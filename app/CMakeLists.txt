cmake_minimum_required(VERSION 3.20)

project (app C)

include(functions.cmake)

include(nativeaot.cmake)

add_library(naothello STATIC IMPORTED)
set_property(TARGET naothello PROPERTY IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/../libnaothello/bin/Release/net8.0/linux-x64/native/libnaothello.a")
target_include_directories(naothello INTERFACE "../libnaothello/inc")
target_link_options(naothello INTERFACE "-Wl,-u,NativeAOT_StaticInitialization")

add_executable(hello)
target_sources (hello PRIVATE src/hello.c)
target_link_libraries(hello PRIVATE nativeAotFramework naothello)
target_link_options(hello PRIVATE "-Wl,--version-script=${CMAKE_SOURCE_DIR}/hello.exports")
set_target_properties(hello PROPERTIES LINK_DEPENDS "${CMAKE_SOURCE_DIR}/hello.exports")

install(TARGETS hello)
