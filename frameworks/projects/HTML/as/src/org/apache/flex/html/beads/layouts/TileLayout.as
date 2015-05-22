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
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	/**
	 *  The TileLayout class bead sizes and positions the elements it manages into rows and columns.
	 *  The size of each element is determined either by setting TileLayout's columnWidth and rowHeight
	 *  properties, or having the tile size determined by factoring the numColumns into the area assigned
	 *  for the layout.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class TileLayout implements IBeadLayout
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function TileLayout()
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
		
		private var _numColumns:Number = 4;
		private var _columnWidth:Number = Number.NaN;
		private var _rowHeight:Number = Number.NaN;
		
		/**
		 *  The number of tiles to fit horizontally into the layout.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
         * @copy org.apache.flex.core.IBeadLayout#layout
         */
		public function layout():Boolean
		{
			// this is where the layout is calculated
			var p:ILayoutParent = _strand.getBeadByType(ILayoutParent) as ILayoutParent;
			var area:UIBase = p.contentView as UIBase;
			
			var xpos:Number = 0;
			var ypos:Number = 0;
			var useWidth:Number = columnWidth;
			var useHeight:Number = rowHeight;
			var n:Number = area.numChildren;
			if (n == 0) return false;
			
			var realN:Number = n;
			for(var j:int=0; j < n; j++)
			{
				var testChild:IUIBase = area.getChildAt(i) as IUIBase;
				if (testChild && !testChild.visible) realN--;
			}
			
			if (isNaN(useWidth)) useWidth = Math.floor(area.width / numColumns); // + gap
			if (isNaN(useHeight)) {
				// given the width and total number of items, how many rows?
				var numRows:Number = Math.floor(realN/numColumns);
				useHeight = Math.floor(area.height / numRows);
			}
			
			for(var i:int=0; i < n; i++)
			{
				var child:IUIBase = area.getChildAt(i) as IUIBase;
				if (child && !child.visible) continue;
				child.width = useWidth;
				child.height = useHeight;
				child.x = xpos;
				child.y = ypos;
				
				xpos += useWidth;
				
				var test:Number = (i+1)%numColumns;
				
				if (test == 0) {
					xpos = 0;
					ypos += useHeight;
				} 
			}
            return true;
		}
	}
}
