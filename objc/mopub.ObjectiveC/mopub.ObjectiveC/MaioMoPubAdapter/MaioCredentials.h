//
//  MaioCredentials.h
//  mopub.ObjectiveC
//
//  Copyright © 2018年 maio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaioCredentials : NSObject

+ (instancetype)credentialsFromDictionary:(NSDictionary *)dictionary;

- (NSString *)mediaId;

- (NSString *)zoneId;
@end
