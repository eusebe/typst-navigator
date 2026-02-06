#import "../lib.typ": *

#set page(width: 15cm, height: auto, margin: 1cm)

= A very long heading that should be replaced <long-h1>
#metadata("Short H1") <short>

== Another long heading for level 2 <long-h2>
#metadata("Short H2") <short>

=== Level 3 long heading <long-h3>
#metadata("Short H3") <short>

#v(2em)
*Default (should use original titles now as default is false):*
#progressive-outline()

#v(2em)
*Short titles enabled:*
#progressive-outline(use-short-title: true)

#v(2em)
*Short titles disabled (explicit):*
#progressive-outline(use-short-title: false)

#v(2em)
*Short titles + Truncation (Short H1 -> Sho...):*
#progressive-outline(use-short-title: true, max-length: 6)

#v(2em)
*Short titles per level (L1: true, L2: false):*
#progressive-outline(use-short-title: (level-1: true, level-2: false))

#v(2em)
*Test with resolve-slide-title:*
#navigator-config.update(c => { c.auto-title = true; c })
#context {
  let title = resolve-slide-title(none)
  [Current Resolved Slide Title: #title]
}

#v(2em)
*Test with miniframes:*
#context {
  let all-shorts = query(<short>)
  let struct = get-structure(all-shorts: all-shorts)
  render-miniframes(struct, 1, max-length: 10, use-short-title: true)
}
