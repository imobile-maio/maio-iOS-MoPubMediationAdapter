//
//  MaioInterstitialImmediateResponseAdapter.h
//  mopub.ObjectiveC
//
//  Created by im-ttmskk on 2020/11/25.
//  Copyright © 2020 maio. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<MoPubSDK/MoPub.h>)
    #import <MoPubSDK/MoPub.h>
#elif __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#else
    #import "MPFullscreenAdAdapter.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/// Immediate response. But fail to load ad when initialize media.
@interface MaioInterstitialImmediateResponseAdapter : MPFullscreenAdAdapter <MPThirdPartyFullscreenAdAdapter>

@end

NS_ASSUME_NONNULL_END
