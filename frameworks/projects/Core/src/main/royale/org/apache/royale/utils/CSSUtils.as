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
	 *  The CSSUtils class is a collection of static functions that provide utility
	 *  features for managing CSS values.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class CSSUtils
	{
		/**
		 * @private
		 */
		
        public static function attributeFromColor(value:uint):String
        {
            var hexVal:String = value.toString(16);
			if(value > 16777215)
			{
                //rgba -- return rgba notation
                var rgba:Array = hexVal.match(/.{2}/g);
                for(var i:int = 0; i < 4; i++)
                {
                    rgba[i] = parseInt(rgba[i], 16);
                }
                rgba[3] = parseInt(""+(rgba[3]/255)*1000, 10) / 1000;
				return "rgba(" + rgba.join(",") + ")";
			}
            return "#" + StringPadder.pad(hexVal,"0",6);
        }
        /**
         *  Converts a String to number.
         *
         *  @param str The String. 
         *  @param reference A Number that will be used to convert percentages. 
         *
         *  @return Number. 
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         */
        public static function toNumber(str:String, reference:Number = 0):Number
        {
            //str must be non-null
            if(str === "")
                return NaN;
            var c:int = str.indexOf("px");
            if (c > -1)
                return Number(str.substr(0, c));
            
            c = str.indexOf("%");
            if (c > -1)
                return Number(str.substr(0, c)) * reference / 100;
            
            return Number(str);
        }

        /**
         *  Converts a value describing a color to a uint 
         *
         *  @param value The value. 
         *
         *  @return uint of the color. 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public static function toColor(value:Object):uint
        {
            return toColorWithAlpha(value) & 0xFFFFFF;
        }
        
        /**
         *  Converts a value describing a color and alpha in a uint 
         *
         *  @param value The value. 
         *
         *  @return uint of the color. If value is "transparent" then uint.MAX_VALUE is returned.
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion String
         */
        public static function toColorWithAlpha(value:Object):uint
        {
            if (!(value is String))
                return uint(value) | 0xFF000000; // css parser converted #rrggbb without alpha channel
            
            var c:int;
            var c2:int;
            
            var stringValue:String = value as String;
			if (stringValue === "transparent")
			{
				return uint.MAX_VALUE;
			}
            if (stringValue.charAt(0) === '#')
            {
                if (stringValue.length === 4)
                    return uint("0x" + stringValue.charAt(1) + stringValue.charAt(1) +
                        stringValue.charAt(2) + stringValue.charAt(2) +
                        stringValue.charAt(3) + stringValue.charAt(3));
                if (stringValue.length === 7)
                    return uint("0xFF" + stringValue.substr(1));
                return uint("0x" + stringValue.substr(1));
            }
            else if ((c = stringValue.indexOf("rgb(")) !== -1)
            {
                c2 = stringValue.indexOf(")");
                stringValue = stringValue.substring(c + 4, c2);
                var parts3:Array = stringValue.split(",");
                return (0xFF000000 + 
                        (uint(parts3[0]) << 16) +
                        (uint(parts3[1]) << 8) +
                        uint(parts3[2]));
            }
            else if ((c = stringValue.indexOf("rgba(")) !== -1)
            {
                c2 = stringValue.indexOf(")");
                stringValue = stringValue.substring(c + 5, c2);
                var parts4:Array = stringValue.split(",");
                parts4[3] *= 255; // range is 0 to 1

                return ((uint(parts4[3]) << 24) +
                        (uint(parts4[0]) << 16) +
                        (uint(parts4[1]) << 8) +
                        uint(parts4[2]));
            }
            
            if (colorMap.hasOwnProperty(stringValue))
                return colorMap[stringValue];
            return uint(stringValue);
        }

        /**
         *  Computes paddingTop or marginTop.
         *
         *  @param value The value of padding-top or margin-top. 
         *  @param values The value of padding or margin. 
         *  @param reference A Number that will be used to convert percentages. 
         *
         *  @return Number. 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion String
         */
        public static function getTopValue(value:Object, values:Object, reference:Number = NaN):Number
        {
            return getSideValue(value, values, 0, reference);
        }
        
        /**
         *  Computes paddingRight or marginRight.
         *
         *  @param value The value of padding-right or margin-right. 
         *  @param values The value of padding or margin. 
         *  @param reference A Number that will be used to convert percentages. 
         *
         *  @return Number. 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion String
         */
        public static function getRightValue(value:Object, values:Object, reference:Number = NaN):Number
        {
            return getSideValue(value, values, 1, reference);
        }
        
        /**
         *  Computes paddingBottom or marginBottom.
         *
         *  @param value The value of padding-bottom or margin-bottom. 
         *  @param values The value of padding or margin. 
         *  @param reference A Number that will be used to convert percentages. 
         *
         *  @return Number. 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion String
         */
        public static function getBottomValue(value:Object, values:Object, reference:Number = NaN):Number
        {
            return getSideValue(value, values, 2, reference);
        }

        /**
         *  Computes paddingLeft or marginLeft.
         *
         *  @param value The value of padding-left or margin-left. 
         *  @param values The value of padding or margin. 
         *  @param reference A Number that will be used to convert percentages. 
         *
         *  @return Number. 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion String
         */
        public static function getLeftValue(value:Object, values:Object, reference:Number = NaN):Number
        {
            return getSideValue(value, values, 3, reference);
        }

        /**
         *  Computes padding or margin.
         *
         *  @param value The value of padding or margin.
         *  @param values The value of padding or margin. 
         *  @param side Which side we want to get. 0 = top, 1 = right, 2 = bottom, 3 = left
         *  @param reference A Number that will be used to convert percentages. 
         *
         *  @return Number. 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         *  @royaleignorecoercion Array
         *  @royaleignorecoercion Number
         *  @royaleignorecoercion String
         */
        public static function getSideValue(value:Object, values:Object, side:int, reference:Number = NaN):Number
        {
            if (value is Number)
                return value as Number;
            
            if (values is Number)
                return values as Number;
            
            if (value != null)
                return toNumber(value as String, reference);
            if (values == null)
                return 0;
            if (values is Array)
            {
                value = getArrayValue(values as Array,side);
                if (value is String)
                    return toNumber(value as String, reference);
                return value as Number;
            }
            return toNumber(values as String, reference);
        }

        /**
         *  @private
         *  
         *  side should be an int 0 = top, 1 = right, 2 = bottom, 3 = left
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        private static function getArrayValue(arr:Array,side:int):Object
        {
            var n:int = arr.length;
            switch (side)
            {
                case 2:
                    side = n === 2 ? 0 : 2;
                    break;
                case 3:
                    side = n < 3 ? 1 : 3;
                    break;
                default:
                    //do nothing for 0 and 1
                    break;
            }
            return arr[side];
        }

        
        /**
         *  The map of color names to uints.
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         */
        public static const colorMap:Object = {
            transparent:   0,
            white:   0xFFFFFFFF,
            silver:	 0xFFC0C0C0,
            gray:    0xFF808080,
            black:	 0xFF000000,
            red:     0xFFFF0000,
            maroon:  0xFF800000,
            yellow:	 0xFFFFFF00,
            olive:	 0xFF808000,
            lime:	 0xFF00FF00,
            green:	 0xFF008000,
            aqua:	 0xFF00FFFF,
            teal:	 0xFF008080,
            blue:	 0xFF0000FF,
            navy:	 0xFF000080,
            fuchsia: 0xFFFF00FF,
            purple:	 0xFF800080
        };
	}
}
