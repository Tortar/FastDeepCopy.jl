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

The benchmarks have been run on

```julia
Julia Version 1.9.4
Commit 8e5136fa297 (2023-11-14 08:46 UTC)
Build Info:
  Official https://julialang.org/ release
Platform Info:
  OS: Linux (x86_64-linux-gnu)
  CPU: 12 × AMD Ryzen 5 5600H with Radeon Graphics
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-14.0.6 (ORCJIT, znver3)
  Threads: 1 on 12 virtual cores
```

## Limitations

Unlike `deepcopy` this more performant version doesn't preserve object identities:

```julia
julia> a = [1];

julia> b = [a, a]
2-element Vector{Vector{Int64}}:
 [1]
 [1]

julia> c = deepcopy(b)
2-element Vector{Vector{Int64}}:
 [1]
 [1]

julia> c[1] === c[2]
true

julia> using FastDeepCopy

julia> c = fastdeepcopy(b)
2-element Vector{Vector{Int64}}:
 [1]
 [1]

julia> c[1] === c[2]
false
```

which means that `fastdeepcopy` should **not** be used when mutable structures are passed by reference inside the object to be copied.
