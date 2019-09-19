#!/bin/bash
readonly DOC_ROOT=$(cd $(dirname ${BASH_SOURCE:-$0})/.. ; pwd)
readonly ADAPTER_ROOT="$DOC_ROOT/objc/mopub.ObjectiveC/mopub.ObjectiveC/MaioMoPubAdapter"

# echo $DOC_ROOT 1>&2
# echo $ADAPTER_ROOT 1>&2

show_help() {
    echo "Usage: ${BASH_SOURCE:-$0} [-d dir] <commit>..." 1>&2
}

destination=$(pwd)

while getopts d:h OPT
do
    case "$OPT" in
        d)
            destination=$OPTARG
            ;;
        h)
            show_help
            exit 0
            ;;
        \?)
            show_help
            ;;
    esac
done

# echo $destination 1>&2
