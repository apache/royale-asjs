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
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.html.beads.layouts.ITileLayout;
	import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.utils.CSSUtils;

	/**
	 *  The TileLayout class bead sizes and positions the elements it manages into rows and columns.
	 *  The size of each element is determined either by setting TileLayout's columnWidth and rowHeight
	 *  properties, or having the tile size determined by factoring the numColumns into the area assigned
	 *  for the layout.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class TileLayout extends LayoutBase implements ITileLayout
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function TileLayout()
		{
			super();
		}

		private var _numColumns:Number = 4;
		private var _columnWidth:Number = Number.NaN;
		private var _rowHeight:Number = Number.NaN;

		/**
		 *  The number of tiles to fit horizontally into the layout.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get numColumns():Number
		{
			return _numColumns;
		}
		public function set numColumns(value:Number):void
		{
			_numColumns = value;
		}

		/**
		 *  The width of each column, in pixels. If left unspecified, the
		 *  columnWidth is determined by dividing the numColumns into the
		 *  strand's bounding box width.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get columnWidth():Number
		{
			return _columnWidth;
		}
		public function set columnWidth(value:Number):void
		{
			_columnWidth = value;
		}

		/**
		 *  The height of each row, in pixels. If left unspecified, the
		 *  rowHeight is determine by dividing the possible number of rows
		 *  into the strand's bounding box height.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get rowHeight():Number
		{
			return _rowHeight;
		}
		public function set rowHeight(value:Number):void
		{
			_rowHeight = value;
		}

		/**
		 * @copy org.apache.royale.core.IBeadLayout#layout
		 * @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 * @royaleignorecoercion org.apache.royale.core.IParentIUIBase
		 */
		override public function layout():Boolean
		{
			// var paddingMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPaddingMetrics(host);
			
			COMPILE::SWF
			{
				var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(host);
				var area:UIBase = layoutView as UIBase;

				var xpos:Number = 0;
				var ypos:Number = 0;
				var useWidth:Number = columnWidth;
				var useHeight:Number = rowHeight;
				var n:Number = area.numElements;
				if (n == 0) return false;
				
				var adjustedWidth:Number = Math.floor(host.width - borderMetrics.left - borderMetrics.right);
				var adjustedHeight:Number = Math.floor(host.height - borderMetrics.top - borderMetrics.bottom);

				var realN:Number = n;
				for(var j:int=0; j < n; j++)
				{
					var testChild:IUIBase = area.getElementAt(i) as IUIBase;
					if (testChild == null || !testChild.visible) realN--;
				}

				if (isNaN(useWidth)) useWidth = Math.floor(adjustedWidth / numColumns); // + gap
				if (isNaN(useHeight)) {
					// given the width and total number of items, how many rows?
					var numRows:Number = Math.ceil(realN/numColumns);
					if (host.isHeightSizedToContent()) useHeight = 30; // default height
					else useHeight = Math.floor(adjustedHeight / numRows);
				}

				var maxWidth:Number = useWidth;
				var maxHeight:Number = useHeight;

				for(var i:int=0; i < n; i++)
				{
					var child:IUIBase = area.getElementAt(i) as IUIBase;
					if (child == null || !child.visible) continue;
					child.width = useWidth;
					child.height = useHeight;
					child.x = xpos;
					child.y = ypos;

					xpos += useWidth;
					maxWidth = Math.max(maxWidth,xpos);

					var test:Number = (i+1)%numColumns;

					if (test == 0) {
						xpos = 0;
						ypos += useHeight;
						maxHeight = Math.max(maxHeight,ypos);
					}
				}

				maxWidth = Math.max(maxWidth, numColumns*useWidth);
				maxHeight = Math.max(maxHeight, numRows*useHeight);

				// Only return true if the contentView needs to be larger; that new
				// size is stored in the model.
				var sizeChanged:Boolean = true;

				return sizeChanged;
			}
			COMPILE::JS
			{
				var children:Array;
				var i:int;
				var n:int;
				var child:UIBase;
				var xpos:Number;
				var ypos:Number;
				var useWidth:Number;
				var useHeight:Number;

				var contentView:IParentIUIBase = layoutView as IParentIUIBase;
				
				children = contentView.internalChildren();
				n = children.length;
				if (n === 0) return false;

				contentView.element.style["display"] = "flex";
				contentView.element.style["flexFlow"] = "row wrap";
				contentView.element.style["alignContent"] = "flex-start";
				var realN:int = n;
				for (i = 0; i < n; i++)
				{
					child = children[i].royale_wrapper;
					if (!child.visible) realN--;
				}

				xpos = 0;
				ypos = 0;
				useWidth = columnWidth;
				useHeight = rowHeight;
				var needWidth:Boolean = isNaN(useWidth);
				var needHeight:Boolean = isNaN(useHeight);
				if(needHeight || needWidth){
					var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(host);
					var adjustedWidth:Number = Math.floor(host.width - borderMetrics.left - borderMetrics.right);
					var adjustedHeight:Number = Math.floor(host.height - borderMetrics.top - borderMetrics.bottom);
					if (needWidth)
						useWidth = Math.floor(adjustedWidth / numColumns); // + gap
					
					if (needHeight)
					{
						// given the width and total number of items, how many rows?
						var numRows:Number = Math.ceil(realN / numColumns);
						if (host.isHeightSizedToContent()) useHeight = 30; // default height
						else useHeight = Math.floor(adjustedHeight / numRows);
					}
				}
				
				for (i = 0; i < n; i++)
				{
					child = children[i].royale_wrapper;
					if (!child.visible) continue;
					child.setDisplayStyleForLayout('inline-block');
					//if the parent width/height not explicitly set, we can't calculate the child width/height
					if(useWidth > 0)
						child.width = useWidth;
					if(useHeight > 0)
						child.height = useHeight;
				}
				return true;
			}
		}
	}
}
