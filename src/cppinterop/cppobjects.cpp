#include "cppobjects.hpp"

CppObject::CppObject(const std::string& name) : 
    m_name(name),
    m_nCalls(0) 
{
    s_id++;
}

CppObject::~CppObject() {}

const char* CppObject::name()
{
    return m_name.c_str();
}

void CppObject::call() 
{
    m_nCalls++;
}

int CppObject::nCalls() 
{
    return m_nCalls;
}

int CppObject::s_id = 0;

void* init() 
{
    std::cout << "Calling init ";

    CppObject* obj = new CppObject("CppObject_" + std::to_string(CppObject::s_id));

    std::cout << "and created object " << obj->name() << std::endl;    

    return obj;
}

const char* name(void* obj)
{
    std::cout << "Calling name ";    

    CppObject* cppObj = static_cast<CppObject*>(obj);    

    std::cout << "on object " << cppObj->name() << std::endl;

    return cppObj->name();
}

int call(void* obj) 
{
    std::cout << "Calling call ";    

    CppObject* cppObj = static_cast<CppObject*>(obj);

    std::cout << "on object " << cppObj->name() << std::endl;    

    cppObj->call();

    int nCalls = cppObj->nCalls();

    return nCalls;
}

void destroy(void* obj) 
{
    std::cout << "Calling destroy ";    

    CppObject* cppObj = static_cast<CppObject*>(obj);

    std::cout << "on object " << cppObj->name() << std::endl;    

    delete cppObj;

    return;    
}