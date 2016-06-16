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
	
	public class Display
	{
		public function Display()
		{
		}
		
		public static function get dpi():int
		{
			COMPILE::SWF
			{
				return Capabilities.screenDPI;	
			}
			COMPILE::JS
			{
				// TODO (aharui)
				return 96;
			}
		}

		public static function get width():int
		{
			COMPILE::SWF
			{
				return Capabilities.screenResolutionX;	
			}
			COMPILE::JS
			{
				return screen.width;
			}
		}

		public static function get height():int
		{
			COMPILE::SWF
			{
				return Capabilities.screenResolutionY;	
			}
			COMPILE::JS
			{
				return screen.height;
			}
		}
	}
	
}
