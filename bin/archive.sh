#!/bin/bash
readonly DOC_ROOT=$(cd $(dirname ${BASH_SOURCE:-$0})/.. ; pwd)
readonly ADAPTER_NAME='MaioMoPubAdapter'
readonly ADAPTER_PATH="objc/mopub.ObjectiveC/mopub.ObjectiveC/$ADAPTER_NAME"

# echo $DOC_ROOT 1>&2
# echo $ADAPTER_PATH 1>&2

show_help() {
    echo "Usage: ${BASH_SOURCE:-$0} [-hq] [-d dir]  <commit>..." 1>&2
    echo "    -d  Output directory" 1>&2
    echo "    -h  Print this help" 1>&2
    echo "    -v  Be verbose" 1>&2
}

destination=$(pwd)
flag_quiet='-q'

while getopts d:vh OPT
do
    case "$OPT" in
        d)
            destination=$OPTARG
            ;;
        h)
            show_help
            exit 0
            ;;
        v)
            flag_quiet=''
            ;;
        \?)
            show_help
            ;;
    esac
done

# echo $destination 1>&2

# drop argument of option
shift $(($OPTIND - 1))

# safety
if [ $# -eq 0 ]; then
    echo "argument not found." 1>&2
    show_help
    exit 1
fi

tempDir=$(mktemp -d -t 'archive-mopub-adapter')
git clone -l $flag_quiet $DOC_ROOT $tempDir

for commit in "$@"; do
    cd $tempDir;
    git checkout $flag_quiet $commit
    cd $tempDir/$ADAPTER_PATH/..
    zip $flag_quiet -r $destination/"${ADAPTER_NAME}_${commit}.zip" ./${ADAPTER_NAME}
done

# cleanup
rm -rf $tempDir
