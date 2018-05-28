cmake_minimum_required( VERSION 3.5 )
set(CMAKE_C_COMPILER "/usr/local/opt/llvm@4/bin/clang")
set(CMAKE_CXX_COMPILER "/usr/local/opt/llvm@4/bin/clang++")
project( EOS-Mobile-Lib )

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/libraries/fc/CMakeModules")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMakeModules")

include( GNUInstallDirs )
include( VersionMacros )
include( SetupTargetMacros )
include( InstallDirectoryPermissions )

set( CMAKE_CXX_STANDARD 14 )
set( CMAKE_CXX_EXTENSIONS ON )
set( CXX_STANDARD_REQUIRED ON)


SET( Boost_USE_STATIC_LIBS ON CACHE STRING "ON or OFF" )
IF( WIN32 )
  SET(BOOST_ROOT $ENV{BOOST_ROOT})
  set(Boost_USE_MULTITHREADED ON)
  set(BOOST_ALL_DYN_LINK OFF) # force dynamic linking for all libraries
ENDIF(WIN32)
FIND_PACKAGE(Boost 1.66 REQUIRED COMPONENTS
    thread
    date_time
    filesystem
    system
    program_options
    signals
    serialization
    chrono
    unit_test_framework
    context
    locale
    iostreams)

include(wasm)

add_subdirectory(externals)
add_subdirectory(contracts)
add_subdirectory(libraries)
add_subdirectory(plugins)
add_subdirectory(keosdlib)
add_subdirectory(main)
