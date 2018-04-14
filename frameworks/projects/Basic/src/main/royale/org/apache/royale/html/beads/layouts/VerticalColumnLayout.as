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
	import org.apache.royale.core.IContainer;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.IMeasurementBead;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.utils.CSSUtils;
	
	COMPILE::JS {
		import org.apache.royale.core.WrappedHTMLElement;
	}

	/**
	 * ColumnLayout is a class that organizes the positioning of children
	 * of a container into a set of columns where each column's width is set to
	 * the maximum size of all of the children in that column.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class VerticalColumnLayout extends LayoutBase implements IBeadLayout
	{
		/**
		 *  constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function VerticalColumnLayout()
		{
			super();
		}


		private var _numColumns:int;

		/**
		 * The number of columns.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get numColumns():int
		{
			return _numColumns;
		}
		public function set numColumns(value:int):void
		{
			_numColumns = value;
		}

        /**
         * @copy org.apache.royale.core.IBeadLayout#layout
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion org.apache.royale.core.IMeasurementBead
         * @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
         */
		override public function layout():Boolean
		{
			var contentView:ILayoutView = layoutView;
			COMPILE::JS {
				if (contentView.element.style.position != "absolute" && contentView.element.style.position != "relative") {
					contentView.element.style.position = "relative";
				}
				contentView.element.style["vertical-align"] = "top";
			}
			
            var padding:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPaddingMetrics(host);
			var sw:Number = host.width;
			var sh:Number = host.height;

            var hasWidth:Boolean = !host.isWidthSizedToContent();
            var hasHeight:Boolean = !host.isHeightSizedToContent();
			var e:IUIBase;
			var i:int;
			var col:int = 0;
			var columns:Array = [];
            var rows:Array = [];
            var data:Array = [];
			for (i = 0; i < numColumns; i++)
				columns[i] = 0;

			var n:int = contentView.numElements;
            var rowData:Object = { rowHeight: 0 };

			//cache values to prevent layout thrashing
			var views:Array = [];
			var heights:Array = [];
			var widths:Array = [];
			// determine max widths of columns
			for (i = 0; i < n; i++) {
				views[i] = contentView.getElementAt(i);
				heights[i] = views[i].height;
				widths[i] = views[i].width;
				e = views[i];
				if (e == null || !e.visible) continue;
				var margins:Object = childMargins(e, sw, sh);
				
                data.push({ mt: margins.top, mb: margins.bottom, mr: margins.right, ml: margins.left});
				var thisPrefWidth:int = 0;
				if (e is IStrand)
				{
					var measure:IMeasurementBead = e.getBeadByType(IMeasurementBead) as IMeasurementBead;
					if (measure)
						thisPrefWidth = measure.measuredWidth + margins.left + margins.right;
					else
						thisPrefWidth = widths[i] + margins.left + margins.right;
				}
				else
					thisPrefWidth = widths[i] + margins.left + margins.right;

                rowData.rowHeight = Math.max(rowData.rowHeight, heights[i] + margins.top + margins.bottom);
				columns[col] = Math.max(columns[col], thisPrefWidth);
                col = col + 1;
                if (col == numColumns)
                {
                    rows.push(rowData);
                    rowData = {rowHeight: 0};
                    col = 0;
                }
			}

            var lastmb:Number = 0;
			var curx:int = padding.left;
			var cury:int = padding.top;
			var maxHeight:int = 0;
            var maxWidth:int = 0;
			col = 0;
			for (i = 0; i < n; i++)
            {
				e = views[i];
				if (e == null || !e.visible) continue;
				e.x = curx + data[i].ml;
				e.y = cury + data[i].mt;
				curx += columns[col++];
                maxHeight = Math.max(maxHeight, e.y + heights[i] + data[i].mb);
                maxWidth = Math.max(maxWidth, e.x + widths[i] + data[i].mr);
				if (col == numColumns)
				{
					cury += rows[0].rowHeight;
                    rows.shift();
					col = 0;
					curx = padding.left;
				}
				COMPILE::JS {
					e.element.style.position = "absolute";
				}
			}
			return true;
		}
	}
}
