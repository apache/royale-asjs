// //////////////////////////////////////////////////////////////////////////////
// 
// Licensed to the Apache Software Foundation (ASF) under one or more
// contributor license agreements.  See the NOTICE file distributed with
// this work for additional information regarding copyright ownership.
// The ASF licenses this file to You under the Apache License, Version 2.0
// (the "License"); you may not use this file except in compliance with
// the License.  You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// 
// //////////////////////////////////////////////////////////////////////////////
package org.apache.royale.style
{
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.elements.Legend;
	import org.apache.royale.style.skins.FieldsetSkin;

	public class Fieldset extends Group
	{

		public function Fieldset()
		{
			super();
		}

		private var legend:Legend;

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			var elem:WrappedHTMLElement = super.createElement();
			legend = new Legend();
			if(_text)
				legend.text = _text;
			addElement(legend);
			return elem;
		}

		override protected function applySkin():void
		{
			var fieldsetSkin:FieldsetSkin = skin as FieldsetSkin;
			assert(fieldsetSkin, "Fieldset requires a skin that implements FieldsetSkin");
			if (legend) {
				var styles:Array = fieldsetSkin.legendStyles || [];
				legend.setStyles(styles);
			}
		}

		private var _text:String;
		COMPILE::JS
		public function get text():String
		{
			return _text;
		}
		public function set text(value:String):void
		{
			_text = value;
			if(legend)
				legend.text = value;
		}

		override protected function getTag():String
		{
			return "fieldset";
		}
	}
}
