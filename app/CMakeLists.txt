cmake_minimum_required(VERSION 3.20)

project(app C CXX)

include(functions.cmake)

include(../libnaothello/bin/libnaothello.cmake) # build output of the NativeAOT compilation

include(nativeaot.cmake)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
  add_library(naothello STATIC IMPORTED)
  set_property(TARGET naothello PROPERTY IMPORTED_LOCATION "${LIBNAOTHELLO_PATH}")
  target_link_options (naothello INTERFACE "LINKER:--exclude-libs=libnaothello.a")
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
  ## FIXME: because we're not telling cmake that ${LIBNAOTHELLO_LIBPATH}/libnaothello.a is a
  ## dependency, this doesn't relink helloLib if libnaothello.a changes since Cmake doesn't
  ## understand the -hidden-lx switch.
  add_library(naothello INTERFACE IMPORTED)
  target_link_directories(naothello INTERFACE "${LIBNAOTHELLO_LIBPATH}")
  target_link_libraries(naothello INTERFACE "-Wl,-hidden-lnaothello")
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
  add_library(naothello STATIC IMPORTED)
  set_property(TARGET naothello PROPERTY IMPORTED_LOCATION "${LIBNAOTHELLO_PATH}")
endif()
target_include_directories(naothello INTERFACE "../libnaothello/inc")
# target_link_options(naothello INTERFACE "-Wl,-u,NativeAOT_StaticInitialization") # see https://github.com/dotnet/runtime/pull/89291


add_library(helloLib SHARED)

if(NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
  set_property(TARGET helloLib PROPERTY OUTPUT_NAME hello)
else()
  set_property(TARGET helloLib PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

  # if doing a debug build, tell the linker to not link ucrt.lib which was used by the nativeaot build to build the support libraries.
  target_link_options(helloLib PRIVATE "$<$<CONFIG:Debug>:/NODEFAULTLIB:libcmt;/NODEFAULTLIB:libcpmt>")
endif()

target_sources(helloLib PRIVATE src/hello.cxx src/hello.h)
set_property(TARGET helloLib PROPERTY C_VISIBILITY_PRESET hidden)
set_property(TARGET helloLib PROPERTY CXX_VISIBILITY_PRESET hidden)
target_link_libraries(helloLib PRIVATE nativeAotFramework naothello)
target_include_directories(helloLib PUBLIC src)
target_compile_definitions(helloLib PRIVATE -DCOMPILING_HELLOLIB)

add_executable(hello)
target_sources(hello PRIVATE src/main.c)
target_link_libraries(hello PRIVATE helloLib)

install(TARGETS hello helloLib)
