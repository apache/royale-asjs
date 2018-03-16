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
		import flash.geom.Rectangle;	
	}
	
	/**
	 *  The Rectangle class is a utility class for holding four coordinates of
	 *  a rectangle
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	COMPILE::SWF
	public class Rectangle extends flash.geom.Rectangle
	{
		public function Rectangle(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0)
		{
			super(x, y, width, height);
		}
		
		[SWFOverride(returns="flash.geom.Rectangle")]
		override public function clone():org.apache.royale.geom.Rectangle
		{
			return new org.apache.royale.geom.Rectangle(x,y,width,height);
		}

		[SWFOverride(returns="flash.geom.Point")]
		override public function get topLeft():Point
		{
			return new Point(x, y);
		}
		
		[SWFOverride(params="flash.geom.Point",altparams="org.apache.royale.geom.Point")]
		override public function set topLeft(value:Point):void
		{
			super.topLeft = value;
		}
		
		[SWFOverride(returns="flash.geom.Point")]
		override public function get bottomRight():Point
		{
			return new Point(right, bottom);
		}
		
		[SWFOverride(params="flash.geom.Point",altparams="org.apache.royale.geom.Point")]
		override public function set bottomRight(value:Point):void
		{
			super.bottomRight = value;
		}
		
		[SWFOverride(returns="flash.geom.Point")]
		override public function get size():Point
		{
			return new Point(width, height);
		}
		
		[SWFOverride(params="flash.geom.Point",altparams="org.apache.royale.geom.Point")]
		override public function set size(value:org.apache.royale.geom.Point):void
		{
			super.size = value;
		}
		
		[SWFOverride(returns="flash.geom.Rectangle",params="flash.geom.Rectangle",altparams="org.apache.royale.geom.Rectangle")]
		override public function intersection(toIntersect:org.apache.royale.geom.Rectangle):org.apache.royale.geom.Rectangle
		{
			var result:org.apache.royale.geom.Rectangle = new org.apache.royale.geom.Rectangle();
			if (isEmpty() || toIntersect.isEmpty())
			{
				result.setEmpty();
				return result;
			}
			result.x = Math.max(x, toIntersect.x);
			result.y = Math.max(y, toIntersect.y);
			result.width = Math.min(x + width, toIntersect.x + toIntersect.width) - result.x;
			result.height = Math.min(y + height, toIntersect.y + toIntersect.height) - result.y;
			if (result.width <= 0 || result.height <= 0)
			{
				result.setEmpty();
			}
			return result;
		}
		
		[SWFOverride(returns="flash.geom.Rectangle",params="flash.geom.Rectangle",altparams="org.apache.royale.geom.Rectangle")]
		override public function union(toUnion:org.apache.royale.geom.Rectangle):org.apache.royale.geom.Rectangle
		{
			var r:org.apache.royale.geom.Rectangle = null;
			if (isEmpty())
			{
				return toUnion.clone();
			}
			if (toUnion.isEmpty())
			{
				return clone();
			}
			r = new org.apache.royale.geom.Rectangle();
			r.x = Math.min(x, toUnion.x);
			r.y = Math.min(y, toUnion.y);
			r.width = Math.max(x + width, toUnion.x + toUnion.width) - r.x;
			r.height = Math.max(y + height, toUnion.y + toUnion.height) - r.y;
			return r;
		}
		
		public static function fromJSONString(str:String):org.apache.royale.geom.Rectangle
		{
			var obj:Object = JSON.parse(str);
			return org.apache.royale.geom.Rectangle.fromObject(obj);
		}
		
		public static function fromObject(obj:Object):org.apache.royale.geom.Rectangle
		{
			var x:Number = obj.x === undefined ? obj.left : obj.x;
			var y:Number = obj.y === undefined ? obj.top : obj.y;
			var width:Number = obj.width === undefined ? obj.right - x : obj.width;
			var height:Number = obj.height === undefined ? obj.bottom - y : obj.height;
			return new org.apache.royale.geom.Rectangle(x,y,width,height);
		}

	}
	
	/**
	 *  The Rectangle class is a utility class for holding four coordinates of
	 *  a rectangle
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
     * 
     *  @royalesuppresspublicvarwarning
	 */
	COMPILE::JS
	public class Rectangle
	{
	    public function Rectangle(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0)
	    {
	        this.x = x;
	        this.y = y;
	        this.width = width;
	        this.height = height;
	    }
	    
		public var x:Number;
		public var y:Number;
	    public var width:Number;
	    public var height:Number;

		public function get left():Number
		{
			return x;
		}
		public function set left(value:Number):void
		{
			x = value;
		}
		public function get top():Number
		{
			return y;
		}
		public function set top(value:Number):void
		{
			y = value;
		}
	    public function get right():Number
	    {
	        return x + width;
	    }
	    public function set right(value:Number):void
	    {
	        width = value - x;
	    }
	    
	    public function get bottom():Number
	    {
	        return y + height;
	    }
	    public function set bottom(value:Number):void
	    {
	        height = value - y;
	    }
		public function clone():Rectangle
		{
			return new Rectangle(x,y,width,height);
		}
		public function get topLeft():Point
		{
			return new Point(x, y);
		}
		
		public function set topLeft(value:Point):void
		{
			width = width + (x - value.x);
			height = height + (y - value.y);
			x = value.x;
			y = value.y;
		}
		
		public function get bottomRight():Point
		{
			return new Point(right, bottom);
		}
		
		public function set bottomRight(value:Point):void
		{
			width = value.x - x;
			height = value.y - y;
		}
		
		public function get size():Point
		{
			return new Point(width, height);
		}
		
		public function set size(value:Point):void
		{
			width = value.x;
			height = value.y;
		}
		
		public function isEmpty():Boolean
		{
			return width <= 0 || height <= 0;
		}
		
		public function setEmpty():void
		{
			x = 0;
			y = 0;
			width = 0;
			height = 0;
		}
		
		public function inflate(dx:Number, dy:Number):void
		{
			x = x - dx;
			width = width + 2 * dx;
			y = y - dy;
			height = height + 2 * dy;
		}
		
		public function inflatePoint(point:Point):void
		{
			x = x - point.x;
			width = width + 2 * point.x;
			y = y - point.y;
			height = height + 2 * point.y;
		}
		
		public function offset(dx:Number, dy:Number):void
		{
			x = x + dx;
			y = y + dy;
		}
		
		public function offsetPoint(point:Point):void
		{
			x = x + point.x;
			y = y + point.y;
		}
		
		public function contains(x:Number, y:Number):Boolean
		{
			return x >= this.x && x < this.x + this.width && y >= this.y && y < this.y + this.height;
		}
		
		public function containsPoint(point:Point):Boolean
		{
			return contains(point.x, point.y);
		}
		
		public function containsRect(rect:Rectangle):Boolean
		{
			var r1:Number = rect.x + rect.width;
			var b1:Number = rect.y + rect.height;
			var r2:Number = x + width;
			var b2:Number = y + height;
			return rect.x >= x && rect.x < r2 && rect.y >= y && rect.y < b2 && r1 > x && r1 <= r2 && b1 > y && b1 <= b2;
		}
		
		public function intersection(toIntersect:Rectangle):Rectangle
		{
			var result:Rectangle = new Rectangle();
			if (isEmpty() || toIntersect.isEmpty())
			{
				result.setEmpty();
				return result;
			}
			result.x = Math.max(x, toIntersect.x);
			result.y = Math.max(y, toIntersect.y);
			result.width = Math.min(x + width, toIntersect.x + toIntersect.width) - result.x;
			result.height = Math.min(y + height, toIntersect.y + toIntersect.height) - result.y;
			if (result.width <= 0 || result.height <= 0)
			{
				result.setEmpty();
			}
			return result;
		}
		
		public function intersects(toIntersect:Rectangle):Boolean
		{
			if (isEmpty() || toIntersect.isEmpty())
			{
				return false;
			}
			var resultx:Number = Math.max(x, toIntersect.x);
			var resulty:Number = Math.max(y, toIntersect.y);
			var resultwidth:Number = Math.min(x + width, toIntersect.x + toIntersect.width) - resultx;
			var resultheight:Number = Math.min(y + height, toIntersect.y + toIntersect.height) - resulty;
			if (resultwidth <= 0 || resultheight <= 0)
			{
				return false;
			}
			return true;
		}
		
		public function union(toUnion:Rectangle):Rectangle
		{
			var r:Rectangle = null;
			if (isEmpty())
			{
				return toUnion.clone();
			}
			if (toUnion.isEmpty())
			{
				return clone();
			}
			r = new Rectangle();
			r.x = Math.min(x, toUnion.x);
			r.y = Math.min(y, toUnion.y);
			r.width = Math.max(x + width, toUnion.x + toUnion.width) - r.x;
			r.height = Math.max(y + height, toUnion.y + toUnion.height) - r.y;
			return r;
		}
		
		public function equals(toCompare:Rectangle):Boolean
		{
			return toCompare.x == x && toCompare.y == y && toCompare.width == width && toCompare.height == height;
		}
		
		public function toString():String
		{
			return "(x=" + x + ", y=" + y + ", w=" + width + ", h=" + height + ")";
		}
		
		public function copyFrom(sourceRect:Rectangle):void
		{
			x = sourceRect.x;
			y = sourceRect.y;
			width = sourceRect.width;
			height = sourceRect.height;
		}
		
		public function setTo(xa:Number, ya:Number, widtha:Number, heighta:Number):void
		{
			x = xa;
			y = ya;
			width = widtha;
			height = heighta;
		}

		public static function fromJSONString(str:String):Rectangle
		{
			var obj:Object = JSON.parse(str);
			return Rectangle.fromObject(obj);
		}

		public static function fromObject(obj:Object):Rectangle
		{
			var x:Number = obj.x === undefined ? obj.left : obj.x;
			var y:Number = obj.y === undefined ? obj.top : obj.y;
			var width:Number = obj.width === undefined ? obj.right - x : obj.width;
			var height:Number = obj.height === undefined ? obj.bottom - y : obj.height;
			return new Rectangle(x,y,width,height);
		}
	}


}
