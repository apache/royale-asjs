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
package org.apache.royale.html.beads.controllers
{
	import flash.display.DisplayObject;
	
	import org.apache.royale.events.Event;
    import org.apache.royale.events.MouseEvent;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.utils.sendStrandEvent;
	
    /**
     *  The VScrollBarMouseController class is the controller for
     *  org.apache.royale.html.supportClasses.ScrollBar
     *  that acts as the Vertical ScrollBar.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class VScrollBarMouseController extends ScrollBarMouseControllerBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function VScrollBarMouseController()
		{
		}
		
        /**
         *  @private
         */
		override protected function trackClickHandler(event:MouseEvent):void
		{
			if (sbView.thumb.visible)
			{
				if (event.localY < sbView.thumb.y)
				{
					sbModel.value = snap(Math.max(sbModel.minimum, sbModel.value - sbModel.pageStepSize));						
					sendStrandEvent(strand,"scroll");
				}
				else
				{
					sbModel.value = snap(Math.min(sbModel.maximum - sbModel.pageSize, sbModel.value + sbModel.pageStepSize));
					sendStrandEvent(strand,"scroll");
				}
			}
		}
		
		private var thumbDownY:Number;
		private var lastThumbY:Number;
		
        /**
         *  @private
         */
		override protected function thumbMouseDownHandler(event:MouseEvent):void
		{
			sbView.thumb.stage.addEventListener(MouseEvent.MOUSE_MOVE, thumbMouseMoveHandler);
			sbView.thumb.stage.addEventListener(MouseEvent.MOUSE_UP, thumbMouseUpHandler);
			thumbDownY = event.screenY;
			lastThumbY = sbView.thumb.y;
		}
		
		private function thumbMouseMoveHandler(event:MouseEvent):void
		{
			var thumb:DisplayObject = sbView.thumb;
			var track:DisplayObject = sbView.track;
			thumb.y = Math.max(track.y, Math.min(lastThumbY + (event.screenY - thumbDownY), track.y + track.height - thumb.height));
			var newValue:Number = snap((thumb.y - track.y) / (track.height - thumb.height) * (sbModel.maximum - sbModel.minimum - sbModel.pageSize));
			sbModel.value = newValue;
			sendStrandEvent(strand,"scroll");
		}
		
		private function thumbMouseUpHandler(event:MouseEvent):void
		{
			sbView.thumb.stage.removeEventListener(MouseEvent.MOUSE_MOVE, thumbMouseMoveHandler);
			sbView.thumb.stage.removeEventListener(MouseEvent.MOUSE_UP, thumbMouseUpHandler);			
		}
	}
}
