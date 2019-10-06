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
package org.apache.royale.jewel.beads.controls.datefield
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
	import org.apache.royale.core.IFormatter;
	
	/**
	 *  The DateFieldMaskedTextInput class is a specialty bead that is used
     *  by DateField control. The bead mask the input of the user to conform
	 *  to numbers and slashes in the following pattern: 'NN/NN/NNNN'
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class DateFieldMaskedTextInput implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function DateFieldMaskedTextInput()
		{
		}
		
		private var _strand:IStrand;
		
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
			_strand = value;
			
			COMPILE::SWF
			{
				IEventDispatcher(value).addEventListener("viewChanged",viewChangeHandler);					
			}
			COMPILE::JS
			{
                var host:UIBase = _strand as UIBase;
                host.element.addEventListener("keyup", dateInputMask, false);
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
				textField.restrict = "0-9";
				// listen for changes to this textField and prevent non-numeric values
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

		private var _formatter:IFormatter;

		public function get formatter():IFormatter
		{
			return _formatter;
		}

		public function set formatter(value:IFormatter):void
		{
			_formatter = value;
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

		COMPILE::JS
		/**
		 * (TODO carlosrovira): this should take into account IFormatter
		 */
		private function dateInputMask(event:BrowserEvent):void {
			event.target.value = formatter.format(event.target.value);
		}
	}
}
