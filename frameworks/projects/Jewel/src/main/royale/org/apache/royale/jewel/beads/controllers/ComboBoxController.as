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
package org.apache.royale.jewel.beads.controllers
{
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.jewel.TextInput;
	import org.apache.royale.jewel.List;
	import org.apache.royale.jewel.beads.controls.combobox.IComboBoxView;
	import org.apache.royale.jewel.supportClasses.util.callLater;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	
	/**
	 *  The ComboBoxController class is responsible for listening to
	 *  mouse event related to ComboBox. Events such as selecting a item
	 *  or changing the sectedItem.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class ComboBoxController implements IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function ComboBoxController()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			viewBead = _strand.getBeadByType(IComboBoxView) as IComboBoxView;
			if (viewBead) {
				finishSetup();
			} else {
				IEventDispatcher(_strand).addEventListener("viewChanged", finishSetup);
			}
		}

		protected var viewBead:IComboBoxView;
		
		protected function finishSetup(event:Event = null):void
		{
			IEventDispatcher(viewBead.button).addEventListener(MouseEvent.CLICK, handleButtonClick);
            IEventDispatcher(viewBead.textinput).addEventListener(MouseEvent.CLICK, handleButtonClick);
		}

		protected function handleControlMouseDown(event:MouseEvent):void
		{			
			event.stopImmediatePropagation();
		}
		
		protected function prepareVisiblePopUp():void
		{
			IEventDispatcher(viewBead.popup).addEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			IEventDispatcher(_strand).addEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			callLater(callLaterCallBack);
		}

		private function callLaterCallBack():void {
			IUIBase(viewBead.popup).topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_DOWN, handleTopMostEventDispatcherMouseDown);
		}
		
		protected function handleTopMostEventDispatcherMouseDown(event:MouseEvent):void
		{
			viewBead.popUpVisible = false;
		}
		
		protected function prepareHiddenPopUp():void
		{
			IEventDispatcher(viewBead.popup).removeEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			IEventDispatcher(_strand).removeEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			IUIBase(viewBead.popup).topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, handleTopMostEventDispatcherMouseDown);
		}
		
		protected function handleButtonClick(event:MouseEvent):void
		{
			if(viewBead.popup != null)
			{
				IEventDispatcher(viewBead.popup).removeEventListener(Event.CHANGE, handleListChange);
			}
			viewBead.popUpVisible = !viewBead.popUpVisible;

			if(viewBead.popUpVisible)
			{
				prepareVisiblePopUp();
			} else
			{
				prepareHiddenPopUp();
			}

			if(viewBead.popup != null)
			{
				IEventDispatcher(viewBead.popup).addEventListener(Event.CHANGE, handleListChange);
			}
		}
		
		private function handleListChange(event:Event):void
		{
			if(viewBead.popUpVisible)
				viewBead.popUpVisible = false;
			
			IEventDispatcher(_strand).dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
