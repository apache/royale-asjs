////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

## DESCRIPTION

Tour De Style is a Component Explorer for the Apache Royale Style UI Set.

Style is a CSS-driven UI component set that uses DaisyUI/Tailwind-inspired
design tokens and applies them through ActionScript skin classes.

This example showcases all Style components with different variants and
configurations.

## BUILDING

### Prerequisites

The Style library SWC must be built before compiling this example. From the
SDK root:

    cd frameworks/js/projects/StyleJS
    ant

### Build All Components (Tour)

To build the combined application with tabbed navigation across all components:

    cd examples/royale/TourDeStyle
    ant

### Build a Single Component

Each component has a standalone PlayGround application that can be compiled
individually:

    ant -Dexample=PaginationPlayGround
    ant -Dexample=CardPlayGround
    ant -Dexample=ModalPlayGround
    ant -Dexample=TabsPlayGround
    ant -Dexample=TogglePlayGround
    ant -Dexample=DropdownPlayGround
    ant -Dexample=NavbarPlayGround

### Debug-Only Build (faster)

To skip the JS release/Closure Compiler step and build only the debug output,
use the `debug` target with any example:

    ant debug -Dexample=NavbarPlayGround
    ant debug -Dexample=CardPlayGround
    ant debug                              # builds TourDeStyle

This is significantly faster during development and produces
`bin/js-debug/index.html` ready for browser testing.

### Viewing

After building, open `bin/js-debug/index.html` in a browser.

## COMPONENTS

| PlayGround             | Description                                      |
|------------------------|--------------------------------------------------|
| PaginationPlayGround   | Pagination with prev/next, disabled items         |
| CardPlayGround         | Card with shadow, border, and dash variants       |
| ModalPlayGround        | Modal dialogs with actions and easy dismiss       |
| TabsPlayGround         | TabBar with content switching, disabled tabs      |
| TogglePlayGround       | Toggle switches, checked and disabled states      |
| DropdownPlayGround     | Dropdowns with programmatic and disabled states   |
| NavbarPlayGround       | Navbar with start/center/end slot layout           |
