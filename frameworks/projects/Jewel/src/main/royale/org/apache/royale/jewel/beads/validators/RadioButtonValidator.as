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
package org.apache.royale.jewel.beads.validators
{
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.RadioButton;

	/**
	 *  The RadioButtonValidator class is a specialty bead that can be used with
	 *  Group control.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class RadioButtonValidator extends Validator
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function RadioButtonValidator()
		{
			super();
		}

		private var _groupName:String;

		public function get groupName():String
		{
			return _groupName;
		}
		/**
		 * 	Specifies the radio button group to be validated.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function set groupName(value:String):void
		{
			_groupName = value;
		}

		/**
		 *  Override of the base class validate() method to validate if selected.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		override public function validate(event:Event = null):Boolean {
			if (super.validate(event)) {
				var selectedCount:int = 0;
				var i:int = hostComponent.numElements;
				while(--i > -1) {
					var rb:RadioButton = hostComponent.getElementAt(i) as RadioButton;
					if (!rb) continue;
					if (groupName && rb.groupName != groupName) continue;
					if (rb.selected) {
						selectedCount++;
						break;
					}
				}
				if (selectedCount < 1) {
					createErrorTip(requiredFieldError);
				} else {
					destroyErrorTip();
				}	
			}
			return !isError;
		}		
	}
}
