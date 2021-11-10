using Documenter
using SDC

const ROOT = joinpath(@__DIR__, "..")
makedocs(
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true"
    ),
    sitename = "SDC.jl",
    modules = [SDC],
    authors = "Spencer Lee, and contributors.",
    pages = Any[
        "Home" => "index.md",
        "Types" => "types.md",
        "Methods" => "methods.md",
        "Index" => "function-index.md",
    ],
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
 deploydocs(
    repo = "github.com/leespen1/SDC.jl.git",
    devbranch = "main"
)
