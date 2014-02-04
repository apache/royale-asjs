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
package org.apache.flex.html.staticControls.accessories
{
	import flash.events.TextEvent;
	
	import org.apache.flex.core.CSSTextField;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.staticControls.beads.ITextFieldView;
	
	/**
	 *  The NumericOnlyTextInputBead class is a specialty bead that can be used with
	 *  any TextInput control. The bead prevents non-numeric entry into the text input
	 *  area.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class NumericOnlyTextInputBead implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function NumericOnlyTextInputBead()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 * @private
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			IEventDispatcher(value).addEventListener("viewChanged",viewChangeHandler);
		}
		
		private var _decimalSeparator:String = ".";
		
		/**
		 *  The character used to separate the integer and fraction parts of numbers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
		
		/**
		 * @private
		 */
		private function viewChangeHandler(event:Event):void
		{			
			// get the ITextFieldView bead, which is required for this bead to work
			var textView:ITextFieldView = _strand.getBeadByType(ITextFieldView) as ITextFieldView;
			if (textView) {
				var textField:CSSTextField = textView.textField;
				textField.restrict = "0-9" + decimalSeparator;
				
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
		private function handleTextInput(event:TextEvent):void
		{
			var insert:String = event.text;
			var caretIndex:int = (event.target as CSSTextField).caretIndex;
			var current:String = (event.target as CSSTextField).text;
			var value:String = current.substring(0,caretIndex) + insert + current.substr(caretIndex);
			var n:Number = Number(value);
			if (isNaN(n)) event.preventDefault();
		}
	}
}