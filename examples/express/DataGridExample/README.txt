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

The DataGridExample in the Express project demonstrates the Royale DataGrid with
the addition of beads that provide drag-and-drop support. 

This Royale application may be run as a Flash SWF or cross-compiled (using the Royale Compiler)
into JavaScript and HTML and run without Flash.

The data for the DataGrid is found in the application's model and is connected
using a ConstantBinding bead which ties a property of a model to a property
in a component, in this case, the DataGrid's dataProvider property.
