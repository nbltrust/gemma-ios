#include <iostream>
#include <vector>
#include <keosdlib.hpp>
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
