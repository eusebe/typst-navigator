# Navigator

**Navigator** is an navigation engine for Typst. It provides a modular suite of tools to generate dynamic tables of contents (progressive outlines), progress bars (miniframes), and automated transition slides. It should be compatible with any presentation framework (e.g. Polylux, Presentate, Typslides). All tools could also be used for any native Typst documents (particularly the `progressive-outline` function), but they are really usefull when use within a structured presentation.

## Key Features

- **Progressive Outline**: A roadmap component that adapts to the current position in the document, with smart state management (active, completed, future).
- **Flexible Miniframes**: Highly configurable progress markers (compact vs. grid modes, alignment, vertical positioning).
- **Transition Engine**: Automatically generates "roadmap" slides during section changes via simple show rules.

## Installation

Import the package from the Typst Universe:

```typ
#import "@preview/navigator:0.1.0": *
```

## Core Components

### Progressive Outline (`progressive-outline`)
The `progressive-outline` function inserts a table of contents that reflects the document's progression. See [detailed documentation](docs/progressive-outline.typ).

```typ
#progressive-outline(
  level-1-mode: "all",
  level-2-mode: "current-parent",
  text-styles: (
    level-1: (active: (weight: "bold", fill: navy), inactive: 0.5),
  ),
  spacing: (v-between-1-2: 1em)
)
```

### Navigation Bars (`render-miniframes`)
Generates a bar of dots (miniframes) representing the logical structure of a presentation. See [detailed documentation](docs/miniframes.typ).

```typ
#render-miniframes(
  structure,            // Extracted via get-structure()
  current-slide-num,    // Current active slide index
  style: "compact",
  navigation-pos: "top",
  active-color: blue
)
```

### Transition Engine (`render-transition`)
Automates the creation of roadmap slides using a show rule on structural headings. See [detailed documentation](docs/transition.typ).

```typ
#show heading.where(level: 1): h => render-transition(
  h,
  mapping: (section: 1, subsection: 2),
  slide-func: my-slide-wrapper, // Callback to your slide engine
  transitions: (background: navy)
)
```

## Demos

Integration examples for various frameworks and document types are available in the `examples/` directory:

- **Polylux**: [Miniframes](examples/polylux_miniframes.typ), [Progressive Outline & Transitions](examples/polylux_progressive_ouline.typ)
- **Typslides**: [Miniframes](examples/typslides_miniframes.typ)
- **Native / Standard Documents**: [Report with local roadmaps](examples/report.typ), [Customizable markers](examples/markers.typ)

## License

Distributed under the MIT License. See `LICENSE` for more information.
