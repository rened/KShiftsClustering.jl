println("\n\n\nStarting runtests.jl $(join(ARGS, " ")) ...")

using Tests
using KShiftsClustering

getdata(n) = 10*rand(1, n) .+ 0.5

centers = kshifts(getdata(1_000_000), 10)
@test all(round.(Int, sort(vec(centers)))  .==  collect(1:10))

centers = kshifts(getdata(1000), 10)
for i = 1:100
    kshifts!(centers, getdata(1000))
end
@test all(round.(Int, sort(vec(centers)))  .==  collect(1:10))

