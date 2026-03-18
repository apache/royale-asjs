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
package org.apache.royale.style.stylebeads.anim
{
	import org.apache.royale.style.stylebeads.CompositeStyle;
	import org.apache.royale.style.util.ThemeManager;

	public class Transition extends CompositeStyle
	{
		public function Transition(property:String= "default")
		{
			super();
			_property = property;
			propStyle = new TransitionProperty(property);
			timingStyle = new TransitionTimingFunction("default");
			durationStyle = new TransitionDuration("default");
			styles = [
				propStyle,
				timingStyle,
				durationStyle
			];
		}
		private var _property:String = "default";

		public function get property():String
		{
			return _property;
		}
		private var propStyle:TransitionProperty;
		public function set property(value:String):void
		{
			propStyle.value = _property = value;
		}

		private var _timingFunction:String = "default";
		private var timingStyle:TransitionTimingFunction;
		public function get timingFunction():String
		{
			return _timingFunction;
		}

		public function set timingFunction(value:String):void
		{
			timingStyle.value = _timingFunction = value;
		}

		private var _duration:String = "default";
		public function get duration():String
		{
			return _duration;
		}
		private var durationStyle:TransitionDuration;
		public function set duration(value:String):void
		{
			durationStyle.value = _duration = value;
		}

	}
}