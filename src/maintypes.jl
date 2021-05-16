"""
    Manifold{F}

A manifold type. The `Manifold` is used to dispatch to different functions on a manifold,
usually as the first argument of the function. Examples are the [`exp`](@ref)onential and
[`log`](@ref)arithmic maps as well as more general functions that are built on them like the
[`geodesic`](@ref).

The manifold is parametrized by an [`AbstractNumbers`](@ref) to distinguish for example
real (ℝ) and complex (ℂ) manifolds.

For subtypes the preferred order of parameters is: size and simple value parameters,
followed by the [`AbstractNumbers`](@ref) `field`, followed by data type parameters,
which might depend on the abstract number field type.
"""
abstract type Manifold{𝔽} end

"""
    MPoint

Type for a point on a manifold. While a [`Manifold`](@ref) does not necessarily require this
type, for example when it is implemented for `Vector`s or `Matrix` type elements, this type
can be used for more complicated representations, semantic verification, or even dispatch
for different representations of points on a manifold.
"""
abstract type MPoint end

"""
    TVector

Type for a tangent vector of a manifold. While a [`Manifold`](@ref) does not necessarily
require this type, for example when it is implemented for `Vector`s or `Matrix` type
elements, this type can be used for more complicated representations, semantic verification,
or even dispatch for different representations of tangent vectors and their types on a
manifold.
"""
abstract type TVector end

"""
    CoTVector

Type for a cotangent vector of a manifold. While a [`Manifold`](@ref) does not necessarily
require this type, for example when it is implemented for `Vector`s or `Matrix` type
elements, this type can be used for more complicated representations, semantic verification,
or even dispatch for different representations of cotangent vectors and their types on a
manifold.
"""
abstract type CoTVector end
