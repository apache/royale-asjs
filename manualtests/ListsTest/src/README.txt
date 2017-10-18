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

The ListsTests example demonstrates the Royale List component using custom data
and a custom itemRenderer. 

This Flex application may be run as a Flash SWF or cross-compiled (using Falcon JX)
into JavaScript and HTML and run without Flash.

The data for the list is found in the application model and is bound to the list
via ConstantBinding bead which maps the application data model's products property
to the List's dataProvider property.

The display of each element of the list is through a custom itemRenderer, 
ProductItemRenderer, which can found in the example's source tree. The itemRenderer
uses and Image component to display an image and a Label to give a title.

COMPONENTS and BEADS

- Image
- Label
- List

- ConstantBinding

NOTES

More control of the itemRenderer via styles would be a nice addition. ItemRenderers
based on row or data would require a custom itemRendererFactory bead.
