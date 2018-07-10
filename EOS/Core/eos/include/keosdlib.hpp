#include <eosio/wallet_plugin/wallet_manager.hpp>
#include <eosio/chain/exceptions.hpp>
#include <boost/algorithm/string.hpp>
#include <fc/io/json.hpp>
#include <map>

class keosdlib {
private:
    eosio::wallet::wallet_manager walletManager;
public:
    keosdlib() = default;
    
    // Set time out
    void setTimeOut(const int& t) {
        const uint64_t s(t);
        walletManager.set_timeout(s);
    }
    
    // Set direction
    void setDir(const std::string& dir) {
        const boost::filesystem::path p(dir);
        walletManager.set_dir(p);
    }
    
    // Create wallet
    std::string create(const std::string& name, const std::string& password) {
        return walletManager.create(name, password);
    }
    
    // Open wallet
    void open(const std::string& name) {
        walletManager.open(name);
    }
    
    // Unlock
    void unlock(const std::string& name, const std::string& password) {
        walletManager.unlock(name, password);
    }
    
    // Lock
    void lock(const std::string& name) {
        walletManager.lock(name);
    }
    
    // Lock all
    void lock_all() {
        walletManager.lock_all();
    }
    
    // List wallets
    std::vector<std::string> listWallets() {
        return walletManager.list_wallets();
    }
    
    // List keys
    map<std::string, std::string> listKeys() {
        map<std::string, std::string> result;
        map<public_key_type,private_key_type> keys = walletManager.list_keys();
        for (const auto& k : keys) {
            result[string(k.first)] = string(k.second);
        }
        return result;
    }
    
    // Get public keys
    std::vector<std::string> getPublicKeys() {
        flat_set<public_key_type> keys = walletManager.get_public_keys();
        std::vector<std::string> result;
        for (const auto& k : keys) {
            result.push_back(string(k));
        }
        return result;
    }
    // int func() {
    //     return 1;
    // }
    
    // Create key
    // std::string createKey(const std::string& key_type) {
    // needed by koofrank
    pair<std::string, std::string> createKey(const std::string& key_type) {
        return eosio::wallet::wallet_manager::create_key(key_type);
    }
    // std::string createKey(const std::string& name, const std::string& key_type) {
    //     return walletManager.create_key(name, key_type);
    // }
    
    // std::pair<std::string, std::string> createKey(const std::string& name, const std::string& role, const std::string& password) {
    //     return walletManager.create_keypair(name, role, password);
    // }
    
    // Import key
    void importKey(const std::string& name, const std::string& wif_key) {
        walletManager.import_key(name, wif_key);
    }
    
    // needed by koofrank
    std::string get_private_key(const std::string& cipher_keys, const std::string& password){
        return eosio::wallet::wallet_manager::get_private_key(password, cipher_keys);
    }
    
    // needed by koofrank
    std::string get_cypher(const std::string& password, const std::string& priv_key){
        return eosio::wallet::wallet_manager::get_cipher(password, priv_key);
    }
    // Sign transaction
    std::string signTransaction(const string& priv_key_str, const string& contract, const string& senderstr, const string& recipientstr, const string& amountstr,
                                const string& memo, const string& infostr, const string& abistr , uint32_t max_cpu_usage_ms, uint32_t max_net_usage_words , uint32_t tx_expiration = 30  ){
        return eosio::wallet::wallet_manager::sign_transaction(priv_key_str, contract, senderstr, recipientstr, amountstr,
                                                               memo, infostr, abistr ,  max_cpu_usage_ms,  max_net_usage_words ,  tx_expiration  );
    }
    std::string create_abi_req(const string& code, const string& action, const string& from, const string& to, const string& quantity){
        return eosio::wallet::wallet_manager::create_abi(code, action, from, to, quantity);
    }
    
    
    // std::string signTransaction(const std::string& data) {
    //     const auto& vs = fc::json::json::from_string(data);
    //     eosio::chain::signed_transaction res = walletManager.sign_transaction(vs[size_t(0)].as<eosio::chain::signed_transaction>(),vs[size_t(1)].as<flat_set<public_key_type>>(),vs[size_t(2)].as<eosio::chain::chain_id_type>());
    //     return fc::json::json::to_string(variant(res));
    // }
};
