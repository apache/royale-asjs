# Royale Style Project

`Style` is a Royale component set inspired by the utility-first approach popularized by Tailwind CSS.

The goal is to make it easy to build consistent, modern UIs in Royale by composing small, reusable style units instead of relying on large, monolithic theme files.

## Vision

- Bring utility-style ergonomics to Royale applications.
- Keep styling composable and predictable.
- Generate visual assets at runtime when possible to reduce static asset management.

## Goals
- Provide a core set of style beads that can be combined to create complex styles.
- Maximize performance wherever possible.
- Enable dynamic class composition at runtime for maximum flexibility in styling components.
- Matches Tailwind naming conventions where it makes sense to provide familiarity for developers coming from a utility-first CSS background.
- Only include in runtime what is necessary to keep the bundle size small and performance high.
- Provide a complete set of runtime-generated colors that can be used in style beads and components without needing to pre-generate static variants.
- Provide theming capabilities that allow for easy switching between color palettes and dynamic color usage in components.
- Provide skinning capabilities that allow for application on css as well as colors and icons for specific components.
- Enable runtime generation of colors and SVG icons for maximum flexibility.
- Keep the API simple and intuitive that enables easy composition using Royale concepts and patterns.

## Non-goals
- We don't intend to have full Tailwind compatibility. Where the patterns are too convergent, or Tailwind's approach doesn't fit well with Royale's architecture, we will diverge and create APIs that are more natural for Royale developers.
- We won't include a large set of pre-generated static style variants. Instead, we will focus on providing the building blocks and runtime capabilities to generate styles dynamically as needed.
- We are not styling components by default. Instead, we will provide style beads that can be applied to components as needed, allowing developers to choose the level of styling they want to apply to their components.
- We are not precompiling CSS at compile time like Tailwind does. Instead, we will generate styles at runtime based on the style beads applied to components and the current theme or palette in use.

## Core Concepts

### 1) Style Beads (runtime class composition)

The project introduces **style beads** that compose style classes at runtime.

This enables developers to:

- apply styles in small, focused building blocks,
- combine multiple style classes dynamically,
- adapt component appearance based on state, data, or interaction.

### 2) Runtime Colors

Color values are designed to be resolved/generated at runtime.

This allows:

- easier theme switching,
- dynamic palette usage,
- less duplication of pre-generated static style variants.

### 3) Runtime SVG Icons

SVG icons are created at runtime as well, enabling:

- dynamic icon coloring,
- scalable icon rendering,
- flexible icon usage without requiring a large set of precompiled assets.

## Implementation Details

### CSS Variables and Lookups
- This component set supports faux CSS variables by using a global CSS lookup system.
- Custom CSS variables can be registered and used anywhere CSS values are accepted, such as in style beads or component styles.
- The naming of these vartiables is flexible, but they must be registered with the CSS lookup system to be used in styles.
-- The names must **not** include the `--` prefix that is typically used in CSS variable naming. For example, a color variable would be registered as `primary` instead of `--primary`.

### Colors
- Colors are defined as static properties on color swatch classes (e.g., `SkySwatch._500`).
- When accessed, these properties register the color value with a global CSS lookup and return a string name that can be used in style beads and components.
- This allows for dynamic color generation and usage without needing to pre-generate static CSS classes for each color variant.
- Anywhere colors are applied, the string name of the color should be used, , but the nmes must be registered by CSSLookup first.

### Arbitrary CSS Values
- Any style bead which acepts a `value` should support names registered with CSSLookup. This enables specifying specific styling used in theming such as custom box-shadows or filters, etc. without needing to create a new style bead for each unique value.

### Animations
- Style includes the prebuilt standard animations inclused in Tailwind.
- Those standard settings can be customized in the StyleTheme.
- If custom keyframes are needed, they must be registered in the AnimationManager.
- Keyframes are registered with a `name` and an array of the keyframe steps.
- Animation variables can be defined as any other CSS variable definition. The rule should use the keyframe name as necessary.
- All keyframe names must be unique across the application to avoid conflicts.

## Why this project

Traditional styling in large component systems can become rigid over time. This project aims to keep Royale styling lightweight, composable, and application-driven by combining:

- utility-inspired style composition,
- runtime style beads,
- runtime-generated colors and SVG icons.

## Examples

Simple usage of style beads to compose styles on a component:
```xml
<st:IconButton theme="dark">
	<st:icon>
		<st:PencilIcon size="M" />
	</st:icon>
  <st:beads>
	  <st:ColorStyle color="primary" />
	</st:beads>
</st:IconButton>
```

An icon can be specified something like this as well:
```xml
<st:IconButton theme="dark" icon={Icons.MediumPencil}/>
```

More comples example with state beads:
```xml
<st:Button>
	<st:beads>
		<st:ColorStyle color="primary" />
		<st:HoverStyle>
			<st:ColorStyle color="primaryHover" />
		</st:HoverStyle>
	</st:beads>
</st:Button>
```

More copmplex example showing support for media queries and dynamic class composition:
```xml
<st:Button>
	<st:beads>
		<st:ColorStyle color="primary" />
		<st:HoverStyle>
			<st:ColorStyle color="primaryHover" />
		</st:HoverStyle>
		<st:MediaQuery maxWidth="600px">
			<st:ColorStyle color="primaryLarge" />
		</st:MediaQuery>
	</st:beads>
</st:Button>
```
Examples of skins:

### Defining a skin:
```xml
<st:Skin xmlns:st="library://ns.apache.org/royale/style"
  theme="dark">
	<st:icon>
		<st:PencilIcon size="M" />
	</st:icon>
	<st:beads>
		<st:ColorStyle color="primary" />
		<st:HoverStyle>
			<st:ColorStyle color="primaryHover" />
		</st:HoverStyle>
	</st:beads>
</st:Skin>
```

1) Using MXML:
```xml
<st:Button>
	<st:skin>
		<local:CustomButtonSkin/>
	</st:skin>
</st:Button>
```

2) In Actionscript:
```actionscript
var button:Button = new Button();
button.skin = new CustomButtonSkin();
```
3) Using CSS:
```css
Button {
	skin: ClassReference("com.example.skins.CustomButtonSkin");
}
```

## Status

This project is under active development. APIs and naming may evolve as style beads, runtime class composition, and asset generation are expanded.


### To work on later:
- (min/max-)inline-size
- (min/max-)block-size
- Add support for normal rgb for browsers which don't support oklch (i.e. CEP) Maybe?
- border "between" https://tailwindcss.com/docs/border-width
- Audit all of the available Tailwind state classes: https://tailwindcss.com/docs/hover-focus-and-other-states#quick-reference


### Internal notes
- It does not look like we need ContainerBase
- We need cascading styling.
- For that to work, any "leaf" style bead should only be applied once.
- Leaf stlye beads should be considered unique if they are decorated by state beads.
- The first bead to be applied should win.
- Skins should be applied last.
- That would allow overriding specific style beads declared in a a skin.
- Full order should probably be something like this:
	1. Directly applied style beads
	2. Beads listed in the styleBeads property of the component
	3. Skin beads applied directly to the component
	4. Beads declared in the component's CSS.
	5. Skins declared in the component's CSS.
- To facilitate this, leaf beads need to become special:
	- All leaf beads will be applied directly to the component.
	- All leaf beads will have their class prefix decorated by their parent state beads.
	- State beads will have a way to return all their descendant leaf beads with the correctly decorated class names.
	- Each component will maintain a list of all applied leaf beads names. Maybe it can be efficient enough to loop through the beads and check instead of maintaining the list. Needs thought.
	- When trying to add a bead, the component will check if any of the leaf beads it would apply are already in the list of applied leaf beads. If so, it will skip applying that bead.

