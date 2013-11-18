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
	import flash.text.TextFieldType;
	
	import org.apache.flex.core.CSSTextField;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.staticControls.beads.ITextItemRenderer;

	public class StringItemRenderer extends UIItemRendererBase implements ITextItemRenderer
	{
		public function StringItemRenderer()
		{
			super();
			
			textField = new CSSTextField();
			textField.type = TextFieldType.DYNAMIC;
			textField.selectable = false;
		}
		
		public var textField:CSSTextField;
		
		override public function addedToParent():void
		{
			super.addedToParent();
			
			addChild(textField);

			adjustSize();
		}
		
		override public function adjustSize():void
		{
			textField.x = 0;
			textField.y = 0;
			textField.width = this.width;
			textField.height = this.height;
		}
		
		public function get text():String
		{
			return textField.text;
		}
		
		public function set text(value:String):void
		{
			textField.text = value;
		}
		
		override public function updateRenderer():void
		{
			super.updateRenderer();
			
			textField.background = (down || selected || hovered);
			textField.backgroundColor = backgroundColor;
		}
	}
}