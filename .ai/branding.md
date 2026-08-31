# SSoQE visual identity

This document records the current visual system. It governs new or deliberately modified visual material; it is not authorization to redesign existing output.

## Color tokens

| Token | Value | Default role |
|---|---:|---|
| White | `#F2F4F2` | Light background and reversed text |
| Black | `#1F2937` | Body text and dark neutral |
| Midnight green | `#155560` | Primary structure and headings |
| Persian green | `#509A8E` | Links and secondary emphasis |
| Cambridge blue | `#A1C3B3` | Light surfaces and code backgrounds |
| Satin sheen gold | `#C2A337` | Restrained accent |

- Use semantic tokens rather than introducing near-duplicate colors.
- Gold is an accent, not a default body-text color. Check text/background contrast whenever colors are combined or transparency is introduced.
- Do not infer inaccessible foreground colors from brand preference; readable contrast takes precedence.

## Typography

- Body: **Plus Jakarta Sans**, followed by suitable system sans-serif fallbacks.
- Headings: **Space Grotesk**, then Plus Jakarta Sans and system fallbacks.
- Code: **JetBrains Mono**, followed by suitable system monospace fallbacks.
- Preserve heading weight 600, body weight 400, and bold weight 700 unless a format-specific implementation documents a reason to differ.
- Do not add another web-font dependency for convenience. Retain fallbacks so content remains usable when remote fonts are unavailable.

## Logo

- `SSOQE_logo3` is the current SSoQE logo used by the website and lecture materials.
- Preserve its aspect ratio, transparency, internal padding, and original colors.
- Do not stretch, crop, recolor, trace, redraw, or substitute it without an explicit brand-change request.
- Third-party marks are outside the SSoQE brand system. They require their own permission and attribution and must not imply endorsement.

## Implementations and ownership

- For template-derived lectures, edit `Presentation/colors.json`, `Presentation/fonts.json`, or `Presentation/custom_theme.json`, then run `R/generate_theme.R`. The generated SCSS, font include, exercise theme, and R plotting theme remain tracked products, not editable sources.
- For the public website, `styles.scss` is the format-specific implementation of the shared tokens. Lecture layout rules do not automatically apply to it.
- A repository may document an intentional deviation in `.ai/repository.md`. Undocumented drift is an error.
- A global brand change must update this registry, every affected editable implementation, generated files, and rendered visual checks in one coordinated change.
