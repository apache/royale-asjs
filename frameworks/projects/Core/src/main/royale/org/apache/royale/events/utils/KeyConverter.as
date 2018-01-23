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
package org.apache.royale.events.utils
{	
    
	/**
     *  Converts Keyboard Codes and key values into rational string equivalents.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
	 */
	public class KeyConverter
	{

        COMPILE::JS
        private static const lookup:Object = {
            "Unidentified" : "",
            "Enter" : "\r",
            "Tab" : "\t",
            "Spacebar": " "
        };

        /**
         *  Converts HTML key values into rational string equivalents.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        COMPILE::JS
        public static function convertKey(value:String):String
        {
            if(value.length < 2)
                return value;

            value = lookup[value];
            return value || "";
        }

        /**
         *  Converts SWF key values into rational string equivalents. (is anything needed?)
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
         COMPILE::SWF
         public static function convertKey(value:String):String
         {
             return value;
         }

        /**
         *  Converts Flash keyCodes into rational string equivalents. These represent the physical (or virtual) key locations.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
         public static function convertKeyCode(code:uint):String
         {
             // A to Z
             if(code > 64 && code < 91)
             {
                 return "Key" + String.fromCharCode(code);
             }
             // 0 to 9
             if(code > 47 && code < 58)
             {
                 return "Digit" + String.fromCharCode(code);
             }
             // Numpad 0 to 9
             if(code > 95 && code < 106)
             {
                 // convert the value to digit equivalent
                 return "Numpad" + String.fromCharCode(code - 48);
             }
             // Fn keys
             if(code > 111 && code < 135)
             {
                 return "F" + (code - 111);
             }
             // The rest
             switch(code){
                case 8:
                    return "Backspace";
                case 9:
                    return "Tab";
                case 13:
                    return "Enter";
                case 16:
                    return "ShiftLeft";
                case 17:
                    return "ControlLeft";
                case 18:
                    return "AltLeft";
                case 20:
                    return "CapsLock";
                case 27:
                    return "Escape";
                case 32:
                    return "Space";
                case 33:
                    return "PageUp";
                case 34:
                    return "PageDown";
                case 35:
                    return "End";
                case 36:
                    return "Home";
                case 37:
                    return "ArrowLeft";
                case 38:
                    return "ArrowUp";
                case 39:
                    return "ArrowRight";
                case 40:
                    return "ArrowDown";
                case 45:
                    return "Insert";
                case 46:
                    return "Delete";
                case 91:
                    return "MetaLeft";
                case 92:
                case 93://both 92 and 93 can be MetaRight depending on the platform
                    return "MetaRight";
                case 144:
                    return "NumLock";
                case 145:
                    return "ScrollLock";
                case 19:
                    return "Pause";
                case 186:
                    return "Semicolon";
                case 187:
                    return "Equal";
                case 189:
                    return "Minus";
                case 191:
                    return "Slash";
                case 192:
                    return "Backquote";
                case 219:
                    return "BracketLeft";
                case 220:
                    return "Backslash";
                case 221:
                    return "BracketRight";
                case 222:
                    return "Quote";
                case 188:
                    return "Comma";
                case 190 :
                    return "Period";
                case 106:
                    return "NumpadMultiply";
                case 107:
                    return "NumpadAdd";
                // case 13:
                //     return "NumpadEnter";
                case 109:
                    return "NumpadSubtract";
                case 110:
                    return "NumpadDecimal";
                case 111:
                    return "NumpadDivide";
                default:
                    throw new Error("Unknown Key Code: " + code);
             }
         }

        /**
         *  Converts Flash charCodes into rational string equivalents. These represent the actual input.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
         public static function convertCharCode(code:uint):String
         {
             //By default we use String.fromCharCode. This should work for the vast majority of characters.
             //Special characters need to be dealt with individually.
             switch(code){
                 default:
                    return String.fromCharCode(code);
             }
         }
    }
}
