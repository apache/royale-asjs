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
package flexUnitTests.binding.support.bindings.bindables
{
	[Bindable]
	public class TaskVO_on_top_of_class implements ITaskVO
	{
		public function DominoPartitionTaskVO(label:String = null, data:String = null, tooltip:String = null)
		{
			
			this.label = label;
			this.data = data;
			this.tooltip = tooltip;
		}
		
		private var _label:String;
		
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
		}

		private var _data:String;

		public function get data():String
		{
			return _data;
		}
		
		public function set data(value:String):void
		{
			_data = value;
		}
		
		private var _tooltip:String;

		public function get tooltip():String
		{
			return _tooltip;
		}
		
		public function set tooltip(value:String):void
		{
			_tooltip = value;
		}

		private var _selected:Boolean
		public function get selected():Boolean{
			return _selected;
		}
		public function set selected(value:Boolean):void{
			_selected = value;
		}
	}
}