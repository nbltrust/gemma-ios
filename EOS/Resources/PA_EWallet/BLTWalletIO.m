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

const uint32_t puiDerivePathETH[] = {0, 0x8000002c, 0x8000003c, 0x80000000, 0x00000000, 0x00000000};
const uint32_t puiDerivePathEOS[] = {0, 0x8000002C, 0x800000c2, 0x80000000, 0x00000000, 0x00000000};
const uint32_t puiDerivePathCYB[] = {0, 0, 1, 0x00000080, 0x00000000, 0x00000000};

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

static BLTWalletIO* _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        selfClass = self;
    }
    return self;
}

- (void)formmart {
    if (!savedDevH) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int devIdx = 0;
        void *ppPAEWContext = savedDevH;
        int iRtn = PAEW_RET_UNKNOWN_FAIL;
        
        iRtn = PAEW_Format(ppPAEWContext, devIdx);
        if (iRtn != PAEW_RET_SUCCESS) {
            NSLog(@"PAEW_Format returns failed");
            return ;
        } else {
            NSLog(@"PAEW_Format returns success");
        }
    });
}

- (void)powerOff {
    if (!savedDevH) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int devIdx = 0;
        void *ppPAEWContext = savedDevH;
        int iRtn = PAEW_RET_UNKNOWN_FAIL;
        iRtn = PAEW_PowerOff(ppPAEWContext, devIdx);
        if (iRtn != PAEW_RET_SUCCESS) {
            NSLog(@"PAEW_PowerOff returns failed");
            return ;
        } else {
            NSLog(@"PAEW_PowerOff returns success");
        }
    });
}

- (void)searchBLTCard {
    __block unsigned char nDeviceType = PAEW_DEV_TYPE_BT;
    __block char *szDeviceNames = (char *)malloc(512*16);
    __block size_t nDeviceNameLen = 512*16;
    __block size_t nDevCount = 0;
    __block EnumContext DevContext = {0};
    DevContext.timeout = 5;//scanning may found nothing if timeout is lower than 2 seconds. So the suggested timeout value should be larger than 2
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

- (void)startHeartBeat {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(repatGetDeviceInfo) userInfo:nil repeats:true];
    }
    [_timer fire];
}

- (void)repatGetDeviceInfo {
    [self getDeviceInfo:^(BOOL successed, PAEW_DevInfo *info) { }];
}

- (void)connectCard:(NSString *)deviceNameId complication:(ConnectComplication)complication {
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

- (void)getDeviceInfo:(GetDeviceInfoComplication)complication {
    if (!savedDevH) {
        return;
    }
    __block  size_t            i = 0;
    __block PAEW_DevInfo    devInfo;
    
    __block uint32_t        nDevInfoType = 0;
    
    nDevInfoType = PAEW_DEV_INFOTYPE_COS_TYPE | PAEW_DEV_INFOTYPE_COS_VERSION | PAEW_DEV_INFOTYPE_SN | PAEW_DEV_INFOTYPE_CHAIN_TYPE | PAEW_DEV_INFOTYPE_PIN_STATE | PAEW_DEV_INFOTYPE_LIFECYCLE;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        void *ppPAEWContext = savedDevH;
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

- (void)initPin:(NSString *)pin success:(SuccessedComplication)successComlication failed:(FailedComplication)failedCompliction {
    if (!savedDevH) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int devIdx = 0;
        void *ppPAEWContext = savedDevH;
        int initState = PAEW_InitPIN(ppPAEWContext, devIdx, [pin UTF8String]);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (initState == PAEW_RET_SUCCESS) {
                successComlication();
            } else {
                failedCompliction([BLTUtils errorCodeToString:initState]);
            }
        });
    });
}

- (void)getSeed:(GetSeedsComplication)successComlication failed:(FailedComplication)failedCompliction {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int devIdx = 0;
        void *ppPAEWContext = savedDevH;
        int iRtn = PAEW_RET_UNKNOWN_FAIL;
        unsigned char nSeedLen = 16;
        unsigned char pbMneWord[PAEW_MNE_MAX_LEN] = {0};
        size_t pnMneWordLen = sizeof(pbMneWord);
        size_t  pnCheckIndex[PAEW_MNE_INDEX_MAX_COUNT] = { 0 };
        size_t pnCheckIndexCount = PAEW_MNE_INDEX_MAX_COUNT;
        iRtn = PAEW_GenerateSeed_GetMnes(ppPAEWContext, devIdx, nSeedLen, pbMneWord, &pnMneWordLen, pnCheckIndex, &pnCheckIndexCount);
        if (iRtn == PAEW_RET_SUCCESS) {
            NSString *temp = [NSString stringWithFormat:@"%s",pbMneWord];
            NSArray *seeds = [temp componentsSeparatedByString:@" "];
            NSMutableArray *tempCheck = [NSMutableArray new];
            for (int i = 0; i < pnCheckIndexCount; i++) {
                [tempCheck addObject:seeds[pnCheckIndex[i]]];
            }
            successComlication(seeds, [tempCheck componentsJoinedByString:@" "]);
        } else {
            failedCompliction([BLTUtils errorCodeToString:iRtn]);
        }
    });
}

- (void)checkSeed:(NSString *)seed success:(SuccessedComplication)successComlication failed:(FailedComplication)failedCompliction {
    if (seed.length == 0) {
        return;
    }
    seed = [seed stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int devIdx = 0;
        void *ppPAEWContext = savedDevH;
        int iRtn = PAEW_GenerateSeed_CheckMnes(ppPAEWContext, devIdx, (unsigned char *)[seed UTF8String], seed.length);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (iRtn == PAEW_RET_SUCCESS) {
                successComlication();
            } else {
                failedCompliction([BLTUtils errorCodeToString:iRtn]);
            }
        });
    });
}

- (void)getVolidation:(GetVolidationComplication)successComlication failed:(FailedComplication)failedCompliction {
    if (!savedDevH) {
        return;
    }
    __block BOOL success_sn = false;
    __block BOOL success_pub = false;
    __block NSString *sn = @"";
    __block NSString *sn_sig = @"";
    __block NSString *pub = @"";
    __block NSString *pub_sig = @"";
    __block NSString *failedReason = @"";
    
    dispatch_queue_t disqueue =  dispatch_queue_create("com.shidaiyinuo.NetWorkStudy", DISPATCH_QUEUE_SERIAL);
    dispatch_group_t disgroup = dispatch_group_create();

    dispatch_group_async(disgroup, disqueue, ^{
        int devIdx = 0;
        void *ppPAEWContext = savedDevH;
        int iRtn = PAEW_RET_UNKNOWN_FAIL;
        unsigned char *pbCheckCode = NULL;
        size_t nAddressLen = 1024;
        
        iRtn = PAEW_GetDeviceCheckCode(ppPAEWContext, devIdx, pbCheckCode, &nAddressLen);
        if (iRtn == PAEW_RET_SUCCESS) {
            pbCheckCode = (unsigned char *)malloc(nAddressLen);
            memset(pbCheckCode, 0, nAddressLen);
            iRtn = PAEW_GetDeviceCheckCode(ppPAEWContext, 0, pbCheckCode, &nAddressLen);
            if (iRtn != PAEW_RET_SUCCESS) {
                failedReason = [BLTUtils errorCodeToString:iRtn];
            } else {
                NSString *temp = [BLTUtils bytesToHexString:pbCheckCode length:nAddressLen];
                sn = [temp substringToIndex:32];
                sn_sig = [temp substringFromIndex:32];
                success_sn = true;
            }
            if (pbCheckCode) {
                free(pbCheckCode);
            }
        } else {
            failedReason = [BLTUtils errorCodeToString:iRtn];
        }
    });
    dispatch_group_async(disgroup, disqueue, ^{
        int devIdx = 0;
        void *ppPAEWContext = savedDevH;
        int iRtn = PAEW_RET_UNKNOWN_FAIL;
        unsigned char bAddress[1024] = {0};
        size_t nAddressLen = 1024;
        
        iRtn = PAEW_DeriveTradeAddress(ppPAEWContext, devIdx, PAEW_COIN_TYPE_EOS, puiDerivePathEOS, sizeof(puiDerivePathEOS)/sizeof(puiDerivePathEOS[0]));
        if (iRtn != PAEW_RET_SUCCESS) {
            failedReason = [BLTUtils errorCodeToString:iRtn];
        } else {
            iRtn = PAEW_GetTradeAddress(ppPAEWContext, devIdx, PAEW_COIN_TYPE_EOS, bAddress, &nAddressLen);
            if (iRtn != PAEW_RET_SUCCESS) {
                failedReason = [BLTUtils errorCodeToString:iRtn];
            } else {
                size_t addressLen = strlen(bAddress);
                pub_sig = [BLTUtils bytesToHexString:[NSData dataWithBytes:bAddress + addressLen + 1 length:nAddressLen - addressLen - 1] ];
                pub = [BLTUtils bytesToHexString:bAddress length:addressLen];
                success_pub = true;
            }
        }
    });
    dispatch_group_notify(disgroup, disqueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success_pub && success_sn) {
                successComlication(sn,sn_sig,pub,pub_sig);
            } else {
                failedCompliction(failedReason);
            }
        });
    });
}

- (void)getSN:(GetSNComplication)successComlication failed:(FailedComplication)failedCompliction {
    if (!savedDevH) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int devIdx = 0;
        void *ppPAEWContext = savedDevH;
        int iRtn = PAEW_RET_UNKNOWN_FAIL;
        unsigned char *pbCheckCode = NULL;
        size_t nAddressLen = 1024;
        
        iRtn = PAEW_GetDeviceCheckCode(ppPAEWContext, devIdx, pbCheckCode, &nAddressLen);
        if (iRtn == PAEW_RET_SUCCESS) {
            pbCheckCode = (unsigned char *)malloc(nAddressLen);
            memset(pbCheckCode, 0, nAddressLen);
            iRtn = PAEW_GetDeviceCheckCode(ppPAEWContext, 0, pbCheckCode, &nAddressLen);
            if (iRtn != PAEW_RET_SUCCESS) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failedCompliction([BLTUtils errorCodeToString:iRtn]);
                });
            } else {
                NSString *temp = [BLTUtils bytesToHexString:pbCheckCode length:nAddressLen];
                NSString *sn = [temp substringToIndex:31];
                NSString *sn_sig = [temp substringFromIndex:32];
                dispatch_async(dispatch_get_main_queue(), ^{
                    successComlication(sn, sn_sig);
                });
            }
            if (pbCheckCode) {
                free(pbCheckCode);
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failedCompliction([BLTUtils errorCodeToString:iRtn]);
            });
        }
    });
}

- (void)getPubKey:(GetPubKeyComplication)successComlication failed:(FailedComplication)failedCompliction {
    if (!savedDevH) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int devIdx = 0;
        void *ppPAEWContext = savedDevH;
        int iRtn = PAEW_RET_UNKNOWN_FAIL;
        unsigned char bAddress[1024] = {0};
        size_t nAddressLen = 1024;
        
        iRtn = PAEW_DeriveTradeAddress(ppPAEWContext, devIdx, PAEW_COIN_TYPE_EOS, puiDerivePathEOS, sizeof(puiDerivePathEOS)/sizeof(puiDerivePathEOS[0]));
        if (iRtn != PAEW_RET_SUCCESS) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failedCompliction([BLTUtils errorCodeToString:iRtn]);
            });
        } else {
            iRtn = PAEW_GetTradeAddress(ppPAEWContext, devIdx, PAEW_COIN_TYPE_EOS, bAddress, &nAddressLen);
            if (iRtn != PAEW_RET_SUCCESS) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failedCompliction([BLTUtils errorCodeToString:iRtn]);
                });
            } else {
                size_t addressLen = strlen(bAddress);
                NSString *signature = [BLTUtils bytesToHexString:[NSData dataWithBytes:bAddress + addressLen + 1 length:nAddressLen - addressLen - 1] ];
                NSString *pubKey = [NSString stringWithUTF8String:(char *)bAddress];
                dispatch_async(dispatch_get_main_queue(), ^{
                    successComlication(pubKey,signature);
                });
            }
        }
    });
}

@end

@implementation BLTDevice

@end
