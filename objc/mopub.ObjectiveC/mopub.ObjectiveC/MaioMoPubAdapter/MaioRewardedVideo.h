//
//  MaioRewardedVideo.h
//  mopub.ObjectiveC
//
//  Copyright © 2018年 maio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Maio/Maio.h>
#import "MPFullscreenAdAdapter.h"

@interface MaioRewardedVideo : MPFullscreenAdAdapter <MPThirdPartyFullscreenAdAdapter, MaioDelegate>

/// Initialized by  `MPFullscreenAdAdapter -setUpWithAdConfiguration:localExtras:`
@property (nonatomic, copy) NSDictionary *localExtras;

@property (nonatomic) BOOL hasAdAvailable;

@end
