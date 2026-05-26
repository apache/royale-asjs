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
package org.apache.royale.style.beads
{
  import org.apache.royale.core.IRollOverModel;
  import org.apache.royale.core.ISelectionModel;
  import org.apache.royale.debugging.assert;
  import org.apache.royale.events.Event;
  import org.apache.royale.functional.decorator.debounceLong;
  import org.apache.royale.html.beads.DataContainerView;
  import org.apache.royale.style.renderers.IListItemRenderer;

	public class ListView extends DataContainerView
	{
		public function ListView()
		{
			super();
			runChangeHandler = debounceLong(function():void{
				selectionChangeHandler(null);
			},0);
		}

		protected var listModel:IRollOverModel;

		protected var lastSelectedIndex:int = -1;
		protected var lastFocusedIndex:int = -1;
		// protected var lastKeyboardFocusedIndex:int = -1;

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 * @royaleignorecoercion org.apache.royale.core.IRollOverModel
		 */
		override protected function handleInitComplete(event:Event):void
		{
			listModel = dataModel as IRollOverModel;
			listModel.addEventListener("selectedIndexChanged", selectionChangeHandler);
			listModel.addEventListener("rollOverIndexChanged", rollOverIndexChangeHandler);
			// Don't call super because we don't need the overhead of layout
			// super.handleInitComplete(event);
		}
		override protected function itemsCreatedHandler(event:Event):void
		{
			super.itemsCreatedHandler(event);
			runChangeHandler();
		}
		private var runChangeHandler:Function;
		/**
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 * @royaleignorecoercion org.apache.royale.style.renderers.IListItemRenderer
		 */
		protected function selectionChangeHandler(event:Event):void
		{
			var ir:IListItemRenderer = dataGroup.getItemRendererForIndex(lastSelectedIndex) as IListItemRenderer;
			if(ir)
				ir.selected = false;
			assert(listModel is ISelectionModel, "ListModel should implement ISelectionModel. For multi-selection, use MultiSelectionListView.");
			ir = dataGroup.getItemRendererForIndex((listModel as ISelectionModel).selectedIndex) as IListItemRenderer;
			if(ir)
				ir.selected = true;

			lastSelectedIndex = (listModel as ISelectionModel).selectedIndex;
		}

		protected var lastRollOverIndex:int = -1;

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IRollOverModel
		 * @royaleignorecoercion org.apache.royale.style.renderers.IListItemRenderer
		 */
		protected function rollOverIndexChangeHandler(event:Event):void
		{
			var ir:IListItemRenderer = dataGroup.getItemRendererForIndex(lastRollOverIndex) as IListItemRenderer;
			if(ir)
				ir.hovered = false;
			ir = dataGroup.getItemRendererForIndex((listModel as IRollOverModel).rollOverIndex) as IListItemRenderer;
			if(ir)
				ir.hovered = true;
			lastRollOverIndex = (listModel as IRollOverModel).rollOverIndex;
		}
	}

}