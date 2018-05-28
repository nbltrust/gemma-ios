add_library( keosdlib keosdlib.cpp )

target_link_libraries( keosdlib
    wallet_plugin 
    eosio_chain 
    appbase 
    fc
)
target_include_directories( keosdlib PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}" )

