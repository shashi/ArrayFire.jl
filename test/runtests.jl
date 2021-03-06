using ArrayFire
using Base.Test

setBackend(AF_BACKEND_CPU)

# AFArray creation
function test_constructor(f, dims, typ=AFArray{Float32})
    afa = f(typ, dims)
    @test size(afa) == dims
    afa = f(typ, dims...)
    @test size(afa) == dims
    afa
end

arr = test_constructor(rand, (10, 10))
@test eltype(arr) == Float32
arr = test_constructor(ones, (10, 10))
@test eltype(arr) == Float32
@test Array(arr) == ones(Float32, 10, 10)
arr = test_constructor(zeros, (10, 10))
@test eltype(arr) == Float32
@test Array(arr) == zeros(Float32, 10, 10)


#Basic math
a = rand(Float32, 10, 10)
ad = AFArray(a)
@test sumabs2(Array(ad + 2) - (a + 2)) < 1e-6
@test sumabs2(Array(ad - 2) - (a - 2)) < 1e-6
@test sumabs2(Array(ad * 2) - (a * 2)) < 1e-6
@test sumabs2(Array(ad / 2) - (a / 2)) < 1e-6
@test sumabs2(Array(ad .^ 2) - (a .^ 2)) < 1e-6

#Trig functions
@test sumabs2(Array(sin(ad)) - sin(a)) < 1e-6
@test sumabs2(Array(cos(ad)) - cos(a)) < 1e-6
@test sumabs2(Array(tan(ad)) - tan(a)) < 1e-6
@test sumabs2(Array(sinh(ad)) - sinh(a)) < 1e-6
@test sumabs2(Array(cosh(ad)) - cosh(a)) < 1e-6
@test sumabs2(Array(tanh(ad)) - tanh(a)) < 1e-6

#Measures
@test minimum(a) == minimum(ad)
@test maximum(a) == maximum(ad)
@test sumabs2(Array(maximum(ad,1)) - maximum(a,1)) < 1e-6
@test sumabs2(Array(maximum(ad,2)) - maximum(a,2)) < 1e-6
@test sumabs2(Array(minimum(ad,1)) - minimum(a,1)) < 1e-6
@test sumabs2(Array(minimum(ad,2)) - minimum(a,2)) < 1e-6
@test sumabs2(Array(max(ad,0.5)) - max(a,0.5)) < 1e-6
@test sumabs2(Array(min(ad,0.5)) - min(a,0.5)) < 1e-6
@test mean(ad) == mean(a)
@test sumabs2(Array(mean(ad,1)) - mean(a,1)) < 1e-6
@test sumabs2(Array(mean(ad,2)) - mean(a,2)) < 1e-6
@test median(ad) == median(a)
@test sumabs2(Array(median(ad,1)) - median(a,1)) < 1e-6
@test var(ad) == var(a)

#Linalg 
@test sumabs2(Array(ad') - a') < 1e-6
ld, ud, pd = lu(ad)
l, u, p = lu(a)
@test sumabs(Array(ld) - l) < 1e-5
@test sumabs(Array(ud) - u) < 1e-5 
@test sumabs(Array(pd) - p) < 1e-5 
@test sumabs2(Array(chol(ad*ad')) - chol(a*a')) < 1e-5
@test sumabs2(Array(ctranspose(chol(ad*ad'))) - ctranspose(chol(a*a'))) < 1e-5
ud, sd, vtd = svd(ad)
u, s, v = svd(a)
@test sumabs(Array(ud) - u) < 1e-4
@test sumabs(Array(sd) - s) < 1e-4
@test sumabs(Array(vtd') - v) < 1e-4

#Complex numbers 
@test Array(complex(ad,ad)) == complex(a,a)
@test Array(real(complex(ad,ad))) == real(complex(a,a))
@test Array(imag(complex(a,a))) == imag(complex(a,a))
