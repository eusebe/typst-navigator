#import "@preview/touying:0.7.3": *
#import themes.simple: *
#import "../lib.typ" as navigator

// --- Configuration ---
#let primary = rgb("#003366")

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

// --- Navigator configuration ---
// No slide-func needed: progressive-outline is called directly in the hooks,
// not via render-transition.
#navigator.navigator-config.update(c => {
  c.mapping = (section: 1, subsection: 2)
  c
})

// --- Content ---

#slide[
  #set align(center + horizon)
  #text(size: 1.5em, weight: "bold", fill: primary)[Touying + Navigator] \
  #v(0.5em)
  #text(size: 0.9em, style: "italic")[Structural Transitions via Native Hooks]
]

= Introduction

== Welcome

#slide[
  #lorem(40)
]

== Objectives

#slide[
  #lorem(40)
]

= Methodology

== Data Collection

#slide[
  #lorem(40)
]

== Analysis

#slide[
  #lorem(40)
]

= Conclusion

== Final Thoughts

#slide[
  #set align(center + horizon)
  #text(fill: primary, weight: "bold", size: 1.2em)[Thank you!]
]
