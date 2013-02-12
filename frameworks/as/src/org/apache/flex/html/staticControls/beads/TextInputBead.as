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
package org.apache.flex.html.staticControls.beads
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.text.TextFieldType;
	
	import org.apache.flex.core.IStrand;
	
	public class TextInputBead extends TextFieldBeadBase
	{
		public function TextInputBead()
		{
			super();
			
			textField.selectable = true;
			textField.type = TextFieldType.INPUT;
			textField.mouseEnabled = true;
			textField.multiline = false;
			textField.wordWrap = false;
		}
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			// Default size
			var ww:Number = DisplayObject(strand).width;
			if( isNaN(ww) || ww == 0 ) DisplayObject(strand).width = 100;
			var hh:Number = DisplayObject(strand).height;
			if( isNaN(hh) || hh == 0 ) DisplayObject(strand).height = 18;
			
			// for input, listen for changes to the _textField and update
			// the model
			textField.addEventListener(Event.CHANGE, inputChangeHandler);
			
			IEventDispatcher(strand).addEventListener("widthChanged", sizeChangedHandler);
			IEventDispatcher(strand).addEventListener("heightChanged", sizeChangedHandler);
			sizeChangedHandler(null);
		}
		
		private function inputChangeHandler(event:Event):void
		{
			textModel.text = textField.text;
		}
		
		private function sizeChangedHandler(event:Event):void
		{
			var ww:Number = DisplayObject(strand).width;
			if( !isNaN(ww) && ww > 0 ) textField.width = ww;
			
			var hh:Number = DisplayObject(strand).height;
			if( !isNaN(hh) && hh > 0 ) textField.height = hh;
		}
	}
}