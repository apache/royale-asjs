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
package org.apache.royale.jewel.supportClasses.table
{
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IItemRenderer;
    import org.apache.royale.core.IItemRendererParent;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemAddedEvent;
	import org.apache.royale.events.ItemRemovedEvent;
	import org.apache.royale.html.supportClasses.ContainerContentArea;
	import org.apache.royale.html.supportClasses.DataItemRenderer;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
    }

	/**
	 *  The TBodyContentArea class is a building block of Jewel SimpleTable and Table components, 
	 *  is used in TableView and represents an HTML <tbody> element
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class TBodyContentArea extends ContainerContentArea implements IItemRendererParent
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function TBodyContentArea()
		{
			super();

			typeNames = "jewel tbody";
		}
		
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this, 'tbody');
        }

		public var itemRenderers:Array = [];

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
		public function addItemRenderer(renderer:IItemRenderer, dispatchAdded:Boolean):void
		{
			// var tableCell:TableCell = new TableCell();
			// tableCell.addElement(renderer);
			// addElement(tableCell, dispatchAdded);
			// dispatchItemAdded(renderer);
		}
		
		/**
		 * @copy org.apache.royale.core.IItemRendererParent#addItemRendererAt()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function addItemRendererAt(renderer:IItemRenderer, index:int):void
		{
			// var tableCell:TableCell = new TableCell();
			// tableCell.addElement(renderer);
			// addElementAt(tableCell, index, true);
			// dispatchItemAdded(renderer);
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function dispatchItemAdded(renderer:IItemRenderer):void
		{
			itemRenderers.push(renderer);

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
			// removeElement(renderer, true);
			
			// var newEvent:ItemRemovedEvent = new ItemRemovedEvent("itemRemoved");
			// newEvent.item = renderer;
			
			// (host as IEventDispatcher).dispatchEvent(newEvent);
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
			if (index < 0 || index >= itemRenderers.length) return null;
			// if (index < 0 || index >= numElements) return null;
			// return getElementAt(index) as IItemRenderer;
			return itemRenderers[index] as IItemRenderer;
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
