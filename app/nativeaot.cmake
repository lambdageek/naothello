# following https://github.com/dotnet/runtime/issues/70277#issuecomment-1575293355

# depends on NATIVEAOT_FRAMEWORK_PATH and NATIVEAOT_SDK_PATH to be set
# the sample sets is by generating the bin/libnaothello.cmake fragment during the managed build

set(NAOT_SDK_BASE_BOOTSTRAP
  ${CMAKE_STATIC_LIBRRAY_PREFIX}bootstrapperdll${CMAKE_C_OUTPUT_EXTENSION})
set(NAOT_SDK_BASE_LIBS
  Runtime.WorkstationGC
  eventpipe-disabled)

if(NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
  list(APPEND NAOT_SDK_BASE_LIBS stdc++compat)
else()
  list(APPEND NAOT_SDK_BASE_LIBS
    Runtime.VxsortEnabled
    System.Globalization.Native.Aot
    System.IO.Compression.Native.Aot
  )
endif()

addprefix(NAOT_SDK_BOOTSTRAP "${NATIVEAOT_SDK_PATH}" "${NAOT_SDK_BASE_BOOTSTRAP}")
addprefix(NAOT_SDK_LIBS "${NATIVEAOT_SDK_PATH}" "${NAOT_SDK_BASE_LIBS}")

if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
  set(NAOT_FRAMEWORK_BASE_LIBS)
else()
  set(NAOT_FRAMEWORK_BASE_LIBS
    System.Native
    System.Globalization.Native
    System.IO.Compression.Native
    System.Net.Security.Native
    System.Security.Cryptography.Native.OpenSsl)
endif()

addprefix(NAOT_FRAMEWORK_LIBS "${NATIVEAOT_FRAMEWORK_PATH}" "${NAOT_FRAMEWORK_BASE_LIBS}")

if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
  list(TRANSFORM NAOT_FRAMEWORK_LIBS APPEND "${CMAKE_STATIC_LIBRARY_SUFFIX}")
  list(TRANSFORM NAOT_SDK_LIBS APPEND "${CMAKE_STATIC_LIBRARY_SUFFIX}")
endif()

add_library(nativeAotFramework INTERFACE)

if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
  string(REPLACE ";" ":" NAOT_SDK_EXCLUDE_ARG "${NAOT_SDK_BASE_LIBS}")
  string(REPLACE ";" ":" NAOT_FRAMEWORK_EXCLUDE_ARG "${NAOT_FRAMEWORK_BASE_LIBS}")
  target_link_libraries(nativeAotFramework INTERFACE "${NAOT_SDK_BOOTSTRAP}" "${NAOT_SDK_LIBS}" "${NAOT_FRAMEWORK_LIBS}" -lm)
  target_link_options(nativeAotFramework INTERFACE "LINKER:--exclude-libs=${NAOT_SDK_EXCLUDE_ARG}:${NAOT_FRAMEWORK_EXCLUDE_ARG}")
  target_link_options(nativeAotFramework INTERFACE "LINKER:--discard-all")
  target_link_options(nativeAotFramework INTERFACE "LINKER:--gc-sections")
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
  list(TRANSFORM NAOT_SDK_BASE_LIBS PREPEND "-Wl,-hidden-l" OUTPUT_VARIABLE NAOT_SDK_HIDDEN_LIBS)
  list(TRANSFORM NAOT_FRAMEWORK_BASE_LIBS PREPEND "-Wl,-hidden-l" OUTPUT_VARIABLE NAOT_FRAMEWORK_HIDDEN_LIBS)
  target_link_directories(nativeAotFramework INTERFACE "${NATIVEAOT_FRAMEWORK_PATH}" "${NATIVEAOT_SDK_PATH}")
  target_link_libraries(nativeAotFramework INTERFACE "${NAOT_SDK_BOOTSTRAP}" "${NAOT_SDK_HIDDEN_LIBS}" "${NAOT_FRAMEWORK_HIDDEN_LIBS}" -lm)
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
  target_link_directories(nativeAotFramework INTERFACE "${NATIVEAOT_FRAMEWORK_PATH}" "${NATIVEAOT_SDK_PATH}")
  target_link_libraries(nativeAotFramework INTERFACE "${NAOT_SDK_BOOTSTRAP}" "${NAOT_SDK_LIBS}" "${NAOT_FRAMEWORK_LIBS}" BCrypt)
endif()
