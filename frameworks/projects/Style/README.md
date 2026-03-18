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
- peer and peer-has.
```css
.peer:focus ~ .peer-focus\:invisible {
    visibility: hidden;
}
.peer-has-checked\:hidden:is(:where(.peer):has(:checked) ~ *) {
	display: none;
}
```
- "not" media queries:
```css
@media not all and (min-width:80rem) {
    .not-xl\:hidden {
      display:none
    }
  }
```
- [hidden preflight](https://tailwindcss.com/docs/preflight#elements-with-a-hidden-attribute-stay-hidden)
- [Deal with list defaults](https://tailwindcss.com/docs/preflight#lists-are-unstyled)
- [Deal with form heading defaults](https://tailwindcss.com/docs/preflight#headings-are-unstyled)

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

### CSS Notes:

**Combinators:**
- Child: `" > "`
- Descendant: `" "` (space)
- Adjacent sibling: `" + "`
- Sibling: `" ~ "`

**Selectors:**
- `&`: refers to the current selector in nested CSS rules. (not sure if we need it)
- `[]`: attribute selector, can be used to target elements with specific attributes or attribute values.

**Pseudo-classes:**
- `:hover`: applies when the user hovers over an element.
- `:focus`: applies when an element has focus.
- `:active`: applies when an element is being activated (e.g., clicked).
- `:disabled`: applies when an element is disabled.
- `:checked`: applies to checkboxes or radio buttons that are checked.
- `:first-child`: applies to an element that is the first child of its parent.
- `:last-child`: applies to an element that is the last child of its parent.
- `:nth-child(n)`: applies to an element that is the nth child of its parent.
- `:not(selector)`: applies to elements that do not match the specified selector.
- `:has(selector)`: applies to elements that have at least one descendant that matches the specified selector.
- `:is(selector)`: applies to elements that match any of the selectors in the list.
- `:where(selector)`: similar to `:is()`, but with zero specificity, meaning it won't override other styles.
- `:root`: applies to the root element of the document (e.g., `<html>` in HTML).
- `:empty`: applies to elements that have no children (including text nodes).
- `:nth-of-type(n)`: applies to an element that is the nth child of its type (tag name) among its siblings.
- `:first-of-type`: applies to an element that is the first child of its type among its siblings.
- `:last-of-type`: applies to an element that is the last child of its type among its siblings.
- `:only-child`: applies to an element that is the only child of its parent.
- `:only-of-type`: applies to an element that is the only child of its type among its siblings.
- `:lang(language)`: applies to elements that are in a specific language (e.g., `:lang(en)` for English).
- `:dir(direction)`: applies to elements based on their text direction (e.g., `:dir(ltr)` for left-to-right).
- `:in-range`: applies to input elements with a value within a specified range.
- `:out-of-range`: applies to input elements with a value outside a specified range.
- `:valid`: applies to input elements with valid values.
- `:invalid`: applies to input elements with invalid values.
- `:required`: applies to input elements that are required.
- `:optional`: applies to input elements that are not required.
- `:read-only`: applies to elements that are read-only.
- `:read-write`: applies to elements that are not read-only.
- `:placeholder-shown`: applies to input elements that are showing placeholder text.
- `:default`: applies to form elements that are in their default state.
- `:indeterminate`: applies to checkboxes that are in an indeterminate state.
- `:fullscreen`: applies to elements that are in fullscreen mode.
- `:focus-within`: applies to an element if it or any of its descendants have focus.
- `:focus-visible`: applies to an element when it receives focus and the user agent determines that the focus should be visibly indicated (e.g., when navigating with a keyboard).
- `:current`: applies to elements that represent the current item within a set (e.g., the current page in a pagination component).
- `:past`: applies to elements that represent items that are in the past relative to the current item.
- `:future`: applies to elements that represent items that are in the future relative to the current item.
- `:seeking`: applies to elements that are in the process of being focused or activated.
- `:playing`: applies to media elements that are currently playing.
- `:paused`: applies to media elements that are currently paused.
- `:stalled`: applies to media elements that are stalled (e.g., waiting for data).
- `:muted`: applies to media elements that are muted.
- `:volume-locked`: applies to media elements that have a locked volume state.
- `:scope`: applies to the element that is the scope of a query (e.g., the element that is the context for a `:has()` selector).


Review all these preflight rules and fiugre out how to make them as PAYG as possible:

```css
*,
::after,
::before {
	box-sizing: border-box;
	border-width: 0;
	border-style: solid;
	border-color: #e5e7eb
}

::after,
::before {
	--tw-content: ''
}

:host,
html {
	line-height: 1.5;
	-webkit-text-size-adjust: 100%;
	-moz-tab-size: 4;
	tab-size: 4;
	font-family: ui-sans-serif, system-ui, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
	font-feature-settings: normal;
	font-variation-settings: normal;
	-webkit-tap-highlight-color: transparent
}

body {
	margin: 0;
	line-height: inherit
}

hr {
	height: 0;
	color: inherit;
	border-top-width: 1px
}

abbr:where([title]) {
	-webkit-text-decoration: underline dotted;
	text-decoration: underline dotted
}

h1,
h2,
h3,
h4,
h5,
h6 {
	font-size: inherit;
	font-weight: inherit
}

a {
	color: inherit;
	text-decoration: inherit
}

b,
strong {
	font-weight: bolder
}

code,
kbd,
pre,
samp {
	font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
	font-feature-settings: normal;
	font-variation-settings: normal;
	font-size: 1em
}

small {
	font-size: 80%
}

sub,
sup {
	font-size: 75%;
	line-height: 0;
	position: relative;
	vertical-align: baseline
}

sub {
	bottom: -.25em
}

sup {
	top: -.5em
}

table {
	text-indent: 0;
	border-color: inherit;
	border-collapse: collapse
}

button,
input,
optgroup,
select,
textarea {
	font-family: inherit;
	font-feature-settings: inherit;
	font-variation-settings: inherit;
	font-size: 100%;
	font-weight: inherit;
	line-height: inherit;
	letter-spacing: inherit;
	color: inherit;
	margin: 0;
	padding: 0
}

button,
select {
	text-transform: none
}

button,
input:where([type=button]),
input:where([type=reset]),
input:where([type=submit]) {
	-webkit-appearance: button;
	background-color: transparent;
	background-image: none
}

:-moz-focusring {
	outline: auto
}

:-moz-ui-invalid {
	box-shadow: none
}

progress {
	vertical-align: baseline
}

::-webkit-inner-spin-button,
::-webkit-outer-spin-button {
	height: auto
}

[type=search] {
	-webkit-appearance: textfield;
	outline-offset: -2px
}

::-webkit-search-decoration {
	-webkit-appearance: none
}

::-webkit-file-upload-button {
	-webkit-appearance: button;
	font: inherit
}

summary {
	display: list-item
}

blockquote,
dd,
dl,
figure,
h1,
h2,
h3,
h4,
h5,
h6,
hr,
p,
pre {
	margin: 0
}

fieldset {
	margin: 0;
	padding: 0
}

legend {
	padding: 0
}

menu,
ol,
ul {
	list-style: none;
	margin: 0;
	padding: 0
}

dialog {
	padding: 0
}

textarea {
	resize: vertical
}

input::placeholder,
textarea::placeholder {
	opacity: 1;
	color: #9ca3af
}

[role=button],
button {
	cursor: pointer
}

:disabled {
	cursor: default
}

audio,
canvas,
embed,
iframe,
img,
object,
svg,
video {
	display: block;
	vertical-align: middle
}

img,
video {
	max-width: 100%;
	height: auto
}

[hidden]:where(:not([hidden=until-found])) {
	display: none
}
```