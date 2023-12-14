@doc raw"""
    AbstractApproximationMethod

Abstract type for defining estimation methods on manifolds.
"""
abstract type AbstractApproximationMethod end

@doc raw"""
    GradientDescentEstimation <: AbstractApproximationMethod

Method for estimation using [📖 gradient descent](https://en.wikipedia.org/wiki/Gradient_descent).
"""
struct GradientDescentEstimation <: AbstractApproximationMethod end

@doc raw"""
    CyclicProximalPointEstimation <: AbstractApproximationMethod

Method for estimation using the cyclic proximal point technique, which is based on [📖 proximal maps](https://en.wikipedia.org/wiki/Proximal_operator).
"""
struct CyclicProximalPointEstimation <: AbstractApproximationMethod end

@doc raw"""
    EfficientEstimator <: AbstractApproximationMethod

Method for estimation in the best possible sense, see [📖 Efficiency (Statictsics)](https://en.wikipedia.org/wiki/Efficiency_(statistics)) for mroe details.
This can for example be used when computing the usual mean on an Euclidean space, which is the best estimator.
"""
struct EfficientEstimator <: AbstractApproximationMethod end


@doc raw"""
    ExtrinsicEstimation{T} <: AbstractApproximationMethod

Method for estimation in the ambient space with a method of type `T` and projecting the result back
to the manifold.
"""
struct ExtrinsicEstimation{T} <: AbstractApproximationMethod
    extrinsic_estimation::T
end

@doc raw"""
    WeiszfeldEstimation <: AbstractApproximationMethod

Method for estimation using the Weiszfeld algorithm, compare for example the computation of the
[📖 Geometric median](https://en.wikipedia.org/wiki/Geometric_median).
"""
struct WeiszfeldEstimation <: AbstractApproximationMethod end

@doc raw"""
    GeodesicInterpolation <: AbstractApproximationMethod

Method for estimation based on geodesic interpolation.
"""
struct GeodesicInterpolation <: AbstractApproximationMethod end

@doc raw"""
    GeodesicInterpolationWithinRadius{T} <: AbstractApproximationMethod

Method for estimation based on geodesic interpolation that is restricted to some `radius`

# Constructor

    GeodesicInterpolationWithinRadius(radius)
"""
struct GeodesicInterpolationWithinRadius{T} <: AbstractApproximationMethod
    radius::T
    function GeodesicInterpolationWithinRadius(radius::T) where {T}
        radius > 0 && return new{T}(radius)
        return throw(
            DomainError("The radius must be strictly postive, received $(radius)."),
        )
    end
end

@doc raw"""
    default_estimation_method(M::AbstractManifold)
    default_estimation_method(M::AbtractManifold, f, T)

Specify a default estimation method for an [`AbstractManifold`](@ref) and (optional)
for a specific function `f` and a type `T` to distinguish different (point or vector)
representations on M.

By default, all functions `f` call the signature for just a manifold.
The exceptional functions are

* `retract` and `retract!` which fall back to [`default_retraction_method`](@ref)
* `inverse_retract` and `inverse_retract!` which fall back to [`default_inverse_retraction_method`](@ref)
* any of the vector transport mehods fall back to [`default_vector_transport_method`](@ref)
"""
default_estimation_method(M::AbstractManifold)

default_estimation_method(M::AbstractManifold, f, T) = default_estimation_method(M, f)
default_estimation_method(M::AbstractManifold, f) = default_estimation_method(M)
