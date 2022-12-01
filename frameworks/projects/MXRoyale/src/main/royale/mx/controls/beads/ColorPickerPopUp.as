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
package mx.controls.beads
{
	import org.apache.royale.core.IColorModel;
	import org.apache.royale.core.IColorSpectrumModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.core.IBead;
	import org.apache.royale.html.supportClasses.ColorPalette;
	import org.apache.royale.html.beads.layouts.TileLayout;
	import org.apache.royale.html.supportClasses.IColorPickerPopUp;
	import org.apache.royale.html.TextInput;
	import org.apache.royale.html.Group;
	import org.apache.royale.core.IStyleableObject;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.CSSUtils;
	import org.apache.royale.html.beads.DispatchInputFinishedBead;
	import org.apache.royale.html.accessories.RestrictToColorTextInputBead;
	import org.apache.royale.core.IStrandWithModel;

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
		protected var colorPalette:ColorPalette;
		protected var textInput:TextInput;
		protected var selectedColorDisplay:Group;
		protected var host:IStrand;
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 */
		public function ColorPickerPopUp()
		{
			super();
			colorPalette = new ColorPalette();
			var colorPaletteLayout:TileLayout = loadBeadFromValuesManager(TileLayout, "iBeadLayout", colorPalette) as TileLayout;
			selectedColorDisplay = new Group();
			(selectedColorDisplay as IStyleableObject).className = "ColorPickerDisplayedColor";			
			var irDim:int = 11;
			var margin:int = 2;
			colorPaletteLayout.rowHeight = colorPaletteLayout.columnWidth = irDim;
			colorPalette.width =  irDim * 20;
			selectedColorDisplay.width = irDim * 4;
			textInput = new TextInput();
			textInput.width = 62;
			textInput.x = selectedColorDisplay.width + margin * 2;
			selectedColorDisplay.y = textInput.y = margin;
			selectedColorDisplay.height = textInput.height = 24;
			colorPalette.y = selectedColorDisplay.height + margin * 2;
			COMPILE::JS
			{
				selectedColorDisplay.element.style.position = "absolute";
				textInput.element.style.position = "absolute";
				colorPalette.element.style.position = "absolute";
			}
		}
		
		override public function set model(value:Object):void
		{
			super.model = value;
			colorPalette.model = value;
			if (getElementIndex(selectedColorDisplay) < 0)
			{
				addElement(selectedColorDisplay);
			}
			if (getElementIndex(textInput) < 0)
			{
				addElement(textInput);
			}
			if (getElementIndex(colorPalette) < 0)
			{
				addElement(colorPalette);
			}
		}
		
		public function set strand(value:IStrand):void
		{
			host = value;
			textInput.addEventListener("change", changeHandler);
			var restrictBead:RestrictToColorTextInputBead = new RestrictToColorTextInputBead();
			textInput.addBead(restrictBead);
			textInput.addBead(new DispatchInputFinishedBead());
			textInput.addEventListener(DispatchInputFinishedBead.INPUT_FINISHED, inputFinishedHandler)
		}

		protected function changeHandler(event:Event):void
		{
			var color:uint = CSSUtils.toColorWithAlpha("#" + textInput.text);
			COMPILE::JS
			{
				selectedColorDisplay.element.style.backgroundColor = CSSUtils.attributeFromColor(color);
			}
		}

		protected function inputFinishedHandler(event:Event):void
		{
			var color:uint = CSSUtils.toColorWithAlpha("#" + textInput.text);
			((host as IStrandWithModel).model as IColorModel).color = color;
		}
		
	}
}
