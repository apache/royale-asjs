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
	COMPILE::SWF
	{
		import org.apache.royale.core.CSSTextField;			
	}
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IRenderedObject;
	COMPILE::SWF
	{
		import org.apache.royale.html.beads.ITextFieldView;
	}
	
	/**
	 *  The PasswordInput class is a specialty bead that can be used with
	 *  any TextInput control. The bead secures the text input area by masking
	 *  the input as it is typed.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class PasswordInputBead extends Bead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function PasswordInputBead()
		{
		}
		/**
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 *  @royaleignorecoercion HTMLInputElement
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
				var host:IRenderedObject = value as IRenderedObject;
				var e:HTMLInputElement = host.element as HTMLInputElement;
				e.type = 'password';
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
				textField.displayAsPassword = true;
			}
			else {
				throw new Error("PasswordInputBead requires strand to have a TextInputView bead");
			}
		}
	}
}
