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
package org.apache.royale.textLayout.formats
{

	

	
	import org.apache.royale.textLayout.elements.FlowValueHolder;
	public class TextLayoutFormatBase implements ITextLayoutFormat
	{

		/** @private */
		public function writableTextLayoutFormat():FlowValueHolder
		{
			if (_format == null)
				_format = new FlowValueHolder();
			return _format;
		}

		/** format settings on this FlowElement. @private */
		protected var _format:FlowValueHolder;
		
		/** TextLayoutFormat properties applied directly to this element.
		 * <p>Each element may have properties applied to it as part of its format. Properties applied to this element override properties inherited from the parent. Properties applied to this element will in turn be inherited by element's children if they are not overridden on the child. If no properties are applied to the element, this will be null.</p>
		 * @see org.apache.royale.textLayout.formats.ITextLayoutFormat
		 */
		public function get format():ITextLayoutFormat
		{ return _format; }
		public function set format(value:ITextLayoutFormat):void
		{
			if (value == _format)
				return;
			
			var oldStyleName:String = this.styleName;
			
			if (value == null)
				_format.clearStyles();
			else
				writableTextLayoutFormat().copy(value);
			formatChanged();
			
			if (oldStyleName != this.styleName)
				styleSelectorChanged();
		}

		/** This gets called when an element has changed its attributes. This may happen because an
		 * ancestor element changed it attributes.
		 * @private 
		 */
		public function formatChanged(notifyModelChanged:Boolean = true):void
		{
			throw new Error("This must be overridden!");
		}
		
		/** This gets called when an element has changed its style selection related attributes. This may happen because an
		 * ancestor element changed it attributes.
		 * @private 
		 */		
		public function styleSelectorChanged():void
		{
			throw new Error("This must be overridden!");
		}
		public function getStyle(styleProp:String):*
		{
			throw new Error("This must be overridden!");
		}

		[Inspectable(enumeration="auto,always,inherit")]
		/**
		 * TextLayoutFormat:
		 * Controls column break before the element.
		 * <p>Legal values are BreakStyle.AUTO, BreakStyle.ALWAYS, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of BreakStyle.AUTO.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.BreakStyle
		 */
		public function get columnBreakBefore():*
		{
			return _format ? _format.columnBreakBefore : undefined;
		}
		public function set columnBreakBefore(columnBreakBeforeValue:*):void
		{
			writableTextLayoutFormat().columnBreakBefore = columnBreakBeforeValue;
			formatChanged();
		}

		[Inspectable(enumeration="auto,always,inherit")]
		/**
		 * TextLayoutFormat:
		 * Controls column after before the element.
		 * <p>Legal values are BreakStyle.AUTO, BreakStyle.ALWAYS, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of BreakStyle.AUTO.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.BreakStyle
		 */
		public function get columnBreakAfter():*
		{
			return _format ? _format.columnBreakAfter : undefined;
		}
		public function set columnBreakAfter(columnBreakAfterValue:*):void
		{
			writableTextLayoutFormat().columnBreakAfter = columnBreakAfterValue;
			formatChanged();
		}

		[Inspectable(enumeration="auto,always,inherit")]
		/**
		 * TextLayoutFormat:
		 * Controls container break before the element.
		 * <p>Legal values are BreakStyle.AUTO, BreakStyle.ALWAYS, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of BreakStyle.AUTO.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.BreakStyle
		 */
		public function get containerBreakBefore():*
		{
			return _format ? _format.containerBreakBefore : undefined;
		}
		public function set containerBreakBefore(containerBreakBeforeValue:*):void
		{
			writableTextLayoutFormat().containerBreakBefore = containerBreakBeforeValue;
			formatChanged();
		}

		[Inspectable(enumeration="auto,always,inherit")]
		/**
		 * TextLayoutFormat:
		 * Controls container after before the element.
		 * <p>Legal values are BreakStyle.AUTO, BreakStyle.ALWAYS, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of BreakStyle.AUTO.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.BreakStyle
		 */
		public function get containerBreakAfter():*
		{
			return _format ? _format.containerBreakAfter : undefined;
		}
		public function set containerBreakAfter(containerBreakAfterValue:*):void
		{
			writableTextLayoutFormat().containerBreakAfter = containerBreakAfterValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Color of the text. A hexadecimal number that specifies three 8-bit RGB (red, green, blue) values; for example, 0xFF0000 is red and 0x00FF00 is green. It can also be enum value {BLACK, GREEN, GRAY, BLUE, SILVER, LIME, OLIVE, WHITE, YELLOW, MAROON, NAVY, RED, PURPLE, TEAL, FUCHSIA, AQUA, MAGENTA, CYAN}
		 * <p>Legal values as a string are ColorName.BLACK, ColorName.GREEN, ColorName.GRAY, ColorName.BLUE, ColorName.SILVER, ColorName.LIME, ColorName.OLIVE, ColorName.WHITE, ColorName.YELLOW, ColorName.MAROON, ColorName.NAVY, ColorName.RED, ColorName.PURPLE, ColorName.TEAL, ColorName.FUCHSIA, ColorName.AQUA, ColorName.MAGENTA, ColorName.CYAN, FormatValue.INHERIT and uints from 0x0 to 0xffffffff.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.ColorName
		 */
		public function get color():*
		{
			return _format ? _format.color : undefined;
		}
		public function set color(colorValue:*):void
		{
			writableTextLayoutFormat().color = colorValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Background color of the text (adopts default value if undefined during cascade). Can be either the constant value  <code>BackgroundColor.TRANSPARENT</code>, or a hexadecimal value that specifies the three 8-bit RGB (red, green, blue) values; for example, 0xFF0000 is red and 0x00FF00 is green.
		 * <p>Legal values as a string are BackgroundColor.TRANSPARENT, FormatValue.INHERIT and uints from 0x0 to 0xffffffff.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of BackgroundColor.TRANSPARENT.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.BackgroundColor
		 */
		public function get backgroundColor():*
		{
			return _format ? _format.backgroundColor : undefined;
		}
		public function set backgroundColor(backgroundColorValue:*):void
		{
			writableTextLayoutFormat().backgroundColor = backgroundColorValue;
			formatChanged();
		}

		[Inspectable(enumeration="true,false,inherit")]
		/**
		 * TextLayoutFormat:
		 * If <code>true</code>, applies strikethrough, a line drawn through the middle of the text.
		 * <p>Legal values are true, false and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of false.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get lineThrough():*
		{
			return _format ? _format.lineThrough : undefined;
		}
		public function set lineThrough(lineThroughValue:*):void
		{
			writableTextLayoutFormat().lineThrough = lineThroughValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Alpha (transparency) value for the text. A value of 0 is fully transparent, and a value of 1 is fully opaque. Display objects with <code>textAlpha</code> set to 0 are active, even though they are invisible.
		 * <p>Legal values are numbers from 0 to 1 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 1.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get textAlpha():*
		{
			return _format ? _format.textAlpha : undefined;
		}
		public function set textAlpha(textAlphaValue:*):void
		{
			writableTextLayoutFormat().textAlpha = textAlphaValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Alpha (transparency) value for the background (adopts default value if undefined during cascade). A value of 0 is fully transparent, and a value of 1 is fully opaque. Display objects with alpha set to 0 are active, even though they are invisible.
		 * <p>Legal values are numbers from 0 to 1 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of 1.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get backgroundAlpha():*
		{
			return _format ? _format.backgroundAlpha : undefined;
		}
		public function set backgroundAlpha(backgroundAlphaValue:*):void
		{
			writableTextLayoutFormat().backgroundAlpha = backgroundAlphaValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * The size of the text in pixels.
		 * <p>Legal values are numbers from 1 to 720 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 12.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get fontSize():*
		{
			return _format ? _format.fontSize : undefined;
		}
		public function set fontSize(fontSizeValue:*):void
		{
			writableTextLayoutFormat().fontSize = fontSizeValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * The horizontal scale of the text as a multiplier.
		 * <p>Legal values are numbers from 0.01 to 100 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 1.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get xScale():*
		{
			return _format ? _format.xScale : undefined;
		}
		public function set xScale(xScaleValue:*):void
		{
			writableTextLayoutFormat().xScale = xScaleValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * The vertical scale of the text as a multiplier.
		 * <p>Legal values are numbers from 0.01 to 100 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 1.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get yScale():*
		{
			return _format ? _format.yScale : undefined;
		}
		public function set yScale(yScaleValue:*):void
		{
			writableTextLayoutFormat().yScale = yScaleValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Amount to shift the baseline from the <code>dominantBaseline</code> value. Units are in pixels, or a percentage of <code>fontSize</code> (in which case, enter a string value, like 140%).  Positive values shift the line up for horizontal text (right for vertical) and negative values shift it down for horizontal (left for vertical). 
		 * <p>Legal values are BaselineShift.SUPERSCRIPT, BaselineShift.SUBSCRIPT, FormatValue.INHERIT.</p>
		 * <p>Legal values as a number are from -1000 to 1000.</p>
		 * <p>Legal values as a percent are numbers from -1000 to 1000.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 0.0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.BaselineShift
		 */
		public function get baselineShift():*
		{
			return _format ? _format.baselineShift : undefined;
		}
		public function set baselineShift(baselineShiftValue:*):void
		{
			writableTextLayoutFormat().baselineShift = baselineShiftValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Number in pixels (or percent of <code>fontSize</code>, like 120%) indicating the amount of tracking (manual kerning) to be applied to the left of each character. If kerning is enabled, the <code>trackingLeft</code> value is added to the values in the kerning table for the font. If kerning is disabled, the <code>trackingLeft</code> value is used as a manual kerning value. Supports both positive and negative values. 
		 * <p>Legal values as a number are from -1000 to 1000.</p>
		 * <p>Legal values as a percent are numbers from -1000% to 1000%.</p>
		 * <p>Legal values include FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get trackingLeft():*
		{
			return _format ? _format.trackingLeft : undefined;
		}
		public function set trackingLeft(trackingLeftValue:*):void
		{
			writableTextLayoutFormat().trackingLeft = trackingLeftValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Number in pixels (or percent of <code>fontSize</code>, like 120%) indicating the amount of tracking (manual kerning) to be applied to the right of each character.  If kerning is enabled, the <code>trackingRight</code> value is added to the values in the kerning table for the font. If kerning is disabled, the <code>trackingRight</code> value is used as a manual kerning value. Supports both positive and negative values. 
		 * <p>Legal values as a number are from -1000 to 1000.</p>
		 * <p>Legal values as a percent are numbers from -1000% to 1000%.</p>
		 * <p>Legal values include FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get trackingRight():*
		{
			return _format ? _format.trackingRight : undefined;
		}
		public function set trackingRight(trackingRightValue:*):void
		{
			writableTextLayoutFormat().trackingRight = trackingRightValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Leading controls for the text. The distance from the baseline of the previous or the next line (based on <code>LeadingModel</code>) to the baseline of the current line is equal to the maximum amount of the leading applied to any character in the line. This is either a number or a percent.  If specifying a percent, enter a string value, like 140%.<p><img src='../../../images/textLayout_lineHeight1.jpg' alt='lineHeight1' /><img src='../../../images/textLayout_lineHeight2.jpg' alt='lineHeight2' /></p>
		 * <p>Legal values as a number are from -720 to 720.</p>
		 * <p>Legal values as a percent are numbers from -1000% to 1000%.</p>
		 * <p>Legal values include FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 120%.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get lineHeight():*
		{
			return _format ? _format.lineHeight : undefined;
		}
		public function set lineHeight(lineHeightValue:*):void
		{
			writableTextLayoutFormat().lineHeight = lineHeightValue;
			formatChanged();
		}

		[Inspectable(enumeration="all,any,auto,none,inherit")]
		/**
		 * TextLayoutFormat:
		 * Controls where lines are allowed to break when breaking wrapping text into multiple lines. Set to <code>BreakOpportunity.AUTO</code> to break text normally. Set to <code>BreakOpportunity.NONE</code> to <em>not</em> break the text unless the text would overrun the measure and there are no other places to break the line. Set to <code>BreakOpportunity.ANY</code> to allow the line to break anywhere, rather than just between words. Set to <code>BreakOpportunity.ALL</code> to have each typographic cluster put on a separate line (useful for text on a path).
		 * <p>Legal values are BreakOpportunity.ALL, BreakOpportunity.ANY, BreakOpportunity.AUTO, BreakOpportunity.NONE, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of BreakOpportunity.AUTO.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.text.engine.BreakOpportunity
		 */
		public function get breakOpportunity():*
		{
			return _format ? _format.breakOpportunity : undefined;
		}
		public function set breakOpportunity(breakOpportunityValue:*):void
		{
			writableTextLayoutFormat().breakOpportunity = breakOpportunityValue;
			formatChanged();
		}

		[Inspectable(enumeration="default,lining,oldStyle,inherit")]
		/**
		 * TextLayoutFormat:
		 * The type of digit case used for this text. Setting the value to <code>DigitCase.OLD_STYLE</code> approximates lowercase letterforms with varying ascenders and descenders. The figures are proportionally spaced. This style is only available in selected typefaces, most commonly in a supplemental or expert font. The <code>DigitCase.LINING</code> setting has all-cap height and is typically monospaced to line up in charts.<p><img src='../../../images/textLayout_digitcase.gif' alt='digitCase' /></p>
		 * <p>Legal values are DigitCase.DEFAULT, DigitCase.LINING, DigitCase.OLD_STYLE, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of DigitCase.DEFAULT.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.text.engine.DigitCase
		 */
		public function get digitCase():*
		{
			return _format ? _format.digitCase : undefined;
		}
		public function set digitCase(digitCaseValue:*):void
		{
			writableTextLayoutFormat().digitCase = digitCaseValue;
			formatChanged();
		}

		[Inspectable(enumeration="default,proportional,tabular,inherit")]
		/**
		 * TextLayoutFormat:
		 * Type of digit width used for this text. This can be <code>DigitWidth.PROPORTIONAL</code>, which looks best for individual numbers, or <code>DigitWidth.TABULAR</code>, which works best for numbers in tables, charts, and vertical rows.<p><img src='../../../images/textLayout_digitwidth.gif' alt='digitWidth' /></p>
		 * <p>Legal values are DigitWidth.DEFAULT, DigitWidth.PROPORTIONAL, DigitWidth.TABULAR, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of DigitWidth.DEFAULT.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.text.engine.DigitWidth
		 */
		public function get digitWidth():*
		{
			return _format ? _format.digitWidth : undefined;
		}
		public function set digitWidth(digitWidthValue:*):void
		{
			writableTextLayoutFormat().digitWidth = digitWidthValue;
			formatChanged();
		}

		[Inspectable(enumeration="auto,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom,inherit")]
		/**
		 * TextLayoutFormat:
		 * Specifies which element baseline snaps to the <code>alignmentBaseline</code> to determine the vertical position of the element on the line. A value of <code>TextBaseline.AUTO</code> selects the dominant baseline based on the <code>locale</code> property of the parent paragraph.  For Japanese and Chinese, the selected baseline value is <code>TextBaseline.IDEOGRAPHIC_CENTER</code>; for all others it is <code>TextBaseline.ROMAN</code>. These baseline choices are determined by the choice of font and the font size.<p><img src='../../../images/textLayout_baselines.jpg' alt='baselines' /></p>
		 * <p>Legal values are FormatValue.AUTO, TextBaseline.ROMAN, TextBaseline.ASCENT, TextBaseline.DESCENT, TextBaseline.IDEOGRAPHIC_TOP, TextBaseline.IDEOGRAPHIC_CENTER, TextBaseline.IDEOGRAPHIC_BOTTOM, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of FormatValue.AUTO.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.text.engine.TextBaseline
		 */
		public function get dominantBaseline():*
		{
			return _format ? _format.dominantBaseline : undefined;
		}
		public function set dominantBaseline(dominantBaselineValue:*):void
		{
			writableTextLayoutFormat().dominantBaseline = dominantBaselineValue;
			formatChanged();
		}

		[Inspectable(enumeration="on,off,auto,inherit")]
		/**
		 * TextLayoutFormat:
		 * Kerning adjusts the pixels between certain character pairs to improve readability. Kerning is supported for all fonts with kerning tables.
		 * <p>Legal values are Kerning.ON, Kerning.OFF, Kerning.AUTO, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of Kerning.AUTO.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.text.engine.Kerning
		 */
		public function get kerning():*
		{
			return _format ? _format.kerning : undefined;
		}
		public function set kerning(kerningValue:*):void
		{
			writableTextLayoutFormat().kerning = kerningValue;
			formatChanged();
		}

		[Inspectable(enumeration="minimum,common,uncommon,exotic,inherit")]
		/**
		 * TextLayoutFormat:
		 * Controls which of the ligatures that are defined in the font may be used in the text. The ligatures that appear for each of these settings is dependent on the font. A ligature occurs where two or more letter-forms are joined as a single glyph. Ligatures usually replace consecutive characters sharing common components, such as the letter pairs 'fi', 'fl', or 'ae'. They are used with both Latin and Non-Latin character sets. The ligatures enabled by the values of the LigatureLevel class - <code>MINIMUM</code>, <code>COMMON</code>, <code>UNCOMMON</code>, and <code>EXOTIC</code> - are additive. Each value enables a new set of ligatures, but also includes those of the previous types.<p><b>Note: </b>When working with Arabic or Syriac fonts, <code>ligatureLevel</code> must be set to MINIMUM or above.</p><p><img src='../../../images/textLayout_ligatures.png' alt='ligatureLevel' /></p>
		 * <p>Legal values are LigatureLevel.MINIMUM, LigatureLevel.COMMON, LigatureLevel.UNCOMMON, LigatureLevel.EXOTIC, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of LigatureLevel.COMMON.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.text.engine.LigatureLevel
		 */
		public function get ligatureLevel():*
		{
			return _format ? _format.ligatureLevel : undefined;
		}
		public function set ligatureLevel(ligatureLevelValue:*):void
		{
			writableTextLayoutFormat().ligatureLevel = ligatureLevelValue;
			formatChanged();
		}

		[Inspectable(enumeration="roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom,useDominantBaseline,inherit")]
		/**
		 * TextLayoutFormat:
		 * Specifies the baseline to which the dominant baseline aligns. For example, if you set <code>dominantBaseline</code> to ASCENT, setting <code>alignmentBaseline</code> to DESCENT aligns the top of the text with the DESCENT baseline, or below the line.  The largest element in the line generally determines the baselines.<p><img src='../../../images/textLayout_baselines.jpg' alt='baselines' /></p>
		 * <p>Legal values are TextBaseline.ROMAN, TextBaseline.ASCENT, TextBaseline.DESCENT, TextBaseline.IDEOGRAPHIC_TOP, TextBaseline.IDEOGRAPHIC_CENTER, TextBaseline.IDEOGRAPHIC_BOTTOM, TextBaseline.USE_DOMINANT_BASELINE, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of TextBaseline.USE_DOMINANT_BASELINE.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.text.engine.TextBaseline
		 */
		public function get alignmentBaseline():*
		{
			return _format ? _format.alignmentBaseline : undefined;
		}
		public function set alignmentBaseline(alignmentBaselineValue:*):void
		{
			writableTextLayoutFormat().alignmentBaseline = alignmentBaselineValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * The locale of the text. Controls case transformations and shaping. Standard locale identifiers as described in Unicode Technical Standard #35 are used. For example en, en_US and en-US are all English, ja is Japanese. 
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of en.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get locale():*
		{
			return _format ? _format.locale : undefined;
		}
		public function set locale(localeValue:*):void
		{
			writableTextLayoutFormat().locale = localeValue;
			formatChanged();
		}

		[Inspectable(enumeration="default,capsToSmallCaps,uppercase,lowercase,lowercaseToSmallCaps,inherit")]
		/**
		 * TextLayoutFormat:
		 * The type of typographic case used for this text. Here are some examples:<p><img src='../../../images/textLayout_typographiccase.png' alt='typographicCase' /></p>
		 * <p>Legal values are TLFTypographicCase.DEFAULT, TLFTypographicCase.CAPS_TO_SMALL_CAPS, TLFTypographicCase.UPPERCASE, TLFTypographicCase.LOWERCASE, TLFTypographicCase.LOWERCASE_TO_SMALL_CAPS, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of TLFTypographicCase.DEFAULT.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.TLFTypographicCase
		 */
		public function get typographicCase():*
		{
			return _format ? _format.typographicCase : undefined;
		}
		public function set typographicCase(typographicCaseValue:*):void
		{
			writableTextLayoutFormat().typographicCase = typographicCaseValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 *  The name of the font to use, or a comma-separated list of font names. The Flash runtime renders the element with the first available font in the list. For example Arial, Helvetica, _sans causes the player to search for Arial, then Helvetica if Arial is not found, then _sans if neither is found.
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of Arial.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get fontFamily():*
		{
			return _format ? _format.fontFamily : undefined;
		}
		public function set fontFamily(fontFamilyValue:*):void
		{
			writableTextLayoutFormat().fontFamily = fontFamilyValue;
			formatChanged();
		}

		[Inspectable(enumeration="none,underline,inherit")]
		/**
		 * TextLayoutFormat:
		 * Decoration on text. Use to apply underlining; default is none.
		 * <p>Legal values are TextDecoration.NONE, TextDecoration.UNDERLINE, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of TextDecoration.NONE.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.TextDecoration
		 */
		public function get textDecoration():*
		{
			return _format ? _format.textDecoration : undefined;
		}
		public function set textDecoration(textDecorationValue:*):void
		{
			writableTextLayoutFormat().textDecoration = textDecorationValue;
			formatChanged();
		}


		/**
		 * TextLayoutFormat:
		 * Style of text.
		 * <p>Legal values style names specified byt the font.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of "Regular".</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.text.engine.FontPosture
		 */
		public function get fontStyle():*
		{
			return _format ? _format.fontStyle : undefined;
		}
		public function set fontStyle(fontStyleValue:*):void
		{
			writableTextLayoutFormat().fontStyle = fontStyleValue;
			formatChanged();
		}

		[Inspectable(enumeration="preserve,collapse,inherit")]
		/**
		 * TextLayoutFormat:
		 * Collapses or preserves whitespace when importing text into a TextFlow. <code>WhiteSpaceCollapse.PRESERVE</code> retains all whitespace characters. <code>WhiteSpaceCollapse.COLLAPSE</code> removes newlines, tabs, and leading or trailing spaces within a block of imported text. Line break tags (<br/>) and Unicode line separator characters are retained.
		 * <p>Legal values are WhiteSpaceCollapse.PRESERVE, WhiteSpaceCollapse.COLLAPSE, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of WhiteSpaceCollapse.COLLAPSE.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.WhiteSpaceCollapse
		 */
		public function get whiteSpaceCollapse():*
		{
			return _format ? _format.whiteSpaceCollapse : undefined;
		}
		public function set whiteSpaceCollapse(whiteSpaceCollapseValue:*):void
		{
			writableTextLayoutFormat().whiteSpaceCollapse = whiteSpaceCollapseValue;
			formatChanged();
		}

		[Inspectable(enumeration="normal,cff,inherit")]
		/**
		 * TextLayoutFormat:
		 * The rendering mode used for this text.  Applies only to embedded fonts (<code>fontLookup</code> property is set to <code>FontLookup.EMBEDDED_CFF</code>).
		 * <p>Legal values are RenderingMode.NORMAL, RenderingMode.CFF, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of RenderingMode.CFF.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.text.engine.RenderingMode
		 */
		public function get renderingMode():*
		{
			return _format ? _format.renderingMode : undefined;
		}
		public function set renderingMode(renderingModeValue:*):void
		{
			writableTextLayoutFormat().renderingMode = renderingModeValue;
			formatChanged();
		}

		[Inspectable(enumeration="none,horizontalStem,inherit")]
		/**
		 * TextLayoutFormat:
		 * The type of CFF hinting used for this text. CFF hinting determines whether the Flash runtime forces strong horizontal stems to fit to a sub pixel grid or not. This property applies only if the <code>renderingMode</code> property is set to <code>RenderingMode.CFF</code>, and the font is embedded (<code>fontLookup</code> property is set to <code>FontLookup.EMBEDDED_CFF</code>). At small screen sizes, hinting produces a clear, legible text for human readers.
		 * <p>Legal values are CFFHinting.NONE, CFFHinting.HORIZONTAL_STEM, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of CFFHinting.HORIZONTAL_STEM.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.text.engine.CFFHinting
		 */
		public function get cffHinting():*
		{
			return _format ? _format.cffHinting : undefined;
		}
		public function set cffHinting(cffHintingValue:*):void
		{
			writableTextLayoutFormat().cffHinting = cffHintingValue;
			formatChanged();
		}

		[Inspectable(enumeration="device,embeddedCFF,inherit")]
		/**
		 * TextLayoutFormat:
		 * Font lookup to use. Specifying <code>FontLookup.DEVICE</code> uses the fonts installed on the system that is running the SWF file. Device fonts result in a smaller movie size, but text is not always rendered the same across different systems and platforms. Specifying <code>FontLookup.EMBEDDED_CFF</code> uses font outlines embedded in the published SWF file. Embedded fonts increase the size of the SWF file (sometimes dramatically), but text is consistently displayed in the chosen font.
		 * <p>Legal values are FontLookup.DEVICE, FontLookup.EMBEDDED_CFF, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of FontLookup.DEVICE.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.text.engine.FontLookup
		 */
		public function get fontLookup():*
		{
			return _format ? _format.fontLookup : undefined;
		}
		public function set fontLookup(fontLookupValue:*):void
		{
			writableTextLayoutFormat().fontLookup = fontLookupValue;
			formatChanged();
		}

		[Inspectable(enumeration="rotate0,rotate180,rotate270,rotate90,auto,inherit")]
		/**
		 * TextLayoutFormat:
		 * Determines the number of degrees to rotate this text.
		 * <p>Legal values are TextRotation.ROTATE_0, TextRotation.ROTATE_180, TextRotation.ROTATE_270, TextRotation.ROTATE_90, TextRotation.AUTO, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of TextRotation.AUTO.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.text.engine.TextRotation
		 */
		public function get textRotation():*
		{
			return _format ? _format.textRotation : undefined;
		}
		public function set textRotation(textRotationValue:*):void
		{
			writableTextLayoutFormat().textRotation = textRotationValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * A Number that specifies, in pixels, the amount to indent the first line of the paragraph.
		 * A negative indent will push the line into the margin, and possibly out of the container.
		 * <p>Legal values are numbers from -8000 to 8000 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get textIndent():*
		{
			return _format ? _format.textIndent : undefined;
		}
		public function set textIndent(textIndentValue:*):void
		{
			writableTextLayoutFormat().textIndent = textIndentValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * A Number that specifies, in pixels, the amount to indent the paragraph's start edge. Refers to the left edge in left-to-right text and the right edge in right-to-left text. 
		 * <p>Legal values are numbers from 0 to 8000 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get paragraphStartIndent():*
		{
			return _format ? _format.paragraphStartIndent : undefined;
		}
		public function set paragraphStartIndent(paragraphStartIndentValue:*):void
		{
			writableTextLayoutFormat().paragraphStartIndent = paragraphStartIndentValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * A Number that specifies, in pixels, the amount to indent the paragraph's end edge. Refers to the right edge in left-to-right text and the left edge in right-to-left text. 
		 * <p>Legal values are numbers from 0 to 8000 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get paragraphEndIndent():*
		{
			return _format ? _format.paragraphEndIndent : undefined;
		}
		public function set paragraphEndIndent(paragraphEndIndentValue:*):void
		{
			writableTextLayoutFormat().paragraphEndIndent = paragraphEndIndentValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * A Number that specifies the amount of space, in pixels, to leave before the paragraph. 
		 * Collapses in tandem with <code>paragraphSpaceAfter</code>.
		 * <p>Legal values are numbers from 0 to 8000 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get paragraphSpaceBefore():*
		{
			return _format ? _format.paragraphSpaceBefore : undefined;
		}
		public function set paragraphSpaceBefore(paragraphSpaceBeforeValue:*):void
		{
			writableTextLayoutFormat().paragraphSpaceBefore = paragraphSpaceBeforeValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * A Number that specifies the amount of space, in pixels, to leave after the paragraph.
		 * Collapses in tandem with  <code>paragraphSpaceBefore</code>.
		 * <p>Legal values are numbers from 0 to 8000 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get paragraphSpaceAfter():*
		{
			return _format ? _format.paragraphSpaceAfter : undefined;
		}
		public function set paragraphSpaceAfter(paragraphSpaceAfterValue:*):void
		{
			writableTextLayoutFormat().paragraphSpaceAfter = paragraphSpaceAfterValue;
			formatChanged();
		}

		[Inspectable(enumeration="left,right,center,justify,start,end,inherit")]
		/**
		 * TextLayoutFormat:
		 * Alignment of lines in the paragraph relative to the container.
		 * <code>TextAlign.LEFT</code> aligns lines along the left edge of the container. <code>TextAlign.RIGHT</code> aligns on the right edge. <code>TextAlign.CENTER</code> positions the line equidistant from the left and right edges. <code>TextAlign.JUSTIFY</code> spreads the lines out so they fill the space. <code>TextAlign.START</code> is equivalent to setting left in left-to-right text, or right in right-to-left text. <code>TextAlign.END</code> is equivalent to setting right in left-to-right text, or left in right-to-left text.
		 * <p>Legal values are TextAlign.LEFT, TextAlign.RIGHT, TextAlign.CENTER, TextAlign.JUSTIFY, TextAlign.START, TextAlign.END, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of TextAlign.START.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.TextAlign
		 */
		public function get textAlign():*
		{
			return _format ? _format.textAlign : undefined;
		}
		public function set textAlign(textAlignValue:*):void
		{
			writableTextLayoutFormat().textAlign = textAlignValue;
			formatChanged();
		}

		[Inspectable(enumeration="left,right,center,justify,start,end,inherit")]
		/**
		 * TextLayoutFormat:
		 * Alignment of the last (or only) line in the paragraph relative to the container in justified text.
		 * If <code>textAlign</code> is set to <code>TextAlign.JUSTIFY</code>, <code>textAlignLast</code> specifies how the last line (or only line, if this is a one line block) is aligned. Values are similar to <code>textAlign</code>.
		 * <p>Legal values are TextAlign.LEFT, TextAlign.RIGHT, TextAlign.CENTER, TextAlign.JUSTIFY, TextAlign.START, TextAlign.END, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of TextAlign.START.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.TextAlign
		 */
		public function get textAlignLast():*
		{
			return _format ? _format.textAlignLast : undefined;
		}
		public function set textAlignLast(textAlignLastValue:*):void
		{
			writableTextLayoutFormat().textAlignLast = textAlignLastValue;
			formatChanged();
		}

		[Inspectable(enumeration="interWord,distribute,inherit")]
		/**
		 * TextLayoutFormat:
		 * Specifies options for justifying text.
		 * Default value is <code>TextJustify.INTER_WORD</code>, meaning that extra space is added to the space characters. <code>TextJustify.DISTRIBUTE</code> adds extra space to space characters and between individual letters. Used only in conjunction with a <code>justificationRule</code> value of <code>JustificationRule.SPACE</code>.
		 * <p>Legal values are TextJustify.INTER_WORD, TextJustify.DISTRIBUTE, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of TextJustify.INTER_WORD.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.TextJustify
		 */
		public function get textJustify():*
		{
			return _format ? _format.textJustify : undefined;
		}
		public function set textJustify(textJustifyValue:*):void
		{
			writableTextLayoutFormat().textJustify = textJustifyValue;
			formatChanged();
		}

		[Inspectable(enumeration="eastAsian,space,auto,inherit")]
		/**
		 * TextLayoutFormat:
		 * Rule used to justify text in a paragraph.
		 * Default value is <code>FormatValue.AUTO</code>, which justifies text based on the paragraph's <code>locale</code> property. For all languages except Japanese and Chinese, <code>FormatValue.AUTO</code> becomes <code>JustificationRule.SPACE</code>, which adds extra space to the space characters.  For Japanese and Chinese, <code>FormatValue.AUTO</code> becomes <code>JustficationRule.EAST_ASIAN</code>. In part, justification changes the spacing of punctuation. In Roman text the comma and Japanese periods take a full character's width but in East Asian text only half of a character's width. Also, in the East Asian text the spacing between sequential punctuation marks becomes tighter, obeying traditional East Asian typographic conventions. Note, too, in the example below the leading that is applied to the second line of the paragraphs. In the East Asian version, the last two lines push left. In the Roman version, the second and following lines push left.<p><img src='../../../images/textLayout_justificationrule.png' alt='justificationRule' /></p>
		 * <p>Legal values are JustificationRule.EAST_ASIAN, JustificationRule.SPACE, FormatValue.AUTO, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of FormatValue.AUTO.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.JustificationRule
		 */
		public function get justificationRule():*
		{
			return _format ? _format.justificationRule : undefined;
		}
		public function set justificationRule(justificationRuleValue:*):void
		{
			writableTextLayoutFormat().justificationRule = justificationRuleValue;
			formatChanged();
		}

		[Inspectable(enumeration="prioritizeLeastAdjustment,pushInKinsoku,pushOutOnly,auto,inherit")]
		/**
		 * TextLayoutFormat:
		 * The style used for justification of the paragraph. Used only in conjunction with a <code>justificationRule</code> setting of <code>JustificationRule.EAST_ASIAN</code>.
		 * Default value of <code>FormatValue.AUTO</code> is resolved to <code>JustificationStyle.PUSH_IN_KINSOKU</code> for all locales.  The constants defined by the JustificationStyle class specify options for handling kinsoku characters, which are Japanese characters that cannot appear at either the beginning or end of a line. If you want looser text, specify <code>JustificationStyle.PUSH-OUT-ONLY</code>. If you want behavior that is like what you get with the  <code>justificationRule</code> of <code>JustificationRule.SPACE</code>, use <code>JustificationStyle.PRIORITIZE-LEAST-ADJUSTMENT</code>.
		 * <p>Legal values are JustificationStyle.PRIORITIZE_LEAST_ADJUSTMENT, JustificationStyle.PUSH_IN_KINSOKU, JustificationStyle.PUSH_OUT_ONLY, FormatValue.AUTO, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of FormatValue.AUTO.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.text.engine.JustificationStyle
		 */
		public function get justificationStyle():*
		{
			return _format ? _format.justificationStyle : undefined;
		}
		public function set justificationStyle(justificationStyleValue:*):void
		{
			writableTextLayoutFormat().justificationStyle = justificationStyleValue;
			formatChanged();
		}

		[Inspectable(enumeration="ltr,rtl,inherit")]
		/**
		 * TextLayoutFormat:
		 * Specifies the default bidirectional embedding level of the text in the text block. 
		 * Left-to-right reading order, as in Latin-style scripts, or right-to-left reading order, as in Arabic or Hebrew. This property also affects column direction when it is applied at the container level. Columns can be either left-to-right or right-to-left, just like text. Below are some examples:<p><img src='../../../images/textLayout_direction.gif' alt='direction' /></p>
		 * <p>Legal values are Direction.LTR, Direction.RTL, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of Direction.LTR.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.Direction
		 */
		public function get direction():*
		{
			return _format ? _format.direction : undefined;
		}
		public function set direction(directionValue:*):void
		{
			writableTextLayoutFormat().direction = directionValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Specifies the optimum, minimum, and maximum spacing (as a multiplier of the width of a normal space) between words to use during justification.
		 * The optimum space is used to indicate the desired size of a space, as a fraction of the value defined in the font. The minimum and maximum values are the used when textJustify is distribute to determine how wide or narrow the spaces between the words may grow before letter spacing is used to justify the line.
		 * <p>Legal values as a percent are numbers from -1000% to 1000%.</p>
		 * <p>Legal values include FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 100%, 50%, 150%.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get wordSpacing():*
		{
			return _format ? _format.wordSpacing : undefined;
		}
		public function set wordSpacing(wordSpacingValue:*):void
		{
			writableTextLayoutFormat().wordSpacing = wordSpacingValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Specifies the tab stops associated with the paragraph.
		 * Setters can take an array of TabStopFormat, a condensed string representation, undefined, or <code>FormatValue.INHERIT</code>. The condensed string representation is always converted into an array of TabStopFormat. <p>The string-based format is a list of tab stops, where each tab stop is delimited by one or more spaces.</p><p>A tab stop takes the following form: &lt;alignment type&gt;&lt;alignment position&gt;|&lt;alignment token&gt;.</p><p>The alignment type is a single character, and can be S, E, C, or D (or lower-case equivalents). S or s for start, E or e for end, C or c for center, D or d for decimal. The alignment type is optional, and if its not specified will default to S.</p><p>The alignment position is a Number, and is specified according to FXG spec for Numbers (decimal or scientific notation). The alignment position is required.</p><p>The vertical bar is used to separate the alignment position from the alignment token, and should only be present if the alignment token is present.</p><p> The alignment token is optional if the alignment type is D, and should not be present if the alignment type is anything other than D. The alignment token may be any sequence of characters terminated by the space that ends the tab stop (for the last tab stop, the terminating space is optional; end of alignment token is implied). A space may be part of the alignment token if it is escaped with a backslash (\ ). A backslash may be part of the alignment token if it is escaped with another backslash (\\). If the alignment type is D, and the alignment token is not specified, it will take on the default value of null.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of null.</p>
		 * @see org.apache.royale.textLayout.formats.TabStopFormat
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get tabStops():*
		{
			return _format ? _format.tabStops : undefined;
		}
		public function set tabStops(tabStopsValue:*):void
		{
			writableTextLayoutFormat().tabStops = tabStopsValue;
			formatChanged();
		}

		[Inspectable(enumeration="romanUp,ideographicTopUp,ideographicCenterUp,ideographicTopDown,ideographicCenterDown,approximateTextField,ascentDescentUp,box,auto,inherit")]
		/**
		 * TextLayoutFormat:
		 * Specifies the leading model, which is a combination of leading basis and leading direction.
		 * Leading basis is the baseline to which the <code>lineHeight</code> property refers. Leading direction determines whether the <code>lineHeight</code> property refers to the distance of a line's baseline from that of the line before it or the line after it. The default value of <code>FormatValue.AUTO</code> is resolved based on the paragraph's <code>locale</code> property.  For Japanese and Chinese, it is <code>LeadingModel.IDEOGRAPHIC_TOP_DOWN</code> and for all others it is <code>LeadingModel.ROMAN_UP</code>.<p><strong>Leading Basis:</strong></p><p><img src='../../../images/textLayout_LB1.png' alt='leadingBasis1' />    <img src='../../../images/textLayout_LB2.png' alt='leadingBasis2' />    <img src='../../../images/textLayout_LB3.png' alt='leadingBasis3' /></p><p><strong>Leading Direction:</strong></p><p><img src='../../../images/textLayout_LD1.png' alt='leadingDirection1' />    <img src='../../../images/textLayout_LD2.png' alt='leadingDirection2' />    <img src='../../../images/textLayout_LD3.png' alt='leadingDirection3' /></p>
		 * <p>Legal values are LeadingModel.ROMAN_UP, LeadingModel.IDEOGRAPHIC_TOP_UP, LeadingModel.IDEOGRAPHIC_CENTER_UP, LeadingModel.IDEOGRAPHIC_TOP_DOWN, LeadingModel.IDEOGRAPHIC_CENTER_DOWN, LeadingModel.APPROXIMATE_TEXT_FIELD, LeadingModel.ASCENT_DESCENT_UP, LeadingModel.BOX, LeadingModel.AUTO, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of LeadingModel.AUTO.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.LeadingModel
		 */
		public function get leadingModel():*
		{
			return _format ? _format.leadingModel : undefined;
		}
		public function set leadingModel(leadingModelValue:*):void
		{
			writableTextLayoutFormat().leadingModel = leadingModelValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Specifies the amount of gutter space, in pixels, to leave between the columns (adopts default value if undefined during cascade).
		 * Value is a Number
		 * <p>Legal values are numbers from 0 to 1000 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of 20.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get columnGap():*
		{
			return _format ? _format.columnGap : undefined;
		}
		public function set columnGap(columnGapValue:*):void
		{
			writableTextLayoutFormat().columnGap = columnGapValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Left inset in pixels.  Default of auto is zero except in lists which get a start side padding of 45. (adopts default value if undefined during cascade).
		 * Space between the left edge of the container and the text.  Value is a Number or auto.<p> With vertical text, in scrollable containers with multiple columns, the first and following columns will show the padding as blank space at the end of the container, but for the last column, if the text doesn't all fit, you may have to scroll in order to see the padding.</p>
		 * <p>Legal values as a string are FormatValue.AUTO, FormatValue.INHERIT and numbers from -8000 to 8000.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of FormatValue.AUTO.</p>
		 * @see org.apache.royale.textLayout.elements.Configuration#autoListElementStartPadding
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.FormatValue
		 */
		public function get paddingLeft():*
		{
			return _format ? _format.paddingLeft : undefined;
		}
		public function set paddingLeft(paddingLeftValue:*):void
		{
			writableTextLayoutFormat().paddingLeft = paddingLeftValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Top inset in pixels.  Default of auto is zero except in lists which get a start side padding of 45. (adopts default value if undefined during cascade).
		 * Space between the top edge of the container and the text.  Value is a Number or auto.
		 * <p>Legal values as a string are FormatValue.AUTO, FormatValue.INHERIT and numbers from -8000 to 8000.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of FormatValue.AUTO.</p>
		 * @see org.apache.royale.textLayout.elements.Configuration#autoListElementStartPadding
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.FormatValue
		 */
		public function get paddingTop():*
		{
			return _format ? _format.paddingTop : undefined;
		}
		public function set paddingTop(paddingTopValue:*):void
		{
			writableTextLayoutFormat().paddingTop = paddingTopValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Right inset in pixels.  Default of auto is zero except in lists which get a start side padding of 45. (adopts default value if undefined during cascade).
		 * Space between the right edge of the container and the text.  Value is a Number or auto. 
		 * <p>Legal values as a string are FormatValue.AUTO, FormatValue.INHERIT and numbers from -8000 to 8000.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of FormatValue.AUTO.</p>
		 * @see org.apache.royale.textLayout.elements.Configuration#autoListElementStartPadding
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.FormatValue
		 */
		public function get paddingRight():*
		{
			return _format ? _format.paddingRight : undefined;
		}
		public function set paddingRight(paddingRightValue:*):void
		{
			writableTextLayoutFormat().paddingRight = paddingRightValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Bottom inset in pixels.  Default of auto is zero except in lists which get a start side padding of 45.  (adopts default value if undefined during cascade).
		 * Space between the bottom edge of the container and the text.  Value is a Number  or auto. <p> With horizontal text, in scrollable containers with multiple columns, the first and following columns will show the padding as blank space at the bottom of the container, but for the last column, if the text doesn't all fit, you may have to scroll in order to see the padding.</p>
		 * <p>Legal values as a string are FormatValue.AUTO, FormatValue.INHERIT and numbers from -8000 to 8000.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of FormatValue.AUTO.</p>
		 * @see org.apache.royale.textLayout.elements.Configuration#autoListElementStartPadding
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.FormatValue
		 */
		public function get paddingBottom():*
		{
			return _format ? _format.paddingBottom : undefined;
		}
		public function set paddingBottom(paddingBottomValue:*):void
		{
			writableTextLayoutFormat().paddingBottom = paddingBottomValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Number of text columns (adopts default value if undefined during cascade).
		 * The column number overrides the  other column settings. Value is an integer, or <code>FormatValue.AUTO</code> if unspecified. If <code>columnCount</code> is not specified,<code>columnWidth</code> is used to create as many columns as can fit in the container.
		 * <p>Legal values as a string are FormatValue.AUTO, FormatValue.INHERIT and from ints from 1 to 50.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of FormatValue.AUTO.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.FormatValue
		 */
		public function get columnCount():*
		{
			return _format ? _format.columnCount : undefined;
		}
		public function set columnCount(columnCountValue:*):void
		{
			writableTextLayoutFormat().columnCount = columnCountValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Column width in pixels (adopts default value if undefined during cascade).
		 * If you specify the width of the columns, but not the count, TextLayout will create as many columns of that width as possible, given the  container width and <code>columnGap</code> settings. Any remainder space is left after the last column. Value is a Number.
		 * <p>Legal values as a string are FormatValue.AUTO, FormatValue.INHERIT and numbers from 0 to 8000.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of FormatValue.AUTO.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.FormatValue
		 */
		public function get columnWidth():*
		{
			return _format ? _format.columnWidth : undefined;
		}
		public function set columnWidth(columnWidthValue:*):void
		{
			writableTextLayoutFormat().columnWidth = columnWidthValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Specifies the baseline position of the first line in the container. Which baseline this property refers to depends on the container-level locale.  For Japanese and Chinese, it is <code>TextBaseline.IDEOGRAPHIC_BOTTOM</code>; for all others it is <code>TextBaseline.ROMAN</code>.
		 * The offset from the top inset (or right inset if <code>blockProgression</code> is RL) of the container to the baseline of the first line can be either <code>BaselineOffset.ASCENT</code>, meaning equal to the ascent of the line, <code>BaselineOffset.LINE_HEIGHT</code>, meaning equal to the height of that first line, or any fixed-value number to specify an absolute distance. <code>BaselineOffset.AUTO</code> aligns the ascent of the line with the container top inset.<p><img src='../../../images/textLayout_FBO1.png' alt='firstBaselineOffset1' /><img src='../../../images/textLayout_FBO2.png' alt='firstBaselineOffset2' /><img src='../../../images/textLayout_FBO3.png' alt='firstBaselineOffset3' /><img src='../../../images/textLayout_FBO4.png' alt='firstBaselineOffset4' /></p>
		 * <p>Legal values as a string are BaselineOffset.AUTO, BaselineOffset.ASCENT, BaselineOffset.LINE_HEIGHT, FormatValue.INHERIT and numbers from 0 to 1000.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of BaselineOffset.AUTO.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.BaselineOffset
		 */
		public function get firstBaselineOffset():*
		{
			return _format ? _format.firstBaselineOffset : undefined;
		}
		public function set firstBaselineOffset(firstBaselineOffsetValue:*):void
		{
			writableTextLayoutFormat().firstBaselineOffset = firstBaselineOffsetValue;
			formatChanged();
		}

		[Inspectable(enumeration="top,middle,bottom,justify,inherit")]
		/**
		 * TextLayoutFormat:
		 * Vertical alignment or justification (adopts default value if undefined during cascade).
		 * Determines how TextFlow elements align within the container.
		 * <p>Legal values are VerticalAlign.TOP, VerticalAlign.MIDDLE, VerticalAlign.BOTTOM, VerticalAlign.JUSTIFY, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of VerticalAlign.TOP.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.VerticalAlign
		 */
		public function get verticalAlign():*
		{
			return _format ? _format.verticalAlign : undefined;
		}
		public function set verticalAlign(verticalAlignValue:*):void
		{
			writableTextLayoutFormat().verticalAlign = verticalAlignValue;
			formatChanged();
		}

		[Inspectable(enumeration="rl,tb,inherit")]
		/**
		 * TextLayoutFormat:
		 * Specifies a vertical or horizontal progression of line placement.
		 * Lines are either placed top-to-bottom (<code>BlockProgression.TB</code>, used for horizontal text) or right-to-left (<code>BlockProgression.RL</code>, used for vertical text).
		 * <p>Legal values are BlockProgression.RL, BlockProgression.TB, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of BlockProgression.TB.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.BlockProgression
		 */
		public function get blockProgression():*
		{
			return _format ? _format.blockProgression : undefined;
		}
		public function set blockProgression(blockProgressionValue:*):void
		{
			writableTextLayoutFormat().blockProgression = blockProgressionValue;
			formatChanged();
		}

		[Inspectable(enumeration="explicit,toFit,inherit")]
		/**
		 * TextLayoutFormat:
		 * Controls word wrapping within the container (adopts default value if undefined during cascade).
		 * Text in the container may be set to fit the width of the container (<code>LineBreak.TO_FIT</code>), or can be set to break only at explicit return or line feed characters (<code>LineBreak.EXPLICIT</code>).
		 * <p>Legal values are LineBreak.EXPLICIT, LineBreak.TO_FIT, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of LineBreak.TO_FIT.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.LineBreak
		 */
		public function get lineBreak():*
		{
			return _format ? _format.lineBreak : undefined;
		}
		public function set lineBreak(lineBreakValue:*):void
		{
			writableTextLayoutFormat().lineBreak = lineBreakValue;
			formatChanged();
		}

		[Inspectable(enumeration="upperAlpha,lowerAlpha,upperRoman,lowerRoman,none,disc,circle,square,box,check,diamond,hyphen,arabicIndic,bengali,decimal,decimalLeadingZero,devanagari,gujarati,gurmukhi,kannada,persian,thai,urdu,cjkEarthlyBranch,cjkHeavenlyStem,hangul,hangulConstant,hiragana,hiraganaIroha,katakana,katakanaIroha,lowerAlpha,lowerGreek,lowerLatin,upperAlpha,upperGreek,upperLatin,inherit")]
		/**
		 * TextLayoutFormat:
		 * <p>Legal values are ListStyleType.UPPER_ALPHA, ListStyleType.LOWER_ALPHA, ListStyleType.UPPER_ROMAN, ListStyleType.LOWER_ROMAN, ListStyleType.NONE, ListStyleType.DISC, ListStyleType.CIRCLE, ListStyleType.SQUARE, ListStyleType.BOX, ListStyleType.CHECK, ListStyleType.DIAMOND, ListStyleType.HYPHEN, ListStyleType.ARABIC_INDIC, ListStyleType.BENGALI, ListStyleType.DECIMAL, ListStyleType.DECIMAL_LEADING_ZERO, ListStyleType.DEVANAGARI, ListStyleType.GUJARATI, ListStyleType.GURMUKHI, ListStyleType.KANNADA, ListStyleType.PERSIAN, ListStyleType.THAI, ListStyleType.URDU, ListStyleType.CJK_EARTHLY_BRANCH, ListStyleType.CJK_HEAVENLY_STEM, ListStyleType.HANGUL, ListStyleType.HANGUL_CONSTANT, ListStyleType.HIRAGANA, ListStyleType.HIRAGANA_IROHA, ListStyleType.KATAKANA, ListStyleType.KATAKANA_IROHA, ListStyleType.LOWER_ALPHA, ListStyleType.LOWER_GREEK, ListStyleType.LOWER_LATIN, ListStyleType.UPPER_ALPHA, ListStyleType.UPPER_GREEK, ListStyleType.UPPER_LATIN, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of ListStyleType.DISC.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.ListStyleType
		 */
		public function get listStyleType():*
		{
			return _format ? _format.listStyleType : undefined;
		}
		public function set listStyleType(listStyleTypeValue:*):void
		{
			writableTextLayoutFormat().listStyleType = listStyleTypeValue;
			formatChanged();
		}

		[Inspectable(enumeration="inside,outside,inherit")]
		/**
		 * TextLayoutFormat:
		 * <p>Legal values are ListStylePosition.INSIDE, ListStylePosition.OUTSIDE, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of ListStylePosition.OUTSIDE.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.ListStylePosition
		 */
		public function get listStylePosition():*
		{
			return _format ? _format.listStylePosition : undefined;
		}
		public function set listStylePosition(listStylePositionValue:*):void
		{
			writableTextLayoutFormat().listStylePosition = listStylePositionValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * This specifies an auto indent for the start edge of lists when the padding value of the list on that side is <code>auto</code>.
		 * <p>Legal values are numbers from -1000 to 1000 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 40.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get listAutoPadding():*
		{
			return _format ? _format.listAutoPadding : undefined;
		}
		public function set listAutoPadding(listAutoPaddingValue:*):void
		{
			writableTextLayoutFormat().listAutoPadding = listAutoPaddingValue;
			formatChanged();
		}

		[Inspectable(enumeration="start,end,left,right,both,none,inherit")]
		/**
		 * TextLayoutFormat:
		 * Controls how text wraps around a float. A value of none allows the text to wrap most closely around a float. A value of left causes the text to skip over any portion of the container that has a left float, and a value of right causes the text to skip over any portion of the container that has a right float. A value of both causes the text to skip over any floats.
		 * <p>Legal values are ClearFloats.START, ClearFloats.END, ClearFloats.LEFT, ClearFloats.RIGHT, ClearFloats.BOTH, ClearFloats.NONE, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of ClearFloats.NONE.</p>
		 * @see org.apache.royale.textLayout.formats.ClearFloats
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.ClearFloats
		 */
		public function get clearFloats():*
		{
			return _format ? _format.clearFloats : undefined;
		}
		public function set clearFloats(clearFloatsValue:*):void
		{
			writableTextLayoutFormat().clearFloats = clearFloatsValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Assigns an identifying class to the element, making it possible to set a style for the element by referencing the <code>styleName</code>.
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of null.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get styleName():*
		{
			return _format ? _format.styleName : undefined;
		}
		public function set styleName(styleNameValue:*):void
		{
			writableTextLayoutFormat().styleName = styleNameValue;
			styleSelectorChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Defines the formatting attributes used for links in normal state. This value will cascade down the hierarchy and apply to any links that are descendants.
		 * Accepts <code>inherit</code>, an <code>ITextLayoutFormat</code> or converts an array of objects with key and value as members to a TextLayoutFormat.
		 * <p>Legal values include FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of null.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get linkNormalFormat():*
		{
			return _format ? _format.linkNormalFormat : undefined;
		}
		public function set linkNormalFormat(linkNormalFormatValue:*):void
		{
			writableTextLayoutFormat().linkNormalFormat = linkNormalFormatValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Defines the formatting attributes used for links in normal state. This value will cascade down the hierarchy and apply to any links that are descendants.
		 * Accepts <code>inherit</code>, an <code>ITextLayoutFormat</code> or converts an array of objects with key and value as members to a TextLayoutFormat.
		 * <p>Legal values include FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of null.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get linkActiveFormat():*
		{
			return _format ? _format.linkActiveFormat : undefined;
		}
		public function set linkActiveFormat(linkActiveFormatValue:*):void
		{
			writableTextLayoutFormat().linkActiveFormat = linkActiveFormatValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Defines the formatting attributes used for links in hover state, when the mouse is within the bounds (rolling over) a link. This value will cascade down the hierarchy and apply to any links that are descendants.
		 * Accepts <code>inherit</code>, an <code>ITextLayoutFormat</code> or converts an array of objects with key and value as members to a TextLayoutFormat.
		 * <p>Legal values include FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of null.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get linkHoverFormat():*
		{
			return _format ? _format.linkHoverFormat : undefined;
		}
		public function set linkHoverFormat(linkHoverFormatValue:*):void
		{
			writableTextLayoutFormat().linkHoverFormat = linkHoverFormatValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Defines the formatting attributes list markers. This value will cascade down the hierarchy and apply to any links that are descendants.
		 * Accepts <code>inherit</code>, an <code>IListMarkerFormat</code> or converts an array of objects with key and value as members to a ListMarkerFormat.
		 * <p>Legal values include FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of null.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get listMarkerFormat():*
		{
			return _format ? _format.listMarkerFormat : undefined;
		}
		public function set listMarkerFormat(listMarkerFormatValue:*):void
		{
			writableTextLayoutFormat().listMarkerFormat = listMarkerFormatValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Left border width in pixels (adopts default value if undefined during cascade)
		 * <p>Legal values are numbers from 0 to 128 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get borderLeftWidth():*
		{
			return _format ? _format.borderLeftWidth : undefined;
		}
		public function set borderLeftWidth(borderLeftWidthValue:*):void
		{
			writableTextLayoutFormat().borderLeftWidth = borderLeftWidthValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Right border width in pixels (adopts default value if undefined during cascade)
		 * <p>Legal values are numbers from 0 to 128 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get borderRightWidth():*
		{
			return _format ? _format.borderRightWidth : undefined;
		}
		public function set borderRightWidth(borderRightWidthValue:*):void
		{
			writableTextLayoutFormat().borderRightWidth = borderRightWidthValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Top border width in pixels (adopts default value if undefined during cascade)
		 * <p>Legal values are numbers from 0 to 128 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get borderTopWidth():*
		{
			return _format ? _format.borderTopWidth : undefined;
		}
		public function set borderTopWidth(borderTopWidthValue:*):void
		{
			writableTextLayoutFormat().borderTopWidth = borderTopWidthValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Bottom border width in pixels (adopts default value if undefined during cascade)
		 * <p>Legal values are numbers from 0 to 128 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get borderBottomWidth():*
		{
			return _format ? _format.borderBottomWidth : undefined;
		}
		public function set borderBottomWidth(borderBottomWidthValue:*):void
		{
			writableTextLayoutFormat().borderBottomWidth = borderBottomWidthValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Color of the left border (adopts default value if undefined during cascade). Can be either the constant value <code>BorderColor.TRANSPARENT</code>, or a hexadecimal value that specifies the three 8-bit RGB (red, green, blue) values; for example, 0xFF0000 is red and 0x00FF00 is green.
		 * <p>Legal values as a string are BorderColor.TRANSPARENT, FormatValue.INHERIT and uints from 0x0 to 0xffffffff.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of BorderColor.TRANSPARENT.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.BorderColor
		 */
		public function get borderLeftColor():*
		{
			return _format ? _format.borderLeftColor : undefined;
		}
		public function set borderLeftColor(borderLeftColorValue:*):void
		{
			writableTextLayoutFormat().borderLeftColor = borderLeftColorValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Color of the right border (adopts default value if undefined during cascade). Can be either the constant value <code>BorderColor.TRANSPARENT</code>, or a hexadecimal value that specifies the three 8-bit RGB (red, green, blue) values; for example, 0xFF0000 is red and 0x00FF00 is green.
		 * <p>Legal values as a string are BorderColor.TRANSPARENT, FormatValue.INHERIT and uints from 0x0 to 0xffffffff.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of BorderColor.TRANSPARENT.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.BorderColor
		 */
		public function get borderRightColor():*
		{
			return _format ? _format.borderRightColor : undefined;
		}
		public function set borderRightColor(borderRightColorValue:*):void
		{
			writableTextLayoutFormat().borderRightColor = borderRightColorValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Color of the top border (adopts default value if undefined during cascade). Can be either the constant value <code>BorderColor.TRANSPARENT</code>, or a hexadecimal value that specifies the three 8-bit RGB (red, green, blue) values; for example, 0xFF0000 is red and 0x00FF00 is green.
		 * <p>Legal values as a string are BorderColor.TRANSPARENT, FormatValue.INHERIT and uints from 0x0 to 0xffffffff.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of BorderColor.TRANSPARENT.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.BorderColor
		 */
		public function get borderTopColor():*
		{
			return _format ? _format.borderTopColor : undefined;
		}
		public function set borderTopColor(borderTopColorValue:*):void
		{
			writableTextLayoutFormat().borderTopColor = borderTopColorValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Color of the bottom border (adopts default value if undefined during cascade). Can be either the constant value <code>BorderColor.TRANSPARENT</code>, or a hexadecimal value that specifies the three 8-bit RGB (red, green, blue) values; for example, 0xFF0000 is red and 0x00FF00 is green.
		 * <p>Legal values as a string are BorderColor.TRANSPARENT, FormatValue.INHERIT and uints from 0x0 to 0xffffffff.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of BorderColor.TRANSPARENT.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.BorderColor
		 */
		public function get borderBottomColor():*
		{
			return _format ? _format.borderBottomColor : undefined;
		}
		public function set borderBottomColor(borderBottomColorValue:*):void
		{
			writableTextLayoutFormat().borderBottomColor = borderBottomColorValue;
			formatChanged();
		}

		/**
 		* TextLayoutFormat:
 		* Specifies the priority when drawing cell boundaries. When settings between two adjacent cells conflict, the border with the higher priority wins. If the priorities are equal, the latter of the two cells takes priority.
 		* <p>Legal values are any rational number. Conflicts are resolved with the properties of the higher number being drawn.</p>
 		* <p>Default value is undefined indicating not set.</p>
 		* <p>If undefined during the cascade this property will inherit, and default to 0.</p>
 		* 
 		* @throws RangeError when set value is not within range for this property
 		* 
 		* @playerversion Flash 10
 		* @playerversion AIR 1.5
 		* @langversion 3.0
 		*/
		public function get borderLeftPriority():*
		{
			return _format ? _format.borderLeftPriority : undefined;
		}
		public function set borderLeftPriority(value:*):void
		{ 
			writableTextLayoutFormat().borderLeftPriority = value;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Specifies the priority when drawing cell boundaries. When settings between two adjacent cells conflict, the border with the higher priority wins. If the priorities are equal, the latter of the two cells takes priority.
		 * <p>Legal values are any rational number. Conflicts are resolved with the properties of the higher number being drawn.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit, and default to 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get borderRightPriority():*
		{
			return  _format ? _format.borderRightPriority : undefined;
		}
		public function set borderRightPriority(value:*):void
		{
			writableTextLayoutFormat().borderRightPriority = value;
			formatChanged();
		}
		
		/**
		 * TextLayoutFormat:
		 * Specifies the priority when drawing cell boundaries. When settings between two adjacent cells conflict, the border with the higher priority wins. If the priorities are equal, the latter of the two cells takes priority.
		 * <p>Legal values are any rational number. Conflicts are resolved with the properties of the higher number being drawn.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit, and default to 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get borderTopPriority():*
		{
			return  _format ? _format.borderTopPriority : undefined;
		}
		public function set borderTopPriority(value:*):void
		{
			writableTextLayoutFormat().borderTopPriority = value;
			formatChanged();
		}
		
		/**
		 * TextLayoutFormat:
		 * Specifies the priority when drawing cell boundaries. When settings between two adjacent cells conflict, the border with the higher priority wins. If the priorities are equal, the latter of the two cells takes priority.
		 * <p>Legal values are any rational number. Conflicts are resolved with the properties of the higher number being drawn.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit, and default to 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get borderBottomPriority():*
		{
			return  _format ? _format.borderBottomPriority : undefined;
		}
		public function set borderBottomPriority(value:*):void
		{
			writableTextLayoutFormat().borderBottomPriority = value;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * left margin in pixels(adopts default value if undefined during cascade).
		 * <p>Legal values are numbers from -8000 to 8000 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */

		public function get marginLeft():*
		{
			return _format ? _format.marginLeft : undefined;
		}
		public function set marginLeft(marginLeftValue:*):void
		{
			writableTextLayoutFormat().marginLeft = marginLeftValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * right margin in pixels (adopts default value if undefined during cascade).
		 * <p>Legal values are numbers from -8000 to 8000 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get marginRight():*
		{
			return _format ? _format.marginRight : undefined;
		}
		public function set marginRight(marginRightValue:*):void
		{
			writableTextLayoutFormat().marginRight = marginRightValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * top margin in pixels (adopts default value if undefined during cascade).
		 * <p>Legal values are numbers from -8000 to 8000 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get marginTop():*
		{
			return _format ? _format.marginTop : undefined;
		}
		public function set marginTop(marginTopValue:*):void
		{
			writableTextLayoutFormat().marginTop = marginTopValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * bottom margin in pixels (adopts default value if undefined during cascade).
		 * <p>Legal values are numbers from -8000 to 8000 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get marginBottom():*
		{
			return _format ? _format.marginBottom : undefined;
		}
		public function set marginBottom(marginBottomValue:*):void
		{
			writableTextLayoutFormat().marginBottom = marginBottomValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * cellSpacing specifies how much space the user agent should leave between the left side of the table and the left-hand side of the leftmost column, the top of the table and the top side of the topmost row, and so on for the right and bottom of the table. The attribute also specifies the amount of space to leave between cells.
		 * <p>Legal values are numbers from 0 to 1000 and FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get cellSpacing():*
		{
			return _format ? _format.cellSpacing : undefined;
		}
		public function set cellSpacing(cellSpacingValue:*):void
		{
			writableTextLayoutFormat().cellSpacing = cellSpacingValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * cellPadding specifies the amount of space between the border of the cell and its contents. If the value of this attribute is a pixel length, all four margins should be this distance from the contents. If the value of the attribute is a percentage length, the top and bottom margins should be equally separated from the content based on a percentage of the available vertical space, and the left and right margins should be equally separated from the content based on a percentage of the available horizontal space.
		 * <p>Legal values as a number are from 0 to 1000.</p>
		 * <p>Legal values as a percent are numbers from 0% to 100%.</p>
		 * <p>Legal values include FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get cellPadding():*
		{
			return _format ? _format.cellPadding : undefined;
		}
		public function set cellPadding(cellPaddingValue:*):void
		{
			writableTextLayoutFormat().cellPadding = cellPaddingValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Width of table element specifies the desired width of the entire table and is intended for visual user agents. When the value is a percentage value, the value is relative to the user agent's available horizontal space.
		 * <p>Legal values as a number are from 0 to 8000.</p>
		 * <p>Legal values as a percent are numbers from 0% to 100%.</p>
		 * <p>Legal values include FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of 100%.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get tableWidth():*
		{
			return _format ? _format.tableWidth : undefined;
		}
		public function set tableWidth(tableWidthValue:*):void
		{
			writableTextLayoutFormat().tableWidth = tableWidthValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Width of table column specifies a default width for each column spanned by the current COL element.
		 * <p>Legal values as a number are from 0 to 8000.</p>
		 * <p>Legal values as a percent are numbers from 0% to 100%.</p>
		 * <p>Legal values include FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of 0.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get tableColumnWidth():*
		{
			return _format ? _format.tableColumnWidth : undefined;
		}
		public function set tableColumnWidth(tableColumnWidthValue:*):void
		{
			writableTextLayoutFormat().tableColumnWidth = tableColumnWidthValue;
			formatChanged();
		}

		/**
		 * TextLayoutFormat:
		 * Minimum height of a table cell. If there is no maximum, the cell will grow in height to fit the content. Minimum and maximum of the same values will give the cell a fixed height.
		 * <p>Legal values as a number are from 2 to 10000.</p>
		 * <p>Legal values include FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of 2.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get minCellHeight():*
		{
			return _format ? _format.minCellHeight : undefined;
		}
		public function set minCellHeight(value:*):void
		{
			writableTextLayoutFormat().minCellHeight = value;
			formatChanged();
		}
		
		/**
		 * TextLayoutFormat:
		 * Maximum height of a table cell. If there is no maximum, the cell will grow in height to fit the content. Minimum and maximum of the same values will give the cell a fixed height.
		 * <p>Legal values as a number are from 2 to 10000.</p>
		 * <p>Legal values include FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of 2.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get maxCellHeight():*
		{
			return _format ? _format.maxCellHeight : undefined;
		}
		public function set maxCellHeight(value:*):void
		{
			writableTextLayoutFormat().maxCellHeight = value;
			formatChanged();
		}

		[Inspectable(enumeration="void,above,below,hsides,vsides,lhs,rhs,box,border,inherit")]
		/**
		 * TextLayoutFormat:
		 * frame specifies which sides of the frame surrounding a table will be visible. Possible values:
		 * <p>Legal values are TableFrame.VOID, TableFrame.ABOVE, TableFrame.BELOW, TableFrame.HSIDES, TableFrame.VSIDES, TableFrame.LHS, TableFrame.RHS, TableFrame.BOX, TableFrame.BORDER, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of TableFrame.VOID.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.TableFrame
		 */
		public function get frame():*
		{
			return _format ? _format.frame : undefined;
		}
		public function set frame(frameValue:*):void
		{
			writableTextLayoutFormat().frame = frameValue;
			formatChanged();
		}

		[Inspectable(enumeration="none,groups,rows,cols,all,inherit")]
		/**
		 * TextLayoutFormat:
		 * rules specifies which rules will appear between cells within a table. The rendering of rules is user agent dependent. Possible values:
		 * <p>Legal values are TableRules.NONE, TableRules.GROUPS, TableRules.ROWS, TableRules.COLS, TableRules.ALL, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will have a value of TableRules.NONE.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.TableRules
		 */
		public function get rules():*
		{
			return _format ? _format.rules : undefined;
		}
		public function set rules(rulesValue:*):void
		{
			writableTextLayoutFormat().rules = rulesValue;
			formatChanged();
		}
	}
}
