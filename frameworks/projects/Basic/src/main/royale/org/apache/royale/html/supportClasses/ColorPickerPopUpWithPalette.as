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
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.layouts.TileLayout;
	import org.apache.royale.utils.loadBeadFromValuesManager;

	/**
	 *  The ColorPickerPopUpWithPalette class is used in ColorPicker. It contains a set of controls for picking a color, incluse a color palette.
	 * 
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class ColorPickerPopUpWithPalette extends ColorPickerPopUp
	{
		protected var colorPalette:ColorPalette;
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function ColorPickerPopUpWithPalette()
		{
			super();
			colorPalette = new ColorPalette();
			var colorPaletteLayout:TileLayout = loadBeadFromValuesManager(TileLayout, "iBeadLayout", colorPalette) as TileLayout;
			colorPaletteLayout.rowHeight = colorPaletteLayout.columnWidth = 30;
			var pwidth:Number = 300;
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
			if (getElementIndex(colorPalette) < 0)
			{
				addElement(colorPalette);
			}
		}
	}
}
