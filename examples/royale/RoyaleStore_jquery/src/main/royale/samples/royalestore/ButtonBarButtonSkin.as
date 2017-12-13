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

package samples.royalestore
{

import flash.display.GradientType;
import mx.containers.BoxDirection;
import mx.controls.Button;
import mx.controls.ButtonBar;
import mx.skins.Border;
import mx.skins.halo.*;
import mx.styles.StyleManager;
import mx.utils.ColorUtil;

/**
 *  Adapted from mx.skins.halo.ButtonBarButtonSkin.
 *  This version of the ButtonBarButtonSkin is applied for the
 *  selectedOver, selectedUp, and over states to use the 2nd two
 *  values of the fillColors for the selected state of the
 *  button.  The over state then uses a computed value from
 *  the themeColor to show emphasis.  The border of the selected
 *  button also uses a computed value from the themeColor, but
 *  is partially transparent.
 */
public class ButtonBarButtonSkin extends Border
{
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private static var cache:Object = {};

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  Several colors used for drawing are calculated from the base colors
	 *  of the component (themeColor, borderColor and fillColors).
	 *  Since these calculations can be a bit expensive,
	 *  we calculate once per color set and cache the results.
	 */
	private static function calcDerivedStyles(themeColor:uint,
											  fillColor0:uint,
											  fillColor1:uint):Object
	{
		var key:String = HaloColors.getCacheKey(themeColor,
												fillColor0, fillColor1);

		if (!cache[key])
		{
			var o:Object = cache[key] = {};

			// Cross-component styles.
			HaloColors.addHaloColors(o, themeColor, fillColor0, fillColor1);

			// Button-specific styles.
			o.innerEdgeColor1 = ColorUtil.adjustBrightness2(fillColor0, -10);
			o.innerEdgeColor2 = ColorUtil.adjustBrightness2(fillColor1, -25);
		}

		return cache[key];
	}

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  Constructor.
	 */
	public function ButtonBarButtonSkin()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  measuredWidth
	//----------------------------------

	/**
	 *  @private
	 */
	override public function get measuredWidth():Number
	{
		return 50;
	}

	//----------------------------------
	//  measuredHeight
	//----------------------------------

	/**
	 *  @private
	 */
	override public function get measuredHeight():Number
	{
		return 22;
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override protected function updateDisplayList(w:Number, h:Number):void
	{
		super.updateDisplayList(w, h);

		// User-defined styles.
		var borderColor:uint = getStyle("borderColor");
		var cornerRadius:Number = getStyle("cornerRadius");
		var fillAlphas:Array = getStyle("fillAlphas");
		var fillColors:Array = getStyle("fillColors");
		styleManager.getColorNames(fillColors);
		var highlightAlphas:Array = getStyle("highlightAlphas");
		var themeColor:uint = getStyle("themeColor");

		// Derivative styles.
		var derStyles:Object = calcDerivedStyles(themeColor, fillColors[0],
												 fillColors[1]);

		var borderColorDrk1:Number =
			ColorUtil.adjustBrightness2(borderColor, -50);

		var themeColorDrk1:Number =
			ColorUtil.adjustBrightness2(themeColor, -25);

		var emph:Boolean = false;

		if (parent is Button)
			emph = (parent as Button).emphasized;

		var tmp:Number;

		var bar:ButtonBar = parent ? ButtonBar(parent.parent) : null;
		var horizontal:Boolean = true;
		var pos:int = 0;

		if (bar)
		{
			if (bar.direction == BoxDirection.VERTICAL)
				horizontal = false;

			// first: -1, middle: 0, last: 1
			var index:int = bar.getChildIndex(parent);
			pos = (index == 0 ? -1 : (index == bar.numChildren - 1 ? 1 : 0));
		}

		var radius:Object = getCornerRadius(pos, horizontal, cornerRadius);
		var cr:Object = getCornerRadius(pos, horizontal, cornerRadius);
		var cr1:Object = getCornerRadius(pos, horizontal, cornerRadius - 1);
		var cr2:Object = getCornerRadius(pos, horizontal, cornerRadius - 2);
		var cr3:Object = getCornerRadius(pos, horizontal, cornerRadius - 3);

		graphics.clear();

		switch (name)
		{
			case "selectedUpSkin":
			case "selectedOverSkin":
			{
				var overFillColors:Array;
				if (fillColors.length > 2)
					overFillColors = [ fillColors[2], fillColors[3] ];
				else
					overFillColors = [ fillColors[0], fillColors[1] ];

				var overFillAlphas:Array;
				if (fillAlphas.length > 2)
					overFillAlphas = [ fillAlphas[2], fillAlphas[3] ];
  				else
					overFillAlphas = [ fillAlphas[0], fillAlphas[1] ];

				// button border/edge
				drawRoundRect(
					0, 0, w, h, cr,
					[ themeColor, derStyles.themeColDrk1 ], 0.5,
					verticalGradientMatrix(0, 0, w , h),
					GradientType.LINEAR, null,
					{ x: 1, y: 1, w: w - 2, h: h - 2, r: cr1 });

				// button fill
				drawRoundRect(
					1, 1, w - 2, h - 2, cr1,
					overFillColors, overFillAlphas,
					verticalGradientMatrix(0, 0, w - 2, h - 2));

				// top highlight
				if (!(radius is Number))
					{ radius.bl = radius.br = 0;}
				drawRoundRect(
					1, 1, w - 2, (h - 2) / 2, radius,
					[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
					verticalGradientMatrix(1, 1, w - 2, (h - 2) / 2));
				break;
			}

			case "overSkin":
			{
				// button border/edge
				drawRoundRect(
					0, 0, w, h, cr,
					[ themeColor, derStyles.themeColDrk1 ], 0.5,
					verticalGradientMatrix(0, 0, w, h));

				// button fill
				drawRoundRect(
					1, 1, w - 2, h - 2, cr1,
					[ derStyles.fillColorPress1, derStyles.fillColorPress2 ], 1,
					verticalGradientMatrix(0, 0, w - 2, h - 2));

				// top highlight
				if (!(radius is Number))
					{ radius.bl = radius.br = 0;}
				drawRoundRect(
					1, 1, w - 2, (h - 2) / 2, radius,
					[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
					verticalGradientMatrix(1, 1, w - 2, (h - 2) / 2));

				break;
			}
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private function getCornerRadius(pos:int, horizontal:Boolean,
									 radius:Number):Object
	{
		if (pos == 0)
			return 0;

		radius = Math.max(0, radius);

		if (horizontal)
		{
			if (pos == -1)
				return { tl: radius, tr: 0, bl: radius, br: 0 };
			else // pos == 1
				return { tl: 0, tr: radius, bl: 0, br: radius };
		}
		else
		{
			if (pos == -1)
				return { tl: radius, tr: radius, bl: 0, br: 0 };
			else // pos == 1
				return { tl: 0, tr: 0, bl: radius, br: radius };
		}
	}
}

}
