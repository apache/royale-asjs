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
package org.apache.royale.jewel.beads.models
{
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.beads.controls.TextAlign;
	
	/**
	 *  The FormItemModel bead class holds the values for a org.apache.royale.jewel.FormItem
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	[Bindable]
	public class FormItemModel extends TextModel
	{
        /**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function FormItemModel()
		{
			super();
		}

        private var _required:Boolean;

        [Bindable("requiredChange")]
        /**
		 *  If <code>true</code>, shows the
		 *  <code>required</code> label. By default, this displays 
		 *  an indicator that the FormItem children require user input.
		 *  If <code>false</code>, the indicator is not displayed.
		 *
		 *  This property controls indicator visibility only.
		 *  You must assign a validator to the child 
		 *  if you require input validation.
		 *
		 *  @default false
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get required():Boolean
		{
			return _required;
		}
		
        /**
         *  @private
         */
		public function set required(value:Boolean):void
		{
            if (value == null)
                value = "";
			if (value != _required)
			{
				_required = value;
				dispatchEvent(new Event("requiredChange"));
			}
		}

		private var _labelAlign:String = TextAlign.RIGHT;
		/**
		 *  How textLabel form item part will align.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get labelAlign():String
		{
			return _labelAlign;
		}

		public function set labelAlign(value:String):void
		{
			_labelAlign = value;
		}
    }
}