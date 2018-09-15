//
//  BLTWalletIO.m
//  EOS
//
//  Created by peng zhu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

#import "BLTWalletIO.h"
#import "PA_EWallet.h"
#import "BLTWalletHeader.h"

@implementation BLTWalletIO

void *savedDevH;

static BLTWalletIO *selfClass = nil;

int BatteryCallback(const int nBatterySource, const int nBatteryState)
{
    NSLog(@"current battery source is: %d, current battery state is: 0x%X", nBatterySource, nBatteryState);
    return PAEW_RET_SUCCESS;
}

int EnumCallback(const char *szDevName, int nRSSI, int nState)
{
    BLTWallet *wallet = [[BLTWallet alloc] init];
    wallet.name = [NSString stringWithUTF8String:szDevName];
    wallet.RSSI = nRSSI;
    wallet.state = nState;
    if (selfClass.didSearchDevice) {
        selfClass.didSearchDevice(wallet);
    }
    return PAEW_RET_SUCCESS;
}

int DisconnectedCallback(const int status, const char *description)
{
    NSLog(@"device has disconnected already, status code is: %d, detail is: %s", status, description);
    return PAEW_RET_SUCCESS;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        selfClass = self;
    }
    return self;
}


+ (void)searchBLTCard {
    __block unsigned char nDeviceType = PAEW_DEV_TYPE_BT;
    __block char *szDeviceNames = (char *)malloc(512*16);
    __block size_t nDeviceNameLen = 512*16;
    __block size_t nDevCount = 0;
    __block EnumContext DevContext = {0};
    DevContext.timeout = 10;//scanning may found nothing if timeout is lower than 2 seconds. So the suggested timeout value should be larger than 2
    //typedef int(*tFunc_EnumCallback)(const char *szDevName, int nRSSI, int nState)
//    tFunc_EnumCallback *callback;
    DevContext.enumCallBack = EnumCallback;
    NSString *devName = @"WOOKONG BIO";
    strcpy(DevContext.searchName, [[devName stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet] UTF8String]);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int devInfoState = PAEW_GetDeviceListWithDevContext(nDeviceType, szDeviceNames, &nDeviceNameLen, &nDevCount, &DevContext, sizeof(DevContext));
        dispatch_async(dispatch_get_main_queue(), ^{
            free(szDeviceNames);
        });
        NSLog(@"%d", devInfoState);
    });
}

+ (void)connectCard:(NSString *)deviceNameId complication:(connectComplication)complication {
    char *szDeviceName = (char *)[deviceNameId UTF8String];
    __block ConnectContext additional = {0};
    additional.timeout = 5;
    additional.batteryCallBack = BatteryCallback;
    additional.disconnectedCallback = DisconnectedCallback;
    __block void *ppPAEWContext = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int connectDev = PAEW_InitContextWithDevNameAndDevContext(&ppPAEWContext, szDeviceName, PAEW_DEV_TYPE_BT, &additional, sizeof(additional), 0x00, 0x00);
        NSLog(@"-------connect returns: 0x%X", connectDev);
        if (ppPAEWContext) {
            savedDevH = ppPAEWContext;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (connectDev == PAEW_RET_SUCCESS) {
                uint64_t pt = (uint64_t)savedDevH;
                complication(true, pt);
            } else {
                complication(false, 0);
            }
        });

    });
}

@end

@implementation BLTWallet

@end
