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
package org.apache.royale.mdl.beads.controllers
{
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IRangeModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.geom.Point;
	import org.apache.royale.html.beads.ISliderView;

    COMPILE::JS
    {
		import goog.events;
        import goog.events.EventType;
        import org.apache.royale.events.BrowserEvent;
        import org.apache.royale.mdl.Slider;
    }
	
	/**
	 *  The SliderMouseController class bead handles mouse events on the 
	 *  org.apache.royale.mdl.Slider's component parts (in swf thumb and track) and 
	 *  dispatches input and change events on behalf of the Slider (in swf, as well,
     *  co-ordinating visual changes (such as moving the thumb when the track has 
     *  been tapped or clicked).
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class SliderMouseController implements IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
         */
		private var rangeModel:IRangeModel;
		
		private var _strand:IStrand;
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
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
				//track = sliderView.track as UIBase;
				//thumb = sliderView.thumb as UIBase;
                //goog.events.listen(track.element, goog.events.EventType.CLICK, handleTrackClick, false, this);
                //goog.events.listen(thumb.element, goog.events.EventType.MOUSEDOWN, handleThumbDown, false, this);

                goog.events.listen(UIBase(_strand).element, goog.events.EventType.CHANGE, handleChange, false, this);
                goog.events.listen(UIBase(_strand).element, goog.events.EventType.INPUT, handleInput, false, this);
            }
		}

        /**
         *  Manages the change event to update the range model value
         *   
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
         */
        COMPILE::JS
        private function handleChange(event:BrowserEvent):void
        {
            var host:Slider = _strand as Slider;

            rangeModel.value = Number((UIBase(_strand).element as HTMLInputElement).value);

            //host.dispatchEvent(new org.apache.royale.events.Event('change')); --- This is not needed, the event is thrown in the main comp
        }

        /**
         *  Manages the input event to update the range model value and dispatch a input Royale event 
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
         */
        COMPILE::JS
        private function handleInput(event:BrowserEvent):void
        {
            var host:Slider = _strand as Slider;

            rangeModel.value = Number((UIBase(_strand).element as HTMLInputElement).value);

            host.dispatchEvent(new org.apache.royale.events.Event('input'));
        }
		
        COMPILE::SWF
		private var origin:Point;
        COMPILE::SWF
		private var thumb:Point;

		/**
		 *  @private
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        COMPILE::SWF
		private function thumbDownHandler( event:MouseEvent ) : void
		{
			UIBase(_strand).topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_MOVE, thumbMoveHandler);
			UIBase(_strand).topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_UP, thumbUpHandler);
			
			var sliderView:ISliderView = _strand.getBeadByType(ISliderView) as ISliderView;
			
			origin = new Point(event.screenX, event.screenY);
			thumb = new Point(sliderView.thumb.x,sliderView.thumb.y);
		}
		
		/**
		 *  @private
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        COMPILE::SWF
		private function thumbUpHandler( event:MouseEvent ) : void
		{
			UIBase(_strand).topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, thumbMoveHandler);
			UIBase(_strand).topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_UP, thumbUpHandler);
			
			IEventDispatcher(_strand).dispatchEvent(new Event("valueChange"));
		}
		
		/**
		 *  @private
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
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
		
			rangeModel.value = n;
			
			IEventDispatcher(_strand).dispatchEvent(new Event("valueChange"));
		}
		
		/**
		 *  @private
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        COMPILE::SWF
		private function trackClickHandler( event:MouseEvent ) : void
		{
			event.stopImmediatePropagation();
			
			var sliderView:ISliderView = _strand.getBeadByType(ISliderView) as ISliderView;
			
			var xloc:Number = event.localX;
			var p:Number = xloc/sliderView.track.width;
			var n:Number = p*(rangeModel.maximum - rangeModel.minimum) + rangeModel.minimum;
			
			rangeModel.value = n;
			
			IEventDispatcher(_strand).dispatchEvent(new Event("valueChange"));
		}
    }
}
