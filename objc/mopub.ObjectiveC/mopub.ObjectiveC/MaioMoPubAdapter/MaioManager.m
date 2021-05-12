//
//  MaioManager.m
//  mopub.ObjectiveC
//
//  Copyright © 2018年 maio. All rights reserved.
//

#import "MaioManager.h"
#import <Maio/Maio.h>
#import "MaioError.h"
#import "MaioCredentials.h"
#import "MaioAdStockOutRegister.h"
#if __has_include(<MoPubSDK/MoPub.h>)
    #import <MoPubSDK/MoPub.h>
#elif __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#else
    #import "MoPub.h"
#endif

@interface MaioGeneralDelegate : NSObject <MaioDelegate>
@end

@implementation MaioGeneralDelegate {
    NSHashTable<id <MaioDelegate>> *_delegates;
}
- initWithDelegate:(id <MaioDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegates = [NSHashTable weakObjectsHashTable];
        [_delegates addObject:delegate];
    }
    return self;
}

- (void)addDelegate:(id <MaioDelegate>)delegate {
    [_delegates addObject:delegate];
}

- (BOOL)containsDelegate:(id <MaioDelegate>)delegate {
    return [_delegates containsObject:delegate];
}

- (void)maioDidInitialize {
    for (id <MaioDelegate> delegate in _delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(maioDidInitialize)]) {
            [delegate maioDidInitialize];
        }
    }
}

- (void)maioDidClickAd:(NSString *)zoneId {
    for (id <MaioDelegate> delegate in _delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(maioDidClickAd:)]) {
            [delegate maioDidClickAd:zoneId];
        }
    }
}

- (void)maioDidCloseAd:(NSString *)zoneId {
    for (id <MaioDelegate> delegate in _delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(maioDidCloseAd:)]) {
            [delegate maioDidCloseAd:zoneId];
        }
    }
}

- (void)maioWillStartAd:(NSString *)zoneId {
    for (id <MaioDelegate> delegate in _delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(maioWillStartAd:)]) {
            [delegate maioWillStartAd:zoneId];
        }
    }
}

- (void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason {
    for (id <MaioDelegate> delegate in _delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(maioDidFail:reason:)]) {
            [delegate maioDidFail:zoneId reason:reason];
        }
    }
}

- (void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue {
    for (id <MaioDelegate> delegate in _delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(maioDidChangeCanShow:newValue:)]) {
            [delegate maioDidChangeCanShow:zoneId newValue:newValue];
        }
    }
}

- (void)maioDidFinishAd:(NSString *)zoneId playtime:(NSInteger)playtime skipped:(BOOL)skipped rewardParam:(NSString *)rewardParam {
    for (id <MaioDelegate> delegate in _delegates.allObjects) {
        if ([delegate respondsToSelector:@selector(maioDidFinishAd:playtime:skipped:rewardParam:)]) {
            [delegate maioDidFinishAd:zoneId playtime:playtime skipped:skipped rewardParam:rewardParam];
        }
    }
}

@end

@interface MaioManager ()
@property (nonatomic) MaioAdStockOutRegister *adStockOutRegister;
@end

@implementation MaioManager {
    NSMutableDictionary<NSString *, MaioInstance *> *_references;
    NSMutableDictionary<NSString *, MaioGeneralDelegate *> *_generalDelegateReferences;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _references = [NSMutableDictionary dictionary];
        _generalDelegateReferences = [NSMutableDictionary dictionary];
        _adStockOutRegister = [MaioAdStockOutRegister new];
    }
    return self;
}

+ (MaioManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static MaioManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[MaioManager alloc] init];
    });

    return manager;
}

+ (BOOL)canRequestWithCustomEventInfo:(NSDictionary*)info error:(NSError**)errorPointer {

    // If GDPR is required do not initialize SDK
    if ([MoPub sharedInstance].isGDPRApplicable == MPBoolYes) {
        if (errorPointer) {
            *errorPointer = [MaioError gdpr];
        }
        return NO;
    }

    MaioCredentials *credentials = [MaioCredentials credentialsFromDictionary:info];
    if (!credentials) {
        if (errorPointer) {
            *errorPointer = [MaioError credentials];
        }
        return NO;
    }

    return YES;
}

- (void)startWithMediaId:(NSString *)mediaId delegate:(id <MaioDelegate>)delegate {
    if (_references[mediaId]) {
        MaioGeneralDelegate *generalDelegate = _generalDelegateReferences[mediaId];
        [generalDelegate addDelegate:delegate];
        return;
    }

    MaioGeneralDelegate *generalDelegate = [[MaioGeneralDelegate alloc] initWithDelegate:delegate];
    [generalDelegate addDelegate:self.adStockOutRegister];
    _generalDelegateReferences[mediaId] = generalDelegate;
    MaioInstance *maioInstance = [Maio startWithNonDefaultMediaId:mediaId delegate:generalDelegate];
    _references[mediaId] = maioInstance;
}

- (BOOL)isInitialized:(NSString *)mediaId {
    return _references[mediaId] != nil;
}

- (BOOL)isAdStockOut:(NSString *)zoneId {
    return [self.adStockOutRegister hasRecordThatZoneId:zoneId];
}

- (void)addDelegate:(id <MaioDelegate>)delegate forMediaId:(NSString *)mediaId {
    if (!_references[mediaId]) {
        return;
    }

    MaioGeneralDelegate *generalDelegate = _generalDelegateReferences[mediaId];
    [generalDelegate addDelegate:delegate];
}

- (BOOL)hasDelegate:(id <MaioDelegate>)delegate forMediaId:(NSString *)mediaId {
    if (!_references[mediaId]) {
        return NO;
    }

    MaioGeneralDelegate *generalDelegate = _generalDelegateReferences[mediaId];
    return [generalDelegate containsDelegate:delegate];
}

- (BOOL)canShowAtMediaId:(NSString *)mediaId zoneId:(NSString *)zoneId {
    if (!_references[mediaId]) {
        return NO;
    }

    MaioInstance *instance = _references[mediaId];
    return [instance canShowAtZoneId:zoneId];
}

- (void)showAtMediaId:(NSString *)mediaId zoneId:(NSString *)zoneId viewController: (UIViewController*) viewController {
    if (!_references[mediaId]) {
        return;
    }

    MaioInstance *instance = _references[mediaId];
    [instance showAtZoneId:zoneId vc: viewController];
}

@end
