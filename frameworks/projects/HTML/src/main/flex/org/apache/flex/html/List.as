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
	import org.apache.flex.core.ILayoutObject;
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
	public class List extends ListBase implements IList, IItemRendererParent, ILayoutObject
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
			addEventListener("beadsAdded", beadsAddedHandler);
		}
		
		/**
		 *  The name of field within the data used for display. Each item of the
		 *  data should have a property with this name.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get labelField():String
		{
			return ISelectionModel(model).labelField;
		}
		public function set labelField(value:String):void
		{
			ISelectionModel(model).labelField = value;
		}
		
		/**
		 *  The data being display by the List.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get dataProvider():Object
        {
            return ISelectionModel(model).dataProvider;
        }
        public function set dataProvider(value:Object):void
        {
            ISelectionModel(model).dataProvider = value;
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
		 *  The presentation model for the list.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get presentationModel():IListPresentationModel
		{
			var presModel:IListPresentationModel = getBeadByType(IListPresentationModel) as IListPresentationModel;
			if (presModel == null) {
				presModel = new ListPresentationModel();
				addBead(presModel);
			}
			return presModel;
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
		 * IList and IItemRendererProvider
		 */
		
		/**
		 * Provides the DataGroup for this List.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get dataGroup():IItemRendererParent
		{
			return this;
		}
		
		private var _itemRenderer:IFactory;
		
		/**
		 *  The class or factory used to display each item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}
		public function set itemRenderer(value:IFactory):void
		{
			_itemRenderer = value;
		}
		
		/**
		 * Returns whether or not the itemRenderer property has been set.
		 *
		 *  @see org.apache.flex.core.IItemRendererProvider
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get hasItemRenderer():Boolean
		{
			var result:Boolean = false;
			
			COMPILE::SWF {
				result = _itemRenderer != null;
			}
			
			COMPILE::JS {
				var test:* = _itemRenderer;
				result = _itemRenderer !== null && test !== undefined;
			}
			
			return result;
		}
		
		/*
		 * IItemRendererParent
		 */
		
		/**
		 * @copy org.apache.flex.core.IItemRendererParent#getItemRendererForIndex()
		 * @private
		 */
		public function addItemRenderer(renderer:IItemRenderer):void
		{			
			addElement(renderer, true);
			
			var newEvent:ItemAddedEvent = new ItemAddedEvent("itemAdded");
			newEvent.item = renderer;
			
			dispatchEvent(newEvent);
		}
		
		/**
		 * @copy org.apache.flex.core.IItemRendererParent#getItemRendererForIndex()
		 * @private
		 */
		public function removeItemRenderer(renderer:IItemRenderer):void
		{				
			removeElement(renderer, true);
			
			var newEvent:ItemRemovedEvent = new ItemRemovedEvent("itemRemoved");
			newEvent.item = renderer;
			
			dispatchEvent(newEvent);
		}
		
		/**
		 * @copy org.apache.flex.core.IItemRendererParent#getItemRendererForIndex()
		 * @private
		 */
		public function removeAllItemRenderers():void
		{			
			while (numElements > 0) {
				var child:IChild = getElementAt(0);
				removeElement(child);
			}
		}
		
		/**
		 *  @copy org.apache.flex.core.IItemRendererParent#getItemRendererForIndex()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function getItemRendererForIndex(index:int):IItemRenderer
		{			
			if (index < 0 || index >= numElements) return null;
			return getElementAt(index) as IItemRenderer;
		}
		
		/**
		 *  Refreshes the itemRenderers. Useful after a size change by the data group.
		 *  
		 *  @copy org.apache.flex.core.IItemRendererParent#getItemRendererForIndex()
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function updateAllItemRenderers():void
		{			
			var n:Number = numElements;
			for (var i:Number = 0; i < n; i++)
			{
				var renderer:DataItemRenderer = getItemRendererForIndex(i) as DataItemRenderer;
				if (renderer) {
					renderer.setWidth(this.width,true);
					renderer.adjustSize();
				}
			}
		}
		
		/*
		 * UIBase
		 */
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
            super.addedToParent();
            		
			dispatchEvent(new Event("initComplete"));
		}
        
		/**
		 * @private
		 */
	    private function beadsAddedHandler(e:Event):void
		{
            if (getBeadByType(IDataProviderItemRendererMapper) == null)
            {
                var mapper:IDataProviderItemRendererMapper = new (ValuesManager.valuesImpl.getValue(this, "iDataProviderItemRendererMapper")) as IDataProviderItemRendererMapper;
                addBead(mapper);
            }
			var itemRendererFactory:IItemRendererClassFactory = getBeadByType(IItemRendererClassFactory) as IItemRendererClassFactory;
			if (!itemRendererFactory)
			{
				itemRendererFactory = new (ValuesManager.valuesImpl.getValue(this, "iItemRendererClassFactory")) as IItemRendererClassFactory;
				addBead(itemRendererFactory);
			}
		}
		
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
