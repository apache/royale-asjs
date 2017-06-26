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
	 *  The OSUtils class is an all-static class with methods for
	 *  getting informatiojn about the host operating system.
	 *  You do not create instances of OSUtils;
	 *  instead you call methods such as 
	 *  the <code>OSUtils.getOS()</code> method.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 *  @productversion FlexJS 0.0
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
        public static const UNKNOWN_OS:String = "Unknown OS";

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
                    _osName = "Unknown OS";
                    var appVersion:String = navigator.appVersion;
                    if (appVersion.indexOf("Win") != -1) _osName="Windows";
                    if (appVersion.indexOf("Mac") != -1) _osName="MacOS";
                    if (appVersion.indexOf("X11") != -1) _osName="UNIX";
                    if (appVersion.indexOf("Linux") != -1) _osName="Linux";
                }
                return _osName;
            }
        }
        
        private static var _osName:String;
    }
}