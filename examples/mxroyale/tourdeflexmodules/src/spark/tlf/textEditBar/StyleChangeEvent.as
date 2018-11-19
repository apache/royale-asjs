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
package textEditBar
{
	import flash.events.Event;
	
	import flashx.textLayout.formats.ITextLayoutFormat;

	public class StyleChangeEvent extends Event
	{
		private var _attrs:Object;
		
		public function StyleChangeEvent(type:String, styleAttrs:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_attrs = styleAttrs;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new StyleChangeEvent(type, _attrs, bubbles, cancelable);
		}
		
		public function get format():ITextLayoutFormat
		{ return _attrs as ITextLayoutFormat; }	
		
		public function get attrs():Object
		{ return _attrs; }
	}
}