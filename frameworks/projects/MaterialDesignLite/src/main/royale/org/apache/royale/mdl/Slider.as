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
package org.apache.royale.mdl
{
	import org.apache.royale.core.IRangeModel;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
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
     *  @productversion Royale 0.8
     */
	[Event(name="change", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched each time user moves the slider thumb from one position to another
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
	[Event(name="input", type="org.apache.royale.events.Event")]
	
	/**
	 *  The Slider class is used for selecting a value out of a range.
	 *  The Material Design Lite (MDL) slider component is an enhanced version of the new
	 *  HTML5 <input type="range"> element. A slider consists of a horizontal line upon which
	 *  sits a small, movable disc (the thumb) and, typically, text that clearly communicates
	 *  a value that will be set when the user moves it.
	 *  
	 *  In Royale the MDL Slider uses the following bead types:
	 * 
	 *  org.apache.royale.core.IBeadModel: the data model, typically an IRangeModel, that holds the Slider values.
	 *  org.apache.royale.core.IBeadView:  the bead that constructs the visual parts of the Slider.
	 *  org.apache.royale.core.IBeadController: the bead that handles input.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class Slider extends UIBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function Slider()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}
		
		/**
		 *  The current value of the Slider.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
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
		 *  The amount to move the thumb when the track is selected. This value is
		 *  adjusted to fit the nearest snapInterval.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
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
		private var _positioner:WrappedHTMLElement;

		COMPILE::JS
		override public function get positioner():WrappedHTMLElement
		{
			return _positioner;
		}

		COMPILE::JS
		override public function set positioner(value:WrappedHTMLElement):void
		{
			_positioner = value;
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion HTMLInputElement
		 * @royaleignorecoercion HTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			var div:HTMLElement = document.createElement('div') as HTMLElement;

			var input:HTMLInputElement = addElementToWrapper(this,'input') as HTMLInputElement;
			input.type = "range";
			input.className = "mdl-slider mdl-js-slider";
			
			div.appendChild(input);
            
            positioner = div as WrappedHTMLElement;
            _positioner.royale_wrapper = this;
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
    }
}
