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
package org.apache.royale.utils
{
	    /**
	     *  Converts RGB values to HSV values.
	     *  @param r: A uint from 0 to 255 representing the red value.
	     *  @param g: A uint from 0 to 255 representing the green value.
	     *  @param b: A uint from 0 to 255 representing the blue value.
	     *  @return Returns an HSV object with the properties h, s, and v defined.
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.9.6
	     */

        public function rgbToHsv( r:uint, g:uint, b:uint ):HSV
        {
			var max:uint = Math.max( r, g, b );
			var min:uint = Math.min( r, g, b );
			var hue:Number = 0;
			var saturation:Number = 0;
			var value:Number = 0;
			//get Hue
			if( max == min )
				hue = 0;
			else if( max == r )
				hue = ( 60 * ( g - b ) / ( max - min ) + 360 ) % 360;
			else if( max == g )
				hue = ( 60 * ( b - r ) / ( max - min ) + 120 );
			else if( max == b )
				hue = ( 60 * ( r - g ) / ( max - min ) + 240 );
			//get Value
			value = max;
			//get Saturation
			if(max == 0){
				saturation = 0;
			}else{
				saturation = ( max - min ) / max;
			}
			var hsv:HSV = new HSV();
			hsv.h = Math.round(hue);
			hsv.s = Math.round(saturation * 100);
			hsv.v = Math.round(value / 255 * 100);
			return hsv;
        }
}
