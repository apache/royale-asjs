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
	 *  The IOSUtils class is an all-static class with methods for
	 *  getting information about the IOS operating system.
	 *  You do not create instances of IOSUtils;
	 *  instead you call methods such as 
	 *  the <code>IOSUtils.getDevice()</code> method.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 1.0.0
	 *  @productversion Royale 0.9.6
	 */
    public class IOSUtils
    {
        COMPILE::SWF
        {
            import flash.system.Capabilities;
        }
        public function OSUtils ()
        {
        }
        public static const IOS_OS:String = "iOS";
        
        public static const UNKNOWN_DEVICE:String = "Unknown Device";
        public static const IOS_IPAD:String = "iPad";
        public static const IOS_IPHONE:String = "iPhone";
        public static const IOS_IPOD:String = "iPod";

        /**
         * Gets the name of the operating system.
         */
        public static function getIOSDevice():String
        {
            COMPILE::SWF
            {
                if(!_iosDevice)
                {
                    //TODO for SWF
                    _iosDevice = UNKNOWN_DEVICE;
                }
                return _iosDevice;
            }

            COMPILE::JS
            {
                if(!_iosDevice)
                {
                    _iosDevice = UNKNOWN_DEVICE;
                    var appVersion:String = navigator.appVersion;
                    if (appVersion.indexOf("iPad") != -1) _iosDevice = IOS_IPAD;
                    if (appVersion.indexOf("iPhone") != -1) _iosDevice = IOS_IPHONE;
                    if (appVersion.indexOf("iPod") != -1) _iosDevice = IOS_IPOD;
                }
                return _iosDevice;
            }
        }
        
        private static var _iosDevice:String;
    }
}
