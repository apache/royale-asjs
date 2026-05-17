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
	}
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.skins.IBarLoaderSkin;
	import org.apache.royale.style.elements.Div;
	/**
	 *  Dispatched when the user interacts with the Progress component.
	 *
	 */
	[Event(name="change", type="org.apache.royale.events.Event")]

	public class BarLoader extends StyleUIBase
	{

		public function BarLoader()
		{
			super();
		}

		COMPILE::JS
		private var _barLoader:Div;

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement{
			super.createElement();
			_barLoader = new Div();
			addElement(_barLoader);
			return element;
		}
		private var _value:Number = 0;
		public function get value():Number
		{
			return _value;
		}
		public function set value(val:Number):void
		{
			_value = val;
			COMPILE::JS
			{
				var percentValue:String = Math.max(0, Math.min(100, val)) + "%";
				_barLoader.setStyle("width", percentValue);
			}
		}
		private var _small:Boolean = false;
		public function get small():Boolean
		{
			return _small;
		}
		public function set small(val:Boolean):void
		{
			_small = val;
			COMPILE::JS
			{
				setStyle("height", val ? "0.417rem" : "0.625rem");
			}
		}
		private var _indeterminate:Boolean = false;
		public function get indeterminate():Boolean
		{
			return _indeterminate;
		}
		public function set indeterminate(val:Boolean):void
		{
			_indeterminate = val;
		}
		override protected function applySkin():void
		{
			var loaderSkin:IBarLoaderSkin = skin as IBarLoaderSkin;
			assert(loaderSkin, "BarLoader requires a skin that implements IBarLoaderSkin");
			COMPILE::JS
			{
				var styles:Array = loaderSkin.barLoaderStyles || [];
				if(_indeterminate){
					styles = styles.concat(loaderSkin.indeterminateStyles || []);
				}
				_barLoader.setStyles(styles);
			}
		}
	}
}