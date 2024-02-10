#ifndef HELLOLIB_H
#define HELLOLIB_H

#ifdef COMPILING_HELLOLIB
#define HELLOLIB_API __attribute__((visibility("default")))
#else
#define HELLOLIB_API /*empty*/
#endif

int HELLOLIB_API
hellolib_main (void);


#endif
