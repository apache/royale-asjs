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
		import org.apache.royale.html.beads.ITextFieldView;			
		import org.apache.royale.core.CSSTextField;			
	}
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IRenderedObject;
	
	/**
	 *  The RestrictTextInputBead class is a specialty bead that can be used with
	 *  any TextInput control. The bead prevents certain characters from being 
     *  entered into the text input
	 *  area.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class RestrictTextInputBead extends Bead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function RestrictTextInputBead()
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
				var host:IRenderedObject = _strand as IRenderedObject;
				host.element.addEventListener("keypress", validateKeypress, false);
				host.element.addEventListener("input", validateInput, false);
			}
		}
		
		private var _restrict:String;
		
		/**
		 *  The characters allowed or denied.  Uses flash.text.TextField.restrict syntax
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get restrict():String
		{
			return _restrict;
		}
		public function set restrict(value:String):void
		{
			if (_restrict != value) {
				_restrict = value;
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
				textField.restrict = restrict;
			}
			else {
				// throw new Error("RestrictTextInputBead requires strand to have an ITextFieldView bead");
			}
		}
				
		COMPILE::JS
		private function validateKeypress(event:BrowserEvent):void
		{
			var code:int = event.charCode;
			
			var key:String = String.fromCharCode(code);
			
			if (restrict)
			{
				var regex:RegExp = new RegExp("[" + restrict + "]");
				if (!regex.test(key)) {
					event["returnValue"] = false;
					if (event.preventDefault) event.preventDefault();
					return;
				}
			}
		}
        
		/**
		 *  @royaleignorecoercion HTMLInputElement 
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */
		COMPILE::JS
		private function validateInput(event:BrowserEvent):void
		{            
			var host:IRenderedObject = _strand as IRenderedObject;
			var data:String = (host.element as HTMLInputElement).value;
			
			if (restrict && data != null && data.length > 0)
			{
				var regex:RegExp = new RegExp("[" + restrict + "]");
				var out:String = "";
				var n:int = data.length;
				var blocked:Boolean = false;
				for (var i:int = 0; i < n; i++)
				{
					var key:String = data.charAt(i);
					if (regex.test(key)) {
						out += key;
					}
					else
						blocked = true;
				}
				if (blocked) 
				{
					event["returnValue"] = false;
					if (event.preventDefault) event.preventDefault();
					(host.element as HTMLInputElement).value = out;                    
				}
			}
		}
	}
}
