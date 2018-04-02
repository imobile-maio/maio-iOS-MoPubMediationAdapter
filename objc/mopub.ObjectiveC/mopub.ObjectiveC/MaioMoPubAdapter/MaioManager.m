//
//  MaioManager.m
//  mopub.ObjectiveC
//
//  Created by 土肥 一郎 on 2018/02/07.
//  Copyright © 2018年 maio. All rights reserved.
//

#import "MaioManager.h"
#import <Maio/Maio.h>

@interface MaioGeneralDelegate : NSObject<MaioDelegate>
@end

@implementation MaioGeneralDelegate {
    NSMutableSet<id<MaioDelegate>> *_delegates;
}
-initWithDelegate:(id<MaioDelegate>) delegate {
    self = [super init];
    if(self) {
        _delegates = [NSMutableSet set];
        [_delegates addObject:delegate];
    }
    return self;
}

-(void)addDelegate:(id<MaioDelegate>) delegate {
    [_delegates addObject:delegate];
}

-(void)maioDidInitialize {
    for(id<MaioDelegate> delegate in _delegates) {
        if([delegate respondsToSelector:@selector(maioDidInitialize)]) {
            [delegate maioDidInitialize];
        }
    }
}

-(void)maioDidClickAd:(NSString *)zoneId {
    for(id<MaioDelegate> delegate in _delegates) {
        if([delegate respondsToSelector:@selector(maioDidClickAd:)]) {
            [delegate maioDidClickAd:zoneId];
        }
    }
}

-(void)maioDidCloseAd:(NSString *)zoneId {
    for(id<MaioDelegate> delegate in _delegates) {
        if([delegate respondsToSelector:@selector(maioDidCloseAd:)]) {
            [delegate maioDidCloseAd:zoneId];
        }
    }
}

-(void)maioWillStartAd:(NSString *)zoneId {
    for(id<MaioDelegate> delegate in _delegates) {
        if([delegate respondsToSelector:@selector(maioWillStartAd:)]) {
            [delegate maioWillStartAd:zoneId];
        }
    }
}

-(void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason {
    for(id<MaioDelegate> delegate in _delegates) {
        if([delegate respondsToSelector:@selector(maioDidFail:reason:)]) {
            [delegate maioDidFail:zoneId reason:reason];
        }
    }
}

-(void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue {
    NSLog(@"change can show: %@ -> %d", zoneId, newValue);
    for(id<MaioDelegate> delegate in _delegates) {
        if([delegate respondsToSelector:@selector(maioDidChangeCanShow:newValue:)]) {
            [delegate maioDidChangeCanShow:zoneId newValue:newValue];
        }
    }
}

-(void)maioDidFinishAd:(NSString *)zoneId playtime:(NSInteger)playtime skipped:(BOOL)skipped rewardParam:(NSString *)rewardParam {
    for(id<MaioDelegate> delegate in _delegates) {
        if([delegate respondsToSelector:@selector(maioDidFinishAd:playtime:skipped:rewardParam:)]) {
            [delegate maioDidFinishAd:zoneId playtime:playtime skipped:skipped rewardParam:rewardParam];
        }
    }
}

@end

@implementation MaioManager {
    NSMutableDictionary<NSString *, MaioInstance *> *_references;
    NSMutableArray<MaioGeneralDelegate *> *_generalDelegateReferences;
}

-(instancetype)init{
    self = [super init];
    if(self) {
        _references = [NSMutableDictionary dictionary];
        _generalDelegateReferences = [NSMutableArray array];
    }
    return self;
}

+(MaioManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static MaioManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[MaioManager alloc] init];
    });
    
    return manager;
}

-(void) startWithMediaId:(NSString *)mediaId delegate:(id<MaioDelegate>)delegate {
    if([_references objectForKey:mediaId]) {
        MaioInstance *maioInstance = [_references objectForKey:mediaId];
        MaioGeneralDelegate *generalDelegate = (MaioGeneralDelegate *)[maioInstance delegate];
        [generalDelegate addDelegate:delegate];
        return;
    }
    
    MaioGeneralDelegate *generalDelegate = [[MaioGeneralDelegate alloc] initWithDelegate:delegate];
    [_generalDelegateReferences addObject:generalDelegate];
    MaioInstance *maioInstance = [Maio startWithNonDefaultMediaId:mediaId delegate:generalDelegate];
    [_references setObject:maioInstance forKey:mediaId];
}

-(BOOL) isInitialized:(NSString *)mediaId {
    return !![_references objectForKey:mediaId];
}

-(BOOL) canShowAtMediaId:(NSString *)mediaId zoneId:(NSString *)zoneId {
    if(![_references objectForKey:mediaId]) {
        return NO;
    }
    
    MaioInstance *instance = [_references objectForKey:mediaId];
    return [instance canShowAtZoneId:zoneId];
}

-(void) showAtMediaId:(NSString *)mediaId zoneId:(NSString *)zoneId {
    if(![_references objectForKey:mediaId]) {
        return;
    }
    
    MaioInstance *instance = [_references objectForKey:mediaId];
    [instance showAtZoneId:zoneId];
}

@end
