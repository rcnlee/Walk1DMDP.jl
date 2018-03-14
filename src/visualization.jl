@recipe function f(m::Walk1D, h::SimHistory)
    xlim := (-1, m.p.t_max)
    ylim := (-m.p.threshx-1, m.p.threshx+1)
    @series begin
        seriestype := :line
        color := :black
        label := "thresh+"
        x = [0.0, m.p.t_max]
        y = [m.p.threshx, m.p.threshx] 
        x, y
    end
    @series begin
        seriestype := :line
        color := :black
        label := "thresh-"
        x = [0.0, m.p.t_max]
        y = [-m.p.threshx, -m.p.threshx] 
        x, y
    end
    @series begin
        label := "path"
        color := :blue
        x = [s.t for s in state_hist(h)[1:end-1]]
        y = [s.x for s in state_hist(h)[1:end-1]]
        x, y
    end
    @series begin
        seriestype := :scatter
        label := "current position"
        t = state_hist(h)[end-1].t
        x = state_hist(h)[end-1].x
        if abs(x) < abs(m.p.threshx)
            color := :blue
        else
            color := :red
        end
        [t], [x]
    end
end

