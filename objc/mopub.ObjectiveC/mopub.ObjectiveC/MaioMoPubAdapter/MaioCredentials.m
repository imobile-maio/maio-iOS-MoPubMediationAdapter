//
//  MaioCredentials.m
//  mopub.ObjectiveC
//
//  Copyright © 2018年 maio. All rights reserved.
//

#import "MaioCredentials.h"
#if __has_include(<MoPubSDK/MoPub.h>)
    #import <MoPubSDK/MoPub.h>
#elif __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#else
    #import "MoPub.h"
#endif

@implementation MaioCredentials {
    NSString *_mediaId;
    NSString *_zoneId;
}
- (NSString *)mediaId {
    return _mediaId;
}

- (NSString *)zoneId {
    return _zoneId;
}

static NSString *const kMaioMediaId = @"mediaId";
static NSString *const kMaioZoneId = @"zoneId";

+ (instancetype)credentialsFromDictionary:(NSDictionary *)dictionary {

    // mediaId validations
    NSString *mediaId = dictionary[kMaioMediaId];
    if (!mediaId) {
        MPLogError(@"MaioInterstitial: Invalid mediaId: %@", mediaId);
        return nil;
    }

    // zoneId validations
    NSString *zoneId = dictionary[kMaioZoneId];

    return [[MaioCredentials alloc] initWithMediaId:mediaId zoneId:zoneId];
}

- (instancetype)initWithMediaId:(NSString *)mediaId zoneId:(NSString *)zoneId {
    self = [super init];
    if (self) {
        _mediaId = mediaId;
        _zoneId = zoneId;
    }
    return self;
}

@end
