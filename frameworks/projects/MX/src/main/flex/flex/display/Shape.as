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

package flex.display
{	
	import org.apache.flex.core.graphics.GraphicsContainer;
	import org.apache.flex.geom.Point;
	import org.apache.flex.utils.PointUtils;
	import mx.managers.SystemManagerGlobals;
	
	public class Shape extends GraphicsContainer
	{
		COMPILE::JS
		private var _name:String;
		COMPILE::JS
		public function get name():String
		{
			return _name;
		}
		COMPILE::JS
		public function set name(value:String):void
		{
			_name = value;
		}
		
		/**
		 *  @flexjsignorecoercion flex.display.TopOfDisplayList
		 */
		public function get topOfDisplayList():TopOfDisplayList
		{
			return topMostEventDispatcher as TopOfDisplayList;
		}

		COMPILE::JS
		/**
		 *  @flexjsignorecoercion flex.display.DisplayObject
		 */
		public function get root():DisplayObject
		{
			return topMostEventDispatcher as DisplayObject;
		}
		
		COMPILE::JS
		/**
		 *  @flexjsignorecoercion flex.display.DisplayObject
		 */
		public function contains(child:DisplayObject):Boolean
		{
			while (child)
			{
				if (child.parent == this)
					return true;
				child = child.parent as DisplayObject;
			}
			return topMostEventDispatcher as DisplayObject;
		}
		
		COMPILE::JS
		private var _graphics:Graphics;
		
		COMPILE::JS
		/**
		 *  @flexjsignorecoercion flex.display.DisplayObject
		 */
		public function get graphics():Graphics
		{
			if (!_graphics)
				_graphics = new Graphics(this);
			return _graphics
		}

		COMPILE::JS
		public function get mouseX():Number
		{
			var pt:Point = new Point(SystemManagerGlobals.lastMouseEvent.screenX,
									 SystemManagerGlobals.lastMouseEvent.screenY);
			pt = PointUtils.globalToLocal(pt, this);
			return pt.x;
		}
		
		COMPILE::JS
		public function get mouseY():Number
		{
			var pt:Point = new Point(SystemManagerGlobals.lastMouseEvent.screenX,
				SystemManagerGlobals.lastMouseEvent.screenY);
			pt = PointUtils.globalToLocal(pt, this);
			return pt.x;
		}
		
		COMPILE::JS
		override public function get parent():DisplayObjectContainer
		{
			return super.parent as DisplayObjectContainer;
		}

	}
	
}
