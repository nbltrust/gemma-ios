/**
 *\file		PA_EWallet.h
 *\brief	Header File of EWallet Middleware
 */

/**
 * \mainpage EWallet Middleware
 * 
 * EWallet Middleware is used for connecting and operating wookong-solo / wookong-dragonball / wookong-bio. Useful functions can be found \ref group_functions "here".
 * 
 * \section sec_guid Common Guide
 *
 * \subsection subsec_connect Connect and disconnect device
 * Connect devices using PAEW_InitContext() or PAEW_InitContextWithDevName(), and if the function returns #PAEW_RET_SUCCESS, the \p ppPAEWContext argument will contain a context variable which is very important for later use. Disconnect device using PAEW_FreeContext(), and the context variable must be passed to disconnect device and free internal memory.
 * \code
int test_ewallet_default()
{
	int    iRtn = -1;

	void            *pPAEWContext = 0;
	size_t          nDevCount;

	iRtn = PAEW_InitContext(&pPAEWContext, &nDevCount);
	if (iRtn != PAEW_RET_SUCCESS)
	{
		iRtn = -1;
		goto END;
	}

	iRtn = 0;
END:
	PAEW_FreeContext(pPAEWContext);
	return iRtn;
}
 * \endcode
 * 
 * \subsection subsec_init Initialize wallet
 * Device without seed (usually brand new or formatted) needs to be initialized before signing transaction. In this case, the life cycle of device info is #PAEW_DEV_INFO_LIFECYCLE_PRODUCE. After initialize, life cycle will change to #PAEW_DEV_INFO_LIFECYCLE_USER. User has two approaches to initialize device.
 * - Generate seed
 *   Using PAEW_GenerateSeed() for solo and dragon ball device or using PAEW_GenerateSeed_GetMnes() + PAEW_GenerateSeed_CheckMnes() for bio device.
 * \code
//for solo device
PAEW_GenerateSeed(pPAEWContext, 0, 16, 0, 0);

//for dragon ball device
PAEW_GenerateSeed(pPAEWContext, 0, 0, (uint8_t)nDevCount, (uint8_t)(nDevCount - 1));

//for bio device
PAEW_GenerateSeed_GetMnes(pPAEWContext, 0, 32, pbMneWord, &nMneWordLen, pnCheckIndex, &nCheckIndexCount);
//...after user backup mnemonics and inputs mnemonics to be checked
PAEW_GenerateSeed_CheckMnes(pPAEWContext, 0, szCheckMneWord, strlen(szCheckMneWord));
 * \endcode
 * - Import mnemonics
 *   Using PAEW_ImportSeed()
 * \code
const unsigned char	*pbMneWord = (const unsigned char*)"mass dust captain baby mass dust captain baby mass dust captain baby mass dust captain baby mass electric";
PAEW_ImportSeed(pPAEWContext, i, pbMneWord, strlen((const char*)pbMneWord));
 * \endcode
 *
 * \subsection sebsec_sign Using wallet to sign transaction
 * Device with life cycle #PAEW_DEV_INFO_LIFECYCLE_USER can be used to sign transaction of different coins (BTC/ETH/ETC/EOS/...). Before signing, device has no private key inside it, so we need to invoke PAEW_DeriveTradeAddress() to derive private key from seed using derive path (<a href="https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki">BIP32</a>, <a href="https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki">BIP44</a>). Then, after private key is derived, user can get public key and address of specific coin type using PAEW_GetTradeAddress(), or sign ETH transaction using PAEW_ETH_SetTX() and PAEW_ETH_GetSignResult() / PAEW_ETH_GetSignResult_DragonBall().
 * \code
const uint32_t		puiETHPath[] = { 0, 0x8000002c, 0x8000003c, 0x80000000, 0x00000000, 0x00000000 };
const unsigned char	pbETHCurrentTX[] = { 0xec, 0x09, 0x85, 0x04, 0xa8, 0x17, 0xc8, 0x00, 0x82, 0x52, 0x08, 0x94, 0x35, 0x35, 0x35, 0x35, 0x35, 0x35, 0x35, 0x35, 0x35, 0x35, 0x35, 0x35, 0x35, 0x35, 0x35, 0x35, 0x35, 0x35, 0x35, 0x35, 0x88, 0x0d, 0xe0, 0xb6, 0xb3, 0xa7, 0x64, 0x00, 0x00, 0x80, 0x01, 0x80, 0x80 };

unsigned char	pbAddressData[PAEW_COIN_ADDRESS_MAX_LEN] = { 0 };
size_t			nAddressDataLen = 0;
unsigned char	pbETHTXSig[PAEW_ETH_SIG_MAX_LEN] = { 0 };
size_t			nETHTXSigLen = PAEW_ETH_SIG_MAX_LEN;

//derive private key
PAEW_DeriveTradeAddress(pPAEWContext, 0, PAEW_COIN_TYPE_ETH, puiETHPath, sizeof(puiETHPath) / sizeof(puiETHPath[0]));

//get ETH address
nAddressDataLen = sizeof(pbAddressData);
PAEW_GetTradeAddress(pPAEWContext, 0, PAEW_COIN_TYPE_ETH, 0, pbAddressData, &nAddressDataLen);

//sign ETH transaction
nETHTXSigLen = sizeof(pbETHTXSig);
PAEW_ETH_TXSign(pPAEWContext, 0, pbETHCurrentTX, sizeof(pbETHCurrentTX), pbETHTXSig, &nETHTXSigLen);
 * \endcode
 */

#ifndef _PA_EWALLET_H_
#define _PA_EWALLET_H_

#include <stdint.h>

#ifndef _WIN32
#include <stddef.h> //for size_t
#endif //_WIN32

/**
 * \defgroup group_retvalue Return values
 */
///@{
#define PAEW_RET_SUCCESS					0x00000000 ///<success
#define PAEW_RET_UNKNOWN_FAIL				0x80000001 ///<unknown error
#define PAEW_RET_ARGUMENTBAD				0x80000002 ///<argument bad
#define PAEW_RET_HOST_MEMORY				0x80000003 ///<memory malloc failed, maybe insufficient memory on host
#define PAEW_RET_DEV_ENUM_FAIL				0x80000004 ///<device enumerate failed
#define PAEW_RET_DEV_OPEN_FAIL				0x80000005 ///<device open(connect) failed
#define PAEW_RET_DEV_COMMUNICATE_FAIL		0x80000006 ///<device communicate failed, usually caused by disconnect
#define PAEW_RET_DEV_NEED_PIN				0x80000007 ///<device not login, need PIN verification
#define PAEW_RET_DEV_OP_CANCEL				0x80000008 ///<current operation on device is cancelled
#define PAEW_RET_DEV_KEY_NOT_RESTORED		0x80000009 ///<current operation needs key restored
#define PAEW_RET_DEV_KEY_ALREADY_RESTORED	0x8000000A ///<current operation doesn’t need key restored
#define PAEW_RET_DEV_COUNT_BAD				0x8000000B ///<errors such as no device, or device count must equal to N when initiating, device count must >= T and <= N when restore or sign
#define PAEW_RET_DEV_RETDATA_INVALID		0x8000000C ///<received data length less than 2 or ret data structure invalid
#define PAEW_RET_DEV_AUTH_FAIL				0x8000000D ///<current operation is failed because of device authentication error
#define PAEW_RET_DEV_STATE_INVALID			0x8000000E ///<life cycle or other device state not matched to current operation
#define PAEW_RET_DEV_WAITING				0x8000000F ///<waiting for user to operate on device
#define PAEW_RET_DEV_COMMAND_INVALID		0x80000010 ///<command cannot recognized by device
#define PAEW_RET_DEV_RUN_COMMAND_FAIL		0x80000011 ///<data returned by device indicates some common errors
#define PAEW_RET_DEV_HANDLE_INVALID			0x80000012 ///<invalid device handle
#define PAEW_RET_COS_TYPE_INVALID			0x80000013 ///<value of COS type must be PAEW_DEV_INFO_COS_TYPE_XXX
#define PAEW_RET_COS_TYPE_NOT_MATCH			0x80000014 ///<device cos type not matched to current operation, such as dragon ball spec function calls on personal e-wallet, or passed argument implies specific cos type while current cos type not match, or current inserted devices' types are not the same
#define PAEW_RET_DEV_BAD_SHAMIR_SPLIT		0x80000015 ///<errors when calculating shamir data
#define PAEW_RET_DEV_NOT_ONE_GROUP			0x80000016 ///<dragon ball devices not belong to one group
#define PAEW_RET_BUFFER_TOO_SAMLL			0x80000017 ///<size of input buffer not enough to store return data
#define PAEW_RET_TX_PARSE_FAIL				0x80000018 ///<input transaction parse failed
#define PAEW_RET_TX_UTXO_NEQ				0x80000019 ///<count of input and UTXO is not equal
#define PAEW_RET_TX_INPUT_TOO_MANY			0x8000001A ///<input count shouldn't larger than 100
#define PAEW_RET_MUTEX_ERROR				0x8000001B ///<mutex error, such as create / free / lock / unlock
#define PAEW_RET_COIN_TYPE_INVALID			0x8000001C ///<value of coin type must be PAEW_COIN_TYPE_XXX
#define PAEW_RET_COIN_TYPE_NOT_MATCH		0x8000001D ///<value of coin type must be equal to the value passed to PAEW_DeriveTradeAddress
#define PAEW_RET_DERIVE_PATH_INVALID		0x8000001E ///<derive path must start by 0x00000000, indicates m
#define PAEW_RET_NOT_SUPPORTED				0x8000001F ///<operation not supportted
#define PAEW_RET_INTERNAL_ERROR				0x80000020 ///<library internal errors, such as internal structure definition mistake
#define PAEW_RET_BAD_N_T					0x80000021 ///<value of N or T is invalid
#define PAEW_RET_TARGET_DEV_INVALID			0x80000022 ///<when getting address or signing, dragon ball must select a target device by calling PAEW_DeriveTradeAddress successfully first
#define PAEW_RET_CRYPTO_ERROR				0x80000023 ///<errors of cryption
#define PAEW_RET_DEV_TIMEOUT				0x80000024 ///<operation time out
#define PAEW_RET_DEV_PIN_LOCKED				0x80000025 ///<PIN locked
#define PAEW_RET_DEV_PIN_CONFIRM_FAIL		0x80000026 ///<set new pin error when confirm
#define PAEW_RET_DEV_PIN_VERIFY_FAIL		0x80000027 ///<input pin error when change pin or do other operation
#define PAEW_RET_DEV_CHECKDATA_FAIL			0x80000028 ///<input data check failed in device, usually caused by invalid CRC check
#define PAEW_RET_DEV_DEV_OPERATING			0x80000029 ///<user is operating device, please wait
#define PAEW_RET_DEV_PIN_UNINIT				0x8000002A ///<PIN not initialized
#define PAEW_RET_DEV_BUSY					0x8000002B ///<device is busy, such as when enroll or verify finger print, previous operation is not finished yet
#define PAEW_RET_DEV_ALREADY_AVAILABLE		0x8000002C ///<device is available, not need to abort again
#define PAEW_RET_DEV_DATA_NOT_FOUND			0x8000002D ///<required data is not found
#define PAEW_RET_DEV_SENSOR_ERROR			0x8000002E ///<sensor (such as finger print sensor) error
#define PAEW_RET_DEV_STORAGE_ERROR			0x8000002F ///<device storage error
#define PAEW_RET_DEV_STORAGE_FULL			0x80000030 ///<device storage full
#define PAEW_RET_DEV_FP_COMMON_ERROR		0x80000031 ///<finger print common error (such as finger print verify or enroll error)
#define PAEW_RET_DEV_FP_REDUNDANT			0x80000032 ///<finger print redundant error
#define PAEW_RET_DEV_FP_GOOG_FINGER			0x80000033 ///<finger print enroll step success
#define PAEW_RET_DEV_FP_NO_FINGER			0x80000034 ///<sensor haven't got any finger print
#define PAEW_RET_DEV_FP_NOT_FULL_FINGER		0x80000035 ///<sensor haven't got full finger print image
#define PAEW_RET_DEV_FP_BAD_IMAGE			0x80000036 ///<sensor haven't got valid image
#define PAEW_RET_DEV_LOW_POWER				0x80000037 ///<device power is too low
#define PAEW_RET_DEV_TYPE_INVALID			0x80000038 ///<invalid device type
#define PAEW_RET_NO_VERIFY_COUNT			0x80000039 ///<count of verification run out when doing signature
#define PAEW_RET_AUTH_CANCEL				0x8000003A ///<not used yet
#define PAEW_RET_PIN_LEN_ERROR				0x8000003B ///<PIN length error
#define PAEW_RET_AUTH_TYPE_INVALID			0x8000003C ///<authenticate type invalid
///@}

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

/**
 * \defgroup group_callbacks Callbacks
 */
///@{
typedef int(*tFunc_Progress_Callback)(void * const pCallbackContext, const size_t nProgress); ///<Callback to indicate progress of a long-time function

typedef int(*tFunc_PutState_Callback)(void * const pCallbackContext, const int nState); ///<Callback to indicate button or finge rprint loop state

typedef int(*tFunc_GetAuthType)(void * const pCallbackContext, unsigned char * const pnAuthType); ///<\deprecated This function type is only used for compatible reason, and will be removed soon
typedef int(*tFunc_GetPIN)(void * const pCallbackContext, unsigned char * const pbPIN, size_t * const pnPINLen); ///<\deprecated This function type is only used for compatible reason, and will be removed soon
typedef int(*tFunc_PutSignState)(void * const pCallbackContext, const int nSignState); ///<\deprecated This function type is only used for compatible reason, and will be removed soon
/**
* \deprecated This structure is only used for compatible reason, and will be removed soon
*/
typedef struct _signCallbacks {
	tFunc_GetAuthType    getAuthType; ///<when sign function is invoked, getAuthType is called firstly, to get authenticate type which user chose or set by app, and should return PAEW_SIGN_AUTH_TYPE_XXX by pnAuthType
	tFunc_GetPIN        getPIN; ///<if pnAuthType is PAEW_SIGN_AUTH_TYPE_PIN, this function is called to let app inject PIN value to sign procedure
	tFunc_PutSignState    putSignState; ///<this function is called multiple times when waiting for sign procedure is completed, sign state can be one of the values of PAEW_RET_XXXX
} signCallbacks;

///@}

/**
 * \defgroup group_devinfo_type Device info type
 */
///@{
#define PAEW_DEV_INFOTYPE_PIN_STATE		0x00000001 ///<PIN state, such as un-login / login / unset / locked
#define PAEW_DEV_INFOTYPE_COS_TYPE		0x00000002 ///<COS type, such as dragon ball or personal
#define PAEW_DEV_INFOTYPE_CHAIN_TYPE	0x00000004 ///<chain type, such as formal net or test net
#define PAEW_DEV_INFOTYPE_SN			0x00000008 ///<device serial number
#define PAEW_DEV_INFOTYPE_COS_VERSION	0x00000010 ///<COS version
#define PAEW_DEV_INFOTYPE_LIFECYCLE		0x00000020 ///<device life cycle, such as agreement / user / produce
#define PAEW_DEV_INFOTYPE_SESSKEY_HASH	0x00000040 ///<dragon ball device group hash
#define PAEW_DEV_INFOTYPE_N_T			0x00000080 ///<dragon ball device N / T
#define PAEW_DEV_INFOTYPE_LCD_STATE		0x00000100 ///<device screen state
///@}

/**
 * \defgroup group_pin_state PIN state
 */
///@{
#define PAEW_DEV_INFO_PIN_INVALID_STATE		0xFF ///<invalid PIN state
#define PAEW_DEV_INFO_PIN_LOGOUT			0x00 ///<PIN not logged-in
#define PAEW_DEV_INFO_PIN_LOGIN				0x01 ///<PIN logged-in
#define PAEW_DEV_INFO_PIN_LOCKED			0x02 ///<PIN locked
#define PAEW_DEV_INFO_PIN_UNSET				0x03 ///<PIN not initialized
///@}

/**
 * \defgroup group_chain_type Chain type
 */
///@{
#define PAEW_DEV_INFO_CHAIN_TYPE_FORMAL		0x01 ///<formal chain
#define PAEW_DEV_INFO_CHAIN_TYPE_TEST		0x02 ///<test chain
///@}

/**
 * \defgroup group_sn Device serial number
 */
/// @{
#define PAEW_DEV_INFO_SN_LEN				0x20 ///<max length of serial number
/// @}

/**
 * \defgroup group_cos_version COS version
 * 1st byte means cos architecture, usually essential cos upgrade
 * 2nd byte means cos type, currently 00 dragon ball, 01 personal wallet, 02 biometric wallet
 * 3rd and 4th bytes means minor version
 */
/// @{
#define PAEW_DEV_INFO_COS_VERSION_LEN		0x04 ///<COS version length
/// @}

/**
 * \defgroup group_cos_type COS type
 */
/// @{
#define PAEW_DEV_INFO_COS_TYPE_INDEX		0x01 ///<index of COS type
#define PAEW_DEV_INFO_COS_TYPE_INVALID		0xFF ///<invalid COS type
#define PAEW_DEV_INFO_COS_TYPE_DRAGONBALL	0x00 ///<dragon ball wallet
#define PAEW_DEV_INFO_COS_TYPE_PERSONAL		0x01 ///<personal wallet
#define PAEW_DEV_INFO_COS_TYPE_BIO			0x02 ///<biometric wallet
/// @}

/**
 * \defgroup group_dev_lifecycle Device lifecycle
 */
/// @{
#define PAEW_DEV_INFO_LIFECYCLE_INVALID		0xFF ///<invalid lifecycle
#define PAEW_DEV_INFO_LIFECYCLE_AGREE		0x01 ///<production state
#define PAEW_DEV_INFO_LIFECYCLE_USER		0x02 ///<normal state
#define PAEW_DEV_INFO_LIFECYCLE_PRODUCE		0x04 ///<not generate seed
/// @}

/**
 * \defgroup group_dragonball_dev_info Dragon ball device info
 */
/// @{
#define PAEW_DEV_INFO_SESSKEY_HASH_LEN		0x04 ///<length of dragon ball group hash
#define PAEW_DEV_INFO_N_T_INVALID			0xFF ///<dragon ball N/T
/// @}

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

/**
 * \brief Device info structure
 */
typedef struct _PAEW_DevInfo
{
	unsigned char	ucPINState; ///<PIN state, valid values are PAEW_DEV_INFO_PIN_XX
	unsigned char	ucCOSType; ///<COS type, valid values are PAEW_DEV_INFO_COS_TYPE_XXX
	unsigned char	ucChainType; ///<chain type, valid values are PAEW_DEV_INFO_CHAIN_TYPE_XXX
	unsigned char	pbSerialNumber[PAEW_DEV_INFO_SN_LEN]; ///<device serial number, current content is ASCII string
	unsigned char	pbCOSVersion[PAEW_DEV_INFO_COS_VERSION_LEN]; ///<device COS version
	unsigned char	ucLifeCycle; ///<device life cycle, valid values are PAEW_DEV_INFO_LIFECYCLE_XXX
	uint64_t		nLcdState; ///<screen state, valid values are PAEW_DEV_INFO_LCD_XXX

	//dragon ball device info
	unsigned char	pbSessKeyHash[PAEW_DEV_INFO_SESSKEY_HASH_LEN]; ///<dragon ball device group hash
	uint8_t			nN; ///<group device count of dragon ball device
	uint8_t			nT; ///<minimum valid device count of dragon ball device
} PAEW_DevInfo;

/**
 * \defgroup group_coin_type Coin types
 */
/// @{
#define PAEW_COIN_TYPE_INVALID	0xFF ///<invalid coin type
#define PAEW_COIN_TYPE_BTC		0x00 ///<BTC
#define PAEW_COIN_TYPE_ETH		0x01 ///<ETH
#define PAEW_COIN_TYPE_CYB		0x02 ///<CYBEX
#define PAEW_COIN_TYPE_EOS		0x03 ///<EOS
#define PAEW_COIN_TYPE_LTC		0x04 ///<LTC
#define PAEW_COIN_TYPE_NEO		0x05 ///<NEO
#define PAEW_COIN_TYPE_ETC		0x06 ///<ETC
#define PAEW_COIN_TYPE_BTC_WIT	0x07 ///<BTC P2WPKH nested in BIP16 P2SH
#define PAEW_COIN_TYPE_BTC_SIGWIT	0x08 ///<BTC P2WPKH
#define PAEW_COIN_TYPE_XRP	0x09 ///<XRP
#define PAEW_COIN_TYPE_USDT		0x0A ///<USDT，only used by PAEW_GetTradeAddress
/// @}

/**
 * \defgroup group_sig_constant Signature related constants
 */
/// @{
#define PAEW_BTC_SIG_MAX_LEN			0x70 ///<BTC max signature length
#define PAEW_ETH_SIG_MAX_LEN			0x45 ///<ETH max signature length
#define PAEW_ETC_SIG_MAX_LEN			0x45 ///<ETC max signature length
#define PAEW_CYB_SIG_MAX_LEN			0x41 ///<CYB max signature length

#define PAEW_EOS_SIG_MAX_LEN			0x80 ///<EOS max signature length
#define PAEW_SIG_EOS_TX_HEADER			0x00 ///<EOS header
#define PAEW_SIG_EOS_TX_ACTION_COUNT	0x01 ///<EOS action count
#define PAEW_SIG_EOS_TX_ACTION			0x02 ///<EOS action
#define PAEW_SIG_EOS_TX_CF_HASH			0x03 ///<EOS context_free hash

#define PAEW_LTC_SIG_MAX_LEN			0x70 ///<LTC max signature length
#define PAEW_NEO_SIG_MAX_LEN			0x70 ///<NEO max signature length
#define PAEW_BTC_WIT_SIG_MAX_LEN		0x70 ///<BTC WITNESS max signature length
#define PAEW_XRP_SIG_MAX_LEN			0x70 ///<XRP max signature length
/// @}

/**
 * \defgroup group_images Image and screen
 */
/// @{
#define PAEW_IMAGE_NAME_MAX_LEN		63 ///<image name max len
#define PAEW_LCD_CLEAR				0x00 ///<clear screen
#define PAEW_LCD_SHOW_LOGO			0x01 ///<show logo on screen
#define PAEW_LCD_CLEAR_SHOW_LOGO	0x02 ///<clear screen and then show logo on screen
/// @}

/**
* \defgroup group_dev_type Device type
*/
/// @{
#define PAEW_DEV_TYPE_INVALID	0xFF ///<invalid device type
#define PAEW_DEV_TYPE_HID		0x00 ///<HID device
#define PAEW_DEV_TYPE_BT		0x01 ///<blue tooth device
/// @}

/**
 * \defgroup group_sign_auth_type Signature authenticate type
 */
/// @{
#define PAEW_SIGN_AUTH_TYPE_PIN		0x00 ///<sign authenticate type: PIN
#define PAEW_SIGN_AUTH_TYPE_FP		0x01 ///<sign authenticate type: Fingerprint
/// @}

/**
 * \defgroup group_other_constant Other constant
 */
/// @{
#define INVALID_DEV_INDEX			((size_t)(-1)) ///<invalid device index
#define PAEW_COIN_ADDRESS_MAX_LEN		0x80 ///<coin address max len
#define PAEW_ROOT_SEED_LEN				0x40 ///<root seed len

#define PAEW_MNE_MAX_LEN			512 ///<mnemonic max len
#define PAEW_MNE_INDEX_MAX_COUNT	32 ///<mnemonic max count

#define PAEW_PIN_MAX_LEN	0x20 ///<PIN max len

#define PAEW_PUBLIC_KEY_MAX_LEN		0x60 ///<public key max len
/// @}

/**
 * \defgroup group_fp_id Fingerprint ID
 */
///@{
#define PAEW_FP_ID_LEN	0x01 ///<length of Fingerprint ID

/**
 * \brief Fingerprint ID structure
 */
typedef struct _FingerPrintID
{
	unsigned char	data[PAEW_FP_ID_LEN]; ///<finger print ID data
} FingerPrintID;
/// @}

/**
 * \defgroup group_erc20_info ERC20 token info
 */
/// @{
#define PAEW_ERC20_TOKEN_NAME_MAX_LEN	0x08 ///<Token name max len
#define PAEW_ERC20_TOKEN_ADDRESS_LEN	0x14 ///<Token address len
/**
 * \brief ERC20 info structure
 */
typedef struct _PAEW_ERC20Info
{
	unsigned char	pbTokenName[PAEW_ERC20_TOKEN_NAME_MAX_LEN]; ///<Token name
	unsigned char	nTokenPrecision; ///<Token precision
	unsigned char	pbTokenAddress[PAEW_ERC20_TOKEN_ADDRESS_LEN]; ///<Token address
} PAEW_ERC20Info;
/// @}


/**
 * \defgroup group_fw_version Firmware version
 */
/// @{
#define PAEW_FW_VERSION_MAJORVSERION_LEN	0x04 ///<Major version length
#define PAEW_FW_VERSION_CHIP_VERSION_LEN	0x04 ///<Chip version length
#define PAEW_FW_VERSION_MINORVSERION_LEN	0x04 ///<Minor version length
#define PAEW_FW_VERSION_LOADERVSERION_LEN	0x04 ///<Loader version length
#define PAEW_FW_VERSION_ALGVSERION_MAX_LEN	0x20 ///<Algorithm version max length
/**
 * \brief Firmware version structure
 */
typedef struct _PAEW_FWVersion
{
	unsigned char	nIsUserFW; ///<User or loader FW
	unsigned char	pbMajorVersion[PAEW_FW_VERSION_MAJORVSERION_LEN]; ///<Major version
	unsigned char	pbUserChipVersion[PAEW_FW_VERSION_CHIP_VERSION_LEN]; ///<User chip version
	unsigned char	pbMinorVersion[PAEW_FW_VERSION_MINORVSERION_LEN]; ///<Minor version
	unsigned char	pbLoaderChipVersion[PAEW_FW_VERSION_CHIP_VERSION_LEN]; ///<Loader chip version
	unsigned char	pbLoaderVersion[PAEW_FW_VERSION_LOADERVSERION_LEN]; ///<Loader version
	unsigned char	pbAlgVersion[PAEW_FW_VERSION_ALGVSERION_MAX_LEN]; ///<Algorithm version
	size_t			nAlgVersionLen; ///<Algorithm version length
} PAEW_FWVersion;
/// @}

/**
 * \defgroup group_functions Middleware functions
 */
///@{

/**
 * \brief		Get library version
 * \param[out]	pbVersion		buffer to store library version, defined as follows: PA_VERSION_PRODUCT || PA_VERSION_RESERVED || PA_VERSION_MAJOR || PA_VERSION_MINOR and value of PA_VERSION_PRODUCT could be: PA_PRODUCT_WOOKONG (1) or PA_PRODUCT_TIDE (2) or PA_PRODUCT_WOOKONG_SOLO (3) or PA_PRODUCT_WOOKONG_BIO (4)
 * \param[out]	pnVersionLen	length of version data
 * \return		#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
 */
int EWALLET_API PAEW_GetLibraryVersion(unsigned char * const pbVersion, size_t * const pnVersionLen);

/**
 * \brief			Get device list with device context
 * \param[in]		nDeviceType		device Type, valid values are PAEW_DEV_TYPE_XXX (\ref group_dev_type)
 * \param[out]		szDeviceNames	buffer used to store device name list when this function succeeds. Format of name list is: devName1 + \0 + devName2 + \0 + ... + devNameN + \0\0
 * \param[in,out]	pnDeviceNameLen	this value represents size of szDevNames when input, and represents valid length of name list when output, should not be NULL
 * \param[out]		pnDevCount		device count
 * \param[in]		pDevContext		device context
 * \param[in]		nDevContextLen	device context length
 * \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
 */
int EWALLET_API PAEW_GetDeviceListWithDevContext(const unsigned char nDeviceType, char * const szDeviceNames, size_t * const pnDeviceNameLen, size_t * const pnDevCount, void * const pDevContext, const size_t nDevContextLen);

/**
 * \brief			Initialize context and connect devices
 * \param[out]		ppPAEWContext	address used to store the value of address used to record initialized library context, shouldn't be NULL, and must be passed to PAEW_FreeContext() to free memory when not used anymore
 * \param[out]		pnDevCount		contains device count when function success
 * \param[in]		pDevContext		device context
 * \param[in]		nDevContextLen	device context length
 * \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
 */
int EWALLET_API PAEW_InitContextWithDevContext(void ** const ppPAEWContext, size_t * const pnDevCount, void * const pDevContext, const size_t nDevContextLen);

/**
* \brief			Initialize context and connect devices
* \param[out]		ppPAEWContext	address used to store the value of address used to record initialized library context, shouldn't be NULL, and must be passed to PAEW_FreeContext() to free memory when not used anymore
* \param[out]		pnDevCount		contains device count when function success
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_InitContext(void ** const ppPAEWContext, size_t * const pnDevCount);

/**
* \brief			Initialize context and connect device (specify device name) using device context
* \param[out]		ppPAEWContext	address used to store the value of address used to record initialized library context, shouldn't be NULL, and must be passed to PAEW_FreeContext() to free memory when not used anymore
* \param[in]		szDeviceName	device name composed by 3 parts (could be found in node-usb usb detection procedure): "busNumber:deviceAddress:interfaceNumber", formatted in "%04x:%04x:%02x", or blue tooth address in format of "xx:xx:xx:xx"
* \param[in]		nDeviceType		device type, valid values are PAEW_DEV_TYPE_XXX (\ref group_dev_type)
* \param[in]		pDevContext		device context
* \param[in]		nDevContextLen	device context length
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_InitContextWithDevNameAndDevContext(void ** const ppPAEWContext, const char * const szDeviceName, const unsigned char nDeviceType, void * const pDevContext, const size_t nDevContextLen);

/**
* \brief			Initialize context and connect device (specify device name)
* \param[out]		ppPAEWContext	address used to store the value of address used to record initialized library context, shouldn't be NULL, and must be passed to PAEW_FreeContext() to free memory when not used anymore
* \param[in]		szDeviceName	device name composed by 3 parts (could be found in node-usb usb detection procedure): "busNumber:deviceAddress:interfaceNumber", formatted in "%04x:%04x:%02x", or blue tooth address in format of "xx:xx:xx:xx"
* \param[in]		nDeviceType		device type, valid values are PAEW_DEV_TYPE_XXX (\ref group_dev_type)
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_InitContextWithDevName(void ** const ppPAEWContext, const char * const szDeviceName, const unsigned char nDeviceType);


/**
* \brief			Free context and disconnect device
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_InitContext(), PAEW_InitContextWithDevContext(), PAEW_InitContextWithDevName(), PAEW_InitContextWithDevNameAndDevContext()
*/
int EWALLET_API PAEW_FreeContext(void * const pPAEWContext);

/**
* \brief			Set device context to library context
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pDevContext		device context
* \param[in]		nDevContextLen	device context length
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_SetDevContext(void * const pPAEWContext, const size_t nDevIndex, void * const pDevContext, const size_t nDevContextLen);

/**
* \brief			Get device context from library context
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[out]		ppDevContext	device context
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_GetDevContext(void * const pPAEWContext, const size_t nDevIndex, void ** const ppDevContext);

/**
* \brief			Get firmware version (used only by bio device)
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[out]		pFWVersion		returned firmware version, shouldn't be NULL
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_GetFWVersion(void * const pPAEWContext, const size_t nDevIndex, PAEW_FWVersion * const pFWVersion);

/**
* \brief			Get device info
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nDevInfoType	device info types user want to get, valid values should be ORs of PAEW_DEV_INFOTYPE_XXX (\ref group_devinfo_type)
* \param[out]		pDevInfo		returned device info, shouldn't be NULL
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				\ref group_devinfo_type
*/
int EWALLET_API PAEW_GetDevInfo(void * const pPAEWContext, const size_t nDevIndex, const uint32_t nDevInfoType, PAEW_DevInfo * const pDevInfo);

/**
* \brief			Generate seed to initialize device
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nSeedLen		(used only by solo device) length of seed corresponding to mnemonics, valid range of values is [16, 32], and must be multiples of 4
* \param[in]		nN				(used only by dragon ball device) system parameter, count of parts which seed be separated into, 4<=N<=7, and must be equal to device count currently connected to host device 
* \param[in]		nT				(used only by dragon ball device) system parameter, count of devices needed when restore seed, 2<=M<=N
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_GenerateSeed(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nSeedLen, const uint8_t nN, const uint8_t nT);

/**
* \brief			Generate seed to initialize device - step 1/2, get mnemonics (used only by bio device)
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nSeedLen		(used only by solo device) length of seed corresponding to mnemonics, valid range of values is [16, 32], and must be multiples of 4
* \param[out]		pbMneWord		buffer to store generated mnemonics, shouldn't be NULL
* \param[in,out]	pnMneWordLen	contains size of \p pbMneWord when input, and contains actual length of mnemonics when output
* \param[out]		pnCheckIndex	buffer to store indexes of mnemonics which need to be checked using PAEW_GenerateSeed_CheckMnes()
* \param[in,out]	pnCheckIndexCount	contains amount of elements of \p pnCheckIndex when input, and contains actual amount of mnemonics need to be checked when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_GenerateSeed_CheckMnes()
*/
int EWALLET_API PAEW_GenerateSeed_GetMnes(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nSeedLen, unsigned char * const pbMneWord, size_t * const pnMneWordLen, size_t * const pnCheckIndex, size_t * const pnCheckIndexCount);

/**
* \brief			Check Generate seed to initialize device - step 2/2, check mnemonics (used only by bio device)
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pbMneWord		mnemonics need to be checked, each word should be separated by 1 space, shouldn't be NULL
* \param[in]		nMneWordLen		buffer size of \p pbMneWord
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_GenerateSeed_GetMnes()
*/
int EWALLET_API PAEW_GenerateSeed_CheckMnes(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbMneWord, const size_t nMneWordLen);

/**
* \brief			Import seed into device to initialize device (used only by non-dragonball device)
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pbMneWord		mnemonics need to be imported, shouldn't be NULL
* \param[in]		nMneWordLen		buffer size of \p pbMneWord
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_ImportSeed(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbMneWord, const size_t nMneWordLen);

/**
* \brief			Recover seed from mnemonics (algorithm implemented by software)
* \param[in]		pbWordBuf		buffer contains mnemonics, shouldn't be NULL
* \param[in]		nWordBufLen		buffer size of \p pbWordBuf
* \param[out]		pbPrvSeed		seed restored from mnemonics, shouldn't be NULL
* \param[in,out]	pnPrvSeedLen	contains size of \p pbPrvSeed when input, and contains actual length of seed when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_RecoverSeedFromMne(const unsigned char * const pbWordBuf, const size_t nWordBufLen, unsigned char * const pbPrvSeed, size_t * const pnPrvSeedLen);

/**
* \brief			Recover seed from mnemonics group (algorithm implemented by software)
* \param[in]		nGroupCount		group count of input sentences, shouldn't be NULL
* \param[in]		ppbWordBuf		each of which contains a sentence composed by mnemonics, shouldn't be NULL
* \param[in]		pnWordBufLen		each of which contains length of sentence corresponding to the same position of \p ppbWordBuf, shouldn't be NULL
* \param[out]		pbMneWord		mnemonics restored from sentences, shouldn't be NULL
* \param[in,out]	pnMneWordLen	contains size of \p pbMneWord when input, and contains actual length of mnemonics when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_RecoverMneFromMneGroup(const size_t nGroupCount, const unsigned char * const * const ppbWordBuf, const size_t * const pnWordBufLen, unsigned char * const pbMneWord, size_t * const pnMneWordLen);

/**
* \brief			Get trade address from seed (algorithm implemented by software)
* \param[in]		pbSeed			seed used as root of derivation, shouldn't be NULL
* \param[in]		nSeedLen		length of \p pbSeed
* \param[in]		puiDerivePath	derive path, shouldn't be NULL, and first element must be 0, indicating m (from seed to master private key), shouldn't be NULL
* \param[in]		nDerivePathLen	count of derive path elements, not less than 1
* \param[out]		pbPrivateKey	private key derived from seed, shouldn't be NULL
* \param[in,out]	pnPrivateKeyLen	contains size of \p pbPrivateKey when input, and contains actual length of private key when output
* \param[in]		bTestNet		whether derived address is used for test net, 0 is formal net, 1 is test net
* \param[in]		nCoinType		coin type, valid values are PAEW_COIN_TYPE_XXX (\ref group_coin_type)
* \param[out]		pbTradeAddress		trade address encoded according to \p nCoinType
* \param[in,out]	pnTradeAddressLen	contains size of \p pbTradeAddress when input, and contains actual length of address when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_GetTradeAddressFromSeed(const unsigned char * const pbSeed, const size_t nSeedLen, const uint32_t * const puiDerivePath, const size_t nDerivePathLen, unsigned char * const pbPrivateKey, size_t * const pnPrivateKeyLen, const unsigned char bTestNet, const unsigned char nCoinType, unsigned char * const pbTradeAddress, size_t * const pnTradeAddressLen);

/**
* \brief			Derive trade address, _MUST_ be invoked before PAEW_GetTradeAddress() / PAEW_GetPublicKey() / PAEW_BTC_SetTX() / PAEW_BTC_GetSignResult() / PAEW_BTC_GetSignResult_DragonBall() and signature functions for other coins
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nCoinType		coin type, valid values are PAEW_COIN_TYPE_XXX (\ref group_coin_type)
* \param[in]		puiDerivePath	derive path, shouldn't be NULL, and first element must be 0, indicating m (from seed to master private key), shouldn't be NULL
* \param[in]		nDerivePathLen	count of derive path elements, not less than 1
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_DeriveTradeAddress(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nCoinType, const uint32_t * const puiDerivePath, const size_t nDerivePathLen);

/**
* \brief			Get trade address, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nCoinType		coin type, valid values are PAEW_COIN_TYPE_XXX (\ref group_coin_type)
* \param[in]		nShowOnScreen	whether coin address showed on device screen, 0 means not shown, 1 means show address on screen
* \param[out]		pbTradeAddress		trade address encoded according to \p nCoinType
* \param[in,out]	pnTradeAddressLen	contains size of \p pbTradeAddress when input, and contains actual length of address when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_GetTradeAddress(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nCoinType, const unsigned char nShowOnScreen, unsigned char * const pbTradeAddress, size_t * const pnTradeAddressLen);

/**
* \brief			Get trade address, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nCoinType		coin type, valid values are PAEW_COIN_TYPE_XXX (\ref group_coin_type)
* \param[in]		nShowOnScreen	whether coin address showed on device screen, 0 means not shown, 1 means show address on screen
* \param[out]		pbTradeAddress		trade address encoded according to \p nCoinType
* \param[in,out]	pnTradeAddressLen	contains size of \p pbTradeAddress when input, and contains actual length of address when output
* \param[in]		pPutStateCallback	callback called when loop device button press
* \param[in]		pCallbackContext	callback context used by \p pPutStateCallback
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_GetTradeAddress_Ex(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nCoinType, const unsigned char nShowOnScreen, unsigned char * const pbTradeAddress, size_t * const pnTradeAddressLen, const tFunc_PutState_Callback pPutStateCallback, void * const pCallbackContext);

/**
* \brief			Get public key, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nCoinType		coin type, valid values are PAEW_COIN_TYPE_XXX (\ref group_coin_type)
* \param[out]		pbPublicKey		trade address encoded according to \p nCoinType
* \param[in,out]	pnPublicKeyLen	contains size of \p pbPublicKey when input, and contains actual length of public key when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_GetPublicKey(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nCoinType, unsigned char * const pbPublicKey, size_t * const pnPublicKeyLen);

/**
 * \brief		Set BTC transaction to device, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
 * \param[in]	pPAEWContext	library context, shouldn't be NULL
 * \param[in]	nDevIndex		(used only by personal device) index of device, valid range of value is [0, nDevCount-1]
 * \param[in]	nUTXOCount		count of UTXOs, must equal to input number of transaction to be singed
 * \param[in]	ppbUTXO			each of which contains one UTXO data
 * \param[in]	pnUTXOLen		each of which contains length of UTXO data corresponding to the same position of ppbUTXO
 * \param[in]	pbCurrentTX		transaction data to be signed
 * \param[in]	nCurrentTXLen	length of transaction data to be signed
 * \return		#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
 * \sa			PAEW_DeriveTradeAddress()
 */
int EWALLET_API PAEW_BTC_SetTX(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen);

/**
 * \brief			Get BTC signature (used only by non-dragon-ball device)
 * 
 * This function will not be blocked. More detailes: PAEW_ETH_GetSignResult(), _MUST_ be invoked after PAEW_BTC_SetTX() is called
 * \param[in]		pPAEWContext	library context, shouldn't be NULL
 * \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
 * \param[in]		nSignAuthType	(only for bio device) type of authentication when signature (\ref group_sign_auth_type)
 * \param[in]		nSignIndex		index of signature, valid range of value is [0, nUTXOCount-1]
 * \param[out]		pbTXSig			contains DER encoded signature data, shouldn't be NULL, signature structure: DERLen(1 byte) + DER + 01 + PublicKeyLen(1 byte) + PublicKey
 * \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
 * \return			#PAEW_RET_SUCCESS means success, #PAEW_RET_DEV_WAITING means device is waiting for user operation, and other value means failure (\ref group_retvalue)
 * \sa				PAEW_ETH_GetSignResult(), PAEW_BTC_SetTX()
 */
int EWALLET_API PAEW_BTC_GetSignResult(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nSignAuthType, const size_t nSignIndex, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
 * \brief			Get BTC signature (used only by dragon ball device), _MUST_ be invoked after PAEW_BTC_SetTX() is called
 *
 * This function may be blocked and wait user to check all the transaction information legal and press button
 * \param[in]		pPAEWContext	library context, shouldn't be NULL
 * \param[in]		nUTXOCount		count of UTXOs, must equal to input number of transaction to be singed
 * \param[out]		ppbTXSig		contains DER encoded signature data, each of which corresponds to one input of transaction data, and element count is the same to input count if shouldn't be NULL, signature structure: DERLen(1 byte) + DER + 01 + PublicKeyLen(1 byte) + PublicKey
 * \param[in,out]	pnTXSigLen		contains size of buffer corresponding to the same position of ppbTXSig when input, and contains actual lengths of signature data when output
 * \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
 * \sa				PAEW_BTC_SetTX()
 */
int EWALLET_API PAEW_BTC_GetSignResult_DragonBall(void * const pPAEWContext, const size_t nUTXOCount, unsigned char * const * const ppbTXSig, size_t * const pnTXSigLen);

/**
* \brief			BTC signature, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nUTXOCount		count of UTXOs, must equal to input number of transaction to be singed
* \param[in]		ppbUTXO			each of which contains one UTXO data
* \param[in]		pnUTXOLen		each of which contains length of UTXO data corresponding to the same position of ppbUTXO
* \param[in]		pbCurrentTX		transaction data to be signed
* \param[in]		nCurrentTXLen	length of transaction data to be signed
* \param[out]		ppbTXSig		contains DER encoded signature data, each of which corresponds to one input of transaction data, and element count is the same to input count if shouldn't be NULL, signature structure: DERLen(1 byte) + DER + 01 + PublicKeyLen(1 byte) + PublicKey
* \param[in,out]	pnTXSigLen		contains size of buffer corresponding to the same position of ppbTXSig when input, and contains actual lengths of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_BTC_TXSign(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const * const ppbTXSig, size_t * const pnTXSigLen);

/**
* \brief		Set ETH transaction to device, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
* \param[in]	pPAEWContext	library context, shouldn't be NULL
* \param[in]	nDevIndex		(used only by personal device) index of device, valid range of value is [0, nDevCount-1]
* \param[in]	pbCurrentTX		transaction data to be signed
* \param[in]	nCurrentTXLen	length of transaction data to be signed
* \return		#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa			PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_ETH_SetTX(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen);

/**
* \brief			Get ETH signature (used only by non-dragon-ball device), _MUST_ be invoked after PAEW_ETH_SetTX() is called
*
* This function will not be blocked.
*
* For non-bio device, the caller should invoke this function repeated until the return value is not #PAEW_RET_DEV_WAITING.
*
* For bio device, you can set \p nSignAuthType to #PAEW_SIGN_AUTH_TYPE_FP or #PAEW_SIGN_AUTH_TYPE_PIN:\n
* - If value of \p nSignAuthType is #PAEW_SIGN_AUTH_TYPE_FP, then this function should be called repeated if return value is #PAEW_RET_DEV_WAITING / #PAEW_RET_DEV_FP_COMMON_ERROR / #PAEW_RET_DEV_FP_NO_FINGER / #PAEW_RET_DEV_FP_NOT_FULL_FINGER. If return value is #PAEW_RET_NO_VERIFY_COUNT, then this means too many amount of wrong finger print authentication causes the signature operation failed, but caller can still invoke this function using \p nSignAuthType = #PAEW_SIGN_AUTH_TYPE_PIN WITHOUT calling PAEW_SwitchSign().\n
* - If value of \p nSignAuthType is #PAEW_SIGN_AUTH_TYPE_FP, then then this function should be called repeated if return value is #PAEW_RET_DEV_WAITING. If return value is #PAEW_RET_NO_VERIFY_COUNT, then this means too many amount of wrong PIN authentication causes the signature operation failed, but caller can still invoke this function using \p nSignAuthType = #PAEW_SIGN_AUTH_TYPE_FP WITHOUT calling PAEW_SwitchSign().\n
* - If user wants to switch from #PAEW_SIGN_AUTH_TYPE_FP to #PAEW_SIGN_AUTH_TYPE_PIN or opposite, and the retry count of original authentication type doesn't run out (hasn't returned #PAEW_RET_NO_VERIFY_COUNT), then the caller must invoke PAEW_SwitchSign() to switch between different authentication types.\n
* - If authentication retry count runs out for both #PAEW_SIGN_AUTH_TYPE_FP and #PAEW_SIGN_AUTH_TYPE_PIN, or this function returns #PAEW_RET_DEV_STATE_INVALID (which actually caused by timeout or not having set transaction before get sign result), device will changes its state automatically to normal. For other errors, the caller MUST call PAEW_AbortSign() to restore device state.\n
*
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nSignAuthType	(only for bio device) type of authentication when signature (\ref group_sign_auth_type)
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature structure: R(32 byte) + S(32byte) + V(1 byte)
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, #PAEW_RET_DEV_WAITING means device is waiting for user operation, and other value means failure (\ref group_retvalue)
* \sa				PAEW_ETH_SetTX()
*/
int EWALLET_API PAEW_ETH_GetSignResult(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nSignAuthType, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			Get ETH signature (used only by dragon ball device), _MUST_ be invoked after PAEW_ETH_SetTX() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature structure: R(32 byte) + S(32byte) + V(1 byte)
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_ETH_SetTX()
*/
int EWALLET_API PAEW_ETH_GetSignResult_DragonBall(void * const pPAEWContext, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			ETH signature, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pbCurrentTX		transaction data to be signed
* \param[in]		nCurrentTXLen	length of transaction data to be signed
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature structure: R(32 byte) + S(32byte) + V(1 byte)
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_ETH_TXSign(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			ETH signature with callbacks, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \deprecated		This function is only used for compatible reason, and will be removed soon
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pbCurrentTX		transaction data to be signed
* \param[in]		nCurrentTXLen	length of transaction data to be signed
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature structure: R(32 byte) + S(32byte) + V(1 byte)
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \param[in]		pSignCallbacks	callbacks called when the function proceeds
* \param[in]		pSignCallbackContext	callback context used by the callback function
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_ETH_TXSign_Ex(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen, const signCallbacks * const pSignCallbacks, void * const pSignCallbackContext);

/**
* \brief		Set ETC transaction to device, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
* \param[in]	pPAEWContext	library context, shouldn't be NULL
* \param[in]	nDevIndex		(used only by personal device) index of device, valid range of value is [0, nDevCount-1]
* \param[in]	pbCurrentTX		transaction data to be signed
* \param[in]	nCurrentTXLen	length of transaction data to be signed
* \return		#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa			PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_ETC_SetTX(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen);

/**
* \brief			Get ETC signature (used only by non-dragon-ball device), _MUST_ be invoked after PAEW_ETC_SetTX() is called
*
* This function will not be blocked. More detailes: PAEW_ETH_GetSignResult()
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nSignAuthType	(only for bio device) type of authentication when signature (\ref group_sign_auth_type)
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature structure: R(32 byte) + S(32byte) + V(1 byte)
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, #PAEW_RET_DEV_WAITING means device is waiting for user operation, and other value means failure (\ref group_retvalue)
* \sa				PAEW_ETH_GetSignResult(), PAEW_ETC_SetTX()
*/
int EWALLET_API PAEW_ETC_GetSignResult(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nSignAuthType, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			Get ETC signature (used only by dragon ball device), _MUST_ be invoked after PAEW_ETC_SetTX() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature structure: R(32 byte) + S(32byte) + V(1 byte)
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_ETC_SetTX()
*/
int EWALLET_API PAEW_ETC_GetSignResult_DragonBall(void * const pPAEWContext, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			ETC signature, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pbCurrentTX		transaction data to be signed
* \param[in]		nCurrentTXLen	length of transaction data to be signed
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature structure: R(32 byte) + S(32byte) + V(1 byte)
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_ETC_TXSign(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief		Set CYB transaction to device, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
* \param[in]	pPAEWContext	library context, shouldn't be NULL
* \param[in]	nDevIndex		(used only by personal device) index of device, valid range of value is [0, nDevCount-1]
* \param[in]	pbCurrentTX		transaction data to be signed
* \param[in]	nCurrentTXLen	length of transaction data to be signed
* \return		#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_CYB_SetTX(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen);

/**
* \brief			Get CYB signature (used only by non-dragon-ball device), _MUST_ be invoked after PAEW_CYB_SetTX() is called
*
* This function will not be blocked. More detailes: PAEW_ETH_GetSignResult()
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nSignAuthType	(only for bio device) type of authentication when signature (\ref group_sign_auth_type)
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature structure: R(32 byte) + S(32byte)
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, #PAEW_RET_DEV_WAITING means device is waiting for user operation, and other value means failure (\ref group_retvalue)
* \sa				PAEW_ETH_GetSignResult(), PAEW_CYB_SetTX()
*/
int EWALLET_API PAEW_CYB_GetSignResult(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nSignAuthType, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			Get CYB signature (used only by dragon ball device), _MUST_ be invoked after PAEW_CYB_SetTX() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature structure: R(32 byte) + S(32byte)
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_CYB_SetTX()
*/
int EWALLET_API PAEW_CYB_GetSignResult_DragonBall(void * const pPAEWContext, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			CYB signature, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pbCurrentTX		transaction data to be signed
* \param[in]		nCurrentTXLen	length of transaction data to be signed
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature structure: R(32 byte) + S(32byte)
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_CYB_TXSign(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			CYB signature with callbacks, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \deprecated		This function is only used for compatible reason, and will be removed soon
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pbCurrentTX		transaction data to be signed
* \param[in]		nCurrentTXLen	length of transaction data to be signed
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature structure: R(32 byte) + S(32byte)
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \param[in]		pSignCallbacks	callbacks called when the function proceeds
* \param[in]		pSignCallbackContext	callback context used by the callback function
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_CYB_TXSign_Ex(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen, const signCallbacks * const pSignCallbacks, void * const pSignCallbackContext);

/**
* \brief		Set EOS transaction to device, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
* \param[in]	pPAEWContext	library context, shouldn't be NULL
* \param[in]	nDevIndex		(used only by personal device) index of device, valid range of value is [0, nDevCount-1]
* \param[in]	pbCurrentTX		transaction data to be signed
* \param[in]	nCurrentTXLen	length of transaction data to be signed
* \return		#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa			PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_EOS_SetTX(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen);

/**
* \brief			Get EOS signature (used only by non-dragon-ball device), _MUST_ be invoked after PAEW_EOS_SetTX() is called
*
* This function will not be blocked. More detailes: PAEW_ETH_GetSignResult()
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nSignAuthType	(only for bio device) type of authentication when signature (\ref group_sign_auth_type)
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature data is a string which already encoded by EOS encoder
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, #PAEW_RET_DEV_WAITING means device is waiting for user operation, and other value means failure (\ref group_retvalue)
* \sa				PAEW_ETH_GetSignResult(), PAEW_EOS_SetTX()
*/
int EWALLET_API PAEW_EOS_GetSignResult(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nSignAuthType, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			Get EOS signature (used only by dragon ball device), _MUST_ be invoked after PAEW_EOS_SetTX() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature data is a string which already encoded by EOS encoder
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_EOS_SetTX()
*/
int EWALLET_API PAEW_EOS_GetSignResult_DragonBall(void * const pPAEWContext, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			EOS signature, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pbCurrentTX		transaction data to be signed
* \param[in]		nCurrentTXLen	length of transaction data to be signed
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature data is a string which already encoded by EOS encoder
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_EOS_TXSign(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			EOS signature with callbacks, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \deprecated		This function is only used for compatible reason, and will be removed soon
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pbCurrentTX		transaction data to be signed
* \param[in]		nCurrentTXLen	length of transaction data to be signed
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature data is a string which already encoded by EOS encoder
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \param[in]		pSignCallbacks	callbacks called when the function proceeds
* \param[in]		pSignCallbackContext	callback context used by the callback function
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_EOS_TXSign_Ex(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen, const signCallbacks * const pSignCallbacks, void * const pSignCallbackContext);

/**
* \brief		Set LTC transaction to device, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
* \param[in]	pPAEWContext	library context, shouldn't be NULL
* \param[in]	nDevIndex		(used only by personal device) index of device, valid range of value is [0, nDevCount-1]
* \param[in]	nUTXOCount		count of UTXOs, must equal to input number of transaction to be singed
* \param[in]	ppbUTXO			each of which contains one UTXO data
* \param[in]	pnUTXOLen		each of which contains length of UTXO data corresponding to the same position of ppbUTXO
* \param[in]	pbCurrentTX		transaction data to be signed
* \param[in]	nCurrentTXLen	length of transaction data to be signed
* \return		#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa			PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_LTC_SetTX(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen);

/**
* \brief			Get LTC signature (used only by non-dragon-ball device), _MUST_ be invoked after PAEW_LTC_SetTX() is called
*
* This function will not be blocked. More detailes: PAEW_ETH_GetSignResult()
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nSignAuthType	(only for bio device) type of authentication when signature (\ref group_sign_auth_type)
* \param[in]		nSignIndex		index of signature, valid range of value is [0, nUTXOCount-1]
* \param[out]		pbTXSig			contains DER encoded signature data, shouldn't be NULL, signature structure: DERLen(1 byte) + DER + 01 + PublicKeyLen(1 byte) + PublicKey
* \param[in,out]	pnTXSigLen		contains size of pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, #PAEW_RET_DEV_WAITING means device is waiting for user operation, and other value means failure (\ref group_retvalue)
* \sa				PAEW_ETH_GetSignResult(), PAEW_LTC_SetTX()
*/
int EWALLET_API PAEW_LTC_GetSignResult(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nSignAuthType, const size_t nSignIndex, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			Get LTC signature (used only by dragon ball device), _MUST_ be invoked after PAEW_LTC_SetTX() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nUTXOCount		count of UTXOs, must equal to input number of transaction to be singed
* \param[out]		ppbTXSig		contains DER encoded signature data, each of which corresponds to one input of transaction data, and element count is the same to input count if shouldn't be NULL, signature structure: DERLen(1 byte) + DER + 01 + PublicKeyLen(1 byte) + PublicKey
* \param[in,out]	pnTXSigLen		contains size of buffer corresponding to the same position of ppbTXSig when input, and contains actual lengths of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_LTC_SetTX()
*/
int EWALLET_API PAEW_LTC_GetSignResult_DragonBall(void * const pPAEWContext, const size_t nUTXOCount, unsigned char * const * const ppbTXSig, size_t * const pnTXSigLen);

/**
* \brief			LTC signature, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nUTXOCount		count of UTXOs, must equal to input number of transaction to be singed
* \param[in]		ppbUTXO			each of which contains one UTXO data
* \param[in]		pnUTXOLen		each of which contains length of UTXO data corresponding to the same position of ppbUTXO
* \param[in]		pbCurrentTX		transaction data to be signed
* \param[in]		nCurrentTXLen	length of transaction data to be signed
* \param[out]		ppbTXSig		contains DER encoded signature data, each of which corresponds to one input of transaction data, and element count is the same to input count if shouldn't be NULL, signature structure: DERLen(1 byte) + DER + 01 + PublicKeyLen(1 byte) + PublicKey
* \param[in,out]	pnTXSigLen		contains size of buffer corresponding to the same position of ppbTXSig when input, and contains actual lengths of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_LTC_TXSign(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const * const ppbTXSig, size_t * const pnTXSigLen);

/**
* \brief		Set NEO transaction to device, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
* \param[in]	pPAEWContext	library context, shouldn't be NULL
* \param[in]	nDevIndex		(used only by personal device) index of device, valid range of value is [0, nDevCount-1]
* \param[in]	nUTXOCount		count of UTXOs, must equal to input number of transaction to be singed
* \param[in]	ppbUTXO			each of which contains one UTXO data
* \param[in]	pnUTXOLen		each of which contains length of UTXO data corresponding to the same position of ppbUTXO
* \param[in]	pbCurrentTX		transaction data to be signed
* \param[in]	nCurrentTXLen	length of transaction data to be signed
* \return		#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa			PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_NEO_SetTX(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen);

/**
* \brief			Get NEO signature (used only by non-dragon-ball device), _MUST_ be invoked after PAEW_NEO_SetTX() is called
*
* This function will not be blocked. More detailes: PAEW_ETH_GetSignResult()
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nSignAuthType	(only for bio device) type of authentication when signature (\ref group_sign_auth_type)
* \param[in]		nSignIndex		index of signature, valid range of value is [0, nUTXOCount-1]
* \param[out]		pbTXSig			contains signature and public key, shouldn't be NULL, signature structure: SigLen + Sig + 01 + PublicKeyLen + PublicKey
* \param[in,out]	pnTXSigLen		contains size of pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, #PAEW_RET_DEV_WAITING means device is waiting for user operation, and other value means failure (\ref group_retvalue)
* \sa				PAEW_ETH_GetSignResult(), PAEW_NEO_SetTX()
*/
int EWALLET_API PAEW_NEO_GetSignResult(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nSignAuthType, const size_t nSignIndex, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			Get NEO signature (used only by dragon ball device), _MUST_ be invoked after PAEW_NEO_SetTX() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[out]		pbTXSig			contains signature and public key, shouldn't be NULL, signature structure: SigLen + Sig + 01 + PublicKeyLen + PublicKey
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_NEO_SetTX()
*/
int EWALLET_API PAEW_NEO_GetSignResult_DragonBall(void * const pPAEWContext, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			NEO signature, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nUTXOCount		count of UTXOs, must equal to input number of transaction to be singed
* \param[in]		ppbUTXO			each of which contains one UTXO data
* \param[in]		pnUTXOLen		each of which contains length of UTXO data corresponding to the same position of ppbUTXO
* \param[in]		pbCurrentTX		transaction data to be signed
* \param[in]		nCurrentTXLen	length of transaction data to be signed
* \param[out]		pbTXSig			contains signature and public key, shouldn't be NULL, signature structure: SigLen + Sig + 01 + PublicKeyLen + PublicKey
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_NEO_TXSign(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen);
/**
* \brief		Set BTC WIT transaction to device, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
* \param[in]	pPAEWContext	library context, shouldn't be NULL
* \param[in]	nDevIndex		(used only by personal device) index of device, valid range of value is [0, nDevCount-1]
* \param[in]	nUTXOCount		count of UTXOs, must equal to input number of transaction to be singed
* \param[in]	ppbUTXO			each of which contains one UTXO data
* \param[in]	pnUTXOLen		each of which contains length of UTXO data corresponding to the same position of ppbUTXO
* \param[in]	pbCurrentTX		transaction data to be signed
* \param[in]	nCurrentTXLen	length of transaction data to be signed
* \return		#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa			PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_BTC_WIT_SetTX(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen);

/**
* \brief			Get BTC WIT signature (used only by non-dragon-ball device), _MUST_ be invoked after PAEW_BTC_WIT_SetTX() is called
*
* This function will not be blocked. More detailes: PAEW_ETH_GetSignResult()
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nSignAuthType	(only for bio device) type of authentication when signature (\ref group_sign_auth_type)
* \param[in]		nSignIndex		index of signature, valid range of value is [0, nUTXOCount-1]
* \param[out]		pbTXSig			contains DER encoded signature data, shouldn't be NULL, signature structure: DERLen(1 byte) + DER + 01 + PublicKeyLen(1 byte) + PublicKey
* \param[in,out]	pnTXSigLen		contains size of pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, #PAEW_RET_DEV_WAITING means device is waiting for user operation, and other value means failure (\ref group_retvalue)
* \sa				PAEW_ETH_GetSignResult(), PAEW_BTC_WIT_SetTX()
*/
int EWALLET_API PAEW_BTC_WIT_GetSignResult(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nSignAuthType, const size_t nSignIndex, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			Get BTC WIT signature (used only by dragon ball device), _MUST_ be invoked after PAEW_BTC_WIT_SetTX() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nUTXOCount		count of UTXOs, must equal to input number of transaction to be singed
* \param[out]		ppbTXSig		contains DER encoded signature data, each of which corresponds to one input of transaction data, and element count is the same to input count if shouldn't be NULL, signature structure: DERLen(1 byte) + DER + 01 + PublicKeyLen(1 byte) + PublicKey
* \param[in,out]	pnTXSigLen		contains size of buffer corresponding to the same position of ppbTXSig when input, and contains actual lengths of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_BTC_WIT_SetTX()
*/
int EWALLET_API PAEW_BTC_WIT_GetSignResult_DragonBall(void * const pPAEWContext, const size_t nUTXOCount, unsigned char * const * const ppbTXSig, size_t * const pnTXSigLen);

/**
* \brief			BTC WIT signature, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nUTXOCount		count of UTXOs, must equal to input number of transaction to be singed
* \param[in]		ppbUTXO			each of which contains one UTXO data
* \param[in]		pnUTXOLen		each of which contains length of UTXO data corresponding to the same position of ppbUTXO
* \param[in]		pbCurrentTX		transaction data to be signed
* \param[in]		nCurrentTXLen	length of transaction data to be signed
* \param[out]		ppbTXSig		contains DER encoded signature data, each of which corresponds to one input of transaction data, and element count is the same to input count if shouldn't be NULL, signature structure: DERLen(1 byte) + DER + 01 + PublicKeyLen(1 byte) + PublicKey
* \param[in,out]	pnTXSigLen		contains size of buffer corresponding to the same position of ppbTXSig when input, and contains actual lengths of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_BTC_WIT_TXSign(void * const pPAEWContext, const size_t nDevIndex, const size_t nUTXOCount, const unsigned char * const * const ppbUTXO, const size_t * const pnUTXOLen, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const * const ppbTXSig, size_t * const pnTXSigLen);

/**
* \brief		Set XRP transaction to device, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
* \param[in]	pPAEWContext	library context, shouldn't be NULL
* \param[in]	nDevIndex		(used only by personal device) index of device, valid range of value is [0, nDevCount-1]
* \param[in]	pbCurrentTX		transaction data to be signed
* \param[in]	nCurrentTXLen	length of transaction data to be signed
* \return		#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa			PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_XRP_SetTX(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen);

/**
* \brief			Get XRP signature (used only by non-dragon-ball device), _MUST_ be invoked after PAEW_XRP_SetTX() is called
*
* This function will not be blocked. More detailes: PAEW_ETH_GetSignResult()
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nSignAuthType	(only for bio device) type of authentication when signature (\ref group_sign_auth_type)
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature structure: R(32bytes) + S(32bytes)
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, #PAEW_RET_DEV_WAITING means device is waiting for user operation, and other value means failure (\ref group_retvalue)
* \sa				PAEW_ETH_GetSignResult(), PAEW_XRP_SetTX()
*/
int EWALLET_API PAEW_XRP_GetSignResult(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nSignAuthType, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			Get XRP signature (used only by dragon ball device), _MUST_ be invoked after PAEW_XRP_SetTX() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature structure: R(32bytes) + S(32bytes)
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_XRP_SetTX()
*/
int EWALLET_API PAEW_XRP_GetSignResult_DragonBall(void * const pPAEWContext, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			XRP signature, _MUST_ be invoked after PAEW_DeriveTradeAddress() is called
*
* This function may be blocked and wait user to check all the transaction information legal and press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pbCurrentTX		transaction data to be signed
* \param[in]		nCurrentTXLen	length of transaction data to be signed
* \param[out]		pbTXSig			contains signature data, shouldn't be NULL, signature structure: R(32bytes) + S(32bytes)
* \param[in,out]	pnTXSigLen		contains size of \p pbTXSig when input, and contains actual length of signature data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_DeriveTradeAddress()
*/
int EWALLET_API PAEW_XRP_TXSign(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCurrentTX, const size_t nCurrentTXLen, unsigned char * const pbTXSig, size_t * const pnTXSigLen);

/**
* \brief			Clear User COS
* This function may be blocked and wait user to press button
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_ClearCOS(void * const pPAEWContext, const size_t nDevIndex);

/**
* \brief			Change PIN
* This function may be blocked and wait user to input PIN on device
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_ChangePIN(void * const pPAEWContext, const size_t nDevIndex);
 
/**
* \brief			Change PIN (used only by bio device)
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		szOldPIN		old PIN which need to be changed
* \param[in]		szNewPIN		new PIN want to change to
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_ChangePIN_Input(void * const pPAEWContext, const size_t nDevIndex, const char * const szOldPIN, const char * const szNewPIN);

/**
* \brief			Change PIN (used only by bio device)
*
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		szOldPIN		old PIN which need to be changed
* \param[in]		szNewPIN		new PIN want to change to
* \param[in]		pPutStateCallback	callback called when loop device button press
* \param[in]		pCallbackContext	callback context used by \p pPutStateCallback
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_ChangePIN_Input_Ex(void * const pPAEWContext, const size_t nDevIndex, const char * const szOldPIN, const char * const szNewPIN, const tFunc_PutState_Callback pPutStateCallback, void * const pCallbackContext);

/**
* \brief			Initialize PIN (used only by bio device)
*
* This function should be called only ONCE until be formatted
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		szPIN			initial PIN set to device
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_InitPIN(void * const pPAEWContext, const size_t nDevIndex, const char * const szPIN);

/**
* \brief			Initialize PIN (used only by bio device)
*
* This function should be called only ONCE until be formatted. \p pPutStateCallback is called every time the device is checked
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		szPIN			initial PIN set to device
* \param[in]		pPutStateCallback	callback called when loop device button press
* \param[in]		pCallbackContext	callback context used by \p pPutStateCallback
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_InitPIN_Ex(void * const pPAEWContext, const size_t nDevIndex, const char * const szPIN, const tFunc_PutState_Callback pPutStateCallback, void * const pCallbackContext);

/**
* \brief			Verify PIN (used only by bio device)
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		szPIN			PIN need to be checked
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_VerifyPIN(void * const pPAEWContext, const size_t nDevIndex, const char * const szPIN);

/**
* \brief			Format device, usually used when user forgets his PIN
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_Format(void * const pPAEWContext, const size_t nDevIndex);

/**
* \brief			Format device, usually used when user forgets his PIN
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pPutStateCallback	callback called when loop device button press (used only by bio device)
* \param[in]		pCallbackContext	callback context used by \p pPutStateCallback (used only by bio device)
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_Format_Ex(void * const pPAEWContext, const size_t nDevIndex, const tFunc_PutState_Callback pPutStateCallback, void * const pCallbackContext);

/**
* \brief			Update COS
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pbCOSData		COS data
* \param[in]		nCOSDataLen		length of COS data
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_UpdateCOS(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbCOSData, const size_t nCOSDataLen);

/**
* \brief		Update COS using progress callback and context, support resume from breakpoint of last unfinished procedure
* \param[in]	pPAEWContext		library context, shouldn't be NULL
* \param[in]	nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[in]	bRestart			0 means resume breakpoint of last procedure, 1 means restart COS download
* \param[in]	pbCOSData			COS data
* \param[in]	nCOSDataLen			length of COS data
* \param[in]	pProgressCallback	progress callback to receive progress of updating
* \param[in]	pCallbackContext	context of progress callback
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_UpdateCOS_Ex(void * const pPAEWContext, const size_t nDevIndex, const unsigned char bRestart, const unsigned char * const pbCOSData, const size_t nCOSDataLen, const tFunc_Progress_Callback pProgressCallback, void * const pCallbackContext);

/**
* \brief			EOS transaction string (Json) serialization (implemented by software)
* \param[in]		szTransactionString	transaction string in json format, shouldn't be NULL
* \param[out]		pbTransactionData	contains binary data of transaction, shouldn't be NULL
* \param[in,out]	pnTransactionLen	contains size of \p pbTransactionData when input, and contains actual length of transaction data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_EOS_TX_Serialize(const char * const szTransactionString, unsigned char * const pbTransactionData, size_t * pnTransactionLen);

/**
* \brief			EOS transaction string (Json) serialization - specific part (implemented by software)
* \param[in]		nPartIndex			EOS transaction part id, which value is one of the PAEW_SIG_EOS_TX_XXX (\ref group_sig_constant)
* \param[in]		szTransactionString	transaction string in json format, shouldn't be NULL
* \param[out]		pbTransactionData	contains binary data of transaction, shouldn't be NULL
* \param[in,out]	pnTransactionLen	contains size of \p pbTransactionData when input, and contains actual length of transaction data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_EOS_TX_Part_Serialize(const unsigned int nPartIndex, const char * const szTransactionString, unsigned char * const pbTransactionData, size_t * pnTransactionLen);

/**
* \brief		Set ERC20 token info
* \param[in]	pPAEWContext		library context, shouldn't be NULL
* \param[in]	nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[in]	nCoinType			coin type, valid values are PAEW_COIN_TYPE_XXX (\ref group_coin_type)
* \param[in]	szTokenName			token name
* \param[in]	nPrecision			token precision, means 10^nPrecision
* \return		#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_SetERC20Info(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nCoinType, const char * const szTokenName, const unsigned char nPrecision);

/**
* \brief			Get finge rprint list (used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[out]		pFPList				contains finger print list, shouldn't be NULL
* \param[in,out]	pnFPListCount		amount of elements of \p pFPList when input, and contains actual count of finger print when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_GetFPList(void * const pPAEWContext, const size_t nDevIndex, FingerPrintID * const pFPList, size_t * const pnFPListCount);

/**
* \brief			Start verify finger print, and should use PAEW_GetFPState() to get verify state (used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_GetFPState()
*/
int EWALLET_API PAEW_VerifyFP(void * const pPAEWContext, const size_t nDevIndex);

/**
* \brief			Get verified finger print list (used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[out]		pFPList				contains verified finger print list, shouldn't be NULL
* \param[in,out]	pnFPListCount		amount of elements of \p pFPList when input, and contains actual count of verified finger print when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_GetVerifyFPList(void * const pPAEWContext, const size_t nDevIndex, FingerPrintID * const pFPList, size_t * const pnFPListCount);

/**
* \brief			Start enroll finger print, and should use PAEW_GetFPState() to get enroll state (used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_GetFPState()
*/
int EWALLET_API PAEW_EnrollFP(void * const pPAEWContext, const size_t nDevIndex);

/**
* \brief			Get enroll or verify finger print state(used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_VerifyFP(), PAEW_EnrollFP()
*/
int EWALLET_API PAEW_GetFPState(void * const pPAEWContext, const size_t nDevIndex);

/**
* \brief			Abort enroll or verify finger print (used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_VerifyFP(), PAEW_EnrollFP()
*/
int EWALLET_API PAEW_AbortFP(void * const pPAEWContext, const size_t nDevIndex);

/**
* \brief			Delete finger print (used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pFPID				stores finger print ID to be deleted, and delete all finger prints when this value is NULL
* \param[in]		nFPCount			count of finger print to be deleted (element count of \p pFPID), and could be any value when \p pFPID is NULL
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_DeleteFP(void * const pPAEWContext, const size_t nDevIndex, const FingerPrintID * const pFPID, const size_t nFPCount);

/**
* \brief			Calibrate finger print sensor (used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_CalibrateFP(void * const pPAEWContext, const size_t nDevIndex);

/**
* \brief			Clear screen (used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_ClearLCD(void * const pPAEWContext, const size_t nDevIndex);

/**
* \brief			Power off device (used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_PowerOff(void * const pPAEWContext, const size_t nDevIndex);

int EWALLET_API PAEW_GetClientConfigData(unsigned char * const pbData, size_t * const pnDataLen);

/**
* \brief			Get device check code
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[out]		pbCheckCode			contains check code, shouldn't be NULL
* \param[in,out]	pnCheckCodeLen		size of \p pbCheckCode when input, and contains actual size of device check code when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_GetDeviceCheckCode(void * const pPAEWContext, const size_t nDevIndex, unsigned char * const pbCheckCode, size_t * const pnCheckCodeLen);

/**
* \brief			Get supported ERC20 token info
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[out]		pERC20InfoList		contains ERC20 infos, shouldn't be NULL
* \param[in,out]	pnERC20InfoCount	amount of elements of \p pERC20InfoList when input, and contains actual amount of ERC20 info when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_GetERC20List(void * const pPAEWContext, const size_t nDevIndex, PAEW_ERC20Info * const pERC20InfoList, size_t * const pnERC20InfoCount);

/**
* \brief			Import ERC20 token info
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pbERC20RecordData	contains ERC20 info to be imported, shouldn't be NULL
* \param[in]		nERC20RecordLen		length of \p pbERC20RecordData to be imported
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_ImportERC20Record(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbERC20RecordData, const size_t nERC20RecordLen);

/**
* \brief			Write serial number
* \deprecated		This function is for test only, production _MUST_ not used this function
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[in]		pbSerialNumber		contains serial number to be imported, shouldn't be NULL
* \param[in]		nSerialNumberLen	length of \p pbSerialNumber to be imported
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_WriteSN(void * const pPAEWContext, const size_t nDevIndex, const unsigned char * const pbSerialNumber, const size_t nSerialNumberLen);

/**
* \brief			Write image data to device (used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nImageIndex			index of image to be set, valid range of value is [0, nImageCount-1]
* \param[in]		pbImageData			contains image data to be imported, shouldn't be NULL
* \param[in]		nImageDataLen		length of \p pbImageData to be imported
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_GetImageList()
*/
int EWALLET_API PAEW_SetImageData(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nImageIndex, const unsigned char * const pbImageData, const size_t nImageDataLen);

/**
* \brief			Show image on device screen (used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nImageIndex			index of image to be set, valid range of value is [0, nImageCount-1]
* \param[in]		nLCDMode			screen refresh mode, valid values are PAEW_LCD_XXX (\ref group_images)
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_GetImageList()
*/
int EWALLET_API PAEW_ShowImage(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nImageIndex, const unsigned char nLCDMode);

/**
* \brief			Set image as device logo (used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nImageIndex			index of image to be set, valid range of value is [0, nImageCount-1]
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_GetImageList()
*/
int EWALLET_API PAEW_SetLogoImage(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nImageIndex);

/**
* \brief			Get image list in device (used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[out]		pbImageIndex		contains image indexes in device, shouldn't be NULL
* \param[in,out]	pnImageCount		count of elements of \p pbImageIndex when input, and contains actual count of image indexes when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_GetImageList(void * const pPAEWContext, const size_t nDevIndex, unsigned char * const pbImageIndex, size_t * const pnImageCount);

/**
* \brief			Get image name (used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nImageIndex			index of image to be set, valid range of value is [0, nImageCount-1]
* \param[out]		pbImageName			contains image name of specific image index, shouldn't be NULL
* \param[in,out]	pnImageNameLen		size of \p pbImageName when input, and contains actual length of image name when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_GetImageList()
*/
int EWALLET_API PAEW_GetImageName(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nImageIndex, unsigned char * const pbImageName, size_t * const pnImageNameLen);

/**
* \brief			Set image name (used only by bio device)
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[in]		nImageIndex			index of image to be set, valid range of value is [0, nImageCount-1]
* \param[in]		pbImageName			contains image name of specific image index, shouldn't be NULL
* \param[in]		nImageNameLen		length of \p pbImageName
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_GetImageList()
*/
int EWALLET_API PAEW_SetImageName(void * const pPAEWContext, const size_t nDevIndex, const unsigned char nImageIndex, const unsigned char * const pbImageName, const size_t nImageNameLen);

/**
* \brief			Convert binary image to data compatible with device (algorithm implemented by software)
* \param[in]		pbOrigImage		origin image data from BMP file, shouldn't be NULL
* \param[in]		nOrigImageLen	length of origin image data
* \param[in]		nWidth			image width
* \param[in]		nHeight			image height
* \param[out]		pbDestImage		contains device image data, shouldn't be NULL
* \param[in,out]	pnDestImageLen	size of \p pbDestImage when input, and contains actual length of device image data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_ConvertBMP(const unsigned char * const pbOrigImage, const size_t nOrigImageLen, const size_t nWidth, const size_t nHeight, unsigned char * const pbDestImage, size_t * const pnDestImageLen);

/**
* \brief			Verify file ECC signature (algorithm implemented by software)
* \param[in]		szFileFullPath	path of file to be validate, shouldn't be NULL
* \param[in]		pbSignature		signature data to be verified, shouldn't be NULL
* \param[in]		nSignatureLen	length of \p pbSignature
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_VerifyFileECCSignature(const char * const szFileFullPath, const unsigned char * const pbSignature, const size_t nSignatureLen);

/**
* \brief			Verify PIN for sign (used only by bio device)
*
* This function should be called before PAEW_XXX_GetSignResult with \p nSignAuthType == #PAEW_SIGN_AUTH_TYPE_PIN.
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \param[in]		szPIN			PIN need to be checked
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_VerifySignPIN(void * const pPAEWContext, const size_t nDevIndex, const char * const szPIN);

/**
* \brief			Switch to other authenticate type (used only by bio device)
*
* This function MUST be called if PAEW_XXX_GetSignResult has invoked several times to wait button or finger print and then user wants to change to other authentication type (from #PAEW_SIGN_AUTH_TYPE_FP to #PAEW_SIGN_AUTH_TYPE_PIN or opposite).
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
* \sa				PAEW_ETH_GetSignResult()
*/
int EWALLET_API PAEW_SwitchSign(void * const pPAEWContext, const size_t nDevIndex);

/**
* \brief			Abort transaction sign (used only by bio device)
*
* This function should be called if user wants to abort current transaction sign. Typically, if PAEW_XXX_GetSignResult returns error (exclude #PAEW_RET_DEV_STATE_INVALID or #PAEW_RET_NO_VERIFY_COUNT (with \p nSignAuthType == #PAEW_SIGN_AUTH_TYPE_FP and #PAEW_SIGN_AUTH_TYPE_PIN)), this function must be called to restore device state
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_AbortSign(void * const pPAEWContext, const size_t nDevIndex);

/**
* \brief			Get battery value (used only by bio device)
*
* \param[in]		pPAEWContext		library context, shouldn't be NULL
* \param[in]		nDevIndex			index of device, valid range of value is [0, nDevCount-1]
* \param[out]		pbBatteryValue		contains battery value, data format is: PowerSource || PowerLevel. PowerSource is 1-byte data, 0x00 means connecting and charging with usb, 0x01 means using battery. PowerLevel is 1-byte data, indicates power value of battery.
* \param[in,out]	pnBatteryValueLen	size of \p pbBatteryValue when input, and contains actual length of battery value data when output
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_GetBatteryValue(void * const pPAEWContext, const size_t nDevIndex, unsigned char * const pbBatteryValue, size_t * const pnBatteryValueLen);

/**
* \brief			Abort button waiting (used only by bio device)
*
* \param[in]		pPAEWContext	library context, shouldn't be NULL
* \param[in]		nDevIndex		index of device, valid range of value is [0, nDevCount-1]
* \return			#PAEW_RET_SUCCESS means success, and other value means failure (\ref group_retvalue)
*/
int EWALLET_API PAEW_AbortButton(void * const pPAEWContext, const size_t nDevIndex);
///@}

#ifdef __cplusplus
};
#endif
#endif //_PA_EWALLET_H_
