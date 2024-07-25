using Libdl

#=
A hint on calling C functions with void argument. The syntax is

ccall(("function_name", "lib_path"), <Return type in Julia>, ())

like 

ccall(("init", "./libcppobjects.so"), Ptr{Cvoid}, ())

for calling 

void* init(void);

Note that the void argument in the call is specified by () and _no_ argument 
value is given in the otherwise following argument list!
=#

this_folder = splitdir(@__FILE__)[1]

# Simple function call ########################################################
println("# Doing simple vecsum function call...")
X = rand(1000)
X_sum = ccall(("sum", "$this_folder/libvecsum.so"), Float64, (Csize_t, Ptr{Float64}), length(X), X)
println("sum as returned from library is $X_sum and should be $(sum(X))")

# Now transferring data back and forth through an opaque pointer ##############
#= 
Opening per Libdl and dlopen. Can close lib in between.

See the static int counter when instaniating a second object instance:
it will reset after closing. But only if compiled with clang, g++ does not
unload correctly. This is not a Julia bug, but rather a C++ bug.
=#

println("# Opening for 1st time and closing...")
cppLib = Libdl.dlopen("$this_folder/libcppobjects.so")

initsym = Libdl.dlsym(cppLib, "init")
namesym = Libdl.dlsym(cppLib, "name")
callsym = Libdl.dlsym(cppLib, "call")
destroysym = Libdl.dlsym(cppLib, "destroy")

ptr1 = ccall(initsym, Ptr{Cvoid}, ())
name = unsafe_string(ccall(namesym, Cstring, (Ptr{Cvoid},), ptr1))
calls = ccall(callsym, Int64, (Ptr{Cvoid},), ptr1)
println("nCalls on $name: $calls")

ccall(destroysym, Cvoid, (Ptr{Cvoid},), ptr1)
Libdl.dlclose(cppLib)

println("# Opening for 2nd time and closing...")
cppLib = Libdl.dlopen("$this_folder/libcppobjects.so")

initsym = Libdl.dlsym(cppLib, "init")
namesym = Libdl.dlsym(cppLib, "name")
callsym = Libdl.dlsym(cppLib, "call")
destroysym = Libdl.dlsym(cppLib, "destroy")

ptr2 = ccall(initsym, Ptr{Cvoid}, ())
calls = ccall(callsym, Int64, (Ptr{Cvoid},), ptr2)
name = unsafe_string(ccall(namesym, Cstring, (Ptr{Cvoid},), ptr2))
calls = ccall(callsym, Int64, (Ptr{Cvoid},), ptr2)
println("nCalls on $name: $calls")

ccall(destroysym, Cvoid, (Ptr{Cvoid},), ptr2)
Libdl.dlclose(cppLib)

#= 
Opening per ccall and function per string literal. 
Lib will remain loaded until Julia REPL is restarted. 

See the static int counter when instaniating a second object instance:
it will continue counting.
=#
ptr3 = ccall(("init", "$this_folder/libcppobjects.so"), Ptr{Cvoid}, ())
ptr4 = ccall(("init", "$this_folder/libcppobjects.so"), Ptr{Cvoid}, ())

name = unsafe_string(ccall(("name", "$this_folder/libcppobjects.so"), Cstring, (Ptr{Cvoid},), ptr3))
calls = ccall(("call", "$this_folder/libcppobjects.so"), Int64, (Ptr{Cvoid},), ptr3)
println("nCalls on $name: $calls")

name = unsafe_string(ccall(("name", "$this_folder/libcppobjects.so"), Cstring, (Ptr{Cvoid},), ptr3))
calls = ccall(("call", "$this_folder/libcppobjects.so"), Int64, (Ptr{Cvoid},), ptr3)
println("nCalls on $name: $calls")

ccall(("destroy", "$this_folder/libcppobjects.so"), Cvoid, (Ptr{Cvoid},), ptr3)
ccall(("destroy", "$this_folder/libcppobjects.so"), Cvoid, (Ptr{Cvoid},), ptr4)