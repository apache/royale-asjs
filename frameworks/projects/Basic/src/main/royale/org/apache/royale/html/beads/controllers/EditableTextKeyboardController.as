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
package org.apache.royale.html.beads.controllers
{
	import org.apache.royale.core.CSSTextField;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ITextModel;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.html.beads.ITextFieldView;
	
	/**
	 *  The EditableTextKeyboardController class bead intercepts keyboard events on the
	 *  component's text field and emits change events.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class EditableTextKeyboardController implements IBead, IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function EditableTextKeyboardController()
		{
		}
		
		private var model:ITextModel;
		private var textField:CSSTextField;
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			model = UIBase(_strand).model as ITextModel;
			
			var viewBead:ITextFieldView = _strand.getBeadByType(ITextFieldView) as ITextFieldView;
			textField = viewBead.textField;
			textField.addEventListener("change", inputChangeHandler);
		}
		
		/**
		 * @private
		 */
		private function inputChangeHandler( event:Object ) : void
		{
            // this will otherwise bubble an event of flash.events.Event
            event.stopImmediatePropagation();
			model.text = textField.text;
		}
	}
}
