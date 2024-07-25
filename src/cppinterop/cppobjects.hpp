#ifndef CINJULIA_CPPOBJECTS_HPP
#define CINJULIA_CPPOBJECTS_HPP

/*
 * Compile with 
 *
 *     g++ -shared -fPIC cppobjects.hpp cppobjects.cpp -o ./libcppobjects.so
 * 
 * or 
 * 
 *      clang -I /usr/include/c++/11/ -I /usr/include/x86_64-linux-gnu/c++/11 -L /usr/lib/gcc/x86_64-linux-gnu/11/ -lstdc++  -shared -fPIC -x c++ cppobjects.hpp cppobjects.cpp -o ./libcppobjects.so
 * 
 * The include directories and the library directory is needed under Ubuntu 22.04 because of an issue with clang and g++
 */ 
#include <iostream>
#include <string>

class CppObject
{
public:
    CppObject(const std::string& name);
    ~CppObject();

    void call(); 
    const char* name();
    int nCalls(); 
    static int s_id;

private:
    std::string m_name;
    int m_nCalls;
};

extern "C" void* init();
extern "C" const char* name(void* obj);
extern "C" int call(void* obj);
extern "C" void destroy(void* obj);

#endif // CINJULIA_CPPOBJECTS_HPP