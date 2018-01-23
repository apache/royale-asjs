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
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IContentView;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.events.IEventDispatcher;

	public class MockContentView implements IContentView, IParentIUIBase, ILayoutView
	{
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		private var elements:Array = [];

		public function MockContentView(source:ILayoutView)
		{
			var p:IParentIUIBase = source as IParentIUIBase;

			x = p.x;
			y = p.y;
			width = p.width;
			height = p.height;
			for (var i:int = 0; i < source.numElements; i++)
			{
				var mock:ILayoutChild = new MockLayoutChild(source.getElementAt(i) as ILayoutChild);
				elements.push(mock);
			}
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

		public function removeAllElements():void
		{
			elements = [];
		}

		public function addElement(c:IChild, dispatchEvent:Boolean=true):void
		{
			elements.push(c);
		}

		public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean=true):void
		{
			elements.splice(index, 0, c);
		}

		public function getElementIndex(c:IChild):int
		{
			return elements.indexOf(c);
		}

		public function removeElement(c:IChild, dispatchEvent:Boolean=true):void
		{
			var i:int = getElementIndex(c);
			elements.removeAt(i);
		}

		public function get numElements():int
		{
			return elements.length;
		}

		public function getElementAt(index:int):IChild
		{
			return elements[index] as IChild;
		}

		COMPILE::SWF
		public function get $displayObject():DisplayObject
		{
			// TODO Auto Generated method stub
			return null;
		}

		public function addBead(bead:IBead):void
		{
			// TODO Auto Generated method stub

		}

		public function getBeadByType(classOrInterface:Class):IBead
		{
			// TODO Auto Generated method stub
			return null;
		}

		public function removeBead(bead:IBead):IBead
		{
			// TODO Auto Generated method stub
			return null;
		}

		COMPILE::SWF
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			// TODO Auto Generated method stub
		}

		COMPILE::JS
		public function addEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
		{
		}

		COMPILE::SWF
		public function dispatchEvent(event:flash.events.Event):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}

		COMPILE::JS
		public function dispatchEvent(event:Object):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}

		public function hasEventListener(type:String):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}

		COMPILE::SWF
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			// TODO Auto Generated method stub
		}

		COMPILE::JS
		public function removeEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
		{
			// TODO Auto Generated method stub
		}

		public function willTrigger(type:String):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}

		public function get parent():IParent
		{
			// TODO Auto Generated method stub
			return null;
		}

		public function addedToParent():void
		{
			// TODO Auto Generated method stub

		}

		public function get alpha():Number
		{
			// TODO Auto Generated method stub
			return 0;
		}

		public function set alpha(value:Number):void
		{
			// TODO Auto Generated method stub

		}

		public function get topMostEventDispatcher():IEventDispatcher
		{
			// TODO Auto Generated method stub
			return null;
		}

		public function set visible(value:Boolean):void
		{
			// TODO Auto Generated method stub

		}

		public function get visible():Boolean
		{
			// TODO Auto Generated method stub
			return false;
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
		public function internalChildren():Array
		{
			return elements;
		}

		COMPILE::JS
        public function set positioner(value:WrappedHTMLElement):void
		{
			// void implementation of IUIBase.positioner
		}

	}
}
