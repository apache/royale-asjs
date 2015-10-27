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
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IRollOverModel;
	import org.apache.flex.core.ISelectableItemRenderer;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.MouseEvent;
	import org.apache.flex.html.beads.IListView;
	

    /**
     *  The ListSingleSelectionMouseController class is a controller for
     *  org.apache.flex.html.List.  Controllers
     *  watch for events from the interactive portions of a View and
     *  update the data model or dispatch a semantic event.
     *  This controller watches for events from the item renderers
     *  and updates an ISelectionModel (which only supports single
     *  selection).  Other controller/model pairs would support
     *  various kinds of multiple selection.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class ListSingleSelectionMouseController implements IBeadController
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ListSingleSelectionMouseController()
		{
		}
		
        /**
         *  The model.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		protected var listModel:ISelectionModel;

        /**
         *  The view.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        protected var listView:IListView;

        /**
         *  The parent of the item renderers.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        protected var dataGroup:IItemRendererParent;

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
			listModel = value.getBeadByType(ISelectionModel) as ISelectionModel;
			listView = value.getBeadByType(IListView) as IListView;
			dataGroup = listView.dataGroup;
            dataGroup.addEventListener("selected", selectedHandler, true);
            IEventDispatcher(_strand).addEventListener(MouseEvent.ROLL_OVER, rolloverHandler);
//			dataGroup.addEventListener(MouseEvent.ROLL_OVER, rolloverHandler, true);
		}
		
        private function selectedHandler(event:Event):void
        {
            listModel.selectedIndex = ISelectableItemRenderer(event.target).index;
            listView.host.dispatchEvent(new Event("change"));
        }
		
        private function rolloverHandler(event:Event):void
        {
			var renderer:ISelectableItemRenderer = event.target as ISelectableItemRenderer;
			if (renderer) {
				//trace("ListSingleSelectionMouseController.ROLL_OVER");
				IRollOverModel(listModel).rollOverIndex = renderer.index;
			}
        }
	
	}
}
