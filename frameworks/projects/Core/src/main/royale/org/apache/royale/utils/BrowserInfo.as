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
 *  The BrowserInfo class is a convenience class for getting info about the current browser environment.
 *  It uses browser sniffing which is generally considered a fragile way to get this info, but it's the best we have.
 *  You cannot instantiate your own instance of a BrowserInfo. To get the current environment use `BrowserInfo.current()`
 *  This will return a static instance which represents your current browser environment.
 *  This class contains blank values on Flash.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.9
 */
    public class BrowserInfo
    {
        public function BrowserInfo(enf:Enforcer)
        {
            COMPILE::JS
            {
                init();
            }
        }

        private var _browser:String;
        /**
         * The browser (if any)
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.0
         */
        public function get browser():String
        {
            return _browser;
        }

        private var _version:String;
        /**
         * The browser version.
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.0
         */
        public function get version():String
        {
            return _version;
        }

        private var _engine:String;
        /**
         * The rendering engine used by the browser. One of: "Trident", "Gecko", "Presto", "Blink", "WebKit", "EdgeHTML".
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.0
         */
        public function get engine():String
        {
            return _engine;
        }

        private var _engineVersion:String;
        /**
         * The specific version of the rendering engine used.
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.0
         */
        public function get engineVersion():String
        {
            return _engineVersion;
        }

        private var _formFactor:String;

        /**
         * The form factor of the device. One of: "Mobile", "Tablet", "TV", "iPhone", "iPad", "iPod" or "Desktop".
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.0
         */
        public function get formFactor():String{
            return _formFactor;
        }
        /**
         * The os. @see org.apache.royale.utils.OSUtils
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.0
         */
        public function get os():String
        {
            return OSUtils.getOS();
        }
        /**
         * True if the platform is a tablet or phone.
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.0
         */
        public function isMobile():Boolean
        {
            return formFactor != "Desktop" && formFactor != "TV";
        }
        private static var _current:BrowserInfo;
        /**
         * Returns a BrowserInfo object with properties of the current runtime.
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.0
         */
        public static function current():BrowserInfo
        {
            if(!_current)
                _current = new BrowserInfo(new Enforcer);
            
            return _current;
        }


        /**
         * 
         Browser userAgent data:
         Safari: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/602.3.12 (KHTML, like Gecko) Version/10.0.2 Safari/602.3.12"
         Chrome Mac: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36"
         Firefox Mac: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:54.0) Gecko/20100101 Firefox/54.0"
         "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.0 Safari/537.36"

         IE 11: "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729; rv:11.0) like Gecko"
         Edge: "Mozilla/5.0 (Windows NT 10.0; Win64; x64; ServiceUI 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.79 Safari/537.36 Edge/14.14393"
         Firefox Windows 10: "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:44.0) Gecko/20100101 Firefox/44.0"
         Chrome Windows 10: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"

"Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729; rv:11.0) like Gecko".match(/\brv[ :]+(\d\.+)/g)
var m = str.match(/\brv[ :]+[\d\.]+/g)
         */
         

        COMPILE::JS
        private function init():void
        {
            var ua:String = window["navigator"]["userAgent"];
            //Figure out formFactor
            if(ua.indexOf("iPad") != -1)
                _formFactor = "iPad";
            else if(ua.indexOf("iPhone") != -1)
                _formFactor = "iPhone";
            else if(ua.indexOf("iPod") != -1)
                _formFactor = "iPod";
            else if(ua.indexOf("Tablet") != -1)
                _formFactor = "Tablet";
            else if(ua.indexOf("Mobile") != -1)
                _formFactor = "Mobile";
            else if(ua.indexOf("Android") != -1)
                _formFactor = "Tablet";
            else if(ua.indexOf("TV;") != -1)
                _formFactor = "TV";
            else
                _formFactor = "Desktop";
            var verMatch:Array;
            // This should work for all desktop browsers. Not sure about mobile browsers.
            if(ua.search(/trident/i) > -1)//IE I think all versions of IE used Trident
            {
                _browser = "IE";
                verMatch = ua.match(/\brv[ :]+[\d\.]+/g);
                if(verMatch)
                    _version = verMatch[0].split(":")[1];
                _engine = "Trident";
                verMatch = ua.match(/trident\/[\d\.]+/i);
                if(verMatch)
                    _engineVersion = verMatch[0].split("/")[1];
            }
            else if(ua.search(/edge/i) > -1)//Edge
            {
                _browser = "IE";
                _engine = "EdgeHTML";
                verMatch = ua.match(/edge\/[\d\.]+/i);
                if(verMatch)
                    _version = _engineVersion = verMatch[0].split("/")[1];

            }
            else if(ua.search(/firefox\/[\d\.]/i) > -1)//Firefox. Assuming Firefox for now to always be Gecko.
            {
                _browser = "Firefox";
                _engine = "Gecko";
                verMatch = ua.match(/firefox\/[\d\.]+/i);
                if(verMatch)
                    _version = verMatch[0].split("/")[1];
                verMatch = ua.match(/gecko\/[\d\.]+/i);
                if(verMatch)
                    _engineVersion = verMatch[0].split("/")[1];
            }
            else if(ua.search(/version\/[\d\.]/i) > -1)//Safari is the only browser which has "Version/"
            {
                _browser = "Safari";
                _engine = "WebKit";
                verMatch = ua.match(/version\/[\d\.]+/i);
                if(verMatch)
                    _version = verMatch[0].split("/")[1];
                verMatch = ua.match(/applewebkit\/[\d\.]+/i);
                if(verMatch)
                    _engineVersion = verMatch[0].split("/")[1];
            }            
            else if(ua.search(/opera\/[\d\.]/i) > -1)//Opera with Presto used "opera"
            {
                _browser = "Opera";
                _engine = "Presto";
                verMatch = ua.match(/opera\/[\d\.]+/i);
                if(verMatch)
                    _version = _engineVersion = verMatch[0].split("/")[1];
            }            
            else if(ua.search(/opr\/[\d\.]/i) > -1)//Opera with Blink uses "OPR"
            {
                _browser = "Opera";
                _engine = "Blink";
                verMatch = ua.match(/opr\/[\d\.]+/i);
                if(verMatch)
                    _version = _engineVersion = verMatch[0].split("/")[1];
            }            
            else if(ua.search(/chrome\/[\d\.]/i) > -1)//Safari is the only browser which has "Version/"
            {
                _browser = "Chrome";
                verMatch = ua.match(/chrome\/[\d\.]+/i);
                if(verMatch)
                    _version = _engineVersion = verMatch[0].split("/")[1];
                var verNum:Number = parseFloat(_version);
                if(isNaN(verNum) || verNum < 28 || _formFactor.indexOf("iP") != -1)//iOS uses Webkit
                    _engine = "WebKit";
                else 
                    _engine = "Blink";
            }
            else if(ua.indexOf("CriOS") != -1)// CriOS is Chrome on mobile devices
            {
                _browser = "Chrome";
                verMatch = ua.match(/CriOS\/[\d\.]+/i);
                if(verMatch)
                    _version = _engineVersion = verMatch[0].split("/")[1];
                
                 _engine = "WebKit";
            }
            else if(ua.indexOf("FxiOS") != -1)// FxiOS is Firefox on mobile devices
            {
                _browser = "Firefox";
                verMatch = ua.match(/FxiOS\/[\d\.]+/i);
                if(verMatch)
                    _version = _engineVersion = verMatch[0].split("/")[1];
                
                 _engine = "WebKit";
            }
        }
    }   
}
//Ensure this cannot be instantiated elsewhere
class Enforcer{
}
