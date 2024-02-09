
# following https://github.com/dotnet/runtime/issues/70277#issuecomment-1575293355

# depends on NATIVEAOT_FRAMEWORK_PATH and NATIVEAOT_SDK_PATH to be set
# the sample sets is by generating the bin/libnaothello.cmake fragment during the managed build

set(NAOT_SDK_LIBS
  libbootstrapperdll.o
  libRuntime.WorkstationGC.a
  libeventpipe-disabled.a
  libstdc++compat.a)

addprefix(NAOT_SDK_LIBS "${NATIVEAOT_SDK_PATH}" "${NAOT_SDK_LIBS}")

set(NAOT_FRAMEWORK_LIBS
  libSystem.Native.a
  libSystem.Globalization.Native.a
  libSystem.IO.Compression.Native.a
  libSystem.Net.Security.Native.a
  libSystem.Security.Cryptography.Native.OpenSsl.a)

addprefix(NAOT_FRAMEWORK_LIBS "${NATIVEAOT_FRAMEWORK_PATH}" "${NAOT_FRAMEWORK_LIBS}")

add_library(nativeAotFramework INTERFACE)
target_link_libraries (nativeAotFramework INTERFACE "${NAOT_SDK_LIBS}" "${NAOT_FRAMEWORK_LIBS}" -lm)

