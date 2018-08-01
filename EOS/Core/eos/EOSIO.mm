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
    return @(k.get_public_key(privateKey.UTF8String).c_str());
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


@end
