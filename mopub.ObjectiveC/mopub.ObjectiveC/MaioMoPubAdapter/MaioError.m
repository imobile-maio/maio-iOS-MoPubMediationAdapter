//
//  MaioError.m
//  mopub.ObjectiveC
//
//  Copyright © 2018年 maio. All rights reserved.
//

#import <Maio/Maio.h>
#import "MaioError.h"

@implementation MaioError

+(NSError *) credentials {
    return [self errorWithReason:@"Something is not right with your credentials."];
}

+(NSError *) loadFailed {
    return [self errorWithReason:@"Maio load failed."];
}

+(NSError *) loadFailedWithReason: (MaioFailReason) reason {
    return [self errorWithReason:[NSString stringWithFormat:@"Maio load failed with reason: %ld", (long)reason]];
}

+(NSError *)gdpr {
    return [self errorWithReason:@"If GDPR is required do not initialize maio SDK"];
}

+(NSError *) errorWithReason:(NSString *)reason {
    return [NSError errorWithDomain:@"jp.maio"
                               code:0
                           userInfo:@{@"Error reason": reason}];
}

@end
