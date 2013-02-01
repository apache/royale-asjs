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
	import flash.events.Event;
    import flash.events.IEventDispatcher;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.html.staticControls.beads.IListBead;

	public class ListSingleSelectionMouseController implements IBead
	{
		public function ListSingleSelectionMouseController()
		{
		}
		
		protected var listModel:ISelectionModel;
		protected var listView:IListBead;
		protected var dataGroup:IItemRendererParent;

		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			listModel = value.getBeadByType(ISelectionModel) as ISelectionModel;
			listView = value.getBeadByType(IListBead) as IListBead;
			dataGroup = listView.dataGroup;
            dataGroup.addEventListener("selected", selectedHandler, true);
		}
		
        private function selectedHandler(event:Event):void
        {
            listModel.selectedIndex = IItemRenderer(event.target).index;
            IEventDispatcher(listView.strand).dispatchEvent(new Event("change"));
        }
	
	}
}