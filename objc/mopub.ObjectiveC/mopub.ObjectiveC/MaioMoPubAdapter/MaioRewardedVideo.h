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

/// Initialized by `MPFullscreenAdAdapter -init`
@property (nonatomic, weak, readonly) id<MPFullscreenAdAdapterDelegate> delegate;

@end
