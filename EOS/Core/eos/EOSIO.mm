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


@end
