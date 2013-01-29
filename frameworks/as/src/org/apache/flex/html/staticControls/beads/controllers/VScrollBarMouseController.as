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
package org.apache.flex.html.staticControls.beads.controllers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import org.apache.flex.core.IScrollBarModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.html.staticControls.beads.IScrollBarBead;

	public class VScrollBarMouseController extends ScrollBarMouseControllerBase
	{
		public function VScrollBarMouseController()
		{
		}
		
		override protected function trackClickHandler(event:MouseEvent):void
		{
			if (sbView.thumb.visible)
			{
				if (event.localY < sbView.thumb.y)
				{
					sbModel.value = snap(Math.max(sbModel.minimum, sbModel.value - sbModel.pageStepSize));						
					IEventDispatcher(strand).dispatchEvent(new Event("scroll"));
				}
				else
				{
					sbModel.value = snap(Math.min(sbModel.maximum, sbModel.value + sbModel.pageStepSize));
					IEventDispatcher(strand).dispatchEvent(new Event("scroll"));
				}
			}
		}
		
		private var thumbDownY:Number;
		private var lastThumbY:Number;
		
		override protected function thumbMouseDownHandler(event:MouseEvent):void
		{
			sbView.thumb.stage.addEventListener(MouseEvent.MOUSE_MOVE, thumbMouseMoveHandler);
			sbView.thumb.stage.addEventListener(MouseEvent.MOUSE_UP, thumbMouseUpHandler);
			thumbDownY = event.stageY;
			lastThumbY = sbView.thumb.y;
		}
		
		private function thumbMouseMoveHandler(event:MouseEvent):void
		{
			var thumb:DisplayObject = sbView.thumb;
			var track:DisplayObject = sbView.track;
			thumb.y = Math.max(track.y, Math.min(lastThumbY + (event.stageY - thumbDownY), track.y + track.height - thumb.height));
			var newValue:Number = snap((thumb.y - track.y) / (track.height - thumb.height) * (sbModel.maximum - sbModel.minimum - sbModel.pageSize));
			sbModel.value = newValue;
			IEventDispatcher(strand).dispatchEvent(new Event("scroll"));
		}
		
		private function thumbMouseUpHandler(event:MouseEvent):void
		{
			sbView.thumb.stage.removeEventListener(MouseEvent.MOUSE_MOVE, thumbMouseMoveHandler);
			sbView.thumb.stage.removeEventListener(MouseEvent.MOUSE_UP, thumbMouseUpHandler);			
		}
	}
}