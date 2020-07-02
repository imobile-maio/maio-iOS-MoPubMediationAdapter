//
//  MaioInterstitial.h
//  mopub.ObjectiveC
//
//  Copyright © 2018年 maio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Maio/Maio.h>
#import "MPFullscreenAdAdapter.h"

@interface MaioInterstitial : MPFullscreenAdAdapter <MPThirdPartyFullscreenAdAdapter, MaioDelegate>

/// Initialized by `MPFullscreenAdAdapter -init`
@property (nonatomic, weak, readonly) id<MPFullscreenAdAdapterDelegate> delegate;

/// Initialized by  `MPFullscreenAdAdapter -setUpWithAdConfiguration:localExtras:`
@property (nonatomic, copy) NSDictionary *localExtras;

@end
