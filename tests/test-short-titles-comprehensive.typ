#import "../lib.typ": *

#set page(width: 20cm, height: auto, margin: 1cm)
#set text(font: "Helvetica", size: 12pt)

// Utility for visual separation
#let separator(title) = block(width: 100%, inset: 1em, fill: luma(240), above: 2em, below: 1em)[
  *TEST CASE: #title*
]

// Mock slide function for transitions
#let mock-slide(fill: white, body) = block(
  width: 100%, 
  height: 6em, 
  fill: fill, 
  inset: 1em,
  stroke: 1pt + black
)[#body]

// ----------------------------------------------------------------------
// 1. METADATA PLACEMENT TESTS
// ----------------------------------------------------------------------

#separator("1. Metadata Placement Variants")

= Title on one line
#metadata("Short 1") <short>

== Title with metadata on same line in markup #metadata("Short 2") <short>

=== Title with content before metadata
Content here.
#metadata("Short 3") <short>

==== Title far above
#lorem(5)
#metadata("Short 4") <short>

#progressive-outline(
  use-short-title: true,
  level-1-mode: "all", 
  level-2-mode: "all", 
  level-3-mode: "all"
)

// ----------------------------------------------------------------------
// 2. LAYOUT & NUMBERING
// ----------------------------------------------------------------------

#separator("2. Horizontal Layout + Numbering")

#set heading(numbering: "I.a.")

= Numbered Long Title One
#metadata("Num 1") <short>

== Numbered Long Title Two
#metadata("Num 2") <short>

#progressive-outline(
  layout: "horizontal", 
  level-1-mode: "all", 
  level-2-mode: "all", 
  show-numbering: true,
  use-short-title: true
)

// ----------------------------------------------------------------------
// 3. COMPLEX CONFIGURATION (Truncation + Selective Short Titles)
// ----------------------------------------------------------------------

#separator("3. Truncation & Selective Short Titles")

= Verify Truncation of Short Title
#metadata("This is still a bit too long") <short>

== Verify Truncation of Original Title (Short title disabled)
#metadata("Hidden Short") <short>

#progressive-outline(
  level-1-mode: "current",
  level-2-mode: "all",
  max-length: 15,
  use-short-title: (level-1: true, level-2: false)
)

// ----------------------------------------------------------------------
// 4. TRANSITIONS
// ----------------------------------------------------------------------

#separator("4. Transitions Integration")

#show heading.where(level: 1): h => render-transition(
  h,
  slide-func: mock-slide,
  mapping: (section: 1),
  transitions: (
    sections: (enabled: true, visibility: (section: "all"))
  ),
  use-short-title: true
)

= Transition Test Section
#metadata("Trans. Sect.") <short>

// Note: The transition should appear ABOVE this text in the PDF due to 'place' but we verify the content

// ----------------------------------------------------------------------
// 5. MINIFRAMES
// ----------------------------------------------------------------------

#separator("5. Miniframes Integration")

#context {
  let struct = get-structure(all-shorts: query(<short>))
  render-miniframes(
    struct, 
    1, 
    show-level1-titles: true, 
    show-level2-titles: true,
    max-length: 10,
    use-short-title: true
  )
}
