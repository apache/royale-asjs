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
package org.apache.royale.core
{
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ItemAddedEvent;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.events.ItemRemovedEvent;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.states.State;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	
	/**
	 *  Indicates that the initialization of the list is complete.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="initComplete", type="org.apache.royale.events.Event")]
    
    /**
     *  The DataContainerBase class is the base class for components that
	 *  that have generated content, like lists.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class DataContainerBase extends ContainerBase implements IItemRendererParent, IList
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DataContainerBase()
		{
			super();
		}
		
		/*
		* UIBase
		*/
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			super.createElement();
			className = 'DataContainer';
			
			return element;
		}
		
		private var _DCinitialized:Boolean;
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			if (!_DCinitialized)
			{
				ValuesManager.valuesImpl.init(this);
				_DCinitialized = true;
			}
			
			super.addedToParent();
			
			// Even though super.addedToParent dispatched "beadsAdded", DataContainer still needs its data mapper
			// and item factory beads. These beads are added after super.addedToParent is called in case substitutions
			// were made; these are just defaults extracted from CSS.
			
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
			
			dispatchEvent(new Event("initComplete"));
		}
		
		/*
		 * IList
		 */
		
		/**
		 * Returns the sub-component that parents all of the item renderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get dataGroup():IItemRendererParent
		{
			// The JS-side's view.dataGroup is actually this instance of DataContainerBase
			return (view as IListView).dataGroup;
		}
		
		/*
		* IItemRendererProvider
		*/
		
		private var _itemRenderer:IFactory;
		
		/**
		 *  The class or factory used to display each item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 *  @see org.apache.royale.core.IItemRendererProvider
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 * @copy org.apache.royale.core.IItemRendererParent#addItemRenderer()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function addItemRenderer(renderer:IItemRenderer):void
		{
			addElement(renderer, true);
			
			var newEvent:ItemAddedEvent = new ItemAddedEvent("itemAdded");
			newEvent.item = renderer;
			
			dispatchEvent(newEvent);
		}
		
		/**
		 * @copy org.apache.royale.core.IItemRendererParent#removeItemRenderer()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function removeItemRenderer(renderer:IItemRenderer):void
		{
			removeElement(renderer, true);
			
			var newEvent:ItemRemovedEvent = new ItemRemovedEvent("itemRemoved");
			newEvent.item = renderer;
			
			dispatchEvent(newEvent);
		}
		
		/**
		 * @copy org.apache.royale.core.IItemRendererParent#removeAllItemRenderers()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function removeAllItemRenderers():void
		{
			while (numElements > 0) {
				var child:IChild = getElementAt(0);
				removeElement(child);
			}
		}
		
		/**
		 *  @copy org.apache.royale.core.IItemRendererParent#getItemRendererForIndex()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function getItemRendererForIndex(index:int):IItemRenderer
		{
			if (index < 0 || index >= numElements) return null;
			return getElementAt(index) as IItemRenderer;
		}
		
		/**
		 *  Refreshes the itemRenderers. Useful after a size change by the data group.
		 *
		 *  @copy org.apache.royale.core.IItemRendererParent#updateAllItemRenderers()
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
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

    }
}
