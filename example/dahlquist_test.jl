using SDC
import Plots
using LaTeXStrings
using PrettyTables
"""
Currently a demonstration of SDC solving
"""
function main()

    # 5-node quadrature
    n = 5
    # IMEX Euler, half explicit, half implicit (dalhquist equation)
    fE(t, u) = 0.5*u
    fI(t, u) = 0.5*u
    # Solve implicit euler analytically
    implicit_solver(α, t, b) = b/(1+α)

    # Create SDC timestepper with provided parameters (should change code
    # structure to avoid this)
    my_SDC = make_SDC(n, fE, fI, implicit_solver)

    # Analytic solution
    u(t) = exp(t)
    # Start time
    t = 0.0
    # Initial value
    u_n = u(t)
    # Timesteps
    Δtimes = [1.0, 1.0, 1.0, 1.0, 1.0]
    # Non-start times, derived from timesteps
    times = cumsum(Δtimes) .+ t

    # Perform timestepping
    u_actual = []
    u_approx = []
    for i in eachindex(Δtimes)
        t += Δtimes[i] 
        u_n = my_SDC(u_n, t, Δtimes[i])
        push!(u_actual, u(t))
        push!(u_approx, u_n)
    end

    # Calculate errors
    u_diff_abs = abs.(u_actual - u_approx)
    u_diff_rel = [u_diff_abs[i]/u_actual[i] for i in eachindex(u_diff_abs)]

    # Produce table of results
    table_data = hcat(times, u_actual, u_approx, u_diff_abs, u_diff_rel)
    header = ["t", "u(t)", "est u(t)", "Abs Err", "Rel Err"]
    pretty_table(table_data; header=header)

    # Produce graph of results
    p1 = Plots.plot(times, u_diff_abs, yaxis=:log, title = "Absolute Error of e^t, t_0=0, variable timesteps",
                   legend=false)
    Plots.xlabel!(p1, "Time")
    Plots.ylabel!(p1, "Absolute Error")
    p2 = Plots.plot(times, u_diff_rel, yaxis=:log, title = "Relative Error of e^t, t_0=0, variable timesteps",
                   legend=false)
    Plots.xlabel!(p2, "Time")
    Plots.ylabel!(p2, "Relative Error")
    plt = Plots.plot(p1, p2, layout=(2,1))
    Plots.savefig(plt, "./dahlquist_test.png")
    return plt
end

display(main())
