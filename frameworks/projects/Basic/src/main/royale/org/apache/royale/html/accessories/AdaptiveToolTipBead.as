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
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.geom.Point;
	import org.apache.royale.html.ToolTip;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.UIUtils;
	import org.apache.royale.utils.DisplayUtils;

	/**
	 *  The AdaptiveToolTipBead class is a specialty bead that can be used with
	 *  any control. The bead floats a string over a control if
   *  the user hovers over the control with a mouse.
	 *  It contains logic to ensure the tooltip remains inside the window.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class AdaptiveToolTipBead extends ToolTipBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function AdaptiveToolTipBead()
		{
		}

		public static const TOP:int = 10000;
		public static const BOTTOM:int = 10001;
		public static const LEFT:int = 10002;
		public static const RIGHT:int = 10003;
		public static const MIDDLE:int = 10004;


		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function rollOverHandler(event:MouseEvent):void
		{
			if (!toolTip || tt)
				return;
			listenOnStrand(MouseEvent.MOUSE_OUT, rollOutHandler);

			var comp:IUIBase = _strand as IUIBase
			host = UIUtils.findPopUpHost(comp);
			if (tt)
				host.popUpParent.removeElement(tt);

			tt = new ToolTip();
			tt.text = toolTip;
			// add this before measuring or measurement is not accurate.
			host.popUpParent.addElement(tt, false); // don't trigger a layout
			var pt:Point = determinePosition(event, event.target);
			tt.x = pt.x;
			tt.y = pt.y;
		}

		/**
		 * @private
		 * Determines the position of the toolTip.
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.core.IParentIUIBase
		 */
		override protected function determinePosition(event:MouseEvent, base:Object):Point
		{
			var ttWidth:Number = tt.width;
			var ttHeight:Number = tt.height;
			var comp:IUIBase = _strand as IUIBase;
			var x:Number;
			var y:Number;
			switch(xPos){
				case LEFT:
					x = -ttWidth;
					break;
				case MIDDLE:
					x = (comp.width - ttWidth) / 2;
					break;
				case RIGHT:
					x = comp.width;
					break;
			}
			switch(yPos){
				case TOP:
					y = -ttHeight;
					break;
				case MIDDLE:
					y = (comp.height - ttHeight) / 2;
					break;
				case BOTTOM:
					y = comp.height;
					break;
			}

			var pt:Point = new Point(x,y);
			pt = PointUtils.localToGlobal(pt, comp);

			//make sure it's not too high or to the left.
			pt.x = Math.max(pt.x,0);
			pt.y = Math.max(pt.y,0);

			var screenHeight:Number = (host.popUpParent as IParentIUIBase).height;
			// add an extra pixel for rounding errors
			var extraHeight:Number = 1 + pt.y + ttHeight - screenHeight;
			if(extraHeight > 0){
				pt.y -= extraHeight;
			}
			var screenWidth:Number = (host.popUpParent as IParentIUIBase).width;
			var extraWidth:Number = 1 + pt.x + ttWidth - screenWidth;
			if(extraWidth > 0){
				pt.x -= extraWidth;
			}
			return pt;
		}

	}
}

