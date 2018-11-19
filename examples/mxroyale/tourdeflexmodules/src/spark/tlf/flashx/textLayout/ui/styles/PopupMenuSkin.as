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

package flashx.textLayout.ui.styles
{
	import flash.filters.DropShadowFilter;
	
	import mx.skins.RectangularBorder;

	public class PopupMenuSkin extends RectangularBorder
	{
		public function PopupMenuSkin()
		{
			super();
			filters = [new DropShadowFilter(2, 90, 0x000000, .45, 2, 2)];
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
	 		if (getStyle("cornerRadius") != undefined)
				mCornerRadius = getStyle("cornerRadius");
			if (getStyle("backColor") != undefined)
				mBackColor = getStyle("backColor");
			if (getStyle("backAlpha") != undefined)
				mBackAlpha = getStyle("backAlpha");
			if (getStyle("lineColor") != undefined)
				mLineColor = getStyle("lineColor");
			if (getStyle("lineAlpha") != undefined)
				mLineAlpha = getStyle("lineAlpha");
			if (getStyle("lineWidth") != undefined)
				mLineWidth = getStyle("lineWidth");
	
			graphics.clear();
	 		graphics.lineStyle(mLineWidth, mLineColor, mLineAlpha);
			graphics.beginFill(mBackColor, mBackAlpha);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
				
		}
	
	 	private var mCornerRadius:Number = 0;
	 	private var mLineWidth:Number = 1;
	 	private var mBackColor:uint = 0x1a1a1a;
	 	private var mBackAlpha:Number = 0.9;
	 	private var mLineColor:uint = 0xffffff;
	 	private var mLineAlpha:Number = 0.15;


	}
	
	
}
