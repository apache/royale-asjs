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

DESCRIPTION

The FlexJSTest_SVG example shows how to use SVG to skin components when run in
the HTML/JavaScript environment.

This Flex application may be run as a Flash SWF or cross-compiled (using Falcon JX)
into JavaScript and HTML and run without Flash.

The FlexJSTest_SVG application may be run in ActionScript, which uses standard Flash
drawing to produce the button skin. When run in JavaScript however, SVG is used to
make the skin.

To make the skin, a new classification of TextButton was created in the 
org.apache.flex.svg package. On the ActionScript side, the svg.TextButton simply
extends the normal TextButton. On the JavaScript side, the svg.TextButton class
uses an SVG file (svg.assets.TextButton_skin.svg).

COMPONENTS and BEADS

- Label
- TextButton

NOTES

Maybe a more standard or common way or place to specify skins could be developed so
specialized packages would not always be needed.
