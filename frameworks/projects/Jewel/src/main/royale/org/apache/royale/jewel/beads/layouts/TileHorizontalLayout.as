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
package org.apache.royale.jewel.beads.layouts
{
	COMPILE::SWF
	{
	import org.apache.royale.core.IUIBase;
	}
	import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.layout.ILayoutStyleProperties;
	import org.apache.royale.events.Event;

	/**
	 *  The TileHorizontalLayout class bead sizes and positions the elements it manages into rows and columns.
	 *  The size of each element is determined either by setting TileHorizontalLayout's columnWidth and rowHeight
	 *  properties, or having the tile size determined by factoring the columnCount into the area assigned
	 *  for the layout.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.10.0
	 */
	public class TileHorizontalLayout extends SimpleHorizontalLayout implements ILayoutStyleProperties
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function TileHorizontalLayout()
		{
			super();
		}

		public static const LAYOUT_TYPE_NAMES:String = "layout horizontal tile";

		/**
		 *  Add class selectors when the component is addedToParent
		 *  Otherwise component will not get the class selectors when 
		 *  perform "removeElement" and then "addElement"
		 * 
 		 *  @langversion 3.0
 		 *  @playerversion Flash 10.2
 		 *  @playerversion AIR 2.6
 		 *  @productversion Royale 0.10.0
 		 */
		override public function beadsAddedHandler(event:Event = null):void
		{
			super.beadsAddedHandler();

			hostComponent.replaceClass("tile");
		}

		private var _columnCount:int = -1;
		/**
		 *  The number of tiles to fit horizontally into the layout.
		 *  Contain the actual column count.
		 *  The default value is -1.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		[Bindable("columnCountChanged")]
		public function get columnCount():int
		{
			return _columnCount;
		}

		private var _requestedColumnCount:int = -1;
		/**
		 *  Number of columns to be displayed.
		 *  Set to -1 to allow the TileHorizontalLayout to determine the column count automatically.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		[Bindable("requestedColumnCountChanged")]
		public function get requestedColumnCount():int
		{
			return _requestedColumnCount;
		}
		public function set requestedColumnCount(value:int):void
		{
			if (_requestedColumnCount != value)
            {
				_requestedColumnCount = value;
				if(!isNaN(value))
					_columnWidth = NaN;
				if(hostComponent)
					updateLayout();
            }
		}

		private var _columnWidth:Number = Number.NaN;
		/**
		 *  Contain the actual column width, in pixels.
		 *  If not explicitly set, the column width is determined from the width of the widest element.
		 *  If the columnAlign property is set to "justifyUsingWidth", the column width grows to the container width to justify the fully-visible columns.
		 *  The default value is NaN.
		 *  This property can be used as the source for data binding.
		 *  
		 *  The width of each column, in pixels. If left unspecified, the
		 *  columnWidth is determined by dividing the columnCount into the
		 *  strand's bounding box width.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		[Bindable("columnWidthChanged")]
		public function get columnWidth():Number
		{
			return _columnWidth;
		}
		public function set columnWidth(value:Number):void
		{
			if (_columnWidth != value)
            {
				_columnWidth = value;
				if(!isNaN(value))
					_requestedColumnCount = -1;
				if(hostComponent)
					updateLayout();
            }
		}

		private var _rowCount:int = -1;
		/**
		 *  The number of tiles to fit horizontally into the layout.
		 *  The row count.
		 *  The default value is -1.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		[Bindable("rowCountChanged")]
		public function get rowCount():int
		{
			return _rowCount;
		}
		
		private var _rowHeight:Number = Number.NaN;
		/**
		 *  The row height, in pixels.
		 *  If not explicitly set, the row height is determined from the maximum of elements' height.
		 *  If rowAlign is set to "justifyUsingHeight", the actual row height increases to justify the fully-visible rows to the container height.
		 *  The default value is NaN.
		 *  This property can be used as the source for data binding.
		 *  
		 *  The height of each row, in pixels. If left unspecified, the
		 *  rowHeight is determine by dividing the possible number of rows
		 *  into the strand's bounding box height.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		[Bindable("rowHeightChanged")]
		public function get rowHeight():Number
		{
			return _rowHeight;
		}
		public function set rowHeight(value:Number):void
		{
			if (_rowHeight != value)
            {
				_rowHeight = value;
				if(hostComponent)
					updateLayout();
            }
		}

		/**
		 *  @private
		 */
		// private var horizontalGapInitialized:Boolean;
		private var _horizontalGap:Number = 0;
		/**
		 *  The horizontalGap between items.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		[Bindable("horizontalGapChanged")]
		public function get horizontalGap():Number
		{
			return _horizontalGap;
		}
		/**
		 *  @private
		 */
		public function set horizontalGap(value:Number):void
		{
			if (_horizontalGap != value)
            {
				_horizontalGap = value;
				// horizontalGapInitialized = true;
				if(hostComponent)
					updateLayout();
            }
		}

		/**
		 *  @private
		 */
		// private var verticalGapInitialized:Boolean;
		private var _verticalGap:Number = 0;
		/**
		 *  The verticalGap between items.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		[Bindable("verticalGapChanged")]
		public function get verticalGap():Number
		{
			return _verticalGap;
		}
		/**
		 *  @private
		 */
		public function set verticalGap(value:Number):void
		{
			if (_verticalGap != value)
            {
				_verticalGap = value;
				// verticalGapInitialized = true;
				if(hostComponent)
					updateLayout();
            }
		}

		private function updateLayout():void
		{
			layout();
		}

		/**
		 *  Get the component layout style and apply to if exists
		 * 
		 *  @param component the IUIBase component that host this layout
		 *  @param cssProperty the style property in css set for the component to retrieve
		 * 
		 *  @see org.apache.royale.core.layout.ILayoutStyleProperties#applyStyleToLayout(component:IUIBase, cssProperty:String):void
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		// override public function applyStyleToLayout(component:IUIBase, cssProperty:String):void
		// {	
		// 	var cssValue:* = ValuesManager.valuesImpl.getValue(component, cssProperty);
		// 	if (cssValue !== undefined)
		// 	{
		// 		switch(cssProperty)
		// 		{
		// 			case VERTICAL_GAP_STYLE:
		// 				if(!verticalGapInitialized)
		// 				{
		// 					verticalGap = Number(cssValue);
		// 				}
		// 				break;
		// 			default:
		// 				break;
		// 		}	
		// 	}
		// }
		
		/**
		 *  Layout children
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 *  @royaleignorecoercion org.apache.royale.core.ILayoutHost
		 *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		override public function layout():Boolean
		{
			COMPILE::SWF
			{
				var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(host);
				var area:UIBase = layoutView as UIBase;

				var xpos:Number = 0;
				var ypos:Number = 0;
				var useWidth:Number = _columnWidth;
				var useHeight:Number = _rowHeight;
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

				if (isNaN(useWidth)) useWidth = Math.floor(adjustedWidth / _columnCount); // + gap
				if (isNaN(useHeight)) {
					// given the width and total number of items, how many rows?
					var numRows:Number = Math.ceil(realN/_columnCount);
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

					var test:Number = (i+1)%_columnCount;

					if (test == 0) {
						xpos = 0;
						ypos += useHeight;
						maxHeight = Math.max(maxHeight,ypos);
					}
				}

				maxWidth = Math.max(maxWidth, _columnCount*useWidth);
				maxHeight = Math.max(maxHeight, numRows*useHeight);

				// Only return true if the contentView needs to be larger; that new
				// size is stored in the model.
				var sizeChanged:Boolean = true;

				return sizeChanged;
			}
			COMPILE::JS
			{
				// trace(" **** TILE LAYOUT ****");
				
				// trace(" - requestedColumnCount", _requestedColumnCount);
				// trace(" - columnCount", _columnCount);
				// trace(" - columnWidth", _columnWidth);
				// trace(" - horizontalGap", _horizontalGap);

				// trace(" - rowCount", _rowCount);
				// trace(" - rowHeight", _rowHeight);
				// trace(" - verticalGap", _verticalGap);
				
				var i:int;
				var n:int;
				var child:UIBase;
				var useWidth:Number;
				var useHeight:Number;

				var contentView:ILayoutView = layoutView as ILayoutView;
				n = contentView.numElements;

				if (n === 0) return false;

				useWidth = _columnWidth;
				// trace(" - useWidth", useWidth);
				useHeight = _rowHeight;
				// trace(" - useHeight", useHeight);
				var needWidth:Boolean = isNaN(useWidth);
				// trace(" - needWidth", needWidth);
				var needHeight:Boolean = isNaN(useHeight);
				// trace(" - needHeight", needHeight);
				
				var realN:int = n;
				var widestTile:Number = 0; // hold the widest tile
				var tallestTile:Number = 0; // hold the widest tile
				for (i = 0; i < n; i++)
				{
					child = contentView.getElementAt(i) as UIBase;
					if (!child.visible) realN--;
					if (needWidth && child.width > widestTile) widestTile = child.width;
					if (needWidth && child.height > tallestTile) tallestTile = child.height;
				}
				// trace(" - widestTile", widestTile);
				// trace(" - tallestTile", tallestTile);
				
				
				// trace("  -- calculate useWidth & useHeight");
				var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(host);
				var adjustedHostWidth:Number = Math.floor(host.width - borderMetrics.left - borderMetrics.right);
				// trace(" - adjustedWidth", adjustedHostWidth);
				var adjustedHostHeight:Number = Math.floor(host.height - borderMetrics.top - borderMetrics.bottom);
				// trace(" - adjustedHeight", adjustedHostHeight);

				if (needWidth)
				{
					// calculate columnCount based of the widesTile
					_columnCount = _requestedColumnCount != -1 ? _requestedColumnCount : Math.floor(adjustedHostWidth / (widestTile + _horizontalGap));
					useWidth = _requestedColumnCount == -1 ? widestTile : Math.floor((adjustedHostWidth - _horizontalGap) / _columnCount);
				} else {
					// calculate columnCount based on columnWidth
					_columnCount = _requestedColumnCount != -1 ? _requestedColumnCount : Math.floor(adjustedHostWidth/ (_columnWidth + _horizontalGap));
					useWidth = _requestedColumnCount == -1 ? _columnWidth : Math.floor((adjustedHostWidth - _horizontalGap) / _columnCount);
				}
				// trace("  -- _columnCount", _columnCount);
				// trace("  -- useWidth", useWidth);

				// given the width and total number of items, how many rows?
				// _rowCount = _requestedRowCount != -1 ? _requestedRowCount : Math.floor(adjustedHostHeight / (tallestTile + _verticalGap));
				_rowCount = Math.ceil(realN / _columnCount);
				// trace("  -- _rowCount", _rowCount);
				
				if (needHeight)
				{	
					useHeight = tallestTile;
					// if (host.isHeightSizedToContent()) useHeight = 30; // default height
					// else useHeight = Math.floor((adjustedHostHeight + _verticalGap) / numRows);
					// trace("  -- useHeight", useHeight);
				} else {
					// _rowCount = _requestedRowCount != -1 ? _requestedRowCount : Math.floor(adjustedHostHeight / (_rowHeight + _verticalGap));
					useHeight = _rowHeight;
				}
				// trace("  -- useHeight", useHeight);
				
				for (i = 0; i < n; i++)
				{
					child = contentView.getElementAt(i) as UIBase;

					if (!child.visible) continue;
					
					// trace(i, i % _columnCount, i % _rowCount);
					
					// add horizontalGap
					if(i % _columnCount != 0)
						child.positioner.style.marginLeft = _horizontalGap + "px";
					else
						child.positioner.style.marginLeft = null;
					
					// add verticalGap
					if(i >= _columnCount)
						child.positioner.style.marginTop = _verticalGap + "px";
					else
						child.positioner.style.marginTop = null;

					//if the parent width/height not explicitly set, we can't calculate the child width/height
					if(useWidth > 0)
						child.width = _requestedColumnCount == -1 ? useWidth : useWidth - _horizontalGap;
					if(useHeight > 0)
						child.height = useHeight;// - _verticalGap;
						// child.height = _requestedColumnCount == -1 ? useHeight : useHeight - _verticalGap;
					
					// add dummy margin: avoid a tile from the next row stay in the previous row due to flexbox algorithm
					if(i % _columnCount == _columnCount - 1)
						child.positioner.style.marginRight = Math.floor(adjustedHostWidth - (1 + child.width + (child.width + _horizontalGap) * (_columnCount - 1))) + "px";
					else
						child.positioner.style.marginRight = null;
					
					child.dispatchEvent(new Event('sizeChanged'));
				}
				return true;
			}
		}
	}
}
