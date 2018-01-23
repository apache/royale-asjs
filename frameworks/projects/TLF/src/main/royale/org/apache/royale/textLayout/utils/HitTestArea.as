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
package org.apache.royale.textLayout.utils {
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.FlowElement;

	

	
	// [ExcludeClass]
	/**
	 * The HitTestArea class is a lightweight implementation of the Warnock
	 * algorithm for rectangles. It is used for hit-testing in FlowElements, which 
	 * may contain multiple child elements. The algorithm attempts to set the logical
	 * midpoint to be outside of a bounding rectangle to avoid having to split too many rectangles.
	 * Note that the code is optimized for non-overlapping rectangles;
	 * the determination of the logical midpoint does not work well for overlapping
	 * rectangles because the algorithm breaks once it found a rectangle that contains
	 * the geometric midpoint.
	 * 
	 * The pseudocode for this algorithm is:
	 * 
	 * if !(point in this rectangle) return false;
	 * if !(hasKids) return true;
	 * determine the quadrant where the point is in (top left "tl", top right "tr",
	 * bottom left "bl", or bottom right "br");
	 * if this[quadrant] == null, return false; // no rectangle covers this area
	 * else return this[quadrant].hitTest(x,y);
	 * 
	 * To avoid having to create a 4-element array for the four quadrants, the code
	 * constructs the property name and accesses the property with dynamic lookup.
	 */
	public class HitTestArea
	{
//		private var tl:HitTestArea = null;	// top left quadrant	// NO PMD
//		private var tr:HitTestArea = null;	// top right quadrant	// NO PMD
//		private var bl:HitTestArea = null;	// bottom left quadrant	// NO PMD
//		private var br:HitTestArea = null;	// bottom right quadrant	// NO PMD
		
		private var _rect:Rectangle;	// the bounding rectangle
		private var _xm:Number;			// logical midpoint
		private var _ym:Number;
		
		/**
		 * The owning FlowElement is the element whose area this HitTestArea
		 * covers. This variable is set for a rectangle if the structure passed
		 * in to the constructor contains an "owner" property. If it is null,
		 * the instance has child quadrants.
		 */
		private var _owner:FlowElement = null;
		
		CONFIG::debug
		{
//			static private var _depth:int = 0;
			/**
			 * This array takes the counts for recursion depths on hit testing.
			 */
			static public const depths:Array = [];	
		}		
		/**
		 * Create a HitTestArea with an object containing enumerable property objects as a rectangle
		 * in a "rect" property, and a a FlowElement in its "owner" property. First, 
		 * determine the bounding rectangle; then, determine the midpoint, and fill
		 * in each quadrant with the intersecting rectangles.
		 * @param obj    An object containing {rect:Rectangle, owner:FlowElement} objects as property values.
		 */
		public function HitTestArea(objects:Object)
		{
			initialize(objects);
		}
		
		/** @private */
		public function initialize(objects:Object):void
		{
			var obj:Object;
			// determine the number of objects; all we need to know is 0, 1, or more
			var count:int = 0;
			if (objects)
			{
				for (obj in objects)
				{
					if (++count > 1)
						break;
				}
			}
			
			if (count == 0)
			{
				_rect = new Rectangle();
				_xm = _ym = 0;
				return;
			}
			
			// Determine the bounding rectangle
			// if the object only has one element, it is easy
			if (count == 1)
			{
				for each (obj in objects)
				{
					_rect = obj.rect;
					_xm = _rect.left;
					_ym = _rect.top;
					_owner = obj.owner;
					CONFIG::debug { assert(_owner != null, "No owner given"); }
					return;
				}
			}
			
			var r:Rectangle;
			// if more than one element, we need to calulate and fill
			for each (obj in objects)
			{
				r = obj.rect;
				if (!_rect)
					_rect = r;
				else
					_rect = _rect.union(r);
			}
			
			// Set the geometric midpoint
			_xm = Math.ceil(_rect.left + _rect.width / 2);
			_ym = Math.ceil(_rect.top + _rect.height / 2);
			
			// Hard stop here: if the bounding rectangle is < 3 pixels in any direction,
			// we consider it to be a single rectangle.
			if (_rect.width <= 3 || _rect.height <= 3)
			{
				// Here, we set the owner to the first element's owner
				for each (obj in objects)
				{
					_owner = obj.owner;
					CONFIG::debug { assert(_owner != null, "No owner given"); }
					return;
				}
			}
			
			// Determine the logical midpoint. This point is as close to
			// the geometric midpoint as possible. If the midpoint is inside 
			// a rectangle, the midpoint is adjusted to the nearest point 
			// outside of the rectangle if possible to avoid excessive 
			// splitting of rectangles. The first point is used as the new
			// midpoint to avoid having to deal with overlapping rectangles,
			// which should usually not appear at all.
			for each (obj in objects)
			{
				r = obj.rect;
				if (r.equals(_rect))
					continue;
				
				if (r.contains(_xm, _ym))
				{
					// The midpoint is over a rectangle; find the closest
					// rectangle boundary and move the midpoint there
					var dxLower:Number = _xm - r.left;
					var dxUpper:Number = r.right - _xm;
					var dyLower:Number = _ym - r.top;
					var dyUpper:Number = r.bottom - _ym;
					// this may lead to _xm and/or _ym being equal to left/top
					_xm = (dxLower > dxUpper) ? _xm + dxUpper : _xm - dxLower;
					_ym = (dyLower > dyUpper) ? _ym + dyUpper : _ym - dyLower;
					// this should be changed if overlapping rectangles need to be supported
					// in that case, all rectangles that have a hit shouldd be checked to
					// determine the closest boundary
					break;
				}
			}
			
			// Insert all rectangles into the respective quadrants
			var quadrant:Rectangle = new Rectangle(_rect.left, _rect.top, _xm - _rect.left, _ym - _rect.top);
			addQuadrant(objects, "tl", quadrant);
			quadrant.left = _xm;
			quadrant.right = _rect.right;
			addQuadrant(objects, "tr", quadrant);
			quadrant.left = _rect.left;
			quadrant.top = _ym;
			quadrant.right = _xm;
			quadrant.bottom = _rect.bottom;
			addQuadrant(objects, "bl", quadrant);
			quadrant.left = _xm;
			quadrant.right = _rect.right;
			addQuadrant(objects, "br", quadrant);
		}
		
		/**
		 * Do a hit test. If the point is within this rectangle, determine
		 * the quadrant of the point. If the quadrant is empty, the hit test
		 * is true. If not, recurse into that quadrant.
		 * @param x    the X coordinate
		 * @param y    the Y coordinate
		 * @return     the owner if the hit test succeeds, null otherwise
		 */
		public function hitTest(x:Number, y:Number):FlowElement
		{
			if (!_rect.contains(x, y))
				return null;
			// if there are no kids (the owner is set), the rectangle has been hit
			// no need to attempt to retrieve the quadrant
			if (_owner)
				return _owner;
			// determine quadrant
			var quadrantName:String = (y < _ym) ? "t" : "b";
			quadrantName += (x < _xm) ? "l" : "r";
			var quadrant:HitTestArea = this[quadrantName];
			// there is no child rectangle here: no hit
			if (quadrant == null)
				return null;
			// ask the child
			return quadrant.hitTest(x, y);
		}

		/* Use this version to track hit testing in debug code
		public function hitTest(x:Number, y:Number, depth:int=1):FlowElement
		{
			if (!_rect.contains(x, y))
			{
				trace("Depth " + depth + ": " + x + "," + y);
				return null;
			}
			// if there are no kids (the owner is set), the rectangle has been hit
			// no need to attempt to retrieve the quadrant
			if (_owner)
			{
				trace("Depth " + depth + ": " + x + "," + y + ": " + _owner);
				if (depths[depth] == undefined)
					depths[depth] = 0;
				depths[depth]++;
				return _owner;
			}
			// determine quadrant
			var quadrantName:String = (y < _ym) ? "t" : "b";
			quadrantName += (x < _xm) ? "l" : "r";
			var quadrant:HitTestArea = this[quadrantName];
			// there is no child rectangle here: no hit
			if (quadrant == null)
			{
				trace("Depth " + depth + ": " + x + "," + y);
				return null;
			}
			// ask the child
			return quadrant.hitTest(x, y, depth+1);
		}
		*/
		/** @private
		 * Add the given objects of rectangles to the given quadrant. Create an array of
		 * intersecting rectangles, and, if that array if not empty, create a new
		 * HitTestArea covering these rectangles, and store it into the quadrant
		 * property. Note that this method is recursive.
		 * @param arr        An object of rectangle objects.
		 * @param propName   The name of the quadrant property (tl, tr, bl, br).
		 * @param quadrant   The bounding rectangle for this quadrant.
		 */
		private function addQuadrant(objects:Object, propName:String, quadrant:Rectangle):void
		{
			if (quadrant.isEmpty())
				return;
			
			// Collect the objects of intersecting rectangles
			var qrects:Object = {};
			var i:int = 0;
			for each (var obj:Object in objects)
			{
				var intersect:Rectangle = obj.rect.intersection(quadrant);
				if (!intersect.isEmpty())
					qrects[i++] = {owner:obj.owner, rect:intersect};
			}
			if (i > 0)
				this[propName] = new HitTestArea(qrects);
		}
	}
}
