//
//  BLTBatteryInfo.h
//  EOS
//
//  Created by peng zhu on 2018/10/17.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BatteryStateCharge = 0,
    BatteryStateCommon = 1,
} BatteryState;

@interface BLTBatteryInfo : NSObject

@property (nonatomic,assign) BatteryState state;
@property (nonatomic,assign) int electricQuantity;

@end

