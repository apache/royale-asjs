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
package mx.controls.beads.controllers
{

	import mx.controls.beads.IComboBoxView;

	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.beads.controllers.ComboBoxController;
	import org.apache.royale.utils.sendStrandEvent;


public class ComboBoxController extends org.apache.royale.html.beads.controllers.ComboBoxController
	{
		public function ComboBoxController()
		{
		}

		public function get mxViewBead():IComboBoxView{
			return viewBead as IComboBoxView;
		}

		override protected function finishSetup(event:Event):void{
			super.finishSetup(event);
			viewBead.textInputField.addEventListener('change', handleInputChange)
		}

		protected function handleInputChange(event:Event):void{
			event.stopPropagation();
			sendStrandEvent(_strand,"change");
		}

		public var noPopup:Boolean;
		override protected function handleButtonClick(event:MouseEvent):void{
			if (event.target == viewBead.textInputField && mxViewBead.editable) {
				//ignore click events on the text input if it is editable
				return;
			}
			if (noPopup) return;
			super.handleButtonClick(event);
		}
		
		override protected function handleListChange(event:Event):void
		{
			viewBead.popUpVisible = false;
			//unlike the super class do not send a change event (it is already handled in the emulation ComboBox code)
			//sendStrandEvent(_strand,"change");
		}
	}
}
