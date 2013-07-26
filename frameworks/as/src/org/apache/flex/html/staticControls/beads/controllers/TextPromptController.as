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
package org.apache.flex.html.staticControls.beads.controllers
{
	import flash.text.TextFieldType;
	
	import org.apache.flex.core.CSSTextField;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	public class TextPromptController implements IBead
	{
		public function TextPromptController()
		{
		}
		
		private var _prompt:String;
		public function get prompt():String
		{
			return _prompt;
		}
		public function set prompt(value:String):void
		{
			_prompt = value;
		}
		
		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			// listen for changes in text to hide or show the prompt
			var model:Object = UIBase(_strand).model;
			if (!model.hasOwnProperty("text")) {
				throw new Error("Model requires a text property when used with TextPromptController");
			}
			IEventDispatcher(model).addEventListener("textChange",handleTextChange);
			
			// create a TextField that displays the prompt - it shows
			// and hides based on the model's content
			promptField = new CSSTextField();
			promptField.selectable = false;
			promptField.type = TextFieldType.DYNAMIC;
			promptField.mouseEnabled = false;
			promptField.multiline = false;
			promptField.wordWrap = false;
			
			// trigger the event handler to display if needed
			handleTextChange(null);
		}
		
		private var promptField:CSSTextField;
		private var promptAdded:Boolean;
		
		private function handleTextChange( event:Event ):void
		{	
			// see what the model currently has to determine if the prompt should be
			// displayed or not.
			var model:Object = UIBase(_strand).model;
			
			if (model.text != null && model.text.length > 0 ) {
				if (promptAdded) UIBase(_strand).removeChild(promptField);
				promptAdded = false;
			}
			else {
				if (!promptAdded) UIBase(_strand).addChild(promptField);
				promptField.text = prompt;
				promptAdded = true;
			}
		}
	}
}