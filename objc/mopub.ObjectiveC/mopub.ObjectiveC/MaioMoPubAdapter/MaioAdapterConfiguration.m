//
//  MaioAdapterConfiguration.m
//  mopub.ObjectiveC
//
//  Created by Kasamatsu on 2019/04/17.
//  Copyright © 2019 maio. All rights reserved.
//

#import "MaioAdapterConfiguration.h"
#import <Maio/Maio.h>

static NSString* const kMaioAdapterVersion = @"1.5.3.1";

@implementation MaioAdapterConfiguration

- (NSString *)adapterVersion {
    return kMaioAdapterVersion;
}

- (NSString *)biddingToken {
    return nil;
}

-(NSString *)moPubNetworkName {
    return @"maio";
}

-(NSString *)networkSdkVersion {
    return [Maio sdkVersion];
}

- (void)initializeNetworkWithConfiguration:(NSDictionary<NSString *,id> *)configuration complete:(void (^)(NSError * _Nullable))complete {
    if (complete) {
        complete(nil);
    }
}

@end
