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
	COMPILE::SWF
	{
		import flash.system.Capabilities;
	}
	
	public class Platform
	{
		public function Platform()
		{
		}
		
		public static const ANDROID:String = "Android";
		public static const BLACKBERRY:String = "Blackberry";
		public static const IOS:String = "IOS";
		public static const MAC:String = "Mac";
		public static const LINUX:String = "Linux";
		public static const WINDOWS:String = "windows";

		
		private static var _isMobile:Boolean;
		public static function get isMobile():Boolean
		{
			return _isMobile;
		}
	
		private static var _isIPad:Boolean;
		public static function get isIPad():Boolean
		{
			return _isIPad;
		}
		
		COMPILE::SWF
		private static var _isAir:Boolean;
		
		public static function get isAir():Boolean
		{
			COMPILE::SWF
			{
				return _isAir;					
			}
			COMPILE::JS
			{
				return false;
			}
		}
		
		private static var _isBrowser:Boolean;
		public static function get isBrowser():Boolean
		{
			return _isBrowser;
		}
		
		public static function get isFlash():Boolean
		{
			COMPILE::SWF
			{
				return true;
			}
			COMPILE::JS
			{
				return false;
			}
		}
		
		private static var _platform:String;
		
		public static function get platform():String
		{
			COMPILE::SWF
			{
				if (!platform)
				{
					var cap: Class = Capabilities;
					var version:  String = Capabilities.version;
					var os: String = Capabilities.os;
					var playerType: String = Capabilities.playerType;
					
					if (version.indexOf("AND") > -1)
						_platform = ANDROID;
					else if (version.indexOf('IOS') > -1)
						_platform = IOS;
					else if (version.indexOf('QNX') > -1)
						_platform = BLACKBERRY;
					else if (os.indexOf("Mac OS") != -1)
						_platform = MAC;
					else if (os.indexOf("Windows") != -1)
						_platform = WINDOWS;
					else if (os.indexOf("Linux") != -1) // note that Android is also Linux
						_platform = LINUX;

					
					_isIPad = os.indexOf('iPad') > -1;
					
					_isMobile = (_platform == ANDROID || _platform == IOS || _platform == BLACKBERRY);
						
						
					_isAir = playerType == "Desktop";
					_isBrowser = (playerType == "PlugIn" || playerType == "ActiveX");
					
				}
			}
			COMPILE::JS
			{
				if (navigator.userAgent.indexOf("iOS") != -1)
					_platform = IOS;
				else if (navigator.userAgent.indexOf("Android") != -1)
					_platform = ANDROID;
				else if (navigator.appVersion.indexOf("Win")!=-1)
					_platform = WINDOWS;
				else if (navigator.appVersion.indexOf("Mac")!=-1)
					_platform = MAC;
				else if (navigator.appVersion.indexOf("Linux")!=-1)
					_platform = LINUX;
				
				_isIPad = navigator.userAgent.indexOf('iPad') > -1;
				
				_isMobile = (_platform == ANDROID || _platform == IOS || _platform == BLACKBERRY);					
			}
			return _platform;
		}

	}
	
}
