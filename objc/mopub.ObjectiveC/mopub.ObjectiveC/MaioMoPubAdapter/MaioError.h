//
//  MaioError.h
//  mopub.ObjectiveC
//
//  Created by 土肥 一郎 on 2018/04/02.
//  Copyright © 2018年 maio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaioError : NSObject
+(NSError *) credentials;
+(NSError *) loadFailed;
+(NSError *) loadFailedWithReason: (MaioFailReason) reason;
@end
