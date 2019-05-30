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
    return [self.zoneIds containsObject:zoneId];
}

@end
