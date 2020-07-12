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
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IComboBoxModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.TextInput;
	import org.apache.royale.html.List;
	import org.apache.royale.html.beads.IComboBoxView;
	import org.apache.royale.utils.sendStrandEvent;
	import org.apache.royale.core.Bead;
	
	public class ComboBoxController extends Bead implements IBeadController
	{
		public function ComboBoxController()
		{
		}
		
		protected var viewBead:IComboBoxView;
		
		/**
		 * @royaleignorecoercion org.apache.royale.html.beads.IComboBoxView
		 * 
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			
			viewBead = _strand.getBeadByType(IComboBoxView) as IComboBoxView;
			if (viewBead) {
				finishSetup(null);
			} else {
				listenOnStrand("viewChanged", finishSetup);
			}
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 * @royaleignorecoercion org.apache.royale.html.beads.IComboBoxView
		 */
		protected function finishSetup(event:Event):void
		{
			if (viewBead == null) {
				viewBead = _strand.getBeadByType(IComboBoxView) as IComboBoxView;
			}
			
			(viewBead.popupButton as IEventDispatcher).addEventListener("click", handleButtonClick);
			(viewBead.textInputField as IEventDispatcher).addEventListener("click", handleButtonClick);
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function handleButtonClick(event:MouseEvent):void
		{			
			viewBead.popUpVisible = !viewBead.popUpVisible;
			(viewBead.popUp as IEventDispatcher).addEventListener("change", handleListChange);
		}
		
		private function handleListChange(event:Event):void
		{
			viewBead.popUpVisible = false;
			
			sendStrandEvent(_strand,"change");
		}
	}
}
