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
	import org.apache.flex.events.Event;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;        
    }

	//--------------------------------------
    //  Events
    //--------------------------------------

     /**
     *  Dispatched when Slider ends its change from one position to another.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
	[Event(name="change", type="org.apache.flex.events.Event")]

	/**
     *  Dispatched each time user moves the slider thumb from one position to another
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
	[Event(name="input", type="org.apache.flex.events.Event")]
	
	/**
	 *  The Slider class is used for selecting a value out of a range.
	 *  The Material Design Lite (MDL) slider component is an enhanced version of the new
	 *  HTML5 <input type="range"> element. A slider consists of a horizontal line upon which
	 *  sits a small, movable disc (the thumb) and, typically, text that clearly communicates
	 *  a value that will be set when the user moves it.
	 *  
	 *  In FlexJS the MDL Slider uses the following bead types:
	 * 
	 *  org.apache.flex.core.IBeadModel: the data model, typically an IRangeModel, that holds the Slider values.
	 *  org.apache.flex.core.IBeadView:  the bead that constructs the visual parts of the Slider.
	 *  org.apache.flex.core.IBeadController: the bead that handles input.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class Slider extends UIBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function Slider()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
			
			//default model values 
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
		 *  @productversion FlexJS 0.8
		 */
		public function get value():Number
		{
			return IRangeModel(model).value;
		}
		public function set value(newValue:Number):void
		{
			IRangeModel(model).value = newValue;
		}
		
		/**
		 *  The minimum value of the Slider.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get minimum():Number
		{
			return IRangeModel(model).minimum;
		}
		public function set minimum(value:Number):void
		{
			IRangeModel(model).minimum = value;
		}
		
		/**
		 *  The maximum value of the Slider.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get maximum():Number
		{
			return IRangeModel(model).maximum;
		}
		public function set maximum(value:Number):void
		{
			IRangeModel(model).maximum = value;
		}
		
		/**
		 *  The modulus of the Slider value. The thumb will be positioned
		 *  at the nearest multiple of this value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
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
		 *  @productversion FlexJS 0.8
		 */
        public function get stepSize():Number
        {
            return IRangeModel(model).stepSize;
        }
        public function set stepSize(value:Number):void
        {
            IRangeModel(model).stepSize = value;
        }
        
		COMPILE::JS
		private var input:HTMLInputElement;

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 * @flexjsignorecoercion HTMLInputElement
		 * @flexjsignorecoercion HTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-slider mdl-js-slider";

			var p:HTMLElement = document.createElement('p') as HTMLElement;
            p.style.width = '300px';

			input = document.createElement('input') as HTMLInputElement;
			input.type = "range";
			input.className = typeNames;
			
			p.appendChild(input);

			element = input as WrappedHTMLElement; 
            
            positioner = p as WrappedHTMLElement;
			(input as WrappedHTMLElement).flexjs_wrapper = this;
            element.flexjs_wrapper = this;

            return element;
        }
        
		private var _className:String;

        /**
         * since we have a div surronding the main input, we need to 
         * route the class assignaments to div
         */
        override public function set className(value:String):void
		{
			if (_className != value)
			{
                COMPILE::JS
                {
                    positioner.className = typeNames ? value + ' ' + typeNames : value;             
                }
				_className = value;
				dispatchEvent(new Event("classNameChanged"));
			}
		}

        /**
		 * @private
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
    }
}
