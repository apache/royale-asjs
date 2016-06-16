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

package flex.system
{
COMPILE::SWF
{
	import flash.system.ApplicationDomain;		
}

	public class DefinitionManager
	{
		COMPILE::SWF
		public function DefinitionManager(appdom:ApplicationDomain = null)
		{
			if (appdom)
				this.appdom = appdom;
			else
				this.appdom = ApplicationDomain.currentDomain;
		}
		
		COMPILE::SWF
		private var appdom:ApplicationDomain;
		
		public function hasDefinition(name:String):Boolean
		{
			COMPILE::SWF
			{
				return appdom.hasDefinition(name);
			}
			COMPILE::JS
			{
				var parts:Array = name.split(".");
				var obj:* = window;
				for each (var part:String in parts)
				{
					obj = obj[part];
					if (obj === undefined)
						return false;
				}
				return true;
			}
		}
		
		public function getDefinition(name:String):Object
		{
			COMPILE::SWF
			{
				return appdom.getDefinition(name);
			}
			COMPILE::JS
			{
				var parts:Array = name.split(".");
				var obj:* = window;
				for each (var part:String in parts)
				{
					obj = obj[part];
					if (obj === undefined)
						throw new Error("definition not found");
				}
				return obj;				
			}
		}
	}
}
