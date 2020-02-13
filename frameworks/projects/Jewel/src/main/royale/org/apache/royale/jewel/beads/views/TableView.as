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
package org.apache.royale.jewel.beads.views
{
    import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStrandWithModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.jewel.beads.models.TableModel;
	import org.apache.royale.jewel.beads.views.ListView;
	import org.apache.royale.jewel.supportClasses.table.TFoot;
	import org.apache.royale.jewel.supportClasses.table.THead;
	
	/**
	 *  The TableView class creates the visual elements of the org.apache.royale.jewel.Table component.
	 * 
	 *  It creates a TBody, and defines THead and TFoot optional parts to be created by a mapper
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class TableView extends ListView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function TableView()
		{
			super();
        }

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
		}

		protected var model:TableModel;

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		override protected function handleInitComplete(event:Event):void
		{
			model = _strand.getBeadByType(TableModel) as TableModel;
			model.addEventListener("selectedIndexChanged", selectionChangeHandler);
			model.addEventListener("rollOverIndexChanged", rollOverIndexChangeHandler);
			model.addEventListener("columnsChanged", columnsChangedHandler);
			IEventDispatcher(_strand).addEventListener("itemsCreated", itemsCreatedHandler);

			super.handleInitComplete(event);
		}

		protected function columnsChangedHandler(event:Event):void
		{
			IStrandWithModel(_strand).model.dispatchEvent(new Event("dataProviderChanged"));
		}

		/**
		 * @private
		 * Ensure the list selects the selectedItem if someone is set by the user at creation time
		 */
		override protected function itemsCreatedHandler(event:Event):void
		{
            super.itemsCreatedHandler(event);
			if(listModel.selectedIndex != -1)
				selectionChangeHandler(null);
		}

		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var thead:THead;

		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var tfoot:TFoot;

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 */
		override protected function selectionChangeHandler(event:Event):void
		{
            var selectionBead:ISelectableItemRenderer;
			var ir:IItemRenderer = dataGroup.getItemRendererAt(lastSelectedIndex) as IItemRenderer;
            if (ir)
            {
                selectionBead = (ir as IStrand).getBeadByType(ISelectableItemRenderer) as ISelectableItemRenderer;
                if (selectionBead)
                    selectionBead.selected = false;
            }
			
			ir = dataGroup.getItemRendererAt(listModel.selectedIndex) as IItemRenderer;
			if (ir)
            {
                selectionBead = (ir as IStrand).getBeadByType(ISelectableItemRenderer) as ISelectableItemRenderer;
                if (selectionBead)
                    selectionBead.selected = true;
            }
            lastSelectedIndex = listModel.selectedIndex;
		}
	}
}
