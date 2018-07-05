//
//  EOSIO.h
//  EOS
//
//  Created by koofrank on 2018/7/5.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOSIO : NSObject

+ (NSArray<NSString *> *)createKey;//pub, pri
+ (NSString *)getCypher:(NSString *)privateKey password:(NSString *)password;
+ (NSString *)getPirvateKey:(NSString *)cypher password:(NSString *)password;

@end
