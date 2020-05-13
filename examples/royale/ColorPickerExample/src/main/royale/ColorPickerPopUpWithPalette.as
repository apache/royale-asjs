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
////////////////////////////////////////////////////////////////////////////////package 
package {
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.HideColorSpectrumThumbWhenEmpty;
	import org.apache.royale.html.beads.layouts.TileLayout;
	import org.apache.royale.html.supportClasses.ColorPalette;
	import org.apache.royale.html.supportClasses.ColorPickerPopUp;
	import org.apache.royale.core.IColorSpectrumModel;
	import org.apache.royale.utils.loadBeadFromValuesManager;

	public class ColorPickerPopUpWithPalette extends ColorPickerPopUp
	{
		protected var colorPalette:ColorPalette;
		public function ColorPickerPopUpWithPalette()
		{
			super();
			colorSpectrum.addBead(new HideColorSpectrumThumbWhenEmpty());
			style = {padding: 10};
			colorPalette = new ColorPalette();
			var colorPaletteLayout:TileLayout = loadBeadFromValuesManager(TileLayout, "iBeadLayout", colorPalette) as TileLayout;
			colorPaletteLayout.rowHeight = colorPaletteLayout.columnWidth = 30;
			var pwidth:Number = 100;
			var margin:Number = 10;
			colorPalette.width =  pwidth;
			colorSpectrum.x = pwidth + margin;
			COMPILE::JS 
			{
				colorSpectrum.element.style.position = "absolute";
			}
			hueSelector.x += pwidth + margin;
			
		}
		
		override public function set model(value:Object):void
		{
			super.model = value;
			colorPalette.model = value;
			(value as IEventDispatcher).addEventListener("change", changeHandler);
			
			if (getElementIndex(colorPalette) < 0)
			{
				addElement(colorPalette);
			}
		}
		
		private function changeHandler(event:org.apache.royale.events.Event):void
		{
			var model:IColorSpectrumModel = colorSpectrum.model as IColorSpectrumModel;
			model.baseColor = model.hsvModifiedColor = colorPalette.selectedItem as Number;
		}
	}
}
