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
package org.apache.royale.utils.string
{
    /**
	 *  Base64 encoding/decoding that works cross browsers
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class Base64
	{
        public static const _keyStr:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

        /**
         *  encode a string in base64
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        public static function encode(e:String):String
        {
            var t:String = "";
            var n:int,r:int,i:int,s:int,o:int,u:int,a:int;
            var f:int = 0;
            e = _utf8_encode(e);
            while(f < e.length)
            {
                n=e.charCodeAt(f++);
                r=e.charCodeAt(f++);
                i=e.charCodeAt(f++);
                s=n>>2;
                o=(n&3)<<4|r>>4;
                u=(r&15)<<2|i>>6;
                a=i&63;
                if(isNaN(r))
                {
                    u=a=64
                }else if(isNaN(i))
                {
                    a=64
                }
                t=t+_keyStr.charAt(s)+_keyStr.charAt(o)+_keyStr.charAt(u)+_keyStr.charAt(a);
            }
            return t;
        }
        
        /**
         *  decode string from base64
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        public static function decode(e:String):String
        {
            var t:String = "";
            var n:int,r:int,i:int;
            var s:int,o:int,u:int,a:int;
            var f:int = 0;
            e = e.replace(/[^A-Za-z0-9+/=]/g,"");
            while(f<e.length)
            {
                s=_keyStr.indexOf(e.charAt(f++));
                o=_keyStr.indexOf(e.charAt(f++));
                u=_keyStr.indexOf(e.charAt(f++));
                a=_keyStr.indexOf(e.charAt(f++));
                n=s<<2|o>>4;
                r=(o&15)<<4|u>>2;
                i=(u&3)<<6|a;
                t=t+String.fromCharCode(n);
                if(u!=64)
                {
                    t=t+String.fromCharCode(r);
                }
                if(a!=64)
                {
                    t=t+String.fromCharCode(i);
                }
            }
            t = _utf8_decode(t);
            return t;
        }
        
        /**
         *  encode utf8 string
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        public static function _utf8_encode(e:String):String
        {
            e = e.replace(/rn/g,"n");
            var t:String = "";
            for(var n:int=0;n<e.length;n++)
            {
                var r:int = e.charCodeAt(n);
                if(r < 128)
                {
                    t+=String.fromCharCode(r);
                } else if(r>127&&r<2048)
                {
                    t+=String.fromCharCode(r>>6|192);
                    t+=String.fromCharCode(r&63|128);
                } else
                {
                    t+=String.fromCharCode(r>>12|224);
                    t+=String.fromCharCode(r>>6&63|128);
                    t+=String.fromCharCode(r&63|128);
                }
            }
            return t;
        }

        /**
         *  decode utf8 string
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        public static function _utf8_decode(e:String):String
        {
            var t:String = "";
            var n:int,r:int,c1:int;
            var c2:int=0;
            while(n < e.length)
            {
                r = e.charCodeAt(n);
                if(r < 128)
                {
                    t += String.fromCharCode(r);n++;
                } else if(r>191 && r<224)
                {
                    c2 = e.charCodeAt(n+1);
                    t += String.fromCharCode((r&31)<<6|c2&63);
                    n+=2;
                } else
                {
                    c2 = e.charCodeAt(n+1);
                    var c3:int = e.charCodeAt(n+2);
                    t += String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);
                    n += 3;
                }
            }
            return t;
        }  
    }
}   