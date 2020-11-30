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
package org.apache.royale.html.accessories
{
	COMPILE::JS
	{
		import goog.events.BrowserEvent;
	}
	COMPILE::SWF
	{
		import flash.events.TextEvent;
		import org.apache.royale.core.CSSTextField;			
		import org.apache.royale.html.beads.ITextFieldView;			
	}
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IRenderedObject;
	
	/**
	 *  The NumericOnlyTextInputBead class is a specialty bead that can be used with
	 *  any TextInput control. The bead prevents non-numeric entry into the text input
	 *  area.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class NumericOnlyTextInputBead extends Bead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function NumericOnlyTextInputBead()
		{
		}
				
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			
			COMPILE::SWF
			{
				IEventDispatcher(value).addEventListener("viewChanged",viewChangeHandler);					
			}
			COMPILE::JS
			{
				(_strand as IRenderedObject).element.addEventListener("keypress", validateInput, false);
			}
		}
		
		private var _decimalSeparator:String = ".";
		
		/**
		 *  The character used to separate the integer and fraction parts of numbers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get decimalSeparator():String
		{
			return _decimalSeparator;
		}
		public function set decimalSeparator(value:String):void
		{
			if (_decimalSeparator != value) {
				_decimalSeparator = value;
			}
		}
		
		private var _maxChars:int = 0;
		
		/**
		 *  The character used to separate the integer and fraction parts of numbers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get maxChars():int
		{
			return _maxChars;
		}
		public function set maxChars(value:int):void
		{
			if (_maxChars != value) {
				_maxChars = value;
			}
		}

		/**
		 * @private
		 */
		COMPILE::SWF
		private function viewChangeHandler(event:Event):void
		{			
			// get the ITextFieldView bead, which is required for this bead to work
			var textView:ITextFieldView = _strand.getBeadByType(ITextFieldView) as ITextFieldView;
			if (textView) {
				var textField:CSSTextField = textView.textField;
				textField.restrict = "0-9" + decimalSeparator;
				textField.maxChars = maxChars;
				// listen for changes to this textField and prevent non-numeric values, such
				// as 34.09.94
				textField.addEventListener(TextEvent.TEXT_INPUT, handleTextInput);
			}
			else {
				throw new Error("NumericOnlyTextInputBead requires strand to have an ITextFieldView bead");
			}
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		private function handleTextInput(event:TextEvent):void
		{
			var insert:String = event.text;
			var caretIndex:int = (event.target as CSSTextField).caretIndex;
			var current:String = (event.target as CSSTextField).text;
			var value:String = current.substring(0,caretIndex) + insert + current.substr(caretIndex);
			var n:Number = Number(value);
			if (isNaN(n)) event.preventDefault();
		}
		
		COMPILE::JS
		private function validateInput(event:BrowserEvent):void
		{
			var code:int = event.charCode;
			
			// backspace or delete
			if (event.keyCode == 8 || event.keyCode == 46) return;
			
			// tab or return/enter
			if (event.keyCode == 9 || event.keyCode == 13) return;
			
			// left or right cursor arrow
			if (event.keyCode == 37 || event.keyCode == 39) return;
			
			var key:String = String.fromCharCode(code);
			
			var regex:RegExp = /[0-9]|\./;
			if (!regex.test(key)) {
				event["returnValue"] = false;
				if (event.preventDefault) event.preventDefault();
				return;
			}
			var cursorStart:int = event.target.selectionStart;
			var cursorEnd:int = event.target.selectionEnd;
			var left:String = event.target.value.substring(0, cursorStart);
			var right:String = event.target.value.substr(cursorEnd);
			var complete:String = left + key + right;
			if (isNaN(parseFloat(complete))) {
				event["returnValue"] = false;
				if (event.preventDefault) event.preventDefault();
			}

		}
	}
}
