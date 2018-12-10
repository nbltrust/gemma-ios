//
//  BLTUtils.h
//  EOS
//
//  Created by peng zhu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <iOS_EWalletDynamic/PA_EWallet.h>
#import "BLTWalletHeader.h"
#import "BLTDevice.h"
#import "BLTBatteryInfo.h"

//Data Struct
typedef NS_ENUM(NSInteger, FingerPrinterState)
{
    common = 0,
    redundant,
    good,
    none,
    notFull,
    badImage
};

typedef NS_ENUM(NSInteger, BLTCardPINState) {
    unInit = 0,
    unFinishInit,
    finishInit
};

//CallBack
typedef void(^ DidSearchDevice)(BLTDevice *device);

typedef void(^ BatteryInfoUpdated)(BLTBatteryInfo *info);

typedef void(^ DeviceUnConnected)(void);

typedef void(^ PowerButtonPressed)(void);

typedef void(^ PowerButtonFailed)(void);

typedef void(^ EnrollFingerComplication)(FingerPrinterState state);

typedef void(^ VerifyFingerComplication)(FingerPrinterState state);

typedef void(^ CheckPinStateComplication)(BLTCardPINState state);

typedef void(^ SuccessedComplication)(void);

typedef void(^ TimeoutComplication)(void);

typedef void(^ FailedComplication)(NSString *failedReason);

typedef void(^ GetDeviceInfoComplication)(BOOL successed,PAEW_DevInfo *info);

typedef void(^ GetSeedsComplication)(NSArray *seeds, NSString *checkStr);

typedef void(^ GetVolidationComplication)(NSString *SN,NSString *SN_sig,NSString *pubkey,NSString *pubkey_si,NSString *public_key);

typedef void(^ GetSNComplication)(NSString *SN,NSString *SN_sig);

typedef void(^ GetPubKeyComplication)(NSString *pubkey,NSString *pubkey_sig);

typedef void(^ GetSignComplication)(NSString *sign);

typedef void(^ GetFPListComplication)(NSArray *fpList);

@interface BLTUtils : NSObject

//Function
+ (NSString *)errorCodeToString:(int)retValue;

+ (NSString *)bytesToHexString:(NSData *)data;

+ (NSString *)bytesToHexString:(void *)data length:(size_t)length;

+ (NSData *)hexStringToBytes:(NSString *)hexString;

+ (FingerPrinterState)fingerEntrolStateWithValue:(int)value;

+ (BLTCardPINState)pinStateWithDevInfo:(PAEW_DevInfo)info;

+ (NSString *)validSeedWithimportSeed:(NSString *)seed;
@end
