//
//  EOSIO.m
//  EOS
//
//  Created by koofrank on 2018/7/5.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

#import "EOSIO.h"
#include "eosio.hpp"

@implementation EOSIO

+ (NSArray<NSString *> *)createKey {
    auto result = createKey();
    NSString *pub = @(result.first.c_str());
    NSString *pri = @(result.second.c_str());

    return @[pub, pri];
}

+ (NSString *)getCypher:(NSString *)privateKey password:(NSString *)password {
    return @(get_cypher(password.UTF8String, privateKey.UTF8String).c_str());
}

+ (NSString *)getPirvateKey:(NSString *)cypher password:(NSString *)password {
    return @(get_private_key(cypher.UTF8String, password.UTF8String).c_str());
}

+ (NSString *)getAbiJsonString:(NSString *)code action:(NSString *)action from:(NSString *)from to:(NSString *)to quantity:(NSString *)quantity {
    return @(create_abi_req(code.UTF8String, action.UTF8String, from.UTF8String, to.UTF8String, quantity.UTF8String).c_str());
}

+ (NSString *)getTransaction:(NSString *)privateKey code:(NSString *)code from:(NSString *)from to:(NSString *)to quantity:(NSString *)quantity memo:(NSString *)memo getinfo:(NSString *)getinfo abistr:(NSString *)abistr {
    return @(signTransaction(privateKey.UTF8String, code.UTF8String, from.UTF8String, to.UTF8String, quantity.UTF8String, memo.UTF8String, getinfo.UTF8String, abistr.UTF8String, 0, 0).c_str());
}

@end
