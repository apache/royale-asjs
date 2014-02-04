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
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.staticControls.beads.IComboBoxView;

	/**
	 *  The ComboBoxController class bead handles mouse events on the elements of
	 *  the ComboBox. This includes selecting the button to display the selection list
	 *  pop-up as well as selecting an item from the pop-up list.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ComboBoxController implements IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ComboBoxController()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 * @private
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
            IEventDispatcher(value).addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 * @private
		 */
        private function clickHandler(event:MouseEvent):void
        {
            var viewBead:IComboBoxView = _strand.getBeadByType(IComboBoxView) as IComboBoxView;
            viewBead.popUpVisible = true;
            var selectionModel:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
            var popUpModel:ISelectionModel = viewBead.popUp.getBeadByType(ISelectionModel) as ISelectionModel;
            popUpModel.dataProvider = selectionModel.dataProvider;
            popUpModel.selectedIndex = selectionModel.selectedIndex;
			DisplayObject(viewBead.popUp).width = DisplayObject(_strand).width;
			DisplayObject(viewBead.popUp).height = 200;
			DisplayObject(viewBead.popUp).x = DisplayObject(_strand).x;
			DisplayObject(viewBead.popUp).y = DisplayObject(_strand).y;
            IEventDispatcher(viewBead.popUp).addEventListener("change", changeHandler);
        }
        
		/**
		 * @private
		 */
        private function changeHandler(event:Event):void
        {
            var viewBead:IComboBoxView = _strand.getBeadByType(IComboBoxView) as IComboBoxView;
            viewBead.popUpVisible = false;
            var selectionModel:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
            var popUpModel:ISelectionModel = viewBead.popUp.getBeadByType(ISelectionModel) as ISelectionModel;
            selectionModel.selectedIndex = popUpModel.selectedIndex;
			IEventDispatcher(_strand).dispatchEvent(new Event("change"));
        }
	
	}
}