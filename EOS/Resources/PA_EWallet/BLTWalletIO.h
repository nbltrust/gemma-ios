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
#import "BLTUtils.h"

@class BLTDevice;

@interface BLTWalletIO : NSObject

//Complication
typedef void(^ DidSearchDevice)(BLTDevice *wallet);

typedef void(^ SuccessedComplication)();

typedef void(^ FailedComplication)(NSString *failedReason);

typedef void(^ ConnectComplication)(BOOL isConnected,NSInteger savedDevice);

typedef void(^ GetDeviceInfoComplication)(BOOL successed,PAEW_DevInfo *info);

typedef void(^ GetSeedsComplication)(NSArray *seeds, NSString *checkStr);

typedef void(^ GetSNComplication)(NSString *SN,NSString *SN_sig);

typedef void(^ GetPubKeyComplication)(NSString *pubkey,NSString *pubkey_sig);

@property (nonatomic,strong) DidSearchDevice didSearchDevice;

@property (nonatomic,strong) NSTimer *timer;

+(instancetype) shareInstance ;

- (void)formmart;

- (void)powerOff;

- (void)searchBLTCard;

- (void)startHeartBeat;

- (void)connectCard:(NSString *)deviceNameId complication:(ConnectComplication)complication;

- (void)getDeviceInfo:(GetDeviceInfoComplication)complication;

- (void)initPin:(NSString *)pin success:(SuccessedComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)getSeed:(GetSeedsComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)checkSeed:(NSString *)seed success:(SuccessedComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)getSN:(GetSNComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)getPubKey:(GetPubKeyComplication)successComlication failed:(FailedComplication)failedCompliction;

@end

@interface BLTDevice : NSObject

@property (nonatomic,strong) NSString *name;

@property (nonatomic,assign) int RSSI;

@property (nonatomic,assign) int state;

@end
