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
package org.apache.royale.style.stylebeads
{
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.util.CSSUnit;

	public class PaddingStyle extends SpacingBase
	{
		public function PaddingStyle()
		{
			super();

		}

		override public function get selectors():Array
		{
			var items:Array = stringify();
			if(items.length > 1)
				return [".pt" + items[0], ".pr" + items[1], ".pb" + items[2], ".pl" + items[3]];
			
			return [".p" + items[0]];
		}
	
		override public function get rules():Array
		{
			var items:Array = stringify();
			if(items.length > 1)
				return ["padding-top:" + items[0] + ";", "padding-right:" + items[1] + ";", "padding-bottom:" + items[2] + ";", "padding-left:" + items[3] + ";"];
			
			return ["padding:" + items[0] + ";"];
		}

	}
}