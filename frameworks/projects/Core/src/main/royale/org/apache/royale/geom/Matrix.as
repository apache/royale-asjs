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
//
// Implementation derived fromL
//     https://github.com/openfl/openfl/blob/develop/openfl/geom/Matrix.hx
// available under MIT License.
//
package org.apache.royale.geom
{

    /**
     *  2D Matrix
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.7
     * 
     *  @royalesuppresspublicvarwarning
     */
	public class Matrix
	{
		public function Matrix(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 1, tx:Number = 0, ty:Number = 0)
		{
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;
			this.tx = tx;
			this.ty = ty;

		}
		public var a:Number;
		public var b:Number;
		public var c:Number;
		public var d:Number;
		public var tx:Number;
		public var ty:Number;

		/**
		 *	Returns a copy of the Matrix
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.7
		 */
		public function clone():Matrix
		{
			return new Matrix(a, b, c, d, tx, ty);
		}
		
		/**
		 *  Adds the Matrix the current one
		 *  Returns the matrix so the methods can be chained.
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.7
		 */
		public function concat(m:Matrix):Matrix
		{
			var newa:Number = a * m.a + b * m.c;
			b = a * m.b + b * m.d;
			a = newa;
			
			var newc:Number = c * m.a + d * m.c;
			d = c * m.b + d * m.d;
			c = newc;
			
			var newtx:Number = tx * m.a + ty * m.c + m.tx;
			ty = tx * m.b + ty * m.d + m.ty;
			tx = newtx;
			return this;
		}

		/**
		 *  Calculates the Matrix determinant
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.7
		 */
		public function determinant():Number
		{
			return a * d - b * c;
		}
		
		/**
		 *  Inverts the Matrix.
		 *  Returns the matrix so the methods can be chained.
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.7
		 */
		public function invert():Matrix
		{
			// if b and c are both 0, we can simplify this.
			if (b == 0 && c == 0)
			{
				a = 1 / a;
				d = 1 / d;
				tx *= -a;
				ty *= -d;
			}
			else
			{
				var det:Number = determinant();
				if (det == 0)
				{
					identity();
					return this;
				}
				det = 1 / det;
				var newa:Number = d * det;
				d = a * det;
				a = newa;
				b *= -det;
				c *= -det;
			
				var newtx:Number = - a * tx - c * ty;
				ty = - b * tx - d * ty;
				tx = newtx;
			}
			return this;
		}
		
		/**
		 *  Resets the matrix to the default values.
		 *  Returns the matrix so the methods can be chained.
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.7
		 */
		public function identity():Matrix
		{
			a = d = 1;
			b = c = tx = ty = 0;
			return this;
		}
		
		/**
		 *  Rotates the Matrix by the specified value.
		 *  Returns the matrix so the methods can be chained.
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.7
		 */
		public function rotate(angle:Number):Matrix
		{
			var cos:Number = Math.cos(angle);
			var sin:Number = Math.sin(angle);
			
			var newa:Number = a * cos - b * sin;
			b = a * sin + b * cos;
			a = newa;
		
			var newc:Number = c * cos - d * sin;
			d = c * sin + d * cos;
			c = newc;
		
			var newtx:Number = tx * cos - ty * sin;
			ty = tx * sin + ty * cos;
			tx = newtx;
			return this;
		}
		
		/**
		 *  Moves the Matrix by the specified amount
		 *  Returns the matrix so the methods can be chained.
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.7
		 */
		public function translate(x:Number, y:Number):Matrix
		{
			tx += x;
			ty += y;
			return this;
		}
		
		/**
		 *  Scales the Matrix by the specified amount.
		 *  Returns the matrix so the methods can be chained.
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.7
		 */
		public function scale(x:Number, y:Number):Matrix
		{
			a *= x;
			b *= y;
			c *= x;
			d *= y;
			tx *= x;
			ty *= y;
			return this;
		}
		
		/**
		 *  Uses the Matrix to transform the point without the translation values.
		 *  Returns a new Point. The original Point is unchanged.
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.7
		 */
		public function deltaTransformPoint(point:Point):Point
		{
			return new Point(a * point.x + c * point.y, d * point.y + b * point.x);
		}
		
		/**
		 *  Uses the Matrix to transform the point including the translation values.
		 *  Returns a new Point. The original Point is unchanged.
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.7
		 */
		public function transformPoint(point:Point):Point
		{
			return new Point(a * point.x + c * point.y + tx, d * point.y + b * point.x + ty);
		}
		
		/**
		 * Creates the specific style of matrix expected by the certain methods of the swf Graphics emulation class in the Graphics library.
		 * @param width The width of the gradient box.
		 * @param height The height of the gradient box.
		 * @param rotation (default = 0) — The amount to rotate, in radians.
		 * @param tx (default = 0) — The distance, in pixels, to translate to the right along the x axis. This value is offset by half of the width parameter.
		 * @param ty (default = 0) — The distance, in pixels, to translate down along the y axis. This value is offset by half of the height parameter.
		 *
		 * This method is not reflectable in javascript, to allow for dead-code-elimination in applications that will not use it.
		 * If it is required for reflection, you can create a subclass, and overrride this method, simply calling the super method with the original arguments.
		 * That change will make it reflectable in the subclass.
		 * @royalesuppressexport
		 */
		public function createGradientBox(width:Number, height:Number, rotation:Number = 0, tx:Number = 0, ty:Number = 0):void
		{
			this.tx = tx + width / 2;
			this.ty = ty + height / 2;
			a = width / 1638.4;
			d = height / 1638.4;
			if (rotation !== 0) {
				var cos:Number = Math.cos(rotation);
				var sin:Number = Math.sin(rotation);
				c = -sin * a;
				b = sin * d;
				a = cos * a;
				d = cos * d;
			} else {
				// the following seems unusual, but it correctly results in NaN values if a or d is NaN, which matches observed behavior from swf reference implementation
				c = a * 0;
				b = d * 0;
			}
		}
		
		/**
		 *  Returns a string representation of the Matrix.
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.7
		 */
		public function toString():String
		{
			return "(a=" + a + ", b=" + b + ", c=" + c + ", d=" + d + ", tx=" + tx + ", ty=" + ty + ")";
		}
		
		/**
		 *  Copies the values from another Matrix.
		 *  Returns the matrix so the methods can be chained.
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.7
		 */
		public function copyFrom(source:Matrix):Matrix
		{
			a = source.a;
			b = source.b;
			c = source.c;
			d = source.d;
			tx = source.tx;
			ty = source.ty;
			return this;
		}
		
	}
}
