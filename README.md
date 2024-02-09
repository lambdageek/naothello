# experimenting with NativeAOT static libs

Requires Cmake and .NET 8

## Building

``` console
$ dotnet publish -r linux-x64 libnaothello/libnaothello.csproj
$ cmake -S app -B app/out
$ cmake --build app/out
```
