# Functions on manifolds

This page collects several basic functions on manifolds.

## Validation

ince points and tangent vectors are represented usually as multidimensional arrays or for more complex cases as structs, there might be values, which invalidate a point of tangent vector. Here the interface provides two [high level functions](@ref design-layer1).

```@docs
is_point
is_vector
```

These are mapped to the [lower level functions](@ref design-layer3)

```@docs
ManifoldsBase.check_point
ManifoldsBase.check_vector
ManifoldsBase.check_size
```

## [The exponential and the logarithmic map, and geodesics](@id exp-and-log)

Geodesics are the generalizations of a straight line to manifolds, i.e. their intrinsic acceleration is zero.
Together with geodesics one also obtains the exponential map and its inverse, the logarithmic map.
Informally speaking, the exponential map takes a vector (think of a direction and a length) at one point and returns another point,
which lies towards this direction at distance of the specified length. The logarithmic map does the inverse, i.e. given two points, it tells which vector “points towards” the other point.

```@autodocs
Modules = [ManifoldsBase]
Pages = ["exp_log_geo.jl"]
Order = [:function]
```

## [Parallel transport](@id parallel-transport)

TODO

```@autodocs
Modules = [ManifoldsBase]
Pages = ["parallel_transport.jl"]
Order = [:function]
```


## Further functions

```@autodocs
Modules = [ManifoldsBase]
Pages = ["ManifoldsBase.jl"]
Order = [:type, :function]
```

TODO split layer 1 and layer 3 here

## Error Messages

especially to collect and display errors on [`AbstractPowerManifold`](@ref)s the following
component and collection error messages are available.

```@autodocs
Modules = [ManifoldsBase]
Pages = ["errors.jl"]
Order = [:type]
```