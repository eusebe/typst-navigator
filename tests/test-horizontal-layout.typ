#import "../src/progressive-outline.typ": progressive-outline

#set page(paper: "presentation-16-9")
#set text(font: "Lato", size: 20pt)

= Section 1
== Subsection 1.1
== Subsection 1.2

#v(2em)
*Layout Horizontal (Buggy if space is huge):*
#line(length: 100%)
#progressive-outline(layout: "horizontal", level-2-mode: "all")
#line(length: 100%)

#v(2em)
*Layout Vertical (Should still work):*
#progressive-outline(layout: "vertical", level-2-mode: "all")
