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
package org.apache.royale.textLayout.elements
{
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;

	

	
	/** 
	 * <p> TableColElement is an item in a TableElement. It only contains the information of the column formats, 
	 * A TableColElement always appears within a TableElement, TableColGroupElement.</p>
	 *
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 */
	public final class TableColElement extends TableFormattedElement implements ITableColElement
	{		
		// public var height:Number;
		private var _x:Number;
		private var _colIndex:int;
		
		public function TableColElement(format:ITextLayoutFormat=null)
		{
			super();
			if(format)
				this.format = format;
		}

		override public function get className():String{
			return "TableColElement";
		}
		/** @private */
		override protected function get abstract():Boolean
		{ return false; }
		
		/** @private */
		public override function get defaultTypeName():String
		{ return "col"; }
		
		/** @private */
		public override function canOwnFlowElement(elem:IFlowElement):Boolean
		{
			return false;
		}
		
		/** @private if its in a numbered list expand the damage to all list items - causes the numbers to be regenerated */
		public override function modelChanged(changeType:String, elem:IFlowElement, changeStart:int, changeLen:int, needNormalize:Boolean = true, bumpGeneration:Boolean = true):void
		{
			super.modelChanged(changeType,elem,changeStart,changeLen,needNormalize,bumpGeneration);
		}
		
		/**
		 * Get a Vector of cells or null if the column contains no cells
		 **/
		public function get cells():Vector.<ITableCellElement> {
			
			if (!table) {
				return null;
			}
			
			return table.getCellsForColumn(this);
		}
		
		/**
		 * Returns the number of cells in this column. 
		 **/
		public function get numCells():int {
			
			if (!table) {
				return 0;
			}
			
			return table.getCellsForColumn(this).length;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(x:Number):void
		{
			this._x = x;
		}

		public function get colIndex():int
		{
			return _colIndex;
		}

		public function set colIndex(colIndex:int):void
		{
			this._colIndex = colIndex;
		}
	}
}
