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
package org.apache.royale.style.beads
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.geom.Point;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.UIUtils;
	import org.apache.royale.style.Tooltip;
	
	COMPILE::SWF{
		//for compilation support only
		import flash.utils.setTimeout;
		import flash.utils.clearTimeout;
	}
	
	/**
	 * Provides core functionality for managing display of Tooltips.
	 * 
	 */
	public class TooltipBead implements IBead
	{
		public function TooltipBead()
		{
		}
		

		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const BOTTOM:String = "bottom";
		public static const TOP:String = "top";

		private static var activeBead:TooltipBead;

		public static function closeTips():void{
			if(activeBead){
				activeBead.closeTooltip();
			}
		}

		protected var tt:Tooltip;
		protected var host:IPopUpHost;

		private var _autoClose:Number = 2000;

		/**
		 * Number of milliseconds to auto-close the tooltip
		 * 0 means it stays open
		 * Default is 2000
		 */
		public function get autoClose():Number
		{
			return _autoClose;
		}

		public function set autoClose(value:Number):void
		{
			_autoClose = value;
		}

		private var _delay:Number = 0;
		/**
		 * Delay (in ms) until tooltip shows
		 */
		public function get delay():Number{
			return _delay;
		}

		public function set delay(value:Number):void{
			_delay = value;
		}

		private var _stayOpen:Number = 0;
		/**
		 * How long  (in ms) for the tooltip to stay open after mouse leaves.
		 */
		public function get stayOpen():Number
		{
			return _stayOpen;
		}

		public function set stayOpen(value:Number):void
		{
			_stayOpen = value;
		}

		private var _coolDown:Number = 0;
		/**
		 * ms since last closed tooltip to ignore delay value
		 * See https://spectrum.adobe.com/page/tooltip/#Warmup-and-cooldown
		 */
		public function get coolDown():Number{
			return _coolDown;
		}

		public function set coolDown(value:Number):void{
			_coolDown = value;
		}

		private var _toolTip:String;
		public function get toolTip():String
		{
			return _toolTip;
		}
		public function set toolTip(value:String):void
		{
			_toolTip = value;
			if (tt) {
				if (value) {
					tt.text = value;
				} else {
					closeTooltip();
				}
			}
		}

		private var _direction:String = TOP;
    	[Inspectable(category="General", enumeration="left,right,bottom,top", defaultValue="top")]
		public function set direction(value:String):void
		{
			_direction = value;
			if (tt)
			{
				tt.direction = value;
			}
		}

		public function get direction():String
		{
			return _direction;
		}

		private var _tipPosition:String;

		/**
		 * The position of the tip within the tooltip
		 */
		public function get tipPosition():String{
			return _tipPosition;
		}

		[Inspectable(category="General", enumeration="start,end,center",defaultValue="center")]
		public function set tipPosition(value:String):void{
			_tipPosition = value;
			if (tt)
			{
				tt.tipPosition = value;
			}
		}

		private var _flavor:String;

		/**
		 * The flavor of the Tooltip
		 * One of info, positive and negative, success and error.
		 * To set the Tooltip to the default, specify an empty string
		 */
		public function get flavor():String
		{
			return _flavor;
		}

		[Inspectable(category="General", enumeration="info,positive,negative,success,error")]
		public function set flavor(value:String):void
		{
			_flavor = value;
			if(tt){
				tt.flavor = value;
			}
		}

		protected var _strand:IStrand;

		public function set strand(value:IStrand):void
		{
			_strand = value;

			(_strand as IEventDispatcher).addEventListener("mouseenter", rollOverHandler, false);
		}

		protected function rollOverHandler(event:MouseEvent):void
		{
			if (!toolTip || tt){
				return;
			}
			(_strand as IEventDispatcher).addEventListener("mouseleave", rollOutHandler, false);
			
			// Already open. Just make sure it stays open and closes when it should.
			if(activeBead == this && tt && tt.isOpen){
				clearTimeouts();
				if(_autoClose > 0){
					closeTimeoutId = setTimeout(closeTooltip,_autoClose);
				}
			}
			else if(delay == 0 || new Date().getTime() - lastShownTS < coolDown){
				showTooltip();
			} else {
				showTimeoutId = setTimeout(showTooltip,delay);
			}

		}
		private var showTimeoutId:Number = 0;
		private var closeTimeoutId:Number = 0;
		private var stayOpenTimeoutId:Number = 0;
		private function clearTimeouts():void{
			if(showTimeoutId > 0){
				clearTimeout(showTimeoutId);
				showTimeoutId = 0;
			}
			if(closeTimeoutId > 0){
				clearTimeout(closeTimeoutId);
				closeTimeoutId = 0;
			}
			if(stayOpenTimeoutId > 0){
				clearTimeout(stayOpenTimeoutId);
				stayOpenTimeoutId = 0;
			}

		}

		protected function createTooltip():void{
			if(activeBead && activeBead != this){
				activeBead.closeTooltip();
			}
			activeBead = this;


			var comp:IUIBase = _strand as IUIBase
			host = UIUtils.findPopUpHost(comp);
			removeTooltip();
			tt = new Tooltip(true);
			if(_flavor){
				tt.flavor = _flavor;
			}
			tt.direction = _direction;
			if(tipPosition){
				tt.tipPosition = tipPosition;
			}
		
			tt.text = toolTip;
			if(_autoClose > 0){
				closeTimeoutId = setTimeout(closeTooltip,_autoClose);
			}
		}

		protected function showTooltip():void {
			createTooltip();
			host.popUpParent.addElement(tt, false); // don't trigger a layout
			var ttWidth:Number = tt.width;
			var pt:Point = determinePosition(_strand as IUIBase, tt);
			tt.x = pt.x;
			tt.y = pt.y;
			tt.isOpen = true;
			if(ttWidth != tt.width){
				pt = determinePosition(_strand as IUIBase, tt);
				tt.x = pt.x;
				tt.y = pt.y;
			}
		}

		protected function determinePosition(comp:IUIBase, tooltip:Tooltip):Point
		{
			var pt:Point = new Point();
			if (_direction == LEFT) {
				pt.x = -tooltip.width;
				pt.y = (comp.height - tooltip.height) / 2;
			} else if (_direction == TOP) {
				pt.x = (comp.width - tooltip.width) / 2;
				pt.y = -tooltip.height;
			} else if (_direction == RIGHT) {
				pt.x = comp.width;
				pt.y = (comp.height - tooltip.height) / 2;
			} else
			{
				pt.x = (comp.width - tooltip.width) / 2;
				pt.y = comp.height;
			}

			pt = PointUtils.localToGlobal(pt, comp);
			return pt;
		}

		protected function rollOutHandler(event:MouseEvent):void{
			(_strand as IEventDispatcher).removeEventListener("mouseleave", rollOutHandler, false);
			clearTimeouts();
			if(stayOpen > 0){
				stayOpenTimeoutId = setTimeout(closeTooltip,stayOpen);
			} else {
				closeTooltip();
			}
		}
		protected function closeTooltip():void{
			clearTimeouts();
			activeBead = null;
			removeTooltip();
			closeTimeoutId = 0;
			showTimeoutId = 0;
			lastShownTS = new Date().getTime();
		}
		protected function removeTooltip():void{
			if(tt && tt.parent){
				tt.parent.removeElement(tt);
			}
			tt = null;
		}
		public static var lastShownTS:Number = 0;
	}
}

