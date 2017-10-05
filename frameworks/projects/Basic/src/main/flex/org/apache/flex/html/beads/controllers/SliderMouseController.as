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
	import org.apache.royale.html.beads.SliderTrackView;

    COMPILE::JS
    {
        import goog.events;
        import goog.events.EventType;
        import org.apache.royale.events.BrowserEvent;
        import org.apache.royale.html.Slider;
        import org.apache.royale.html.beads.SliderThumbView;
        import org.apache.royale.html.beads.SliderTrackView;
    }
	
	/**
	 *  The SliderMouseController class bead handles mouse events on the 
	 *  org.apache.royale.html.Slider's component parts (thumb and track) and 
	 *  dispatches change events on behalf of the Slider (as well as co-ordinating visual 
	 *  changes (such as moving the thumb when the track has been tapped or clicked).
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class SliderMouseController implements IBead, IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function SliderMouseController()
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
		 *  @productversion Royale 0.0
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
        
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
        COMPILE::SWF
		private function thumbUpHandler( event:MouseEvent ) : void
		{
			UIBase(_strand).topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, thumbMoveHandler);
			UIBase(_strand).topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_UP, thumbUpHandler);
			
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", oldValue, rangeModel.value);
			IEventDispatcher(_strand).dispatchEvent(vce);
		}
		
        COMPILE::SWF
		private var origin:Point;
        COMPILE::SWF
		private var thumb:Point;
		
		/**
		 * @private
		 */
        COMPILE::SWF
		private function thumbMoveHandler( event:MouseEvent ) : void
		{
			var sliderView:ISliderView = _strand.getBeadByType(ISliderView) as ISliderView;
			
			var deltaX:Number = event.screenX - origin.x;
			var thumbW:Number = sliderView.thumb.width/2;
			var newX:Number = thumb.x + deltaX;
			
			var p:Number = newX/sliderView.track.width;
			var n:Number = p*(rangeModel.maximum - rangeModel.minimum) + rangeModel.minimum;
		
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", rangeModel.value, n);
			rangeModel.value = n;
			
			IEventDispatcher(_strand).dispatchEvent(vce);
		}
		
		/**
		 * @private
		 */
        COMPILE::SWF
		private function trackClickHandler( event:MouseEvent ) : void
		{
			event.stopImmediatePropagation();
			
			var sliderView:ISliderView = _strand.getBeadByType(ISliderView) as ISliderView;
			
			var xloc:Number = event.localX;
			var p:Number = xloc/sliderView.track.width;
			var n:Number = p*(rangeModel.maximum - rangeModel.minimum) + rangeModel.minimum;
			
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", rangeModel.value, n);
			rangeModel.value = n;
			
			IEventDispatcher(_strand).dispatchEvent(vce);
		}
        
        /**
         */
        COMPILE::JS
        private function handleTrackClick(event:BrowserEvent):void
        {
            var host:Slider = _strand as Slider;
            var xloc:Number = event.clientX;
            var p:Number = Math.min(1, xloc / parseInt(track.element.style.width, 10));
            var n:Number = p * (host.maximum - host.minimum) +
                host.minimum;
            
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", host.value, n);
            host.value = n;
            
            origin = parseInt(thumb.element.style.left, 10);
            position = parseInt(thumb.element.style.left, 10);
            
            calcValFromMousePosition(event, true);
            
            host.dispatchEvent(vce);
        }
        
        
        /**
         */
        COMPILE::JS
        private function handleThumbDown(event:BrowserEvent):void
        {
            var host:Slider = _strand as Slider;
            goog.events.listen(host.element, goog.events.EventType.MOUSEUP,
                handleThumbUp, false, this);
            goog.events.listen(host.element, goog.events.EventType.MOUSEMOVE,
                handleThumbMove, false, this);
            
            origin = event.clientX;
            position = parseInt(thumb.element.style.left, 10);
            oldValue = rangeModel.value;
        }
        
        COMPILE::JS
        private var origin:Number;
        COMPILE::JS
        private var position:int;
        
        /**
         */
        COMPILE::JS
        private function handleThumbUp(event:BrowserEvent):void
        {
            var host:Slider = _strand as Slider;
            goog.events.unlisten(host.element, goog.events.EventType.MOUSEUP,
                handleThumbUp, false, this);
            goog.events.unlisten(host.element, goog.events.EventType.MOUSEMOVE,
                handleThumbMove, false, this);
            
            calcValFromMousePosition(event, false);
            var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", oldValue, rangeModel.value);
            
            host.dispatchEvent(vce);
        }
        
        
        /**
         */
        COMPILE::JS
        private function handleThumbMove(event:BrowserEvent):void
        {
            var host:Slider = _strand as Slider;
            var lastValue:Number = rangeModel.value;
            calcValFromMousePosition(event, false);
            
            var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", lastValue, rangeModel.value);
            
            host.dispatchEvent(vce);
        }
        
        
        /**
         */
        COMPILE::JS
        private function calcValFromMousePosition(event:BrowserEvent, useOffset:Boolean):void
        {
            var host:Slider = _strand as Slider;
            var deltaX:Number = (useOffset ? event.offsetX : event.clientX) - origin;
            var thumbW:int = parseInt(thumb.element.style.width, 10) / 2;
            var newX:Number = position + deltaX;
            
            var p:Number = newX / parseInt(track.element.style.width, 10);
            var n:Number = p * (host.maximum - host.minimum) +
                host.minimum;
            n = host.snap(n);
            if (n < host.minimum) n = host.minimum;
            else if (n > host.maximum) n = host.maximum;
            
            p = (n - host.minimum) / (host.maximum -
                host.minimum);
            newX = p * parseInt(track.element.style.width, 10);
            
            thumb.element.style.left = String(newX -
                parseInt(thumb.element.style.width, 10) / 2) + 'px';
            
            host.value = n;
        }
    }
}
