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
package org.apache.royale.html.supportClasses
{	
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IContentView;
    import org.apache.royale.core.IItemRenderer;
    import org.apache.royale.core.IItemRendererParent;
	import org.apache.royale.core.IRollOverModel;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIBase;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ItemAddedEvent;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.events.ItemRemovedEvent;

    /**
     *  The DataGroup class is the IItemRendererParent used internally
     *  by org.apache.royale.html.List class.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class DataGroup extends ContainerContentArea implements IItemRendererParent
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DataGroup()
		{
			super();
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
			
			(host as IEventDispatcher).dispatchEvent(newEvent);
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
			
			(host as IEventDispatcher).dispatchEvent(newEvent);
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
				removeItemRenderer(child as IItemRenderer);
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
