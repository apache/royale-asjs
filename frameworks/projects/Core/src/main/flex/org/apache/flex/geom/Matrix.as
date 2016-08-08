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
package org.apache.flex.geom
{

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

		public function clone():Matrix
		{
			return new Matrix(a, b, c, d, tx, ty);
		}
		
		public function concat(m:Matrix):void
		{
			var result_a:Number = a * m.a;
			var result_b:Number = 0;
			var result_c:Number = 0;
			var result_d:Number = d * m.d;
			var result_tx:Number = tx * m.a + m.tx;
			var result_ty:Number = ty * m.d + m.ty;
			if (b != 0 || c != 0 || m.b != 0 || m.c != 0)
			{
				result_a = result_a + b * m.c;
				result_d = result_d + c * m.b;
				result_b = result_b + (a * m.b + b * m.d);
				result_c = result_c + (c * m.a + d * m.c);
				result_tx = result_tx + ty * m.c;
				result_ty = result_ty + tx * m.b;
			}
			a = result_a;
			b = result_b;
			c = result_c;
			d = result_d;
			tx = result_tx;
			ty = result_ty;
		}
		
		public function invert():void
		{
			if (b == 0 && c == 0)
			{
				a = 1 / a;
				d = 1 / d;
				b = c = 0.0;
				tx = -a * tx;
				ty = -d * ty;
			}
			else
			{
				var a0:Number = a;
				var a1:Number = b;
				var a2:Number = c;
				var a3:Number = d;
				var det:Number = a0 * a3 - a1 * a2;
				if (det == 0)
				{
					identity();
					return;
				}
				det = 1 / det;
				a = a3 * det;
				b = -a1 * det;
				c = -a2 * det;
				d = a0 * det;
				var result_ty:Number = -(b * tx + d * ty);
				tx = -(a * tx + c * ty);
				ty = result_ty;
			}
		}
		
		public function identity():void
		{
			a = d = 1;
			b = c = 0;
			tx = ty = 0;
		}
		
		public function rotate(angle:Number):void
		{
			var u:Number = Math.cos(angle);
			var v:Number = Math.sin(angle);
			var result_a:Number = u * a - v * b;
			var result_b:Number = v * a + u * b;
			var result_c:Number = u * c - v * d;
			var result_d:Number = v * c + u * d;
			var result_tx:Number = u * tx - v * ty;
			var result_ty:Number = v * tx + u * ty;
			a = result_a;
			b = result_b;
			c = result_c;
			d = result_d;
			tx = result_tx;
			ty = result_ty;
		}
		
		public function translate(dx:Number, dy:Number):void
		{
			tx = tx + dx;
			ty = ty + dy;
		}
		
		public function scale(sx:Number, sy:Number):void
		{
			a = a * sx;
			b = b * sy;
			c = c * sx;
			d = d * sy;
			tx = tx * sx;
			ty = ty * sy;
		}
		
		public function deltaTransformPoint(point:Point):Point
		{
			return new Point(a * point.x + c * point.y, d * point.y + b * point.x);
		}
		
		public function transformPoint(point:Point):Point
		{
			return new Point(a * point.x + c * point.y + tx, d * point.y + b * point.x + ty);
		}
		
		public function toString():String
		{
			return "(a=" + a + ", b=" + b + ", c=" + c + ", d=" + d + ", tx=" + tx + ", ty=" + ty + ")";
		}
		
		public function copyFrom(sourceMatrix:Matrix):void
		{
			a = sourceMatrix.a;
			b = sourceMatrix.b;
			c = sourceMatrix.c;
			d = sourceMatrix.d;
			tx = sourceMatrix.tx;
			ty = sourceMatrix.ty;
		}
		
	}
}