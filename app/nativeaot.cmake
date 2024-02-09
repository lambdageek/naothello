
# following https://github.com/dotnet/runtime/issues/70277#issuecomment-1575293355

set(NUGET_PACKAGES_DIR "$ENV{HOME}/.nuget/packages")

set(NAOT_NUGET_DIR "${NUGET_PACKAGES_DIR}/runtime.linux-x64.microsoft.dotnet.ilcompiler/8.0.0")
set(NAOT_SDK_DIR "${NAOT_NUGET_DIR}/sdk")
set(NAOT_FRAMEWORK_DIR "${NAOT_NUGET_DIR}/framework")



set(NAOT_SDK_LIBS
  libbootstrapperdll.o
  libRuntime.WorkstationGC.a
  libeventpipe-disabled.a
  libstdc++compat.a)

addprefix(NAOT_SDK_LIBS "${NAOT_SDK_DIR}" "${NAOT_SDK_LIBS}")

set(NAOT_FRAMEWORK_LIBS
  libSystem.Native.a
  libSystem.Globalization.Native.a
  libSystem.IO.Compression.Native.a
  libSystem.Net.Security.Native.a
  libSystem.Security.Cryptography.Native.OpenSsl.a)

addprefix(NAOT_FRAMEWORK_LIBS "${NAOT_FRAMEWORK_DIR}" "${NAOT_FRAMEWORK_LIBS}")

add_library(nativeAotFramework INTERFACE)
target_link_libraries (nativeAotFramework INTERFACE "${NAOT_SDK_LIBS}" "${NAOT_FRAMEWORK_LIBS}" -lm)

