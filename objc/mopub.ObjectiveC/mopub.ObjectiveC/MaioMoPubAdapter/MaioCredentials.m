//
//  MaioCredentials.m
//  mopub.ObjectiveC
//
//  Created by 土肥 一郎 on 2018/02/07.
//  Copyright © 2018年 maio. All rights reserved.
//

#import "MaioCredentials.h"
#import "MPLogging.h"

@implementation MaioCredentials {
    NSString *_mediaId;
    NSString *_zoneId;
}
- (NSString *)mediaId { return _mediaId; }
- (NSString *)zoneId { return _zoneId; }

static NSString *const kMaioMediaId = @"mediaId";
static NSString *const kMaioZoneId  = @"zoneId";

+ (instancetype)credentialsFromDictionary:(NSDictionary *)dictionary {
    
    // mediaId validations
    NSString *mediaId   = [dictionary objectForKey:kMaioMediaId];
    if(!mediaId) {
        MPLogError(@"MaioInterstitial: Media Id is empty.");
        return nil;
    }
    if(![self isValidMaioId:mediaId]) {
        MPLogError(@"MaioInterstitial: Invalid mediaId: %@", mediaId);
        return nil;
    }
    
    // zoneId validations
    NSString *zoneId    = [dictionary objectForKey:kMaioZoneId];
    if(zoneId && ![self isValidMaioId:zoneId]) {
        MPLogError(@"MaioInterstitial: Invalid zoneId: %@", zoneId);
        return nil;
    }
    
    return [[MaioCredentials alloc] initWithMediaId:mediaId zoneId:zoneId];
}

+(BOOL)isValidMaioId:(NSString *)uuidString {
    if(!uuidString) return NO;
    
    if([uuidString hasPrefix:@"Demo"]) return YES;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
    return !!uuid;
}

-(instancetype)initWithMediaId:(NSString *)mediaId zoneId:(NSString *)zoneId {
    self = [super init];
    if(self) {
        _mediaId = mediaId;
        _zoneId = zoneId;
    }
    return self;
}

@end
