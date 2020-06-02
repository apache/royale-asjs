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
	 *  The TileLayout class bead sizes and positions the elements it manages into rows and columns.
	 *  The size of each element is determined either by setting TileLayout's columnWidth and rowHeight
	 *  properties, or having the tile size determined by factoring the columnCount into the area assigned
	 *  for the layout.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class TileLayout extends StyledLayoutBase implements ILayoutStyleProperties
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function TileLayout()
		{
			super();
		}

		public static const LAYOUT_TYPE_NAMES:String = "layout tile";

		/**
		 *  Add class selectors when the component is addedToParent
		 *  Otherwise component will not get the class selectors when 
		 *  perform "removeElement" and then "addElement"
		 * 
 		 *  @langversion 3.0
 		 *  @playerversion Flash 10.2
 		 *  @playerversion AIR 2.6
 		 *  @productversion Royale 0.9.4
 		 */
		override public function beadsAddedHandler(event:Event = null):void
		{
			super.beadsAddedHandler();

			COMPILE::JS
			{
			if (hostComponent.containsClass("layout"))
				hostComponent.removeClass("layout");
			hostComponent.addClass("layout");
			if(hostComponent.containsClass("tile"))
				hostComponent.removeClass("tile");
			hostComponent.addClass("tile");
			}
		}

		private var _columnCount:Number = 4;
		/**
		 *  The number of tiles to fit horizontally into the layout.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get columnCount():Number
		{
			return _columnCount;
		}
		public function set columnCount(value:Number):void
		{
			_columnCount = value;
			layout();
		}

		private var _columnWidth:Number = Number.NaN;
		/**
		 *  The width of each column, in pixels. If left unspecified, the
		 *  columnWidth is determined by dividing the columnCount into the
		 *  strand's bounding box width.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get columnWidth():Number
		{
			return _columnWidth;
		}
		public function set columnWidth(value:Number):void
		{
			_columnWidth = value;
			layout();
		}

		private var _rowCount:Number = 4;
		/**
		 *  The number of tiles to fit horizontally into the layout.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get rowCount():Number
		{
			return _rowCount;
		}
		public function set rowCount(value:Number):void
		{
			_rowCount = value;
			layout();
		}

		private var _rowHeight:Number = Number.NaN;
		/**
		 *  The height of each row, in pixels. If left unspecified, the
		 *  rowHeight is determine by dividing the possible number of rows
		 *  into the strand's bounding box height.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get rowHeight():Number
		{
			return _rowHeight;
		}
		public function set rowHeight(value:Number):void
		{
			_rowHeight = value;
			layout();
		}

		/**
		 *  @private
		 */
		private var verticalGapInitialized:Boolean;
		public static const VERTICAL_GAP_STYLE:String = "verticalGap"
		private var _verticalGap:Number = 0;
		/**
		 *  The verticalGap between items.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get verticalGap():Number
		{
			return _verticalGap;
		}
		/**
		 *  @private
		 */
		public function set verticalGap(value:Number):void
		{
			_verticalGap = value;
			verticalGapInitialized = true;
		}

		/**
		 *  @private
		 */
		private var horizontalGapInitialized:Boolean;
		public static const HORIZONTAL_GAP_STYLE:String = "horizontalGap"
		private var _horizontalGap:Number = 0;
		/**
		 *  The horizontalGap between items.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get horizontalGap():Number
		{
			return _horizontalGap;
		}
		/**
		 *  @private
		 */
		public function set horizontalGap(value:Number):void
		{
			_horizontalGap = value;
			horizontalGapInitialized = true;
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
		 *  @productversion Royale 0.9.4
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
		 *  @productversion Royale 0.9.4
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

				if (isNaN(useWidth)) useWidth = Math.floor(adjustedWidth / columnCount); // + gap
				if (isNaN(useHeight)) {
					// given the width and total number of items, how many rows?
					var numRows:Number = Math.ceil(realN/columnCount);
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

					var test:Number = (i+1)%columnCount;

					if (test == 0) {
						xpos = 0;
						ypos += useHeight;
						maxHeight = Math.max(maxHeight,ypos);
					}
				}

				maxWidth = Math.max(maxWidth, columnCount*useWidth);
				maxHeight = Math.max(maxHeight, numRows*useHeight);

				// Only return true if the contentView needs to be larger; that new
				// size is stored in the model.
				var sizeChanged:Boolean = true;

				return sizeChanged;
			}
			COMPILE::JS
			{
				trace(" **** TILE LAYOUT ****");
				trace(" - columnCount", columnCount);
				trace(" - columnWidth", columnWidth);
				trace(" - horizontalGap", horizontalGap);
				trace(" - rowCount", rowCount);
				trace(" - rowHeight", rowHeight);
				trace(" - verticalGap", verticalGap);
				var i:int;
				var n:int;
				var child:UIBase;
				var useWidth:Number;
				var useHeight:Number;

				var contentView:ILayoutView = layoutView as ILayoutView;
				n = contentView.numElements;

				if (n === 0) return false;

				var realN:int = n;
				for (i = 0; i < n; i++)
				{
					child = contentView.getElementAt(i) as UIBase;
					if (!child.visible) realN--;
				}

				useWidth = columnWidth;
				trace(" - useWidth", useWidth);
				useHeight = rowHeight;
				trace(" - useHeight", useHeight);
				var needWidth:Boolean = isNaN(useWidth);
				trace(" - needWidth", needWidth);
				var needHeight:Boolean = isNaN(useHeight);
				trace(" - needHeight", needHeight);
				if(needHeight || needWidth)
				{
				trace("  -- calculate useWidth & useHeight");
					var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(host);
					var adjustedWidth:Number = Math.floor(host.width - borderMetrics.left - borderMetrics.right);
					trace(" - adjustedWidth", adjustedWidth);
					var adjustedHeight:Number = Math.floor(host.height - borderMetrics.top - borderMetrics.bottom);
					trace(" - adjustedHeight", adjustedHeight);
					if (needWidth)
					{
						useWidth = Math.floor(adjustedWidth / columnCount) + horizontalGap; // + gap
						trace("  -- useWidth", useWidth);
					}
					
					if (needHeight)
					{
						// given the width and total number of items, how many rows?
						var numRows:Number = Math.ceil(realN / columnCount);
						trace("  -- numRows", numRows);
						if (host.isHeightSizedToContent()) useHeight = 30; // default height
						else useHeight = Math.floor(adjustedHeight / numRows) + verticalGap;
						trace("  -- useHeight", useHeight);
					}
				}
				
				trace("  -- useHeight", useHeight);
				for (i = 0; i < n; i++)
				{
					child = contentView.getElementAt(i) as UIBase;

					if (!child.visible) continue;
					
					trace(i, i % columnCount, i % rowCount);
					
					// add horizontalGap
					if(i % (columnCount - 1) != 0)
						child.positioner.style.marginLeft = horizontalGap + "px";
					else
						child.positioner.style.marginLeft = null;
					
					// add verticalGap
					if(i % (columnCount - 1) != 0)
						child.positioner.style.marginTop = verticalGap + "px";
					else
						child.positioner.style.marginTop = null;

					//child.setDisplayStyleForLayout('inline-flex');
					//if the parent width/height not explicitly set, we can't calculate the child width/height
					if(useWidth > 0)
						child.width = useWidth;
					if(useHeight > 0)
						child.height = useHeight;
					child.dispatchEvent('sizeChanged');
				}
				return true;
			}
		}
	}
}
