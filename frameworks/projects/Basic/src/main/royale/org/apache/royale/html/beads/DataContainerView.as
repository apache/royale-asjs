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
package org.apache.royale.html.beads
{	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IChild;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.Strand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.events.ItemAddedEvent;
    import org.apache.royale.events.ItemRemovedEvent;
	import org.apache.royale.html.supportClasses.Border;
	import org.apache.royale.html.supportClasses.DataGroup;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.utils.sendStrandEvent;

	/**
	 *  The DataContainerView provides the visual elements for the DataContainer.
	 *  
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class DataContainerView extends ContainerView implements IListView, IItemRendererOwnerView
	{
		public function DataContainerView()
		{
			super();
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
            // Even though super.addedToParent dispatched "beadsAdded", DataContainer still needs its data mapper
            // and item factory beads. These beads are added after super.addedToParent is called in case substitutions
            // were made; these are just defaults extracted from CSS.
            loadBeadFromValuesManager(IDataProviderItemRendererMapper, "iDataProviderItemRendererMapper", value);
            loadBeadFromValuesManager(IItemRendererClassFactory, "iItemRendererClassFactory", value);
            
			host.addEventListener("beadsAdded", beadsAddedHandler);
            //host.addEventListener("itemsCreated", itemsCreatedHandler); in beadsAddedHandler
		}
		
        
		protected var dataModel:IDataProviderModel;
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.IItemRendererOwnerView
		 */
		public function get dataGroup():IItemRendererOwnerView
		{
			return this as IItemRendererOwnerView;
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
		protected function beadsAddedHandler(event:Event):void
		{
			dataModel = _strand.getBeadByType(IDataProviderModel) as IDataProviderModel;
			host.addEventListener("itemsCreated", itemsCreatedHandler);
			dataModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
		}
        
		
		/**
		 * @private
		 */
		protected function itemsCreatedHandler(event:Event):void
		{
			// trace("DataContainerView: itemsCreatedHandler");
            sendStrandEvent(_strand,"layoutNeeded");
		}
		
		/**
		 * @private
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			// trace("DataContainerView: dataProviderChangeHandler");
            sendStrandEvent(_strand,"layoutNeeded");
		}
        
        /**
         * @private
         */
        COMPILE::SWF
        override public function get resizableView():IUIBase
        {
            return _strand as IUIBase;
        }
        
        /*
        * IItemRendererOwnerView
        */
        
        /**
         * @copy org.apache.royale.core.IItemRendererOwnerView#numItemRenderers()
         * @private
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.IParent
         */
        public function get numItemRenderers():int
        {
            return (contentView as IParent).numElements;
        }
        
        
        /**
         * @copy org.apache.royale.core.IItemRendererOwnerView#addItemRenderer()
         * @private
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.IParent
         */
        public function addItemRenderer(renderer:IItemRenderer, dispatchAdded:Boolean):void
        {
            (contentView as IParent).addElement(renderer, dispatchAdded);
            dispatchItemAdded(renderer);
        }
        
        /**
         * @copy org.apache.royale.core.IItemRendererOwnerView#addItemRendererAt()
         * @private
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         *  @royaleignorecoercion org.apache.royale.core.IParent
         */
        public function addItemRendererAt(renderer:IItemRenderer, index:int):void
        {
            (contentView as IParent).addElementAt(renderer, index, true);
            dispatchItemAdded(renderer);
        }
        
        private function dispatchItemAdded(renderer:IItemRenderer):void
        {
            var newEvent:ItemAddedEvent = new ItemAddedEvent("itemAdded");
            newEvent.item = renderer;
            sendStrandEvent(_strand,newEvent);
        }
        
        /**
         * @copy org.apache.royale.core.IItemRendererOwnerView#removeItemRenderer()
         * @private
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.IParent
         */
        public function removeItemRenderer(renderer:IItemRenderer):void
        {
            (contentView as IParent).removeElement(renderer);
            
            var newEvent:ItemRemovedEvent = new ItemRemovedEvent("itemRemoved");
            newEvent.item = renderer;
            sendStrandEvent(_strand,newEvent);
        }
        
        /**
         * @copy org.apache.royale.core.IItemRendererOwnerView#removeAllItemRenderers()
         * @private
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.IParent
         */
        public function removeAllItemRenderers():void
        {
            while ((contentView as IParent).numElements > 0) {
                var child:IChild = (contentView as IParent).getElementAt(0);
                (contentView as IParent).removeElement(child);
            }
        }
        
        /**
         *  @copy org.apache.royale.core.IItemRendererOwnerView#getItemRendererForIndex()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         * 	@royaleignorecoercion org.apache.royale.core.IItemRenderer
         * 	@royaleignorecoercion org.apache.royale.core.IParent
         */
        public function getItemRendererForIndex(index:int):IItemRenderer
        {
            if (index < 0 || index >= (contentView as IParent).numElements) return null;
            return (contentView as IParent).getElementAt(index) as IItemRenderer;
        }
        
        /**
         *  @copy org.apache.royale.core.IItemRendererOwnerView#getItemRendererAt()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         * 	@royaleignorecoercion org.apache.royale.core.IItemRenderer
         *  @royaleignorecoercion org.apache.royale.core.IParent
         */
        public function getItemRendererAt(index:int):IItemRenderer
        {
            if (index < 0 || index >= (contentView as IParent).numElements) return null;
            return (contentView as IParent).getElementAt(index) as IItemRenderer;
        }
        
        /**
         *  Refreshes the itemRenderers. Useful after a size change by the data group.
         *
         *  @copy org.apache.royale.core.IItemRendererOwnerView#updateAllItemRenderers()
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         * 	@royaleignorecoercion org.apache.royale.html.supportClasses.DataItemRenderer
         *  @royaleignorecoercion org.apache.royale.core.IParent
         */
        public function updateAllItemRenderers():void
        {
            var n:Number = (contentView as IParent).numElements;
            for (var i:Number = 0; i < n; i++)
            {
                var renderer:DataItemRenderer = getItemRendererForIndex(i) as DataItemRenderer;
                if (renderer) {
                    renderer.setWidth(host.width,true);
                    renderer.adjustSize();
                }
            }
        }

	}
}
