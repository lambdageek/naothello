# experimenting with NativeAOT static libs

Requires Cmake and .NET 8

## Building on Linux or Mac

``` console
$ dotnet publish -r linux-x64 libnaothello/libnaothello.csproj
$ cmake -S app -B app/out
$ cmake --build app/out
```

## Building on Windows

Only the release configuration is supported

```console
dotnet publish -r win-x64 libnaothello\libnaothello.csproj
cmake -S app -B app/out
cmake --build app/out --config Release
```
