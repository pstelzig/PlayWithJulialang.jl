using PyCall
using LinearAlgebra

# Functions defined in as inlined Python code #################################
py"""
def pysum(a): 
    s = 0.0
    for i in range(0, len(a)):
        s += a[i]

    return s
"""

sum_py = py"pysum"
ar1 = [1.0, 2.0, 3.0]
println("pysum(ar1)=$(sum_py(ar1))")

# Imported modules ############################################################
np = pyimport("numpy")
A = np.random.rand(3,3)
Ainv = np.linalg.inv(A)
println("A=$A")
res = A*Ainv - I
println("||res||=$(norm(res))")