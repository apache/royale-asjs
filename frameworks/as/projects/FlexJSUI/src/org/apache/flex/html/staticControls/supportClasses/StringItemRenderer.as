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
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	import org.apache.flex.core.CSSTextField;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.staticControls.beads.ITextItemRenderer;

	/**
	 *  The StringItemRenderer class displays data in string form using the data's toString()
	 *  function.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class StringItemRenderer extends DataItemRenderer implements ITextItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function StringItemRenderer()
		{
			super();
			
			textField = new CSSTextField();
			textField.type = TextFieldType.DYNAMIC;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
		}
		
		public var textField:CSSTextField;
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
			
			addChild(textField);

			adjustSize();
		}
		
		/**
		 * @private
		 */
		override public function adjustSize():void
		{
			var cy:Number = this.height/2;
			
			textField.x = 0;
			textField.y = cy - textField.height/2;
			textField.width = this.width;
			
			updateRenderer();
		}
		
		/**
		 *  The text currently displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get text():String
		{
			return textField.text;
		}
		
		public function set text(value:String):void
		{
			textField.text = value;
		}
		
		/**
		 *  Sets the data value and uses the String version of the data for display.
		 * 
		 *  @param Object data The object being displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
			if (labelField) textField.text = String(value[labelField]);
			else if (dataField) textField.text = String(value[dataField]);
			else textField.text = String(value);
		}
		
		/**
		 * @private
		 */
		override public function updateRenderer():void
		{
			super.updateRenderer();
			
			textField.background = (down || selected || hovered);
			textField.backgroundColor = backgroundColor;
		}
	}
}