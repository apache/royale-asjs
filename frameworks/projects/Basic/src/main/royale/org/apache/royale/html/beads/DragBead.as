
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
package org.apache.royale.html.beads
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IChild;
	import org.apache.royale.geom.Point;
	import org.apache.royale.geom.Rectangle;
	
	/**
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	public class DragBead implements IBead
	{
		protected var _host:IUIBase;
		protected var startingPoint:Point;
		private var _hitArea:IEventDispatcher;
		private var _moveArea:Rectangle;
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function set strand(value:IStrand):void
		{
			_host = value as IUIBase;
			if (!_hitArea)
			{
				_hitArea = value as IEventDispatcher;
			}
			if (!_moveArea)
			{
				var hostParent:IUIBase = (_host as IChild).parent as IUIBase;
				_moveArea = new Rectangle(hostParent.x, hostParent.y, hostParent.width, hostParent.height);
			}
			_hitArea.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}

		/**
		 *  Area on which user presses mouse down to drag strand. Typically this is the title bar of a panel.
		 *  If nothing is specified then the hit area is assumed to be the whole strand.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get hitArea():IEventDispatcher
		{
			return _hitArea;
		}

		public function set hitArea(value:IEventDispatcher):void
		{
			_hitArea = value;
		}

		/**
		 *  Area to which dragging is constrained. By default it is the width and height of the strand's parent
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get moveArea():Rectangle
		{
			return _moveArea;
		}

		public function set moveArea(value:Rectangle):void
		{
			_moveArea = value;
		}

		protected function mouseDownHandler(event:MouseEvent):void
		{
			startingPoint = new Point(event.clientX, event.clientY);
			_host.topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_host.topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		protected function mouseMoveHandler(event:MouseEvent):void
		{

			var xDelta:Number = event.clientX - startingPoint.x;
			var yDelta:Number = event.clientY - startingPoint.y;
			var potentialX:Number = _host.x + xDelta;
			var potentialY:Number = _host.y + yDelta;
			if (potentialX < _moveArea.x || potentialX > _moveArea.x + _moveArea.width)
			{
				xDelta = 0;
			}
			if (potentialY < _moveArea.y || potentialY > _moveArea.y + _moveArea.height)
			{
				yDelta = 0;
			}
			_host.x = _host.x + xDelta;
			_host.y = _host.y + yDelta;
			startingPoint.x += xDelta;
			startingPoint.y += yDelta;
		}

		protected function mouseUpHandler(event:MouseEvent):void
		{
			_host.topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_host.topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}

	}
}
