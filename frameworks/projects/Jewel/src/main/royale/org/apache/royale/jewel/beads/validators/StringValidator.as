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
	COMPILE::JS
	{
	import goog.events.BrowserEvent;

	import org.apache.royale.utils.OSUtils;
	}
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.supportClasses.textinput.TextInputBase;
	import org.apache.royale.utils.StringUtil;

	/**
	 *  The StringValidator class is a specialty bead that can be used with
	 *  TextInput control.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class StringValidator extends Validator implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function StringValidator()
		{
			super();
		}


		/**                         	
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			COMPILE::JS
			{
				updateHost();
			}
		}

		private var _autoTrim:Boolean;

		public function get autoTrim():Boolean
		{
			return _autoTrim;
		}
		/**
		 *  Auto trim the entered text before validation
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function set autoTrim(value:Boolean):void
		{
			_autoTrim = value;
		}

		private var _maxLength:int;

		public function get maxLength():int
		{
			return _maxLength;
		}
		/**
		 *  Maximum length for a valid String.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function set maxLength(value:int):void
		{
			_maxLength = value;
			COMPILE::JS
			{
			updateHost();
			}	
		}

		COMPILE::JS
		/**
		 * solves Android issue where you can enter more characters than maxlenght in the input
		 */
		private function forceMaxLength(event:BrowserEvent):void {
			var input:HTMLInputElement = hostComponent.element as HTMLInputElement;
			if(input.value.length > _maxLength) {
				input.value = input.value.substring(0, _maxLength);
			}
		}

		/**
		 *  Override of the base class validate() method to validate a String.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		override public function validate(event:Event = null):Boolean {
			var txt:TextInputBase = hostComponent as TextInputBase;
			var str:String = txt.text;

			if (autoTrim) {
				str = StringUtil.trim(str);
				if (str != txt.text) txt.text = str;
			}

			if (super.validate(event)) {
				if (str.length < required) {
					createErrorTip(requiredFieldError);
				} else {
					destroyErrorTip();
				}	
			}
			return !isError;
		}

		COMPILE::JS
		private function updateHost():void
		{
			if (hostComponent)
            {
                if(maxLength > 0)
				{
					hostComponent.element.setAttribute('maxlength', maxLength);
				} else
				{
					hostComponent.element.removeAttribute('maxlength');
				}

				if(OSUtils.getOS() == OSUtils.ANDROID_OS)
				{
					if(maxLength > 0)
					{
						//solves Android issue where you can enter more characters than maxlenght in the input
						hostComponent.element.addEventListener("keyup", forceMaxLength, false);
					} else
					{
						hostComponent.element.removeEventListener("keyup", forceMaxLength, false);
					}
				}
            }
		}		
	}
}
