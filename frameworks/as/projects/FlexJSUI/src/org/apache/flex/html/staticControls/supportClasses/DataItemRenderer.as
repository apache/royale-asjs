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
	import flash.display.Sprite;

	public class DataItemRenderer extends UIItemRendererBase
	{
		public function DataItemRenderer()
		{
			super();
		}
		
		private var _columnIndex:int;
		public function get columnIndex():int
		{
			return _columnIndex;
		}
		public function set columnIndex(value:int):void
		{
			_columnIndex = value;
		}
		
		private var _rowIndex:int;
		public function get rowIndex():int
		{
			return _rowIndex;
		}
		public function set rowIndex(value:int):void
		{
			_rowIndex = value;
		}
		
		private var _labelField:String = "label";
		public function get labelField():String
		{
			return _labelField;
		}
		public function set labelField(value:String):void
		{
			_labelField = value;
		}
		
		private var background:Sprite;
		
		override public function addedToParent():void
		{
			super.addedToParent();
			
			background = new Sprite();
			addChild(background);
		}
		
		override public function updateRenderer():void
		{
			super.updateRenderer();
			
			background.graphics.clear();
			background.graphics.beginFill(backgroundColor, (down||selected||hovered)?1:0);
			background.graphics.drawRect(0, 0, this.width, this.height);
			background.graphics.endFill();
		}
	}
}