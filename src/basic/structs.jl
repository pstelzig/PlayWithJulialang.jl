using Plots, Images

this_folder = splitdir(@__FILE__)[1]

# Struct and methods for creating a grayscale contour plot ####################
mutable struct ContourPixels
    name::String
    xs::Tuple{Float64,Float64}
    ys::Tuple{Float64,Float64}
    nx::Int64
    ny::Int64
    f::Function
    px::Array{Float64, 2}

    function ContourPixels(name, xrange, yrange, nx, ny, f)
        # Construct pixel array
        ar = zeros(nx, ny)
        
        # Initial filling        
        dx = (xrange[2] - xrange[1])/nx
        xvals = xrange[1]:dx:xrange[2]

        dy = (yrange[2] - yrange[1])/ny
        yvals = yrange[1]:dy:yrange[2]

        for i in 1:nx, j in 1:ny
            ar[i,j] = f(xvals[i],yvals[j])
        end

        # Affine transformation to [0,1] to be interpreted as grayscale
        fmin = minimum(ar)
        fmax = maximum(ar)
        scale = 1.0/(fmax - fmin)

        ar = scale*(ar .- fmin)

        new(name, xrange, yrange, nx, ny, f, ar)
    end
end

function saveContour(img::ContourPixels, fname::String)
    save(fname, colorview(Gray, img.px))
end

function resample!(img::ContourPixels, nxnew, nynew)
    img.nx = nxnew
    img.ny = nynew

    # Construct new pixel array
    img.px = zeros(nxnew, nynew)
    
    # Initial filling        
    dx = (img.xs[2] - img.xs[1])/img.nx
    xvals = img.xs[1]:dx:img.xs[2]

    dy = (img.ys[2] - img.ys[1])/img.ny
    yvals = img.ys[1]:dy:img.ys[2]

    for i in 1:img.nx, j in 1:img.ny
        img.px[i,j] = img.f(xvals[i],yvals[j])
    end

    # Affine transformation to [0,1] to be interpreted as grayscale
    fmin = minimum(img.px)
    fmax = maximum(img.px)
    scale = 1.0/(fmax - fmin)

    img.px = scale*(img.px .- fmin)
end


# Some experiments ############################################################
f(x,y) = 2*exp(-(x^2 + y^2))-0.5
bell = ContourPixels("Gauss Bell Curve", (-1,1), (-1,1), 100, 100, f)

expsin(x,y) = f(x,y)*sin((x^2 + y^2))
dampedwave = ContourPixels("Damped wave", (-5,5), (-5,5), 200, 200, expsin)

plot(colorview(Gray, bell.px))
saveContour(bell, "$this_folder/rbf.png")
saveContour(dampedwave, "$this_folder/dampedwave.png")

resample!(dampedwave, 400,400)
saveContour(dampedwave, "$this_folder/dampedwavefine.png")