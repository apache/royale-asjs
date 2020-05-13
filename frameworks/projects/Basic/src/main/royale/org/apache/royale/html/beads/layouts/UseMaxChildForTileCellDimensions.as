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
package org.apache.royale.html.beads.layouts
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.html.beads.layouts.ITileLayout;

	/**
	 *  The UseMaxChildForTileCellDimensions class bead finds the biggest item renderer in a tiled list
	 *  and sets the tile dimensions accordingly.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class UseMaxChildForTileCellDimensions implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function UseMaxChildForTileCellDimensions()
		{
			super();
		}
		
		public function set strand(value:IStrand):void
		{
			(value as IEventDispatcher).addEventListener("layoutNeeded", layoutNeededHandler);
		}
		
		private function layoutNeededHandler(e:Event):void
		{
			var strand:IStrand = e.target as IStrand;
			var dataGroup:IItemRendererOwnerView = (strand.getBeadByType(IListView) as IListView).dataGroup;
			var maxWidth:int = 0;
			var maxHeight:int = 0;
			for (var i:int = 0; i < dataGroup.numItemRenderers; i++)
			{
				var uibase:IUIBase = dataGroup.getItemRendererForIndex(i) as IUIBase;
				if (!uibase.visible)
				{
					continue;
				}
				if (!isNaN(uibase.width) && maxWidth < uibase.width)
				{
					maxWidth = uibase.width;
				}
				if (!isNaN(uibase.height) && maxHeight < uibase.height)
				{
					maxHeight = uibase.height;
				}
			}
			var tileLayout:ITileLayout = strand.getBeadByType(ITileLayout) as ITileLayout;
			if (maxWidth > 0)
			{
				tileLayout.columnWidth = maxWidth;
			}
			if (maxHeight > 0)
			{
				tileLayout.rowHeight = maxHeight;
			}
		}
		
	}
}
