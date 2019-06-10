//
//  MaioAdStockOutRegister.h
//  mopub.ObjectiveC
//
//  Created by Kasamatsu on 2019/05/30.
//  Copyright © 2019 maio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Maio/Maio.h>

@interface MaioAdStockOutRegister : NSObject<MaioDelegate>

- (BOOL) hasRecordThatZoneId:(NSString*)zoneId;

@end
