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
	
	import org.apache.flex.core.IValueToggleButtonModel;
	import org.apache.flex.events.Event;

	/**
	 *  The ValueToggleButtonModel class bead extends the ToggleButtonModel and adds
	 *  value intended to represent a collection of similar Buttons such as RadioButtons.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ValueToggleButtonModel extends ToggleButtonModel implements IValueToggleButtonModel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ValueToggleButtonModel()
		{
			super();
		}
		
		private var _value:Object;
		
		/**
		 *  The current value of the button collection.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
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
		
		/**
		 *  The name of the collection has shared by all of the buttons in the collection.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
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
		
		private var _selectedValue:Object;
		
		/**
		 *  The value that is currently selected.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get selectedValue():Object
		{
			return _selectedValue;
		}
		
		public function set selectedValue(newValue:Object):void
		{
			if( _selectedValue != newValue )
			{
				_selectedValue = newValue;
				dispatchEvent(new Event("selectedValueChange"));
			}
		}
	}
}