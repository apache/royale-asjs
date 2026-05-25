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
	import org.apache.royale.core.IMultiSelectionModel;
	import org.apache.royale.core.IRollOverModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.DataContainerView;
	import org.apache.royale.html.util.getModelByType;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.renderers.IListItemRenderer;
	import org.apache.royale.core.IStrand;

	/**
	 *  The List class creates the visual elements of the org.apache.royale.html.List
	 *  component. A List consists of the area to display the data (in the dataGroup), any
	 *  scrollbars, and so forth.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	COMPILE::JS
	public class MultiSelectionListView extends DataContainerView
	{
		public function MultiSelectionListView()
		{
			super();
		}

		protected var listModel:IMultiSelectionModel;

		protected var lastSelectedIndices:Array = null;

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IMultiSelectionModel
		 */
		override protected function handleInitComplete(event:Event):void
		{
			listModel = getModelByType(_strand,IMultiSelectionModel) as IMultiSelectionModel;
			assert(listModel != null, "ListModel must implement IMultiSelectionModel when using MultiSelectionListView");
			listModel.addEventListener("selectedIndicesChanged", selectionChangeHandler);
			listModel.addEventListener("rollOverIndexChanged", rollOverIndexChangeHandler);

			super.handleInitComplete(event);
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.style.renderers.IListItemRenderer
		 */
		protected function selectionChangeHandler(event:Event):void
		{
			if (lastSelectedIndices)
			{
				for (var i:int = 0; i < lastSelectedIndices.length; i++)
				{
					var ir:IListItemRenderer = dataGroup.getItemRendererForIndex(lastSelectedIndices[i]) as IListItemRenderer;
					if(ir)
						ir.selected = false;
				}
			}
			if (listModel.selectedIndices)
			{
				for (i = 0; i < listModel.selectedIndices.length; i++)
				{
					ir = dataGroup.getItemRendererForIndex(listModel.selectedIndices[i]) as IListItemRenderer;
					if(ir)
						ir.selected = true;
				}
			}

			lastSelectedIndices = listModel.selectedIndices;
		}

		protected var lastRollOverIndex:int = -1;

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.style.renderers.IListItemRenderer
		 * @royaleignorecoercion org.apache.royale.core.IRollOverModel
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

	COMPILE::SWF
	public class MultiSelectionListView extends DataContainerView
	{
		public function MultiSelectionListView()
		{
			super();
		}

		protected var listModel:IMultiSelectionModel;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;
		}

		/**
		 * @private
		 */
		override protected function handleInitComplete(event:Event):void
		{
			super.handleInitComplete(event);

			listModel = getModelByType(_strand,IMultiSelectionModel) as IMultiSelectionModel;
			listModel.addEventListener("selectedIndicesChanged", selectionChangeHandler);
			listModel.addEventListener("rollOverIndexChanged", rollOverIndexChangeHandler);
		}

		protected var lastSelectedIndices:Array = null;

		/**
		 * @private
		 */
		protected function selectionChangeHandler(event:Event):void
		{

			if (lastSelectedIndices)
			{
				for (var i:int = 0; i < lastSelectedIndices.length; i++)
				{
					var ir:IListItemRenderer = dataGroup.getItemRendererForIndex(lastSelectedIndices[i]) as IListItemRenderer;
					if (ir)
						ir.selected = false;
				}
			}
			if (listModel.selectedIndices)
			{
				for (i = 0; i < listModel.selectedIndices; i++)
				{
					ir = dataGroup.getItemRendererForIndex(listModel.selectedIndices[i]) as IListItemRenderer;
					if (ir)
						ir.selected = true;
				}
			}
			lastSelectedIndices = listModel.selectedIndices;
		}

		protected var lastRollOverIndex:int = -1;

		/**
		 * @private
		 */
		protected function rollOverIndexChangeHandler(event:Event):void
		{
			var ir:IListItemRenderer = dataGroup.getItemRendererForIndex(lastRollOverIndex) as IListItemRenderer;
			if(ir)
				ir.hovered = false;
			ir = dataGroup.getItemRendererForIndex(IRollOverModel(listModel).rollOverIndex) as IListItemRenderer;
			if(ir)
				ir.hovered = true;
			
			lastRollOverIndex = IRollOverModel(listModel).rollOverIndex;
		}
	}
}
