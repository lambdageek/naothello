
# following https://github.com/dotnet/runtime/issues/70277#issuecomment-1575293355

# depends on NATIVEAOT_FRAMEWORK_PATH and NATIVEAOT_SDK_PATH to be set
# the sample sets is by generating the bin/libnaothello.cmake fragment during the managed build

set(NAOT_SDK_BASE_BOOTSTRAP
    libbootstrapperdll.o)
set(NAOT_SDK_BASE_LIBS
  libRuntime.WorkstationGC.a
  libeventpipe-disabled.a
  libstdc++compat.a)

addprefix(NAOT_SDK_BOOTSTRAP "${NATIVEAOT_SDK_PATH}" "${NAOT_SDK_BASE_BOOTSTRAP}")
addprefix(NAOT_SDK_LIBS "${NATIVEAOT_SDK_PATH}" "${NAOT_SDK_BASE_LIBS}")

set(NAOT_FRAMEWORK_BASE_LIBS
  libSystem.Native.a
  libSystem.Globalization.Native.a
  libSystem.IO.Compression.Native.a
  libSystem.Net.Security.Native.a
  libSystem.Security.Cryptography.Native.OpenSsl.a)

addprefix(NAOT_FRAMEWORK_LIBS "${NATIVEAOT_FRAMEWORK_PATH}" "${NAOT_FRAMEWORK_BASE_LIBS}")

add_library(nativeAotFramework INTERFACE)

if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
  string(REPLACE ";" ":" NAOT_SDK_EXCLUDE_ARG "${NAOT_SDK_BASE_LIBS}")
  string(REPLACE ";" ":" NAOT_FRAMEWORK_EXCLUDE_ARG "${NAOT_FRAMEWORK_BASE_LIBS}")
  target_link_libraries (nativeAotFramework INTERFACE "${NAOT_SDK_BOOTSTRAP}" "${NAOT_SDK_LIBS}" "${NAOT_FRAMEWORK_LIBS}" -lm)
  target_link_options (nativeAotFramework INTERFACE "LINKER:--exclude-libs=${NAOT_SDK_EXCLUDE_ARG}:${NAOT_FRAMEWORK_EXCLUDE_ARG}")
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
  list(TRANSFORM NAOT_SDK_LIBS PREPEND "-hidden-l" OUTPUT_VARIABLE NAOT_SDK_HIDDEN_LIBS)
  list(TRANSFORM NAOT_FRAMEWORK_LIBS PREPEND "-hidden-l" OUTPUT_VARIABLE NAOT_FRAMEWORK_HIDDEN_LIBS)
  target_link_libraries(nativeAotFramework INTERFACE "${NAOT_SDK_BOOTSTRAP}" "${NAOT_SDK_HIDDEN_LIBS}" "${NAOT_FRAMEWORK_HIDDEN_LIBS}" -lm)
endif()
target_link_options(nativeAotFramework INTERFACE "LINKER:--discard-all")
target_link_options(nativeAotFramework INTERFACE "LINKER:--gc-sections")
