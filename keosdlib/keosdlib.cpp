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
    std::string create(const std::string& name) {
        return walletManager.create(name);
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
    int func() {
        return 1;
    }

    // Create key
    std::string createKey(const std::string& name, const std::string& key_type) {
        return walletManager.create_key(name, key_type);
    }

    // Import key
    void importKey(const std::string& name, const std::string& wif_key) {
        walletManager.import_key(name, wif_key);
    }

    // Sign transaction
    std::string signTransaction(const std::string& data) {
        const auto& vs = fc::json::json::from_string(data);
        eosio::chain::signed_transaction res = walletManager.sign_transaction(vs[size_t(0)].as<eosio::chain::signed_transaction>(),vs[size_t(1)].as<flat_set<public_key_type>>(),vs[size_t(2)].as<eosio::chain::chain_id_type>());
        return fc::json::json::to_string(variant(res));
    }
};
