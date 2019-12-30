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
	COMPILE::JS
	{
	import org.apache.royale.core.WrappedHTMLElement;
	}
	import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.layout.ILayoutStyleProperties;

	/**
	 *  The TileLayout class bead sizes and positions the elements it manages into rows and columns.
	 *  The size of each element is determined either by setting TileLayout's columnWidth and rowHeight
	 *  properties, or having the tile size determined by factoring the numColumns into the area assigned
	 *  for the layout.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class TileLayout extends LayoutBase implements ILayoutStyleProperties
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

		private var _numColumns:Number = 4;
		private var _columnWidth:Number = Number.NaN;
		private var _rowHeight:Number = Number.NaN;

		/**
		 *  The number of tiles to fit horizontally into the layout.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
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
		 *  @productversion Royale 0.9.4
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
		 *  @productversion Royale 0.9.4
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
		 *  @private
		 */
		private var _paddingTop:Number = 0;

		/**
		 *  The top padding value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get paddingTop():Number
		{
			return _paddingTop;
		}

		/**
		 *  @private
		 */
		public function set paddingTop(value:Number):void
		{
			_paddingTop = value;
		}

		/**
		 *  @private
		 */
		private var _paddingRight:Number = 0;

		/**
		 *  The right padding value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get paddingRight():Number
		{
			return _paddingRight;
		}

		/**
		 *  @private
		 */
		public function set paddingRight(value:Number):void
		{
			_paddingRight = value;
		}

		/**
		 *  @private
		 */
		private var _paddingBottom:Number = 0;

		/**
		 *  The top padding value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}

		/**
		 *  @private
		 */
		public function set paddingBottom(value:Number):void
		{
			_paddingBottom = value;
		}

		/**
		 *  @private
		 */
		private var _paddingLeft:Number = 0;

		/**
		 *  The left padding value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}

		/**
		 *  @private
		 */
		public function set paddingLeft(value:Number):void
		{
			_paddingLeft = value;
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
		public function applyStyleToLayout(component:IUIBase, cssProperty:String):void
		{	
			var cssValue:* = ValuesManager.valuesImpl.getValue(component, cssProperty);
			if (cssValue !== undefined)
			{
				switch(cssProperty)
				{
					case VERTICAL_GAP_STYLE:
						if(!verticalGapInitialized)
						{
							verticalGap = Number(cssValue);
						}
						break;
					default:
						break;
				}	
			}
		}

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

				if (isNaN(useWidth)) useWidth = Math.floor(adjustedWidth / numColumns); // + verticalGap
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
				var contentView:IParentIUIBase = layoutView as IParentIUIBase;
				var c:UIBase = (contentView as UIBase);
				c.element.classList.add("layout");
				c.element.classList.add("tile");
				
				var children:Array = contentView.internalChildren();
				var i:int;
				var n:int = children.length;
				if (n === 0) return false;

				var realN:int = n;
				for (i = 0; i < n; i++)
				{
					child = children[i].royale_wrapper;
					if (!child.visible) realN--;
				}
				
				var useWidth:Number = columnWidth;
				var useHeight:Number = rowHeight;
				var needWidth:Boolean = isNaN(useWidth);
				var needHeight:Boolean = isNaN(useHeight);
				
				// given the width and total number of items, how many rows?
				var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(host);
				var adjustedWidth:Number = Math.floor(host.width - borderMetrics.left - borderMetrics.right);
				var adjustedHeight:Number = Math.floor(host.height - borderMetrics.top - borderMetrics.bottom);
				var numRows:Number = Math.ceil(realN / (numColumns + _verticalGap));
				
				if(needWidth || needHeight)
				{
					if (needWidth)
						useWidth = Math.floor(adjustedWidth / numColumns);// + _horizontalGap;
					
					if (needHeight)
					{
						if (host.isHeightSizedToContent()) 
							useHeight = 30; // default height
						else 
							useHeight = Math.floor(adjustedHeight / numRows);// + _verticalGap;
					}
				}

				var child:UIBase;
				var numCols:Number = Math.floor(1+(adjustedWidth - useWidth) / (useWidth + _horizontalGap));
				
				for (i = 0; i < n; i++)
				{
					child = children[i].royale_wrapper;
					if (!child.visible) continue;
					child.width = useWidth;
					child.height = useHeight;

					var childW:WrappedHTMLElement = children[i];
					if (childW == null) continue;
					
					if(i < numCols)
					{
						childW.style.marginTop = _paddingTop + 'px';
					}
					else
					{
						childW.style.marginTop = _verticalGap + 'px';
					}

					if(i % numCols)
					{
						childW.style.marginLeft = _horizontalGap + 'px';
					}
					else
					{
						childW.style.marginLeft = _paddingLeft + 'px';
					}

					childW.royale_wrapper.dispatchEvent('sizeChanged');				
				}
				return true;
			}
		}
	}
}
