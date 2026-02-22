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
	public class MinHeight extends MeasurementStyleBase
	{
		public function MinHeight()
		{
			super();
		}

		[Inspectable(category="General", enumeration="max-content,min-content,fit-content,stretch,none,65ch,640px,768px,1024px,1280px,1536px", defaultValue="none")]
		public function get fit():String
		{
			return _strVal;
		}

		public function set fit(value:String):void
		{
			_strVal = value;
		}

		override public function get selectors():Array
		{
			return [".min-w-" + toSelector()];
		}
	
		override public function get rules():Array
		{
			return ["min-width:" + toRuleVal() + ";"];
		}
	}
}