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

The FlexJSTest_Panel application demonstrates some FlexJS common components,
incuding Panel. The application uses a Panel to contain a sub-set of FlexJS
components, listed below.

This Flex application may be run as a Flash SWF or cross-compiled (using Falcon JX)
into JavaScript and HTML and run without Flash.

COMPONENTS and BEADS

- Label
- NumericStepper
- Panel
- Slider
- TextButton

- NonVirtualVerticalLayout

NOTES

Changing the Slider updates a Label. Changing the NumericStepper changes another Label.

The ActionScript version has some layout issues, chiefly the Panel background is not being
displayed. The JavaScript version is not updating the Labels when either the Slider or
NumericStepper is changed.
