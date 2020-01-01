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
	import org.apache.royale.collections.parsers.JSONInputParser;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IRangeModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.geom.Point;
	import org.apache.royale.html.beads.ISliderView;
	import org.apache.royale.utils.sendStrandEvent;
	
	COMPILE::JS
	{
		import goog.events;
		import goog.events.EventType;
		import org.apache.royale.events.BrowserEvent;
		import org.apache.royale.html.Slider;
	}
	
	/**
	 *  The VSliderMouseController class bead handles mouse events on the 
	 *  org.apache.royale.html.Slider's component parts (thumb and track) and 
	 *  dispatches change events on behalf of the Slider (as well as co-ordinating visual 
	 *  changes (such as moving the thumb when the track has been tapped or clicked). Use
	 *  this controller for vertically oriented Sliders.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class VSliderMouseController implements IBead, IBeadController
	{
		/**
		 * Constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function VSliderMouseController()
		{
		}
		
		private var rangeModel:IRangeModel;
		
		private var _strand:IStrand;
		
		private var oldValue:Number;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			rangeModel = UIBase(value).model as IRangeModel;
			
			COMPILE::SWF
			{
				var sliderView:ISliderView = value.getBeadByType(ISliderView) as ISliderView;
				sliderView.thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDownHandler);
				
				// add handler to detect click on track
				sliderView.track.addEventListener(MouseEvent.CLICK, trackClickHandler, false, 99999);
				
			}
			COMPILE::JS
			{
				var sliderView:ISliderView = value.getBeadByType(ISliderView) as ISliderView;
				track = sliderView.track as UIBase;
				thumb = sliderView.thumb as UIBase;
				
				goog.events.listen(track.element, goog.events.EventType.CLICK,
					handleTrackClick, false, this);
				
				goog.events.listen(thumb.element, goog.events.EventType.MOUSEDOWN,
					handleThumbDown, false, this);
				
			}
		}
		
		
		COMPILE::JS
		private var track:UIBase;
		
		COMPILE::JS
		private var thumb:UIBase;
		
		COMPILE::SWF
		private function thumbDownHandler( event:MouseEvent ) : void
		{
			UIBase(_strand).topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_MOVE, thumbMoveHandler);
			UIBase(_strand).topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_UP, thumbUpHandler);
			
			var sliderView:ISliderView = _strand.getBeadByType(ISliderView) as ISliderView;
			
			origin = new Point(event.screenX, event.screenY);
			thumb = new Point(sliderView.thumb.x,sliderView.thumb.y);
			oldValue = rangeModel.value;
		}
		
		COMPILE::SWF
		private function thumbUpHandler( event:MouseEvent ) : void
		{
			UIBase(_strand).topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, thumbMoveHandler);
			UIBase(_strand).topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_UP, thumbUpHandler);
			
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", oldValue, rangeModel.value);
			sendStrandEvent(_strand,vce);
		}
		
		COMPILE::SWF
		private var origin:Point;
		COMPILE::SWF
		private var thumb:Point;
		
		COMPILE::SWF
		private function thumbMoveHandler( event:MouseEvent ) : void
		{
			var sliderView:ISliderView = _strand.getBeadByType(ISliderView) as ISliderView;
			
			var deltaY:Number = event.screenY - origin.y;
			var thumbH:Number = sliderView.thumb.height/2;
			var newY:Number = thumb.y + deltaY;
			
			var p:Number = newY/sliderView.track.height;
			var n:Number = p*(rangeModel.maximum - rangeModel.minimum) + rangeModel.minimum;
			
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", rangeModel.value, n);
			rangeModel.value = n;
			
			sendStrandEvent(_strand,vce);
		}
		
		COMPILE::SWF
		private function trackClickHandler( event:MouseEvent ) : void
		{
			event.stopImmediatePropagation();
			
			var sliderView:ISliderView = _strand.getBeadByType(ISliderView) as ISliderView;
			
			var yloc:Number = event.localY;
			var p:Number = yloc/sliderView.track.height;
			var n:Number = p*(rangeModel.maximum - rangeModel.minimum) + rangeModel.minimum;
			
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", rangeModel.value, n);
			rangeModel.value = n;
			
			sendStrandEvent(_strand,vce);
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.events.BrowserEvent
		 */
		COMPILE::JS
		private function handleTrackClick(event:MouseEvent):void
		{
			var bevent:BrowserEvent = event["nativeEvent"] as BrowserEvent;
			var host:Slider = _strand as Slider;
			var yloc:Number = bevent.offsetY;
			var useHeight:Number = parseInt(track.element.style.height, 10) * 1.0;
			var p:Number = yloc / useHeight;
			var n:Number = p*(rangeModel.maximum - rangeModel.minimum) + rangeModel.minimum;
			
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", rangeModel.value, n);
			rangeModel.value = n;
			
			sendStrandEvent(_strand,vce);
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.events.BrowserEvent
		 */
		COMPILE::JS
		private function handleThumbDown(event:MouseEvent):void
		{
			var bevent:BrowserEvent = event["nativeEvent"] as BrowserEvent;
			var host:Slider = _strand as Slider;
			goog.events.listen(host.element, goog.events.EventType.MOUSEUP,
				handleThumbUp, false, this);
			goog.events.listen(host.element, goog.events.EventType.MOUSEMOVE,
				handleThumbMove, false, this);
			goog.events.listen(host.element, goog.events.EventType.MOUSELEAVE,
				handleThumbLeave, false, this);
			
			mouseOrigin = bevent.screenY; //.clientY;
			thumbOrigin = parseInt(thumb.element.style.top, 10);
			oldValue = rangeModel.value;
		}
		
		COMPILE::JS
		private var mouseOrigin:Number;
		COMPILE::JS
		private var thumbOrigin:int;
		
		/**
		 * @royaleignorecoercion org.apache.royale.events.BrowserEvent
		 */
		COMPILE::JS
		private function handleThumbUp(event:MouseEvent):void
		{
			var bevent:BrowserEvent = event["nativeEvent"] as BrowserEvent;
			var host:Slider = _strand as Slider;
			goog.events.unlisten(host.element, goog.events.EventType.MOUSEUP,
				handleThumbUp, false, this);
			goog.events.unlisten(host.element, goog.events.EventType.MOUSEMOVE,
				handleThumbMove, false, this);
			goog.events.unlisten(host.element, goog.events.EventType.MOUSELEAVE,
				handleThumbLeave, false, this);
			
			calcValFromMousePosition(bevent, false);
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", oldValue, rangeModel.value);
			
			sendStrandEvent(_strand,vce);
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.events.BrowserEvent
		 */
		COMPILE::JS
		private function handleThumbMove(event:MouseEvent):void
		{
			var bevent:BrowserEvent = event["nativeEvent"] as BrowserEvent;
			var host:Slider = _strand as Slider;
			var lastValue:Number = rangeModel.value;
			calcValFromMousePosition(bevent, false);
			
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", lastValue, rangeModel.value);
			
			sendStrandEvent(_strand,vce);
		}
		
		COMPILE::JS
		private function handleThumbLeave(event:MouseEvent):void
		{
			var host:Slider = _strand as Slider;
			goog.events.unlisten(host.element, goog.events.EventType.MOUSEUP,
				handleThumbUp, false, this);
			goog.events.unlisten(host.element, goog.events.EventType.MOUSEMOVE,
				handleThumbMove, false, this);
			goog.events.unlisten(host.element, goog.events.EventType.MOUSELEAVE,
				handleThumbLeave, false, this);
		}
		
		COMPILE::JS
		private function calcValFromMousePosition(event:BrowserEvent, useOffset:Boolean):void
		{
			var deltaY:Number = event.screenY - mouseOrigin;
			if (deltaY == 0) return;
			
			var thumbH:int = parseInt(thumb.element.style.height, 10) / 2;
			var newPointY:Number = thumbOrigin + deltaY;
			
			var useHeight:Number = parseInt(track.element.style.height,10) * 1.0;
			var p:Number = newPointY / useHeight;
			var n:Number = p*(rangeModel.maximum - rangeModel.minimum) + rangeModel.minimum;
			
			rangeModel.value = n;
		}
	}
}