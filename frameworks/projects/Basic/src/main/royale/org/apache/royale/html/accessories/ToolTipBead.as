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
package org.apache.royale.html.accessories
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IToolTipBead;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.geom.Point;
	import org.apache.royale.html.ToolTip;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.UIUtils;
	import org.apache.royale.core.Bead;

	/**
	 *  The ToolTipBead class is a specialty bead that can be used with
	 *  any control. The bead floats a string over a control if
	 *  the user hovers over the control with a mouse.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class ToolTipBead extends Bead implements IToolTipBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function ToolTipBead()
		{
		}

		public static const TOP:int = 10000;
		public static const BOTTOM:int = 10001;
		public static const LEFT:int = 10002;
		public static const RIGHT:int = 10003;
		public static const MIDDLE:int = 10004;

		private var _toolTip:String;
		protected var tt:ToolTip;
		protected var host:IPopUpHost;
		private var _xPos:int = RIGHT;
		private var _yPos:int = BOTTOM;

		/**
		 *  The string to use as the toolTip.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get toolTip():String
		{
			return _toolTip;
		}
		public function set toolTip(value:String):void
		{
			_toolTip = value;
		}

		/**
		 *  Sets the tooltip y relative position to one of
		 *  LEFT, MIDDLE or RIGHT.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function set xPos(pos:int):void
		{
			_xPos = pos;
		}
		public function get xPos():int
		{
			return _xPos;
		}
		/**
		 *  Sets the tooltip y relative position to one of
		 *  TOP, MIDDLE or BOTTOM.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function set yPos(pos:int):void
		{
			_yPos = pos;
		}
		public function get yPos():int
		{
			return _yPos;
		}

		/**                         	
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			listenOnStrand(MouseEvent.MOUSE_OVER, rollOverHandler);
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function rollOverHandler(event:MouseEvent):void
		{
			if (!toolTip || tt)
				return;

			IEventDispatcher(_strand).addEventListener(MouseEvent.MOUSE_OUT, rollOutHandler, false);

			var comp:IUIBase = _strand as IUIBase
				host = UIUtils.findPopUpHost(comp);
			if (tt)
				host.popUpParent.removeElement(tt);

			tt = new ToolTip();
			tt.text = toolTip;
			var pt:Point = determinePosition(event, event.target);
			tt.x = pt.x;
			tt.y = pt.y;
			host.popUpParent.addElement(tt, false); // don't trigger a layout
		}

		/**
		 * @private
		 * Determines the position of the toolTip.
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		protected function determinePosition(event:MouseEvent, base:Object):Point
		{
			var comp:IUIBase = _strand as IUIBase;
			var xFactor:Number = 1;
			var yFactor:Number = 1;
			var pt:Point;
			var relative:Boolean = _xPos > TOP &&  _yPos > TOP;

			if (_xPos == LEFT) {
				xFactor = Number.POSITIVE_INFINITY;
			}
			else if (_xPos == MIDDLE) {
				xFactor = 2;
			}
			else if (_xPos == RIGHT) {
				xFactor = 1;
			}
			if (_yPos == TOP) {
				yFactor = Number.POSITIVE_INFINITY;
			}
			else if (_yPos == MIDDLE) {
				yFactor = 2;
			}
			else if (_yPos == BOTTOM) {
				yFactor = 1;
			}

			pt = new Point(comp.width/xFactor, comp.height/yFactor);
			pt = PointUtils.localToGlobal(pt, comp);

			return pt;
		}

		/**                         	
		 *  @copy org.apache.royale.core.IToolTipBead#removeTip()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		public function removeTip():void
		{
			(_strand as IEventDispatcher).removeEventListener(MouseEvent.MOUSE_OUT, rollOutHandler, false);

			var comp:IUIBase = _strand as IUIBase;
			if (tt) {
				host.popUpParent.removeElement(tt);
				tt = null;
			}
		}

		/**
		 * @private
		 */
		public function rollOutHandler(event:MouseEvent):void
		{
			removeTip();
		}
	}
}

