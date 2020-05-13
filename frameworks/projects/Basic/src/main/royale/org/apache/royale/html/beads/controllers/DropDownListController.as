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
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.beads.IDropDownListView;
	import org.apache.royale.utils.sendStrandEvent;

    /**
     *  The DropDownListController class is the controller for
     *  org.apache.royale.html.DropDownList.  Controllers
     *  watch for events from the interactive portions of a View and
     *  update the data model or dispatch a semantic event.
     *  This controller watches for the click event and displays the
     *  dropdown/popup, and watches the dropdown/popup for change events
     *  and updates the selection model accordingly.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class DropDownListController implements IBead, IBeadController
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DropDownListController()
		{
		}
		
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
            IEventDispatcher(value).addEventListener(org.apache.royale.events.MouseEvent.CLICK, clickHandler);
		}
		
        private function clickHandler(event:org.apache.royale.events.MouseEvent):void
        {
            var viewBead:IDropDownListView = _strand.getBeadByType(IDropDownListView) as IDropDownListView;
            var selectionModel:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
            var popUpModel:ISelectionModel = UIBase(viewBead.popUp).model as ISelectionModel;
            DisplayObject(viewBead.popUp).width = DisplayObject(_strand).width;
            popUpModel.dataProvider = selectionModel.dataProvider;
            popUpModel.labelField = selectionModel.labelField;
            viewBead.popUpVisible = true; // adds to display list as well
            popUpModel.selectedIndex = selectionModel.selectedIndex;
            var pt:Point = new Point(DisplayObject(_strand).x, DisplayObject(_strand).y + DisplayObject(_strand).height);
            pt = DisplayObject(_strand).parent.localToGlobal(pt);
			DisplayObject(viewBead.popUp).x = pt.x;
			DisplayObject(viewBead.popUp).y = pt.y;
            IEventDispatcher(viewBead.popUp).addEventListener("change", changeHandler);
            IUIBase(_strand).topMostEventDispatcher.addEventListener(org.apache.royale.events.MouseEvent.CLICK, dismissHandler);
        }
        
        private function dismissHandler(event:org.apache.royale.events.MouseEvent):void
        {
            if (event.target == _strand) return;
            
            IUIBase(_strand).topMostEventDispatcher.removeEventListener(org.apache.royale.events.MouseEvent.CLICK, dismissHandler);
            var viewBead:IDropDownListView = _strand.getBeadByType(IDropDownListView) as IDropDownListView;
            viewBead.popUpVisible = false;
        }
        
        private function changeHandler(event:Event):void
        {
            var viewBead:IDropDownListView = _strand.getBeadByType(IDropDownListView) as IDropDownListView;
            viewBead.popUpVisible = false;
            var selectionModel:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
            var popUpModel:ISelectionModel = UIBase(viewBead.popUp).model as ISelectionModel;
            selectionModel.selectedIndex = popUpModel.selectedIndex;
			sendStrandEvent(_strand,"change");
        }
	
	}
}
