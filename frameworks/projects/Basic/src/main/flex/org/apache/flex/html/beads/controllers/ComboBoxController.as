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
package org.apache.flex.html.beads.controllers
{
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.IComboBoxModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.MouseEvent;
	import org.apache.flex.html.TextInput;
	import org.apache.flex.html.List;
	import org.apache.flex.html.beads.IComboBoxView;
	
	public class ComboBoxController implements IBeadController
	{
		public function ComboBoxController()
		{
		}
		
		private var _strand:IStrand;
		
		private var viewBead:IComboBoxView;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			viewBead = _strand.getBeadByType(IComboBoxView) as IComboBoxView;
			if (viewBead) {
				finishSetup(null);
			} else {
				IEventDispatcher(_strand).addEventListener("viewChanged", finishSetup);
			}
		}
		
		private function finishSetup(event:Event):void
		{
			if (viewBead == null) {
				viewBead = _strand.getBeadByType(IComboBoxView) as IComboBoxView;
			}
			
			IEventDispatcher(viewBead.popupButton).addEventListener("click", handleButtonClick);
			IEventDispatcher(viewBead.popUp).addEventListener("change", handleListChange);
		}
		
		private function handleButtonClick(event:MouseEvent):void
		{			
			viewBead.popUpVisible = !viewBead.popUpVisible;
		}
		
		private function handleListChange(event:Event):void
		{
			var list:List = viewBead.popUp as List;
			var input:TextInput = viewBead.textInputField as TextInput;
			input.text = list.selectedItem as String;
			
			viewBead.popUpVisible = false;
			
			IEventDispatcher(_strand).dispatchEvent(new Event("change"));
		}
	}
}
