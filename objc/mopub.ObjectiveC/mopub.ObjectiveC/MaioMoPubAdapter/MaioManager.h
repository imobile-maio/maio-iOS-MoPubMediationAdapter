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

+ (BOOL)canRequestWithCustomEventInfo:(NSDictionary*)info error:(NSError**)errorPointer;

- (void)startWithMediaId:(NSString *)mediaId delegate:(id <MaioDelegate>)delegate;

- (BOOL)isInitialized:(NSString *)mediaId;

- (BOOL)isAdStockOut:(NSString *)zoneId;

- (BOOL)hasDelegate:(id <MaioDelegate>)delegate forMediaId:(NSString *)mediaId;

- (BOOL)canShowAtMediaId:(NSString *)mediaId zoneId:(NSString *)zoneId;

- (void)showAtMediaId:(NSString *)mediaId zoneId:(NSString *)zoneId;

- (void)showAtMediaId:(NSString *)mediaId zoneId:(NSString *)zoneId viewController: (UIViewController*) viewController;

- (void)addDelegate:(id <MaioDelegate>)delegate forMediaId:(NSString *)mediaId;
@end
