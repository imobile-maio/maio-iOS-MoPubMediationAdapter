//
//  MaioRewardedVideo.m
//  mopub.ObjectiveC
//
//  Copyright © 2018年 maio. All rights reserved.
//

#import "MaioRewardedVideo.h"
#import "MaioCredentials.h"
#import "MaioManager.h"
#import "MaioError.h"
#import "MPRewardedVideoReward.h"
#import "MPLogging.h"
#import "MoPub.h"

@implementation MaioRewardedVideo {
    MaioCredentials *_credentials;
    BOOL _isAdRequested;
}

- (void)initializeSdkWithParameters:(NSDictionary *)parameters {
    _credentials = [MaioCredentials credentialsFromDictionary:parameters];
    [self initializeMaioSdk];
}

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info {
    NSError* loadError = nil;
    if (![self canRequestWithCustomEventInfo:info error:&loadError]) {
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:loadError];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:loadError], nil);
        return;
    }

    MaioManager *manager = [MaioManager sharedInstance];
    MaioCredentials *credentials = [MaioCredentials credentialsFromDictionary:info];
    _credentials = credentials;
    MPLogAdEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil], _credentials.zoneId);

    if (![manager isInitialized:credentials.mediaId]) {
        _isAdRequested = YES;
        [self initializeMaioSdk];
        return;
    }

    if (![manager hasDelegate:self forMediaId:_credentials.mediaId]) {
        [manager addDelegate:self forMediaId:_credentials.mediaId];
    }

    if ([manager canShowAtMediaId:credentials.mediaId zoneId:credentials.zoneId]) {
        [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
        MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    } else {
        _isAdRequested = YES;
    }
}

- (void)initializeMaioSdk {
    if (!_credentials) {
        MPLogError(@"MaioRewardedVideo: invalid parameters");
        return;
    }

    MaioManager *manager = [MaioManager sharedInstance];
    [manager startWithMediaId:_credentials.mediaId delegate:self];
}

- (BOOL)hasAdAvailable {
    return [[MaioManager sharedInstance] canShowAtMediaId:_credentials.mediaId zoneId:_credentials.zoneId];
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController {
    MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    [[MaioManager sharedInstance] showAtMediaId:_credentials.mediaId zoneId:_credentials.zoneId];
}

- (BOOL)canRequestWithCustomEventInfo:(NSDictionary*)info error:(NSError**)errorPointer {
    return [MaioManager canRequestWithCustomEventInfo:info error:errorPointer];
}

#pragma mark - MaioDelegate

- (void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    if (!_isAdRequested) {
        return;
    }
    _isAdRequested = NO;

    if (newValue) {
        [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
        MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    }
}

- (void)maioDidClickAd:(NSString *)zoneId {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
    [self.delegate rewardedVideoWillLeaveApplicationForCustomEvent:self];
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    MPLogAdEvent([MPLogEvent adWillLeaveApplicationForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
}

- (void)maioWillStartAd:(NSString *)zoneId {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
    MPLogAdEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    MPLogAdEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
}

- (void)maioDidCloseAd:(NSString *)zoneId {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
    MPLogAdEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    MPLogAdEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
}

- (void)maioDidFinishAd:(NSString *)zoneId playtime:(NSInteger)playtime skipped:(BOOL)skipped rewardParam:(NSString *)rewardParam {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }


    MPRewardedVideoReward *reward = [[MPRewardedVideoReward alloc] initWithCurrencyAmount:@([rewardParam intValue])];
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:reward];
}

- (void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    if (reason == MaioFailReasonVideoPlayback) {
        NSError *playbackError = [MaioError loadFailedWithReason:reason];
        [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self error:playbackError];
        MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:playbackError], _credentials.zoneId);
        return;
    }
    NSError *loadError = [MaioError loadFailedWithReason:reason];
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:loadError];
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:loadError], _credentials.zoneId);
}

@end
