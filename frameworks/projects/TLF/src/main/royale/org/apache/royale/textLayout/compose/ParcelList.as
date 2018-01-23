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
package org.apache.royale.textLayout.compose
{
	import org.apache.royale.text.engine.Constants;
	import org.apache.royale.geom.Rectangle;
	
	import org.apache.royale.textLayout.container.ColumnState;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.container.ScrollPolicy;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.TableCellElement;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.LineBreak;

	

			
	/** @private
	 * Used for composing text containers, keeps track of the areas that text in the 
	 * flow is composed into.
	 * 
	 * ParcelList will always have one parcel, which corresponds to the container's
	 * bounding box. 
	 */
	public class ParcelList
	{
		protected var _flowComposer:IFlowComposer;
		
		/** Current vertical position in the parcel. */
		protected var _totalDepth:Number;
		
		/** whether the current parcel has any content */
		protected var _hasContent:Boolean;
		
		/** The list of parcels that are available for text layout.
			They are appear in the array in reading order: the first text goes in the
			first parcel, when it gets filled later text is flowed into the second 
			parcel, and so on.  */
		protected var _parcelArray:Array;	/* of Parcel */
		protected var _numParcels:int;
		protected var _singleParcel:Parcel;
		
		/** Index of the "current" parcel. These next two variables must be kept in sync. */
		protected var _currentParcelIndex:int;
		protected var _currentParcel:Parcel;
		
		protected var _insideListItemMargin:Number;
		
		protected var _leftMargin:Number;
		protected var _rightMargin:Number; 
		
		protected var _explicitLineBreaks:Boolean;
			
		/** True if text is vertical (as for some Japanese & Chinese, false otherwise */
		protected var _verticalText:Boolean;
		
//		private static const MAX_HEIGHT:Number = 900000000;		// vertical scroll max - capped to prevent loss of precision - what should it be?
//		private static const MAX_WIDTH:Number =  900000000;		// horizontal scroll max - capped to prevent loss of precision - what should it be?
			
		// a single parcellist that is checked out and checked in
		static private var _sharedParcelList:ParcelList;

		/** @private */
		static public function getParcelList():ParcelList
		{
			var rslt:ParcelList = _sharedParcelList ? _sharedParcelList : new ParcelList();
			_sharedParcelList = null;
			return rslt;
		}
		
		/** @private */
		static public function releaseParcelList(list:ParcelList):void
		{
			if (_sharedParcelList == null)
			{
				_sharedParcelList = list as ParcelList;
				if (_sharedParcelList)
					_sharedParcelList.releaseAnyReferences();
			}
		}

		/** Constructor. */
		public function ParcelList()
		{ _numParcels = 0;	}
		
		/** prevent any leaks. @private */
		public function releaseAnyReferences():void
		{
			this._flowComposer = null;
			
			_numParcels = 0;
			_parcelArray = null;
			
			if (_singleParcel)
				_singleParcel.releaseAnyReferences();
		}
		
		CONFIG::debug public function getBounds():Array
		{
			var boundsArray:Array = [];
			for (var i:int = 0; i < _numParcels; ++i)
				boundsArray.push(getParcelAt(i));
			return boundsArray;
		}
		
		public function getParcelAt(idx:int):Parcel
		{ return _numParcels <= 1 ? _singleParcel : _parcelArray[idx]; }
				
		public function get currentParcelIndex():int
		{ return _currentParcelIndex; }
		
		public function get explicitLineBreaks():Boolean
		{ 
			return _explicitLineBreaks;
		}
		
		private function get measureLogicalWidth():Boolean
		{
			if (_explicitLineBreaks)
				return true;
			if (!_currentParcel)
				return false;
			var controller:IContainerController = _currentParcel.controller;
			return _verticalText ? controller.measureHeight : controller.measureWidth;
		}

		private function get measureLogicalHeight():Boolean
		{
			if (!_currentParcel)
				return false;
			var controller:IContainerController = _currentParcel.controller;
			return _verticalText ? controller.measureWidth : controller.measureHeight;
		}
		
		public function get totalDepth():Number
		{
			return _totalDepth;
		}
		
		public function addTotalDepth(value:Number):Number
		{
			_totalDepth += value;	
		//	trace("addTotalDepth", value, "newDepth", totalDepth);
			return _totalDepth;
		}
		
		protected function reset():void
		{
			// Composition starts with an initial invalid parcel. It will start by calling next(), which will 
			// advance to the first parcel.
			_totalDepth = 0;
			_hasContent = false;

			_currentParcelIndex = -1;
			_currentParcel = null;
			
			_leftMargin = 0;
			_rightMargin = 0;
			_insideListItemMargin = 0;
		}
		
		public function addParcel(column:Rectangle, controller:IContainerController, columnIndex:int):Parcel
		{
			var newParcel:Parcel = _numParcels == 0 && _singleParcel 
				? _singleParcel.initialize(_verticalText, column.x,column.y,column.width,column.height,controller,columnIndex) 
				: new Parcel(_verticalText, column.x, column.y, column.width, column.height, controller, columnIndex);
			if (_numParcels == 0)
				_singleParcel = newParcel;
			else if (_numParcels == 1)
				_parcelArray = [  _singleParcel, newParcel ];
			else
				_parcelArray.push(newParcel);
			_numParcels++;
			return newParcel;
		}
		
		// Return numbers of parcels in this parcel list
		public function numParcels():int
		{
			return this._numParcels;
		}
		
		// Pop up top most parcel
		public function popParcel():Parcel
		{
			_numParcels -- ;
			return _parcelArray.pop();
		}
		
		public function addTableCell2ColumnState(controller:IContainerController, cell:TableCellElement):void
		{
			var columnState:ColumnState = controller.columnState;
			if (columnState)
				columnState.pushTableCell(cell);
		}
		protected function addOneControllerToParcelList(controllerToInitialize:IContainerController):void
		{
			// Initialize new parcels for columns
			var columnState:ColumnState = controllerToInitialize.columnState;
			columnState.clearCellList();
			for (var columnIndex:int = 0; columnIndex < columnState.columnCount; columnIndex++)
			{
				var column:Rectangle = columnState.getColumnAt(columnIndex);
				if (!column.isEmpty())
					addParcel(column, controllerToInitialize, columnIndex);
			}
		}
		
		public function beginCompose(composer:IFlowComposer, controllerStartIndex:int, controllerEndIndex:int, composeToPosition:Boolean):void
		{
			_flowComposer = composer;
			
			var rootFormat:ITextLayoutFormat = composer.rootElement.computedFormat;
			_explicitLineBreaks = rootFormat.lineBreak == LineBreak.EXPLICIT;
			_verticalText   = (rootFormat.blockProgression == BlockProgression.RL);
			
			if (composer.numControllers != 0)
			{
				// if controllerEndIndex is not specified then assume we are composing to position and add all controllers
				if (controllerEndIndex < 0)
					controllerEndIndex = composer.numControllers-1;
				else
					controllerEndIndex = Math.min(controllerEndIndex,composer.numControllers-1);
				var idx:int = controllerStartIndex;
				do
				{
					addOneControllerToParcelList(IContainerController(composer.getControllerAt(idx)));
				} while (idx++ != controllerEndIndex);
				// adjust the last container for scrolling
				if (controllerEndIndex == composer.numControllers-1)
					adjustForScroll(composer.getControllerAt(composer.numControllers-1), composeToPosition);
			}
			reset();
		}
		
		/** Adjust the size of the parcel corresponding to the last column of the containter, in 
		 * order to account for scrolling.
		 */
		private function adjustForScroll(containerToInitialize:IContainerController, composeToPosition:Boolean):void
		{			
			// Expand the last parcel if scrolling could be enabled. Expand to twice what would fit in available space. 
			// We will start composing from the top, so if we've scrolled down there will be more to compose.
			// We turn on fitAny, so that lines will be included in the container even if only a tiny portion of the line
			// fits. This makes lines that are only partially scrolling in appear. We turn on composeToPosition if we're
			// forcing composition to go through a given position -- this will make all lines fit, and composition will
			// continue until it is past the supplied position.
			var p:Parcel;
			if (_verticalText)
			{
				if (containerToInitialize.horizontalScrollPolicy != ScrollPolicy.OFF)
				{
					p = getParcelAt(_numParcels-1);
					if (p)
					{
						var horizontalPaddingAmount:Number = containerToInitialize.getTotalPaddingRight() + containerToInitialize.getTotalPaddingLeft();
						var right:Number = p.right;
						p.x = containerToInitialize.horizontalScrollPosition - p.width - horizontalPaddingAmount;
						p.width = right - p.x;
						p.fitAny = true;
						p.composeToPosition = composeToPosition;
					}
				}
			}
			else
			{
				if (containerToInitialize.verticalScrollPolicy != ScrollPolicy.OFF)
				{
					p = getParcelAt(_numParcels-1);
					if (p)
					{
						var verticalPaddingAmount:Number = containerToInitialize.getTotalPaddingBottom() + containerToInitialize.getTotalPaddingTop();
						p.height = (containerToInitialize.verticalScrollPosition + p.height + verticalPaddingAmount) - p.y;
						p.fitAny = true;
						p.composeToPosition = composeToPosition;
					}
				}
			}
		}

		public function get leftMargin():Number
		{
			return _leftMargin;
		}
		
		public function pushLeftMargin(leftMargin:Number):void
		{
			_leftMargin += leftMargin;	
		}
		
		public function popLeftMargin(leftMargin:Number):void
		{
			_leftMargin -= leftMargin;	
		}
					
		public function get rightMargin():Number
		{
			return _rightMargin;
		}
		
		public function pushRightMargin(rightMargin:Number):void
		{
			_rightMargin += rightMargin;	
		}
		
		public function popRightMargin(rightMargin:Number):void
		{
			_rightMargin -= rightMargin;	
		}
		
		public function pushInsideListItemMargin(margin:Number):void
		{ _insideListItemMargin += margin; }
		public function popInsideListItemMargin(margin:Number):void
		{ _insideListItemMargin -= margin; }	
		public function get insideListItemMargin():Number
		{ return _insideListItemMargin; }
		
		public		function getComposeXCoord(o:Rectangle):Number
		{ 
			// trace("LPL: getComposeXCoord");
			return _verticalText ? o.right : o.left;
		}
		public		function getComposeYCoord(o:Rectangle):Number
		{ 
			// trace("LPL: getComposeYCoord");
			return o.top;
		}

		public function getComposeWidth(o:Rectangle):Number
		{ 
			// trace("LPL: getComposeWidth");
			if (measureLogicalWidth)
				return Constants.MAX_LINE_WIDTH;
			return _verticalText ? o.height : o.width; 
		}

		public function getComposeHeight(o:Rectangle):Number
		{ 
			// trace("LPL: getComposeHeight");
			if (measureLogicalHeight)
				return Constants.MAX_LINE_WIDTH;
			return _verticalText ? o.width : o.height; 
		}		

		/** Returns true if the current parcel is the last.
		*/
		public function atLast():Boolean
		{
			return _numParcels == 0 || _currentParcelIndex == _numParcels -1;
		}
		
		public function atEnd():Boolean
		{
			return _numParcels == 0 || _currentParcelIndex >= _numParcels;
		}
		
		public function gotoParcel(index:int, depth:Number = 0):Boolean
		{
			if ( index < 0 || index >= _numParcels )
				return false;
			
			_currentParcel = this.getParcelAt(index);
			if ( _currentParcel == null )
				return false;
			_currentParcelIndex = index;
			
			_totalDepth = depth;
			
			return true;
		}
		
		public function next():Boolean
		{
			CONFIG::debug { assert(_currentParcelIndex >= -1 && _currentParcelIndex < _numParcels, "invalid _currentParcelIndex in ParcelList"); }			
			var nextParcelIsValid:Boolean = (_currentParcelIndex + 1) < _numParcels;

			_currentParcelIndex += 1;
			_totalDepth = 0;

			if (nextParcelIsValid)
			{
				_currentParcel = getParcelAt(_currentParcelIndex);
			}
			else
				_currentParcel = null;
	
			return nextParcelIsValid;
		}
		
		public function get currentParcel():Parcel
		{ return _currentParcel; }

		/**Return the slug rectangle for a line that goes at the current vertical location,
		 * and could extend down for at least height pixels. Note that this function
		 * can change the current parcel, and the location within the parcel.
		 * @param slugRect result rectangle where line was fit
		 * @param height	amount of contiguous vertical space that must be available
		 * @param minWidth	amount of contiguous horizontal space that must be available 
		 * @return true if a line slug was fit horizontal space actually available
		 */
		public function getLineSlug(slug:Slug, height:Number, minWidth:Number, textIndent:Number, directionLTR:Boolean):Boolean
		{
			if (currentParcel.getLineSlug(slug, _totalDepth, height, minWidth, currentParcel.fitAny ? 1 : int(height), _leftMargin, _rightMargin, textIndent+_insideListItemMargin, directionLTR,  _explicitLineBreaks))
			{
				if (totalDepth != slug.depth)
					_totalDepth = slug.depth;
				return true;
			}
			return false;
		}
	
		// Attempts to fit a float of the specified width and height in the current parcel. Float is considered to fit if it
		// is alone on the line but exceeds the parcel width and fits within the logical height.
		// Returns success or failure.
		public function fitFloat(slug:Slug, totalDepth:Number, width:Number, height:Number):Boolean
		{
			return currentParcel.getLineSlug(slug, totalDepth, height, width, currentParcel.fitAny ? 1 : int(height), _leftMargin, _rightMargin, 0, true, _explicitLineBreaks);
		}
				
	}	//end class
} //end package
