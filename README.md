1. Required dependencies: 
        boost library 1.66.0;
        secp256k1-zkp;
        LLVM with WASM support;
        OpenSSL;
2. Build proess: 
        (1) cd [project]
        (2) mkdir build
        (3) cd build
        (4) cmake ..
        (5) make
3. Keosd library locates in: [project]/build/keosdlib
4. Demo locates in: [project]/build/main
5. The default path of wallet is [project]/build/main
