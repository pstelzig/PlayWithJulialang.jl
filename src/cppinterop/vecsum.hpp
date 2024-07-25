#ifndef CINJULIA_VECSUM_HPP
#define CINJULIA_VECSUM_HPP

/*
 * Compile with 
 *
 *     g++ -shared -fPIC -x c++ vecsum.hpp -o ./libvecsum.so
 * 
 * The reason for the "-x c++" is that otherwise the hpp will not be recognized to contain C++ code.
 * Otherwise one could rename this file to vecsum.cpp and then
 * 
 *     g++ -shared -fPIC vecsum.cpp -o ./libvecsum.so
 * 
 * will produce the same output.
 */ 

#include <iostream> // Just to have some C++ inside

extern "C" double sum(size_t len, double* v) 
{
    double s = 0.0;

    for(int i = 0; i < len; ++i)
    {
        s += v[i];
    }

    std::cout << "Hi from the C++ shared object library! I'll do some computation now. \n\nsum = " << s << std::endl << std::endl;

    return s;
}

#endif // CINJULIA_VECSUM_HPP