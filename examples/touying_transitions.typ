#import "@preview/touying:0.7.3": *
#import themes.simple: *
#import "../lib.typ" as navigator

// --- Configuration ---
#let primary = rgb("#003366")

// Navigator configuration must be placed BEFORE show: simple-theme to avoid
// Touying wrapping the state update in a blank slide.
#navigator.navigator-config.update(c => {
  c.mapping = (section: 1, subsection: 2)
  // No slide-func needed: progressive-outline is called directly in the hooks,
  // not via render-transition.
  c
})

// --- Custom transition slide ---
//
// Touying provides native hooks for section/subsection transitions via
// config-common(new-section-slide-fn: ..., new-subsection-slide-fn: ...).
// We plug progressive-outline directly into those hooks.
//
// This differs from the polylux example (polylux_progressive_ouline.typ):
//
//  Aspect               │ polylux                          │ Touying (this file)
// ──────────────────────┼──────────────────────────────────┼─────────────────────────────────
//  Detection            │ show heading: render-transition  │ new-section/subsection-slide-fn
//  Navigator function   │ render-transition (high-level)   │ progressive-outline (low-level)
//  slide-func needed    │ Yes                              │ No
//  Slide counter        │ manual                           │ freeze-slide-counter: true
//  target-location      │ h.location() explicit            │ here() via match-page-only: true
//
// A single hook handles both sections and subsections: at hook call time,
// here() already points to the new heading, so match-page-only: true is
// sufficient to identify the active entry in progressive-outline.
// Short titles (from <short> markers) are shown in the outline when available.

#let nav-transition-slide(config: (:), body) = touying-slide-wrapper(self => {
  let self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(fill: primary, header: none, footer: none),
  )
  let roadmap = navigator.progressive-outline(
    level-1-mode: "current",
    level-2-mode: "current-parent",
    level-3-mode: "none",
    match-page-only: true,
    use-short-title: true,
    text-styles: (
      level-1: (
        active:    (fill: white,                    weight: "bold",    size: 1.3em),
        completed: (fill: white.transparentize(30%), weight: "bold",    size: 1.3em),
        inactive:  (fill: white.transparentize(60%), weight: "bold",    size: 1.3em),
      ),
      level-2: (
        active:    (fill: white,                    weight: "regular", size: 1em),
        completed: (fill: white.transparentize(30%), weight: "regular", size: 1em),
        inactive:  (fill: white.transparentize(60%), weight: "regular", size: 1em),
      ),
    ),
  )
  touying-slide(self: self, config: config, {
    set align(top + left)
    v(35%)
    pad(x: 10%, roadmap)
  })
})

// --- Theme ---
#show: simple-theme.with(
  aspect-ratio: "16-9",
  config-colors(primary: primary),
  config-common(
    new-section-slide-fn:    nav-transition-slide,
    new-subsection-slide-fn: nav-transition-slide,
  ),
)

// --- Content ---

#title-slide[
  #set align(center + horizon)
  #text(size: 1.5em, weight: "bold", fill: primary)[Touying + Navigator] \
  #v(0.5em)
  #text(size: 0.9em, style: "italic")[Structural Transitions via Native Hooks]
]

// =============================================================================
// The subsection headings below have intentionally long, descriptive names.
// The <short> markers define abbreviated versions shown in the transition
// outline — demonstrating the use-short-title: true option above.
// =============================================================================

= Background & Motivation

== Why Presentation Structure Matters
#metadata("Motivation") <short>

#slide[
  Structured presentations help audiences track where they are in a talk.
  Navigator generates transition slides automatically from the document outline.

  #v(1em)
  - Section transitions: show the full plan
  - Subsection transitions: highlight current position
  - Slides stay in sync without manual effort
]

#slide[
  #set align(center + horizon)
  #text(style: "italic")[
    "A well-structured talk is a talk the audience can follow \
     even when they lose concentration for a moment."
  ]
]

== Existing Approaches and Their Limitations
#metadata("Prior work") <short>

#slide[
  Most Typst presentation packages handle navigation manually:

  - *Polylux:* `show heading: h => render-transition(h, ...)`
  - *Diatypst / typslides:* similar hook-based approach
  - *Touying:* native section/subsection hooks → cleaner integration
]

= Design & Implementation

== Architecture of the Touying Integration
#metadata("Architecture") <short>

#slide[
  The key insight: Touying's `new-section-slide-fn` hook fires exactly when a
  new section or subsection is encountered, and `here()` already points to that
  heading's location.

  #v(0.5em)
  This makes `match-page-only: true` reliable for identifying the active entry
  in `progressive-outline`, without needing `h.location()` explicitly.
]

== Handling Short Titles in the Outline
#metadata("Short titles") <short>

#slide[
  Long subsection names would overflow the transition slide.
  Navigator supports `<short>` markers placed right after a heading:

  ```typst
  == A Very Long and Descriptive Subsection Title
  #metadata("Short version") <short>
  ```

  The outline then uses the short version; the slide header keeps the full title.
]

#slide[
  Short titles are resolved per level via `use-short-title: true` in
  `progressive-outline`. You can also pass a per-level dictionary:

  ```typst
  use-short-title: ("level-1": false, "level-2": true)
  ```
]

= Results & Conclusion

== Observed Improvements in Audience Engagement
#metadata("Results") <short>

#slide[
  In this example, the transition slides show:

  - The *active* section/subsection in white
  - *Completed* items in semi-transparent white
  - *Upcoming* items in dimmed white

  The visual hierarchy guides the audience through the structure.
]

== Conclusion and Future Directions
#metadata("Conclusion") <short>

#slide[
  #set align(center + horizon)
  #stack(spacing: 1.5em,
    text(fill: primary, weight: "bold", size: 1.1em)[
      Touying's native hooks + `progressive-outline` = \
      zero-boilerplate structural transitions
    ],
    text(size: 0.85em, fill: gray)[
      See also: `polylux_progressive_ouline.typ` for the alternative approach.
    ],
  )
]
