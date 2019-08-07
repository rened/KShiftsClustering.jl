module KShiftsClustering

using NearestNeighbors

export kshifts, kshifts!, kshiftslabels, kshiftslabels!, kshiftmedoids

function kshiftmedoids(data, k)
    centers = kshifts(data,k)
    tree = KDTree(float(data))
    ids = vec(mapslices(a -> knn(tree, a, 1)[1][1], centers, dims=1))

    return data[:,ids], ids
end

@inbounds @inline function dist(a::Matrix{T}, i::Int, b::Matrix{T}, j::Int) where T
    sum = zero(eltype(a))
    @simd for d = 1:size(a,1)
        sum += (a[d,i]-b[d,j])*(a[d,i]-b[d,j])
    end

    return sum
end

function kshifts(data::Array{T,2} where T, k::Int)
    centers = data[:,rand(1:size(data, 2), k)]
    kshifts!(centers, data)
end

@inbounds function kshifts!(centers::Array{T,2}, data::Array{T,2}) where T
    @assert size(data, 1) == size(centers, 1)
    f1 = 29/30
    f2 = 1-f1
    for i = 1:size(data, 2)
        data_view = view(data, :, i)
        v = typemax(eltype(centers))
        ind = 0
        for j = 1:size(centers, 2)
            d = dist(data, i, centers, j)
            if d < v
                v = d
                ind = j
            end
        end
        center_view = view(centers, :, ind)
        for d = 1:size(center_view, 1)
            center_view[d] = f1*center_view[d] + f2*data_view[d]
        end
    end
    centers
end

kshiftslabels(data, centers) = kshiftslabels!(zeros(Int, size(data, 2)), data, centers)
@inbounds function kshiftslabels!(labels::Vector{Int}, data::Matrix{T}, centers::Matrix{T}) where T
    # dv = FD.view(data)::Matrix{T}
    for i = 1:size(data, 2)
        v = typemax(T)
        ind = 0
        for j = 1:size(centers, 2)
            d = dist(data, i, centers, j)
            if d < v
                v = d
                ind = j
            end
        end
        labels[i] = ind
        # next!(dv)
    end
    labels
end

end # module
