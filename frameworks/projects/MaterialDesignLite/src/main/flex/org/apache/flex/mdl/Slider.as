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
package org.apache.flex.mdl
{
	import org.apache.flex.core.IRangeModel;
	import org.apache.flex.core.UIBase;

    COMPILE::JS
    {
        import org.apache.flex.html.beads.SliderTrackView;
        import org.apache.flex.html.beads.SliderThumbView;
        import org.apache.flex.html.beads.controllers.SliderMouseController;
        import org.apache.flex.core.WrappedHTMLElement;            
    }

	[Event(name="valueChange", type="org.apache.flex.events.Event")]
	
	/**
	 *  The Slider class provides a MDL UI-like appearance for a slider.
	 *  It displays a range of values using a track and a thumb control. 
	 *  The Slider uses the following bead types:
	 * 
	 *  org.apache.flex.core.IBeadModel: the data model, typically an IRangeModel, that holds the Slider values.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class Slider extends UIBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function Slider()
		{
			super();
			
			IRangeModel(model).value = 0;
			IRangeModel(model).minimum = 0;
			IRangeModel(model).maximum = 100;
			IRangeModel(model).stepSize = 1;
			IRangeModel(model).snapInterval = 1;
		}
		
		/**
		 *  The current value of the Slider.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get value():Number
		{
			return IRangeModel(model).value;
		}
		public function set value(newValue:Number):void
		{
			IRangeModel(model).value = newValue;

			COMPILE::JS
			{
				(element as HTMLInputElement).value = IRangeModel(model).value.toString();
			}
		}
		
		/**
		 *  The minimum value of the Slider.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get minimum():Number
		{
			return IRangeModel(model).minimum;
		}
		public function set minimum(value:Number):void
		{
			IRangeModel(model).minimum = value;

			COMPILE::JS
			{
				(element as HTMLInputElement).min = IRangeModel(model).minimum.toString();
			}
		}
		
		/**
		 *  The maximum value of the Slider.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get maximum():Number
		{
			return IRangeModel(model).maximum;
		}
		public function set maximum(value:Number):void
		{
			IRangeModel(model).maximum = value;

			COMPILE::JS
			{
				(element as HTMLInputElement).max = IRangeModel(model).maximum.toString();
			}
			
		}
		
		/**
		 *  The modulus of the Slider value. The thumb will be positioned
		 *  at the nearest multiple of this value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get snapInterval():Number
		{
			return IRangeModel(model).snapInterval;
		}
		public function set snapInterval(value:Number):void
		{
			IRangeModel(model).snapInterval = value;
		}
        
		/**
		 *  The amount to move the thumb when the track is selected. This value is
		 *  adjusted to fit the nearest snapInterval.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get stepSize():Number
        {
            return IRangeModel(model).stepSize;
        }
        public function set stepSize(value:Number):void
        {
            IRangeModel(model).stepSize = value;

			COMPILE::JS
			{
				(element as HTMLInputElement).step = IRangeModel(model).stepSize.toString();
			}
        }

        COMPILE::JS
        private var track:SliderTrackView;
        
        COMPILE::JS
        private var thumb:SliderThumbView;
        
        COMPILE::JS
        private var controller:SliderMouseController;
        
		COMPILE::JS
		private var input:HTMLInputElement;

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 * @flexjsignorecoercion HTMLInputElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			var p:HTMLElement = document.createElement('p') as HTMLElement;
            p.style.width = '300px';

			input = document.createElement('input') as HTMLInputElement;
			input.type = "range";
			input.className = 'mdl-slider mdl-js-slider';

			input.value = IRangeModel(model).value.toString();
			input.min = IRangeModel(model).minimum.toString();
			input.max = IRangeModel(model).maximum.toString();
			input.step = IRangeModel(model).stepSize.toString();
			
			p.appendChild(input);

			element = input as WrappedHTMLElement;
            
            //track = new SliderTrackView();
            //addBead(track);            
            //thumb = new SliderThumbView();
            //addBead(thumb);
            //controller = new SliderMouseController();
            //addBead(controller);
            
            positioner = p as WrappedHTMLElement;
            positioner.style.position = 'relative';
			(input as WrappedHTMLElement).flexjs_wrapper = this;
            element.flexjs_wrapper = this;
            
            return element;
        } 
        
        /**
         */
        COMPILE::JS
        public function snap(value:Number):Number
        {
            var si:Number = snapInterval;
            var n:Number = Math.round((value - minimum) / si) *
                si + minimum;
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
         * @param {number} value The value used to calculate new position of the thumb.
         * @return {void} Moves the thumb to the corresponding position.
         */
        COMPILE::JS
        public function setThumbFromValue(value:Number):void
        {
            var min:Number = model.minimum;
            var max:Number = model.maximum;
            var p:Number = (value - min) / (max - min);
            var xloc:Number = p * (parseInt(track.element.style.width, 10) -
                parseInt(thumb.element.style.width, 10));
            
            thumb.element.style.left = "" + xloc + 'px';
        }        

    }
}
