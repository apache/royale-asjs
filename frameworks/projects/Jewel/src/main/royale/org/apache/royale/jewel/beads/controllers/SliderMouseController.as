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
package org.apache.royale.jewel.beads.controllers
{
	COMPILE::SWF
    {
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.geom.Point;
	}
    COMPILE::JS
    {
	import goog.events;
	import goog.events.EventType;

	import org.apache.royale.events.BrowserEvent;
	import org.apache.royale.jewel.HSlider;
	import org.apache.royale.jewel.beads.views.SliderView;
    }
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IRangeModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.jewel.beads.controls.slider.ISliderView;

	/**
	 *  The SliderMouseController class bead handles mouse events on the 
	 *  org.apache.royale.jewel.HSlider's component parts (thumb and track) and 
	 *  dispatches change events on behalf of the HSlider (as well as co-ordinating visual 
	 *  changes (such as moving the thumb when the track has been tapped or clicked). Use
	 *  this controller for horizontally oriented Sliders.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class SliderMouseController implements IBead, IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function SliderMouseController()
		{
		}
		
		/**
         *  Range model
         *   
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
         */
		private var rangeModel:IRangeModel;
		
		private var _strand:IStrand;

		private var oldValue:Number;

		private var _sliderView:ISliderView;
        /**
		 *  the view attached to the slider
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get sliderView():ISliderView
        {
            return _sliderView;
        }

        public function set sliderView(value:ISliderView):void
        {
            _sliderView = value;
        }
				
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			rangeModel = UIBase(value).model as IRangeModel;
			
            sliderView = value.getBeadByType(ISliderView) as ISliderView;
            
			COMPILE::SWF
            {
                sliderView.thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDownHandler);
                
                // add handler to detect click on track
                sliderView.track.addEventListener(MouseEvent.CLICK, trackClickHandler, false, 99999);
                                    
            }
            COMPILE::JS
            {	
                goog.events.listen(UIBase(_strand).element, goog.events.EventType.CHANGE, handleChange, false, this);
                goog.events.listen(UIBase(_strand).element, goog.events.EventType.INPUT, handleInput, false, this);

				SliderView(sliderView).redraw();
            }

			// listen for changes to the model and adjust the model accordingly.
			IEventDispatcher(rangeModel).addEventListener("valueChange",modelChangeHandler);
			IEventDispatcher(rangeModel).addEventListener("stepSizeChange", modelChangeHandler);
			IEventDispatcher(rangeModel).addEventListener("minimumChange", modelChangeHandler);
			IEventDispatcher(rangeModel).addEventListener("maximumChange", modelChangeHandler);
			IEventDispatcher(rangeModel).addEventListener("valueChange", modelChangeHandler);
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 * @royaleignorecoercion org.apache.royale.core.IRangeModel
		 */
		private function modelChangeHandler( event:Event ) : void
		{
			COMPILE::JS
			{
				SliderView(sliderView).redraw();

				// value has change so dispatch VALUE_CHANGE event to the strand
				// if(event is ValueChangeEvent) {
				// 	IEventDispatcher(_strand).dispatchEvent(event.cloneEvent());
				// }
			}
		}

		

		/**
         *  Manages the change event to update the range model value
         *   
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
         */
        COMPILE::JS
        private function handleChange(event:BrowserEvent):void
        {
            var host:HSlider = _strand as HSlider;

            rangeModel.value = Number((UIBase(_strand).element as HTMLInputElement).value);

			SliderView(sliderView).redraw();

            //host.dispatchEvent(new org.apache.royale.events.Event('change')); --- This is not needed, the event is thrown in the main comp
        }

        /**
         *  Manages the 'valueChange' event to update the range model value and dispatch a 'valueChange' Royale event
		 *  with old and new values 
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
         */
        COMPILE::JS
        private function handleInput(event:BrowserEvent):void
        {
            var host:HSlider = _strand as HSlider;
			var oldValue:Number = Number((UIBase(_strand).element as HTMLInputElement).value);
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(host, "value", rangeModel.value, oldValue);
			rangeModel.value = oldValue;
            host.dispatchEvent(vce);
			SliderView(sliderView).redraw();
        }

		COMPILE::SWF
		private var origin:Point;
        COMPILE::SWF
		private var thumb:Point;
		
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
		 * @royaleignorecoercion org.apache.royale.events.BrowserEvent
         */
        /*COMPILE::JS
        private function handleTrackClick(event:MouseEvent):void
        {
			var bevent:BrowserEvent = event["wrappedEvent"] as BrowserEvent;
            var host:HSlider = _strand as HSlider;
            var xloc:Number = bevent.offsetX;
			var useWidth:Number = parseInt(track.element.style.width, 10) * 1.0;
            var p:Number = xloc / useWidth;
			var n:Number = p*(rangeModel.maximum - rangeModel.minimum) + rangeModel.minimum;
            
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", rangeModel.value, n);
            rangeModel.value = n;
            
            host.dispatchEvent(vce);
        }*/
        
        
        /**
		 * @royaleignorecoercion org.apache.royale.events.BrowserEvent
         */
        // COMPILE::JS
        // private function handleThumbDown(event:MouseEvent):void
        // {
		// 	var bevent:BrowserEvent = event["wrappedEvent"] as BrowserEvent;
        //     var host:HSlider = _strand as HSlider;
        //     goog.events.listen(host.element, goog.events.EventType.MOUSEUP,
        //         handleThumbUp, false, this);
        //     goog.events.listen(host.element, goog.events.EventType.MOUSEMOVE,
        //         handleThumbMove, false, this);
		// 	goog.events.listen(host.element, goog.events.EventType.MOUSELEAVE,
		// 		handleThumbLeave, false, this);
            
        //     mouseOrigin = bevent.screenX; //.clientX;
        //     thumbOrigin = parseInt(thumb.element.style.left, 10);
        //     oldValue = rangeModel.value;
        // }
        
        // COMPILE::JS
        // private var mouseOrigin:Number;
        // COMPILE::JS
        // private var thumbOrigin:int;
        
        /**
		 * @royaleignorecoercion org.apache.royale.events.BrowserEvent
         */
        // COMPILE::JS
        // private function handleThumbUp(event:MouseEvent):void
        // {
		// 	var bevent:BrowserEvent = event["wrappedEvent"] as BrowserEvent;
        //     var host:HSlider = _strand as HSlider;
        //     goog.events.unlisten(host.element, goog.events.EventType.MOUSEUP,
        //         handleThumbUp, false, this);
        //     goog.events.unlisten(host.element, goog.events.EventType.MOUSEMOVE,
        //         handleThumbMove, false, this);
		// 	goog.events.unlisten(host.element, goog.events.EventType.MOUSELEAVE,
		// 		handleThumbLeave, false, this);
            
        //     calcValFromMousePosition(bevent, false);
        //     var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", oldValue, rangeModel.value);
            
        //     host.dispatchEvent(vce);
        // }
        
        
        /**
		 * @royaleignorecoercion org.apache.royale.events.BrowserEvent
         */
        // COMPILE::JS
        // private function handleThumbMove(event:MouseEvent):void
        // {
		// 	var bevent:BrowserEvent = event["wrappedEvent"] as BrowserEvent;
        //     var host:HSlider = _strand as HSlider;
        //     var lastValue:Number = rangeModel.value;
        //     calcValFromMousePosition(bevent, false);
            
        //     var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", lastValue, rangeModel.value);
            
        //     host.dispatchEvent(vce);
        // }
		
		// COMPILE::JS
		// private function handleThumbLeave(event:MouseEvent):void
		// {
		// 	var host:HSlider = _strand as HSlider;
		// 	goog.events.unlisten(host.element, goog.events.EventType.MOUSEUP,
		// 		handleThumbUp, false, this);
		// 	goog.events.unlisten(host.element, goog.events.EventType.MOUSEMOVE,
		// 		handleThumbMove, false, this);
		// 	goog.events.unlisten(host.element, goog.events.EventType.MOUSELEAVE,
		// 		handleThumbLeave, false, this);
		// }
        
        
        /**
         */
        // COMPILE::JS
        // private function calcValFromMousePosition(event:BrowserEvent, useOffset:Boolean):void
        // {
        //     var deltaX:Number = event.screenX - mouseOrigin;
		// 	if (deltaX == 0) return;
			
        //     var thumbW:int = parseInt(thumb.element.style.width, 10) / 2;
		// 	var newPointX:Number = thumbOrigin + deltaX;
			
		// 	var useWidth:Number = parseInt(track.element.style.width,10) * 1.0;
		// 	var p:Number = newPointX / useWidth;
		// 	var n:Number = p*(rangeModel.maximum - rangeModel.minimum) + rangeModel.minimum;
            
		// 	rangeModel.value = n;
        // }
    }
}
