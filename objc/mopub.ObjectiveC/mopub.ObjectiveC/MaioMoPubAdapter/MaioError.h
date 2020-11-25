//
//  MaioError.h
//  mopub.ObjectiveC
//
//  Copyright © 2018年 maio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaioError : NSObject
+ (NSError *)credentials;

+ (NSError *)loadFailed;

+ (NSError *)loadFailedWithReason:(MaioFailReason)reason;

+ (NSError *)gdpr;

+ (NSError *)notReadyYet;
@end
