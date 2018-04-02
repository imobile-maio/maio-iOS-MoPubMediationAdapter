//
//  MaioManager.h
//  mopub.ObjectiveC
//
//  Created by 土肥 一郎 on 2018/02/07.
//  Copyright © 2018年 maio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Maio/Maio.h>

@interface MaioManager : NSObject<MaioDelegate>
+(MaioManager *)sharedInstance;
-(void) startWithMediaId:(NSString *)mediaId delegate:(id<MaioDelegate>)delegate;
-(BOOL) isInitialized:(NSString *)mediaId;
-(BOOL) canShowAtMediaId:(NSString *)mediaId zoneId:(NSString *)zoneId;
-(void) showAtMediaId:(NSString *)mediaId zoneId:(NSString *)zoneId;
@end
