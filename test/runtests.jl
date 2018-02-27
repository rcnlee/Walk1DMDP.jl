using Walk1DMDP, POMDPToolbox
using Base.Test

random_policy = RandomGaussian(MersenneTwister(0))
p = Walk1DParams()
mdp = Walk1D(Walk1DParams(), random_policy.distr)
hr = HistoryRecorder(; max_steps=50, show_progress=true)
h = simulate(hr, mdp, random_policy)
h.state_hist


