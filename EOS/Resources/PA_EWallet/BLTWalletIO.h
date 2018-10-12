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

typedef enum : NSUInteger {
    pinType = 1,
    fpType = 2,
} AuthType;

@class BLTDevice;

@interface BLTWalletIO : NSObject

#pragma mark Complication
typedef void(^ DidSearchDevice)(BLTDevice *wallet);

typedef void(^ EnrollFingerComplication)(FingerPrinterState state);

typedef void(^ SuccessedComplication)(void);

typedef void(^ FailedComplication)(NSString *failedReason);

typedef void(^ GetDeviceInfoComplication)(BOOL successed,PAEW_DevInfo *info);

typedef void(^ GetSeedsComplication)(NSArray *seeds, NSString *checkStr);

typedef void(^ GetVolidationComplication)(NSString *SN,NSString *SN_sig,NSString *pubkey,NSString *pubkey_si,NSString *public_key);

typedef void(^ GetSNComplication)(NSString *SN,NSString *SN_sig);

typedef void(^ GetPubKeyComplication)(NSString *pubkey,NSString *pubkey_sig);

typedef void(^ GetSignComplication)(NSString *sign);


@property (nonatomic,strong) DidSearchDevice didSearchDevice;

@property (nonatomic,strong) BLTDevice *selectDevice;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic, assign) BOOL abortBtnState;

@property (nonatomic, strong) NSCondition *abortCondition;

@property (nonatomic, copy) void(^abortHandelBlock)(BOOL abortState);

+(instancetype) shareInstance;

#pragma mark Request
- (void)formmart;

- (void)powerOff;

- (void)searchBLTCard:(SuccessedComplication)complication;

- (void)startHeartBeat;

- (BOOL)isConnection;

- (void)connectCard:(NSString *)deviceNameId success:(SuccessedComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)getDeviceInfo:(GetDeviceInfoComplication)complication;

- (void)initPin:(NSString *)pin success:(SuccessedComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)getSeed:(GetSeedsComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)checkSeed:(NSString *)seed success:(SuccessedComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)getVolidation:(GetVolidationComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)getSN:(GetSNComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)getPubKey:(GetPubKeyComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)enrollFingerPrinter:(EnrollFingerComplication)stateComplication success:(SuccessedComplication)success failed:(FailedComplication)failed;

/*When type == PinType
 Need To implication Method “submmitWaitingVerfyPin”
 */
- (void)getEOSSign:(AuthType)type chainId:(NSString *)chainId transaction:(NSString *)transaction success:(GetSignComplication)complication failed:(FailedComplication)failedComplication;

- (void)submmitWaitingVerfyPin:(NSString *)waitVerPin;


@end

@interface BLTDevice : NSObject

@property (nonatomic,strong) NSString *name;

@property (nonatomic,assign) int RSSI;

@property (nonatomic,assign) int state;

@end
