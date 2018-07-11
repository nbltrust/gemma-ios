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

+ (NSString *)getAbiJsonString:(NSString *)code action:(NSString *)action from:(NSString *)from to:(NSString *)to quantity:(NSString *)quantity memo:(NSString *)memo;
+ (NSString *)getTransaction:(NSString *)privateKey code:(NSString *)code from:(NSString *)from to:(NSString *)to quantity:(NSString *)quantity memo:(NSString *)memo getinfo:(NSString *)getinfo abistr:(NSString *)abistr;
@end
