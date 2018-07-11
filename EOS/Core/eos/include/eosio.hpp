#include <iostream>
#include <vector>
#include <keosdlib.hpp>
#include <fc/exception/exception.hpp>
using namespace std;

eosio::keosdlib k;

pair<std::string, std::string> createKey(){
    return k.createKey("");
}

string get_private_key(const string& cipher_keys, const string& password){
    return k.get_private_key(cipher_keys, password);
}

string get_cypher(const string& password, const string& priv_key){
    return k.get_cypher(password, priv_key);
}
std::string signTransaction(const std::string& trxstr, const std::string& priv_key_str, const std::string& chain_id_str){
    return k.signTransaction(trxstr, priv_key_str, chain_id_str);
}
std::string signTransaction(const string& priv_key_str, const string& contract,
                            const string& senderstr, const string& recipientstr, const string& amountstr,
                            const string& memo, const string& infostr, const string& abistr ,
                            uint32_t max_cpu_usage_ms, uint32_t max_net_usage_words , uint32_t tx_expiration = 120  ){
    return k.signTransaction(priv_key_str, contract, senderstr, recipientstr, amountstr,
                             memo, infostr, abistr ,  max_cpu_usage_ms,  max_net_usage_words ,  tx_expiration  );
}
std::string create_abi_req(const string& code, const string& action, const string& from, const string& to, const string& quantity, const string& memo){
    return k.create_abi_req(code, action, from, to, quantity, memo);
}


// cout << signTransaction(
//         "5KBefyZPfqRH6pJiaGFgua7dupA4sQeVomzq9QssyBWX14udekE",
//         "eosio.token",
//         "useraaaaaaaa",
//         "useraaaaaaab",
//         "1.0000 SYS",
//         "memo",
//         "{\"server_version\":\"90fefdd1\",\"chain_id\":\"00d48a14e7f551db85db479381694c117d33690ae0c66af48b776971c9d565aa\",\"head_block_num\":1175691,\"last_irreversible_block_num\":1175364,\"last_irreversible_block_id\":\"0011ef44a5a05413296f7ea3ed7169c10f0e99749407d8b10f2d851323b171f9\",\"head_block_id\":\"0011f08b28ba5b0c37286d39a4f3b0c2d58fe5a8c4730731c9b5888b68d8da1f\",\"head_block_time\":\"2018-07-09T07:56:13.000\",\"head_block_producer\":\"bp.bb\",\"virtual_block_cpu_limit\":200000000,\"virtual_block_net_limit\":1048576000,\"block_cpu_limit\":199900,\"block_net_limit\":1048576}"
// ,
//         "608c31c6187315d6708c31c6187315d610270000000000000453595300000000087472616e73666572"
//     ) << endl;

//cout << create_abi_req(
//        "eosio.token",
//        "transfer",
//        "useraaaaaaaa",
//        "useraaaaaaab",
//        "1.0000 SYS"
//    )
