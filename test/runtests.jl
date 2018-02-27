using Walk1DMDP, POMDPToolbox
using Base.Test

mdp = Walk1D()
random_policy = RandomGaussian(MersenneTwister(0))
hr = HistoryRecorder(; max_steps=50, show_progress=true)
h = simulate(hr, mdp, random_policy)
h.state_hist


