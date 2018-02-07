//
//  MaioCredentials.h
//  mopub.ObjectiveC
//
//  Created by 土肥 一郎 on 2018/02/07.
//  Copyright © 2018年 maio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaioCredentials : NSObject

+(instancetype)credentialsFromDictionary:(NSDictionary *) dictionary;

-(NSString *) mediaId;
-(NSString *) zoneId;
@end
