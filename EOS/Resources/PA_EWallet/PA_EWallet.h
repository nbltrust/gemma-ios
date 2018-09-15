#ifndef _PA_EWALLET_H_
#define _PA_EWALLET_H_

#include <stdint.h>

#ifndef _WIN32
#include <stddef.h> //for size_t
#endif //_WIN32

#define PAEW_RET_SUCCESS					0x00000000 //success
#define PAEW_RET_UNKNOWN_FAIL				0x80000001 //unknown failure
#define PAEW_RET_ARGUMENTBAD				0x80000002 //argument bad
#define PAEW_RET_HOST_MEMORY				0x80000003 //malloc memory failed

#define PAEW_RET_DEV_ENUM_FAIL				0x80000004 //enum device failed
#define PAEW_RET_DEV_OPEN_FAIL				0x80000005 //open device failed
#define PAEW_RET_DEV_COMMUNICATE_FAIL		0x80000006 //communicate failed
#define PAEW_RET_DEV_NEED_PIN				0x80000007 //device need user input pin to "unlock"
#define PAEW_RET_DEV_OP_CANCEL				0x80000008 //operation canceled
#define PAEW_RET_DEV_KEY_NOT_RESTORED		0x80000009 //operation need seed restored while current state is not restored
#define PAEW_RET_DEV_KEY_ALREADY_RESTORED	0x8000000A //seed already restored
#define PAEW_RET_DEV_COUNT_BAD				0x8000000B //errors such as no device, or device count must equal to N when init, device count must >=T and <=N when restore or sign
#define PAEW_RET_DEV_RETDATA_INVALID		0x8000000C //received data length less than 2 or ret data structure invalid
#define PAEW_RET_DEV_AUTH_FAIL				0x8000000D
#define PAEW_RET_DEV_STATE_INVALID			0x8000000E //life cycle or other device state not matched to current operation
#define PAEW_RET_DEV_WAITING				0x8000000F
#define PAEW_RET_DEV_COMMAND_INVALID		0x80000010 //command can not recognized by device
#define PAEW_RET_DEV_RUN_COMMAND_FAIL		0x80000011 //received data not 9000
#define PAEW_RET_DEV_HANDLE_INVALID			0x80000012
#define PAEW_RET_COS_TYPE_INVALID			0x80000013 //device cos type value must be PAEW_DEV_INFO_COS_TYPE_XXX
#define PAEW_RET_COS_TYPE_NOT_MATCH			0x80000014 //device cos type not matched to current operation, such as dragon ball spec function calls personal e-wallet, or passed argument implies specific cos type while current cos type not match, or current insert devices' types are not the same
#define PAEW_RET_DEV_BAD_SHAMIR_SPLIT		0x80000015
#define PAEW_RET_DEV_NOT_ONE_GROUP			0x80000016 //dragon ball device is not belong to one group

#define PAEW_RET_BUFFER_TOO_SAMLL			0x80000017 //size of input buffer not enough to store return data
#define PAEW_RET_TX_PARSE_FAIL				0x80000018 //input transaction parse failed
#define PAEW_RET_TX_UTXO_NEQ				0x80000019 //count of input and UTXO is not equal
#define PAEW_RET_TX_INPUT_TOO_MANY			0x8000001A //input count shouldn't larger than 100

#define PAEW_RET_MUTEX_ERROR				0x8000001B //mutex error, such as create/free/lock/unlock
#define PAEW_RET_COIN_TYPE_INVALID			0x8000001C //value of coin type must be PAEW_COIN_TYPE_XXX
#define PAEW_RET_COIN_TYPE_NOT_MATCH		0x8000001D //value of coin type must be equal to the value passed to PAEW_DeriveTradeAddress
#define PAEW_RET_DERIVE_PATH_INVALID		0x8000001E //derive path must start by 0x00000000, indicates m
#define PAEW_RET_NOT_SUPPORTED				0x8000001F
#define PAEW_RET_INTERNAL_ERROR				0x80000020 //library internal errors, such as internal structure definition mistake
#define PAEW_RET_BAD_N_T					0x80000021 //value of N or T is invalid
#define PAEW_RET_TARGET_DEV_INVALID			0x80000022 //when getting address or signing, dragon ball must select a target device by calling PAEW_DeriveTradeAddress successfully first
#define PAEW_RET_CRYPTO_ERROR				0x80000023
#define PAEW_RET_DEV_TIMEOUT				0x80000024 //device time out
#define PAEW_RET_DEV_PIN_LOCKED				0x80000025 //pin locked
#define PAEW_RET_DEV_PIN_CONFIRM_FAIL		0x80000026 //set new pin error when confirm
#define PAEW_RET_DEV_PIN_VERIFY_FAIL		0x80000027 //input pin error when change pin or other operation
#define PAEW_RET_DEV_CHECKDATA_FAIL			0x80000028 //input data check failed in device
#define PAEW_RET_DEV_DEV_OPERATING			0x80000029 //user is operating device, please wait
#define PAEW_RET_DEV_PIN_UNINIT				0x8000002A
#define PAEW_RET_DEV_BUSY					0x8000002B //if enroll or verify fp is called twice when the first process is not over
#define PAEW_RET_DEV_ALREADY_AVAILABLE		0x8000002C //if abort when no operation is processing
#define PAEW_RET_DEV_DATA_NOT_FOUND			0x8000002D
#define PAEW_RET_DEV_SENSOR_ERROR			0x8000002E
#define PAEW_RET_DEV_STORAGE_ERROR			0x8000002F
#define PAEW_RET_DEV_STORAGE_FULL			0x80000030

#define PAEW_RET_DEV_FP_COMMON_ERROR		0x80000031
#define PAEW_RET_DEV_FP_REDUNDANT			0x80000032
#define PAEW_RET_DEV_FP_GOOG_FINGER			0x80000033
#define PAEW_RET_DEV_FP_NO_FINGER			0x80000034
#define PAEW_RET_DEV_FP_NOT_FULL_FINGER		0x80000035
#define PAEW_RET_DEV_FP_BAD_IMAGE			0x80000036

#define PAEW_RET_DEV_LOW_POWER				0x80000037
#define PAEW_RET_DEV_TYPE_INVALID			0x80000038

#define PAEW_RET_NO_VERIFY_COUNT			0x80000039
#define PAEW_RET_AUTH_CANCEL				0x8000003A
#define PAEW_RET_PIN_LEN_ERROR				0x8000003B

#if (defined(_WIN32) && defined(_USRDLL))

#ifdef _EWALLET_DLL_
#define EWALLET_API	__declspec(dllexport)
#else //_EWALLET_DLL_
#define EWALLET_API
#endif //_EWALLET_DLL_

#else //_WIN32

#define EWALLET_API

#endif //_WIN32

#ifdef __cplusplus
extern "C"
{
#endif

typedef enum _process_step
{
	pstep_invalid,

	pstep_comm_enum_dev,
	pstep_comm_open_dev,
	pstep_comm_close_dev,
	pstep_comm_get_devinfo,
	pstep_comm_dev_select,

	pstep_init_seed_gen,
	pstep_init_mne_show,
	pstep_init_mne_confirm,
	pstep_init_seed_import,
	pstep_init_seed_import_comfirm,

	pstep_init_keypair_gen,
	pstep_init_key_agree_init,
	pstep_init_key_agree_update,
	pstep_init_key_agree_final,
	pstep_init_key_agree_show,
	pstep_init_key_agree_confirm,

	pstep_init_shamir_transmit_init,
	pstep_init_shamir_export,
	pstep_init_shamir_import,
	pstep_init_shamir_confirm,

	pstep_sig_output_data,
	pstep_sig_confirm,

	pstep_comm_addr_gen,
	pstep_comm_shamir_transmit_init,
	pstep_comm_shamir_export,
	pstep_comm_shamir_import,

	pstep_comm_addr_get,
	pstep_comm_addr_confirm,

	pstep_comm_format,
	pstep_comm_format_confirm,

	pstep_comm_clearcos,
	pstep_comm_clearcos_confirm,

	pstep_comm_updatecos,

	pstep_comm_changepin,
	pstep_comm_changepin_confirm,

	pstep_comm_addr_info_get,
	pstep_comm_addr_info_set,

	pstep_comm_erc20_info_set,

	pstep_init_mne_check,
	pstep_init_pin_init,

	pstep_comm_pin_verify,

	pstep_comm_fp_getlist,
	pstep_comm_fp_enroll,
	pstep_comm_fp_verify,
	pstep_comm_fp_getstate,
	pstep_comm_fp_abort,
	pstep_comm_fp_delete,
	pstep_comm_fp_calibrate,
} process_step;

typedef enum _process_status
{
	pstatus_invalid,
	pstatus_start,
	pstatus_finish,
} process_status;

#define INVALID_DEV_INDEX			((size_t)(-1))
#define PAEW_CALLBACK_DATA_MAX_LEN	(1024)

#pragma pack(1)
typedef struct _callback_data_addr_get
{
	unsigned char	nCoinType;
	size_t			nAddressLen;
	unsigned char	pbAddressData[PAEW_CALLBACK_DATA_MAX_LEN - sizeof(size_t) - 1];
} callback_data_addr_get;
typedef struct _callback_data_cos_update
{
	uint32_t		nProgress;
	unsigned char	pbUnused[PAEW_CALLBACK_DATA_MAX_LEN - sizeof(uint32_t)];
} callback_data_cos_update;
#pragma pack()

typedef struct _callback_param
{
	process_step	pstep;
	process_status	pstatus;
	int				ret_value; //when pstatus==pstatus_finish, check this value

	size_t			dev_index; //current main device index, from 0 to dev_count-1, not valid in pstep_comm_enum_dev

	//user define data
	size_t			dev_count; //valid in pstep_comm_enum_dev

	unsigned char	data[PAEW_CALLBACK_DATA_MAX_LEN]; //store addr or other informations
} callback_param;

typedef int(*tFunc_Proc_Callback)(callback_param * const pCallbackParam);

typedef int(*tFunc_GetAuthType)(void * const pCallbackContext, unsigned char * const pnAuthType); //*pnAuthType should be PAEW_SIGN_AUTH_TYPE_XXX when successfully returned
typedef int(*tFunc_GetPIN)(void * const pCallbackContext, unsigned char * const pbPIN, size_t * const pnPINLen);
typedef int(*tFunc_PutSignState)(void * const pCallbackContext, const int nSignState);
typedef struct _signCallbacks {
	tFunc_GetAuthType	getAuthType;
	tFunc_GetPIN		getPIN;
	tFunc_PutSignState	putSignState;
} signCallbacks;

//==============dev info=============
//dev info type
#define PAEW_DEV_INFOTYPE_PIN_STATE		0x00000001
#define PAEW_DEV_INFOTYPE_COS_TYPE		0x00000002
#define PAEW_DEV_INFOTYPE_CHAIN_TYPE	0x00000004
#define PAEW_DEV_INFOTYPE_SN			0x00000008
#define PAEW_DEV_INFOTYPE_COS_VERSION	0x00000010
#define PAEW_DEV_INFOTYPE_LIFECYCLE		0x00000020
#define PAEW_DEV_INFOTYPE_SESSKEY_HASH	0x00000040
#define PAEW_DEV_INFOTYPE_N_T			0x00000080
#define PAEW_DEV_INFOTYPE_LCD_STATE		0x00000100

//pin state
#define PAEW_DEV_INFO_PIN_INVALID_STATE		0xFF
#define PAEW_DEV_INFO_PIN_LOGOUT			0x00
#define PAEW_DEV_INFO_PIN_LOGIN				0x01
#define PAEW_DEV_INFO_PIN_LOCKED			0x02
#define PAEW_DEV_INFO_PIN_UNSET				0x03
//chain type
#define PAEW_DEV_INFO_CHAIN_TYPE_FORMAL		0x01
#define PAEW_DEV_INFO_CHAIN_TYPE_TEST		0x02
//sn
#define PAEW_DEV_INFO_SN_LEN				0x20
//cos version
//1st byte means cos architecture, usually essential cos upgrade
//2nd byte means cos type, currently 00 dragon ball, 01 personal wallet
//3rd and 4th bytes means minor version
#define PAEW_DEV_INFO_COS_VERSION_LEN		0x04
#define PAEW_DEV_INFO_COS_TYPE_INDEX		0x01
#define PAEW_DEV_INFO_COS_TYPE_INVALID		0xFF
#define PAEW_DEV_INFO_COS_TYPE_DRAGONBALL	0x00
#define PAEW_DEV_INFO_COS_TYPE_PERSONAL		0x01
#define PAEW_DEV_INFO_COS_TYPE_BIO			0x02
//life cycle
#define PAEW_DEV_INFO_LIFECYCLE_INVALID		0xFF
#define PAEW_DEV_INFO_LIFECYCLE_AGREE		0x01
#define PAEW_DEV_INFO_LIFECYCLE_USER		0x02
#define PAEW_DEV_INFO_LIFECYCLE_PRODUCE		0x04
//session key hash
#define PAEW_DEV_INFO_SESSKEY_HASH_LEN		0x04
//n/t
#define PAEW_DEV_INFO_N_T_INVALID			0xFF
//LCD State
#define PAEW_DEV_INFO_LCD_NULL				0x00000000
#define PAEW_DEV_INFO_LCD_SHOWLOGO			0x00000001
#define PAEW_DEV_INFO_LCD_WAITTING			0x00000002
#define PAEW_DEV_INFO_LCD_SHOWOK			0x00000004
#define PAEW_DEV_INFO_LCD_SHOWCANCEL		0x00000008
#define PAEW_DEV_INFO_LCD_SHOWSKEYHASH		0x00000010
#define PAEW_DEV_INFO_LCD_SHOWADDRESS		0x00000020
#define PAEW_DEV_INFO_LCD_SHOWBTCSIGN		0x00000040
#define PAEW_DEV_INFO_LCD_SHOWETHSIGN		0x00000080
#define PAEW_DEV_INFO_LCD_SETNEWPIN			0x00000100
#define PAEW_DEV_INFO_LCD_CHANGEPIN			0x00000200
#define PAEW_DEV_INFO_LCD_VERIFYPIN			0x00000400
#define PAEW_DEV_INFO_LCD_PINLOCKED			0x00000800
#define PAEW_DEV_INFO_LCD_FORMAT			0x00001000
#define PAEW_DEV_INFO_LCD_REBOOT			0x00002000
#define PAEW_DEV_INFO_LCD_SHOWBIP39			0x00004000
#define PAEW_DEV_INFO_LCD_CHECKBIP39		0x00008000
#define PAEW_DEV_INFO_LCD_SHOWBTSSIGN		0x00010000
#define PAEW_DEV_INFO_LCD_PINERROR 			0x00020000
#define PAEW_DEV_INFO_LCD_SELECT_MNENUM		0x00040000
#define PAEW_DEV_INFO_LCD_SHOWM				0x00080000
#define PAEW_DEV_INFO_LCD_SHOWTIMEOUT		0x00100000
#define PAEW_DEV_INFO_LCD_SHOWEOSSIGN		0x00200000
#define PAEW_DEV_INFO_LCD_SHOWFAIL			0x00400000
#define PAEW_DEV_INFO_LCD_SHOWNEOSIGN		0x00800000
#define PAEW_DEV_INFO_LCD_WAITING_TIMEOUT	0x01000000
#define PAEW_DEV_INFO_LCD_GET_MNENUM		0x02000000
#define PAEW_DEV_INFO_LCD_GETMNE_BYDEV		0x04000000 

typedef struct _PAEW_DevInfo
{
	unsigned char	ucPINState; //PAEW_DEV_INFO_PIN_XX
	unsigned char	ucCOSType; //PAEW_DEV_INFO_COS_TYPE_XXX
	unsigned char	ucChainType; //PAEW_DEV_INFO_CHAIN_TYPE_XXX
	unsigned char	pbSerialNumber[PAEW_DEV_INFO_SN_LEN];
	unsigned char	pbCOSVersion[PAEW_DEV_INFO_COS_VERSION_LEN];
	unsigned char	ucLifeCycle; // PAEW_DEV_INFO_LIFECYCLE_XXX
	uint64_t		nLcdState; // PAEW_DEV_INFO_LCD_XXX

	//dragon ball device info
	unsigned char	pbSessKeyHash[PAEW_DEV_INFO_SESSKEY_HASH_LEN];
	uint8_t			nN;
	uint8_t			nT;
} PAEW_DevInfo;

//coin type
#define PAEW_COIN_TYPE_INVALID	0xFF
#define PAEW_COIN_TYPE_BTC		0x00 //bit coin P2PKH
#define PAEW_COIN_TYPE_ETH		0x01 //eth
#define PAEW_COIN_TYPE_CYB		0x02 //cybex
#define PAEW_COIN_TYPE_EOS		0x03 //eos
#define PAEW_COIN_TYPE_LTC		0x04 //lite
#define PAEW_COIN_TYPE_NEO		0x05 //neo
#define PAEW_COIN_TYPE_ETC		0x06 //etc
#define PAEW_COIN_TYPE_BTC_WIT	0x07 //bit coin P2WPKH nested in BIP16 P2SH
#define PAEW_COIN_TYPE_BTC_SIGWIT	0x08 //bit coin P2WPKH

//sig btc
#define PAEW_BTC_SIG_MAX_LEN			0x70
#define PAEW_SIG_BTC_TX_HEADER			0x00
#define PAEW_SIG_BTC_TX_IN				0x01
#define PAEW_SIG_BTC_TX_OUT_HEADER		0x02
#define PAEW_SIG_BTC_TX_OUT				0x03
#define PAEW_SIG_BTC_TX_FINAL			0x04
//sig eth
#define PAEW_ETH_SIG_MAX_LEN			0x45
#define PAEW_SIG_ETH_TX					0x00
//sig etc
#define PAEW_ETC_SIG_MAX_LEN			0x45
#define PAEW_SIG_ETC_TX					0x00
//sig cyb
#define PAEW_CYB_SIG_MAX_LEN			0x41
#define PAEW_SIG_CYB_TX					0x00
//sig eos
#define PAEW_EOS_SIG_MAX_LEN			0x80
#define PAEW_SIG_EOS_TX_HEADER			0x00
#define PAEW_SIG_EOS_TX_ACTION_COUNT	0x01
#define PAEW_SIG_EOS_TX_ACTION			0x02
#define PAEW_SIG_EOS_TX_CF_HASH			0x03 //context_free hash
//sig ltc
#define PAEW_LTC_SIG_MAX_LEN			0x70
#define PAEW_SIG_LTC_TX_HEADER			0x00
#define PAEW_SIG_LTC_TX_IN				0x01
#define PAEW_SIG_LTC_TX_OUT_HEADER		0x02
#define PAEW_SIG_LTC_TX_OUT				0x03
#define PAEW_SIG_LTC_TX_FINAL			0x04
//sig neo
#define PAEW_NEO_SIG_MAX_LEN			0x70
#define PAEW_SIG_NEO_TX_HEADER			0x00
#define PAEW_SIG_NEO_TX_SPEC_COUNT		0x01
#define PAEW_SIG_NEO_TX_SPEC_DATA		0x02
#define PAEW_SIG_NEO_TX_ATTRIBUTE		0x03
#define PAEW_SIG_NEO_TX_IN_COUNT		0x04
#define PAEW_SIG_NEO_TX_IN				0x05
#define PAEW_SIG_NEO_TX_OUT_COUNT		0x06
#define PAEW_SIG_NEO_TX_OUT				0x07
//#define PAEW_SIG_NEO_TX_SCRIPTS			0x06
//sig btc wit
#define PAEW_BTC_WIT_SIG_MAX_LEN			0x70
#define PAEW_SIG_BTC_WIT_TX_HEADER			0x00
#define PAEW_SIG_BTC_WIT_ALL_TX_IN			0x01
#define PAEW_SIG_BTC_WIT_TX_IN				0x02
#define PAEW_SIG_BTC_WIT_TX_OUT_HEADER		0x03
#define PAEW_SIG_BTC_WIT_TX_OUT				0x04
#define PAEW_SIG_BTC_WIT_TX_FINAL			0x05
//sig btc sigwit

//address
#define PAEW_COIN_ADDRESS_MAX_LEN		0x80

//seed
#define PAEW_ROOT_SEED_LEN				0x40

//FingerPrint
#define PAEW_FP_ID_LEN	0x01
typedef struct _FingerPrintID
{
	unsigned char	data[PAEW_FP_ID_LEN];
} FingerPrintID;

//Device Type
#define PAEW_DEV_TYPE_HID	0x00
#define PAEW_DEV_TYPE_BT	0x01

//Mne
#define PAEW_MNE_MAX_LEN			512
#define PAEW_MNE_INDEX_MAX_COUNT	32

//Authenticate Type
#define PAEW_SIGN_AUTH_TYPE_PIN		0x00
#define PAEW_SIGN_AUTH_TYPE_FP		0x01

//PIN
#define PAEW_PIN_MAX_LEN	0x20

//ECR20
#define PAEW_ERC20_TOKEN_NAME_MAX_LEN	0x08
#define PAEW_ERC20_TOKEN_ADDRESS_LEN	0x14
typedef struct _PAEW_ERC20Info
{
	unsigned char	pbTokenName[PAEW_ERC20_TOKEN_NAME_MAX_LEN];
	unsigned char	nTokenPrecision;
	unsigned char	pbTokenAddress[PAEW_ERC20_TOKEN_ADDRESS_LEN];
} PAEW_ERC20Info;

/*
获取库的版本号
[OUT] pbVersion：用于存储版本号的地址，目前的定义为：PA_VERSION_PRODUCT || PA_VERSION_RESERVED || PA_VERSION_MAJOR || PA_VERSION_MINOR
[OUT] pnVersionLen：返回版本号长度
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_GetLibraryVersion(unsigned char * const pbVersion, size_t * const pnVersionLen);

/*
根据设备类型，获取当前设备列表
[IN] nDeviceType：设备类型，取值为PAEW_DEV_TYPE_XXX
[OUT] szDeviceNames：用于存储枚举到的设备列表的地址，若枚举成功，此地址列表返回的格式为：devName1 + \0 + devName2 + \0 + ... + devNameN + \0\0
[OUT] pnDeviceNameLen：输入时表示szDevNames的缓冲区长度，输出时表示有效的设备列表的长度，不可为NULL
[OUT] pnDevCount：返回枚举到的设备数量，不可为NULL
[IN OUT] pDevContext：设备上下文
[IN] nDevContextLen：设备上下文的长度
[IN] pProcCallback：用来接收进度信息的回调函数
[IN] pCallbackParam：回调函数的参数
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_GetDeviceListWithDevContext(const unsigned char nDeviceType, char * const szDeviceNames, size_t * const pnDeviceNameLen, size_t * const pnDevCount, void * const pDevContext, const size_t nDevContextLen);

/*
使用设备上下文，枚举当前的设备列表
[OUT] ppPAEWContext：用于存储初始化好的上下文结构体的指针的地址，不可为NULL，使用完毕后，*ppPAEWContext需要传入PAEW_FreeContext来释放资源
[OUT] pnDevCount：返回枚举到的设备数量
[IN OUT] pDevContext：设备上下文
[IN] nDevContextLen：设备上下文的长度
[IN] pProcCallback：用来接收进度信息的回调函数
[IN] pCallbackParam：回调函数的参数
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_InitContextWithDevContext(void ** const ppPAEWContext, size_t * const pnDevCount, void * const pDevContext, const size_t nDevContextLen, const tFunc_Proc_Callback pProcCallback, callback_param * const pCallbackParam);

/*
申请并初始化钱包上下文
[OUT] ppPAEWContext：用于存储初始化好的上下文结构体的指针的地址，不可为NULL，使用完毕后，*ppPAEWContext需要传入PAEW_FreeContext来释放资源
[OUT] pnDevCount：返回枚举到的设备数量
[IN] pProcCallback：用来接收进度信息的回调函数
[IN] pCallbackParam：回调函数的参数
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_InitContext(void ** const ppPAEWContext, size_t * const pnDevCount, const tFunc_Proc_Callback pProcCallback, callback_param * const pCallbackParam);

/*
使用特定的设备名称和设备上下文，申请并初始化钱包上下文
[OUT] ppPAEWContext：用于存储初始化好的上下文结构体的指针的地址，不可为NULL，使用完毕后，*ppPAEWContext需要传入PAEW_FreeContext来释放资源
[IN] szDeviceName：由node-usb模块检测设备插拔得到的设备名称，由三个字段组成：“busNumber:deviceAddress:interfaceNumber”，使用“%04x:%04x:%02x”的格式进行格式化；或者由系统得到的蓝牙地址“xx:xx:xx:xx”
[IN] nDeviceType：设备类型，取值为PAEW_DEV_TYPE_XXX
[IN OUT] pDevContext：设备上下文
[IN] nDevContextLen：设备上下文的长度
[IN] pProcCallback：用来接收进度信息的回调函数
[IN] pCallbackParam：回调函数的参数
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_InitContextWithDevNameAndDevContext(void ** const ppPAEWContext, const char * const szDeviceName, const unsigned char nDeviceType, void * const pDevContext, const size_t nDevContextLen, const tFunc_Proc_Callback pProcCallback, callback_param * const pCallbackParam);

/*
使用特定的设备名称，申请并初始化钱包上下文
[OUT] ppPAEWContext：用于存储初始化好的上下文结构体的指针的地址，不可为NULL，使用完毕后，*ppPAEWContext需要传入PAEW_FreeContext来释放资源
[IN] szDeviceName：由node-usb模块检测设备插拔得到的设备名称，由三个字段组成：“busNumber:deviceAddress:interfaceNumber”，使用“%04x:%04x:%02x”的格式进行格式化；或者由系统得到的蓝牙地址“xx:xx:xx:xx”
[IN] nDeviceType：设备类型，取值为PAEW_DEV_TYPE_XXX
[IN] pProcCallback：用来接收进度信息的回调函数
[IN] pCallbackParam：回调函数的参数
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_InitContextWithDevName(void ** const ppPAEWContext, const char * const szDeviceName, const unsigned char nDeviceType, const tFunc_Proc_Callback pProcCallback, callback_param * const pCallbackParam);

/*
释放上下文
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_FreeContext(void * const pPAEWContext);

/*
设置设备上下文
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，如果范围为[0, nDevCount-1]，则设置指定设备的上下文；如果值为INVALID_DEV_INDEX，则设置所有设备的上下文；其余取值无效
[IN] pDevContext：设备上下文
[IN] nDevContextLen：设备上下文的长度
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_SetDevContext(void * const pPAEWContext, const size_t nDevIndex, void * const pDevContext, const size_t nDevContextLen);

/*
获取设备上下文
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[OUT] ppDevContext：指向返回的设备上下文的指针
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_GetDevContext(void * const pPAEWContext, const size_t nDevIndex, void ** const ppDevContext);

/*
获取某一设备的硬件信息
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[IN] nDevInfoType：获取的设备信息类型，取值为PAEW_DEV_INFOTYPE_XXX的异或组合
[OUT] pDevInfo：返回的设备信息，不可为NULL
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_GetDevInfo(void * const pPAEWContext, const size_t nDevIndex, const uint32_t nDevInfoType, PAEW_DevInfo * const pDevInfo);

/*
生成种子以初始化设备
七龙珠钱包：包括协商会话密钥、生成种子、分发种子、生成助记词、考试。成功后切换设备生命周期状态
个人版钱包：初始化设备，包括生成种子、生成助记词、考试。成功后切换设备生命周期状态
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：（个人版钱包专用）操作的设备索引号，范围为[0, nDevCount-1]
[IN] nSeedLen：（个人版钱包专用）助记词直接对应的种子长度，取值为[16, 32]之内的4的倍数
[IN] nN：（七龙珠钱包专用）系统参数，密钥分散的数量，4<=N<=7，且当前插入的设备数量必须与nN相等
[IN] nT：（七龙珠钱包专用）系统参数，密钥恢复的数量，2<=M<=N
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_GenerateSeed(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nSeedLen, const uint8_t nN, const uint8_t nT);

/*
生成种子以初始化设备（仅用于指纹钱包）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[IN] nSeedLen：助记词直接对应的种子长度，取值为[16, 32]之内的4的倍数
[OUT] pbMneWord：接收返回的助记词的缓冲区
[OUT] pnMneWordLen：返回的助记词的长度
[OUT] pbCheckIndex：接收返回的考试索引的缓冲区
[OUT] pnCheckIndexCount：返回的考试索引的个数
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_GenerateSeed_GetMnes(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nSeedLen, unsigned char * const pbMneWord, size_t * const pnMneWordLen, size_t * const pnCheckIndex, size_t * const pnCheckIndexCount);

/*
生成种子以初始化设备（仅用于指纹钱包）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[IN] nSeedLen：助记词直接对应的种子长度，取值为[16, 32]之内的4的倍数
[IN] pbMneWord：存储待检查的助记词的缓冲区
[IN] nMneWordLen：待检查的助记词的长度
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_GenerateSeed_CheckMnes(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbMneWord, const size_t nMneWordLen);

/*
（个人版钱包专用）导入助记词以初始化设备
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[IN] pbMneWord：保存了助记词的缓冲区地址
[IN] nMneWordLen：助记词数据的有效长度，不可为0
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_ImportSeed(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbMneWord, const size_t nMneWordLen);

/*
（个人版钱包专用）通过助记词恢复种子（软算法，不初始化设备）
[IN] pbWordBuf：指向保存了助记词的缓冲区地址
[IN] nWordBufLen：缓冲区保存的助记词数据的有效长度
[OUT] pbPrvSeed：保存恢复出的种子的缓冲区，大小不可小于PAEW_ROOT_SEED_LEN字节
[IN OUT] pnPrvSeedLen：输入时的值表示pbPrvSeed缓冲区的长度，输出的值为实际返回的恢复出的种子的长度，固定为PAEW_ROOT_SEED_LEN
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_RecoverSeedFromMne(const unsigned char * const pbWordBuf, const size_t nWordBufLen, unsigned char * const pbPrvSeed, size_t * const pnPrvSeedLen);

/*
（七龙珠钱包专用）通过助记词组恢复助记词（软算法，不初始化设备）
[IN] nGroupCount：输入的分量的个数
[IN] ppbWordBuf：每个元素指向一个保存了助记词的缓冲区地址
[IN] pnWordBufLen：每个元素表示对应下标的缓冲区保存的助记词数据的有效长度
[OUT] pbMneWord：保存恢复出的助记词的缓冲区，不可为NULL
[IN OUT] pnMneWordLen：输入时的值表示pbMneWord缓冲区的长度，输出的值为实际返回的恢复出的助记词的长度
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_RecoverMneFromMneGroup(const size_t nGroupCount, const unsigned char * const * const ppbWordBuf, const size_t * const pnWordBufLen, unsigned char * const pbMneWord, size_t * const pnMneWordLen);

/*
通过种子和衍生路径生成地址（软算法，不初始化设备）
[IN] pbSeed：存储种子数据的缓冲区，不可为NULL
[IN] nSeedLen：种子数据的有效长度
[IN] puiDerivePath：币种衍生路径，不可为NULL，第一个数据必须为0，表示路径m（由种子生成根私钥）
[IN] nDerivePathLen：币种衍生路径的长度（元素个数），至少为1
[OUT] pbPrivateKey：接收私钥的缓冲区，不可为NULL
[IN OUT] pnPrivateKeyLen：输入时的值表示pbPrivateKey缓冲区的长度，输出的值为私钥的长度
[IN] bTestNet：若需获取地址，需确认是否为测试网，测试网为非0，正式网为0
[IN] nCoinType：若需获取地址，则币种类型需设置为PAEW_COIN_TYPE_XXX
[OUT] pbTradeAddress：接收数字货币地址的缓冲区，若不需获取地址，则可设置为NULL
[IN OUT] pnTradeAddressLen：输入时的值表示pbTradeAddress缓冲区的长度，输出的值为数字货币地址的长度，若不需获取地址，则可设置为NULL
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_GetTradeAddressFromSeed(const unsigned char * const pbSeed, const size_t nSeedLen, const uint32_t * const puiDerivePath, const size_t nDerivePathLen, unsigned char * const pbPrivateKey, size_t * const pnPrivateKeyLen, const unsigned char bTestNet, const unsigned char nCoinType, unsigned char * const pbTradeAddress, size_t * const pnTradeAddressLen);

/*
按路径恢复种子和公私钥
七龙珠钱包：按路径恢复种子并从种子衍生出公私钥，恢复到随机选择的某个设备内，恢复之后可进行签名或取地址操作
个人版钱包：按路径从种子衍生出公私钥，恢复之后可进行签名或取地址操作
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：（个人版钱包专用）操作的设备索引号，范围为[0, nDevCount-1]
[IN] nCoinType：币种类型PAEW_COIN_TYPE_XXX
[IN] puiDerivePath：币种衍生路径，不可为NULL，第一个数据必须为0，表示路径m（由种子生成根私钥）
[IN] nDerivePathLen：币种衍生路径的长度（元素个数），至少为1
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_DeriveTradeAddress(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nCoinType, const uint32_t * const puiDerivePath, const size_t nDerivePathLen);

/*
获取数字货币地址，要求先调用PAEW_DeriveTradeAddress
七龙珠钱包：操作的设备为PAEW_DeriveTradeAddress选中的设备
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：（个人版钱包专用）操作的设备索引号，范围为[0, nDevCount-1]
[IN] nCoinType：币种类型PAEW_COIN_TYPE_XXX，必须与PAEW_DeriveTradeAddress时传入的币种一致
[OUT] pbTradeAddress：接收数字货币地址的缓冲区，不可为NULL
[IN OUT] pnTradeAddressLen：输入时的值表示pbTradeAddress缓冲区的长度，输出的值为数字货币地址的长度
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_GetTradeAddress(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nCoinType, unsigned char * const pbTradeAddress, size_t * const pnTradeAddressLen);

/*
比特币签名，要求先调用PAEW_DeriveTradeAddress
七龙珠钱包：操作的设备为PAEW_DeriveTradeAddress选中的设备
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：（个人版钱包专用）操作的设备索引号，范围为[0, nDevCount-1]
[IN] nUTXOCount：本次交易使用的UTXO的个数，与本次交易使用的Input个数相等
[IN] ppbUTXO：本次交易使用的UTXO的完整信息
[IN] pnUTXOLen：本次交易使用的UTXO的信息长度，每个元素对应ppbUTXO的一个元素指向的信息
[IN] pbCurrentTX：本次交易的未签名的交易信息
[IN] nCurrentTXLen：本次交易的未签名交易信息的长度
[OUT] ppbTXSig：DER编码后的签名数据，个数与Input个数相等，不可为NULL，并且元素不可为NULL
[IN OUT] pnTXSigLen：本次交易的交易信息签名的长度，输入时的值表示ppbTXSig缓冲区的长度，输出的值为实际返回的签名后的交易数据的长度
[IN] pSignCallbacks：签名回调函数结构体，包括获取验证方式、获取PIN码、推送签名状态等回调
[IN OUT] pSignCallbackContext：签名回调函数上下文，用来传递特殊的上下文以方便回调函数在不同环境下的实现
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_BTC_TXSign(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const * const ppbTXSig, size_t * const pnTXSigLen);
int EWALLET_API PAEW_BTC_TXSign_Ex(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const * const ppbTXSig, size_t * const pnTXSigLen, const signCallbacks * const pSignCallbacks, void * const pSignCallbackContext);

/*
以太币签名，要求先调用PAEW_DeriveTradeAddress
七龙珠钱包：操作的设备为PAEW_DeriveTradeAddress选中的设备
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：（个人版钱包专用）操作的设备索引号，范围为[0, nDevCount-1]
[IN] pbCurrentTX：本次交易的未签名的交易信息
[IN] nCurrentTXLen：本次交易的未签名交易信息的长度
[OUT] pbTXSig：签名数据，R（32字节）+S（32字节）+V（1字节），不可为NULL
[IN OUT] pnTXSigLen：本次交易的交易信息签名的长度，输入时的值表示pbTXSig缓冲区的长度，输出的值为实际返回的签名后的交易数据的长度
[IN] pSignCallbacks：签名回调函数结构体，包括获取验证方式、获取PIN码、推送签名状态等回调
[IN OUT] pSignCallbackContext：签名回调函数上下文，用来传递特殊的上下文以方便回调函数在不同环境下的实现
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_ETH_TXSign(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen);
int EWALLET_API PAEW_ETH_TXSign_Ex(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen, const signCallbacks * const pSignCallbacks, void * const pSignCallbackContext);

/*
以太现金签名，要求先调用PAEW_DeriveTradeAddress
七龙珠钱包：操作的设备为PAEW_DeriveTradeAddress选中的设备
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：（个人版钱包专用）操作的设备索引号，范围为[0, nDevCount-1]
[IN] pbCurrentTX：本次交易的未签名的交易信息
[IN] nCurrentTXLen：本次交易的未签名交易信息的长度
[OUT] pbTXSig：签名数据，R（32字节）+S（32字节）+V（1字节），不可为NULL
[IN OUT] pnTXSigLen：本次交易的交易信息签名的长度，输入时的值表示pbTXSig缓冲区的长度，输出的值为实际返回的签名后的交易数据的长度
[IN] pSignCallbacks：签名回调函数结构体，包括获取验证方式、获取PIN码、推送签名状态等回调
[IN OUT] pSignCallbackContext：签名回调函数上下文，用来传递特殊的上下文以方便回调函数在不同环境下的实现
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_ETC_TXSign(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen);
int EWALLET_API PAEW_ETC_TXSign_Ex(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen, const signCallbacks * const pSignCallbacks, void * const pSignCallbackContext);

/*
CYB签名，要求先调用PAEW_DeriveTradeAddress
七龙珠钱包：操作的设备为PAEW_DeriveTradeAddress选中的设备
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：（个人版钱包专用）操作的设备索引号，范围为[0, nDevCount-1]
[IN] pbCurrentTX：本次交易的未签名的交易信息
[IN] nCurrentTXLen：本次交易的未签名交易信息的长度
[OUT] pbTXSig：签名数据，R（32字节）+S（32字节），不可为NULL
[IN OUT] pnTXSigLen：本次交易的交易信息签名的长度，输入时的值表示pbTXSig缓冲区的长度，输出的值为实际返回的签名后的交易数据的长度
[IN] pSignCallbacks：签名回调函数结构体，包括获取验证方式、获取PIN码、推送签名状态等回调
[IN OUT] pSignCallbackContext：签名回调函数上下文，用来传递特殊的上下文以方便回调函数在不同环境下的实现
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_CYB_TXSign(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen);
int EWALLET_API PAEW_CYB_TXSign_Ex(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen, const signCallbacks * const pSignCallbacks, void * const pSignCallbackContext);

/*
EOS签名，要求先调用PAEW_DeriveTradeAddress
七龙珠钱包：操作的设备为PAEW_DeriveTradeAddress选中的设备
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：（个人版钱包专用）操作的设备索引号，范围为[0, nDevCount-1]
[IN] pbCurrentTX：本次交易的未签名的交易信息
[IN] nCurrentTXLen：本次交易的未签名交易信息的长度
[OUT] pbTXSig：签名数据，为编码后的签名数据，不可为NULL
[IN OUT] pnTXSigLen：本次交易的交易信息签名的长度，输入时的值表示pbTXSig缓冲区的长度，输出的值为实际返回的签名后的交易数据的长度
[IN] pSignCallbacks：签名回调函数结构体，包括获取验证方式、获取PIN码、推送签名状态等回调
[IN OUT] pSignCallbackContext：签名回调函数上下文，用来传递特殊的上下文以方便回调函数在不同环境下的实现
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_EOS_TXSign(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen);
int EWALLET_API PAEW_EOS_TXSign_Ex(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen, const signCallbacks * const pSignCallbacks, void * const pSignCallbackContext);

/*
比特币签名，要求先调用PAEW_DeriveTradeAddress
七龙珠钱包：操作的设备为PAEW_DeriveTradeAddress选中的设备
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：（个人版钱包专用）操作的设备索引号，范围为[0, nDevCount-1]
[IN] nUTXOCount：本次交易使用的UTXO的个数，与本次交易使用的Input个数相等
[IN] ppbUTXO：本次交易使用的UTXO的完整信息
[IN] pnUTXOLen：本次交易使用的UTXO的信息长度，每个元素对应ppbUTXO的一个元素指向的信息
[IN] pbCurrentTX：本次交易的未签名的交易信息
[IN] nCurrentTXLen：本次交易的未签名交易信息的长度
[OUT] ppbTXSig：DER编码后的签名数据，个数与Input个数相等，不可为NULL，并且元素不可为NULL
[IN OUT] pnTXSigLen：本次交易的交易信息签名的长度，输入时的值表示ppbTXSig缓冲区的长度，输出的值为实际返回的签名后的交易数据的长度
[IN] pSignCallbacks：签名回调函数结构体，包括获取验证方式、获取PIN码、推送签名状态等回调
[IN OUT] pSignCallbackContext：签名回调函数上下文，用来传递特殊的上下文以方便回调函数在不同环境下的实现
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_LTC_TXSign(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const * const ppbTXSig, size_t * const pnTXSigLen);
int EWALLET_API PAEW_LTC_TXSign_Ex(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const * const ppbTXSig, size_t * const pnTXSigLen, const signCallbacks * const pSignCallbacks, void * const pSignCallbackContext);

/*
比特币签名，要求先调用PAEW_DeriveTradeAddress
七龙珠钱包：操作的设备为PAEW_DeriveTradeAddress选中的设备
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：（个人版钱包专用）操作的设备索引号，范围为[0, nDevCount-1]
[IN] nUTXOCount：本次交易使用的UTXO的个数，与本次交易使用的Input个数相等
[IN] ppbUTXO：本次交易使用的UTXO的完整信息
[IN] pnUTXOLen：本次交易使用的UTXO的信息长度，每个元素对应ppbUTXO的一个元素指向的信息
[IN] pbCurrentTX：本次交易的未签名的交易信息
[IN] nCurrentTXLen：本次交易的未签名交易信息的长度
[OUT] pbTXSig：签名数据，为编码后的签名数据，不可为NULL
[IN OUT] pnTXSigLen：本次交易的交易信息签名的长度，输入时的值表示pbTXSig缓冲区的长度，输出的值为实际返回的签名后的交易数据的长度
[IN] pSignCallbacks：签名回调函数结构体，包括获取验证方式、获取PIN码、推送签名状态等回调
[IN OUT] pSignCallbackContext：签名回调函数上下文，用来传递特殊的上下文以方便回调函数在不同环境下的实现
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_NEO_TXSign(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen);
int EWALLET_API PAEW_NEO_TXSign_Ex(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen, const signCallbacks * const pSignCallbacks, void * const pSignCallbackContext);

/*
比特币WIT签名，即P2WPKH nested in BIP16 P2SH，要求先调用PAEW_DeriveTradeAddress
七龙珠钱包：操作的设备为PAEW_DeriveTradeAddress选中的设备
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：（个人版钱包专用）操作的设备索引号，范围为[0, nDevCount-1]
[IN] nUTXOCount：本次交易使用的UTXO的个数，与本次交易使用的Input个数相等
[IN] ppbUTXO：本次交易使用的UTXO的完整信息
[IN] pnUTXOLen：本次交易使用的UTXO的信息长度，每个元素对应ppbUTXO的一个元素指向的信息
[IN] pbCurrentTX：本次交易的未签名的交易信息
[IN] nCurrentTXLen：本次交易的未签名交易信息的长度
[OUT] ppbTXSig：DER编码后的签名数据，个数与Input个数相等，不可为NULL，并且元素不可为NULL
[IN OUT] pnTXSigLen：本次交易的交易信息签名的长度，输入时的值表示ppbTXSig缓冲区的长度，输出的值为实际返回的签名后的交易数据的长度
[IN] pSignCallbacks：签名回调函数结构体，包括获取验证方式、获取PIN码、推送签名状态等回调
[IN OUT] pSignCallbackContext：签名回调函数上下文，用来传递特殊的上下文以方便回调函数在不同环境下的实现
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_BTC_WIT_TXSign(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const * const ppbTXSig, size_t * const pnTXSigLen);
int EWALLET_API PAEW_BTC_WIT_TXSign_Ex(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const * const ppbTXSig, size_t * const pnTXSigLen, const signCallbacks * const pSignCallbacks, void * const pSignCallbackContext);

/*
清除用户COS
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_ClearCOS(void * const pPAEWContext, const size_t nDevIndex);

/*
修改PIN
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_ChangePIN(void * const pPAEWContext, const size_t nDevIndex);

/*
修改PIN（仅用于指纹钱包）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[IN] szOldPIN：设备的当前PIN码，不可为NULL
[IN] szNewPIN：需要设置的新PIN码，不可为NULL
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_ChangePIN_Input(void * const pPAEWContext, const size_t nDevIndex, const char * const szOldPIN, const char * const szNewPIN);

/*
设置初始PIN（仅用于指纹钱包）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[IN] szPIN：需要设置的PIN码，不可为NULL
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_InitPIN(void * const pPAEWContext, const size_t nDevIndex, const char * const szPIN);

/*
验证PIN（仅用于指纹钱包）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[IN] szPIN：需要验证的PIN码，不可为NULL
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_VerifyPIN(void * const pPAEWContext, const size_t nDevIndex, const char * const szPIN);

/*
格式化设备，清除设备中已存有的种子或分量，再次使用需要重新初始化设备
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_Format(void * const pPAEWContext, const size_t nDevIndex);

/*
（个人版钱包专用）升级设备的COS
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[IN] pbCOSData：COS二进制数据缓冲区，不可为NULL
[IN] nCOSDataLen：COS二进制数据的长度，不可为0
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_UpdateCOS(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCOSData, const size_t nCOSDataLen);

/*
EOS transaction 字符串（Json）串行化（软算法，不初始化设备）
[IN] szTransactionString：transaction字符串，其中ref_block_prefix字段需要作为字符串传入（使用双引号括起来）
[OUT] pbTransactionData：存储序列化之后的二进制数据的缓冲区，不可为NULL
[IN OUT] pnTransactionLen：序列化之后的二进制数据的长度，输入时的值表示pbTransactionData缓冲区的长度，输出的值为实际返回的序列化交易数据的长度
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_EOS_TX_Serialize(const char * const szTransactionString, unsigned char * const pbTransactionData, size_t * pnTransactionLen);

/*
EOS transaction 字符串（Json）串行化（软算法，不初始化设备）
[IN] nPartIndex：EOS交易序列化的索引，值为PAEW_SIG_EOS_TX_XXX
[IN] szTransactionString：transaction字符串，其中ref_block_prefix字段需要作为字符串传入（使用双引号括起来）
[OUT] pbTransactionData：存储序列化之后的二进制数据的缓冲区，不可为NULL
[IN OUT] pnTransactionLen：序列化之后的二进制数据的长度，输入时的值表示pbTransactionData缓冲区的长度，输出的值为实际返回的序列化交易数据的长度
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_EOS_TX_Part_Serialize(const unsigned int nPartIndex, const char * const szTransactionString, unsigned char * const pbTransactionData, size_t * pnTransactionLen);

/*
设置ERC20代币的信息（用于显示）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：（个人版钱包专用）操作的设备索引号，范围为[0, nDevCount-1]
[IN] nCoinType：币种类型，目前仅支持PAEW_COIN_TYPE_ETH和PAEW_COIN_TYPE_ETC
[IN] szTokenName：币种的名称，不可为NULL，并且内容长度不可为0
[IN] nPrecision：币种精度，表示10的幂次
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_SetERC20Info(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nCoinType, const char * const szTokenName, const unsigned char nPrecision);


/*
获取指纹列表（仅用于指纹钱包）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[OUT] pFPList：存储指纹列表的缓冲区，不可为NULL
[OUT] pnFPListCount：传入时指向pFPList的元素个数，传出时表示获取到的指纹的个数
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_GetFPList(void * const pPAEWContext, const size_t nDevIndex, FingerPrintID * const pFPList, size_t * const pnFPListCount);

/*
验证指纹（仅用于指纹钱包，之后需使用PAEW_GetFPState获取状态）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_VerifyFP(void * const pPAEWContext, const size_t nDevIndex);

/*
获取验证通过的指纹列表（仅用于指纹钱包）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[OUT] pFPList：存储指纹列表的缓冲区，不可为NULL
[OUT] pnFPListCount：传入时指向pFPList的元素个数，传出时表示获取到的指纹的个数
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_GetVerifyFPList(void * const pPAEWContext, const size_t nDevIndex, FingerPrintID * const pFPList, size_t * const pnFPListCount);

/*
录入指纹（仅用于指纹钱包，之后需使用PAEW_GetFPState获取状态）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_EnrollFP(void * const pPAEWContext, const size_t nDevIndex);

/*
获取指纹操作的状态（仅用于指纹钱包，前置接口为PAEW_VerifyFP或PAEW_EnrollFP）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_GetFPState(void * const pPAEWContext, const size_t nDevIndex);

/*
中断指纹操作（仅用于指纹钱包，用于中断录入或验证指纹）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_AbortFP(void * const pPAEWContext, const size_t nDevIndex);

/*
删除指纹（仅用于指纹钱包）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[IN] pFPID：保存了待删除的指纹ID数组的缓冲区的首地址，当传入NULL时，表示全部删除
[IN] nFPCount：待删除的指纹ID数组的个数
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_DeleteFP(void * const pPAEWContext, const size_t nDevIndex, const FingerPrintID * const pFPID, const size_t nFPCount);

/*
校正指纹传感器（仅用于指纹钱包）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_CalibrateFP(void * const pPAEWContext, const size_t nDevIndex);

/*
清空屏幕（仅用于指纹钱包）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_ClearLCD(void * const pPAEWContext, const size_t nDevIndex);

/*
关闭电源（仅用于指纹钱包）
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_PowerOff(void * const pPAEWContext, const size_t nDevIndex);

/*
获取客户端配置数据
[OUT] pbData：存储配置数据的缓冲区
[OUT] pnDataLen：传入时指向pnDataLen的缓冲区长度，传出时表示获取到的配置数据长度
*/
int EWALLET_API PAEW_GetClientConfigData(unsigned char * const pbData, size_t * const pnDataLen);

/*
获取设备校验码
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[OUT] pbCheckCode：存储校验码的缓冲区，不可为NULL
[OUT] pnCheckCodeLen：传入时指向pbCheckCode的字节长度，传出时表示获取到的校验码的长度
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_GetDeviceCheckCode(void * const pPAEWContext, const size_t nDevIndex, unsigned char * const pbCheckCode, size_t * const pnCheckCodeLen);

/*
获取ERC20记录列表
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[OUT] pERC20InfoList：存储ERC20信息的缓冲区，不可为NULL
[OUT] pnERC20InfoCount：传入时指向pERC20InfoList的元素个数，传出时表示获取到的PAEW_ECR20Info的元素个数
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_GetERC20List(void * const pPAEWContext, const size_t nDevIndex, PAEW_ERC20Info * const pERC20InfoList, size_t * const pnERC20InfoCount);

/*
设置ERC20记录信息
[IN] pPAEWContext：上下文结构体指针，不可为NULL
[IN] nDevIndex：操作的设备索引号，范围为[0, nDevCount-1]
[IN] pbERC20RecordData：存储ERC20记录的缓冲区，不可为NULL
[IN] nERC20RecordLen：pbERC20RecordData的字节长度
[RETURN] PAEW_RET_SUCCESS为成功，非PAEW_RET_SUCCESS值为失败
*/
int EWALLET_API PAEW_ImportERC20Record(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbERC20RecordData, const size_t nERC20RecordLen);

#ifdef __cplusplus
};
#endif
#endif //_PA_EWALLET_H_