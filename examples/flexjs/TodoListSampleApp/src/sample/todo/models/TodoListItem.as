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
package sample.todo.models
{
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	
	[Event("titleChanged","org.apache.flex.events.Event")]
	[Event("selectedChanged","org.apache.flex.events.Event")]
	[Event("removeItem","org.apache.flex.events.Event")]
	
	public class TodoListItem extends EventDispatcher
	{
		public function TodoListItem(title:String, selected:Boolean)
		{
			super();
			_title = title;
			_selected = selected;
		}
		
		private var _title:String;
		[Event("titleChanged")]
		public function get title():String
		{
			return _title;
		}
		public function set title(value:String):void
		{
			_title = value;
			dispatchEvent(new Event("titleChanged"));
		}
		
		private var _selected:Boolean;
		[Event("selectedChanged")]
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			_selected = value;
			dispatchEvent(new Event("selectedChanged"));
		}
		
		public function remove():void
		{
			dispatchEvent(new Event("removeItem"));
		}
	}
}