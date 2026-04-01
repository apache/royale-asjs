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
package org.apache.royale.style
{
	COMPILE::JS{
		import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.style.elements.Div;
	}
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IMXMLDocument;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.MXMLDataInterpreter;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.skins.IDividerSkin;
	

	public class Divider extends StyleUIBase
	{
		public function Divider()
		{
			super();
			unit = 'px';
		}
		
		override protected function requiresView():Boolean{
			return false;
		}
		override protected function requiresController():Boolean{
			return false;
		}
		/*override protected function requiresLayout():Boolean{
			return false;
		}*/
		
		COMPILE::JS
		private var _line:Div;

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement{
			var elem:WrappedHTMLElement = super.createElement();
			_line = new Div();
			addElement(_line);
			return elem;
		}
		
		/**
		 * The internal line element.
		 */
		COMPILE::JS
		public function get line():Div{
			return _line;
		}

		override protected function applySkin():void
		{
			var divSkin:IDividerSkin = skin as IDividerSkin;
			assert(divSkin, "Divider requires a skin that implements IDividerSkin");
			COMPILE::JS
			{
				var styles:Array = divSkin.lineStyles || [];
				_line.setStyles(styles, true);
			}
		}
		
		private var _edgePadding:Number = 0;
		public function get edgePadding():Number{
			return _edgePadding;
		}
		public function set edgePadding(value:Number):void{
			if (_edgePadding != value) {
				_edgePadding = value;
				if (skin) skin.update();
			}
		}
		
		private var _vertical:Boolean;
		
		/**
		 * Whether horizontal or vertical divider
		 */
		public function get vertical():Boolean
		{
			return _vertical;
		}
		
		public function set vertical(value:Boolean):void
		{
			if(value != !!_vertical){
				_vertical = value;
				if (skin) skin.update();
			}
			
		}
	}
}