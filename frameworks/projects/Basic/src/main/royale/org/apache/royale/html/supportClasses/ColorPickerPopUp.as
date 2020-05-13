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
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.core.IColorModel;
	import org.apache.royale.core.IColorSpectrumModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.HueSelector;
	import org.apache.royale.utils.hsvToHex;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.core.IBead;

	/**
	 *  The ColorPickerPopUp class is used in ColorPicker. It contains a set of controls for picking a color.
	 * 
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class ColorPickerPopUp extends UIBase implements IColorPickerPopUp, IBead
	{
		protected var colorSpectrum:ColorSpectrum;
		protected var hueSelector:HueSelector;
		protected var host:IStrand;
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function ColorPickerPopUp()
		{
			super();
			colorSpectrum = new ColorSpectrum();
			colorSpectrum.height =  300;
			colorSpectrum.width =  300;
			hueSelector = new HueSelector();
			hueSelector.width = 20;
			hueSelector.height = 300;
			hueSelector.x = 310;
            hueSelector.y = 0;
			hueSelector.addEventListener("valueChange", hueChangeHandler);
			COMPILE::JS 
			{
				hueSelector.element.style.position = "absolute";
			}
			addElement(colorSpectrum);
			addElement(hueSelector);
		}
		
		private function hueChangeHandler(event:Event):void
		{
			colorSpectrum.baseColor = hsvToHex(hueSelector.value, 100, 100);
		}

		override public function set model(value:Object):void
		{
			super.model = value;
			var colorSpectrumModel:IColorSpectrumModel = loadBeadFromValuesManager(IColorSpectrumModel, "iColorSpectrumModel", colorSpectrum) as IColorSpectrumModel;
			colorSpectrumModel.baseColor = (value as IColorModel).color;
			(colorSpectrum as IEventDispatcher).addEventListener("change", colorSpectrumChangeHandler);
            (colorSpectrum as IEventDispatcher).addEventListener("thumbDown", colorSpectrumThumbDownHandler);
            (colorSpectrum as IEventDispatcher).addEventListener("thumbUp", colorSpectrumThumbUpHandler);
		}
		
        private var draggingThumb:Boolean;
        
		protected function colorSpectrumChangeHandler(event:Event):void
		{
			(model as IColorModel).color = colorSpectrum.hsvModifiedColor;
            if (!draggingThumb)
                dispatchEvent(new Event("change"));
		}
        
        protected function colorSpectrumThumbDownHandler(event:Event):void
        {
            draggingThumb = true;
        }
        
        protected function colorSpectrumThumbUpHandler(event:Event):void
        {
            draggingThumb = false;
            (model as IColorModel).color = colorSpectrum.hsvModifiedColor;
            dispatchEvent(new Event("change"));
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
			host = value;
		}
		
	}
}
