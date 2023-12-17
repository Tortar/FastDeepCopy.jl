# FastDeepCopy.jl

This package export a single function called `fastdeepcopy` which performs much better than its `Base` counterpart `deepcopy` when used on most non-isbits types as shown below:

```julia
# benchmarks on some common cases

julia> using FastDeepCopy, BenchmarkTools

julia> struct A
           x::Int
           y::Float64
       end

julia> mutable struct B
           x::Int
           y::Float64
       end

julia> v = A(1, rand());

julia> r = minimum(@benchmark(deepcopy($v)).times) / minimum(@benchmark(fastdeepcopy($v)).times)
1.0

julia> v = [A(x,rand()) for x in 1:1000];

julia> r = minimum(@benchmark(deepcopy($v)).times) / minimum(@benchmark(fastdeepcopy($v)).times)
1.0077847732979655

julia> v = Dict(x => A(x,rand()) for x in 1:1000);

julia> r = minimum(@benchmark(deepcopy($v)).times) / minimum(@benchmark(fastdeepcopy($v)).times)
1.2999258160237388

julia> v = B(1, rand());

julia> r = minimum(@benchmark(deepcopy($v)).times) / minimum(@benchmark(fastdeepcopy($v)).times)
158.27555689959576

julia> v = [B(x,rand()) for x in 1:1000];

julia> r = minimum(@benchmark(deepcopy($v)).times) / minimum(@benchmark(fastdeepcopy($v)).times)
232.596056505773

julia> v = Dict(x => B(x,rand()) for x in 1:1000);

julia> r = minimum(@benchmark(deepcopy($v)).times) / minimum(@benchmark(fastdeepcopy($v)).times)
59.20866590649943
```

As you can see, it is more than 200x faster for a vector of mutable structs!

---

## Limitations

Unlike `deepcopy` this more performant version doesn't preserve object identities:

```julia
julia> a = [1]; b = [a, a];

julia> c = deepcopy(b);

julia> c[1] === c[2]
true

julia> push!(c[1], 1); c
2-element Vector{Vector{Int64}}:
 [1, 1]
 [1, 1]

julia> using FastDeepCopy

julia> c = fastdeepcopy(b);

julia> c[1] === c[2]
false

julia> push!(c[1], 1); c
2-element Vector{Vector{Int64}}:
 [1, 1]
 [1]
```

which means that `fastdeepcopy` should **not** be used when mutable structures are passed by reference inside the object to be copied.
