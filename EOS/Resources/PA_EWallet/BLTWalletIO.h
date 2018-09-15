//
//  BLTWalletIO.h
//  EOS
//
//  Created by peng zhu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLTWallet;

@interface BLTWalletIO : NSObject

//Complication
typedef void(^ DidSearchDevice)(BLTWallet *wallet);

typedef void(^ connectComplication)(BOOL isConnected,NSInteger savedDevice);

@property (nonatomic,weak) DidSearchDevice didSearchDevice;

+ (void)searchBLTCard;

+ (void)connectCard:(NSString *)deviceNameId complication:(connectComplication)complication;

//+ (void)
@end

@interface BLTWallet : NSObject

@property (nonatomic,strong) NSString *name;

@property (nonatomic,assign) int RSSI;

@property (nonatomic,assign) int state;

@end
