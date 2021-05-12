//
//  MaioAdapterConfiguration.h
//  mopub.ObjectiveC
//
//  Created by Kasamatsu on 2019/04/17.
//  Copyright © 2019 maio. All rights reserved.
//

#if __has_include(<MoPubSDK/MoPub.h>)
    #import <MoPubSDK/MoPub.h>
#elif __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#else
    #import "MPBaseAdapterConfiguration.h"
#endif

@interface MaioAdapterConfiguration : MPBaseAdapterConfiguration

@property (nonatomic, copy, readonly) NSString * adapterVersion;
@property (nonatomic, copy, readonly) NSString * biddingToken;
@property (nonatomic, copy, readonly) NSString * moPubNetworkName;
@property (nonatomic, copy, readonly) NSString * networkSdkVersion;

@end
