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
package models
{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;

	public class Asset extends EventDispatcher
	{
		private var _label:String;
		private var _value:Number;
		private var _netChange:Number;

		public function Asset(newLabel:String, newValue:Number, newNetChange:Number)
		{
			_label = newLabel;
			_value = newValue;
			_netChange = newNetChange;
		}

		[Bindable("labelChanged")]
		public function get label():String
		{
			return _label;
		}
		public function set label(value:String):void
		{
			if (value != _label) {
				_label = value;
			dispatchEvent(new Event("labelChanged"));
			}
		}

		[Bindable("valueChanged")]
		public function get value():Number
		{
			return _value;
		}
		public function set value(newValue:Number):void
		{
			if (_value != newValue) {
				_value = newValue;
			dispatchEvent(new Event("valueChanged"));
			}
		}

		[Bindable("netChangeChanged")]
		public function get netChange():Number
		{
			return _netChange;
		}
		public function set netChange(value:Number):void
		{
			if (_netChange != value) {
				_netChange = value;
			dispatchEvent(new Event("netChangeChanged"));
			}
		}
	}

}
