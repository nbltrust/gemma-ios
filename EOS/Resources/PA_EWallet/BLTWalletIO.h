//
//  BLTWalletIO.h
//  EOS
//
//  Created by peng zhu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTUtils.h"

typedef enum : NSUInteger {
    pinType = 1,
    fpType = 2,
} AuthType;

@interface BLTWalletIO : NSObject

@property (nonatomic,strong) DidSearchDevice didSearchDevice;

@property (nonatomic,strong) BatteryInfoUpdated batteryInfoUpdated;

@property (nonatomic,strong) BLTBatteryInfo *batteryInfo;

@property (nonatomic,strong) BLTDevice *selectDevice;

@property (nonatomic,assign) BOOL stopEntroll;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic, assign) BOOL abortBtnState;

@property (nonatomic, strong) NSCondition *abortCondition;

@property (nonatomic, copy) void(^abortHandelBlock)(BOOL abortState);

+(instancetype) shareInstance;

#pragma mark Bluetooth Action Request
- (void)startHeartBeat;

- (BOOL)isConnection;

- (NSString *)ret15bitString;

- (void)formmart:(SuccessedComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)disConnect:(SuccessedComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)searchBLTCard:(SuccessedComplication)complication;

- (void)connectCard:(NSString *)deviceNameId success:(SuccessedComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)checkPinState:(CheckPinStateComplication)complication failed:(FailedComplication)failed;

- (void)getDeviceInfo:(GetDeviceInfoComplication)complication;

- (void)initPin:(NSString *)pin success:(SuccessedComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)getSeed:(GetSeedsComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)checkSeed:(NSString *)seed success:(SuccessedComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)getVolidation:(GetVolidationComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)getSN:(GetSNComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)getPubKey:(GetPubKeyComplication)successComlication failed:(FailedComplication)failedCompliction;

- (void)enrollFingerPrinter:(EnrollFingerComplication)stateComplication success:(SuccessedComplication)success failed:(FailedComplication)failed timeout:(TimeoutComplication)timeout;

- (void)cancelEntrollFingerPrinter:(SuccessedComplication)successComplication failed:(FailedComplication)failedComplication;

- (void)submmitWaitingVerfyPin:(NSString *)waitVerPin;

- (void)getEOSSign:(AuthType)type chainId:(NSString *)chainId transaction:(NSString *)transaction success:(GetSignComplication)complication failed:(FailedComplication)failedComplication;

- (void)getFPList:(GetFPListComplication)complication failed:(FailedComplication)failedComplication;

- (void)deleteFP:(NSArray *)fpList success:(SuccessedComplication)successComlication failed:(FailedComplication)failedComplication;

- (void)verifyPin:(NSString *)pin success:(SuccessedComplication)successComlication failed:(FailedComplication)failedComplication;

- (void)updatePin:(NSString *)newPin success:(SuccessedComplication)successComlication failed:(FailedComplication)failedComplication;
@end
