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
package org.apache.royale.jewel.beads.controls.textinput
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.supportClasses.textinput.TextInputBase;
	
	/**
	 *  The Restrict bead class is a specialty bead that can be used with
	 *  any Jewel TextInputBase control. The bead uses a reg exp pattern to validate
	 *  input from user. A text property allows to configure error text.
	 *  
	 *  pattern examples:
	 *  Numeric ony pattern = [^0-9]
	 *  Letters only pattern = [^a-zA-Z]
	 *  Numeric and letters only pattern = [^0-9a-zA-Z]
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class Restrict implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function Restrict()
		{
		}
		
		private var _pattern:String;
		/**
		 *  The string to use as numeric pattern.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get pattern():String
		{
			return _pattern;
		}
		public function set pattern(value:String):void
		{
			_pattern = value;
			updateTextToRestriction();
		}

		private var host:TextInputBase;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		public function set strand(value:IStrand):void
		{
			host = value as TextInputBase;
			host.addEventListener(Event.CHANGE, restrictTetToPattern);
			updateTextToRestriction();
		}

		/**
		 * Restrict the text to the reg exp pattern as user types
		 * @private
		 */
		protected function restrictTetToPattern(event:Event):void
		{
			COMPILE::JS
			{
			var start:Number = host.input.selectionStart;
			var end:Number = host.input.selectionEnd;
			var textChanged:Boolean = updateTextToRestriction();
			if(textChanged)
				host.input.setSelectionRange(start, end);
			else
				host.input.setSelectionRange(start - 1, end - 1);
			}
		}

		/**
		 * update the text in the input to the restriction pattern
		 * 
		 * @return true if text changed, false otherwise
		 */
		protected function updateTextToRestriction():Boolean
		{
			var textChanged:Boolean = false;
			if(!host) 
				return textChanged;
			const re:RegExp = new RegExp(pattern, 'g');
			COMPILE::JS
			{
			const oldText:String = host.input.value;
			host.input.value = host.input.value.replace(re, '');
			textChanged = oldText == host.input.value;
			}
			return textChanged;
		}
	}
}
