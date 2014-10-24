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
package org.apache.flex.html.beads.controllers
{
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.IRangeModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.events.MouseEvent;
    import org.apache.flex.geom.Point;
	import org.apache.flex.html.beads.ISliderView;
	
	/**
	 *  The SliderMouseController class bead handles mouse events on the 
	 *  org.apache.flex.html.Slider's component parts (thumb and track) and 
	 *  dispatches change events on behalf of the Slider (as well as co-ordinating visual 
	 *  changes (such as moving the thumb when the track has been tapped or clicked).
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class SliderMouseController implements IBead, IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function SliderMouseController()
		{
		}
		
		private var rangeModel:IRangeModel;
		
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
			
			rangeModel = UIBase(value).model as IRangeModel;
			
			var sliderView:ISliderView = value.getBeadByType(ISliderView) as ISliderView;
			sliderView.thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDownHandler);
			
			// add handler to detect click on track
			sliderView.track.addEventListener(MouseEvent.CLICK, trackClickHandler, false, 99999);
		}
		
		/**
		 * @private
		 */
		private function thumbDownHandler( event:MouseEvent ) : void
		{
			UIBase(_strand).stage.addEventListener(MouseEvent.MOUSE_MOVE, thumbMoveHandler);
			UIBase(_strand).stage.addEventListener(MouseEvent.MOUSE_UP, thumbUpHandler);
			
			var sliderView:ISliderView = _strand.getBeadByType(ISliderView) as ISliderView;
			
			origin = new Point(event.stageX, event.stageY);
			thumb = new Point(sliderView.thumb.x,sliderView.thumb.y);
		}
		
		/**
		 * @private
		 */
		private function thumbUpHandler( event:MouseEvent ) : void
		{
			UIBase(_strand).stage.removeEventListener(MouseEvent.MOUSE_MOVE, thumbMoveHandler);
			UIBase(_strand).stage.removeEventListener(MouseEvent.MOUSE_UP, thumbUpHandler);
			
			IEventDispatcher(_strand).dispatchEvent(new Event("valueChange"));
		}
		
		private var origin:Point;
		private var thumb:Point;
		
		/**
		 * @private
		 */
		private function thumbMoveHandler( event:MouseEvent ) : void
		{
			var sliderView:ISliderView = _strand.getBeadByType(ISliderView) as ISliderView;
			
			var deltaX:Number = event.stageX - origin.x;
			var thumbW:Number = sliderView.thumb.width/2;
			var newX:Number = thumb.x + deltaX;
			
			var p:Number = newX/UIBase(_strand).width;
			var n:Number = p*(rangeModel.maximum - rangeModel.minimum) + rangeModel.minimum;
		
			rangeModel.value = n;
			
			IEventDispatcher(_strand).dispatchEvent(new Event("valueChange"));
		}
		
		/**
		 * @private
		 */
		private function trackClickHandler( event:MouseEvent ) : void
		{
			event.stopImmediatePropagation();
			
			var sliderView:ISliderView = _strand.getBeadByType(ISliderView) as ISliderView;
			
			var xloc:Number = event.localX;
			var p:Number = xloc/UIBase(_strand).width;
			var n:Number = p*(rangeModel.maximum - rangeModel.minimum) + rangeModel.minimum;
			
			rangeModel.value = n;
			
			IEventDispatcher(_strand).dispatchEvent(new Event("valueChange"));
		}
	}
}
