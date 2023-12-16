function structdeepcopy(vs::Vector{S}) where {S}
    return S[structdeepcopy(s) for s in vs]
end

function structdeepcopy(ts::Tuple)
    if isbits(ts)
    	return deepcopy(ts)
    else
	return Tuple(structdeepcopy(s) for s in ts)
    end
end

function structdeepcopy(s::S) where {S}
    if isnoncorestruct(S)
    	return S(fieldsdeepcopy(s)...)
    else
    	return deepcopy(s)
    end
end

function fieldsdeepcopy(s::S) where {S}
    return (structdeepcopy(getfield(s, f)) for f in fieldnames(S))
end

function isnoncorestruct(S)
    return isstructtype(S) && parentmodule(S) != Core
end
