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
package org.apache.royale.html.beads
{
    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.IColorSpectrumModel;
    import org.apache.royale.core.IRenderedObject;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStrandWithModel;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.Button;
    import org.apache.royale.utils.CSSUtils;
	
    /**
     *  The ColorSpectrumView class is the view for
     *  the org.apache.royale.html.ColorSpectrum
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
	public class ColorSpectrumView extends BeadViewBase
	{
		private var _button:Button;
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function ColorSpectrumView()
		{
			super();
		}
		
        /**
         *  @private
         */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_button = new Button();
			(value as IEventDispatcher).addEventListener("change", changeHandler);
			updateSpectrum();
		}
		
		private function changeHandler(e:Event):void
		{
			updateSpectrum();
		}
		
		private function updateSpectrum():void
		{
			var color:String = CSSUtils.attributeFromColor(colorModel.baseColor);
			COMPILE::JS
			{
				(host as IRenderedObject).element.style.background = "linear-gradient(to top, #000000, transparent), linear-gradient(to left, " + color + ", #ffffff)";
			}
		}
		
		private function get colorModel():IColorSpectrumModel
		{
			return (host as IStrandWithModel).model as IColorSpectrumModel;
		}
	}
}
