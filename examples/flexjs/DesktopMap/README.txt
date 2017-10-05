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

This sample Royale application shows how you can integrate a 3rd party library, such as Google Maps, into the
world of Royale.

The ActionScript side is an AIR app that uses HTMLLoader to bring in the Google MAP JavaScript API. You could
also try to use an iFrame with a web application (there are examples of iFrame and Flex scattered around the web).

You can also cross-compile this sample into JavaScript. This is possible because there is a JavaScript version of the
ActionScript Map class. The JavaScript Map class loads the Google MAP API asynchronously and dispatches a "ready" 
event when the load and initialization of the API is complete.
    
You will need a Google API developer key. When you have it, replace --put your Google API dev token here-- with 
your developer token in the MyInitialView.mxml <basic:Map> tag.

COMPONENTS and BEADS

- Container
- DropDownList
- Label
- TextButton
- TextInput
