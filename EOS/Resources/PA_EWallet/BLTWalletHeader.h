//
//  BLTWalletHeader.h
//  EOS
//
//  Created by peng zhu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

#ifndef BLTWalletHeader_h
#define BLTWalletHeader_h

/**
 enum callback
 
 this callback will notify a new WOOKONG BIO is found during bluetooth scanning
 
 @param szDevName the name of the device which had just been found
 @param nRSSI the RSSI of the device
 @param nState the state of the device, see CBPeripheralState for more details
 @return should return PAEW_RET_SUCCESS
 */
typedef int(*tFunc_EnumCallback)(const char *szDevName, int nRSSI, int nState);

/**
 battery callback
 
 this callback will notify battery source and battery state
 in every 6 seconds when WOOKONG BIO is idle
 
 @param nBatterySource current battery source, 0 for external power source, 1 for battery
 @param nBatteryState the RSSI of the device
 @return should return PAEW_RET_SUCCESS
 */
typedef int(*tFunc_BatteryCallback)(const int nBatterySource, const int nBatteryState);

/**
 disconnect callback
 
 this callback will notify when WOOKONG BIO is disconnected unexpectedly
 
 @param status error code
 @param description error description
 @return should return PAEW_RET_SUCCESS
 */
typedef int(*tFunc_DisconnectedCallback)(const int status, const char *description);



//context for enum device
typedef struct _enumContext
{
    int timeout;//bluetooth scan timeout, default value is 5 if it is set to 0
    char searchName[100];//partial or full name of target device, could be a empty string
    tFunc_EnumCallback enumCallBack;//enum call back, will be called every time when a new device is found
} EnumContext, *pEnumContext;

typedef struct _connectContext
{
    int timeout;//bluetooth connect timeout, default value is 5 if it is set to 0
    tFunc_BatteryCallback batteryCallBack;//battery status call back, will be called every 6 seconds while device is idle
    tFunc_DisconnectedCallback disconnectedCallback;//disconnectd call back, will be called when device is disconnected.
} ConnectContext, *pConnectContext;


typedef struct _additionalContext
{
    int timeout;
    char searchName[100];
    tFunc_EnumCallback enumCallBack;
    tFunc_BatteryCallback batteryCallBack;
    tFunc_DisconnectedCallback disconnectedCallback;
} AdditionalContext, *pAdditionalCtx;

#endif /* BLTWalletHeader_h */
