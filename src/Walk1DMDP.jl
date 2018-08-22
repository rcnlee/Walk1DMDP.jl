module Walk1DMDP

using POMDPs, POMDPToolbox, Distributions, Plots, MCTS

export
    Walk1DParams,
    Walk1DState,
    Walk1D,
    RandomGaussian


struct Walk1DParams
    startx::Float64
    threshx::Float64
    t_max::Int
end
Walk1DParams() = Walk1DParams(1.0, 10.0, 20)

struct Walk1DState
    t::Int
    x::Float64
end
mutable struct Walk1D <: MDP{Walk1DState,Float64}
    p::Walk1DParams
    distr::Distribution
end
Walk1D() = Walk1D(Walk1DParams(), Normal(0.0, 1.0))

immutable RandomGaussian <: Policy
    distr::Distribution
    rng::AbstractRNG
end
RandomGaussian(rng::AbstractRNG=MersenneTwister(0), m::Float64=0.0, s::Float64=1.0) = RandomGaussian(Normal(m,s), rng)
function POMDPs.action(pol::RandomGaussian, s::Walk1DState)
    return rand(pol.rng, pol.distr)
end
function POMDPs.initial_state(mdp::Walk1D, rng::AbstractRNG)
    Walk1DState(0, mdp.p.startx)
end
function POMDPs.generate_s(mdp::Walk1D, s::Walk1DState, a::Float64, rng::AbstractRNG)
    Walk1DState(s.t+1, s.x+a)
end
POMDPs.discount(mdp::Walk1D) = 1.0
isevent(mdp::Walk1D, s::Walk1DState) = s.x > mdp.p.threshx
POMDPs.isterminal(mdp::Walk1D, s::Walk1DState) = isevent(mdp, s) || s.t >= mdp.p.t_max
function POMDPs.reward(mdp::Walk1D, s::Walk1DState, a::Float64, sp::Walk1DState)
    r = log(pdf(mdp.distr, a))
    if isterminal(mdp, sp)
        if isevent(mdp, sp)
            r += 0.0
        else
            r += -miss_distance(mdp, sp)
        end
    end
    r
end
function miss_distance(mdp::Walk1D, s::Walk1DState)
    max(mdp.p.threshx-abs(s.x), 0.0)
end
MCTS.next_action(pol::RandomGaussian, sim::Walk1D, s::Walk1DState, snode) = action(pol, s)
Base.string(s::Walk1DState) = "($(s.t),$(round(s.x,2)))"

include("visualization.jl")


end # module
