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

The DataBindingTest example shows a Royale application that can communicate with
a third-party data source (in this case, yahoo.finance) and display the values
returned using data binding. 

This Royale application may be run as a Flash SWF or cross-compiled (using the Royale Compiler)
into JavaScript and HTML and run without Flash.

The DataBindingTest example also shows how the model-view-controller (MVC) pattern
can be used to separate the parts of the application. This is facilitated by
the use of Royale beads added to the main application that provide the
data connection (via HTTPService) and interacting with the rest of the application
via events.

COMPONENTS and BEADS

- Button
- CheckBox
- ComboBox
- Container
- Label
- RadioButton
- TextArea
- TextInput

- Data binding: the text properties of TextArea and Label are linked with results
from the remote server calls.

NOTES

The cross-compilation to JavaScript often results in non-fatal warnings. Some of these warnings
should be addressed in future releases of the the Royale Compiler compiler.
