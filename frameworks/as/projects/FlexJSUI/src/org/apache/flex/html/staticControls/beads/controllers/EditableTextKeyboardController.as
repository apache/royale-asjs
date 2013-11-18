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
	import org.apache.flex.core.CSSTextField;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ITextModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.html.staticControls.beads.ITextFieldView;
	
	public class EditableTextKeyboardController implements IBead, IBeadController
	{
		public function EditableTextKeyboardController()
		{
		}
		
		private var model:ITextModel;
		private var textField:CSSTextField;
		
		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			model = UIBase(_strand).model as ITextModel;
			
			var viewBead:ITextFieldView = _strand.getBeadByType(ITextFieldView) as ITextFieldView;
			textField = viewBead.textField;
			textField.addEventListener("change", inputChangeHandler);
		}
		
		private function inputChangeHandler( event:Object ) : void
		{
			model.text = textField.text;
		}
	}
}