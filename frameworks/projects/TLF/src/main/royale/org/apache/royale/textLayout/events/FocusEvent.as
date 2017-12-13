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
package org.apache.royale.textLayout.events {

import org.apache.royale.events.Event;

	public class FocusEvent extends Event
	{

		public function FocusEvent(type:String)
		{
			super(type);
		}
		
		public static const FOCUS_IN:String = "focusIn";
		public static const FOCUS_OUT:String = "focusOut";
		public static const KEY_FOCUS_CHANGE:String = "keyFocusChange";
		public static const MOUSE_FOCUS_CHANGE:String = "mouseFocusChange";
	}
}
