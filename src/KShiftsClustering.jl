__precompile__()

module KShiftsClustering

using FunctionalDataUtils, NearestNeighbors

export kshifts, kshifts!, kshiftslabels, kshiftmedoids

function kshiftmedoids(data,k)
    centers = kshifts(data,k)
    tree = KDTree(float(data))
    knnID(a) = @p knn tree vec(a) 1  | fst | fst
    ids = @p map centers knnID
    part(data, ids), ids
end


function dist(a,i,b,j)
    sum = zeroel(a)
    for d = 1:size(a,1)
        sum += (a[d,i]-b[d,j])*(a[d,i]-b[d,j])
    end
    sum
end

function kshifts{T}(data::Array{T,2}, k::Int)
    centers = @p randsample data k
    kshifts!(centers, data)
end

function kshifts!{T}(centers::Array{T,2}, data::Array{T,2})
    assert(sizem(data)==sizem(centers))
    f1 = 29/30
    f2 = 1-f1
    dv = FD.view(data)
    cv = FD.view(centers)
    for i = 1:len(data)
        v = typemax(eltype(centers))
        ind = 0
        for j = 1:len(centers)
            d = dist(data, i, centers, j)
            if d < v
                v = d
                ind = j
            end
        end
        view!(centers, ind, cv)
        for d = 1:sizem(cv)
            cv[d] = f1*cv[d] + f2*dv[d]
        end
        next!(dv)
    end
    centers
end

function kshiftslabels(data, centers)
    if len(data)>10000
        @p lmap data kshiftslabels_ centers
    else
        kshiftslabels_(data, centers)
    end
end

function kshiftslabels_(data, centers)
    labels = zeros(Int32,1,len(data))
    dv = FD.view(data)
    for i = 1:len(data)
        v = typemax(eltype(centers))          
        ind = 0
        for j = 1:len(centers)
            d = dist(data, i, centers, j)
            if d < v
                v = d
                ind = j
            end
        end
        labels[i] = ind
        next!(dv)
    end
    labels
end

end # module
