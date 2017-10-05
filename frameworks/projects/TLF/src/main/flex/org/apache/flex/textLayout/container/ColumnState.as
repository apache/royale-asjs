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
package org.apache.royale.textLayout.container
{
	import org.apache.royale.geom.Rectangle;
	
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.TableCellElement;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.Direction;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.LineBreak;

	import org.apache.royale.textLayout.utils.Twips;
		


	/** 
	 * The ColumnState class calculates the sizes and locations of columns using
	 * the width of the container and the container attributes. You can create instances of this class 
	 * independently to calculate column values, or you can get the column values that 
	 * were used for the text after the container has been composed or updated (redrawn).
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 * @see ContainerController
	 */

	public class ColumnState 
	{
		// input information
		private var _inputsChanged:Boolean;
		private var _blockProgression:String;
		private var _columnDirection:String;
		private var _paddingTop:Number;
		private var _paddingBottom:Number;
		private var _paddingLeft:Number;
		private var _paddingRight:Number;
		private var _compositionWidth:Number;
		private var _compositionHeight:Number;
		private var _forceSingleColumn:Boolean;
		
		private var _inputColumnWidth:Object;
		private var _inputColumnGap:Number;
		private var _inputColumnCount:Object;
		
		// Generated column information		
		private var _columnWidth:Number;	
		private var _columnCount:int;		
		private var _columnGap:Number;	
		private var _inset:Number;
		
		// and the array of columns
		private var _columnArray:Array;
		private var _tableCellArray:Array;
		private var _singleColumn:Rectangle;
		
		/**
		 * Constructor function - creates a ColumnState object.
		 *
		 * If the values of <code>controller.compositionWidth</code> and <code>controller.compositionHeight</code> equal
		 * <code>NaN</code> (not a number), the constructor measures the container's contents to determine the actual 
		 * composition width and height that feed into ColumnState.
		 *
		 * Use the constants defined by the <code>org.apache.royale.textLayout.formats.BlockProgression</code> class to 
		 * specify the value of the <code>blockProgression</code> parameter. Use the constants defined by
		 * <code>org.apache.royale.textLayout.formats.Direction</code> to specify the value of the <code>columnDirection</code> 
		 * parameter.
		 *
		 * @param blockProgression The direction of lines for the textflow, either BlockProgression.TB (top-to-bottom) or 
		 * 		BlockProgression.RL (right-to-left).
		 * @param columnDirection The direction of column layout for the text flow, either Direction.RTL (right-to-left) or 
		 * 		Direction.LTR (left-to-right).
		 * @param controller A ContainerController instance whose attributes are used to calculate the column values.
		 * @param compositionWidth The horizontal extent, in pixels, allowed for text inside the container.
		 * @param compositionHeight The vertical extent, in pixels, allowed for text inside the container.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see org.apache.royale.textLayout.formats.BlockProgression BlockProgression
		 * @see org.apache.royale.textLayout.formats.Direction Direction
	 	 */
		
		public function ColumnState(blockProgression:String, columnDirection:String, controller:IContainerController, compositionWidth:Number, compositionHeight:Number)
		{
			_inputsChanged = true;
			_columnCount = 0;

			if (blockProgression != null)		// if values are legit, recalculate now. They might not be, if this is called from a containerController constructor.
			{		
				updateInputs(blockProgression, columnDirection, controller, compositionWidth, compositionHeight);
				computeColumns();
			}
		}
		
		/** 
		 * The width of columns, in pixels, in the container. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public function get columnWidth():Number
		{ return _columnWidth; }

		/** 
		 * The number of columns in the container. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public function get columnCount():int
		{ return _columnCount; }
		
		/** 
		 * The number of cells in the container. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		public function get cellCount():int
		{ 
			if ( _tableCellArray )
				return _tableCellArray.length;
			return -1;
		}

		/** 
		 * The amount of space, in pixels, left between columns in the container.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public function get columnGap():Number
		{ return _columnGap; }
		
		/** 
		 * Returns the area that a column takes within the container. Allows you to access the area for a 
		 * specific column.
		 *
		 * @param index The relative position of the column among all columns in the container, with the first
		 * 	column at position 0.
		 *
		 * @return The area of the specified column.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		 
		public function getColumnAt(index:int):Rectangle
		{
			return _columnCount == 1 ? _singleColumn : _columnArray[index];
		}
		
		public function getCellAt(index:int):TableCellElement
		{
			return _tableCellArray[index];
		}
		
		public function pushTableCell(cell:TableCellElement):void
		{
			if ( _tableCellArray == null )
				_tableCellArray = new Array();
			_tableCellArray.push(cell);
		}
		
		public function clearCellList():void
		{
			_tableCellArray = null;
		}

		/** Recalculate actual column settings based on attributes and width
		 * from the container. Call this after either the attributes or the
		 * width has been changed to get the new values.
		 *
		 * @param newBlockProgression block progression for the textflow
		 * @param newColumnDirection column layout direction for the textflow
		 * @param containerAttr		Formatting attributes from the container
		 * @param containerWidth		Width of the container
		 * @return Boolean			true if the actual column settings have changed
		 * @private 
		 */
		public function updateInputs(newBlockProgression:String, newColumnDirection:String, controller:IContainerController, newCompositionWidth:Number, newCompositionHeight:Number ):void
		{
			var newPaddingTop:Number = controller.getTotalPaddingTop();
			var newPaddingBottom:Number = controller.getTotalPaddingBottom();
			var newPaddingLeft:Number = controller.getTotalPaddingLeft();
			var newPaddingRight:Number = controller.getTotalPaddingRight();
			
			var containerAttr:ITextLayoutFormat = controller.computedFormat;
			
			var newColumnWidth:Object = containerAttr.columnWidth;
			var newColumnGap:Number = containerAttr.columnGap;
			var newColumnCount:Object = containerAttr.columnCount;
			
			var newForceSingleColumn:Boolean = ((containerAttr.columnCount == FormatValue.AUTO && (containerAttr.columnWidth == FormatValue.AUTO || Number(containerAttr.columnWidth) == 0)) ||
				controller.rootElement.computedFormat.lineBreak == LineBreak.EXPLICIT) || isNaN(newBlockProgression == BlockProgression.RL ? newCompositionHeight : newCompositionWidth);
			
			if (_inputsChanged == false) 
				_inputsChanged = newCompositionWidth != _compositionHeight || newCompositionHeight != _compositionHeight
				|| _paddingTop != newPaddingTop || _paddingBottom != newPaddingBottom || _paddingLeft != newPaddingLeft || _paddingRight != newPaddingRight
				|| _blockProgression != _blockProgression || _columnDirection != newColumnDirection || _forceSingleColumn != newForceSingleColumn
				|| _inputColumnWidth != newColumnWidth || _inputColumnGap != newColumnGap || _inputColumnCount != newColumnCount;
				
			if (_inputsChanged)
			{
				_blockProgression = newBlockProgression;
				_columnDirection = newColumnDirection;
				_paddingTop = newPaddingTop;
				_paddingBottom = newPaddingBottom;
				_paddingLeft = newPaddingLeft;
				_paddingRight = newPaddingRight;
				_compositionWidth = newCompositionWidth;
				_compositionHeight = newCompositionHeight;
				_forceSingleColumn = newForceSingleColumn;
				
				_inputColumnWidth = newColumnWidth;
				_inputColumnGap = newColumnGap;
				_inputColumnCount = newColumnCount;
			}
		}

		/** Compute the actual columns based on the input values @private */
		public function computeColumns():void
		{
			if (!_inputsChanged)
				return;
				
			// Recalculate all the column settings. Returns true if settings have changed as a result.
			// See http://www.w3.org/TR/2005/WD-css3-multicol-20051215/#the-number
			var newColumnGap:Number;
			var newColumnCount:int;
			var newColumnWidth:Number;
			
			// calculate the width to divy the columns up among
			var totalColumnWidth:Number = _blockProgression == BlockProgression.RL ? _compositionHeight : _compositionWidth;
			// inset to use
			var newColumnInset:Number   = _blockProgression == BlockProgression.RL ? _paddingTop + _paddingBottom : _paddingLeft + _paddingRight;
				
			totalColumnWidth = (totalColumnWidth > newColumnInset && !isNaN(totalColumnWidth)) ? totalColumnWidth - newColumnInset : 0;
			
			// columnCount is auto && columnWidth is auto || 0 --> one column
			if (_forceSingleColumn)
			{
				// This case deviates from the spec.  Spec is no columns.  
				// TextLayout does either one auto full width column or a zero width column
				newColumnCount = 1;
				newColumnWidth = totalColumnWidth; 
				newColumnGap = 0;
			}
			else
			{
				newColumnGap   = _inputColumnGap;
				
				if (_inputColumnWidth == FormatValue.AUTO)		// auto
				{
					newColumnCount = Number(_inputColumnCount);
					// Column width is not specified, we'll use columnCount and columnGap to figure it out
					if ((newColumnCount-1)*newColumnGap < totalColumnWidth)
					{
						newColumnWidth = (totalColumnWidth - (newColumnCount-1)*newColumnGap) / newColumnCount;
					}
					else if (newColumnGap > totalColumnWidth)
					{
						newColumnCount = 1;
						newColumnWidth = totalColumnWidth;
						newColumnGap = 0;
					}
					else
					{
						newColumnCount = Math.floor(totalColumnWidth/newColumnGap);
						newColumnWidth = (totalColumnWidth-(newColumnCount-1)*newColumnGap)/newColumnCount;
						// newColumnGap = newColumnCount == 1 ? 0 : (totalColumnWidth - newColumnWidth*newColumnCount) / (newColumnCount-1);
					}
				}
				else if (_inputColumnCount == FormatValue.AUTO)	// auto
				{
					newColumnWidth = Number(_inputColumnWidth);
					if (newColumnWidth >= totalColumnWidth)
					{
						newColumnCount = 1;
						newColumnWidth = totalColumnWidth;
						newColumnGap   = 0;
					}
					else
					{
						newColumnCount = Math.floor((totalColumnWidth+newColumnGap)/(newColumnWidth+newColumnGap));
						newColumnWidth = ((totalColumnWidth+newColumnGap)/newColumnCount) - newColumnGap;
					}
				}
				else
				{
					newColumnCount = Number(_inputColumnCount);
					newColumnWidth = Number(_inputColumnWidth);
					if (newColumnCount*newColumnWidth+(newColumnCount-1)*newColumnGap <= totalColumnWidth)
					{
						// done
					}
					else if (newColumnWidth >= totalColumnWidth)
					{
						newColumnCount = 1;
						newColumnGap = 0;
						// use newColumnWidth
					}
					else
					{
						newColumnCount = Math.floor( (totalColumnWidth+newColumnGap) / (newColumnWidth+newColumnGap) );
						newColumnWidth = ((totalColumnWidth+newColumnGap) / newColumnCount) - newColumnGap;
					}
				}
			}
				
			_columnWidth = newColumnWidth;
			_columnCount = newColumnCount;
			_columnGap = newColumnGap;
			_inset = newColumnInset;			
	
			// setup these values for each case
			var xPos:Number;
			var yPos:Number;
			var delX:Number;
			var delY:Number;
			var colH:Number;
			var colW:Number;
			
			// scratch vars
			var insetHeight:Number;
			
			// TODO: USE DIRECTION!!!
			if (_blockProgression == BlockProgression.TB)
			{
				if (_columnDirection == Direction.LTR)
				{
					xPos = _paddingLeft;
					delX = _columnWidth + _columnGap;
					colW = _columnWidth;
				}
				else
				{
					CONFIG::debug { assert(_columnDirection == Direction.RTL,"bad columndirection in ColumnState.computeColumns"); }
					xPos = isNaN(_compositionWidth) ? _paddingLeft : _compositionWidth-_paddingRight-_columnWidth;
					delX = -(_columnWidth + _columnGap);
					colW = _columnWidth;
				}
				yPos = _paddingTop;
				delY = 0;
				insetHeight = _paddingTop + _paddingBottom;
				colH = (_compositionHeight > insetHeight && !isNaN(_compositionHeight)) ? (_compositionHeight - insetHeight) : 0;
			}
			else if (_blockProgression == BlockProgression.RL)
			{
				xPos = isNaN(_compositionWidth) ? -_paddingRight : _paddingLeft -_compositionWidth;
				yPos = _paddingTop;
				delX = 0;
				delY = _columnWidth + _columnGap;
				insetHeight = _paddingLeft + _paddingRight;
				colW = (_compositionWidth > insetHeight) ? (_compositionWidth - insetHeight) : 0;
				colH = _columnWidth;
			}
			
			// make colW and colH just off zero so that we don't get empties
			if (colW == 0)
			{
				colW = Twips.ONE_TWIP;	// MINIMUM VALUE OF ONE TWIP
				if (_blockProgression == BlockProgression.RL)
					xPos -= colW;
			}
			if (colH == 0)
				colH = Twips.ONE_TWIP;	// MINIMUM VALUE OF ONE TWIP
			
			if (_columnCount == 1)
			{
				_singleColumn = new Rectangle(xPos, yPos, colW, colH);
				_columnArray = null;
			}
			else if (_columnCount == 0)
			{
				_singleColumn = null;
				_columnArray = null;
			}
			else
			{
				if (_columnArray)
					_columnArray.splice(0);
				else
					_columnArray = new Array();
				for (var i:int = 0; i < _columnCount; ++i)
				{
					_columnArray.push(new Rectangle(xPos, yPos, colW, colH));
					xPos += delX;
					yPos += delY;
				}
			}	
		}
	}
		

} // end package
