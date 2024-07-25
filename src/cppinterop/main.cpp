#include <iostream>
#include <dlfcn.h>

typedef void* (*InitHandle)(int);
typedef int (*CallHandle)(void*);
typedef void (*DestroyHandle)(void*);

int main() 
{
    // Open for first time
    void* libHandle = dlopen("./libcppobjects.so", RTLD_LAZY);
    
    InitHandle initsym = reinterpret_cast<InitHandle>(dlsym(libHandle, "init"));
    CallHandle callsym = reinterpret_cast<CallHandle>(dlsym(libHandle, "call"));    
    DestroyHandle destroysym = reinterpret_cast<DestroyHandle>(dlsym(libHandle, "destroy"));    

    void* obj = initsym(0);
    int nCalls = callsym(obj);
    destroysym(obj);

    dlclose(libHandle);

    // Open second time
    libHandle = dlopen("./libcppobjects.so", RTLD_LAZY);
    
    initsym = reinterpret_cast<InitHandle>(dlsym(libHandle, "init"));
    callsym = reinterpret_cast<CallHandle>(dlsym(libHandle, "call"));    
    destroysym = reinterpret_cast<DestroyHandle>(dlsym(libHandle, "destroy"));    

    obj = initsym(0);
    nCalls = callsym(obj);
    destroysym(obj);

    dlclose(libHandle);

    return 0;
}