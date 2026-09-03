#=
Colorant interoperability.

Every public entry point that takes a seed or a colour also accepts anything
from the ColorTypes ecosystem. These are thin forwarding methods: a Colorant is
quantised to the 8-bit sRGB the engine works in, then handed to the hex-taking
implementation. Kept in one file so the ported engine stays close to upstream.
=#

# ── Tonal palettes ──
tonal_palette(seed::ColorTypes.Colorant)::TonalPalette = tonal_palette(to_hex(seed))

# ── Schemes ──
color_scheme(seed::ColorTypes.Colorant; kwargs...) = color_scheme(to_hex(seed); kwargs...)
color_scheme_pair(seed::ColorTypes.Colorant; kwargs...) = color_scheme_pair(to_hex(seed); kwargs...)
hex_scheme(seed::ColorTypes.Colorant; kwargs...) = hex_scheme(to_hex(seed); kwargs...)
hex_scheme_pair(seed::ColorTypes.Colorant; kwargs...) = hex_scheme_pair(to_hex(seed); kwargs...)

# ── Contrast ──
# Both arguments are normalised independently, so a Colorant may be compared
# against a hex string without ceremony.
contrast_ratio(a::ColorTypes.Colorant, b::ColorTypes.Colorant)::Float64 =
    contrast_ratio(to_hex(a), to_hex(b))
contrast_ratio(a::ColorTypes.Colorant, b::AbstractString)::Float64 =
    contrast_ratio(to_hex(a), b)
contrast_ratio(a::AbstractString, b::ColorTypes.Colorant)::Float64 =
    contrast_ratio(a, to_hex(b))

for f in (:meets_aa, :meets_aaa)
    @eval begin
        $f(fg::ColorTypes.Colorant, bg::ColorTypes.Colorant; kwargs...) =
            $f(to_hex(fg), to_hex(bg); kwargs...)
        $f(fg::ColorTypes.Colorant, bg::AbstractString; kwargs...) =
            $f(to_hex(fg), bg; kwargs...)
        $f(fg::AbstractString, bg::ColorTypes.Colorant; kwargs...) =
            $f(fg, to_hex(bg); kwargs...)
    end
end

# ── ColorTypes' internal conversion path ──
# Constructor-style conversion (`RGB24(c)`, `ARGB32(c)`) does not go through
# `Base.convert`; ColorTypes routes it via `cconvert`/`_convert`. Colors.hex
# and the SVG swatch both take that route, so teach it about HCT too.
ColorTypes._convert(::Type{Cout}, ::Type{C1}, ::Type{HCT}, c::HCT) where {
        Cout<:ColorTypes.AbstractRGB, C1<:ColorTypes.AbstractRGB} =
    convert(Cout, c)

ColorTypes._convert(::Type{A}, ::Type{C1}, ::Type{HCT}, c::HCT, alpha = 1.0) where {
        A<:ColorTypes.TransparentRGB, C1<:ColorTypes.AbstractRGB} =
    A(convert(ColorTypes.RGB{Float64}, c), alpha)
