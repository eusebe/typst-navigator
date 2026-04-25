#import "@preview/touying:0.7.3": *
#import themes.simple: *
#import "../lib.typ" as navigator

// --- Configuration ---
#let primary = rgb("#003366")

// Navigator configuration must be placed BEFORE show: simple-theme to avoid
// Touying wrapping the state update in a blank slide.
#navigator.navigator-config.update(c => {
  c.mapping = (section: 1, subsection: 2)
  c
})

// --- Transition slide ---
//
// Plugged into new-section-slide-fn and new-subsection-slide-fn.
// level-3-mode: "none" keeps per-slide titles out of the outline —
// they are an intra-slide concern, not part of the document structure.
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
        active:    (fill: white,                     weight: "bold",    size: 1.3em),
        completed: (fill: white.transparentize(30%),  weight: "bold",    size: 1.3em),
        inactive:  (fill: white.transparentize(60%),  weight: "bold",    size: 1.3em),
      ),
      level-2: (
        active:    (fill: white,                     weight: "regular", size: 1em),
        completed: (fill: white.transparentize(30%),  weight: "regular", size: 1em),
        inactive:  (fill: white.transparentize(60%),  weight: "regular", size: 1em),
      ),
    ),
  )
  touying-slide(self: self, config: config, {
    set align(top + left)
    v(35%)
    pad(x: 10%, roadmap)
  })
})

// --- Slide preamble ---
//
// With slide-level: 3, each === heading creates an implicit slide.
// This preamble shows:
//   • the === title (level 3) when the current slide has one
//   • the == subsection title (level 2) as fallback otherwise
//
// utils.current-heading queries all headings (including those not outlined),
// so it reliably sees the level-3 headings inserted by Touying.
#let slide-preamble = context {
  let h3 = utils.current-heading(level: 3)
  let title = if h3 != none {
    h3.body
  } else {
    let h2 = utils.current-heading(level: 2)
    if h2 != none { h2.body } else { none }
  }
  if title != none {
    block(below: 1.5em, text(1.2em, weight: "bold", title))
  }
}

// --- Theme ---
//
// slide-level: 3 means:
//   =   (level 1) → new-section-slide-fn    (transition slide)
//   ==  (level 2) → new-subsection-slide-fn (transition slide)
//   === (level 3) → slide-fn                (content slide, no #slide[] needed)
#show: simple-theme.with(
  aspect-ratio: "16-9",
  config-colors(primary: primary),
  config-common(
    slide-level: 3,
    new-section-slide-fn:    nav-transition-slide,
    new-subsection-slide-fn: nav-transition-slide,
  ),
  subslide-preamble: slide-preamble,
)

// --- Content ---

#title-slide[
  #set align(center + horizon)
  #text(size: 1.5em, weight: "bold", fill: primary)[Touying + Navigator] \
  #v(0.5em)
  #text(size: 0.9em, style: "italic")[
    Structural Transitions · Per-slide Titles via `slide-level: 3`
  ]
]

// =============================================================================
// With slide-level: 3, === headings create content slides implicitly.
// No #slide[] wrapper is needed. Each === opens a new slide; the content
// between two === headings (or between === and the next == / =) is the body.
//
// The slide preamble shows the === title when present. Slides created with
// #slide[] (or content between == and the first ===) display the subsection
// title instead, demonstrating the fallback.
// =============================================================================

= Background & Motivation

== Why Structure Matters

=== The audience perspective

Structured presentations help audiences track where they are in a talk.
Navigator generates transition slides automatically from the document outline.

#v(1em)
- Section transitions: show the full plan
- Subsection transitions: highlight current position
- Slides stay in sync without manual effort

=== A key observation

#set align(center + horizon)
#text(style: "italic")[
  "A well-structured talk is a talk the audience can follow \
   even when they lose concentration for a moment."
]

== Existing Approaches

=== Polylux: show-rule-based transitions

Most Typst presentation packages handle navigation manually:

- *Polylux:* `show heading: h => render-transition(h, ...)`
- *Diatypst / typslides:* similar hook-based approach
- *Touying:* native section/subsection hooks → cleaner integration

=== Why native hooks are better

With Touying's hooks, `here()` already points to the heading at hook call
time — no need to pass `h.location()` explicitly.

#v(0.5em)
This makes `match-page-only: true` reliable for identifying the active entry
in `progressive-outline`.

= Design & Implementation

== Implicit Slides via `slide-level: 3`

=== How the heading hierarchy works

Setting `slide-level: 3` in `config-common` changes the heading hierarchy:

#table(
  columns: (auto, 1fr, 1fr),
  align: (center, left, left),
  table.header([*Level*], [*Syntax*], [*Effect*]),
  [1], [`= Section`],     [Section transition (nav-transition-slide)],
  [2], [`== Subsection`], [Subsection transition (nav-transition-slide)],
  [3], [`=== Title`],     [Content slide — no `#slide[]` needed],
)

=== The document structure

```typst
= Section          // → transition slide
== Subsection      // → transition slide
=== Slide title    // → content slide (implicit)
Content here...
=== Next slide     // → next content slide (implicit)
More content...
```

Each `===` heading opens a new slide and its text appears in the preamble.

== The Preamble Fallback

=== Preamble with a slide-specific title

This slide has a `===` heading, so its own title is shown above.
The subsection title ("The Preamble Fallback") is *not* shown.

The preamble logic:

```typst
let h3 = utils.current-heading(level: 3)
let title = if h3 != none { h3.body } else {
  let h2 = utils.current-heading(level: 2)
  if h2 != none { h2.body } else { none }
}
```

// Explicit #slide[] with no === heading: subsection title shown as fallback.
#slide[
  This slide was created with an explicit `#slide[]` — no `===` heading.

  #v(0.8em)
  The preamble above shows *"The Preamble Fallback"* (the current subsection
  title), because no level-3 heading is active on this page.

  #v(0.8em)
  Explicit `#slide[]` blocks can always be mixed with implicit `===` slides.
]

= Results & Conclusion

== Summary

=== What this example demonstrates

#set list(tight: false)
- `slide-level: 3` enables heading-driven slide creation without `#slide[]`
- `===` headings appear as per-slide titles in the preamble
- Slides without a `===` heading (explicit `#slide[]`) fall back to `==`
- `level-3-mode: "none"` keeps `===` headings out of transition outlines —
  they are an intra-slide concern, invisible to `progressive-outline`

== Conclusion

=== Zero boilerplate

#set align(center + horizon)
#stack(
  spacing: 1.5em,
  text(fill: primary, weight: "bold", size: 1.05em)[
    `slide-level: 3` + `progressive-outline` + per-slide `===` titles \
    #sym.arrow.r fully structured presentations with zero boilerplate
  ],
  text(size: 0.85em, fill: gray)[
    See also: `polylux_progressive_ouline.typ` for the Polylux approach.
  ],
)
