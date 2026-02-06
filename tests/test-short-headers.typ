#import "../lib.typ": *

#set page(width: 15cm, height: auto, margin: 1cm)

= This is a very long title for level 1
== This is a very long title for level 2

#v(2em)
*Default (no truncation):*
#progressive-outline()

#v(2em)
*Global truncation (max-length: 10):*
#progressive-outline(max-length: 10)

#v(2em)
*Per-level truncation (level-1: 5, level-2: 20):*
#progressive-outline(max-length: (level-1: 5, level-2: 20))

#v(2em)
*Mixed truncation (level-1 only: 15):*
#progressive-outline(max-length: (level-1: 15))
