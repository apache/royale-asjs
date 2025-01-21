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
package org.apache.royale.utils
{
	COMPILE::SWF
	{
		import flash.display.DisplayObject;
		import flash.events.Event;
	}
	
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}

	import org.apache.royale.core.IBead;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IStyleableObject;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.IEventDispatcher;
	
	public class MockLayoutChild implements ILayoutChild, IUIBase, IStyleableObject
	{
		private var _explicitHeight:Number;
		private var _isHeightSizedToContent:Boolean;
		private var _isWidthSizedToContent:Boolean;
		private var _percentHeight:Number;
		private var _height:Number;
		private var _width:Number;
		private var _x:Number;
		private var _y:Number;
		private var _percentWidth:Number;
		private var _explicitWidth:Number;
		private var _source:ILayoutChild;
		private var _alpha:Number;
		private var _visible:Boolean;
		
		public function MockLayoutChild(source:ILayoutChild)
		{
			_source = source;
			_explicitHeight = source.explicitHeight;
			_explicitWidth = source.explicitWidth;
			_isHeightSizedToContent = source.isHeightSizedToContent();
			_isWidthSizedToContent = source.isWidthSizedToContent();
			_percentHeight = source.percentHeight;
			_percentWidth = source.percentWidth;
			_x = source.x;
			_y = source.y;
			_width = source.width;
			_height = source.height;
			_alpha = source.alpha;
			_visible = source.visible;
		}
		
		public function get explicitHeight():Number
		{
			return _explicitHeight;
		}
		
		public function set explicitHeight(value:Number):void
		{
			_explicitHeight = value;
		}
		
		public function isHeightSizedToContent():Boolean
		{
			return _isHeightSizedToContent;
		}
		
		public function get percentHeight():Number
		{
			return _percentHeight;
		}
		
		public function set percentHeight(value:Number):void
		{
			_percentHeight = value;
		}
		
		public function setWidthAndHeight(newWidth:Number, newHeight:Number, noEvent:Boolean=false):void
		{
			_width = newWidth;
			_height = newHeight;
		}
		
		public function setHeight(value:Number, noEvent:Boolean=false):void
		{
			_height = value;
		}
		
		public function setX(value:Number):void
		{
			_x = value;
		}
		
		public function setY(value:Number):void
		{
			_y = value;
		}
		
		public function get percentWidth():Number
		{
			return _percentWidth;
		}
		
		public function set percentWidth(value:Number):void
		{
			_percentWidth = value;
		}
		
		public function setWidth(value:Number, noEvent:Boolean=false):void
		{
			_width = value;
		}
		
		public function get explicitWidth():Number
		{
			return _explicitWidth;
		}
		public function set explicitWidth(value:Number):void
		{
			_explicitWidth = value;
		}
		private var _measuredWidth:Number;
		public function get measuredWidth():Number
		{
			return _measuredWidth;
		}

		public function set measuredWidth(value:Number):void
		{
			_measuredWidth = value;

		}
		private var _measuredHeight:Number;
		public function get measuredHeight():Number
		{
			return _measuredHeight;
		}

		public function set measuredHeight(value:Number):void
		{
			_measuredHeight = value;
		}

		public function isWidthSizedToContent():Boolean
		{
			return _isWidthSizedToContent;
		}
		
		public function get parent():IParent
		{
			return _source.parent;
		}
		
		COMPILE::SWF
		public function get $displayObject():DisplayObject
		{
			return _source.$displayObject;
		}
		
		public function addedToParent():void
		{
		}
		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			_alpha = value;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
		}
		
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
		}
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void
		{
			_visible = value;
		}
		
		public function get topMostEventDispatcher():IEventDispatcher
		{
			return _source.topMostEventDispatcher;
		}
		
		public function addBead(bead:IBead):void
		{
		}
		
		public function getBeadByType(classOrInterface:Class):IBead
		{
			return _source.getBeadByType(classOrInterface);
		}
		
		public function removeBead(bead:IBead):IBead
		{
			return null;
		}
		
		COMPILE::JS
		public function addEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
		{
		}

		COMPILE::SWF
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
		}
		
		COMPILE::SWF
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
		}
		
		COMPILE::JS
		public function removeEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
		{
			// TODO Auto Generated method stub
		}

		
		COMPILE::SWF
		public function dispatchEvent(event:Event):Boolean
		{
			return false;
		}
		
		COMPILE::JS
		public function dispatchEvent(event:Object):Boolean
		{
			return false;
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return (_source as IEventDispatcher).hasEventListener(type);
		}
		
		COMPILE::SWF
		public function willTrigger(type:String):Boolean
		{
			return (_source as IEventDispatcher).willTrigger(type);
		}
		
		public function get className():String
		{
			return (_source as IStyleableObject).className;
		}
		
		public function set className(value:String):void
		{
			// TODO Auto Generated method stub
		}
		
		public function get id():String
		{
			return (_source as IStyleableObject).id;
		}
		
		public function get style():Object
		{
			return (_source as IStyleableObject).style;
		}
		
		COMPILE::JS
		public function get positioner():WrappedHTMLElement
		{
			return null;
		}
		
		COMPILE::JS
		public function get element():WrappedHTMLElement
		{
			return null;
		}

		COMPILE::JS
        public function set positioner(value:WrappedHTMLElement):void
		{
			// void implementation of IUIBase.positioner
		}
	}
}
