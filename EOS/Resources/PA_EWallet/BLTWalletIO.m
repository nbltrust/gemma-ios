//
//  BLTWalletIO.m
//  EOS
//
//  Created by peng zhu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

#import "BLTWalletIO.h"

@interface BLTWalletIO () {
    int lastSignState;
    BOOL authTypeCached;
    unsigned char nAuthType;
    int authTypeResult;
    BOOL pinCached;
    NSString *pin;
    int pinResult;
}

@end

@implementation BLTWalletIO

void *savedDevH;

static BLTWalletIO *_instance = nil;

static dispatch_queue_t bltQueue = nil;

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
    if (_instance.didSearchDevice != nil)  {
        _instance.didSearchDevice(device);
    }
    return PAEW_RET_SUCCESS;
}

int DisconnectedCallback(const int status, const char *description)
{
    NSLog(@"device has disconnected already, status code is: %d, detail is: %s", status, description);
    savedDevH = nil;
    return PAEW_RET_SUCCESS;
}

int GetAuthType(void * const pCallbackContext, unsigned char * const pnAuthType)
{
    int rtn = 0;
    if (!_instance->authTypeCached) {
        [_instance getAuthType];
    }
    rtn = _instance->authTypeResult;
    if (rtn == PAEW_RET_SUCCESS) {
        *pnAuthType = _instance->nAuthType;
    }
    _instance->authTypeCached = NO;
    return rtn;
}

int GetPin(void * const pCallbackContext, unsigned char * const pbPIN, size_t * const pnPINLen)
{
    int rtn = 0;
    if (!_instance->pinCached) {
        [_instance getPIN];
    }
    rtn = _instance->pinResult;
    if (rtn == PAEW_RET_SUCCESS) {
        *pnPINLen = _instance->pin.length;
        strcpy((char *)pbPIN, [_instance->pin UTF8String]);
    }
    _instance->pinCached = NO;
    return rtn;
}

int PutSignState(void * const pCallbackContext, const int nSignState)
{
    if (nSignState != _instance->lastSignState) {
        [_instance printLog:[BLTUtils errorCodeToString:nSignState]];
        _instance->lastSignState = nSignState;
    }
    //here is a good place to canel sign function
    if (_instance.abortBtnState) {
        [_instance.abortCondition lock];
        !_instance.abortHandelBlock ? : _instance.abortHandelBlock(YES);
        [_instance.abortCondition wait];
        [_instance.abortCondition unlock];
        _instance.abortBtnState = NO;
    }
    return 0;
}

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        bltQueue = dispatch_queue_create("BluetoothQueue", DISPATCH_QUEUE_SERIAL);
    }) ;
    return _instance ;
}

- (void)formmart {
    if (!savedDevH) {
        return;
    }
    dispatch_async(bltQueue, ^{
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
    dispatch_async(bltQueue, ^{
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

- (void)searchBLTCard:(SuccessedComplication)complication {
    __block unsigned char nDeviceType = PAEW_DEV_TYPE_BT;
    __block char *szDeviceNames = (char *)malloc(512*16);
    __block size_t nDeviceNameLen = 512*16;
    __block size_t nDevCount = 0;
    __block EnumContext DevContext = {0};
    DevContext.timeout = 3;//scanning may found nothing if timeout is lower than 2 seconds. So the suggested timeout value should be larger than 2
    //typedef int(*tFunc_EnumCallback)(const char *szDevName, int nRSSI, int nState)
//    tFunc_EnumCallback *callback;
    DevContext.enumCallBack = EnumCallback;
    NSString *devName = @"WOOKONG BIO";
    strcpy(DevContext.searchName, [[devName stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet] UTF8String]);
    dispatch_async(bltQueue, ^{
        int devInfoState = PAEW_GetDeviceListWithDevContext(nDeviceType, szDeviceNames, &nDeviceNameLen, &nDevCount, &DevContext, sizeof(DevContext));
        dispatch_async(dispatch_get_main_queue(), ^{
            complication();
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

- (BOOL)isConnection {
    return savedDevH != nil;
}

- (void)connectCard:(NSString *)deviceNameId success:(SuccessedComplication)successComlication failed:(FailedComplication)failedCompliction {
    char *szDeviceName = (char *)[deviceNameId UTF8String];
    __block ConnectContext additional = {0};
    additional.timeout = 5;
    additional.batteryCallBack = BatteryCallback;
    additional.disconnectedCallback = DisconnectedCallback;
    __block void *ppPAEWContext = 0;
    dispatch_async(bltQueue, ^{
        int connectDev = PAEW_InitContextWithDevNameAndDevContext(&ppPAEWContext, szDeviceName, PAEW_DEV_TYPE_BT, &additional, sizeof(additional), 0x00, 0x00);
        if (ppPAEWContext) {
            savedDevH = ppPAEWContext;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (connectDev == PAEW_RET_SUCCESS) {
                successComlication();
            } else {
                failedCompliction([BLTUtils errorCodeToString:connectDev]);
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
    dispatch_async(bltQueue, ^{
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
    dispatch_async(bltQueue, ^{
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
    dispatch_async(bltQueue, ^{
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
    dispatch_async(bltQueue, ^{
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
    __block NSString *public_key = @"";
    __block NSString *failedReason = @"";
    
    dispatch_group_t disgroup = dispatch_group_create();
    
    dispatch_group_async(disgroup, bltQueue, ^{
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
    dispatch_group_async(disgroup, bltQueue, ^{
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
                public_key = [NSString stringWithUTF8String:(char *)bAddress];
                pub_sig = [BLTUtils bytesToHexString:[NSData dataWithBytes:bAddress + addressLen + 1 length:nAddressLen - addressLen - 1]];
                pub = [[BLTUtils bytesToHexString:bAddress length:addressLen] stringByAppendingString:@"00"];
                success_pub = true;
            }
        }
    });
    dispatch_group_notify(disgroup, bltQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success_pub && success_sn) {
                successComlication([sn lowercaseString],[sn_sig lowercaseString],[pub lowercaseString],[pub_sig lowercaseString],public_key);
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
    dispatch_async(bltQueue, ^{
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
    dispatch_async(bltQueue, ^{
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

- (void)enrollFingerPrinter:(EnrollFingerComplication)stateComplication success:(SuccessedComplication)success failed:(FailedComplication)failed {
    if (!savedDevH) {
        return;
    }
    dispatch_async(bltQueue, ^{
        int startEnrollS = PAEW_EnrollFP(savedDevH, 0);
        if (startEnrollS != PAEW_RET_SUCCESS) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failed([BLTUtils errorCodeToString:startEnrollS]);
            });
        } else {
            int iRtn = PAEW_RET_UNKNOWN_FAIL;
            int lastRtn = PAEW_RET_SUCCESS;
            do {
                
                iRtn = PAEW_GetFPState(savedDevH, 0);
                if (lastRtn != iRtn) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        stateComplication([BLTUtils stateWithValue:iRtn]);
                    });
                    lastRtn = iRtn;
                }
            } while ((iRtn == PAEW_RET_DEV_WAITING) || (iRtn == PAEW_RET_DEV_FP_GOOG_FINGER) || (iRtn == PAEW_RET_DEV_FP_REDUNDANT) || (iRtn == PAEW_RET_DEV_FP_BAD_IMAGE) || (iRtn == PAEW_RET_DEV_FP_NO_FINGER) || (iRtn == PAEW_RET_DEV_FP_NOT_FULL_FINGER));
            if (iRtn != PAEW_RET_SUCCESS) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed([BLTUtils errorCodeToString:iRtn]);
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                success();
            });
        }
    });
}

- (void)getEOSSign:(AuthType)type success:(GetSignComplication)complication failed:(FailedComplication)failedComplication{
    if (!savedDevH) {
        return;
    }
    int rtn = [self getAuthType];
    if (rtn != PAEW_RET_SUCCESS) {
        [self printLog:@"user canceled PAEW_EOS_TXSign_Ex"];
        return;
    }
    switch (type) {
        case pinType:
            _instance->nAuthType = PAEW_SIGN_AUTH_TYPE_PIN;
            break;
        case fpType:
            _instance->nAuthType = PAEW_SIGN_AUTH_TYPE_FP;
            break;
        default:
            break;
    }
    dispatch_async(bltQueue, ^{
        int devIdx = 0;
        void *ppPAEWContext = savedDevH;
        int iRtn = PAEW_RET_UNKNOWN_FAIL;
        unsigned char nCoinType = PAEW_COIN_TYPE_EOS;
        uint32_t puiDerivePath[] = {0, 0x8000002C, 0x800000c2, 0x80000000, 0x00000000, 0x00000000};
        iRtn = PAEW_DeriveTradeAddress(ppPAEWContext, devIdx, nCoinType, puiDerivePath, sizeof(puiDerivePath)/sizeof(puiDerivePath[0]));
        if (iRtn != PAEW_RET_SUCCESS) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failedComplication([BLTUtils errorCodeToString:iRtn]);
            });
            return ;
        }

        unsigned char transaction[] = {0x74, 0x09, 0x70, 0xd9, 0xff, 0x01, 0xb5, 0x04, 0x63, 0x2f, 0xed, 0xe1, 0xad, 0xc3, 0xdf, 0xe5, 0x59, 0x90, 0x41, 0x5e, 0x4f, 0xde, 0x01, 0xe1, 0xb8, 0xf3, 0x15, 0xf8, 0x13, 0x6f, 0x47, 0x6c, 0x14, 0xc2, 0x67, 0x5b, 0x01, 0x24, 0x5f, 0x70, 0x5d, 0xd7, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0xa6, 0x82, 0x34, 0x03, 0xea, 0x30, 0x55, 0x00, 0x00, 0x00, 0x57, 0x2d, 0x3c, 0xcd, 0xcd, 0x01, 0x20, 0x29, 0xc2, 0xca, 0x55, 0x7a, 0x73, 0x57, 0x00, 0x00, 0x00, 0x00, 0xa8, 0xed, 0x32, 0x32, 0x21, 0x20, 0x29, 0xc2, 0xca, 0x55, 0x7a, 0x73, 0x57, 0x90, 0x55, 0x8c, 0x86, 0x77, 0x95, 0x4c, 0x3c, 0x10, 0x27, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x45, 0x4f, 0x53, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
        unsigned char *pbTXSig = (unsigned char *)malloc(1024);
        size_t pnTXSigLen = 1024;
        signCallbacks callBack;
        callBack.getAuthType = GetAuthType;
        callBack.getPIN = GetPin;
        callBack.putSignState = PutSignState;
        _instance->lastSignState = PAEW_RET_SUCCESS;

        iRtn = PAEW_EOS_TXSign_Ex(ppPAEWContext, devIdx, transaction, sizeof(transaction), pbTXSig, &pnTXSigLen, &callBack, 0);
        if (iRtn) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failedComplication([BLTUtils errorCodeToString:iRtn]);
            });
            return;
        }
        NSString *sign = [[NSString alloc] initWithBytes:pbTXSig length:pnTXSigLen encoding:NSASCIIStringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            complication(sign);
        });
    });
}

- (void)submmitWaitingVerfyPin:(NSString *)waitVerPin {
    _instance->pin = waitVerPin;
}

-(int)getPIN
{
    NSString *pin = @"123456";
    self->pinCached = YES;
    int rtn = PAEW_RET_DEV_OP_CANCEL;
    if (pin) {
        self->pin = pin;
        rtn = PAEW_RET_SUCCESS;
    }
    self->pinResult = rtn;
    return rtn;
}

- (int)getAuthType
{
    int sel = 1;
    self->authTypeCached = YES;
    int rtn = PAEW_RET_DEV_OP_CANCEL;
    if (sel >= 0) {
        _instance->nAuthType = PAEW_SIGN_AUTH_TYPE_FP;
        rtn = PAEW_RET_SUCCESS;
    }
    self->authTypeResult = rtn;
    return rtn;
}


- (void)printLog:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    if ([NSThread isMainThread]) {
        NSLog(@"%@",str);
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",str);
        });
    }
}

@end

@implementation BLTDevice

@end
