//
//  BLTDevice.h
//  EOS
//
//  Created by peng zhu on 2018/10/17.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLTDevice : NSObject

@property (nonatomic,strong) NSString *name;

@property (nonatomic,assign) int RSSI;

@property (nonatomic,assign) int state;

@end

