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
package org.apache.royale.style.elements
{
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.skins.ILabelSkin;
	import org.apache.royale.style.support.NodeElementBase;

	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}
	public class Label extends NodeElementBase
	{
		public function Label()
		{
			super();
		}

		private var textElement:Span;
		private var _text:String;
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			var elem:WrappedHTMLElement = super.createElement();
			textElement = new Span();
			addElement(textElement);
			textElement.text = _text || "";
			return elem;
		}
		override protected function applySkin():void
		{
			var labelSkin:ILabelSkin = skin as ILabelSkin;
			assert(labelSkin, "Label requires a skin that implements ILabelSkin");
			var styles:Array = labelSkin.labelStyles || [];
			if(textElement) {
				textElement.setStyles(styles, true);
			}
		}
		public function get for():String
		{
			return getAttribute("for");
		}
		public function set for(value:String):void
		{
			setAttribute("for", value);
		}
		public function get text():String
		{
			if(textElement)
				return textElement.text;
			return _text;
		}
		public function set text(value:String):void
		{
			_text = value;
			if(textElement) {
				textElement.text = value || "";
			}
		}
		override protected function getTag():String
		{
			return "label";
		}
	}
}
