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
	import org.apache.royale.style.elements.Span;
	import org.apache.royale.style.skins.IRadialProgressSkin;
	import org.apache.royale.utils.number.pinValue;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.elements.Div;
	COMPILE::JS{
		import org.apache.royale.core.WrappedHTMLElement;
	}

	

	public class RadialProgress extends StyleUIBase
	{
		public function RadialProgress()
		{
			super();
			//defaults
			value = 0;
			thickness = 20;
		}
		
		override protected function requiresView():Boolean{
			return false;
		}
		override protected function requiresController():Boolean{
			return false;
		}

		private var bg:Div;
		private var span:Span;
		private var fg:Div;

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement{
			var elem:WrappedHTMLElement = super.createElement();
			bg = new Div();
			addElement(bg);
			span = new Span();
			addElement(span);
			fg = new Div();
			addElement(fg);
			element.setAttribute('role','progressbar');
			return elem;
		}
		
	

		override protected function applySkin():void
		{
			var skin:IRadialProgressSkin = this.skin as IRadialProgressSkin
			assert(skin is IRadialProgressSkin, "RadialProgress requires a skin that implements IRadialProgressSkin");
			skin.processBackgroundRadialStyles(bg);
			skin.processForegroundRadialStyles(fg);
		}
		
		private var _value:Number; // this will be set in the constructor
		public function get value():Number{
			return _value;
		}
		public function set value(value:Number):void{
			if (isNaN(value)) value = 0;
			else value = pinValue(value,0,100);
			if (_value != value) {
				_value = value;
				setAttribute('aria-valuenow',value);
				span.text = value.toFixed(0) + '%'
				if (skin) {
					(skin as IRadialProgressSkin).processValue();
				}
			}
		}
		
		private var _customSize:Number;
		public function get customSize():Number{
			return _customSize
		}
		
		public function set customSize(value:Number):void{
			if (value<=0) value = NaN;	//NaN or 0 or less than zero is 'this property is not applicable'
			if (_customSize != value) {
				_customSize = value;
				if (skin) {
					(skin as IRadialProgressSkin).setSize();
				}
			}
		}
		
		override public function set size(value:String):void{
			if (size != value) {
				super.size = value;
				if (skin) {
					(skin as IRadialProgressSkin).setSize();
				}
			}
		}
		
		private var _thickness:uint;
		public function get thickness():uint{
			return _thickness
		}
		
		public function set thickness(value:uint):void{
			value = pinValue(value,0,100);
			if (_thickness != value) {
				_thickness = value;
				if (skin) {
					(skin as IRadialProgressSkin).applyThickNess();
				}
			}
		}
		
		private var _flavor:String = 'default';
		public function get flavor():String
		{
			return _flavor;
		}
	
		[Inspectable(category="General", enumeration="base,primary,secondary,accent,info,success,warning,error,neutral", defaultValue="default")]
		/**
		 * Set the flavor of the Toast
		 * One of info, success, positive and negative. warning also appears to be an option
		 * To set the Toast to the default, specify an empty string
		 */
		public function set flavor(value:String):void
		{
			if (!value) value = 'default';
			if(value != _flavor){
				switch(value){
					case "default":
					case 'base':
					case 'primary':
					case 'secondary':
					case 'accent':
					case 'info':
					case 'success':
					case 'warning':
					case 'error':
					case 'neutral':
						break;
					default:
						throw new Error("Unknown flavor: " + value);
				}
				_flavor = value;
				if (skin) {
					(skin as IRadialProgressSkin).setColors()
				}
			}
		}
		
		
		private var _background:String = 'default';
		public function get background():String
		{
			return _background;
		}
		
		[Inspectable(category="General", enumeration="base,primary,secondary,accent,info,success,warning,error,neutral", defaultValue="default")]
		public function set background(value:String):void
		{
			if (!value) value = 'default';
			if(value != _background){
				switch(value){
					case "default":
					case 'base':
					case 'primary':
					case 'secondary':
					case 'accent':
					case 'info':
					case 'success':
					case 'warning':
					case 'error':
					case 'neutral':
						break;
					default:
						throw new Error("Unknown background: " + value);
				}
				_background = value;
				if (skin) {
					(skin as IRadialProgressSkin).setColors()
				}
			}
		}
		
		
		/*
		The following overrides are presumptive, but I assume something like this makes sense
		Probably if width and height were both set in mxml, the last one set 'wins',
		Another option might be to do some scaling transform from these setters... not sure what's best.
		 */
		override public function setWidth(value:Number, noEvent:Boolean = false):void{
			setWidthAndHeight(value,value);
		}
		
		override public function setHeight(value:Number, noEvent:Boolean = false):void{
			setWidthAndHeight(value,value);
		}
		
		override public function setWidthAndHeight(width:Number,height:Number, noEvent:Boolean = false):void{
			//if they arrive as different values, then this is arbitrary, but for now do this:
			var value:Number = Math.min(width,height);
			if (!isNaN(value) && value > 0) {
				super.setWidthAndHeight(value,value,noEvent);
				unit = 'px';
				customSize = value;
			}
		}
	
	}
}