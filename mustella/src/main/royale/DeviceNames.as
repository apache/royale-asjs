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
package {

COMPILE::SWF
{
import flash.display.DisplayObject;
import flash.system.Capabilities;
}

/**
 *  allowed values for deviceName
 *
 */
public class DeviceNames
{
	public static const ANDROID:String = "android";
	public static const IOS:String = "ios";
	public static const QNX:String = "qnx";
	public static const MAC:String = "mac";
	public static const WIN:String = "win";

	public static const OS_VALUES:Array = [WIN, MAC, ANDROID, IOS, QNX];
	public static const OS_VERSION_VALUES:Array = ["android22", "android23", "android3", "android4", "ios3x", "ios40", "ios41", "ios5", "ios6"];
	public static const DEVICE_VALUES:Array = ["air","desire","droid","droid2","droidX","evo","incredible","nexusOne","playbook"];

	public static function getFromOS ():String 
	{
        COMPILE::SWF
        {
		if (Capabilities.os.substring (0, Capabilities.os.indexOf (" ")) == "Windows" )
		{
			return WIN;
		} else if (Capabilities.os.substring (0, Capabilities.os.indexOf (" ")) == "Mac" )
		{
			return MAC;

		} else 
		{
			return "";
		}
        }
        COMPILE::JS
        {
            return "";
        }
	}

}
}
