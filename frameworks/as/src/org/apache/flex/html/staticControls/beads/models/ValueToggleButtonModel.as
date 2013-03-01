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
package org.apache.flex.html.staticControls.beads.models
{
	import flash.events.Event;
	
	import org.apache.flex.core.IValueToggleButtonModel;

	public class ValueToggleButtonModel extends ToggleButtonModel implements IValueToggleButtonModel
	{
		public function ValueToggleButtonModel()
		{
			super();
		}
		
		private var _value:Object;
		
		public function get value():Object
		{
			return _value;
		}
		
		public function set value(newValue:Object):void
		{
			if( newValue != _value )
			{
				_value = newValue;
				dispatchEvent(new Event("valueChange"));
			}
		}
		
		private var _groupName:String;
		
		public function get groupName():String
		{
			return _groupName;
		}
		
		public function set groupName(value:String):void
		{
			if( value != _groupName )
			{
				_groupName = value;
				dispatchEvent(new Event("groupNameChange"));
			}
		}
	}
}