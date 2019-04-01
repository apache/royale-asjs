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
	import org.apache.royale.core.IStrand;

	COMPILE::JS 
	{
		import org.apache.royale.core.IStrandWithModel;
		import org.apache.royale.core.IUIBase;
		import org.apache.royale.events.MouseEvent;
	}
	
    /**
     *  The ColorSpectrumMouseController class is a controller for
	 *  the ColorSpecrum control. It's job is to detect the location
	 *  where a user has clicked and change the model's selected color
	 *  value accordingly.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ColorSpectrumMouseController implements IBeadController
	{
		private var _strand:IStrand;
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function ColorSpectrumMouseController()
		{
		}
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			COMPILE::JS 
			{
                goog.events.listen(track.element, goog.events.EventType.CLICK,
                    handleClick, false, this);
			}
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.events.BrowserEvent
         */
        COMPILE::JS
        private function handleClick(event:MouseEvent):void
        {
			var bevent:BrowserEvent = event["wrappedEvent"] as BrowserEvent;
            var host:ColorSpectrum = _strand as IUIBase;
            var xloc:Number = bevent.offsetX;
            var yloc:Number = bevent.offsetY;
			var widthRatio:Number = xloc / host.width;
			var heightRatio:Number = yloc / host.height;
			var model:IColorSpectrumModel = (_strand as IStrandWithModel).model as IColorSpectrumModel;
			var hsvBaseColor:HSV = rgbToHsv(model.baseColor.color);
			model.hsvModifiedColor.color = hsvToHex(hsvBaseColor.h, hsvBaseColor.s * heightRatio, hsvBaseColor.v * widthRatio);
        }
	}
}
