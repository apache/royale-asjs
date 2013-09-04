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
package org.apache.flex.html.staticControls.supportClasses
{
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.UIBase;
	
	public class UIItemRendererBase extends UIBase implements IItemRenderer
	{
		public function UIItemRendererBase()
		{
		}
		
		public var backgroundColor:uint = 0xFFFFFF;
		public var highlightColor:uint = 0xCEDBEF;
		public var selectedColor:uint = 0xA8C6EE;
		public var downColor:uint = 0x808080;
		
		private var _data:Object;
		
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		private var _index:int;
		
		public function get index():int
		{
			return _index;
		}
		public function set index(value:int):void
		{
			_index = value;
		}
		
		private var _hovered:Boolean;
		
		public function get hovered():Boolean
		{
			return _hovered;
		}
		public function set hovered(value:Boolean):void
		{
			_hovered = value;
			updateRenderer();
		}
		
		private var _selected:Boolean;
		
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			_selected = value;
			updateRenderer();
		}
		
		private var _down:Boolean;
		
		public function get down():Boolean
		{
			return _down;
		}
		public function set down(value:Boolean):void
		{
			_down = value;
			updateRenderer();
		}
		
		public function updateRenderer():void
		{
			if (down)
				backgroundColor = downColor;
			else if (hovered)
				backgroundColor = highlightColor;
			else if (selected)
				backgroundColor = selectedColor;
		}
	}
}