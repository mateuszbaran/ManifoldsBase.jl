# Manifolds

While the interface `ManifoldsBase.jl` does not cover concrete manifolds, it provides a few
helpers to build or create manifolds based on existing manifolds

## [(Abstract) power manifold](@id sec-power-manifold)

A power manifold is constructed like higher dimensional vector spaces are formed from the real line, just that for every point ``p = (p_1,\ldots,p_n) ∈ \mathcal M^n`` on the power manifold ``\mathcal M^n`` the entries of ``p`` are points ``p_1,\ldots,p_n ∈ \mathcal M`` on some manifold ``\mathcal M``. Note that ``n`` can also be replaced by multiple values, such that ``p`` is not a vector but a matrix or tensor of points.

```@autodocs
Modules = [ManifoldsBase]
Pages = ["src/PowerManifold.jl"]
Order = [:macro, :type, :function]
```

## `ValidationManifold`

[`ValidationManifold`](@ref) is a simple decorator using the [`AbstractDecoratorManifold`](@ref) that “decorates” a manifold with tests that all involved points and vectors are valid for the wrapped manifold.
For example involved input and output paratemers are checked before and after running a function, repectively.
This is done by calling [`is_point`](@ref) or [`is_vector`](@ref) whenever applicable.

```@autodocs
Modules = [ManifoldsBase]
Pages = ["ValidationManifold.jl"]
Order = [:macro, :type, :function]
```

## `DefaultManifold`

[`DefaultManifold`](@ref ManifoldsBase.DefaultManifold) is a simplified version of [`Euclidean`](https://juliamanifolds.github.io/Manifolds.jl/latest/manifolds/euclidean.html) and demonstrates a basic interface implementation.
It can be used to perform simple tests.
Since when using `Manifolds.jl` the [`Euclidean`](https://juliamanifolds.github.io/Manifolds.jl/latest/manifolds/euclidean.html) is available, the `DefaultManifold` itself is not exported.

```@docs
ManifoldsBase.DefaultManifold
```

## [Embedded manifold](@id sec-embedded-manifold)

The embedded manifold is a manifold ``mathcal N`` which is modelled _explicitly_ mentioning its embedding ``\mathcal N`` in which the points and tangent vectors are represented.
Most prominently [`is_point`](@ref) and [`is_vector`](@ref) of an embedded manifold are implemented to check whether the point is a valid point in the embedding. This can of course still be extended by further tests.
`ManifoldsBase.jl` provides two possibilities of easily introducing this in order to dispatch some functions to the embedding.

### [Implicit case: the `IsEmbeddedManifold` Trait](@id subsec-implicit-embedded)

For the implicti case, your manifold has to be a subtype of the [`AbstractDecoratorManifold`](@ref).
Setting the [`active_traits`](@ref ManifoldsBase.active_traits) function to the [`AbstractTrait`](@ref)
[`IsEmbeddedManifold`](@ref), makes a manifold an embedded manifold. you just have to also define [`get_embedding`](@ref) such that functions are passed on to that embedding.
This is the implicit case, since the manifold type itself does not carry any information about the embedding, just the trait and the function definition do.

### [Explicit case: the `EmbeddedManifold`](@id subsec-explicit-embedded)

The [`EmbeddedManifold`](@ref) itself is an [`AbstractDecoratorManifold`](@ref) so it is a case of the implicit embedding itself, but internally stores both the original manifold and the embedding.
They are also parameters of the type.
This way, additional embeddings can be modelled. That is, if the manifold is implemented using the implicit embedding approach from before but can also be implemented using a _different_ embedding, then this method should be chosen, since you can dispatch functions that you want to implement in this embedding then on the type which explicitly has the manifold and its embedding as parameters.

Hence this case should be used for any further embedding after the first or if the default implementation works without an embedding and the alternative needs one.

```@autodocs
Modules = [ManifoldsBase]
Pages = ["EmbeddedManifold.jl"]
Order = [:type, :macro, :function]
```