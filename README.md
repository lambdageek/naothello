# experimenting with NativeAOT static libs

Requires cmake and .NET 8

## Building: shared vs static

By default on Linux and Mac we build a static library using NativeAOT and link it into the main
application library `libhello`.  On Windows, the default is a static library unless you do a `Debug`
publish (not the default).

It is possible to override the default on every platform using `-p:NativeLib=[shared|static]`.

Note that on Windows you must build the native bits in the `Release` configuration to consume a
static library.  Otherwise there will be native linker errors due to NativeAOT components being
compiled with the Release MSVC.

### Building on Linux or Mac


``` console
$ dotnet publish -r linux-x64 libnaothello/libnaothello.csproj
$ cmake -S app -B app/out
$ cmake --build app/out
```

### Building on Windows

#### Static library

```console
dotnet publish -r win-x64 libnaothello\libnaothello.csproj
cmake -S app -B app/out
cmake --build app/out --config Release
```

Only Release config builds work with the static library.

#### Shared library

```console
dotnet publish -r win-x64 libnaothello\libnaothello.csproj -p:NativeLib=shared
cmake -S app -B app/out
```

``` console
cmake --build app/out --config Release
```

or

Default (Debug) build:

```console
cmake --build app/out 
```


