//
//  MaioRewardedVideo.h
//  mopub.ObjectiveC
//
//  Copyright © 2018年 maio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Maio/Maio.h>
#if __has_include(<MoPubSDK/MoPub.h>)
    #import <MoPubSDK/MoPub.h>
#elif __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#else
    #import "MPFullscreenAdAdapter.h"
#endif

@interface MaioRewardedVideo : MPFullscreenAdAdapter <MPThirdPartyFullscreenAdAdapter, MaioDelegate>

@end
