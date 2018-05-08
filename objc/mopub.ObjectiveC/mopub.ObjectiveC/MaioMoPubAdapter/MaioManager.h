//
//  MaioManager.h
//  mopub.ObjectiveC
//
//  Copyright © 2018年 maio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Maio/Maio.h>

@interface MaioManager : NSObject <MaioDelegate>
+ (MaioManager *)sharedInstance;

- (void)startWithMediaId:(NSString *)mediaId delegate:(id <MaioDelegate>)delegate;

- (BOOL)isInitialized:(NSString *)mediaId;

- (BOOL)hasDelegate:(id <MaioDelegate>)delegate forMediaId:(NSString *)mediaId;

- (BOOL)canShowAtMediaId:(NSString *)mediaId zoneId:(NSString *)zoneId;

- (void)showAtMediaId:(NSString *)mediaId zoneId:(NSString *)zoneId;

- (void)addDelegate:(id <MaioDelegate>)delegate forMediaId:(NSString *)mediaId;
@end
