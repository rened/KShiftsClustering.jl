println("---")

using KShiftsClustering, FunctionalData

d = 10
srand(0)
data = @p rand Float32 d 100_000
centers = @p rand Float32 d 100

labels = zeros(Int,len(data))
kshiftslabels!(labels, take(data,100), take(centers,2))
@time kshiftslabels!(labels, data, centers)
Profile.clear_malloc_data()
@time kshiftslabels!(labels, data, centers)
@time kshiftslabels!(labels, data, centers)
@time kshiftslabels!(labels, data, centers)
@time kshiftslabels!(labels, data, centers)

