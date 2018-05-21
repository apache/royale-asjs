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
package org.apache.royale.jewel
{
	import org.apache.royale.core.IRangeModel;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
    import org.apache.royale.utils.ClassSelectorList;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
		import org.apache.royale.utils.cssclasslist.addStyles; 
    }

	//--------------------------------------
    //  Events
    //--------------------------------------

	/**
     *  Dispatched when Slider change its value.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
	[Event(name="valueChange", type="org.apache.royale.events.ValueChangeEvent")]

     /**
     *  Dispatched when Slider ends its change from one position to another.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
	[Event(name="change", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched each time user moves the slider thumb from one position to another
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
	[Event(name="input", type="org.apache.royale.events.Event")]

	/**
	 *  The Slider class is a component that displays a range of values using a
	 *  track and a thumb control. The Slider uses the following bead types:
	 *
	 *  org.apache.royale.core.IBeadModel: the data model, typically an IRangeModel, that holds the Slider values.
	 *  org.apache.royale.core.IBeadView:  the bead that constructs the visual parts of the Slider.
	 *  org.apache.royale.core.IBeadController: the bead that handles input.
	 *  org.apache.royale.core.IThumbValue: the bead responsible for the display of the thumb control.
	 *  org.apache.royale.core.ITrackView: the bead responsible for the display of the track.
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class Slider extends UIBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function Slider()
		{
			super();

            classSelectorList = new ClassSelectorList(this);
			typeNames = "jewel slider";

			IRangeModel(model).value = 0;
			IRangeModel(model).minimum = 0;
			IRangeModel(model).maximum = 100;
			IRangeModel(model).stepSize = 1;
			IRangeModel(model).snapInterval = 1;
		}
		
        protected var classSelectorList:ClassSelectorList;
        
		/**
		 *  The current value of the Slider.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		[Bindable("valueChange")]
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
		 *  @productversion Royale 0.9.3
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
		 *  @productversion Royale 0.9.3
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.9.3
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
		 * @royaleignorecoercion HTMLDivElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			var div:HTMLDivElement = document.createElement('div') as HTMLDivElement;
            
            var input:HTMLInputElement = addElementToWrapper(this,'input') as HTMLInputElement;
            input.setAttribute('type', 'range');
			
			div.appendChild(input);

            positioner = div as WrappedHTMLElement;
            _positioner.royale_wrapper = this;
			
			return element;
        }

        COMPILE::JS
        override protected function setClassName(value:String):void
        {
            classSelectorList.addNames(value);
        }
    }
}
