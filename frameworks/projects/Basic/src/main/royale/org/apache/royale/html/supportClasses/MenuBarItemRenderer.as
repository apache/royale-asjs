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
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.html.Label;
	import org.apache.royale.html.beads.ITextItemRenderer;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	import org.apache.royale.html.util.getLabelFromData;
	
	public class MenuBarItemRenderer extends DataItemRenderer implements ITextItemRenderer
	{
		public function MenuBarItemRenderer()
		{
			super();
			typeNames = "MenuBarItemRenderer";
			
			label = new Label();
		}
		
		private var label:Label;
		
		override public function addedToParent():void
		{
			super.addedToParent();
			
			addElement(label);
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			
			label.text = getLabelFromData(this,value);
			
			adjustSize();
		}
		
		/**
		 * The label of the itemRenderer, if any.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get text():String
		{
			return label.text;
		}
		public function set text(value:String):void
		{
			label.text = text;
		}
		
		/**
		 * @private
		 */
		override public function adjustSize():void
		{
			var cy:Number = height/2;
			
			label.x = 0;
			label.y = cy - label.height/2;
			label.width = width;
			
			var h:Number = height;
			var w:Number = width;
		}
	}
}