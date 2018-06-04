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

Using the Jewel Alert Control

The following code shows the basic method for displaying an Alert dialog in a Royale application. It uses the new Jewel UI set that supports themes that will be available in the forthcoming 0.9.3 release. In the meanwhile you can find it in the develop branch.

In this example, the Jewel button adds a click handler that will be in charge of showing the Alert control. When the user clicks the button the Alert.show() static method is called. You can add a custom message, a custom title and choose which buttons will be created for that instance of the Alert.
Finally, the Alert instance adds an event listener to manage the alert response when the dialog is closed. In this example we’re changing the label of the button according to the button the user clicks in the Alert.

http://royale.apache.org/using-jewel-alert-control/

