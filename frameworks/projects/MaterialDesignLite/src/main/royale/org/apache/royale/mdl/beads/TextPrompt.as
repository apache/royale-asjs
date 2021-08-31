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
package org.apache.royale.mdl.beads
{
	COMPILE::SWF
	{
		import flash.text.TextFieldType;			
		
		import org.apache.royale.core.CSSTextField;
	}
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;

	import org.apache.royale.mdl.supportClasses.ITextField;
	import org.apache.royale.mdl.supportClasses.TextFieldBase;
	
	/**
	 *  The TextPrompt class is a specialty bead that can be used with
	 *  any MDL TextField control. The bead places a string into the input field
	 *  when there is no value associated with the text property.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class TextPrompt implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function TextPrompt()
		{
		}
		
		private var _prompt:String;
		
		/**
		 *  The string to use as the placeholder prompt.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get prompt():String
		{
			return _prompt;
		}
		public function set prompt(value:String):void
		{
			_prompt = value;
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 *  @royaleignorecoercion org.apache.royale.mdl.supportClasses.ITextField
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			//var model:Object = UIBase(_strand).model;
			// listen for changes in text to hide or show the prompt
			//if (!model.hasOwnProperty("text")) {
			//	throw new Error("Model requires a text property when used with TextPromptBead");
			//}
			(_strand as IEventDispatcher).addEventListener("textChange", handleTextChange);

			COMPILE::SWF
			{
				// create a TextField that displays the prompt - it shows
				// and hides based on the model's content
				promptField = new CSSTextField();
				promptField.selectable = false;
				promptField.type = TextFieldType.DYNAMIC;
				promptField.mouseEnabled = false;
				promptField.multiline = false;
				promptField.wordWrap = false;
				promptField.textColor = 0xBBBBBB;
				
				// trigger the event handler to display if needed
				handleTextChange(null);					
			}

			COMPILE::JS
			{
				mdlTi = value as ITextField;
                mdlTi.textNode.nodeValue = prompt;
			}
		}
		
		private var promptAdded:Boolean;
		
		COMPILE::JS
		private var mdlTi:ITextField;

		COMPILE::SWF
		private var promptField:CSSTextField;
		
		
		/**
		 *  see what the model currently has to determine if the prompt should be
		 *  displayed or not.
		 *  
		 *  @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  @royaleignorecoercion org.apache.royale.mdl.supportClasses.TextFieldBase
		 */
		private function handleTextChange( event:Event ):void
		{
			COMPILE::SWF
			{
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

			COMPILE::JS
			{
				var model:Object = (_strand as UIBase).model;
				
				if ((mdlTi as TextFieldBase).text != null && (mdlTi as TextFieldBase).text.length > 0 )
				{
					mdlTi.textNode.nodeValue = "";
				} 
				else 
				{
					mdlTi.textNode.nodeValue = prompt;
				}
				
			}
		}
	}
}
