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

The DataBindingTestbed shows a Flex application that is simply a test application
for a range of Databinding variations. Its primary purpose is to demonstrate to the
development team examples of bindings that do not currently work or do not work well,
as well as what currently works, and therefore serves to demonstrate what areas
require attention for improvements or bugfixes.

This Flex application may be run as a Flash SWF or cross-compiled (using Falcon JX)
into JavaScript and HTML and run without Flash.

The DataBindingTestbed is primarily for development purposes, but also shows 
simple examples of a range of binding types that might be useful as examples for
FlexJS developers to see how things work (or what currently does not work).
The examples in the code that are commented out are very likely things that need
attention or fixes. If you encounter any bugs in binding that are not currently
represented in this example, please contact the dev team via the mailing list 
   web view : https://lists.apache.org/list.html?dev@flex.apache.org
  subscribe : dev-subscribe@flex.apache.org
participate : dev@flex.apache.org


COMPONENTS and BEADS

- Container
- Label


NOTES

The cross-compilation to JavaScript often results in non-fatal warnings. Some of these warnings
should be addressed in future releases of the Falcon JX compiler.
