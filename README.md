# experimenting with NativeAOT static libs

Requires Cmake and .NET 8

## Building on Linux or Mac

``` console
$ dotnet publish -r linux-x64 libnaothello/libnaothello.csproj
$ cmake -S app -B app/out
$ cmake --build app/out
```

## Building on Windows

Build and Release configurations of the native code are supported.
(See <https://github.com/dotnet/runtime/issues/98356> for why it's ok to use the NativeAOT support libs that were compiled against the Release CRT in a Debug build of the app)

```console
dotnet publish -r win-x64 libnaothello\libnaothello.csproj
cmake -S app -B app/out
```

Default (debug) build:

```console
cmake --build app/out 
```

or

```console
cmake --build app/out --config Release
```
