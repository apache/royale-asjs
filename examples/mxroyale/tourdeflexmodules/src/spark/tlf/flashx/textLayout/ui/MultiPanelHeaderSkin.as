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

package flashx.textLayout.ui
{
	import mx.skins.RectangularBorder;
	import mx.utils.GraphicsUtil;
	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;

	public class MultiPanelHeaderSkin extends RectangularBorder
	{
		public function MultiPanelHeaderSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			var fillColors:Array = [0x000000, 0x000000];
			var fillAlphas:Array = [1.0, 1.0];
			var borderColor:uint = 0x2A2A2A;
			var borderAlpha:Number = 1.0;
			
 			if (getStyle("fillColors") != undefined)
				fillColors = getStyle("fillColors");
 			if (getStyle("fillAlphas") != undefined)
				fillAlphas = getStyle("fillAlphas");
 			if (getStyle("borderColor") != undefined)
				borderColor = getStyle("borderColor");
 			if (getStyle("borderAlpha") != undefined)
				borderAlpha = getStyle("borderAlpha");

			graphics.clear();
			drawRoundRect(0,0,w, h, null, fillColors, fillAlphas, verticalGradientMatrix(0,0,w,h));
			graphics.lineStyle(1, borderColor, borderAlpha, true, LineScaleMode.NONE, CapsStyle.SQUARE);
			graphics.drawRect(0, 0, w-1, h);
		}
	}
}