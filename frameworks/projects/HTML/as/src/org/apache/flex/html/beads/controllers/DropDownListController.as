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
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
    import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.IDropDownListView;

    /**
     *  The DropDownListController class is the controller for
     *  org.apache.flex.html.DropDownList.  Controllers
     *  watch for events from the interactive portions of a View and
     *  update the data model or dispatch a semantic event.
     *  This controller watches for the click event and displays the
     *  dropdown/popup, and watches the dropdown/popup for change events
     *  and updates the selection model accordingly.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class DropDownListController implements IBead, IBeadController
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function DropDownListController()
		{
		}
		
		private var _strand:IStrand;
		
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
            IEventDispatcher(value).addEventListener("click", clickHandler);
		}
		
        private function clickHandler(event:Event):void
        {
            var viewBead:IDropDownListView = _strand.getBeadByType(IDropDownListView) as IDropDownListView;
            var selectionModel:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
            var popUpModel:ISelectionModel = UIBase(viewBead.popUp).model as ISelectionModel;
            DisplayObject(viewBead.popUp).width = DisplayObject(_strand).width;
            popUpModel.dataProvider = selectionModel.dataProvider;
            viewBead.popUpVisible = true; // adds to display list as well
            popUpModel.selectedIndex = selectionModel.selectedIndex;
            var pt:Point = new Point(DisplayObject(_strand).x, DisplayObject(_strand).y + DisplayObject(_strand).height);
            pt = DisplayObject(_strand).parent.localToGlobal(pt);
			DisplayObject(viewBead.popUp).x = pt.x;
			DisplayObject(viewBead.popUp).y = pt.y;
            IEventDispatcher(viewBead.popUp).addEventListener("change", changeHandler);
        }
        
        private function changeHandler(event:Event):void
        {
            var viewBead:IDropDownListView = _strand.getBeadByType(IDropDownListView) as IDropDownListView;
            viewBead.popUpVisible = false;
            var selectionModel:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
            var popUpModel:ISelectionModel = UIBase(viewBead.popUp).model as ISelectionModel;
            selectionModel.selectedIndex = popUpModel.selectedIndex;
			IEventDispatcher(_strand).dispatchEvent(new Event("change"));
        }
	
	}
}
