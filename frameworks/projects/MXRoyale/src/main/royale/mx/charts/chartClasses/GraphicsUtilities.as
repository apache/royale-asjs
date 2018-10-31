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

package mx.charts.chartClasses
{

import mx.display.Graphics;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.LinearGradient;
//import mx.graphics.RadialGradient;
import mx.graphics.SolidColor;

/**
 *  A set of internal graphics rendering utilities
 *  used by the various chart classes.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class GraphicsUtilities
{
//    include "../../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private static var LINE_FORM:Object =
	{
		segment: 0,
		step: 1,
		vertical: 2,
		horizontal: 3,
		reverseStep: 4,
		curve: 5
	}
	
	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  Applies the values in a Stroke to the provded Graphics object. This utility function
	 *  applies the Stroke passed in, or clears the line style of the provided Graphics object
	 *	if the <code>ls</code> parameter is set to <code>null</code>.
	 *
	 *	@param g The Graphics object to modify.
	 *	@param ls The IStroke instance to apply; set to <code>null</code> to render with no Stroke.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static function setLineStyle(g:Graphics, ls:IStroke):void
	{
		if (!ls)
			g.lineStyle(0, 0, 0);
		else
			ls.apply(g,null,null);
	}
	
	/**
	 *  Fill a rectangle using the provided IFill and IStroke objects.
	 *  This utility function fills the provided rectangle in the Graphics object
	 *  with the provided Fill and Stroke. If no Stroke is provided, the rectangle is filled
	 *  with no border. If no Fill is provided, the rectangle is drawn with no fill.
	 *
	 * 	@param g The Graphics object to draw into.
	 *	@param left The left of the rectangle to fill.
	 *	@param top The top of the rectangle to fill.
	 *	@param right The right of the rectangle to fill.
	 *	@param bottom The bottom of the rectangle to fill.
	 *	@param fill The IFill object to fill the rectangle with. Set this parameter to null to draw a rectangle with no Fill.
	 *	@param ls The stroke object to draw the rectangle with. Set this parameter to null to draw a rectangle with no Stroke.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static function fillRect(g:Graphics, left:Number, top:Number,
									right:Number, bottom:Number,
									fill:Object = null, ls:Object = null):void
	{
		var fillIsColor:Boolean;		
		
		g.moveTo(left, top);

		if (fill != null)
		{
			if (fill is IFill)
			{
				fillIsColor = false;
				fill.begin(g,
					new Rectangle(left, top, right - left, bottom - top),null);
			}
			else
			{
				fillIsColor = true;
				g.beginFill(uint(fill));
			}
		}

		if (ls != null)
			ls.apply(g,null,null);
		
		g.lineTo(right, top);
		g.lineTo(right, bottom);
		g.lineTo(left, bottom);
		g.lineTo(left, top);

		if (fill != null)
			g.endFill();
	}

	/**
	 *  @private
	 */
	private static function convertForm(v:Object):Number
	{
		if (typeof(v) == "number")
		{
			return Number(v);
		}
		else
		{
			switch (v)
			{
				case "segment":
				default:
				{
					return LINE_FORM.segment;
				}

				case "curve":
				{
					return LINE_FORM.curve;
				}

				case "step":
				{
					return LINE_FORM.step;
				}

				case "horizontal":
				{
					return LINE_FORM.horizontal;
				}

				case "vertical":
				{
					return LINE_FORM.vertical;
				}

				case "reverseStep":
				{
					return LINE_FORM.reverseStep;
				}
			}
		}
		return NaN;			
	}

	/**
	 *  Draws a line connecting the datapoints using one of various forms.  
	 *	@param	g     The Graphics object to draw into.
	 *	@param	pts   An Array of datapoints that define the line.
	 *	@param	start The index of the first point in the <code>pts</code> Array to use when drawing the line.
	 *	@param	end   The index of the last point, exclusive, to use when drawing the line.
	 *	@param	hProp The name of the property in the objects contained in the <code>pts</code> Array that defines the horizontal position of the points in the line.
	 *	@param 	vProp The name of the property in the objects contained in the <code>pts</code> Array that defines the vertical position of the points in the line.
	 *	@param	stroke The Stroke used to render the line.
	 *	@param	form  The form to render the line with. Valid values are "segment","horizontal","vertical","step","reverseStep", or "curve". These forms are similar to the LineSeries class's <code>form</code> property.
	 *	@param	moveToStart Indicates whether to first move the pen to the beginning of the line before drawing. Pass <code>false</code> to use this function to continue a line in progress.
 	 *  
 	 *  @langversion 3.0
 	 *  @playerversion Flash 9
 	 *  @playerversion AIR 1.1
 	 *  @productversion Flex 3
 	 */
	public static function drawPolyLine(g:Graphics, pts:Array /* of Object */,
										 start:int, end:int,
										 hProp:String, vProp:String,
										 stroke:IStroke, form:Object,
										 moveToStart:Boolean = true):void
	{
		if (start == end)
			return;

		var originalStart:int = start;
		
		form = convertForm(form);
		
		if (stroke)
			stroke.apply(g,null,null);
		
		var len:Number;
		var incr:int;
		var i:int;
		var w:Number;
		var c:Number;
		var a:Number;
		
		var reverse:Boolean = start > end;
		
		if (reverse)
			incr = -1;
		else
			incr = 1;
		
        COMPILE::JS
        {
            g.beginStroke();
        }
		if (moveToStart)
			g.moveTo(pts[start][hProp], pts[start][vProp]);
		else
			g.lineTo(pts[start][hProp], pts[start][vProp]);

		start += incr;
			
		if (form == LINE_FORM.segment)
		{
			for (i = start; i != end;i += incr)
			{
				g.lineTo(pts[i][hProp], pts[i][vProp]);
			}
		}

		else if (form == LINE_FORM.step)
		{			
			for (i = start; i != end; i += incr)
			{
				g.lineTo(pts[i][hProp], pts[i - incr][vProp]);
				g.lineTo(pts[i][hProp], pts[i][vProp]);
			}
		}

		else if (form == LINE_FORM.reverseStep)
		{
			for (i = start; i != end; i += incr)
			{
				g.lineTo(pts[i - incr][hProp], pts[i][vProp]);
				g.lineTo(pts[i][hProp], pts[i][vProp]);
			}
		}

		else if (form == LINE_FORM.horizontal)
		{
			if (reverse)
			{
				for (i = start; i != end; i += incr)
				{
					g.lineStyle(0, 0, 0);
					g.lineTo(pts[i - incr][hProp], pts[i][vProp]);
					if (stroke)
						stroke.apply(g,null,null);
					g.lineTo(pts[i][hProp], pts[i][vProp]);
				}
			}
			else
			{
				for (i = start; i != end; i += incr)
				{
					g.lineStyle(0, 0, 0);
					g.lineTo(pts[i - incr][hProp], pts[i - incr][vProp]);
					if (stroke)
						stroke.apply(g,null,null);
					g.lineTo(pts[i][hProp], pts[i - incr][vProp]);
				}
			}
		}

		else if (form == LINE_FORM.vertical)
		{
			if (reverse)
			{
				for (i = start; i != end; i += incr)
				{

					g.lineStyle(0, 0, 0);
					g.lineTo(pts[i - incr][hProp], pts[i][vProp]);
					if (stroke)
						stroke.apply(g,null,null);
					g.lineTo(pts[i][hProp], pts[i][vProp]);
				}
			}
			else
			{
				for (i = start; i != end; i += incr)
				{
					g.lineStyle(0, 0, 0);
					g.lineTo(pts[i][hProp], pts[i - incr][vProp]);
					if (stroke)
						stroke.apply(g,null,null);
					g.lineTo(pts[i][hProp], pts[i][vProp]);
				}
			}
		}

		else if (form == LINE_FORM.curve)
		{
			start = originalStart;
			var innerEnd:int = end - incr;

			// Check for coincident points at the head of the list.
			// We'll skip over any of those			
			while (start != end && ((start + incr) != end))
			{
				if (pts[start + incr][hProp] != pts[start][hProp] ||
					pts[start + incr][vProp] != pts[start][vProp])
				{
					break;
				}
				start += incr;
			}
			if (start == end || start + incr == end)
				return;
				
			if (Math.abs(end - start) == 2)
			{
				g.lineTo(pts[start + incr][hProp], pts[start + incr][vProp]);
				return;
			}

			var tanLeft:Point = new Point();
			var tanRight:Point = new Point();
			var tangentLengthPercent:Number = 0.25;
			
			if (reverse)
				tangentLengthPercent *= -1;
			
			var j:int= start;
			
			// First, find the normalized vector
			// from the 0th point TO the 1st point
			var v1:Point = new Point();
			var v2:Point = new Point(pts[j + incr][hProp] - pts[j][hProp],
									 pts[j + incr][vProp] - pts[j][vProp]);
			var tan:Point = new Point();
			var p1:Point = new Point();
			var p2:Point = new Point();
			var mp:Point = new Point();
			
			len = Math.sqrt(v2.x * v2.x + v2.y * v2.y);
			v2.x /= len;
			v2.y /= len;
			
			// Now later on we'll be using the tangent to the curve
			// to define the control point.
			// But since we're at the end, we don't have a tangent.
			// Instead, we'll just use the first segment itself as the tangent.
			// The effect will be that the first curve will start along the
			// polyline.
			// Now extend the tangent to get a control point.
			// The control point is expressed as a percentage
			// of the horizontal distance beteen the two points.
			var tanLenFactor:Number = pts[j + incr][hProp] - pts[j][hProp];
			
			var prevNonCoincidentPt:Object = pts[j];
			
			// Here's the basic idea.
			// On any given iteration of this loop, we're going to draw the
			// segment of the curve from the nth-1 sample to the nth sample.
			// To do that, we're going to compute the 'tangent' of the curve
			// at the two samples.
			// We'll use these two tangents to find two control points
			// between the two samples.
			// Each control point is W pixels along the tangent at the sample,
			// where W is some percentage of the horizontal distance
			// between the samples.
			// We then take the two control points, and find the midpoint
			// of the line between them.
			// Then we're ready to draw.
			// We draw two quadratic beziers, one from sample N-1
			// to the midpoint, with control point N-1, and one
			// from the midpoint to sample N, with the control point N.
			
			for (j += incr; j != innerEnd; j += incr)
			{
				// Check and see if the next point is coincident.
				// If it is, we'll skip forward.
				if (pts[j + incr][hProp] == pts[j][hProp] &&
				    pts[j + incr][vProp] == pts[j][vProp])
				{
					continue;
				}
					 
				// v1 is the normalized vector from the nth point
				// to the nth-1 point.
				// Since we already computed from nth-1 to nth,
				// we can just invert it.
				v1.x = -v2.x
				v1.y = -v2.y;
				
				// Now compute the normalized vector from nth to nth+1. 
				v2.x = pts[j + incr][hProp] - pts[j][hProp];
				v2.y = pts[j + incr][vProp] - pts[j][vProp];
				
				len = Math.sqrt(v2.x * v2.x + v2.y * v2.y);
				v2.x /= len;
				v2.y /= len;
				
				// Now compute the 'tangent' of the C1 curve
				// formed by the two vectors.
				// Since they're normalized, that's easy to find...
				// It's the vector that runs between the two endpoints.
				// We normalize it, as well.
				tan.x = v2.x - v1.x;
				tan.y = v2.y - v1.y;
				var tanlen:Number = Math.sqrt(tan.x * tan.x + tan.y * tan.y);
				tan.x /= tanlen;
				tan.y /= tanlen;

				// Optionally, if the vertical direction of the curve
				// reverses itself, we'll pin the tangent to be  horizontal.
				// This works well for typical, well spaced chart lines,
				// not so well for arbitrary curves.
				if (v1.y * v2.y >= 0)
					tan = new Point(1, 0);

				// Find the scaled tangent we'll use
				// to calculate the control point.
				tanLeft.x = -tan.x * tanLenFactor * tangentLengthPercent;
				tanLeft.y = -tan.y * tanLenFactor * tangentLengthPercent;

				if (j == (incr+start))
				{
					// The first segment starts along the polyline,
					// so we only draw a single quadratic.
//					g.moveTo(pts[j - incr].x, pts[j - incr].y);
					g.curveTo(pts[j][hProp] + tanLeft.x,
							  pts[j][vProp] + tanLeft.y,
							  pts[j][hProp],
							  pts[j][vProp]);
				}
				else
				{
					// Determine the two control points...
					p1.x = prevNonCoincidentPt[hProp] + tanRight.x;
					p1.y = prevNonCoincidentPt[vProp] + tanRight.y;
					
					p2.x = pts[j][hProp] + tanLeft.x;
					p2.y = pts[j][vProp] + tanLeft.y;
					
					// and the midpoint of the line between them.
					mp.x = (p1.x+p2.x)/2
					mp.y = (p1.y+p2.y)/2;
					
					// Now draw our two quadratics.
					g.curveTo(p1.x, p1.y, mp.x, mp.y);
					g.curveTo(p2.x, p2.y, pts[j][hProp], pts[j][vProp]);
					
				}

				// We're about to move on to the nth to the nth+1 segment
				// of the curve...so let's flip the tangent at n,
				// and scale it for the horizontal distance from n to n+1.
				tanLenFactor = pts[j + incr][hProp] - pts[j][hProp];
				tanRight.x = tan.x * tanLenFactor * tangentLengthPercent;
				tanRight.y = tan.y * tanLenFactor * tangentLengthPercent;
				prevNonCoincidentPt = pts[j];
			}

			// Now in theory we're going to draw our last curve,
			// which, like the first, is only a single quadratic,
			// ending at the last sample.
			// If we try and draw two curves back to back, in reverse order,
			// they don't quite match.
			// I'm not sure whether this is expected, based on the definition
			// of a quadratic bezier, or a bug in the player.
			// Regardless, to work around this, we'll draw the last segment
			// backwards.
			g.curveTo(prevNonCoincidentPt[hProp] + tanRight.x,
					  prevNonCoincidentPt[vProp] + tanRight.y,
					  pts[j][hProp], pts[j][vProp]);

		}
        COMPILE::JS
        {
            g.endStroke();
        }
	}
	

	/**
	 *  Draws an arc in the target Graphics object.  
	 *	@param	g	The Graphics object to draw into.
	 *	@param	x	The horizontal origin of the arc.
	 *	@param	y	The vertical origin of the arc.
	 *	@param	startAngle	The starting angle, in radians, of the arc.
	 *	@param	arc	The sweep, in radians, of the arc.
	 *	@param	radius  The horizontal radius, in pixels, of the arc
	 *	@param	yRadius The vertical radius, in pixels, of the arc. If unspecified, it is assumed to be the same as the radius
	 *	@param	continueFlag Indicates whether the routine should move the graphics pen to the beginning of the arc before drawing.
	 *  Set to <code>true</code> to continue drawing a line that is already in progress.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static function drawArc(g:Graphics, x:Number, y:Number,
								  startAngle:Number, arc:Number,
								  radius:Number, yRadius:Number = NaN,
								  continueFlag:Boolean = false):void
	{
		
		if (isNaN(yRadius))
			yRadius = radius;

		var segAngle:Number
		var theta:Number
		var angle:Number
		var angleMid:Number
		var segs:Number
		var ax:Number
		var ay:Number
		var bx:Number
		var by:Number
		var cx:Number
		var cy:Number;
		
		if (Math.abs(arc) > 2 * Math.PI)
			arc = 2 * Math.PI;

		segs = Math.ceil(Math.abs(arc) / (Math.PI / 4));
		segAngle = arc / segs;
		theta = -segAngle;
		angle = -startAngle;
		
		if (segs > 0)
		{
			ax = x + Math.cos(startAngle) * radius;
			ay = y + Math.sin(-startAngle) * yRadius;
			
			if (continueFlag == true)
				g.lineTo(ax, ay);
			else
				g.moveTo(ax, ay);
			
			for (var i:uint = 0; i < segs; i++)
			{
				angle += theta;
				angleMid = angle - theta / 2;
				
				bx = x + Math.cos(angle) * radius;
				by = y + Math.sin(angle) * yRadius;
				cx = x + Math.cos(angleMid) * (radius / Math.cos(theta / 2));
				cy = y + Math.sin(angleMid) * (yRadius / Math.cos(theta / 2));
				
				g.curveTo(cx, cy, bx, by);
			}
		}
	}
	
	/**
	 *  Converts a style value into a Fill object. This convenience method converts a value assigned through styles into a Fill object
	 *	that can be used to fill an area on the screen. If the value is numeric, this function converts it into a corresponding SolidColor.
	 *	@param	v	The value to convert into a Fill.
	 *	@return The corresponding IFill object.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static function fillFromStyle(v:Object):IFill
	{		
		if (v is IFill)
			return IFill(v);

		else if (v != null)
			return IFill(new SolidColor(uint(v)));

		else
			return null;		
	}

	/**
	 *  Converts a fill value into a solid color. This convenience method pulls a color value out of a Fill
	 *	that best approximates the Fill on the screen.
	 *	@param	f	The Fill object to extract a color from.
	 *	@return A color value representing the Fill.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static function colorFromFill(f:Object):uint
	{
		var color:uint;

		if (f == null)
		{
		}
		else if (f is SolidColor)
		{
			color = SolidColor(f).color;
		}
		else if (f is LinearGradient &&
				 LinearGradient(f).entries.length > 0)
		{
			color = LinearGradient(f).entries[0].color;
		}
        /*
		else if (f is RadialGradient &&
				 RadialGradient(f).entries.length > 0)
		{
			color = RadialGradient(f).entries[0].color;
		}
        */
		else if (f is Number || f is uint || f is int)
		{
			color = uint(f);
		}

		return color;
	}
}

}
