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
package org.apache.flex.html.accessories
{

	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IPopUpHost;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.MouseEvent;
	import org.apache.flex.geom.Point;
	import org.apache.flex.html.ToolTip;
	import org.apache.flex.utils.PointUtils;
	import org.apache.flex.utils.UIUtils;

	/**
	 *  The ToolTipBead class is a specialty bead that can be used with
	 *  any control. The bead floats a string over a control if
     *  the user hovers over the control with a mouse.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ToolTipBead implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ToolTipBead()
		{
		}

		private var _toolTip:String;

		/**
		 *  The string to use as the toolTip.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get toolTip():String
		{
			return _toolTip;
		}
		public function set toolTip(value:String):void
		{
            _toolTip = value;
		}

		private var _strand:IStrand;

		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

            IEventDispatcher(_strand).addEventListener(MouseEvent.MOUSE_OVER, rollOverHandler, false);
		}

        private var tt:ToolTip;
        private var host:IPopUpHost;

		/**
		 * @private
		 */
		protected function rollOverHandler( event:MouseEvent ):void
		{
			if (!toolTip || tt)
				return;

            IEventDispatcher(_strand).addEventListener(MouseEvent.MOUSE_OUT, rollOutHandler, false);

            var comp:IUIBase = _strand as IUIBase
            host = UIUtils.findPopUpHost(comp);
			if (tt) host.removeElement(tt);

            tt = new ToolTip();
            tt.text = toolTip;
            var pt:Point = determinePosition(event, event.target);
            tt.x = pt.x;
            tt.y = pt.y;
            host.addElement(tt, false); // don't trigger a layout

			tt.addEventListener(MouseEvent.MOUSE_OUT, rollOutHandler, false);
		}

		/**
		 * @private
		 * Determines the position of the toolTip.
		 */
		protected function determinePosition(event:MouseEvent, base:Object):Point
		{
			var comp:IUIBase = _strand as IUIBase;
			var pt:Point = new Point(comp.width/2, comp.height/2);
			pt = PointUtils.localToGlobal(pt, comp);
			return pt;
		}

        /**
         * @private
         */
        private function rollOutHandler(event:MouseEvent):void
        {
			var comp:IUIBase = _strand as IUIBase;
			var outside:Boolean = event.clientX > comp.width || event.clientY > comp.height;
            // check for outside otherwise tool tip itself with flash when you roll over it
            if (tt && outside) {
                host.removeElement(tt);
				tt = null;
			}
        }
	}
}

