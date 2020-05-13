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
    COMPILE::JS
    {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.utils.transparentPixelElement;
    }
	
	/**
	 *  The VSlider class is a component that displays a range of values using a
	 *  track and a thumb control vertically. The VSlider uses the following bead types:
	 *
	 *  org.apache.royale.core.IBeadModel: the data model, typically an IRangeModel, that holds the VSlider values.
	 *  org.apache.royale.core.IBeadView:  the bead that constructs the visual parts of the VSlider.
	 *  org.apache.royale.core.IBeadController: the bead that handles input.
	 *  org.apache.royale.core.IThumbValue: the bead responsible for the display of the thumb control.
	 *  org.apache.royale.core.ITrackView: the bead responsible for the display of the track.
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class VSlider extends HSlider
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function VSlider()
		{
			super();
			typeNames = "vslider";
		}
		
		
		COMPILE::JS
		private var internalWrapper:WrappedHTMLElement;
		
		COMPILE::JS
		override public function get transformElement():WrappedHTMLElement
		{
			return internalWrapper;
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion HTMLDivElement
		 */
		COMPILE::JS
		override public function set positioner(value:WrappedHTMLElement):void
		{
			value.royale_wrapper = this;
			value.appendChild(element);
			internalWrapper = value;
			value.className = "jewel slider";
			
			var outer:WrappedHTMLElement = document.createElement('div') as WrappedHTMLElement;
			outer.royale_wrapper = this;
			outer.appendChild(transparentPixelElement('sizer'));
			outer.className = "transform-container";
			outer.appendChild(value);
			
			var clip:WrappedHTMLElement = document.createElement('div') as WrappedHTMLElement;
			clip.royale_wrapper = this;
			clip.appendChild(outer);
			
			_positioner = clip;
		}
	}
}
