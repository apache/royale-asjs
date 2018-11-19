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

package mx.controls
{
COMPILE::JS
{
	import org.apache.royale.core.WrappedHTMLElement;
}
import mx.core.UIComponent;

import org.apache.royale.events.Event;
import org.apache.royale.html.beads.models.ArraySelectionModel;

/*
import mx.events.MoveEvent;
import mx.events.SandboxMouseEvent;
import mx.managers.IFocusManagerComponent;
import mx.styles.ISimpleStyleClient;


use namespace mx_internal;
*/

//--------------------------------------
//  Events
//--------------------------------------


/**
 *  Dispatched when a Tab is selected
 *
 *  @eventType flash.events.Event.CHANGE
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="change", type="org.apache.royale.events.Event")]



/**
 *  The TabBar control is a ButtonBar with buttons that
 *  look like Tabs.

 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class TabBar extends ToggleButtonBar
{
	
	public function TabBar()
	{
		super();
		typeNames = "TabBar";
	}
		
}

}
