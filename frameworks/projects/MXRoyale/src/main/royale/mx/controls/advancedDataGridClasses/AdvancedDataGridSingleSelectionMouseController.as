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
package mx.controls.advancedDataGridClasses
{
	import mx.controls.AdvancedDataGrid;
	import mx.controls.beads.AdvancedDataGridView;
	import mx.events.ListEvent;
	
	import org.apache.royale.collections.ITreeData;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.html.beads.controllers.ListSingleSelectionMouseController;
	import mx.supportClasses.IFoldable;
	import mx.events.AdvancedDataGridEvent;
	import org.apache.royale.core.IHasDataField;
	import mx.controls.listClasses.IListItemRenderer;
	import org.apache.royale.utils.sendEvent;

	/**
	 *  The TreeSingleSelectionMouseController class is a controller for 
	 *  org.apache.royale.html.Tree. This controller watches for selection
	 *  events on the tree item renderers and uses those events to open
	 *  or close nodes of the tree.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class AdvancedDataGridSingleSelectionMouseController extends ListSingleSelectionMouseController
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function AdvancedDataGridSingleSelectionMouseController()
		{
			super();
		}

		private var _strand:IStrand;

		/**
		 * @private
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;
		}

		/**
		 * @private
		 */
		override protected function selectedHandler(event:ItemClickedEvent):void
		{
			var adg:AdvancedDataGrid =  (_strand as AdvancedDataGridColumnList).grid as AdvancedDataGrid;
			var lists:Array = (adg.view as AdvancedDataGridView).columnLists;
			for (var i:int = 0; i < lists.length; i++)
				if (lists[i] == _strand) break;

			var node:Object = event.data;
			
			var hasChildren:Boolean = adg.hasChildren(node);
			var foldableTarget:IFoldable = event.target as IFoldable;
			if (hasChildren && (foldableTarget is IFoldable))
			{
				if (adg.isItemOpen(node) && foldableTarget.canFold) {
					adg.closeNode(node);
				} else if (foldableTarget.canUnfold) {
					adg.openNode(node);
					var adgEvent:AdvancedDataGridEvent = new AdvancedDataGridEvent(
						AdvancedDataGridEvent.ITEM_OPEN,
						false,
						false,
						i, 
						(adg.columns[i] as IHasDataField).dataField,
						event.index,
						null,
						event.target as IListItemRenderer
						);
					adgEvent.item = node;
					sendEvent(adg, adgEvent);
				}
			}

			//avoid doing this (it breaks ctrl-click de-selection which is managed at the top level):
			//was: reset the selection
			//            ((_strand as AdvancedDataGridColumnList).model as ISelectionModel).selectedItem = node;
			IEventDispatcher(_strand).dispatchEvent(new Event("change"));
			
			var newEvent:ListEvent = new ListEvent(ListEvent.ITEM_CLICK);
			newEvent.rowIndex = event.index;
					newEvent.columnIndex = i;
					newEvent.itemRenderer = event.currentTarget;
			IEventDispatcher(_strand).dispatchEvent(newEvent);
		}
	}
}
