//
//  BLTBatteryInfo.h
//  EOS
//
//  Created by peng zhu on 2018/10/17.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    charge = 0,
    battery = 1,
} BatteryState;

@interface BLTBatteryInfo : NSObject

@property (nonatomic,assign) BatteryState state;
@property (nonatomic,assign) float electricQuantity;

@end

