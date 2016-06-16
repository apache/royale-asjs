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

package flex.display
{
	COMPILE::SWF
	{
		import flash.display.LoaderInfo;		
	}

	public class ModuleInfo
	{
		
		COMPILE::SWF
		private var loaderInfo:LoaderInfo;
		
		COMPILE::SWF
		public function ModuleInfo(loaderInfo:LoaderInfo)
		{
			this.loaderInfo = loaderInfo;
		}
		
		COMPILE::SWF
		public function get height():Number
		{
			return loaderInfo.height;			
		}
		
		COMPILE::SWF
		public function get width():Number
		{
			return loaderInfo.width;
		}
		
		COMPILE::SWF
		public function get url():String
		{
			return loaderInfo.url;
		}
		
		COMPILE::JS
		public function get height():Number
		{
			return document.height;			
		}
		
		COMPILE::JS
		public function get width():Number
		{
			return document.width;
		}
		
		COMPILE::JS
		public function get url():String
		{
			return document.URL;
		}
	}
}
