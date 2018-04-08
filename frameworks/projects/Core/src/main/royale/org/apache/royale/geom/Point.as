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
package org.apache.royale.geom
{

COMPILE::SWF
{
import flash.geom.Point;		
}

/**
 *  The Point class is a utility class for holding x and y values, not that you
 *  can't use it to hold a width and height value.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
COMPILE::SWF
public class Point extends flash.geom.Point
{
	public function Point(x:Number = 0, y:Number = 0)
	{
		super(x, y);
	}
	
	public static function interpolate(pt1:org.apache.royale.geom.Point, pt2:org.apache.royale.geom.Point, f:Number):org.apache.royale.geom.Point
	{
		return new org.apache.royale.geom.Point(pt2.x + f * (pt1.x - pt2.x),pt2.y + f * (pt1.y - pt2.y));
	}
	
	public static function distance(pt1:org.apache.royale.geom.Point, pt2:org.apache.royale.geom.Point):Number
	{
		return pt1.subtract(pt2).length;
	}
	
	public static function polar(len:Number, angle:Number):org.apache.royale.geom.Point
	{
		return new org.apache.royale.geom.Point(len * Math.cos(angle),len * Math.sin(angle));
	}
	
	[SWFOverride(returns="flash.geom.Point")]
	override public function clone():org.apache.royale.geom.Point
	{
		return new org.apache.royale.geom.Point(x,y);
	}
	
	[SWFOverride(returns="flash.geom.Point",params="flash.geom.Point",altparams="org.apache.royale.geom.Point")]
	override public function subtract(v:org.apache.royale.geom.Point):org.apache.royale.geom.Point
	{
		return new org.apache.royale.geom.Point(x - v.x, y - v.y);
	}
	
	[SWFOverride(returns="flash.geom.Point",params="flash.geom.Point",altparams="org.apache.royale.geom.Point")]
	override public function add(v:org.apache.royale.geom.Point):org.apache.royale.geom.Point
	{
		return new org.apache.royale.geom.Point(x + v.x, y + v.y);
	}
	
}

/**
 *  The Point class is a utility class for holding x and y values, not that you
 *  can't use it to hold a width and height value.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 * 
 *  @royalesuppresspublicvarwarning
 */
COMPILE::JS
public class Point
{
    public function Point(x:Number = 0, y:Number = 0)
    {
        this.x = x;
        this.y = y;
    }
    
    public var x:Number;
    public var y:Number;
	public static function interpolate(pt1:Point, pt2:Point, f:Number):Point
	{
		return new Point(pt2.x + f * (pt1.x - pt2.x),pt2.y + f * (pt1.y - pt2.y));
	}
	
	public static function distance(pt1:Point, pt2:Point):Number
	{
		return pt1.subtract(pt2).length;
	}
	
	public static function polar(len:Number, angle:Number):Point
	{
		return new Point(len * Math.cos(angle),len * Math.sin(angle));
	}
	
	public function get length():Number
	{
		return Math.sqrt(x * x + y * y);
	}
	
	public function clone():Point
	{
		return new Point(x,y);
	}
	
	public function offset(dx:Number, dy:Number):void
	{
		x = x + dx;
		y = y + dy;
	}
	
	public function equals(toCompare:Point):Boolean
	{
		return toCompare.x == x && toCompare.y == y;
	}
	
	public function subtract(v:Point):Point
	{
		return new Point(x - v.x, y - v.y);
	}
	
	public function add(v:Point):Point
	{
		return new Point(x + v.x, y + v.y);
	}
	
	public function normalize(thickness:Number):void
	{
		var invD:Number = length;
		if(invD > 0)
		{
			invD = thickness / invD;
			x = x * invD;
			y = y * invD;
		}
	}
	
	public function toString():String
	{
		return "(x=" + x + ", y=" + y + ")";
	}
	
	public function copyFrom(sourcePoint:Point):void
	{
		x = sourcePoint.x;
		y = sourcePoint.y;
	}
	
	public function setTo(xa:Number, ya:Number):void
	{
		x = xa;
		y = ya;
	}
}

}
