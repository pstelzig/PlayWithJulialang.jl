using Plots;
using Colors;

# Elementary stuff ############################################################
println("Hello world!")
mystr1 = "It works "
mystr2 = "now"
println("$mystr1"*mystr2)

palette = distinguishable_colors(10)

rand(palette, 3, 3)

# Dictionaries ################################################################
mydict = Dict('a' => 1, 'b' => 2, "monty" => 1970, "python" => "Eric Idle")
mydict["hungarian"] = "phrasebook"
println("mydict[\"python\"]=$(mydict["python"]) and it has a $(mydict["hungarian"])")

# Plotting ####################################################################
f = x -> x*(x-1)
xvals = -1:0.1:1
plot(xvals, f.(xvals))