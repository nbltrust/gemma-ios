//
//  BLTWalletIO.m
//  EOS
//
//  Created by peng zhu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

#import "BLTWalletIO.h"

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
    BLTDevice *device = [[BLTDevice alloc] init];
    device.name = [NSString stringWithUTF8String:szDevName];
    device.RSSI = nRSSI;
    device.state = nState;
//    if (selfClass.didSearchDevice) {
        selfClass.didSearchDevice(device);
//    }
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

- (void)searchBLTCard {
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

+ (void)getDeviceInfo:(NSInteger)savedDevice complication:(getDeviceInfoComplication)complication {
    if (!savedDevice) {
        return;
    }
    __block  size_t            i = 0;
    __block PAEW_DevInfo    devInfo;
    
    __block uint32_t        nDevInfoType = 0;
    
    nDevInfoType = PAEW_DEV_INFOTYPE_COS_TYPE | PAEW_DEV_INFOTYPE_COS_VERSION | PAEW_DEV_INFOTYPE_SN | PAEW_DEV_INFOTYPE_CHAIN_TYPE | PAEW_DEV_INFOTYPE_PIN_STATE | PAEW_DEV_INFOTYPE_LIFECYCLE;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        void *ppPAEWContext = (void*)savedDevice;
        int devInfoState = PAEW_GetDevInfo(ppPAEWContext, i, nDevInfoType, &devInfo);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (devInfoState == PAEW_RET_SUCCESS) {
                for (int i = 0; i < PAEW_DEV_INFO_SN_LEN; i++) {
                    if (devInfo.pbSerialNumber[i] == 0xFF) {
                        devInfo.pbSerialNumber[i] = 0;
                    }
                }
                complication(true,&devInfo);
            } else {
                complication(false,nil);
            }
        });
    });
}

+ (void)initPin:(NSInteger)savedDevice pin:(NSString *)pin complication:(successedComplication)complication {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int devIdx = 0;
        void *ppPAEWContext = (void*)savedDevice;
        int initState = PAEW_InitPIN(ppPAEWContext, devIdx, [pin UTF8String]);
        if (initState == PAEW_RET_SUCCESS) {
            complication(true,@"");
        } else {
            complication(false,[BLTUtils errorCodeToString:initState]);
        }
    });
}

@end

@implementation BLTDevice

@end
