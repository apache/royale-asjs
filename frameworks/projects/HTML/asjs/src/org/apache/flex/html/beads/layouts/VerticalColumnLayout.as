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
	import org.apache.flex.core.IMeasurementBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IContainer;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
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
			var sw:Number = UIBase(_strand).width;
			var sh:Number = UIBase(_strand).height;
				
			var e:IUIBase;
			var i:int;
			var col:int = 0;
			var columns:Array = [];
			for (i = 0; i < numColumns; i++)
				columns[i] = 0;

			var children:Array = IContainer(_strand).getChildren();
			var n:int = children.length;
			
			// determine max widths of columns
			for (i = 0; i < n; i++) {
				e = children[i];
				var thisPrefWidth:int = 0;
				if (e is IStrand)
				{
					var mb:IMeasurementBead = e.getBeadByType(IMeasurementBead) as IMeasurementBead;
					if (mb)
						thisPrefWidth = mb.measuredWidth;
					else
						thisPrefWidth = e.width;						
				}
				else
					thisPrefWidth = e.width;
				
				columns[col] = Math.max(columns[col], thisPrefWidth);
				col = (col + 1) % numColumns;
			}
			
			var curx:int = 0;
			var cury:int = 0;
			var maxHeight:int = 0;
			col = 0;
			for (i = 0; i < n; i++) {
				e = children[i];
				e.x = curx;
				e.y = cury;
				curx += columns[col++];
				maxHeight = Math.max(e.height, maxHeight);
				if (col == numColumns)
				{
					cury += maxHeight;
					maxHeight = 0;
					col = 0;
					curx = 0;
				}
			}
			
			return true;
		}
	}
}