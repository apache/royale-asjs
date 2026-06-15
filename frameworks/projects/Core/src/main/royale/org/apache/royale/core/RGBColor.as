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
package org.apache.royale.core
{

  import org.apache.royale.utils.number.pinValue;
  import org.apache.royale.utils.HSV;

	/**
	 * The RGBColor class represents a color in terms of its red, green, blue and alpha components.
	 * It's a simple implementation of the IRGBA interface that provides a way to create and manipulate colors in RGB format.
	 */
  public class RGBColor implements IRGBA
  {
		public function RGBColor(initialValue:Object=null){
			if(initialValue && initialValue.length){
				if(!isNaN(initialValue[0])){
					r = initialValue[0];
				}
				if(!isNaN(initialValue[1])){
					g = initialValue[1];
				}
				if(!isNaN(initialValue[2])){
					b = initialValue[2];
				}
				if(!isNaN(initialValue[3])){
					alpha = initialValue[3];
				}
			}
		}

		private var _r:Number;

		public function get r():Number{
			return _r;
		}
		public function set r(value:Number):void{
			if(isNaN(value)){
				_r = value;
			} else {
				_r = pinValue(Math.round(value),0,255);
			}
		}

		private var _g:Number;
		public function get g():Number{
			return _g;
		}
		public function set g(value:Number):void{
			if(isNaN(value)){
				_g = value;
			} else {
				_g = pinValue(Math.round(value),0,255);
			}
		}

		private var _b:Number;
		public function get b():Number{
			return _b;
		}
		public function set b(value:Number):void{
			if(isNaN(value)){
				_b = value;
			} else {
				_b = pinValue(Math.round(value),0,255);
			}
		}

		private var _alpha:Number;
		public function get alpha():Number{
			return _alpha;
		}
		public function set alpha(value:Number):void{
			_alpha = isNaN(value) ? value : pinValue(value,0,1);
		}

		public function get colorValue():uint{
			if(isNaN(alpha) || alpha == 1){
				return (r << 16) | (g << 8) | (b << 0);
			}
			var a:uint = (alpha * 255) & 0xFF;
			return (a << 24) | (r << 16) | (g << 8) | (b << 0);
		}
		public function set colorValue(value:uint):void{
			if(value > 16777215){
				alpha = pinValue((value >> 24 & 255)/255,0,1);
			}
			r = value >> 16 & 255;
			g = value >> 8 & 255;
			b = value >> 0 & 255;
		}
		public function get styleString():String{
			if(isNaN(r) || isNaN(g) || isNaN(b)){
				return "";
			}
			var hasAlpha:Boolean = !isNaN(alpha);
      var prefix:String = hasAlpha ? "rgba(" : "rgb(";
      var str:String = prefix + Math.round(r) + "," + Math.round(g) + "," + Math.round(b);
      if(hasAlpha){
        return str + "," + (Math.round(alpha * 100)/100) + ")";
      }
      return str + ")";
		}
		public function get hexString():String{
			if(!isValid){
				return "";
			}
			return "#" + ((1 << 24) + ((r >> 0) << 16) + ((g >> 0) << 8) + (b >> 0)).toString(16).slice(1);
		}
		public function clone():IRGBA{
			return new RGBColor([r,g,b,alpha]);
		}
		public static function fromHSV(hsv:HSV):RGBColor{
			var h:Number = hsv.h == 360 ? 1 : hsv.h / 360 * 6;
			var s:Number = hsv.s == 100 ? 1 : hsv.s / 100;
			var v:Number = hsv.v == 100 ? 1 : hsv.v / 100;

			var i:Number = Math.floor(h);
			var f:Number = h - i;
			var p:Number = v * (1 - s);
			var q:Number = v * (1 - f * s);
			var t:Number = v * (1 - (1 - f) * s);
			var r:Number;
			var g:Number;
			var b:Number;
			switch(i % 6){
					case 0: r = v, g = t, b = p; break;
					case 1: r = q, g = v, b = p; break;
					case 2: r = p, g = v, b = t; break;
					case 3: r = p, g = q, b = v; break;
					case 4: r = t, g = p, b = v; break;
					case 5: r = v, g = p, b = q; break;
			}
			return new RGBColor([r*255,g*255,b*255]);
		}
		public function get isValid():Boolean{
			if(isNaN(r) || isNaN(g) || isNaN(b)){
				return false;
			}
			return true;
		}

		/**
		 *  Parse a 6-digit hex color string (with or without leading <code>#</code>)
		 *  into a new <code>RGBColor</code>. Returns a color with NaN channels
		 *  (i.e. <code>isValid == false</code>) if the input is malformed.
		 */
		public static function fromHex(hex:String):RGBColor{
			var c:RGBColor = new RGBColor();
			if(!hex) return c;
			var v:String = hex.charAt(0) == "#" ? hex.substr(1) : hex;
			if(v.length != 6) return c;
			var n:Number = parseInt(v, 16);
			if(isNaN(n)) return c;
			c.colorValue = uint(n);
			return c;
		}
	}
}