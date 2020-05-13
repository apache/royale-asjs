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
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.controllers.ListSingleSelectionMouseController;
	import org.apache.royale.jewel.beads.models.IJewelSelectionModel;

    /**
     *  The Jewel ListSingleSelectionMouseController class is a controller for
     *  org.apache.royale.jewel.List.
     * 
     *  Controllers watch for events from the interactive portions of a View and
     *  update the data model or dispatch a semantic event.
     *  This controller watches for events from the item renderers
     *  and updates an ISelectionModel (which only supports single
     *  selection).  Other controller/model pairs would support
     *  various kinds of multiple selection.
     * 
     *  Jewel controller takes into account if the component
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class ListSingleSelectionMouseController extends org.apache.royale.html.beads.controllers.ListSingleSelectionMouseController
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function ListSingleSelectionMouseController()
		{
		}

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 *  @royaleignorecoercion org.apache.royale.jewel.beads.models.IJewelSelectionModel
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         *  @royaleignorecoercion org.apache.royale.core.IListView
         */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

            //if the list is composed as part of another component, with a shared model (e.g. ComboBox) then it should not be the primary dispatcher
			if (listModel is IJewelSelectionModel && !(IJewelSelectionModel(listModel).hasDispatcher)) {
                 IJewelSelectionModel(listModel).dispatcher = IEventDispatcher(value);
			}
            else {
				IEventDispatcher(listModel).addEventListener('rollOverIndexChanged', modelChangeHandler);
				IEventDispatcher(listModel).addEventListener('selectionChanged', modelChangeHandler);
                IEventDispatcher(listModel).addEventListener('dataProviderChanged', modelChangeHandler);
            }
		}

        /**
         * 
         * @param event 
         */
        protected function modelChangeHandler(event:Event):void{
            IEventDispatcher(_strand).dispatchEvent(new Event(event.type));
        }
	}
}
