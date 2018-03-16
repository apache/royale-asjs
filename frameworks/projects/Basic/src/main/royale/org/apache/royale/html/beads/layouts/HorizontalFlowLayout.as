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
	import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	
	COMPILE::SWF {
		import org.apache.royale.geom.Rectangle;
		import org.apache.royale.utils.CSSUtils;
	}

	/**
	 *  The HorizontalFlowLayout class bead sizes and positions the elements it manages into rows
	 *  and columns. It does this by seeing how many elements will fit horizontally and then flow
	 *  the remainder onto the next lines. If an element does not already have an explicit or percentage
	 *  size, a size is chosen for it based on the defaultColumnCount property which divides the
	 *  layout space into equal number of cells as a default measurement.
	 *
	 *  The height of each row is determined by the tallest element in the row. The next row flows
	 *  below that.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class HorizontalFlowLayout extends LayoutBase implements IBeadLayout
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function HorizontalFlowLayout()
		{
			super();
		}

		private var _defaultColumnCount:Number = 4;
		private var _computedColumnWidth:Number = Number.NaN;
		private var _columnGap:int = 4;
		private var _rowGap:int = 4;
		private var _useChildWidth:Boolean = false;

		/**
		 *  The amount of spacing between the columns.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get columnGap():int
		{
			return _columnGap;
		}
		public function set columnGap(value:int):void
		{
			_columnGap = value;
		}

		/**
		 *  Amount of spacing between the rows.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get rowGap():int
		{
			return _rowGap;
		}
		public function set rowGap(value:int):void
		{
			_rowGap = value;
		}

		/**
		 *  The default number of columns the layout should assume should any or
		 *  all of the elements not have explicit or percentage widths. This value is
		 *  used to divide the layout width into equal-width columns. An element's
		 *  own width overrides this computed width, allowing for a ragged grid
		 *  arrangement.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get defaultColumnCount():Number
		{
			return _defaultColumnCount;
		}
		public function set defaultColumnCount(value:Number):void
		{
			_defaultColumnCount = value;
		}

		/**
		 *  The calculated width of each column, in pixels. If left unspecified, the
		 *  columnWidth is determined by dividing the defaultColumnCount into the
		 *  strand's bounding box width.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get computedColumnWidth():Number
		{
			return _computedColumnWidth;
		}
		public function set computedColumnWidth(value:Number):void
		{
			_computedColumnWidth = value;
		}

		/**
		 *  Determines whether or not each child's width is set from the column size (false) or
		 *  uses its own width (true). Default is false.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get useChildWidth():Boolean
		{
			return _useChildWidth;
		}
		public function set useChildWidth(value:Boolean):void
		{
			_useChildWidth = value;
		}

        /**
         * @copy org.apache.royale.core.IBeadLayout#layout
         *  @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
         */
		override public function layout():Boolean
		{
			COMPILE::SWF
			{
				var area:UIBase = layoutView as UIBase;

				var n:Number = area.numElements;
				if (n == 0) return false;
				
				var paddingMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPaddingMetrics(host);
				var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(host);

				// if a computedColumnWidth hasn't been preset, calculate it
				// based on the default column count, giving equal-width columns.
				if (isNaN(computedColumnWidth)) {
					_computedColumnWidth = (area.width - 
						paddingMetrics.left - paddingMetrics.right - 
						borderMetrics.left - borderMetrics.right) / defaultColumnCount;
					_computedColumnWidth -= _columnGap;
				}

				var maxWidth:Number = area.width;
				var maxHeight:Number = 0;
				var xpos:Number = columnGap/2 + paddingMetrics.left + borderMetrics.left;
				var ypos:Number = rowGap/2 + paddingMetrics.top + borderMetrics.top;
				var useWidth:Number = 0;

				for(var i:int=0; i < n; i++)
				{
					var child:ILayoutChild = area.getElementAt(i) as ILayoutChild;
					if (child == null || !child.visible) continue;

					if (!isNaN(child.explicitWidth)) useWidth = child.explicitWidth;
					else if (!isNaN(child.percentWidth)) useWidth = maxWidth * (child.percentWidth/100.0);
					else useWidth = _computedColumnWidth;

					if (xpos+useWidth > maxWidth) {
						ypos += maxHeight + rowGap;
						xpos = columnGap/2;
						maxHeight = 0;
					}

					child.x = xpos;
					child.y = ypos;
					if (!useChildWidth) {
						child.setWidth(useWidth)
					}

					var childWidth:Number = child.width;
					var childHeight:Number = child.height;
					maxHeight = Math.max(maxHeight, childHeight);

					xpos += childWidth + columnGap;
				}

				return true;
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

				var area:IParentIUIBase = layoutView as IParentIUIBase;
				
				children = area.internalChildren();
				n = children.length;
				if (n === 0) return false;

				area.width = host.width;

				var element:HTMLElement = area.element as HTMLElement;
				element.style["flexFlow"] = "row wrap";
				element.style["display"] = "flex";

				// if a computedColumnWidth hasn't been preset, calculate it
				// based on the default column count, giving equal-width columns.
				if (isNaN(computedColumnWidth)) {
					_computedColumnWidth = host.width / defaultColumnCount;
					_computedColumnWidth -= _columnGap;
				}

				for (i = 0; i < n; i++)
				{
					child = children[i].royale_wrapper;
					if (!child.visible) continue;
					children[i].style["position"] = null;
					
					if (useChildWidth) {
						if (!isNaN(child.explicitWidth)) useWidth = child.explicitWidth;
						else if (!isNaN(child.percentWidth)) useWidth = host.width * (child.percentWidth/100.0);
						else useWidth = _computedColumnWidth;
						child.width = useWidth;
					} else {
						child.width = _computedColumnWidth;
					}
					
					if (_rowGap > 0) {
						children[i].style["margin-top"] = String(_rowGap/2)+"px";
						children[i].style["margin-bottom"] = String(_rowGap/2)+"px";
						children[i].style["margin-left"] = String(_columnGap/2)+"px";
						children[i].style["margin-right"] = String(_columnGap/2)+"px";
					}
				}

				return true;
			}
		}
	}
}
