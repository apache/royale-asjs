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
    COMPILE::JS
    {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
    }
    import org.apache.royale.core.IItemRenderer;
    import org.apache.royale.core.IItemRendererOwnerView;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.events.ItemAddedEvent;
    import org.apache.royale.events.ItemRemovedEvent;
    import org.apache.royale.html.supportClasses.StyledDataItemRenderer;
    import org.apache.royale.jewel.itemRenderers.TableItemRenderer;
    import org.apache.royale.jewel.supportClasses.container.StyledContainerContentArea;
    import org.apache.royale.jewel.supportClasses.table.TableRow;


	/**
	 *  The TBodyContentArea class is a building block of Jewel SimpleTable and Table components, 
	 *  is used in TableView and represents an HTML <tbody> element.
	 * 
	 *  The body part in a table use to be the "data" part and can be scrollable for this reason is implemented
	 *  as a ContainerContentArea and provided via CSS as the IContentView.
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class TBodyContentArea extends StyledContainerContentArea implements IItemRendererOwnerView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function TBodyContentArea()
		{
			super();

			typeNames = "jewel tbody";
		}
		
		/**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this, 'tbody');
        }

		private var itemRenderers:Array = [];

		/*
		* IItemRendererOwnerView
		*/
		
		/**
		 * @copy org.apache.royale.core.IItemRendererOwnerView#addItemRenderer()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function addItemRenderer(renderer:IItemRenderer, dispatchAdded:Boolean):void
		{
			// this method is not used for now, so it needs to be tested to see if it's correctly implemented
			var r:TableItemRenderer = renderer as TableItemRenderer;
			r.itemRendererOwnerView = this; // easy access from renderer to table
			var tableCell:TableCell = new TableCell();
			tableCell.addElement(r);

			var row:TableRow;
			if(r.rowIndex > numElements -1)
			{
				row = new TableRow();
				addElementAt(row, r.rowIndex, false);
			} 
			else
			{
				row = getElementAt(r.rowIndex) as TableRow;
			}

			row.addElement(tableCell, dispatchAdded);
			
			itemRenderers.push(r);
			dispatchItemAdded(renderer);
		}
		
		/**
		 * @copy org.apache.royale.core.IItemRendererOwnerView#addItemRendererAt()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function addItemRendererAt(renderer:IItemRenderer, index:int):void
		{
			var r:TableItemRenderer = renderer as TableItemRenderer;
			r.itemRendererOwnerView = this; // easy access from renderer to table
			var tableCell:TableCell = new TableCell();
			tableCell.addElement(r);

			var row:TableRow;
			if(r.rowIndex > numElements - 1)
			{
				row = new TableRow();
				addElementAt(row, r.rowIndex, false);
			} 
			else
			{
				row = getElementAt(r.rowIndex) as TableRow;
			}

			row.addElementAt(tableCell, r.columnIndex, true);
			
			itemRenderers.push(r);
			dispatchItemAdded(r);
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function dispatchItemAdded(renderer:IItemRenderer):void
		{
			var newEvent:ItemAddedEvent = new ItemAddedEvent("itemAdded");
			newEvent.item = renderer;
			
			(host as IEventDispatcher).dispatchEvent(newEvent);
		}
		
		/**
		 * @copy org.apache.royale.core.IItemRendererOwnerView#removeItemRenderer()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function removeItemRenderer(renderer:IItemRenderer):void
		{
			itemRenderers.splice(itemRenderers.indexOf(renderer), 1);
			var newEvent:ItemRemovedEvent = new ItemRemovedEvent("itemRemoved");
			newEvent.item = renderer;
			(host as IEventDispatcher).dispatchEvent(newEvent);
		}

		private var processedRow:TableRow;
		
		/**
		 * @copy org.apache.royale.core.IItemRendererOwnerView#removeAllItemRenderers()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function removeAllItemRenderers():void
		{
			while (numElements > 0) {
				processedRow = getElementAt(0) as TableRow;
				while (processedRow.numElements > 0) {
					var cell:TableCell = processedRow.getElementAt(0) as TableCell;
					var ir:IItemRenderer = cell.getElementAt(0) as IItemRenderer;
					removeItemRenderer(ir);
					cell.removeElement(ir);
					processedRow.removeElement(cell);
				}
				removeElement(processedRow);
			}
		}
		
		/**
		 *  @copy org.apache.royale.core.IItemRendererOwnerView#getItemRendererAt()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function getItemRendererAt(index:int):IItemRenderer
		{
			if (index < 0 || index >= itemRenderers.length) return null;
			return itemRenderers[index] as IItemRenderer;
		}

		/**
		 *  @copy org.apache.royale.core.IItemRendererOwnerView#getItemRendererForIndex()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function getItemRendererForIndex(index:int):IItemRenderer
		{
			if (index < 0 || index >= itemRenderers.length) return null;
			return itemRenderers[index] as IItemRenderer;
		}

		/**
		 *  Refreshes the itemRenderers. Useful after a size change by the data group.
		 *  Not used for now. This should be revised in this case
		 *
		 *  @copy org.apache.royale.core.IItemRendererOwnerView#updateAllItemRenderers()
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function updateAllItemRenderers():void
		{
			var n:Number = numElements;
			for (var i:Number = 0; i < n; i++)
			{
				var renderer:StyledDataItemRenderer = getItemRendererAt(i) as StyledDataItemRenderer;
				if (renderer) {
					renderer.setWidth(this.width,true);
					renderer.adjustSize();
				}
			}
		}

		/**
         *  @copy org.apache.royale.core.IItemRendererOwnerView#numItemRenderers()
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get numItemRenderers():int{
			return numElements;
		}
    }
}
