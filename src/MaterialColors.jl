"""
    MaterialColors

A pure-Julia implementation of the HCT colour space and the Material Design 3
colour system: CAM16 appearance modelling, tonal palettes, scheme generation,
and WCAG contrast helpers.

Ported from Google's material-color-utilities (Apache-2.0). See NOTICE.
"""
module MaterialColors

using StaticArrays

# ─────────────────────────────────────────────────────────────────────────────
# Colour engine
# ─────────────────────────────────────────────────────────────────────────────

include("color/hct.jl")
include("color/tonal_palette.jl")
include("color/color_scheme.jl")
include("color/contrast.jl")

# Colour space
export HCT, hct, to_hex

# Tonal palettes
export TonalPalette, tonal_palette, tone_at, precompute!

# Schemes
export color_scheme, color_scheme_pair

# Contrast
export contrast_ratio, meets_aa, meets_aaa, lighter_tone, darker_tone

end
