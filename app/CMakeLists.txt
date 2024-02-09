cmake_minimum_required(VERSION 3.20)

project (app C)

include(functions.cmake)

include(../libnaothello/bin/libnaothello.cmake) # build output of the NativeAOT compilation

include(nativeaot.cmake)

add_library(naothello STATIC IMPORTED)
set_property(TARGET naothello PROPERTY IMPORTED_LOCATION "${LIBNAOTHELLO_PATH}")
target_include_directories(naothello INTERFACE "../libnaothello/inc")
# target_link_options(naothello INTERFACE "-Wl,-u,NativeAOT_StaticInitialization") # see https://github.com/dotnet/runtime/pull/89291

add_executable(hello)
target_sources (hello PRIVATE src/hello.c)
target_link_libraries(hello PRIVATE nativeAotFramework naothello)
if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
  target_link_options(hello PRIVATE "-Wl,--version-script=${CMAKE_SOURCE_DIR}/hello.exports")
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
  message("on apple")
  target_link_options(hello PRIVATE -framework Foundation)
endif()
set_target_properties(hello PROPERTIES LINK_DEPENDS "${CMAKE_SOURCE_DIR}/hello.exports")

install(TARGETS hello)
