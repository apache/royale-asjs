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
package org.apache.royale.style.stylebeads.states.attribute
{
	import org.apache.royale.style.stylebeads.states.NotState;

	/**
	 * NotDataState is a decorator that adds a :not([data-attribute]) pseudo-class to the rule.
	 */
	public class NotDataState extends NotState
	{
		public function NotDataState(type:String = null, styles:Array = null)
		{
			super(null, styles);
			if(type)
			{
				dataType = type;
			}
		}
		private var _dataType:String;

		public function get dataType():String
		{
			return _dataType;
		}

		public function set dataType(value:String):void
		{
			_dataType = value;
			ruleDecorator = "[data-" + value + "]";
			selectorDecorator = "not-data-" + value + ":";
		}
	}
}
