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
