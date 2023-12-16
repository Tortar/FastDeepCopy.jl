# FastDeepCopy.jl

This package export a single function called `fastdeepcopy` which performs much better than its Base counterparts `deepcopy` when used on non-isbits types as shown below:

```julia
julia> using FastDeepCopy, BenchmarkTools

julia> # let's start with a vector of structs
       struct A
           x::Int
       end

julia> v = [A(x) for x in 1:1000]

julia> @benchmark deepcopy($v)
BenchmarkTools.Trial: 10000 samples with 13 evaluations.
 Range (min … max):  601.923 ns … 89.725 μs  ┊ GC (min … max): 0.00% … 96.99%
 Time  (median):     775.308 ns              ┊ GC (median):    0.00%
 Time  (mean ± σ):     1.120 μs ±  2.382 μs  ┊ GC (mean ± σ):  8.29% ±  4.39%

  ▂▅▇█▆▄▁                                            ▁▂▁▃▂▂▁   ▂
  ███████▅▅▆▆▆▅▅▄▄▃▃▄▃▁▃▃▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▃▃▃▇▆█████████ █
  602 ns        Histogram: log(frequency) by time      3.66 μs <

 Memory estimate: 8.27 KiB, allocs estimate: 3.

 julia> @benchmark fastdeepcopy($v)
BenchmarkTools.Trial: 10000 samples with 198 evaluations.
 Range (min … max):  560.500 ns …   6.036 μs  ┊ GC (min … max):  0.00% … 73.42%
 Time  (median):     619.927 ns               ┊ GC (median):     0.00%
 Time  (mean ± σ):   790.324 ns ± 532.189 ns  ┊ GC (mean ± σ):  10.46% ± 13.26%

  █▇▇▄▃       ▁▃▃▃▃▃▂                                       ▂▂▁ ▂
  ██████▇▆▄▁▄▇████████▇▇▆▇▇▆▃▃▃▃▁▁▁▃▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▅▆███ █
  560 ns        Histogram: log(frequency) by time       3.07 μs <

 Memory estimate: 7.94 KiB, allocs estimate: 1.

julia> # already a bit faster, let's try with a vector of mutable structs
       mutable struct B
           x::Int
       end

julia> v = [B(x) for x in 1:1000];

julia> @benchmark deepcopy($v)
BenchmarkTools.Trial: 7191 samples with 1 evaluation.
 Range (min … max):  671.071 μs …  1.442 ms  ┊ GC (min … max): 0.00% … 50.09%
 Time  (median):     690.177 μs              ┊ GC (median):    0.00%
 Time  (mean ± σ):   694.263 μs ± 34.263 μs  ┊ GC (mean ± σ):  0.23% ±  2.29%

                     ▁▃▆▇██▇▇▆▅▅▄▄▂▂▁  ▁▁▁▂▁▂▂▁▂ ▂ ▁▁▂▂▂▁▁ ▁▁  ▃
  ▃▁▁▁▃▁▁▁▃▁▁▁▁▁▁▁▃▅▇████████████████████████████████████████▇ █
  671 μs        Histogram: log(frequency) by time       717 μs <

 Memory estimate: 119.58 KiB, allocs estimate: 1499.

julia> @benchmark fastdeepcopy($v) # 150x faster!
BenchmarkTools.Trial: 10000 samples with 7 evaluations.
 Range (min … max):  3.803 μs … 114.006 μs  ┊ GC (min … max): 0.00% … 87.68%
 Time  (median):     4.275 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   4.729 μs ±   4.937 μs  ┊ GC (mean ± σ):  5.77% ±  5.34%

   ▂▃▇█▆▃▁                                                    ▂
  ████████████▅▆▅▄▄▄▁▁▁▁▃▁▁▁▁▁▁▁▃▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▃▃▅▆▇███▇▇ █
  3.8 μs       Histogram: log(frequency) by time      10.3 μs <

 Memory estimate: 23.56 KiB, allocs estimate: 1001.
```

