//
//  BLTUtils.h
//  TestCompileDemo
//
//  Created by 周权威 on 2018/8/22.
//  Copyright © 2018年 extropies. All rights reserved.
//

#import <Foundation/Foundation.h>

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

+ (NSString *)errorCodeToString:(int)retValue;
+ (NSString *)bytesToHexString:(NSData *)data;
+ (NSString *)bytesToHexString:(void *)data length:(size_t)length;
+ (NSData *)hexStringToBytes:(NSString *)hexString;
+ (FingerPrinterState)stateWithValue:(int)value;

@end
