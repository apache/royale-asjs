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
package org.apache.flex.utils
{

	/**
	 *  The CSSUtils class is a collection of static functions that provide utility
	 *  features for managing CSS values.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class CSSUtils
	{
		/**
		 * @private
		 */
		public function CSSUtils()
		{
			throw new Error("CSSUtils should not be instantiated.");
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
		 *  @productversion FlexJS 0.0
         */
        public static function toNumber(str:String, reference:Number = 0):Number
        {
            var c:int = str.indexOf("px");
            if (c != -1)
                return Number(str.substr(0, c));
            
            c = str.indexOf("%");
            if (c != -1)
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
         *  @productversion FlexJS 0.0
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
         *  @return uint of the color. 
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
         */
        public static function toColorWithAlpha(value:Object):uint
        {
            if (!(value is String))
                return uint(value);
            
            var c:int;
            var c2:int;
            
            var stringValue:String = value as String;
            if (stringValue.charAt(0) == '#')
            {
                if (stringValue.length == 4)
                    return uint("0x" + stringValue.charAt(1) + stringValue.charAt(1) +
                        stringValue.charAt(2) + stringValue.charAt(2) +
                        stringValue.charAt(3) + stringValue.charAt(3));
                return uint("0x" + stringValue.substr(1));
            }
            else if ((c = stringValue.indexOf("rgb(")) != -1)
            {
                c2 = stringValue.indexOf(")");
                stringValue = stringValue.substring(c + 4, c2);
                var parts3:Array = stringValue.split(",");
                return (0xFF000000 + 
                        uint(parts3[0]) << 16 +
                        uint(parts3[1]) << 8 +
                        uint(parts3[2]));
            }
            else if ((c = stringValue.indexOf("rgba(")) != -1)
            {
                c2 = stringValue.indexOf(")");
                stringValue = stringValue.substring(c + 4, c2);
                var parts4:Array = stringValue.split(",");
                return (uint(parts4[3]) << 24 + 
                    uint(parts3[0]) << 16 +
                    uint(parts3[1]) << 8 +
                    uint(parts3[2]));
            }
            
            if (colorMap.hasOwnProperty(stringValue))
                return colorMap[stringValue];
            return uint(stringValue);
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
         *  @productversion FlexJS 0.0
         */
        public static function getLeftValue(value:Object, values:Object, reference:Number = NaN):Number
        {
            if (value is Number)
                return value as Number;

            if (value != null)
                return toNumber(value as String, reference);
            if (values == null)
                return 0;
            if (values is Array)
            {
                var arr:Array = values as Array;
                var n:int = arr.length;
                // shouldn't be n == 1. values would not be an array
                var index:int = n < 3 ? 1 : 3;
                value = arr[index];
                if (value is String)
                  return toNumber(value as String, reference);
                return value as Number;
            }
            return toNumber(values as String, reference);
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
         *  @productversion FlexJS 0.0
         */
        public static function getRightValue(value:Object, values:Object, reference:Number = NaN):Number
        {
            if (value is Number)
                return value as Number;

            if (value != null)
                return toNumber(value as String, reference);
            if (values == null)
                return 0;
            if (values is Array)
            {
                var arr:Array = values as Array;
                value = arr[1];
                if (value is String)
                    return toNumber(value as String, reference);
                return value as Number;
            }
            return toNumber(values as String, reference);
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
         *  @productversion FlexJS 0.0
         */
        public static function getTopValue(value:Object, values:Object, reference:Number = NaN):Number
        {
            if (value is Number)
                return value as Number;
            
            if (value != null)
                return toNumber(value as String, reference);
            if (values == null)
                return 0;
            if (values is Array)
            {
                var arr:Array = values as Array;
                value = arr[0];
                if (value is String)
                    return toNumber(value as String, reference);
                return value as Number;
            }
            return toNumber(values as String, reference);
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
         *  @productversion FlexJS 0.0
         */
        public static function getBottomValue(value:Object, values:Object, reference:Number = NaN):Number
        {
            if (value is Number)
                return value as Number;
            
            if (value != null)
                return toNumber(value as String, reference);
            if (values == null)
                return 0;
            if (values is Array)
            {
                var arr:Array = values as Array;
                var n:int = arr.length;
                // shouldn't be n == 1. values would not be an array
                var index:int = n == 2 ? 0 : 2;
                value = arr[index];
                if (value is String)
                    return toNumber(value as String, reference);
                return value as Number;
            }
            return toNumber(values as String, reference);
        }
        
        /**
         *  The map of color names to uints.
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
         */
        public static var colorMap:Object = {
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
        }
	}
}