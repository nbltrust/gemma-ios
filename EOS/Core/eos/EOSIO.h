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
+ (NSString *)getPublicKey:(NSString *)privateKey;
+ (NSString *)getCypher:(NSString *)privateKey password:(NSString *)password;
+ (NSString *)getPirvateKey:(NSString *)cypher password:(NSString *)password;

+ (NSString *)getAbiJsonString:(NSString *)code action:(NSString *)action from:(NSString *)from to:(NSString *)to quantity:(NSString *)quantity memo:(NSString *)memo;
+ (NSString *)getTransferTransaction:(NSString *)privateKey code:(NSString *)code from:(NSString *)from getinfo:(NSString *)getinfo abistr:(NSString *)abistr;

+ (NSString *)getDelegateTransaction:(NSString *)privateKey code:(NSString *)code from:(NSString *)from getinfo:(NSString *)getinfo abistr:(NSString *)abistr;
+ (NSString *)getUnDelegateTransaction:(NSString *)privateKey code:(NSString *)code from:(NSString *)from getinfo:(NSString *)getinfo abistr:(NSString *)abistr;
    
+ (NSString *)getDelegateAbi:(NSString *)code action:(NSString *)action from:(NSString *)from receiver:(NSString *)receiver stake_net_quantity:(NSString *)stake_net_quantity stake_cpu_quantity:(NSString *)stake_cpu_quantity;
+ (NSString *)getUnDelegateAbi:(NSString *)code action:(NSString *)action from:(NSString *)from receiver:(NSString *)receiver unstake_net_quantity:(NSString *)unstake_net_quantity unstake_cpu_quantity:(NSString *)unstake_cpu_quantity;

@end
