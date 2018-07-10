#include <iostream>
#include <vector>
#include "keosdlib.hpp"
#include <fc/exception/exception.hpp>
using namespace std;

keosdlib k;

pair<std::string, std::string> createKey(){
    return k.createKey("K1");
}

string get_private_key(const string& cipher_keys, const string& password){
    return k.get_private_key(cipher_keys, password);
}

string get_cypher(const string& password, const string& priv_key){
    return k.get_cypher(password, priv_key);
}

std::string signTransaction(const string& priv_key_str, const string& contract,
                            const string& senderstr, const string& recipientstr, const string& amountstr,
                            const string& memo, const string& infostr, const string& abistr ,
                            uint32_t max_cpu_usage_ms, uint32_t max_net_usage_words , uint32_t tx_expiration = 120  ){
    return k.signTransaction(priv_key_str, contract, senderstr, recipientstr, amountstr,
                             memo, infostr, abistr ,  max_cpu_usage_ms,  max_net_usage_words ,  tx_expiration  );
}
std::string create_abi_req(const string& code, const string& action, const string& from, const string& to, const string& quantity){
    return k.create_abi_req(code, action, from, to, quantity);
}
