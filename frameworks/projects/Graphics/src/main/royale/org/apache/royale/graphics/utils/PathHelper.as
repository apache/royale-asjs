/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.royale.graphics.utils
{
	import flash.display.GraphicsPath;
	import flash.geom.Rectangle;

	public class PathHelper
	{
		private static var segments:PathSegmentsCollection;
		private static var graphicsPath:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
		
		public static function getSegments(data:String, x:Number=0, y:Number=0):GraphicsPath
		{
			segments = new PathSegmentsCollection(data);
			segments.generateGraphicsPath(graphicsPath, x, y, 1, 1);
			return graphicsPath;	
		}
		
		public static function getBounds(data:String):Rectangle
		{
			segments = new PathSegmentsCollection(data);
			return segments.getBounds();
		}
	}
}


//--------------------------------------------------------------------------
//
//  Internal Helper Class - PathSegmentsCollection
//
//--------------------------------------------------------------------------

/**
 *  Helper class that takes in a string and stores and generates a vector of
 *  Path segments.
 *  Provides methods for generating GraphicsPath and calculating bounds. 
 */
class PathSegmentsCollection
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 * 
	 *  @param value 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public function PathSegmentsCollection(value:String)
	{
		if (!value)
		{
			_segments = new Vector.<PathSegment>();
			return;
		}
		
		var newSegments:Vector.<PathSegment> = new Vector.<PathSegment>();
		var charCount:int = value.length;
		var c:Number; // current char code, String.charCodeAt() returns Number.
		var useRelative:Boolean;
		var prevIdentifier:Number = 0;
		var prevX:Number = 0;
		var prevY:Number = 0;
		var lastMoveX:Number = 0;
		var lastMoveY:Number = 0;
		var x:Number;
		var y:Number;
		var controlX:Number;
		var controlY:Number;
		var control2X:Number;
		var control2Y:Number;
		var lastMoveSegmentIndex:int = -1;
		
		_dataLength = charCount;
		_charPos = 0;
		while (true)
		{
			// Skip any whitespace or commas first
			skipWhiteSpace(value);
			
			// Are we done parsing?
			if (_charPos >= charCount)
				break;
			
			// Get the next character
			c = value.charCodeAt(_charPos++);
			
			// Is this a start of a number? 
			// The RegExp for a float is /[+-]?\d*\.?\d+([Ee][+-]?\d+)?/
			if ((c >= 0x30 && c < 0x3A) ||   // A digit
				(c == 0x2B || c == 0x2D) ||  // '+' & '-'
				(c == 0x2E))                 // '.'
			{
				c = prevIdentifier;
				_charPos--;
			}
			else if (c >= 0x41 && c <= 0x56) // Between 'A' and 'V' 
				useRelative = false;
			else if (c >= 0x61 && c <= 0x7A) // Between 'a' and 'v'
				useRelative = true;
			
			switch(c)
			{
				case 0x63:  // c
				case 0x43:  // C
					controlX = getNumber(useRelative, prevX, value);
					controlY = getNumber(useRelative,  prevY, value);
					control2X = getNumber(useRelative, prevX, value);
					control2Y = getNumber(useRelative, prevY, value);
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new CubicBezierSegment(controlX, controlY, 
						control2X, control2Y,
						x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x63;
					
					break;
				
				case 0x6D:  // m
				case 0x4D:  // M
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new MoveSegment(x, y));
					prevX = x;
					prevY = y;
					// If a moveto is followed by multiple pairs of coordinates, 
					// the subsequent pairs are treated as implicit lineto commands.
					prevIdentifier = (c == 0x6D) ? 0x6C : 0x4C; // c == 'm' ? 'l' : 'L'
					
					// Fix for bug SDK-24457:
					// If the Quadratic segment is isolated, the Player
					// won't draw fill correctly. We need to generate
					// a dummy line segment.
					var curSegmentIndex:int = newSegments.length - 1;
					if (lastMoveSegmentIndex + 2 == curSegmentIndex && 
						newSegments[lastMoveSegmentIndex + 1] is QuadraticBezierSegment)
					{
						// Insert a dummy LineSegment
						newSegments.splice(lastMoveSegmentIndex + 1, 0, new LineSegment(lastMoveX, lastMoveY));
						curSegmentIndex++;
					}
					
					lastMoveSegmentIndex = curSegmentIndex;
					lastMoveX = x;
					lastMoveY = y;
					break;
				
				case 0x6C:  // l
				case 0x4C:  // L
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new LineSegment(x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x6C;
					break;
				
				case 0x68:  // h
				case 0x48:  // H
					x = getNumber(useRelative, prevX, value);
					y = prevY;
					newSegments.push(new LineSegment(x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x68;
					break;
				
				case 0x76:  // v
				case 0x56:  // V
					x = prevX;
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new LineSegment(x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x76;
					break;
				
				case 0x71:  // q
				case 0x51:  // Q
					controlX = getNumber(useRelative, prevX, value);
					controlY = getNumber(useRelative, prevY, value);
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new QuadraticBezierSegment(controlX, controlY, x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x71;
					break;
				
				case 0x74:  // t
				case 0x54:  // T
					// control is a reflection of the previous control point
					if (prevIdentifier == 0x74 || prevIdentifier == 0x71) // 't' or 'q'
					{
						controlX = prevX + (prevX - controlX);
						controlY = prevY + (prevY - controlY);
					}
					else
					{
						controlX = prevX;
						controlY = prevY;
					}
					
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new QuadraticBezierSegment(controlX, controlY, x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x74;
					
					break;
				
				case 0x73:  // s
				case 0x53:  // S
					if (prevIdentifier == 0x73 || prevIdentifier == 0x63) // s or c
					{
						controlX = prevX + (prevX - control2X);
						controlY = prevY + (prevY - control2Y);
					}
					else
					{
						controlX = prevX;
						controlY = prevY;
					}
					
					control2X = getNumber(useRelative, prevX, value);
					control2Y = getNumber(useRelative, prevY, value);
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new CubicBezierSegment(controlX, controlY,
						control2X, control2Y, x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x73;
					
					break;
				case 0x61:	//a
				case 0x41:	//A
					var rx:Number = getNumber(useRelative, prevX, value);
					var ry:Number = getNumber(useRelative, prevY, value);
					var angle:Number = getNumber(useRelative, prevY, value);
					var largeArcFlag:Boolean = getNumber(useRelative, prevY, value) == 1 ? true:false;
					var sweepFlag:Boolean = getNumber(useRelative, prevY, value) == 1 ? true:false;
					var endX:Number = getNumber(useRelative, prevX, value);
					var endY:Number = getNumber(useRelative, prevY, value);
					newSegments.push(new EllipticalArcSegment(rx,ry,angle,largeArcFlag,sweepFlag,endX,endY));
					prevX = endX;
					prevY = endY;
					prevIdentifier = 0x41;
					break;
				case 0x7A:  // z
				case 0x5A:  // Z
					x = lastMoveX;
					y = lastMoveY;
					newSegments.push(new LineSegment(x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x7A;
					
					break;
				
				default:
					// unknown identifier, throw error?
					_segments = new Vector.<PathSegment>();
					return;
			}
		}
		
		// Fix for bug SDK-24457:
		// If the Quadratic segment is isolated, the Player
		// won't draw fill correctly. We need to generate
		// a dummy line segment.
		curSegmentIndex = newSegments.length;
		if (lastMoveSegmentIndex + 2 == curSegmentIndex && 
			newSegments[lastMoveSegmentIndex + 1] is QuadraticBezierSegment)
		{
			// Insert a dummy LineSegment
			newSegments.splice(lastMoveSegmentIndex + 1, 0, new LineSegment(lastMoveX, lastMoveY));
			curSegmentIndex++;
		}
		
		_segments = newSegments;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  data
	//----------------------------------
	
	private var _segments:Vector.<PathSegment>;
	
	/**
	 *  A Vector of the actual path segments. May be empty, but always non-null. 
	 */
	public function get data():Vector.<PathSegment>
	{
		return _segments;
	}
	
	//----------------------------------
	//  bounds
	//----------------------------------
	
	private var _bounds:Rectangle;
	
	/**
	 *  The bounds of the segments in local coordinates.  
	 */
	public function getBounds():Rectangle
	{
		if (_bounds)
			return _bounds;
		
		// First, allocate temporary bounds, as getBoundingBox() requires
		// natual bounds to calculate a scaling factor
		_bounds = new Rectangle(0, 0, 1, 1);
		
		// Pass in the same size to getBoundingBox
		// so that the scaling factor is (1, 1).
		_bounds = getBoundingBox(1, 1, null /*Matrix*/);
		return _bounds;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @return Returns the axis aligned bounding box of the segments stretched to 
	 *  width, height and then transformed with transformation matrix m.
	 */
	public function getBoundingBox(width:Number, height:Number, m:Matrix):Rectangle
	{
		var naturalBounds:Rectangle = getBounds();
		var sx:Number = naturalBounds.width == 0 ? 1 : width / naturalBounds.width;
		var sy:Number = naturalBounds.height == 0 ? 1 : height / naturalBounds.height; 
		
		var prevSegment:PathSegment;
		var pathBBox:Rectangle;
		var count:int = _segments.length;
		
		for (var i:int = 0; i < count; i++)
		{
			var segment:PathSegment = _segments[i];
			pathBBox = segment.getBoundingBox(prevSegment, sx, sy, m, pathBBox);
			prevSegment = segment;
		}
		
		// If path is empty, it's untransformed bounding box is (0,0), so we return transformed point (0,0)
		if (!pathBBox)
		{
			var x:Number = m ? m.tx : 0;
			var y:Number = m ? m.ty : 0;
			pathBBox = new Rectangle(x, y);
		}
		return pathBBox;
	}
	
	/**
	 *  Workhorse method that iterates through the <code>segments</code>
	 *  array and draws each path egment based on its control points. 
	 *  
	 *  Segments are drawn from the x and y position of the path. 
	 *  Additionally, segments are drawn by taking into account the scale  
	 *  applied to the path. 
	 * 
	 *  @param tx A Number representing the x position of where this 
	 *  path segment should be drawn
	 *  
	 *  @param ty A Number representing the y position of where this  
	 *  path segment should be drawn
	 * 
	 *  @param sx A Number representing the scaleX at which to draw 
	 *  this path segment 
	 * 
	 *  @param sy A Number representing the scaleY at which to draw this
	 *  path segment
	 */
	public function generateGraphicsPath(graphicsPath:GraphicsPath,
										 tx:Number, 
										 ty:Number, 
										 sx:Number, 
										 sy:Number):void
	{
		graphicsPath.commands = null;
		graphicsPath.data = null;
		
		// Always start by moving to drawX, drawY. Otherwise
		// the path will begin at the previous pen location
		// if it does not start with a MoveSegment.
		graphicsPath.moveTo(tx, ty);
		
		var curSegment:PathSegment;
		var prevSegment:PathSegment;
		var count:int = _segments.length;
		for (var i:int = 0; i < count; i++)
		{
			prevSegment = curSegment;
			curSegment = _segments[i];
			curSegment.draw(graphicsPath, tx, ty, sx, sy, prevSegment);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private methods
	//
	//--------------------------------------------------------------------------
	
	private var _charPos:int = 0;
	private var _dataLength:int = 0;
	
	private function skipWhiteSpace(data:String):void
	{
		while (_charPos < _dataLength)
		{
			var c:Number = data.charCodeAt(_charPos);
			if (c != 0x20 && // Space
				c != 0x2C && // Comma
				c != 0xD  && // Carriage return
				c != 0x9  && // Tab
				c != 0xA)    // New line
			{
				break;
			}
			_charPos++;
		}
	}
	
	private function getNumber(useRelative:Boolean, offset:Number, value:String):Number
	{
		// Parse the string and find the first occurrance of the following RexExp
		// numberRegExp:RegExp = /[+-]?\d*\.?\d+([Ee][+-]?\d+)?/g;
		
		skipWhiteSpace(value); // updates _charPos
		if (_charPos >= _dataLength)
			return NaN;
		
		// Remember the start of the number
		var numberStart:int = _charPos;
		var hasSignCharacter:Boolean = false;
		var hasDigits:Boolean = false;
		
		// The number could start with '+' or '-' (the "[+-]?" part of the RegExp)
		var c:Number = value.charCodeAt(_charPos);
		if (c == 0x2B || c == 0x2D) // '+' or '-'
		{
			hasSignCharacter = true;
			_charPos++;
		}
		
		// The index of the '.' if any
		var dotIndex:int = -1;
		
		// First sequence of digits and optional dot in between (the "\d*\.?\d+" part of the RegExp)
		while (_charPos < _dataLength)
		{
			c = value.charCodeAt(_charPos);
			
			if (c >= 0x30 && c < 0x3A) // A digit
			{
				hasDigits = true;
			}
			else if (c == 0x2E && dotIndex == -1) // '.'
			{
				dotIndex = _charPos;
			}
			else
				break;
			
			_charPos++;
		}
		
		// Now check whether we had at least one digit.
		if (!hasDigits)
		{
			// Go to the end of the data
			_charPos = _dataLength;
			return NaN;
		}
		
		// 1. Was the last character a '.'? If so, rewind one character back.
		if (c == 0x2E)
			_charPos--;
		
		// So far we have a valid number, remember its end character index
		var numberEnd:int = _charPos;
		
		// Check to see if we have scientific notation (the "([Ee][+-]?\d+)?" part of the RegExp)
		if (c == 0x45 || c == 0x65)
		{
			_charPos++;
			
			// Check for '+' or '-'
			if (_charPos < _dataLength)
			{            
				c = value.charCodeAt(_charPos);
				if (c == 0x2B || c == 0x2D)
					_charPos++;
			}
			
			// Find all the digits
			var digitStart:int = _charPos;
			while (_charPos < _dataLength)
			{
				c = value.charCodeAt(_charPos);
				
				// Not a digit?
				if (!(c >= 0x30 && c < 0x3A))
				{
					break;
				}
				
				_charPos++;
			}
			
			// Do we have at least one digit?
			if (digitStart < _charPos)
				numberEnd = _charPos; // Scientific notation, update the end index of the number.
			else
				_charPos = numberEnd; // No scientific notation, rewind back to the end index of the number.
		}
		
		// Use parseFloat to get the actual number.
		// TODO (egeorgie): we could build the number while matching the RegExp which will save the substr and parseFloat
		var subString:String = value.substr(numberStart, numberEnd - numberStart);
		var result:Number = parseFloat(subString);
		if (isNaN(result))
		{
			// Go to the end of the data
			_charPos = _dataLength;
			return NaN;
		}
		_charPos = numberEnd;
		return useRelative ? result + offset : result;
	}
}

//--------------------------------------------------------------------------
//
//  Internal Helper Class - PathSegment 
//
//--------------------------------------------------------------------------
import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Rectangle;


/**
 *  The PathSegment class is the base class for a segment of a path.
 *  This class is not created directly. It is the base class for 
 *  MoveSegment, LineSegment, CubicBezierSegment and QuadraticBezierSegment.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 1.0.0
 */
class PathSegment
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 * 
	 *  @param _x The x position of the pen in the current coordinate system.
	 *  
	 *  @param _y The y position of the pen in the current coordinate system.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public function PathSegment(_x:Number = 0, _y:Number = 0)
	{
		super();
		x = _x;  
		y = _y; 
	}   
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  x
	//----------------------------------
	
	/**
	 *  The ending x position for this segment.
	 *
	 *  @default 0
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public var x:Number = 0;
	
	//----------------------------------
	//  y
	//----------------------------------
	
	/**
	 *  The ending y position for this segment.
	 *
	 *  @default 0
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public var y:Number = 0;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Draws this path segment. You can determine the current pen position by 
	 *  reading the x and y values of the previous segment. 
	 *
	 *  @param g The graphics context to draw into.
	 *  @param prev The previous segment drawn, or null if this is the first segment.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
	{
		// Override to draw your segment
	}
	
	/**
	 *  @param prev The previous segment drawn, or null if this is the first segment.
	 *  @param sx Pre-transform scale factor for x coordinates.
	 *  @param sy Pre-transform scale factor for y coordinates.
	 *  @param m Transformation matrix.
	 *  @param rect If non-null, rect is expanded to include the bounding box of the segment.
	 *  @return Returns the union of rect and the axis aligned bounding box of the post-transformed
	 *  path segment.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */    
	public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number, m:Matrix, rect:Rectangle):Rectangle
	{
		// Override to calculate your segment's bounding box.
		return rect;
	}
	
	/**
	 *  Returns the tangent for the segment. 
	 *  @param prev The previous segment drawn, or null if this is the first segment.
	 *  @param start If true, returns the tangent to the start point, otherwise the tangend to the end point.
	 *  @param sx Pre-transform scale factor for x coordinates.
	 *  @param sy Pre-transform scale factor for y coordinates.
	 *  @param m Transformation matrix.
	 *  @param result The tangent is returned as vector (x, y) in result.
	 */
	public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
	{
		result.x = 0;
		result.y = 0;
	}
}


//--------------------------------------------------------------------------
//
//  Internal Helper Class - LineSegment 
//
//--------------------------------------------------------------------------

import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;


/**
 *  The LineSegment draws a line from the current pen position to the coordinate located at x, y.
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 1.0.0
 */
class LineSegment extends PathSegment
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 *  
	 *  @param x The current location of the pen along the x axis. The <code>draw()</code> method uses 
	 *  this value to determine where to draw to.
	 * 
	 *  @param y The current location of the pen along the y axis. The <code>draw()</code> method uses 
	 *  this value to determine where to draw to.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public function LineSegment(x:Number = 0, y:Number = 0)
	{
		super(x, y);
	}   
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @inheritDoc
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	override public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
	{
		graphicsPath.lineTo(dx + x*sx, dy + y*sy);
	}
	
	/**
	 *  @inheritDoc
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	override public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number, m:Matrix, rect:Rectangle):Rectangle
	{
		pt = MatrixUtil.transformPoint(x * sx, y * sy, m);
		var x1:Number = pt.x;
		var y1:Number = pt.y;
		
		// If the previous segment actually draws, then only add the end point to the rectangle,
		// as the start point would have been added by the previous segment:
		if (prev != null && !(prev is MoveSegment))
			return MatrixUtil.rectUnion(x1, y1, x1, y1, rect); 
		
		var pt:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m);
		var x2:Number = pt.x;
		var y2:Number = pt.y;
		
		return MatrixUtil.rectUnion(Math.min(x1, x2), Math.min(y1, y2),
			Math.max(x1, x2), Math.max(y1, y2), rect); 
	}
	
	/**
	 *  Returns the tangent for the segment. 
	 *  @param prev The previous segment drawn, or null if this is the first segment.
	 *  @param start If true, returns the tangent to the start point, otherwise the tangend to the end point.
	 *  @param sx Pre-transform scale factor for x coordinates.
	 *  @param sy Pre-transform scale factor for y coordinates.
	 *  @param m Transformation matrix.
	 *  @param result The tangent is returned as vector (x, y) in result.
	 */
	override public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
	{
		var pt0:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m).clone();
		var pt1:Point = MatrixUtil.transformPoint(x * sx, y * sy, m);
		
		result.x = pt1.x - pt0.x;
		result.y = pt1.y - pt0.y;
	}
}

//--------------------------------------------------------------------------
//
//  Internal Helper Class - MoveSegment 
//
//--------------------------------------------------------------------------
import flash.display.GraphicsPath;

/**
 *  The MoveSegment moves the pen to the x,y position. This class calls the <code>Graphics.moveTo()</code> method 
 *  from the <code>draw()</code> method.
 * 
 *  
 *  @see flash.display.Graphics
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 1.0.0
 */
class MoveSegment extends PathSegment
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 *  
	 *  @param x The target x-axis location in 2-d coordinate space.
	 *  
	 *  @param y The target y-axis location in 2-d coordinate space.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public function MoveSegment(x:Number = 0, y:Number = 0)
	{
		super(x, y);
	}   
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @inheritDoc
	 * 
	 *  The MoveSegment class moves the pen to the position specified by the
	 *  x and y properties.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	override public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
	{
		graphicsPath.moveTo(dx+x*sx, dy+y*sy);
	}
}

//--------------------------------------------------------------------------
//
//  Internal Helper Class - CubicBezierSegment 
//
//--------------------------------------------------------------------------

import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import org.apache.royale.graphics.utils.MatrixUtil;

/**
 *  The CubicBezierSegment draws a cubic bezier curve from the current pen position 
 *  to x, y. The control1X and control1Y properties specify the first control point; 
 *  the control2X and control2Y properties specify the second control point.
 *
 *  <p>Cubic bezier curves are not natively supported in Flash Player. This class does
 *  an approximation based on the fixed midpoint algorithm and uses 4 quadratic curves
 *  to simulate a cubic curve.</p>
 *
 *  <p>For details on the fixed midpoint algorithm, see:<br/>
 *  http://timotheegroleau.com/Flash/articles/cubic_bezier_in_flash.htm</p>
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 1.0.0
 */
class CubicBezierSegment extends PathSegment
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 *  
	 *  <p>For a CubicBezierSegment, there are two control points, each with x and y coordinates. Control points 
	 *  are points that define the direction and amount of curves of a Bezier curve. 
	 *  The curved line never reaches the control points; however, the line curves as though being drawn 
	 *  toward the control point.</p>
	 *  
	 *  @param _control1X The x-axis location in 2-d coordinate space of the first control point.
	 *  
	 *  @param _control1Y The y-axis location of the first control point.
	 *  
	 *  @param _control2X The x-axis location of the second control point.
	 *  
	 *  @param _control2Y The y-axis location of the second control point.
	 *  
	 *  @param x The x-axis location of the starting point of the curve.
	 *  
	 *  @param y The y-axis location of the starting point of the curve.
	 *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public function CubicBezierSegment(
		_control1X:Number = 0, _control1Y:Number = 0,
		_control2X:Number = 0, _control2Y:Number = 0,
		x:Number = 0, y:Number = 0)
	{
		super(x, y);
		
		control1X = _control1X;
		control1Y = _control1Y;
		control2X = _control2X;
		control2Y = _control2Y;
	}   
	
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	private var _qPts:QuadraticPoints;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  control1X
	//----------------------------------
	
	/**
	 *  The first control point x position.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public var control1X:Number = 0;
	
	//----------------------------------
	//  control1Y
	//----------------------------------
	
	/**
	 *  The first control point y position.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public var control1Y:Number = 0;
	
	//----------------------------------
	//  control2X
	//----------------------------------
	
	/**
	 *  The second control point x position.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public var control2X:Number = 0;
	
	//----------------------------------
	//  control2Y
	//----------------------------------
	
	/**
	 *  The second control point y position.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public var control2Y:Number = 0;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Draws the segment.
	 *
	 *  @param g The graphics context where the segment is drawn.
	 *  
	 *  @param prev The previous location of the pen.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	override public function draw(graphicsPath:GraphicsPath, dx:Number, dy:Number, sx:Number, sy:Number, prev:PathSegment):void
	{
		var qPts:QuadraticPoints = getQuadraticPoints(prev);
		
		graphicsPath.curveTo(dx + qPts.control1.x*sx, dy+qPts.control1.y*sy, dx+qPts.anchor1.x*sx, dy+qPts.anchor1.y*sy);
		graphicsPath.curveTo(dx + qPts.control2.x*sx, dy+qPts.control2.y*sy, dx+qPts.anchor2.x*sx, dy+qPts.anchor2.y*sy);
		graphicsPath.curveTo(dx + qPts.control3.x*sx, dy+qPts.control3.y*sy, dx+qPts.anchor3.x*sx, dy+qPts.anchor3.y*sy);
		graphicsPath.curveTo(dx + qPts.control4.x*sx, dy+qPts.control4.y*sy, dx+qPts.anchor4.x*sx, dy+qPts.anchor4.y*sy);
	}
	
	/**
	 *  @inheritDoc
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	override public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number,
											m:Matrix, rect:Rectangle):Rectangle
	{
		var qPts:QuadraticPoints = getQuadraticPoints(prev);
		
		rect = MatrixUtil.getQBezierSegmentBBox(prev ? prev.x : 0, prev ? prev.y : 0,
			qPts.control1.x, qPts.control1.y,
			qPts.anchor1.x, qPts.anchor1.y,
			sx, sy, m, rect); 
		
		rect = MatrixUtil.getQBezierSegmentBBox(qPts.anchor1.x, qPts.anchor1.y,
			qPts.control2.x, qPts.control2.y,
			qPts.anchor2.x, qPts.anchor2.y,
			sx, sy, m, rect); 
		
		rect = MatrixUtil.getQBezierSegmentBBox(qPts.anchor2.x, qPts.anchor2.y,
			qPts.control3.x, qPts.control3.y,
			qPts.anchor3.x, qPts.anchor3.y,
			sx, sy, m, rect); 
		
		rect = MatrixUtil.getQBezierSegmentBBox(qPts.anchor3.x, qPts.anchor3.y,
			qPts.control4.x, qPts.control4.y,
			qPts.anchor4.x, qPts.anchor4.y,
			sx, sy, m, rect); 
		return rect;
	}
	
	/**
	 *  Returns the tangent for the segment. 
	 *  @param prev The previous segment drawn, or null if this is the first segment.
	 *  @param start If true, returns the tangent to the start point, otherwise the tangend to the end point.
	 *  @param sx Pre-transform scale factor for x coordinates.
	 *  @param sy Pre-transform scale factor for y coordinates.
	 *  @param m Transformation matrix.
	 *  @param result The tangent is returned as vector (x, y) in result.
	 */
	override public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
	{
		// Get the approximation (we want the tangents to be the same as the ones we use to draw
		var qPts:QuadraticPoints = getQuadraticPoints(prev);
		
		var pt0:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m).clone();
		var pt1:Point = MatrixUtil.transformPoint(qPts.control1.x * sx, qPts.control1.y * sy, m).clone();
		var pt2:Point = MatrixUtil.transformPoint(qPts.anchor1.x * sx, qPts.anchor1.y * sy, m).clone();
		var pt3:Point = MatrixUtil.transformPoint(qPts.control2.x * sx, qPts.control2.y * sy, m).clone();
		var pt4:Point = MatrixUtil.transformPoint(qPts.anchor2.x * sx, qPts.anchor2.y * sy, m).clone();
		var pt5:Point = MatrixUtil.transformPoint(qPts.control3.x * sx, qPts.control3.y * sy, m).clone();
		var pt6:Point = MatrixUtil.transformPoint(qPts.anchor3.x * sx, qPts.anchor3.y * sy, m).clone();
		var pt7:Point = MatrixUtil.transformPoint(qPts.control4.x * sx, qPts.control4.y * sy, m).clone();
		var pt8:Point = MatrixUtil.transformPoint(qPts.anchor4.x * sx, qPts.anchor4.y * sy, m).clone();
		
		if (start)
		{
			QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt1.x, pt1.y, pt2.x, pt2.y, start, result);
			// If there is no tangent
			if (result.x == 0 && result.y == 0)
			{
				// Try 3 & 4
				QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt3.x, pt3.y, pt4.x, pt4.y, start, result);
				
				// If there is no tangent
				if (result.x == 0 && result.y == 0)
				{
					// Try 5 & 6
					QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt5.x, pt5.y, pt6.x, pt6.y, start, result);
					
					// If there is no tangent
					if (result.x == 0 && result.y == 0)
						// Try 7 & 8
						QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt7.x, pt7.y, pt8.x, pt8.y, start, result);
				}
			}
		}
		else
		{
			QuadraticBezierSegment.getQTangent(pt6.x, pt6.y, pt7.x, pt7.y, pt8.x, pt8.y, start, result);
			// If there is no tangent
			if (result.x == 0 && result.y == 0)
			{
				// Try 4 & 5
				QuadraticBezierSegment.getQTangent(pt4.x, pt4.y, pt5.x, pt5.y, pt8.x, pt8.y, start, result);
				
				// If there is no tangent
				if (result.x == 0 && result.y == 0)
				{
					// Try 2 & 3
					QuadraticBezierSegment.getQTangent(pt2.x, pt2.y, pt3.x, pt3.y, pt8.x, pt8.y, start, result);
					
					// If there is no tangent
					if (result.x == 0 && result.y == 0)
						// Try 0 & 1
						QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt1.x, pt1.y, pt8.x, pt8.y, start, result);
				}
			}
		}
	}    
	
	/** 
	 *  @private
	 *  Tim Groleau's method to approximate a cubic bezier with 4 quadratic beziers, 
	 *  with endpoint and control point of each saved. 
	 */
	private function getQuadraticPoints(prev:PathSegment):QuadraticPoints
	{
		if (_qPts)
			return _qPts;
		
		var p1:Point = new Point(prev ? prev.x : 0, prev ? prev.y : 0);
		var p2:Point = new Point(x, y);
		var c1:Point = new Point(control1X, control1Y);     
		var c2:Point = new Point(control2X, control2Y);
		
		// calculates the useful base points
		var PA:Point = Point.interpolate(c1, p1, 3/4);
		var PB:Point = Point.interpolate(c2, p2, 3/4);
		
		// get 1/16 of the [p2, p1] segment
		var dx:Number = (p2.x - p1.x) / 16;
		var dy:Number = (p2.y - p1.y) / 16;
		
		_qPts = new QuadraticPoints;
		
		// calculates control point 1
		_qPts.control1 = Point.interpolate(c1, p1, 3/8);
		
		// calculates control point 2
		_qPts.control2 = Point.interpolate(PB, PA, 3/8);
		_qPts.control2.x -= dx;
		_qPts.control2.y -= dy;
		
		// calculates control point 3
		_qPts.control3 = Point.interpolate(PA, PB, 3/8);
		_qPts.control3.x += dx;
		_qPts.control3.y += dy;
		
		// calculates control point 4
		_qPts.control4 = Point.interpolate(c2, p2, 3/8);
		
		// calculates the 3 anchor points
		_qPts.anchor1 = Point.interpolate(_qPts.control1, _qPts.control2, 0.5); 
		_qPts.anchor2 = Point.interpolate(PA, PB, 0.5); 
		_qPts.anchor3 = Point.interpolate(_qPts.control3, _qPts.control4, 0.5); 
		
		// the 4th anchor point is p2
		_qPts.anchor4 = p2;
		
		return _qPts;      
	}
}

//--------------------------------------------------------------------------
//
//  Internal Helper Class - QuadraticPoints  
//
//--------------------------------------------------------------------------
import flash.geom.Point;

/**
 *  Utility class to store the computed quadratic points.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 1.0.0
 */
class QuadraticPoints
{
	public var control1:Point;
	public var anchor1:Point;
	public var control2:Point;
	public var anchor2:Point;
	public var control3:Point;
	public var anchor3:Point;
	public var control4:Point;
	public var anchor4:Point;
	
	/**
	 * Constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public function QuadraticPoints()
	{
		super();
	}
}

//--------------------------------------------------------------------------
//
//  Internal Helper Class - QuadraticBezierSegment 
//
//--------------------------------------------------------------------------
import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import org.apache.royale.graphics.utils.MatrixUtil;

/**
 *  The QuadraticBezierSegment draws a quadratic curve from the current pen position 
 *  to x, y. 
 *
 *  Quadratic bezier is the native curve type
 *  in Flash Player.
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 1.0.0
 */
class QuadraticBezierSegment extends PathSegment
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 *  
	 *  <p>For a QuadraticBezierSegment, there is one control point. A control point
	 *  is a point that defines the direction and amount of a Bezier curve. 
	 *  The curved line never reaches the control point; however, the line curves as though being drawn 
	 *  toward the control point.</p>
	 * 
	 *  @param _control1X The x-axis location in 2-d coordinate space of the control point.
	 *  
	 *  @param _control1Y The y-axis location in 2-d coordinate space of the control point.
	 *  
	 *  @param x The x-axis location of the starting point of the curve.
	 *  
	 *  @param y The y-axis location of the starting point of the curve.
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public function QuadraticBezierSegment(
		_control1X:Number = 0, _control1Y:Number = 0, 
		x:Number = 0, y:Number = 0)
	{
		super(x, y);
		
		control1X = _control1X;
		control1Y = _control1Y;
	}   
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  control1X
	//----------------------------------
	
	/**
	 *  The control point's x position.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public var control1X:Number = 0;
	
	//----------------------------------
	//  control1Y
	//----------------------------------
	
	/**
	 *  The control point's y position.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public var control1Y:Number = 0;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Draws the segment using the control point location and the x and y coordinates. 
	 *  This method calls the <code>Graphics.curveTo()</code> method.
	 *  
	 *  @see flash.display.Graphics
	 *
	 *  @param g The graphics context where the segment is drawn.
	 *  
	 *  @param prev The previous location of the pen.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	override public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
	{
		graphicsPath.curveTo(dx+control1X*sx, dy+control1Y*sy, dx+x*sx, dy+y*sy);
	}
	
	static public function getQTangent(x0:Number, y0:Number,
									   x1:Number, y1:Number,
									   x2:Number, y2:Number,
									   start:Boolean,
									   result:Point):void
	{
		if (start)
		{
			if (x0 == x1 && y0 == y1)
			{
				result.x = x2 - x0;
				result.y = y2 - y0;
			}
			else
			{
				result.x = x1 - x0;
				result.y = y1 - y0;
			}
		}
		else
		{
			if (x2 == x1 && y2 == y1)
			{
				result.x = x2 - x0;
				result.y = y2 - y0;
			}
			else
			{
				result.x = x2 - x1;
				result.y = y2 - y1;
			}
		}
	}
	
	/**
	 *  Returns the tangent for the segment. 
	 *  @param prev The previous segment drawn, or null if this is the first segment.
	 *  @param start If true, returns the tangent to the start point, otherwise the tangend to the end point.
	 *  @param sx Pre-transform scale factor for x coordinates.
	 *  @param sy Pre-transform scale factor for y coordinates.
	 *  @param m Transformation matrix.
	 *  @param result The tangent is returned as vector (x, y) in result.
	 */
	override public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
	{
		var pt0:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m).clone();
		var pt1:Point = MatrixUtil.transformPoint(control1X * sx, control1Y * sy, m).clone();;
		var pt2:Point = MatrixUtil.transformPoint(x * sx, y * sy, m).clone();
		
		getQTangent(pt0.x, pt0.y, pt1.x, pt1.y, pt2.x, pt2.y, start, result);
	}
	
	/**
	 *  @inheritDoc
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	override public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number,
											m:Matrix, rect:Rectangle):Rectangle
	{
		return MatrixUtil.getQBezierSegmentBBox(prev ? prev.x : 0, prev ? prev.y : 0,
			control1X, control1Y, x, y, sx, sy, m, rect);
	}
}


/**
 *  The EllipticalArcSegment draws an arc from the current point to a specified point. 
 *  The arc command begins with the x and y radius and ends with the ending point of the arc. 
 *  Between these are three other values: x axis rotation, large arc flag and sweep flag. 
 *  The x axis rotation is used to rotate the ellipse that the arc is created from. 
 *  This rotation maintains the start and end points, whereas a rotation with the transform 
 *  attribute (outside the path description) would cause the entire path, including the start 
 *  and end points, to be rotated. The large arc flag and sweep flag control which part of 
 *  the ellipse is used to cut the arc. These are needed because there's more than one way 
 *  to place an ellipse so that it includes the start and end points.
 *
 *  
 *  Derieved from the svgweb library
 *  Original found here https://code.google.com/p/svgweb/source/browse/trunk/src/org/svgweb/utils/EllipticalArc.as?r=1251
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 1.0.0
 */
class EllipticalArcSegment extends PathSegment
{
	
	private var _rx:Number;
	private var _ry:Number;
	private var _angle:Number;
	private var _largeArcFlag:Boolean;
	private var _sweepFlag:Boolean;
	private var _endX:Number;
	private var _endY:Number;
	
	/**
	 *  Constructor.
	 *  
	 * 
	 * @param rx x radius
	 *
	 * @param ry y radius
	 *
	 * @param angle angle of rotation from the x-axis
	 *
	 * @param largeArcFlag true if arc is greater than 180 degrees
	 *
	 * @param sweepFlag determines if the arc proceeds in a postitive or negative radial direction
	 *
	 * @param x arc end x value
	 *
	 * @param y arc end y value
	 *
	 * @param LastPointX starting x value of arc
	 *
	 * @param LastPointY starting y value of arc
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0
	 */
	public function EllipticalArcSegment(rx:Number, ry:Number, angle:Number, largeArcFlag:Boolean, sweepFlag:Boolean, endX:Number, endY:Number)
	{
		_rx = rx;
		_ry = ry;
		_angle = angle;
		_largeArcFlag = largeArcFlag;
		_sweepFlag = sweepFlag;
		_endX = endX;
		_endY = endY;
	}
	
	override public function draw(graphicsPath:GraphicsPath, dx:Number, dy:Number, sx:Number, sy:Number, prev:PathSegment):void
	{
		var ellipticalArc:Object = computeSvgArc(_rx, _ry, _angle, _largeArcFlag, _sweepFlag, dx + _endX, dy + _endY, dx + prev.x , dy + prev.y);    
		drawEllipticalArc(ellipticalArc.cx, ellipticalArc.cy, ellipticalArc.startAngle, ellipticalArc.arc, ellipticalArc.radius, ellipticalArc.yRadius, ellipticalArc.xAxisRotation, graphicsPath);
	}
	
	/**
	 * @private
	 * Create quadratic circle graphics commands from an elliptical arc
	 **/
	private static function drawEllipticalArc(x:Number, y:Number, startAngle:Number, arc:Number,
											  radius:Number, yRadius:Number, xAxisRotation:Number, path:GraphicsPath):void
	{
		// Circumvent drawing more than is needed
		if (Math.abs(arc)>360)
		{
			arc = 360;
		}          
		
		// Draw in a maximum of 45 degree segments. First we calculate how many
		// segments are needed for our arc.
		var segs:Number = Math.ceil(Math.abs(arc)/45);          
		
		// Now calculate the sweep of each segment
		var segAngle:Number = arc/segs;        
		
		var theta:Number = degreesToRadians(segAngle);
		var angle:Number = degreesToRadians(startAngle);
		
		// Draw as 45 degree segments
		if (segs>0)
		{                
			var beta:Number = degreesToRadians(xAxisRotation);
			var sinbeta:Number = Math.sin(beta);
			var cosbeta:Number = Math.cos(beta);
			
			var cx:Number;
			var cy:Number;
			var x1:Number;
			var y1:Number;
			
			// Loop for drawing arc segments
			for (var i:int = 0; i<segs; i++) {
				
				angle += theta;
				
				var sinangle:Number = Math.sin(angle-(theta/2));
				var cosangle:Number = Math.cos(angle-(theta/2));
				
				var div:Number = Math.cos(theta/2);
				cx = x + (radius * cosangle * cosbeta - yRadius * sinangle * sinbeta)/div; //Why divide by Math.cos(theta/2)? - FIX THIS
				cy = y + (radius * cosangle * sinbeta + yRadius * sinangle * cosbeta)/div; //Why divide by Math.cos(theta/2)? - FIX THIS                    
				
				sinangle = Math.sin(angle);
				cosangle = Math.cos(angle);                
				
				x1 = x + (radius * cosangle * cosbeta - yRadius * sinangle * sinbeta);
				y1 = y + (radius * cosangle * sinbeta + yRadius * sinangle * cosbeta);
				
				path.curveTo(cx, cy, x1, y1);
			}
		}
	}
	
	
	private function computeSvgArc(rx:Number, ry:Number,angle:Number,largeArcFlag:Boolean,sweepFlag:Boolean,
								   x:Number,y:Number,LastPointX:Number, LastPointY:Number):Object {
		//store before we do anything with it    
		var xAxisRotation:Number = angle;    
		
		// Compute the half distance between the current and the final point
		var dx2:Number = (LastPointX - x) / 2.0;
		var dy2:Number = (LastPointY - y) / 2.0;
		
		// Convert angle from degrees to radians
		angle = degreesToRadians(angle);
		var cosAngle:Number = Math.cos(angle);
		var sinAngle:Number = Math.sin(angle);
		
		
		//Compute (x1, y1)
		var x1:Number = (cosAngle * dx2 + sinAngle * dy2);
		var y1:Number = (-sinAngle * dx2 + cosAngle * dy2);
		
		// Ensure radii are large enough
		rx = Math.abs(rx);
		ry = Math.abs(ry);
		var Prx:Number = rx * rx;
		var Pry:Number = ry * ry;
		var Px1:Number = x1 * x1;
		var Py1:Number = y1 * y1;
		
		// check that radii are large enough
		var radiiCheck:Number = Px1/Prx + Py1/Pry;
		if (radiiCheck > 1) {
			rx = Math.sqrt(radiiCheck) * rx;
			ry = Math.sqrt(radiiCheck) * ry;
			Prx = rx * rx;
			Pry = ry * ry;
		}
		
		
		//Compute (cx1, cy1)
		var sign:Number = (largeArcFlag == sweepFlag) ? -1 : 1;
		var sq:Number = ((Prx*Pry)-(Prx*Py1)-(Pry*Px1)) / ((Prx*Py1)+(Pry*Px1));
		sq = (sq < 0) ? 0 : sq;
		var coef:Number = (sign * Math.sqrt(sq));
		var cx1:Number = coef * ((rx * y1) / ry);
		var cy1:Number = coef * -((ry * x1) / rx);
		
		
		//Compute (cx, cy) from (cx1, cy1)
		var sx2:Number = (LastPointX + x) / 2.0;
		var sy2:Number = (LastPointY + y) / 2.0;
		var cx:Number = sx2 + (cosAngle * cx1 - sinAngle * cy1);
		var cy:Number = sy2 + (sinAngle * cx1 + cosAngle * cy1);
		
		
		//Compute the angleStart (angle1) and the angleExtent (dangle)
		var ux:Number = (x1 - cx1) / rx;
		var uy:Number = (y1 - cy1) / ry;
		var vx:Number = (-x1 - cx1) / rx;
		var vy:Number = (-y1 - cy1) / ry;
		var p:Number
		var n:Number
		
		//Compute the angle start
		n = Math.sqrt((ux * ux) + (uy * uy));
		p = ux;
		
		sign = (uy < 0) ? -1.0 : 1.0;
		
		var angleStart:Number = radiansToDegrees(sign * Math.acos(p / n));
		
		// Compute the angle extent
		n = Math.sqrt((ux * ux + uy * uy) * (vx * vx + vy * vy));
		p = ux * vx + uy * vy;
		sign = (ux * vy - uy * vx < 0) ? -1.0 : 1.0;
		var angleExtent:Number = radiansToDegrees(sign * Math.acos(p / n));
		
		if(!sweepFlag && angleExtent > 0)
		{
			angleExtent -= 360;
		}
		else if (sweepFlag && angleExtent < 0)
		{
			angleExtent += 360;
		}
		
		angleExtent %= 360;
		angleStart %= 360;
		
		//return Object({x:LastPointX,y:LastPointY,startAngle:angleStart,arc:angleExtent,radius:rx,yRadius:ry,xAxisRotation:xAxisRotation});        
		return Object({x:LastPointX,y:LastPointY,startAngle:angleStart,arc:angleExtent,radius:rx,yRadius:ry,xAxisRotation:xAxisRotation, cx:cx,cy:cy});
	}
	
	/**
	 * @private
	 * Convert degrees to radians
	 **/
	private static function degreesToRadians(angle:Number):Number{
		return angle*(Math.PI/180);
	}
	
	/**
	 * @private
	 * Convert radiansToDegrees
	 **/
	private static function radiansToDegrees(angle:Number):Number{
		return angle*(180/Math.PI);
	}
	
	
}

