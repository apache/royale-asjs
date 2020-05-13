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
	     *  Converts HSV values to RGB values.
	     *  @param h: A uint from 0 to 360 representing the hue value.
	     *  @param s: A uint from 0 to 100 representing the saturation value.
	     *  @param v: A uint from 0 to 100 representing the lightness value.
	     *  @return Returns a hex value
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.9.6
         *  @royalesuppressexport
	     */

        public function hsvToHex( h:Number, s:Number, v:Number ):uint
        {
            var r:Number = 0;
            var g:Number = 0;
            var b:Number = 0;
            var tempS:Number = s / 100;
            var tempV:Number = v / 100;
            var hi:int = Math.floor(h/60) % 6;
            var f:Number = h/60 - Math.floor(h/60);
            var p:Number = (tempV * (1 - tempS));
            var q:Number = (tempV * (1 - f * tempS));
            var t:Number = (tempV * (1 - (1 - f) * tempS));

            switch(hi){
                case 0: r = tempV; g = t; b = p; break;
                case 1: r = q; g = tempV; b = p; break;
                case 2: r = p; g = tempV; b = t; break;
                case 3: r = p; g = q; b = tempV; break;
                case 4: r = t; g = p; b = tempV; break;
                case 5: r = tempV; g = p; b = q; break;
            }

			return Math.round( r * 255 ) << 16 | Math.round( g * 255 ) << 8 | Math.round( b * 255 );
        }
}
