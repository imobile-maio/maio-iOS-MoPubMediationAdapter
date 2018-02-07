//
//  MaioManager.m
//  mopub.ObjectiveC
//
//  Created by 土肥 一郎 on 2018/02/07.
//  Copyright © 2018年 maio. All rights reserved.
//

#import "MaioManager.h"
#import <Maio/Maio.h>

@implementation MaioManager {
    NSMutableArray<NSString *> *_mediaIds;
}

static BOOL IsInitialized;

+(MaioManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static MaioManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[MaioManager alloc] init];
    });
    
    return manager;
}

-(instancetype)init {
    self = [super init];
    if(self) {
        IsInitialized = NO;
    }
    return self;
}

-(BOOL)isInitialized {
    return IsInitialized;
}

-(void)setIsInitialized:(BOOL)isInitialized {
    IsInitialized = isInitialized;
}

@end
