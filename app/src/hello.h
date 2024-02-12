#ifndef HELLOLIB_H
#define HELLOLIB_H

#ifdef __cplusplus
extern "C"
{
#endif

#ifndef _MSC_VER
#ifdef COMPILING_HELLOLIB
#define HELLOLIB_API __attribute__((visibility("default")))
#else
#define HELLOLIB_API /*empty*/
#endif
#else
#if defined(COMPILING_HELLOLIB)
#define HELLOLIB_API __declspec(dllexport)
#else
#define HELLOLIB_API __declspec(dllimport)
#endif
#endif

    int HELLOLIB_API
    hellolib_main(void);

#ifdef __cplusplus
} // extern "C"
#endif

#endif
