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
package org.apache.flex.html.beads.layouts
{	
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IContainer;
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.IMeasurementBead;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.utils.CSSUtils;
    import org.apache.flex.utils.CSSContainerUtils;    
	
	/**
	 * ColumnLayout is a class that organizes the positioning of children
	 * of a container into a set of columns where each column's width is set to
	 * the maximum size of all of the children in that column.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class VerticalColumnLayout implements IBeadLayout
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function VerticalColumnLayout()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		
		private var _numColumns:int;
		
		/**
		 * The number of columns.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
         * @copy org.apache.flex.core.IBeadLayout#layout
         */
		public function layout():Boolean
		{			
            var host:UIBase = UIBase(_strand);
            var layoutParent:ILayoutHost = host.getBeadByType(ILayoutHost) as ILayoutHost;
            var contentView:IParent = layoutParent.contentView;
            var padding:Rectangle = CSSContainerUtils.getPaddingMetrics(host);
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

            var marginLeft:Object;
            var marginRight:Object;
            var marginTop:Object;
            var marginBottom:Object;
            var margin:Object;
            var ml:Number;
            var mr:Number;
            var mt:Number;
            var mb:Number;
			var n:int = contentView.numElements;
            var rowData:Object = { rowHeight: 0 };
			
			// determine max widths of columns
			for (i = 0; i < n; i++) {
				e = contentView.getElementAt(i) as IUIBase;
                margin = ValuesManager.valuesImpl.getValue(e, "margin");
                marginLeft = ValuesManager.valuesImpl.getValue(e, "margin-left");
                marginTop = ValuesManager.valuesImpl.getValue(e, "margin-top");
                marginRight = ValuesManager.valuesImpl.getValue(e, "margin-right");
                marginBottom = ValuesManager.valuesImpl.getValue(e, "margin-bottom");
                mt = CSSUtils.getTopValue(marginTop, margin, sh);
                mb = CSSUtils.getBottomValue(marginBottom, margin, sh);
                mr = CSSUtils.getRightValue(marginRight, margin, sw);
                ml = CSSUtils.getLeftValue(marginLeft, margin, sw);
                data.push({ mt: mt, mb: mb, mr: mr, ml: ml});
				var thisPrefWidth:int = 0;
				if (e is IStrand)
				{
					var measure:IMeasurementBead = e.getBeadByType(IMeasurementBead) as IMeasurementBead;
					if (measure)
						thisPrefWidth = measure.measuredWidth + ml + mr;
					else
						thisPrefWidth = e.width + ml + mr;						
				}
				else
					thisPrefWidth = e.width + ml + mr;
				
                rowData.rowHeight = Math.max(rowData.rowHeight, e.height + mt + mb);
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
				e = contentView.getElementAt(i) as IUIBase;
				e.x = curx + ml;
				e.y = cury + data[i].mt;
				curx += columns[col++];
                maxHeight = Math.max(maxHeight, e.y + e.height + data[i].mb);
                maxWidth = Math.max(maxWidth, e.x + e.width + data[i].mr);
				if (col == numColumns)
				{
					cury += rows[0].rowHeight;
                    rows.shift();
					col = 0;
					curx = padding.left;
				}
			}
			if (!hasWidth && n > 0 && !isNaN(maxWidth))
            {
                UIBase(contentView).setWidth(maxWidth, true);
            }
            if (!hasHeight && n > 0 && !isNaN(maxHeight))
            {
                UIBase(contentView).setHeight(maxHeight, true);
            }
			return true;
		}
	}
}