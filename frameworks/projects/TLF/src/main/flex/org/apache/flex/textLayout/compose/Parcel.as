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
		
	import org.apache.royale.textLayout.container.IContainerController;
//	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.formats.ClearFloats;
	import org.apache.royale.textLayout.formats.Direction;



		
	/** 
	 * Helper class for implementations of IParcelList
	 * 
	 * @private
	 */
	public class Parcel 
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var logicalWidth:Number;

		private var _controller:IContainerController;
		private var _columnIndex:int;
		private var _fitAny:Boolean;
		private var _composeToPosition:Boolean;

		private var _left:Edge;
		private var _right:Edge;
		private var _maxWidth:Number;
		
		private const EDGE_CACHE_MAX:int = 6;		// number of edges we cache
		static private var edgeCache:Vector.<Edge>; // cache to prevent edge allocation/deallocation
		
		private var _verticalText:Boolean;
		
		/** Constructor. */
		public function Parcel(verticalText:Boolean, x:Number, y:Number, width:Number, height:Number, controller:IContainerController, columnIndex:int)
		{
			initialize(verticalText, x, y, width, height, controller, columnIndex);
		}
		
		public function initialize(verticalText:Boolean, x:Number, y:Number, width:Number, height:Number, controller:IContainerController, columnIndex:int):Parcel
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.logicalWidth = verticalText ? height : width;
			this._verticalText = verticalText; 
			
			_controller   = controller;
			_columnIndex  =  columnIndex;
			_fitAny	  = false;
			_composeToPosition = false;
			
			var xmin:Number;
			if (verticalText)
			{
				xmin = y;
				_maxWidth = height;
			}
			else
			{
				xmin = x;
				_maxWidth = width;
			}

			_left = allocateEdge(xmin);
			_right = allocateEdge(xmin + _maxWidth);		
			return this;
		}
		
		
		/** prevent any leaks. @private */
		public function releaseAnyReferences():void
		{
			_controller = null;
			deallocateEdge(_left);
			deallocateEdge(_right);
		}
		
		private function allocateEdge(x:Number):Edge
		{
			if (!edgeCache)
			 edgeCache = new Vector.<Edge>();
			var edge:Edge = (edgeCache.length > 0) ? edgeCache.pop() : new Edge();
			edge.initialize(x);
			return edge;
		}
		
		private function deallocateEdge(edge:Edge):void
		{
			if (edgeCache.length < EDGE_CACHE_MAX)
				edgeCache.push(edge);
		}
		
		public function get bottom():Number	{ return (y + height); }
		public function get right():Number	{ return (x + width); }
		
		public function get controller():IContainerController
		{ return _controller; }

		/** column number in the container */
		public function get columnIndex():int
		{ return _columnIndex; }
		public function get fitAny():Boolean
		{ return _fitAny; }
		public function set fitAny(value:Boolean):void
		{ _fitAny = value; }
		public function get composeToPosition():Boolean
		{ return _composeToPosition; }
		public function set composeToPosition(value:Boolean):void
		{ _composeToPosition = value; }
		/** Do explicit line breaking (no wrapping) */

		private function getLogicalHeight():Number
		{
			if (_verticalText)
			{
				return _controller.measureWidth ? Constants.MAX_LINE_WIDTH : width;
			}
			else
			{
				return _controller.measureHeight ? Constants.MAX_LINE_WIDTH : height;
			}
		}
		
		// Returns the amount to move down to apply clear past any floats
		public function applyClear(clear:String, depth:Number, direction:String):Number
		{
			var leftMargin:Number;
			var rightMargin:Number;
			var adjustedDepth:Number = depth;
			
			if (clear == ClearFloats.START)
				clear = (direction == Direction.LTR) ? ClearFloats.LEFT : ClearFloats.RIGHT;
			else if (clear == ClearFloats.END)
				clear = (direction == Direction.RTL) ? ClearFloats.LEFT : ClearFloats.RIGHT;

			while (adjustedDepth < Number.MAX_VALUE)
			{
				leftMargin = _left.getMaxForSpan(adjustedDepth, adjustedDepth + 1);	// getLeftForSpan
				if (leftMargin > 0 && (clear == ClearFloats.BOTH || clear == ClearFloats.LEFT))
				{
					adjustedDepth = _left.findNextTransition(adjustedDepth);
					continue;
				}
				rightMargin = _right.getMaxForSpan(adjustedDepth, adjustedDepth + 1);	// getRightForSpan
				if (rightMargin > 0 && (clear == ClearFloats.BOTH || clear == ClearFloats.RIGHT))
				{
					adjustedDepth = _right.findNextTransition(adjustedDepth);
					continue;
				}
				
				return adjustedDepth - depth;
			} 
			
			return (_verticalText ? this.width : this.height);	
		}
		
		public function fitsInHeight(depth:Number, minimumHeight:Number):Boolean
		{
			return composeToPosition || depth + minimumHeight <= getLogicalHeight();
		}
		
		// Given a current location, what is the longest longest line of a given height that can be placed there,
		// that is at least as wide as the minimum width. Return false if there is no possible line in the parcel.
		// May shift the line down if thee is more space below.
		public function getLineSlug(slug:Slug, depth:Number, lineHeight:Number, minimumWidth:Number, minimumHeight:Number, leftMargin:Number, rightMargin:Number, textIndent:Number, directionLTR:Boolean, useExplicitLineBreaks:Boolean):Boolean
		{
			if (!fitsInHeight(depth, minimumHeight))
				return false;
			
			slug.height = lineHeight;			

			while (depth < Number.MAX_VALUE)
			{
				slug.depth = depth;

				slug.leftMargin = _left.getMaxForSpan(slug.depth, slug.depth + lineHeight);	// getLeftForSpan
				slug.wrapsKnockOut = slug.leftMargin != 0;
				if (leftMargin > 0)
					slug.leftMargin = Math.max(leftMargin, slug.leftMargin);
				else
					slug.leftMargin += leftMargin;		// negative indent, let it overlap
				slug.rightMargin = _right.getMaxForSpan(slug.depth, slug.depth + lineHeight);	// getRightForSpan
				slug.wrapsKnockOut = slug.wrapsKnockOut || (slug.rightMargin != 0);
				if (rightMargin > 0)
					slug.rightMargin = Math.max(rightMargin, slug.rightMargin);
				else
					slug.rightMargin += rightMargin;		// negative indent, let it overlap
				if (textIndent)
				{
					if (directionLTR)
						slug.leftMargin += textIndent;
					else
						slug.rightMargin += textIndent;
				}

				if (useExplicitLineBreaks || (_verticalText && _controller.measureHeight) || (!_verticalText && _controller.measureWidth))
					slug.width = Constants.MAX_LINE_WIDTH;
				else
					slug.width = this.logicalWidth - (slug.leftMargin + slug.rightMargin);
				if (!minimumWidth || slug.width >= minimumWidth)
					break;
				depth = findNextTransition(depth);
			} 
			
			return (depth < Number.MAX_VALUE);
		}

		public function knockOut(knockOutWidth:Number, yMin:Number, yMax:Number, onLeft:Boolean):void
		{
			var edge:Edge = onLeft ? _left : _right;
			edge.addSpan(knockOutWidth, yMin, yMax);	
		}
		
		public function removeKnockOut(knockOutWidth:Number, yMin:Number, yMax:Number, onLeft:Boolean):void
		{
			var edge:Edge = onLeft ? _left : _right;
			edge.removeSpan(knockOutWidth, yMin, yMax);	
		}
		
		/** Returns true if the parcel has no knockouts */
		public function isRectangular():Boolean
		{
			return (_left.numSpans <= 0 && _right.numSpans <= 0);
		}
		
	/*	public function getLeftForSpan(ymin:Number, ymax:Number):Number
		{
			return _left.getMaxForSpan(ymin, ymax);
		}
		
		public function getRightForSpan(ymin:Number, ymax:Number):Number
		{
			return _right.getMinForSpan(ymin, ymax);
		} */
		
		public function findNextTransition(y:Number):Number
		{
			return Math.min(_left.findNextTransition(y), _right.findNextTransition(y));
		}
		
	}
}

class Span
{
	public var x:Number;
	public var ymin:Number;
	public var ymax:Number;
	
	public function Span(x:Number, ymin:Number, ymax:Number)
	{
		this.x = x;
		this.ymin = ymin;
		this.ymax = ymax;
	}
		
	public function overlapsInY(ymin:Number, ymax:Number):Boolean
	{
		return !(ymax < this.ymin || ymin >= this.ymax);
	}
	
	public function equals(x:Number, ymin:Number, ymax:Number):Boolean
	{
		return x == this.x && ymin == this.ymin && ymax == this.ymax;
	} 
}

//import org.apache.royale.textLayout.utils.Twips;

class Edge
{
	private var _xbase:Number;
	private var _spanList:Vector.<Span>;
	
	public function Edge()
	{
		_spanList = new Vector.<Span>();
	}
	
	public function initialize(xbase:Number):void
	{
		_xbase = xbase;
		_spanList.length = 0;
	}
	
	public function get base():Number
	{
		return _xbase;
	}
	
	public function addSpan(x:Number, ymin:Number, ymax:Number):void
	{
		_spanList.push(new Span(x, ymin, ymax));
	}
	
	public function removeSpan(x:Number, ymin:Number, ymax:Number):void
	{
		for (var i:int=0; i < _spanList.length; ++i)
		{
			if (_spanList[i].equals(x, ymin, ymax))
			{
				_spanList.splice(i,1);
				return;
			}
		}

//		CONFIG::debug { org.apache.royale.textLayout.debug.assert(false, "Deleting a span not in list"); }			
	} 
	
	public function get numSpans():int
	{
		return _spanList.length;
	}
	
	public function getMaxForSpan(ymin:Number, ymax:Number):Number
	{
		var res:Number = 0;
		for each (var span:Span in _spanList)
		{
			if (span.x > res && span.overlapsInY(ymin, ymax))
				res = span.x;
		}
		return res;
	}
	
	/*public function getMinForSpan(ymin:Number, ymax:Number):Number
	{
		var res:Number = _xbase;
		for each (var span:Span in _spanList)
		{
			if (span.x < res && span.overlapsInY(ymin, ymax))
				res = span.x;
		}
		return res;
	} */
	
	public function findNextTransition(y:Number):Number
	{
		var res:Number = Number.MAX_VALUE;
		for each (var s:Span in _spanList)
		{
			if (s.ymin > y && s.ymin < res)
				res = s.ymin;
			if (s.ymax > y && s.ymax < res)
				res = s.ymax;
		}
		return res;
	}
}

