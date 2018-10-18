//
//  BLTUtils.h
//  EOS
//
//  Created by peng zhu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//


#import <Foundation/Foundation.h>

//Notification
#define NotificationBatteryChanged @"NotificationBatteryChanged"

#define NotificationDeviceSearched @"NotificationDeviceSearched"

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

@interface BLTUtils : NSObject

//Function
+ (NSString *)errorCodeToString:(int)retValue;

+ (NSString *)bytesToHexString:(NSData *)data;

+ (NSString *)bytesToHexString:(void *)data length:(size_t)length;

+ (NSData *)hexStringToBytes:(NSString *)hexString;

+ (FingerPrinterState)stateWithValue:(int)value;

+ (NSString *)batteryChangedNFName;

+ (NSString *)deviceSearchedNFName;

@end
