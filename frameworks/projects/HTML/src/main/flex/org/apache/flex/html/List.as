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
package org.apache.flex.html
{
	import org.apache.flex.core.ContainerBaseStrandChildren;
	import org.apache.flex.core.IContentViewHost;
	import org.apache.flex.core.IChild;
	import org.apache.flex.core.ILayoutView;
	import org.apache.flex.core.IDataProviderItemRendererMapper;
	import org.apache.flex.core.IFactory;
	import org.apache.flex.core.IItemRendererClassFactory;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IListPresentationModel;
	import org.apache.flex.core.IRollOverModel;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.ListBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.html.beads.ListView;
        import org.apache.flex.html.supportClasses.DataGroup;
    }
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.models.ListPresentationModel;
	import org.apache.flex.html.supportClasses.DataItemRenderer;
	import org.apache.flex.events.ItemAddedEvent;
	import org.apache.flex.events.ItemClickedEvent;
	import org.apache.flex.events.ItemRemovedEvent;

	import org.apache.flex.core.IList;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IItemRendererProvider;
	import org.apache.flex.core.ListBase;

	/**
	 *  Indicates that the initialization of the list is complete.
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	[Event(name="initComplete", type="org.apache.flex.events.Event")]

	/**
	 * The change event is dispatched whenever the list's selection changes.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
    [Event(name="change", type="org.apache.flex.events.Event")]

	/**
	 *  The List class is a component that displays multiple data items. The List uses
	 *  the following bead types:
	 *
	 *  org.apache.flex.core.IBeadModel: the data model, which includes the dataProvider, selectedItem, and
	 *  so forth.
	 *  org.apache.flex.core.IBeadView:  the bead that constructs the visual parts of the list.
	 *  org.apache.flex.core.IBeadController: the bead that handles input and output.
	 *  org.apache.flex.core.IBeadLayout: the bead responsible for the size and position of the itemRenderers.
	 *  org.apache.flex.core.IDataProviderItemRendererMapper: the bead responsible for creating the itemRenders.
	 *  org.apache.flex.core.IItemRenderer: the class or factory used to display an item in the list.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class List extends DataContainer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function List()
		{
			super();
		}

		/**
		 *  The index of the currently selected item. Changing this value
		 *  also changes the selectedItem property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get selectedIndex():int
		{
			return ISelectionModel(model).selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			ISelectionModel(model).selectedIndex = value;
		}

		/**
		 *  The index of the item currently below the pointer.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get rollOverIndex():int
		{
			return IRollOverModel(model).rollOverIndex;
		}
		public function set rollOverIndex(value:int):void
		{
			IRollOverModel(model).rollOverIndex = value;
		}

		/**
		 *  The default height of each cell in every column
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get rowHeight():Number
		{
			return presentationModel.rowHeight;
		}
		public function set rowHeight(value:Number):void
		{
			presentationModel.rowHeight = value;
		}

		/**
		 *  The item currently selected. Changing this value also
		 *  changes the selectedIndex property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get selectedItem():Object
		{
			return ISelectionModel(model).selectedItem;
		}
		public function set selectedItem(value:Object):void
		{
			ISelectionModel(model).selectedItem = value;
		}

		/*
		 * UIBase
		 */

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            super.createElement();
            className = 'List';

            return element;
        }
   	}
}
