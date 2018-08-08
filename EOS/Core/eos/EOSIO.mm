//
//  EOSIO.m
//  EOS
//
//  Created by koofrank on 2018/7/5.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

#import "EOSIO.h"
#include <keosdlib.hpp>

eosio::keosdlib k;

@implementation EOSIO

+ (NSArray<NSString *> *)createKey {
    auto result = k.createKey("");
    NSString *pub = @(result.first.c_str());
    NSString *pri = @(result.second.c_str());

    return @[pub, pri];
}

+ (NSString *)getPublicKey:(NSString *)privateKey {
    NSString *key = @(k.get_public_key(privateKey.UTF8String).c_str());
    if ([key isEqualToString:@""]) {
        return nil;
    }
    return key;
}

+ (NSString *)getCypher:(NSString *)privateKey password:(NSString *)password {
    return @(k.get_cypher(password.UTF8String, privateKey.UTF8String).c_str());
}

+ (NSString *)getPirvateKey:(NSString *)cypher password:(NSString *)password {
    return @(k.get_private_key(cypher.UTF8String, password.UTF8String).c_str());
}

+ (NSString *)getAbiJsonString:(NSString *)code action:(NSString *)action from:(NSString *)from to:(NSString *)to quantity:(NSString *)quantity memo:(NSString *)memo {
    return @(k.create_abi_req_transfer(code.UTF8String, action.UTF8String, from.UTF8String, to.UTF8String, quantity.UTF8String, memo.UTF8String).c_str());
}

+ (NSString *)getTransferTransaction:(NSString *)privateKey code:(NSString *)code from:(NSString *)from getinfo:(NSString *)getinfo abistr:(NSString *)abistr {
    return @(k.signTransaction_tranfer(privateKey.UTF8String, code.UTF8String, from.UTF8String, getinfo.UTF8String, abistr.UTF8String, 0, 0).c_str());
}

+ (NSString *)getDelegateTransaction:(NSString *)privateKey code:(NSString *)code from:(NSString *)from getinfo:(NSString *)getinfo abistr:(NSString *)abistr {
    return @(k.signTransaction_delegatebw(privateKey.UTF8String, code.UTF8String, from.UTF8String, getinfo.UTF8String, abistr.UTF8String, 0, 0).c_str());
}

+ (NSString *)getUnDelegateTransaction:(NSString *)privateKey code:(NSString *)code from:(NSString *)from getinfo:(NSString *)getinfo abistr:(NSString *)abistr {
    return @(k.signTransaction_undelegatebw(privateKey.UTF8String, code.UTF8String, from.UTF8String, getinfo.UTF8String, abistr.UTF8String, 0, 0).c_str());
}

+ (NSString *)getDelegateAbi:(NSString *)code action:(NSString *)action from:(NSString *)from receiver:(NSString *)receiver stake_net_quantity:(NSString *)stake_net_quantity stake_cpu_quantity:(NSString *)stake_cpu_quantity {
        return @(k.create_abi_req_delegatebw(code.UTF8String, action.UTF8String, from.UTF8String, receiver.UTF8String, stake_net_quantity.UTF8String, stake_cpu_quantity.UTF8String).c_str());
}

+ (NSString *)getUnDelegateAbi:(NSString *)code action:(NSString *)action from:(NSString *)from receiver:(NSString *)receiver unstake_net_quantity:(NSString *)unstake_net_quantity unstake_cpu_quantity:(NSString *)unstake_cpu_quantity {
    return @(k.create_abi_req_undelegatebw(code.UTF8String, action.UTF8String, from.UTF8String, receiver.UTF8String, unstake_net_quantity.UTF8String, unstake_cpu_quantity.UTF8String).c_str());
}

+ (NSString *)getBuyRamAbi:(NSString *)code action:(NSString *)action payer:(NSString *)payer receiver:(NSString *)receiver quant:(NSString *)quant {
    return @(k.create_abi_req_buyram(code.UTF8String, action.UTF8String, payer.UTF8String, receiver.UTF8String, quant.UTF8String).c_str());
}

+ (NSString *)getSellRamAbi:(NSString *)code action:(NSString *)action account:(NSString *)account bytes:(uint32_t)bytes {
    return @(k.create_abi_req_sellram(code.UTF8String, action.UTF8String, account.UTF8String, bytes).c_str());
}

//+ (NSString *)getBuyRamTransaction {
//    return @(k.signTransaction_buyram(<#const std::string &priv_key_str#>, <#const std::string &contract#>, <#const std::string &payer_str#>, <#const std::string &infostr#>, <#const std::string &abistr#>, <#uint32_t max_cpu_usage_ms#>, <#uint32_t max_net_usage_words#>).c_str());
//}

@end
