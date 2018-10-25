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

+ (NSString *)getBuyRamAbi:(NSString *)code action:(NSString *)action payer:(NSString *)payer receiver:(NSString *)receiver quant:(NSString *)quant;
+ (NSString *)getSellRamAbi:(NSString *)code action:(NSString *)action account:(NSString *)account bytes:(uint32_t)bytes;

+ (NSString *)getBuyRamTransaction:(NSString *)priv_key_str contract:(NSString *)contract payer_str:(NSString *)payer_str infostr:(NSString *)infostr abistr:(NSString *)abistr max_cpu_usage_ms:(uint32_t)max_cpu_usage_ms max_net_usage_words:(uint32_t)max_net_usage_words;
+ (NSString *)getSellRamTransaction:(NSString *)priv_key_str contract:(NSString *)contract account_str:(NSString *)account_str infostr:(NSString *)infostr abistr:(NSString *)abistr max_cpu_usage_ms:(uint32_t)max_cpu_usage_ms max_net_usage_words:(uint32_t)max_net_usage_words;

+ (NSString *)getVoteTransaction:(NSString *)priv_key_str contract:(NSString *)contract vote_str:(NSString *)vote_str infostr:(NSString *)infostr abistr:(NSString *)abistr max_cpu_usage_ms:(uint32_t)max_cpu_usage_ms max_net_usage_words:(uint32_t)max_net_usage_words;
@end
