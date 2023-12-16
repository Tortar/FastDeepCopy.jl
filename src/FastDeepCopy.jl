module FastDeepCopy

function fastdeepcopy(vs::Vector{S}) where {S}
    return S[fastdeepcopy(s) for s in vs]
end

function fastdeepcopy(ts::Tuple)
    if isbits(ts)
    	return deepcopy(ts)
    else
	return Tuple(fastdeepcopy(s) for s in ts)
    end
end

function fastdeepcopy(ds::Dict{K,S}) where {K,S}
    if isbitstype(K) && isbitstype(S)
    	return deepcopy(ds)
    else
    	return Dict{K,S}(fastdeepcopy(p) for p in ds)
    end
end

function fastdeepcopy(p::Pair)
    if isbits(p)
    	return deepcopy(p)
    else
    	return fastdeepcopy(p.first) => fastdeepcopy(p.second)
    end
end

function fastdeepcopy(s::S) where {S}
    if isnoncorestruct(S)
    	return S(fieldsdeepcopy(s)...)
    else
    	return deepcopy(s)
    end
end

function fieldsdeepcopy(s::S) where {S}
    return (fastdeepcopy(getfield(s, f)) for f in fieldnames(S))
end

function isnoncorestruct(S)
    return isstructtype(S) && parentmodule(S) != Core
end

end
