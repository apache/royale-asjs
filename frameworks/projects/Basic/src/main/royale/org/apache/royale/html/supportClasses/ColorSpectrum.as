
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
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.core.IColorSpectrumModel;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;

	/**
     *  Dispatched when the user changes the color.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
	[Event(name="change", type="org.apache.royale.events.Event")]

    /**
	 *  The ColorSpectrum class is use in a ColorPicker. It defines a base color and the spectrum of colors around it,
	 *  ranging from black to transparent, and from that base color to white.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
	public class ColorSpectrum extends UIBase
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function ColorSpectrum()
		{
			super();
			model.addEventListener("hsvModifiedColorChange", colorChangeHandler);
		}

        /**
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function get baseColor():Number
		{
			return IColorSpectrumModel(model).baseColor;
		}

        /**
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function set baseColor(value:Number):void
		{
			IColorSpectrumModel(model).baseColor = value;
		}

        /**
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		[Bindable(event="change")]
		public function get hsvModifiedColor():Number
		{
			return IColorSpectrumModel(model).hsvModifiedColor;
		}

		/**
		 *  dispatch change event in response to a colorChange event
		 *
		 *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
		 */
		public function colorChangeHandler(event:Event):void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}

	}
}
