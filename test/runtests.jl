println("\n\n\nStarting runtests.jl $(join(ARGS, " ")) ...")
using FactCheck, KShiftsClustering

getdata(n) = 10*rand(1, n) + 0.5
facts("all") do
    centers = kshifts(getdata(1_000_000), 10)
    @fact round(Int, sort(vec(centers)))  -->  collect(1:10)

    centers = kshifts(getdata(1000), 10)
    for i = 1:100
        kshifts!(centers, getdata(1000))
    end
    @fact round(Int, sort(vec(centers)))  -->  collect(1:10)

    centers, ids = kshiftmedoids(rand(10, 100000), 10)

    centers = kshifts(rand(2,1000), 10)
end
