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
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IScrollBarModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.beads.IScrollBarView;
	import org.apache.royale.utils.sendStrandEvent;

    /**
     *  The ScrollBarMouseControllerBase class is the base class
     *  for ScrollBarMouseControllers such as VScrollBarMouseController.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ScrollBarMouseControllerBase implements IBeadController
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ScrollBarMouseControllerBase()
		{
		}
		
        /**
         *  The data model
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		protected var sbModel:IScrollBarModel;

        /**
         *  The view
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		protected var sbView:IScrollBarView;
		
		private var _strand:IStrand;
		
        /**
         *  @private
         */
		public function get strand():IStrand
		{
			return _strand;
		}
		
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
			sbModel = value.getBeadByType(IScrollBarModel) as IScrollBarModel;
			sbView = value.getBeadByType(IScrollBarView) as IScrollBarView;
			sbView.decrement.addEventListener(MouseEvent.CLICK, decrementClickHandler);
			sbView.increment.addEventListener(MouseEvent.CLICK, incrementClickHandler);
            sbView.decrement.addEventListener("buttonRepeat", decrementClickHandler);
            sbView.increment.addEventListener("buttonRepeat", incrementClickHandler);
			sbView.track.addEventListener(MouseEvent.CLICK, trackClickHandler);
			sbView.thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDownHandler);
		}
		
        /**
         *  Force the input number to be "snapped" to the snapInterval.
         *  
         *  @param value The input number.
         *  @return The input number "snapped" to the snapInterval.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */	
		protected function snap(value:Number):Number
		{
			var si:Number = sbModel.snapInterval;
			var n:Number = Math.round((value - sbModel.minimum) / si) * si + sbModel.minimum;
			if (value > 0)
			{
				if (value - n < n + si - value)
					return n;
				return n + si;
				
			}
			if (value - n > n + si - value)
				return n + si;
			return n;
		}
		
        /**
         *  Updates the model when the decrement button is clicked.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */	
		protected function decrementClickHandler(event:MouseEvent):void
		{
			sbModel.value = snap(Math.max(sbModel.minimum, sbModel.value - sbModel.stepSize));
			sendStrandEvent(_strand,"scroll");
		}
		
        /**
         *  Updates the model when the increment button is clicked.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */	
		protected function incrementClickHandler(event:MouseEvent):void
		{
			sbModel.value = snap(Math.min(sbModel.maximum - sbModel.pageSize, sbModel.value + sbModel.stepSize));	
			sendStrandEvent(_strand,"scroll");
		}
		
        /**
         *  Handles a click in the track.  Must be overridden.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */	
		protected function trackClickHandler(event:MouseEvent):void
		{
		}
		
        /**
         *  Handles a mouse down on the thumb.  Must be overridden.
         *  Subclasses process the mouseMove and mouseUp events.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */	
		protected function thumbMouseDownHandler(event:MouseEvent):void
		{
		}
		
	}
}
