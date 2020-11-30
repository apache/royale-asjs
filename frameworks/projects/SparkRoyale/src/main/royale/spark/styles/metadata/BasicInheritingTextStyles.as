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

/**
 *  Specifies the baseline to which the dominant baseline aligns.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.alignmentBaseline</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#alignmentBaseline
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="alignmentBaseline", type="String", enumeration="useDominantBaseline,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom", inherit="yes")]

/**
 *  Amount to shift the baseline.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.baselineShift.</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#baselineShift
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="baselineShift", type="Object", inherit="yes")]

/**
 *  The type of CFF hinting used for this text.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.cffHinting.</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#cffHinting
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="cffHinting", type="String", enumeration="horizontalStem,none", inherit="yes")]

/**
 *  Color of the text.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.color.</b></p>
 *
 *  <p><b>For the Mobile theme, if using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField Style color,
 *  and if using StyleableStageText,
 *  see spark.components.supportClasses.StyleableStageText Style color.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#color
 *  @see spark.components.supportClasses.StyleableTextField#style:color
 *  @see spark.components.supportClasses.StyleableStageText#style:color
 *
 *  @default 0x000000
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="color", type="uint", format="Color", inherit="yes")]

/**
 *  The type of digit case used for this text.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.digitCase.</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#digitCase
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="digitCase", type="String", enumeration="default,lining,oldStyle", inherit="yes")]

/**
 *  Type of digit width used for this text.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.digitWidth.</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#digitWidth
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="digitWidth", type="String", enumeration="default,proportional,tabular", inherit="yes")]

/**
 *  Specifies the default bidirectional embedding level of the text.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.direction.</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#direction
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="direction", type="String", enumeration="ltr,rtl", inherit="yes")]

/**
 *  Specifies which element baseline snaps to the <code>alignmentBaseline</code> to
 *  determine the vertical position of the element on the line.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.dominantBaseline.</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#dominantBaseline
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="dominantBaseline", type="String", enumeration="auto,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom", inherit="yes")]

/**
 *  The name of the font to use, or a comma-separated list of font names.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.fontFamily.</b></p>
 *
 *  <p><b>For the Mobile theme, if using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField Style fontFamily,
 *  and if using StyleableStageText,
 *  see spark.components.supportClasses.StyleableStageText Style fontFamily.</b></p>
 *
 *  <p>The default value for the Spark theme is <code>Arial</code>.
 *  The default value for the Mobile theme is <code>_sans</code>.</p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#fontFamily
 *  @see spark.components.supportClasses.StyleableStageText#style:fontFamily
 *  @see spark.components.supportClasses.StyleableTextField#style:fontFamily
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="fontFamily", type="String", inherit="yes")]

/**
 *  Font lookup to use.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.fontLookup</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#fontLookup
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="fontLookup", type="String", enumeration="auto,device,embeddedCFF", inherit="yes")]

/**
 *  Height of the text, in pixels.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.fontSize</b></p>
 *
 *  <p><b>For the Mobile theme, if using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField Style fontSize,
 *  and if using StyleableStageText,
 *  see spark.components.supportClasses.StyleableStageText Style fontSize.</b></p>
 *
 *  <p>The default value for the Spark theme is <code>12</code>.
 *  The default value for the Mobile theme is <code>24</code>.</p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#fontSize
 *  @see spark.components.supportClasses.StyleableStageText#style:fontSize
 *  @see spark.components.supportClasses.StyleableTextField#style:fontSize
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="fontSize", type="Number", format="Length", inherit="yes", minValue="1.0", maxValue="720.0")]

/**
 *  Determines whether the text is italic font.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.fontStyle</b></p>
 *
 *  <p><b>For the Mobile theme, if using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField Style fontStyle,
 *  and if using StyleableStageText,
 *  see spark.components.supportClasses.StyleableStageText Style fontStyle.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#fontStyle
 *  @see spark.components.supportClasses.StyleableStageText#style:fontStyle
 *  @see spark.components.supportClasses.StyleableTextField#style:fontStyle
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="fontStyle", type="String", enumeration="normal,italic", inherit="yes")]

/**
 *  Determines whether the text is boldface.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.fontWeight</b></p>
 *
 *  <p><b>For the Mobile theme, if using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField Style fontWeight,
 *  and if using StyleableStageText,
 *  see spark.components.supportClasses.StyleableStageText Style fontWeight.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#fontWeight
 *  @see spark.components.supportClasses.StyleableStageText#style:fontWeight
 *  @see spark.components.supportClasses.StyleableTextField#style:fontWeight
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="fontWeight", type="String", enumeration="normal,bold", inherit="yes")]

/**
 *  Rule used to justify text in a paragraph.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.justificationRule</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#justificationRule
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="justificationRule", type="String", enumeration="auto,space,eastAsian", inherit="yes")]

/**
 *  The style used for justification of the paragraph.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.justificationStyle</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#justificationStyle
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="justificationStyle", type="String", enumeration="auto,prioritizeLeastAdjustment,pushInKinsoku,pushOutOnly", inherit="yes")]

/**
 *  The style used for justification of the paragraph.
 *
 *  <p>Kerning is enabled by default for Spark components, but is disabled by default for MX components.
 *  Spark components interpret <code>default</code> as <code>auto</code>,
 *  while MX components interpret <code>default</code> as <code>false</code>.</p>
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.kerning</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#kerning
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="kerning", type="String", enumeration="auto,on,off", inherit="yes")]

/**
 *  Additional vertical space between lines of text.
 *
 *  <p><b>For the Spark theme, this is not supported.</b>  See <code>lineHeight</code>.</p>
 *
 *  <p><b>For the Mobile theme, if using StyleableTextField,
 *  see spark.components.supportClasses.StyleableStageText Style fontWeight
 *  and if using StyleableStageText, this is not supported.</b></p>
 *
 *  @see spark.components.supportClasses.StyleableTextField#style:leading
 *  @see #style:lineHeight
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.0
 *  @productversion Flex 4.5
 */
//[Style(name="leading", type="Number", format="Length", inherit="yes", theme="mobile")]

/**
 *  The number of additional pixels to appear between each character.
 *
 *  <p><b>For the Spark theme, this is not supported.</b>  See <code>trackingLeft</code>
 *  and <code>trackingRight</code>.</p>
 *
 *  <p><b>For the Mobile theme, if using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField.letterSpacing
 *  and if using StyleableStageText, this is not supported.</b></p>
 *
 *  @see spark.components.supportClasses.StyleableTextField#style:letterSpacing
 *  @see #style:trackingLeft
 *  @see #style:trackingRight
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.0
 *  @productversion Flex 4.5
 */
//[Style(name="letterSpacing", type="Number", inherit="yes", theme="mobile")]

/**
 *  Controls which of the ligatures that are defined in the font may be used in the text.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.ligatureLevel</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#ligatureLevel
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="ligatureLevel", type="String", enumeration="common,minimum,uncommon,exotic", inherit="yes")]

/**
 *  Leading controls for the text.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.lineHeight.</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b>  See <code>leading</code>.</p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#lineHeight
 *  @see #style:leading
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Style(name="lineHeight", type="Object", inherit="yes")]

/**
 *  If true, applies strikethrough, a line drawn through the middle of the text.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.lineThrough</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#lineThrough
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="lineThrough", type="Boolean", inherit="yes")]

/**
 *  The locale of the text.
 *  Controls case transformations and shaping.
 *  Uses standard locale identifiers as described in Unicode Technical Standard #35.
 *  For example "en", "en_US" and "en-US" are all English, "ja" is Japanese.
 *
 *  <p>The default value is undefined. This property inherits its value from an ancestor; if
 *  still undefined, it inherits from the global <code>locale</code> style.
 *  During the application initialization, if the global <code>locale</code> style is undefined,
 *  then the default value is set to "en".</p>
 *
 *  <p>When using the Spark formatters and globalization classes, you can set this style on the
 *  root application to the value of the <code>LocaleID.DEFAULT</code> constant.
 *  Those classes will then use the client operating system's international preferences.</p>
 *
 *  @default undefined
 *  @see http://www.unicode.org/reports/tr35/
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="locale", type="String", inherit="yes")]

/**
 *  The rendering mode used for this text which applies only to embedded fonts.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.renderingMode</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#renderingMode
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="renderingMode", type="String", enumeration="cff,normal", inherit="yes")]

/**
 *  Alignment of text within a container.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.textAlign</b></p>
 *
 *  <p><b>For the Mobile theme, if using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField Style textAlign,
 *  and if using StyleableStageText,
 *  see spark.components.supportClasses.StyleableStageText Style textAlign.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#textAlign
 *  @see spark.components.supportClasses.StyleableStageText#style:textAlign
 *  @see spark.components.supportClasses.StyleableTextField#style:textAlign
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="textAlign", type="String", enumeration="start,end,left,right,center,justify", inherit="yes")]

/**
 *  Alignment of the last line in the paragraph relative to the container in justified text.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.textAlignLast</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#textAlignLast
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="textAlignLast", type="String", enumeration="start,end,left,right,center,justify", inherit="yes")]

/**
 *  Alpha (transparency) value for the text.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.textAlpha</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#textAlpha
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="textAlpha", type="Number", inherit="yes", minValue="0.0", maxValue="1.0")]

/**
 *  Determines whether the text is underlined.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.textDecoration</b></p>
 *
 *  <p><b>For the Mobile theme, if using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField Style textDecoration,
 *  and if using StyleableStageText, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#textDecoration
 *  @see spark.components.supportClasses.StyleableTextField#style:textDecoration
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="textDecoration", type="String", enumeration="none,underline", inherit="yes")]

/**
 *  Specifies options for justifying text.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.textJustify</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#textJustify
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="textJustify", type="String", enumeration="interWord,distribute", inherit="yes")]

/**
 *  The amount of tracking (manual kerning) to be applied to the left of each character.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.trackingLeft</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#trackingLeft
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="trackingLeft", type="Object", inherit="yes")]

/**
 *  The amount of tracking (manual kerning) to be applied to the right of each character.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.trackingRight</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#trackingRight
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="trackingRight", type="Object", inherit="yes")]

/**
 *  The type of typographic case used for this text.
 *
 *  <p><b>For the Spark theme, see
 *  flashx.textLayout.formats.ITextLayoutFormat.typographicCase</b></p>
 *
 *  <p><b>For the Mobile theme, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#typographicCase
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="typographicCase", type="String", enumeration="default,capsToSmallCaps,uppercase,lowercase,lowercaseToSmallCaps", inherit="yes")]