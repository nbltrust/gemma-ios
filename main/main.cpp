#include <iostream>
#include <vector>
#include <keosdlib.cpp>
#include <fc/exception/exception.hpp>
using namespace std;

int main(int argc, char** argv)
{
    keosdlib k;
    cout << "Keosdlib" << endl;
    while (true) {
        cout << "\nOptions:" << endl;
        cout << "  0: Set direction;" << endl;
        cout << "  1: Create a wallet;" << endl;
        cout << "  2: Open a wallet;" << endl;
        cout << "  3: Unlock a wallet;" << endl;
        cout << "  4: Lock a wallet;" << endl;
        cout << "  5: Lock all wallets;" << endl;
        cout << "  6: List all wallets;" << endl;
        cout << "  7: List all keys;" << endl;
        cout << "  8: Set timeout;" << endl;
        cout << "  9: Get public keys;" << endl;
        cout << "  10: Create key;" << endl;
        cout << "  11: Import key;" << endl;
        cout << "  12: Sign transaction;" << endl;
        cout << "  -1: Stop.\n" << endl;
        int x;
        cin >> x;
        if (x == -1) {
            break;
        }
        else if (x == 0) {
            cout << "Please input the direction of wallet:" << endl;
            string s;
            cin >> s;
            try {
                k.setDir(s);
                cout << "Successful!" << endl;
            }
            catch (const fc::exception& e) {
                cout << e.to_detail_string() << endl;
            }
        }
        else if (x == 1) {
            cout << "Please input the name of your wallet:" << endl;
            string s;
            cin >> s;
            try {
                string pw = k.create(s);
                cout << "Successful!" << endl;
                cout << "The password of your wallet is:\n" << pw << endl;
            }
            catch (const fc::exception& e) {
                cout << e.to_detail_string() << endl;
            }
        }
        else if (x == 2) {
            cout << "Please input the name of your wallet:" << endl;
            string s;
            cin >> s;
            try {
                k.open(s);
                cout << "Successful!" << endl;
            }
            catch (const fc::exception& e) {
                cout << e.to_detail_string() << endl;
            }
        }
        else if (x == 3) {
            cout << "Please input the name of your wallet:" << endl;
            string s1;
            cin >> s1;
            cout << "Please input the password of your wallet:" << endl;
            string s2;
            cin >> s2;
            // if (s1 == "1") { s2 = "PW5KWexGuCtPfRA4bTKDCEorGtT7vBTBjtHz1ZX62HLLFmbyAUsu4"; }
            // else if (s1 == "default") { s2 = "PW5JYPazJzvw4o8xVSQLxgNPzWVdNuQr2Cb4BNw2oKpgnF6nBmc42"; }
            try {
                k.unlock(s1, s2);
                cout << "Successful!" << endl;
            }
            catch (const fc::exception& e) {
                cout << e.to_detail_string() << endl;
            }
        }
        else if (x == 4) {
            cout << "Please input the name of your wallet:" << endl;
            string s;
            cin >> s;
            try {
                k.lock(s);
                cout << "Successful!" << endl;
            }
            catch (const fc::exception& e) {
                cout << e.to_detail_string() << endl;
            }
        }
        else if (x == 5) {
            try {
                k.lock_all();
                cout << "Successful!" << endl;
            }
            catch (const fc::exception& e) {
                cout << e.to_detail_string() << endl;
            }
        }
        else if (x == 6) {
            try {
                vector<string> result = k.listWallets();
                cout << "Successful!" << endl;
                cout << "The current opened wallets are:" << endl;
                for (int i = 0; i < result.size(); i++) {
                    cout << "  " << result[i] << endl;
                }
            }
            catch (const fc::exception& e) {
                cout << e.to_detail_string() << endl;
            }
        }
        else if (x == 7) {
            try {
                map<string, string> result = k.listKeys();
                cout << "Successful!" << endl;
                cout << "The keys of current opened wallets are:" << endl;
                for (const auto& keys : result) {
                    cout << "  Public key:  " << keys.first << endl;
                    cout << "  Private key: " << keys.second << endl;
                    cout << endl;
                }
            }
            catch (const fc::exception& e) {
                cout << e.to_detail_string() << endl;
            }
        }
        else if (x == 8) {
            cout << "Please input the time:" << endl;
            int t;
            cin >> t;
            try {
                k.setTimeOut(t);
            }
            catch (const fc::exception& e) {
                cout << e.to_detail_string() << endl;
            }
        }
        else if (x == 9) {
            try {
                vector<string> result = k.getPublicKeys();
                cout << "Successful!" << endl;
                cout << "The public keys of current opened wallets are:" << endl;
                for (int i = 0; i < result.size(); i++) {
                    cout << "  " << result[i] << endl;
                }
            }
            catch (const fc::exception& e) {
                cout << e.to_detail_string() << endl;
            }
        }
        else if (x == 10) {
            try {
                cout << "Please input the name of your wallet:" << endl;
                string s;
                cin >> s;
                string result = k.createKey(s, "");
                cout << "Successful!" << endl;
                cout << "The created keys are:\n" << result << endl;
            }
            catch (const fc::exception& e) {
                cout << e.to_detail_string() << endl;
            }
        }
        else if (x == 11) {
            try {
                cout << "Please input the name of your wallet:" << endl;
                string s1;
                cin >> s1;
                cout << "Please input the key:" << endl;
                string s2;
                cin >> s2;
                k.importKey(s1, s2);
                cout << "Successful!" << endl;
            }
            catch (const fc::exception& e) {
                cout << e.to_detail_string() << endl;
            }
        }
        else if (x == 12) {
            try {
                string result = k.signTransaction("[{\"expiration\":\"2018-05-22T06:32:17\",\"ref_block_num\":2288,\"ref_block_prefix\":2882789453,\"max_net_usage_words\":0,\"max_cpu_usage_ms\":0,\"delay_sec\":0,\"context_free_actions\":[],\"actions\":[{\"account\":\"eosio.token\",\"name\":\"transfer\",\"authorization\":[{\"actor\":\"user\",\"permission\":\"active\"}],\"data\":\"00000000007015d6000000005c95b1ca343000000000000004454f5300000000016d\"}],\"transaction_extensions\":[],\"signatures\":[],\"context_free_data\":[]},[\"EOS5BnCwCYrwgMfJnDW9sGPwrsvSZRdck1csKBDdWB2Qtb1EJ6Wmw\"],\"0000000000000000000000000000000000000000000000000000000000000000\"]");
                cout << "Successful!" << endl;
                cout << "Responses are:\n" << result << endl;
            }
            catch (const fc::exception& e) {
                cout << e.to_detail_string() << endl;
            }
        }
        else {
            cout << "Invaild input!" << endl;
        }
    }
   return 0;
}
