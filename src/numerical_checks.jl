
@doc raw"""
    check_inverse_retraction(
        M::AbstractManifold,
        inverse_rectraction_method::AbstractInverseRetractionMethod,
        p=rand(M),
        X=rand(M; vector_at=p);
        #
        exactness_tol::Real = 1e-12,
        io::Union{IO,Nothing} = nothing,
        limits::Tuple = (-8.0, 0.0),
        log_range::AbstractVector = range(limits[1], limits[2]; length=N),
        N::Int = 101,
        name::String = "inverse retraction",
        plot::Bool = false,
        second_order::Bool = true
        slope_tol::Real = 0.1,
        error::Symbol = :none,
        window = nothing,
    )

Check numerically wether the inverse retraction `inverse_retraction_method` is correct.
This requires the [`exp`](@ref) and [`norm`](@ref) functions to be implemented for the [`AbstractManifold`](@ref) `M`.

This implements a method similar to [Boumal:2023; Section 4.8 or Section 6.8](@cite).

Note that if the errors are below the given tolerance and the method is exact,
no plot is generated,

# Keyword arguments

* `exactness_tol`:     if all errors are below this tolerance, the inverse retraction is considered to be exact
* `io`:                provide an `IO` to print the result to
* `limits`:            specify the limits in the `log_range`, that is the exponent for the range
* `log_range`:         specify the range of points (in log scale) to sample the length of the tangent vector `X`
* `N`:                 number of points to verify within the `log_range` default range ``[10^{-8},10^{0}]``
* `name`:              name to display in the plot
* `plot`:              whether to plot the result (see [`plot_slope`](@ref))
  The plot is in log-log-scale. This is returned and can then also be saved.
* `second_order`:      check whether the retraction is of second order. if set to `false`, first order is checked.
* `slope_tol`:         tolerance for the slope (global) of the approximation
* `error`:             specify how to report errors: `:none`, `:info`, `:warn`, or `:error` are available
* `window`:            specify window sizes within the `log_range` that are used for the slope estimation.
  the default is, to use all window sizes `2:N`.
"""
function check_inverse_retraction(
    M::AbstractManifold,
    inverse_retraction_method::AbstractInverseRetractionMethod,
    p = rand(M),
    X = rand(M; vector_at = p);
    exactness_tol::Real = 1e-12,
    io::Union{IO,Nothing} = nothing,
    limits = (-8.0, 0.0),
    N::Int = 101,
    second_order::Bool = true,
    name::String = second_order ? "second order inverse retraction" : "inverse retraction",
    log_range::AbstractVector = range(limits[1], limits[2]; length = N),
    plot::Bool = false,
    slope_tol::Real = 0.1,
    error::Symbol = :none,
    window = nothing,
)
    Xn = X ./ norm(M, p, X) # normalize tangent direction
    # function for the directional derivative
    #
    T = exp10.(log_range)
    # points `p_i` to evaluate the error function at
    points = [exp_fused(M, p, Xn, t) for t in T]
    Xs = [t * Xn for t in T]
    approx_Xs = [inverse_retract(M, p, q, inverse_retraction_method) for q in points]
    errors = [norm(M, p, X - Y) for (X, Y) in zip(Xs, approx_Xs)]
    return prepare_check_result(
        log_range,
        errors,
        second_order ? 3.0 : 2.0;
        exactness_tol = exactness_tol,
        io = io,
        name = name,
        plot = plot,
        slope_tol = slope_tol,
        error = error,
        window = window,
    )
end

@doc raw"""
    check_retraction(
        M::AbstractManifold,
        rectraction_method::AbstractRetractionMethod,
        p=rand(M),
        X=rand(M; vector_at=p);
        #
        exactness_tol::Real = 1e-12,
        io::Union{IO,Nothing} = nothing,
        limits::Tuple = (-8.0, 0.0),
        log_range::AbstractVector = range(limits[1], limits[2]; length=N),
        N::Int = 101,
        name::String = "retraction",
        plot::Bool = false,
        second_order::Bool = true
        slope_tol::Real = 0.1,
        error::Symbol = :none,
        window = nothing,
    )

Check numerically wether the retraction `vector_transport_to` is correct, by selecting
a set of points ``q_i = \exp_p (t_i X)`` where ``t`` takes all values from `log_range`,
to then compare [`parallel_transport_to`](@ref) to the `vector_transport_method`
applied to the vector `Y`.

This requires the [`exp`](@ref), [`parallel_transport_to`](@ref) and [`norm`](@ref) function
to be implemented for the [`AbstractManifold`](@ref) `M`.

This implements a method similar to [Boumal:2023; Section 4.8 or Section 6.8](@cite).

Note that if the errors are below the given tolerance and the method is exact,
no plot is generated,

# Keyword arguments

* `exactness_tol`:     if all errors are below this tolerance, the retraction is considered to be exact
* `io`:                provide an `IO` to print the result to
* `limits`:            specify the limits in the `log_range`, that is the exponent for the range
* `log_range`:         specify the range of points (in log scale) to sample the length of the tangent vector `X`
* `N`:                 number of points to verify within the `log_range` default range ``[10^{-8},10^{0}]``
* `name`:              name to display in the plot
* `plot`:              whether to plot the result (if `Plots.jl` is loaded).
  The plot is in log-log-scale. This is returned and can then also be saved.
* `second_order`:      check whether the retraction is of second order. if set to `false`, first order is checked.
* `slope_tol`:         tolerance for the slope (global) of the approximation
* `error`:             specify how to report errors: `:none`, `:info`, `:warn`, or `:error` are available
* `window`:            specify window sizes within the `log_range` that are used for the slope estimation.
  the default is, to use all window sizes `2:N`.
"""
function check_retraction(
    M::AbstractManifold,
    retraction_method::AbstractRetractionMethod,
    p = rand(M),
    X = rand(M; vector_at = p);
    exactness_tol::Real = 1e-12,
    io::Union{IO,Nothing} = nothing,
    limits::Tuple = (-8.0, 0.0),
    N::Int = 101,
    second_order::Bool = true,
    name::String = second_order ? "second order retraction" : "retraction",
    log_range = range(limits[1], limits[2]; length = N),
    plot::Bool = false,
    slope_tol::Real = 0.1,
    error::Symbol = :none,
    window = nothing,
)
    Xn = X ./ norm(M, p, X) # normalize tangent direction
    # function for the directional derivative
    #
    T = exp10.(log_range)
    # points `p_i` to evaluate the error function at
    points = [exp_fused(M, p, Xn, t) for t in T]
    approx_points = [retract_fused(M, p, Xn, t, retraction_method) for t in T]
    errors = [distance(M, p, q) for (p, q) in zip(points, approx_points)]
    return prepare_check_result(
        log_range,
        errors,
        second_order ? 3.0 : 2.0;
        exactness_tol = exactness_tol,
        io = io,
        name = name,
        plot = plot,
        slope_tol = slope_tol,
        error = error,
        window = window,
    )
end

@doc raw"""
    check_vector_transport(
        M::AbstractManifold,
        vector_transport_method::AbstractVectorTransportMethod,
        p=rand(M),
        X=rand(M; vector_at=p),
        Y=rand(M; vector_at=p);
        #
        exactness_tol::Real = 1e-12,
        io::Union{IO,Nothing} = nothing,
        limits::Tuple = (-8.0, 0.0),
        log_range::AbstractVector = range(limits[1], limits[2]; length=N),
        N::Int = 101,
        name::String = "inverse retraction",
        plot::Bool = false,
        second_order::Bool = true
        slope_tol::Real = 0.1,
        error::Symbol = :none,
        window = nothing,
    )

Check numerically wether the retraction `vector_transport_to` is correct, by selecting
a set of points ``q_i = \exp_p (t_i X)`` where ``t`` takes all values from `log_range`,
to then compare [`parallel_transport_to`](@ref) to the `vector_transport_method`
applied to the vector `Y`.

This requires the [`exp`](@ref), [`parallel_transport_to`](@ref) and [`norm`](@ref) function
to be implemented for the [`AbstractManifold`](@ref) `M`.

This implements a method similar to [Boumal:2023; Section 4.8 or Section 6.8](@cite).

Note that if the errors are below the given tolerance and the method is exact,
no plot is generated,

# Keyword arguments

* `exactness_tol`:     if all errors are below this tolerance, the differential is considered to be exact
* `io`:                provide an `IO` to print the result to
* `limits`:            specify the limits in the `log_range`, that is the exponent for the range
* `log_range`:         specify the range of points (in log scale) to sample the differential line
* `N`:                 number of points to verify within the `log_range` default range ``[10^{-8},10^{0}]``
* `name`:              name to display in the plot
* `plot`:              whether to plot the result (if `Plots.jl` is loaded).
  The plot is in log-log-scale. This is returned and can then also be saved.
* `second_order`:      check whether the retraction is of second order. if set to `false`, first order is checked.
* `slope_tol`:         tolerance for the slope (global) of the approximation
* `error`:             specify how to report errors: `:none`, `:info`, `:warn`, or `:error` are available
* `window`:            specify window sizes within the `log_range` that are used for the slope estimation.
  the default is, to use all window sizes `2:N`.
"""
function check_vector_transport(
    M::AbstractManifold,
    vector_transport_method::AbstractVectorTransportMethod,
    p = rand(M),
    X = rand(M; vector_at = p),
    Y = rand(M; vector_at = p);
    exactness_tol::Real = 1e-12,
    io::Union{IO,Nothing} = nothing,
    limits::Tuple = (-8.0, 0.0),
    N::Int = 101,
    second_order::Bool = true,
    name::String = second_order ? "second order vector transport" : "vector transport",
    log_range::AbstractVector = range(limits[1], limits[2]; length = N),
    plot::Bool = false,
    slope_tol::Real = 0.1,
    error::Symbol = :none,
    window = nothing,
)
    Xn = X ./ norm(M, p, X) # normalize tangent direction
    # function for the directional derivative
    #
    T = exp10.(log_range)
    # points `p_i` to evaluate the error function at
    points = [exp_fused(M, p, Xn, t) for t in T]
    Yv = [vector_transport_to(M, p, Y, q, vector_transport_method) for q in points]
    Yp = [parallel_transport_to(M, p, Y, q) for q in points]
    errors = [norm(M, q, X - Y) for (q, X, Y) in zip(points, Yv, Yp)]
    return prepare_check_result(
        log_range,
        errors,
        second_order ? 3.0 : 2.0;
        exactness_tol = exactness_tol,
        io = io,
        name = name,
        plot = plot,
        slope_tol = slope_tol,
        error = error,
        window = window,
    )
end

function plot_slope end

"""
    plot_slope(x, y;
        slope=2,
        line_base=0,
        a=0,
        b=2.0,
        i=1,
        j=length(x)
    )

Plot the result from the verification functions on data `x,y` with two comparison lines

1) `line_base` + t`slope`  as the global slope(s) the plot could have
2) `a` + `b*t` on the interval [`x[i]`, `x[j]`] for some (best fitting) comparison slope

!!! note
    This function has to be implemented for a certain plotting package.
    loading [Plots.jl](https://docs.juliaplots.org/stable/) provides a default implementation.
"""
plot_slope(x, y)

"""
    prepare_check_result(
        log_range::AbstractVector,
        errors::AbstractVector,
        slope::Real;
        exactness_to::Real = 1e3*eps(eltype(errors)),
        io::Union{IO,Nothing} = nothing
        name::String = "estimated slope",
        plot::Bool = false,
        slope_tol::Real = 0.1,
        error::Symbol = :none,
    )

Given a range of values `log_range`, with computed `errors`,
verify whether this yields a slope of `slope` in log-scale

Note that if the errors are below the given tolerance and the method is exact,
no plot is be generated,

# Keyword arguments

* `exactness_tol`: is all errors are below this tolerance, the verification is considered to be exact
* `io`:            provide an `IO` to print the result to
* `name`:          name to display in the plot title
* `plot`:          whether to plot the result, see [`plot_slope`](@ref)
  The plot is in log-log-scale. This is returned and can then also be saved.
* `slope_tol`:     tolerance for the slope (global) of the approximation
* `error`:         specify how to handle errors, `:none`, `:info`, `:warn`, `:error`
"""

function prepare_check_result(
    log_range::AbstractVector,
    errors::AbstractVector,
    slope::Real;
    io::Union{IO,Nothing} = nothing,
    name::String = "estimated slope",
    slope_tol::Real = 1e-1,
    plot::Bool = false,
    error::Symbol = :none,
    window = nothing,
    exactness_tol::Real = 1e3 * eps(eltype(errors)),
)
    if max(errors...) < exactness_tol
        (io !== nothing) && print(
            io,
            "All errors are below the exactness tolerance $(exactness_tol). Your check can be considered exact, hence there is no use to check for a slope.\n",
        )
        return true
    end
    x = log_range[errors .> 0]
    T = exp10.(x)
    y = log10.(errors[errors .> 0])
    (a, b) = find_best_slope_window(x, y, length(x))[1:2]
    if isapprox(b, slope; atol = slope_tol)
        plot && return plot_slope(
            T,
            errors[errors .> 0];
            slope = slope,
            line_base = errors[1],
            a = a,
            b = b,
            i = 1,
            j = length(y),
        )
        (io !== nothing) && print(
            io,
            "Your $name's slope is globally $(@sprintf("%.4f", b)), so within $slope ± $(slope_tol).\n",
        )
        return true
    end
    # otherwise
    # find best contiguous window of length w
    (ab, bb, ib, jb) = find_best_slope_window(x, y, window; slope_tol = slope_tol)
    msg = "The $(name) fits best on [$(T[ib]),$(T[jb])] with slope  $(@sprintf("%.4f", bb)), but globally your slope $(@sprintf("%.4f", b)) is outside of the tolerance $slope ± $(slope_tol).\n"
    (io !== nothing) && print(io, msg)
    plot && return plot_slope(
        T,
        errors[errors .> 0];
        slope = slope,
        line_base = errors[1],
        a = ab,
        b = bb,
        i = ib,
        j = jb,
    )
    (error === :info) && @info msg
    (error === :warn) && @warn msg
    (error === :error) && throw(ErrorException(msg))
    return false
end

function find_best_slope_window end

"""
    (a, b, i, j) = find_best_slope_window(X, Y, window=nothing; slope::Real=2.0, slope_tol::Real=0.1)

Check data X,Y for the largest contiguous interval (window) with a regression line fitting “best”.
Among all intervals with a slope within `slope_tol` to `slope` the longest one is taken.
If no such interval exists, the one with the slope closest to `slope` is taken.

If the window is set to `nothing` (default), all window sizes `2,...,length(X)` are checked.
You can also specify a window size or an array of window sizes.

For each window size, all its translates in the data is checked.
For all these (shifted) windows the regression line is computed (with `a,b` in `a + t*b`)
and the best line is computed.

From the best line the following data is returned

* `a`, `b` specifying the regression line `a + t*b`
* `i`, `j` determining the window, i.e the regression line stems from data `X[i], ..., X[j]`

!!! note
    This function has to be implemented using some statistics package.
    loading [Statistics.jl](https://github.com/JuliaStats/Statistics.jl) provides a default implementation.
"""
find_best_slope_window(X, Y, window = nothing)
