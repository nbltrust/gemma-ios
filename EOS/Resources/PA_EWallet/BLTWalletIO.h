//
//  BLTWalletIO.h
//  EOS
//
//  Created by peng zhu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PA_EWallet.h"
#import "BLTWalletHeader.h"

@class BLTDevice;

@interface BLTWalletIO : NSObject

//Complication
typedef void(^ DidSearchDevice)(BLTDevice *wallet);

typedef void(^ connectComplication)(BOOL isConnected,NSInteger savedDevice);

typedef void(^ getDeviceInfoComplication)(BOOL successed,PAEW_DevInfo *info);

@property (nonatomic,strong) DidSearchDevice didSearchDevice;

- (void)searchBLTCard;

+ (void)connectCard:(NSString *)deviceNameId complication:(connectComplication)complication;

+ (void)getDeviceInfo:(NSInteger)savedDevice complication:(getDeviceInfoComplication)complication;
//+ (void)
@end

@interface BLTDevice : NSObject

@property (nonatomic,strong) NSString *name;

@property (nonatomic,assign) int RSSI;

@property (nonatomic,assign) int state;

@end
