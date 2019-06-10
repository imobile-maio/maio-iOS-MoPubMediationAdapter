//
//  MaioAdStockOutRegister.m
//  mopub.ObjectiveC
//
//  Created by Kasamatsu on 2019/05/30.
//  Copyright © 2019 maio. All rights reserved.
//

#import "MaioAdStockOutRegister.h"
@interface MaioAdStockOutRegister()

@property (nonatomic) NSMutableSet<NSString*> *zoneIds;

@end

@implementation MaioAdStockOutRegister

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.zoneIds = [NSMutableSet set];
    }
    return self;
}

- (BOOL)hasRecordThatZoneId:(NSString *)zoneId {
    if (!zoneId) {
        return NO;
    }
    @synchronized (self.zoneIds) {
        return [self.zoneIds containsObject:zoneId];
    }
}

#pragma mark - MaioDelegate

-(void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason {
    if (reason != MaioFailReasonAdStockOut) {
        return;
    }
    @synchronized (self.zoneIds) {
        [self.zoneIds addObject:zoneId];
    }
}

-(void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue {
    if (newValue != YES) {
        return;
    }
    @synchronized (self.zoneIds) {
        if (![self.zoneIds containsObject:zoneId]) {
            return;
        }
        [self.zoneIds removeObject:zoneId];
    }
}

@end
