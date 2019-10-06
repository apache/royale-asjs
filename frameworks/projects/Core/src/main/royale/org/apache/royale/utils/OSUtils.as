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
	 *  The OSUtils class is an all-static class with methods for
	 *  getting information about the host operating system.
	 *  You do not create instances of OSUtils;
	 *  instead you call methods such as 
	 *  the <code>OSUtils.getOS()</code> method.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 1.0.0
	 *  @productversion Royale 0.0
	 */
    public class OSUtils
    {
        COMPILE::SWF
        {
            import flash.system.Capabilities;
        }
        public function OSUtils ()
        {
        }
        public static const MAC_OS:String = "MacOS";
        public static const WIN_OS:String = "Windows";
        public static const LINUX_OS:String = "Linux";
        public static const UNIX_OS:String = "UNIX";
        public static const ANDROID_OS:String = "Android";
        public static const IOS_OS:String = "iOS";
        public static const UNKNOWN_OS:String = "Unknown OS";
        
        public static const UNKNOWN_VERSION:String = "Unknown OS Version";

        /**
         * Gets the name of the operating system.
         */
        public static function getOS():String
        {
            COMPILE::SWF
            {
                if(!_osName)
                {
                    if(Capabilities.os.indexOf("Mac OS") != -1)
                        _osName = "MacOS";
                    else if(Capabilities.os.indexOf("Windows") != -1)
                        _osName = "Windows";
                    else if(Capabilities.os.indexOf("Linux") != -1)
                        _osName = "Linux";
                    else
                        _osName = "Unknown OS";
                }
                return _osName;
            }

            COMPILE::JS
            {
                if(!_osName)
                {
                    _osName = UNKNOWN_OS;
                    var appVersion:String = navigator.appVersion;
                    if (appVersion.indexOf("Win") != -1) _osName = WIN_OS;
                    if (appVersion.indexOf("Macintosh") != -1) _osName = MAC_OS;
                    if (appVersion.indexOf("X11") != -1) _osName = UNIX_OS;
                    if (appVersion.indexOf("Linux") != -1) _osName = LINUX_OS;
                    if (appVersion.indexOf("iPad") != -1 || appVersion.indexOf("iPhone") != -1 || appVersion.indexOf("iPod") != -1) _osName = IOS_OS;
                    if (appVersion.indexOf("Android") != -1) _osName = ANDROID_OS;
                }
                return _osName;
            }
        }

        private static var _osName:String;

        /**
         * Gets the version of the operating system.
         */
        public static function getOSVersion():String
        {
            COMPILE::SWF
            {
            if(!_osVersion)
            {
                _osVersion = "To be implemented in SWF";
            }
            return _osVersion;
            }

            COMPILE::JS
            {
            if(!_osVersion)
            {
                var tokenizer:Array = navigator.userAgent.split(/\s*[;)(]\s*/);
                _osVersion = UNKNOWN_VERSION;
                if (/^Android/.test(tokenizer[2]))
                {
                    _osVersion = tokenizer[2].split("Android ").pop(); // "8.1.0"
                }
                else if (/^Linux/.test(tokenizer[3]))
                {
                    _osVersion = tokenizer[6].split("/").pop(); // "8.10" (Ubuntu)
                }
                else if (/^Macintosh/.test(tokenizer[1]))
                {
                    _osVersion = tokenizer[2].split("Mac OS X ").pop().replace(/_/g,'.'); // "10.8.2" (Mountain Lion)
                }
                else if (/^iPhone/.test(tokenizer[1]))
                {
                    _osVersion = tokenizer[2].split("CPU iPhone OS ").pop().replace(/_/g,'.').replace(' like Mac OS X',''); // "12.1.4"
                }
                else if (/^iPad/.test(tokenizer[1]))
                {
                    _osVersion = tokenizer[2].split("CPU OS ").pop().replace(/_/g,'.').replace(' like Mac OS X',''); // "12.1.4"
                }
                else if (/^iPod/.test(tokenizer[1]))
                {
                    _osVersion = tokenizer[2].split("CPU OS ").pop().replace(/_/g,'.').replace(' like Mac OS X',''); // "12.1.4" (this one needs test)
                }
                else
                {
                    _osVersion = tokenizer[3].split(" ").pop(); // "6.1" (Win 7)
                }
            }
            return _osVersion;
            }
        }

        private static var _osVersion:String;
    }
}
