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
	import org.apache.royale.text.engine.BreakOpportunity;
	import org.apache.royale.text.engine.CFFHinting;
	import org.apache.royale.text.engine.DigitCase;
	import org.apache.royale.text.engine.DigitWidth;
	import org.apache.royale.text.engine.FontLookup;
	import org.apache.royale.text.engine.FontPosture;
	import org.apache.royale.text.engine.FontWeight;
	import org.apache.royale.text.engine.JustificationStyle;
	import org.apache.royale.text.engine.Kerning;
	import org.apache.royale.text.engine.LigatureLevel;
	import org.apache.royale.text.engine.RenderingMode;
	import org.apache.royale.text.engine.TextBaseline;
	import org.apache.royale.text.engine.TextRotation;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.property.Property;
	import org.apache.royale.textLayout.property.PropertyFactory;
	import org.apache.royale.textLayout.property.PropertyUtil;

	/**
	 * The TextLayoutFormat class holds all of the text layout properties. These properties affect the format and style of a text flow at the container level, paragraph level, and text level.  Both the ContainerController class and the FlowElement base class have <code>format</code> properties that enable you to assign a TextLayoutFormat instance to them. Assign a TextLayoutFormat object to a container to affect the format of all of the container's content. Assign a TextLayoutFormat object to a FlowElement descendant to specify formatting for that particular element: TextFlow, ParagraphElement, DivElement, SpanElement, InlineGraphicElement, LinkElement, and TCYElement.
	 * In addition to the <code>format</code> property, these classes also define each of the individual TextLayoutFormat properties so that you can override the setting of a particular style property for that element, if you wish. <p>Because you can set a given style at multiple levels, it is possible to have conflicts. For example, the color of the text at the TextFlow level could be set to black while a SpanElement object sets it to blue. The general rule is that the setting at the lowest level on the text flow tree takes precedence. So if the ligature level is set for a TextFlow instance and also set for a DivElement, the DivElement setting takes precedence. </p><p>Cascading styles refers to the process of adopting styles from a higher level in the text flow if a style value is undefined at a lower level. When a style is undefined on an element at the point it is about to be rendered, it either takes its default value or the value cascades or descends from the value on a parent element. For example, if the transparency (<code>textAlpha</code> property) of the text is undefined on a SpanElement object, but is set on the TextFlow, the value of the <code>TextFlow.textAlpha</code> property cascades to the SpanElement object and is applied to the text for that span. The result of the cascade, or the sum of the styles that is applied to the element, is stored in the element's <code>computedFormat</code> property.</p><p>In the same way, you can apply user styles using the <code>userStyles</code> property of the ContainerController and FlowElement classes. This  property allows you to read or write a dictionary of user styles and apply its settings to a container or a text flow element. The user styles dictionary is an object that consists of <em>stylename-value</em> pairs. Styles specified by the <code>userStyles</code> property take precedence over all others.</p><p>Most styles that are undefined inherit the value of their immediate parent during a cascade. A small number of styles, however, do not inherit their parent�s value and take on their default values instead.</p><p><strong>Style properties that adopt their default values, if undefined, include:</strong> <code>backgroundAlpha</code>, <code>backgroundColor</code>, <code>columnCount</code>, <code>columnGap</code>, <code>columnWidth</code>, <code>lineBreak</code>, <code>paddingBottom</code>, <code>paddingLeft</code>, <code>paddingRight</code>, <code>paddingTop</code>, <code>verticalAlign</code></p>.
	 * @see org.apache.royale.textLayout.elements.FlowElement#format
	 * @see org.apache.royale.textLayout.factory.TextFlowTextLineFactory
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5 
	 * @langversion 3.0 
	 */
	public class TextLayoutFormat implements ITextLayoutFormat
	{
		/** @private */
		static private var _columnBreakBeforeProperty:Property;

		static public function get columnBreakBeforeProperty():Property
		{
			if (!_columnBreakBeforeProperty)
				_columnBreakBeforeProperty = PropertyFactory.enumString("columnBreakBefore", BreakStyle.AUTO, false, Vector.<String>([Category.PARAGRAPH]), BreakStyle.AUTO, BreakStyle.ALWAYS);
			return _columnBreakBeforeProperty;
		}

		/** @private */
		static private var _columnBreakAfterProperty:Property;

		static public function get columnBreakAfterProperty():Property
		{
			if (!_columnBreakAfterProperty)
				_columnBreakAfterProperty = PropertyFactory.enumString("columnBreakAfter", BreakStyle.AUTO, false, Vector.<String>([Category.PARAGRAPH]), BreakStyle.AUTO, BreakStyle.ALWAYS);
			return _columnBreakAfterProperty;
		}

		/** @private */
		static private var _containerBreakBeforeProperty:Property;

		static public function get containerBreakBeforeProperty():Property
		{
			if (!_containerBreakBeforeProperty)
				_containerBreakBeforeProperty = PropertyFactory.enumString("containerBreakBefore", BreakStyle.AUTO, false, Vector.<String>([Category.PARAGRAPH]), BreakStyle.AUTO, BreakStyle.ALWAYS);
			return _containerBreakBeforeProperty;
		}

		/** @private */
		static private var _containerBreakAfterProperty:Property;

		static public function get containerBreakAfterProperty():Property
		{
			if (!_containerBreakAfterProperty)
				_containerBreakAfterProperty = PropertyFactory.enumString("containerBreakAfter", BreakStyle.AUTO, false, Vector.<String>([Category.PARAGRAPH]), BreakStyle.AUTO, BreakStyle.ALWAYS);
			return _containerBreakAfterProperty;
		}

		/** @private */
		static private var _colorProperty:Property;

		static public function get colorProperty():Property
		{
			if (!_colorProperty)
				_colorProperty = PropertyFactory.uintOrEnum("color", 0, true, Vector.<String>([Category.CHARACTER]), ColorName.BLACK, ColorName.GREEN, ColorName.GRAY, ColorName.BLUE, ColorName.SILVER, ColorName.LIME, ColorName.OLIVE, ColorName.WHITE, ColorName.YELLOW, ColorName.MAROON, ColorName.NAVY, ColorName.RED, ColorName.PURPLE, ColorName.TEAL, ColorName.FUCHSIA, ColorName.AQUA, ColorName.MAGENTA, ColorName.CYAN,ColorName.ORANGE,ColorName.DARK_GREY,ColorName.BROWN,ColorName.TAN,ColorName.LIGHT_GREY,ColorName.DARK_GREEN);
			return _colorProperty;
		}

		/** @private */
		static private var _backgroundColorProperty:Property;

		static public function get backgroundColorProperty():Property
		{
			if (!_backgroundColorProperty)
				_backgroundColorProperty = PropertyFactory.uintOrEnum("backgroundColor", BackgroundColor.TRANSPARENT, false, Vector.<String>([Category.CHARACTER, Category.PARAGRAPH, Category.CONTAINER, Category.TABLE, Category.TABLEROW, Category.TABLECOLUMN, Category.TABLECELL]), BackgroundColor.TRANSPARENT);
			return _backgroundColorProperty;
		}

		/** @private */
		static private var _lineThroughProperty:Property;

		static public function get lineThroughProperty():Property
		{
			if (!_lineThroughProperty)
				_lineThroughProperty = PropertyFactory.bool("lineThrough", false, true, Vector.<String>([Category.CHARACTER]));
			return _lineThroughProperty;
		}

		/** @private */
		static private var _textAlphaProperty:Property;

		static public function get textAlphaProperty():Property
		{
			if (!_textAlphaProperty)
				_textAlphaProperty = PropertyFactory.number("textAlpha", 1, true, Vector.<String>([Category.CHARACTER]), 0, 1);
			return _textAlphaProperty;
		}

		/** @private */
		static private var _backgroundAlphaProperty:Property;

		static public function get backgroundAlphaProperty():Property
		{
			if (!_backgroundAlphaProperty)
				_backgroundAlphaProperty = PropertyFactory.number("backgroundAlpha", 1, false, Vector.<String>([Category.CHARACTER]), 0, 1);
			return _backgroundAlphaProperty;
		}

		/** @private */
		static private var _fontSizeProperty:Property;

		static public function get fontSizeProperty():Property
		{
			if (!_fontSizeProperty)
				_fontSizeProperty = PropertyFactory.number("fontSize", 12, true, Vector.<String>([Category.CHARACTER]), 1, 720);
			return _fontSizeProperty;
		}

		/** @private */
		static private var _xScaleProperty:Property;

		static public function get xScaleProperty():Property
		{
			if (!_xScaleProperty)
				_xScaleProperty = PropertyFactory.number("xScale", 1, true, Vector.<String>([Category.CHARACTER]), 0.01, 100);
			return _xScaleProperty;
		}

		/** @private */
		static private var _yScaleProperty:Property;

		static public function get yScaleProperty():Property
		{
			if (!_yScaleProperty)
				_yScaleProperty = PropertyFactory.number("yScale", 1, true, Vector.<String>([Category.CHARACTER]), 0.01, 100);
			return _yScaleProperty;
		}

		/** @private */
		static private var _baselineShiftProperty:Property;

		static public function get baselineShiftProperty():Property
		{
			if (!_baselineShiftProperty)
				_baselineShiftProperty = PropertyFactory.numPercentEnum("baselineShift", 0.0, true, Vector.<String>([Category.CHARACTER]), -1000, 1000, "-1000%", "1000%", BaselineShift.SUPERSCRIPT, BaselineShift.SUBSCRIPT);
			return _baselineShiftProperty;
		}

		/** @private */
		static private var _trackingLeftProperty:Property;

		static public function get trackingLeftProperty():Property
		{
			if (!_trackingLeftProperty)
				_trackingLeftProperty = PropertyFactory.numPercent("trackingLeft", 0, true, Vector.<String>([Category.CHARACTER]), -1000, 1000, "-1000%", "1000%");
			return _trackingLeftProperty;
		}

		/** @private */
		static private var _trackingRightProperty:Property;

		static public function get trackingRightProperty():Property
		{
			if (!_trackingRightProperty)
				_trackingRightProperty = PropertyFactory.numPercent("trackingRight", 0, true, Vector.<String>([Category.CHARACTER]), -1000, 1000, "-1000%", "1000%");
			return _trackingRightProperty;
		}

		/** @private */
		static private var _lineHeightProperty:Property;

		static public function get lineHeightProperty():Property
		{
			if (!_lineHeightProperty)
				_lineHeightProperty = PropertyFactory.numPercent("lineHeight", "120%", true, Vector.<String>([Category.CHARACTER]), -720, 720, "-1000%", "1000%");
			return _lineHeightProperty;
		}

		/** @private */
		static private var _breakOpportunityProperty:Property;

		static public function get breakOpportunityProperty():Property
		{
			if (!_breakOpportunityProperty)
				_breakOpportunityProperty = PropertyFactory.enumString("breakOpportunity", BreakOpportunity.AUTO, true, Vector.<String>([Category.CHARACTER]), BreakOpportunity.ALL, BreakOpportunity.ANY, BreakOpportunity.AUTO, BreakOpportunity.NONE);
			return _breakOpportunityProperty;
		}

		/** @private */
		static private var _digitCaseProperty:Property;

		static public function get digitCaseProperty():Property
		{
			if (!_digitCaseProperty)
				_digitCaseProperty = PropertyFactory.enumString("digitCase", DigitCase.DEFAULT, true, Vector.<String>([Category.CHARACTER]), DigitCase.DEFAULT, DigitCase.LINING, DigitCase.OLD_STYLE);
			return _digitCaseProperty;
		}

		/** @private */
		static private var _digitWidthProperty:Property;

		static public function get digitWidthProperty():Property
		{
			if (!_digitWidthProperty)
				_digitWidthProperty = PropertyFactory.enumString("digitWidth", DigitWidth.DEFAULT, true, Vector.<String>([Category.CHARACTER]), DigitWidth.DEFAULT, DigitWidth.PROPORTIONAL, DigitWidth.TABULAR);
			return _digitWidthProperty;
		}

		/** @private */
		static private var _dominantBaselineProperty:Property;

		static public function get dominantBaselineProperty():Property
		{
			if (!_dominantBaselineProperty)
				_dominantBaselineProperty = PropertyFactory.enumString("dominantBaseline", FormatValue.AUTO, true, Vector.<String>([Category.CHARACTER]), FormatValue.AUTO, TextBaseline.ROMAN, TextBaseline.ASCENT, TextBaseline.DESCENT, TextBaseline.IDEOGRAPHIC_TOP, TextBaseline.IDEOGRAPHIC_CENTER, TextBaseline.IDEOGRAPHIC_BOTTOM);
			return _dominantBaselineProperty;
		}

		/** @private */
		static private var _kerningProperty:Property;

		static public function get kerningProperty():Property
		{
			if (!_kerningProperty)
				_kerningProperty = PropertyFactory.enumString("kerning", Kerning.AUTO, true, Vector.<String>([Category.CHARACTER]), Kerning.ON, Kerning.OFF, Kerning.AUTO);
			return _kerningProperty;
		}

		/** @private */
		static private var _ligatureLevelProperty:Property;

		static public function get ligatureLevelProperty():Property
		{
			if (!_ligatureLevelProperty)
				_ligatureLevelProperty = PropertyFactory.enumString("ligatureLevel", LigatureLevel.COMMON, true, Vector.<String>([Category.CHARACTER]), LigatureLevel.MINIMUM, LigatureLevel.COMMON, LigatureLevel.UNCOMMON, LigatureLevel.EXOTIC);
			return _ligatureLevelProperty;
		}

		/** @private */
		static private var _alignmentBaselineProperty:Property;

		static public function get alignmentBaselineProperty():Property
		{
			if (!_alignmentBaselineProperty)
				_alignmentBaselineProperty = PropertyFactory.enumString("alignmentBaseline", TextBaseline.USE_DOMINANT_BASELINE, true, Vector.<String>([Category.CHARACTER]), TextBaseline.ROMAN, TextBaseline.ASCENT, TextBaseline.DESCENT, TextBaseline.IDEOGRAPHIC_TOP, TextBaseline.IDEOGRAPHIC_CENTER, TextBaseline.IDEOGRAPHIC_BOTTOM, TextBaseline.USE_DOMINANT_BASELINE);
			return _alignmentBaselineProperty;
		}

		/** @private */
		static private var _localeProperty:Property;

		static public function get localeProperty():Property
		{
			if (!_localeProperty)
				_localeProperty = PropertyFactory.string("locale", "en", true, Vector.<String>([Category.CHARACTER, Category.PARAGRAPH]));
			return _localeProperty;
		}

		/** @private */
		static private var _typographicCaseProperty:Property;

		static public function get typographicCaseProperty():Property
		{
			if (!_typographicCaseProperty)
				_typographicCaseProperty = PropertyFactory.enumString("typographicCase", TLFTypographicCase.DEFAULT, true, Vector.<String>([Category.CHARACTER]), TLFTypographicCase.DEFAULT, TLFTypographicCase.CAPS_TO_SMALL_CAPS, TLFTypographicCase.UPPERCASE, TLFTypographicCase.LOWERCASE, TLFTypographicCase.LOWERCASE_TO_SMALL_CAPS);
			return _typographicCaseProperty;
		}

		/** @private */
		static private var _fontFamilyProperty:Property;

		static public function get fontFamilyProperty():Property
		{
			if (!_fontFamilyProperty)
				_fontFamilyProperty = PropertyFactory.string("fontFamily", "Arial", true, Vector.<String>([Category.CHARACTER]));
			return _fontFamilyProperty;
		}

		/** @private */
		static private var _textDecorationProperty:Property;

		static public function get textDecorationProperty():Property
		{
			if (!_textDecorationProperty)
				_textDecorationProperty = PropertyFactory.enumString("textDecoration", TextDecoration.NONE, true, Vector.<String>([Category.CHARACTER]), TextDecoration.NONE, TextDecoration.UNDERLINE);
			return _textDecorationProperty;
		}

		/** @private */
		static private var _fontWeightProperty:Property;

		static public function get fontWeightProperty():Property
		{
			if (!_fontWeightProperty)
				_fontWeightProperty = PropertyFactory.enumString("fontWeight", FontWeight.NORMAL, true, Vector.<String>([Category.CHARACTER]), FontWeight.NORMAL, FontWeight.BOLD);
			return _fontWeightProperty;
		}

		/** @private */
		static private var _fontStyleProperty:Property;

		static public function get fontStyleProperty():Property
		{
			if (!_fontStyleProperty)
				_fontStyleProperty = PropertyFactory.string("fontStyle", "Regular", true, Vector.<String>([Category.CHARACTER]));
			// if (!_fontStyleProperty)
			// 	_fontStyleProperty = PropertyFactory.enumString("fontStyle", FontPosture.NORMAL, true, Vector.<String>([Category.CHARACTER]), FontPosture.NORMAL, FontPosture.ITALIC);
			return _fontStyleProperty;
		}

		/** @private */
		static private var _whiteSpaceCollapseProperty:Property;

		static public function get whiteSpaceCollapseProperty():Property
		{
			if (!_whiteSpaceCollapseProperty)
				_whiteSpaceCollapseProperty = PropertyFactory.enumString("whiteSpaceCollapse", WhiteSpaceCollapse.COLLAPSE, true, Vector.<String>([Category.CHARACTER]), WhiteSpaceCollapse.PRESERVE, WhiteSpaceCollapse.COLLAPSE);
			return _whiteSpaceCollapseProperty;
		}

		/** @private */
		static private var _renderingModeProperty:Property;

		static public function get renderingModeProperty():Property
		{
			if (!_renderingModeProperty)
				_renderingModeProperty = PropertyFactory.enumString("renderingMode", RenderingMode.CFF, true, Vector.<String>([Category.CHARACTER]), RenderingMode.NORMAL, RenderingMode.CFF);
			return _renderingModeProperty;
		}

		/** @private */
		static private var _cffHintingProperty:Property;

		static public function get cffHintingProperty():Property
		{
			if (!_cffHintingProperty)
				_cffHintingProperty = PropertyFactory.enumString("cffHinting", CFFHinting.HORIZONTAL_STEM, true, Vector.<String>([Category.CHARACTER]), CFFHinting.NONE, CFFHinting.HORIZONTAL_STEM);
			return _cffHintingProperty;
		}

		/** @private */
		static private var _fontLookupProperty:Property;

		static public function get fontLookupProperty():Property
		{
			if (!_fontLookupProperty)
				_fontLookupProperty = PropertyFactory.enumString("fontLookup", FontLookup.DEVICE, true, Vector.<String>([Category.CHARACTER]), FontLookup.DEVICE, FontLookup.EMBEDDED_CFF);
			return _fontLookupProperty;
		}

		/** @private */
		static private var _textRotationProperty:Property;

		static public function get textRotationProperty():Property
		{
			if (!_textRotationProperty)
				_textRotationProperty = PropertyFactory.enumString("textRotation", TextRotation.AUTO, true, Vector.<String>([Category.CHARACTER]), TextRotation.ROTATE_0, TextRotation.ROTATE_180, TextRotation.ROTATE_270, TextRotation.ROTATE_90, TextRotation.AUTO);
			return _textRotationProperty;
		}

		/** @private */
		static private var _textIndentProperty:Property;

		static public function get textIndentProperty():Property
		{
			if (!_textIndentProperty)
				_textIndentProperty = PropertyFactory.number("textIndent", 0, true, Vector.<String>([Category.PARAGRAPH]), -8000, 8000);
			return _textIndentProperty;
		}

		/** @private */
		static private var _paragraphStartIndentProperty:Property;

		static public function get paragraphStartIndentProperty():Property
		{
			if (!_paragraphStartIndentProperty)
				_paragraphStartIndentProperty = PropertyFactory.number("paragraphStartIndent", 0, true, Vector.<String>([Category.PARAGRAPH]), 0, 8000);
			return _paragraphStartIndentProperty;
		}

		/** @private */
		static private var _paragraphEndIndentProperty:Property;

		static public function get paragraphEndIndentProperty():Property
		{
			if (!_paragraphEndIndentProperty)
				_paragraphEndIndentProperty = PropertyFactory.number("paragraphEndIndent", 0, true, Vector.<String>([Category.PARAGRAPH]), 0, 8000);
			return _paragraphEndIndentProperty;
		}

		/** @private */
		static private var _paragraphSpaceBeforeProperty:Property;

		static public function get paragraphSpaceBeforeProperty():Property
		{
			if (!_paragraphSpaceBeforeProperty)
				_paragraphSpaceBeforeProperty = PropertyFactory.number("paragraphSpaceBefore", 0, true, Vector.<String>([Category.PARAGRAPH]), 0, 8000);
			return _paragraphSpaceBeforeProperty;
		}

		/** @private */
		static private var _paragraphSpaceAfterProperty:Property;

		static public function get paragraphSpaceAfterProperty():Property
		{
			if (!_paragraphSpaceAfterProperty)
				_paragraphSpaceAfterProperty = PropertyFactory.number("paragraphSpaceAfter", 0, true, Vector.<String>([Category.PARAGRAPH]), 0, 8000);
			return _paragraphSpaceAfterProperty;
		}

		/** @private */
		static private var _textAlignProperty:Property;

		static public function get textAlignProperty():Property
		{
			if (!_textAlignProperty)
				_textAlignProperty = PropertyFactory.enumString("textAlign", TextAlign.START, true, Vector.<String>([Category.PARAGRAPH, Category.TABLE, Category.TABLECELL, Category.TABLEROW, Category.TABLECOLUMN]), TextAlign.LEFT, TextAlign.RIGHT, TextAlign.CENTER, TextAlign.JUSTIFY, TextAlign.START, TextAlign.END);
			return _textAlignProperty;
		}

		/** @private */
		static private var _textAlignLastProperty:Property;

		static public function get textAlignLastProperty():Property
		{
			if (!_textAlignLastProperty)
				_textAlignLastProperty = PropertyFactory.enumString("textAlignLast", TextAlign.START, true, Vector.<String>([Category.PARAGRAPH]), TextAlign.LEFT, TextAlign.RIGHT, TextAlign.CENTER, TextAlign.JUSTIFY, TextAlign.START, TextAlign.END);
			return _textAlignLastProperty;
		}

		/** @private */
		static private var _textJustifyProperty:Property;

		static public function get textJustifyProperty():Property
		{
			if (!_textJustifyProperty)
				_textJustifyProperty = PropertyFactory.enumString("textJustify", TextJustify.INTER_WORD, true, Vector.<String>([Category.PARAGRAPH]), TextJustify.INTER_WORD, TextJustify.DISTRIBUTE);
			return _textJustifyProperty;
		}

		/** @private */
		static private var _justificationRuleProperty:Property;

		static public function get justificationRuleProperty():Property
		{
			if (!_justificationRuleProperty)
				_justificationRuleProperty = PropertyFactory.enumString("justificationRule", FormatValue.AUTO, true, Vector.<String>([Category.PARAGRAPH]), JustificationRule.EAST_ASIAN, JustificationRule.SPACE, FormatValue.AUTO);
			return _justificationRuleProperty;
		}

		/** @private */
		static private var _justificationStyleProperty:Property;

		static public function get justificationStyleProperty():Property
		{
			if (!_justificationStyleProperty)
				_justificationStyleProperty = PropertyFactory.enumString("justificationStyle", FormatValue.AUTO, true, Vector.<String>([Category.PARAGRAPH]), JustificationStyle.PRIORITIZE_LEAST_ADJUSTMENT, JustificationStyle.PUSH_IN_KINSOKU, JustificationStyle.PUSH_OUT_ONLY, FormatValue.AUTO);
			return _justificationStyleProperty;
		}

		/** @private */
		static private var _directionProperty:Property;

		static public function get directionProperty():Property
		{
			if (!_directionProperty)
				_directionProperty = PropertyFactory.enumString("direction", Direction.LTR, true, Vector.<String>([Category.PARAGRAPH, Category.TABLE, Category.TABLECELL, Category.TABLEROW, Category.TABLECOLUMN]), Direction.LTR, Direction.RTL);
			return _directionProperty;
		}

		/** @private */
		static private var _wordSpacingProperty:Property;

		static public function get wordSpacingProperty():Property
		{
			if (!_wordSpacingProperty)
				_wordSpacingProperty = PropertyFactory.spacingLimitProp("wordSpacing", "100%, 50%, 150%", true, Vector.<String>([Category.PARAGRAPH]), "-1000%", "1000%");
			return _wordSpacingProperty;
		}

		/** @private */
		static private var _tabStopsProperty:Property;

		static public function get tabStopsProperty():Property
		{
			if (!_tabStopsProperty)
				_tabStopsProperty = PropertyFactory.tabStopsProp("tabStops", null, true, Vector.<String>([Category.PARAGRAPH]));
			return _tabStopsProperty;
		}

		/** @private */
		static private var _leadingModelProperty:Property;

		static public function get leadingModelProperty():Property
		{
			if (!_leadingModelProperty)
				_leadingModelProperty = PropertyFactory.enumString("leadingModel", LeadingModel.AUTO, true, Vector.<String>([Category.PARAGRAPH]), LeadingModel.ROMAN_UP, LeadingModel.IDEOGRAPHIC_TOP_UP, LeadingModel.IDEOGRAPHIC_CENTER_UP, LeadingModel.IDEOGRAPHIC_TOP_DOWN, LeadingModel.IDEOGRAPHIC_CENTER_DOWN, LeadingModel.APPROXIMATE_TEXT_FIELD, LeadingModel.ASCENT_DESCENT_UP, LeadingModel.BOX, LeadingModel.AUTO);
			return _leadingModelProperty;
		}

		/** @private */
		static private var _columnGapProperty:Property;

		static public function get columnGapProperty():Property
		{
			if (!_columnGapProperty)
				_columnGapProperty = PropertyFactory.number("columnGap", 20, false, Vector.<String>([Category.CONTAINER]), 0, 1000);
			return _columnGapProperty;
		}

		/** @private */
		static private var _paddingLeftProperty:Property;

		static public function get paddingLeftProperty():Property
		{
			if (!_paddingLeftProperty)
				_paddingLeftProperty = PropertyFactory.numEnum("paddingLeft", FormatValue.AUTO, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), -8000, 8000, FormatValue.AUTO);
			return _paddingLeftProperty;
		}

		/** @private */
		static private var _paddingTopProperty:Property;

		static public function get paddingTopProperty():Property
		{
			if (!_paddingTopProperty)
				_paddingTopProperty = PropertyFactory.numEnum("paddingTop", FormatValue.AUTO, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), -8000, 8000, FormatValue.AUTO);
			return _paddingTopProperty;
		}

		/** @private */
		static private var _paddingRightProperty:Property;

		static public function get paddingRightProperty():Property
		{
			if (!_paddingRightProperty)
				_paddingRightProperty = PropertyFactory.numEnum("paddingRight", FormatValue.AUTO, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), -8000, 8000, FormatValue.AUTO);
			return _paddingRightProperty;
		}

		/** @private */
		static private var _paddingBottomProperty:Property;

		static public function get paddingBottomProperty():Property
		{
			if (!_paddingBottomProperty)
				_paddingBottomProperty = PropertyFactory.numEnum("paddingBottom", FormatValue.AUTO, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), -8000, 8000, FormatValue.AUTO);
			return _paddingBottomProperty;
		}

		/** @private */
		static private var _columnCountProperty:Property;

		static public function get columnCountProperty():Property
		{
			if (!_columnCountProperty)
				_columnCountProperty = PropertyFactory.intOrEnum("columnCount", FormatValue.AUTO, false, Vector.<String>([Category.CONTAINER]), 1, 50, FormatValue.AUTO);
			return _columnCountProperty;
		}

		/** @private */
		static private var _columnWidthProperty:Property;

		static public function get columnWidthProperty():Property
		{
			if (!_columnWidthProperty)
				_columnWidthProperty = PropertyFactory.numEnum("columnWidth", FormatValue.AUTO, false, Vector.<String>([Category.CONTAINER]), 0, 8000, FormatValue.AUTO);
			return _columnWidthProperty;
		}

		/** @private */
		static private var _firstBaselineOffsetProperty:Property;

		static public function get firstBaselineOffsetProperty():Property
		{
			if (!_firstBaselineOffsetProperty)
				_firstBaselineOffsetProperty = PropertyFactory.numEnum("firstBaselineOffset", BaselineOffset.AUTO, true, Vector.<String>([Category.CONTAINER]), 0, 1000, BaselineOffset.AUTO, BaselineOffset.ASCENT, BaselineOffset.LINE_HEIGHT);
			return _firstBaselineOffsetProperty;
		}

		/** @private */
		static private var _verticalAlignProperty:Property;

		static public function get verticalAlignProperty():Property
		{
			if (!_verticalAlignProperty)
				_verticalAlignProperty = PropertyFactory.enumString("verticalAlign", VerticalAlign.TOP, false, Vector.<String>([Category.CONTAINER, Category.TABLECELL, Category.TABLE, Category.TABLEROW, Category.TABLECOLUMN]), VerticalAlign.TOP, VerticalAlign.MIDDLE, VerticalAlign.BOTTOM, VerticalAlign.JUSTIFY);
			return _verticalAlignProperty;
		}

		/** @private */
		static private var _blockProgressionProperty:Property;

		static public function get blockProgressionProperty():Property
		{
			if (!_blockProgressionProperty)
				_blockProgressionProperty = PropertyFactory.enumString("blockProgression", BlockProgression.TB, true, Vector.<String>([Category.CONTAINER]), BlockProgression.RL, BlockProgression.TB);
			return _blockProgressionProperty;
		}

		/** @private */
		static private var _lineBreakProperty:Property;

		static public function get lineBreakProperty():Property
		{
			if (!_lineBreakProperty)
				_lineBreakProperty = PropertyFactory.enumString("lineBreak", LineBreak.TO_FIT, false, Vector.<String>([Category.CONTAINER, Category.TABLECELL]), LineBreak.EXPLICIT, LineBreak.TO_FIT);
			return _lineBreakProperty;
		}

		/** @private */
		static private var _listStyleTypeProperty:Property;

		static public function get listStyleTypeProperty():Property
		{
			if (!_listStyleTypeProperty)
				_listStyleTypeProperty = PropertyFactory.enumString("listStyleType", ListStyleType.DISC, true, Vector.<String>([Category.LIST]), ListStyleType.UPPER_ALPHA, ListStyleType.LOWER_ALPHA, ListStyleType.UPPER_ROMAN, ListStyleType.LOWER_ROMAN, ListStyleType.NONE, ListStyleType.DISC, ListStyleType.CIRCLE, ListStyleType.SQUARE, ListStyleType.BOX, ListStyleType.CHECK, ListStyleType.DIAMOND, ListStyleType.HYPHEN, ListStyleType.ARABIC_INDIC, ListStyleType.BENGALI, ListStyleType.DECIMAL, ListStyleType.DECIMAL_LEADING_ZERO, ListStyleType.DEVANAGARI, ListStyleType.GUJARATI, ListStyleType.GURMUKHI, ListStyleType.KANNADA, ListStyleType.PERSIAN, ListStyleType.THAI, ListStyleType.URDU, ListStyleType.CJK_EARTHLY_BRANCH, ListStyleType.CJK_HEAVENLY_STEM, ListStyleType.HANGUL, ListStyleType.HANGUL_CONSTANT, ListStyleType.HIRAGANA, ListStyleType.HIRAGANA_IROHA, ListStyleType.KATAKANA, ListStyleType.KATAKANA_IROHA, ListStyleType.LOWER_ALPHA, ListStyleType.LOWER_GREEK, ListStyleType.LOWER_LATIN, ListStyleType.UPPER_ALPHA, ListStyleType.UPPER_GREEK, ListStyleType.UPPER_LATIN);
			return _listStyleTypeProperty;
		}

		/** @private */
		static private var _listStylePositionProperty:Property;

		static public function get listStylePositionProperty():Property
		{
			if (!_listStylePositionProperty)
				_listStylePositionProperty = PropertyFactory.enumString("listStylePosition", ListStylePosition.OUTSIDE, true, Vector.<String>([Category.LIST]), ListStylePosition.INSIDE, ListStylePosition.OUTSIDE);
			return _listStylePositionProperty;
		}

		/** @private */
		static private var _listAutoPaddingProperty:Property;

		static public function get listAutoPaddingProperty():Property
		{
			if (!_listAutoPaddingProperty)
				_listAutoPaddingProperty = PropertyFactory.number("listAutoPadding", 40, true, Vector.<String>([Category.CONTAINER]), -1000, 1000);
			return _listAutoPaddingProperty;
		}

		/** @private */
		static private var _clearFloatsProperty:Property;

		static public function get clearFloatsProperty():Property
		{
			if (!_clearFloatsProperty)
				_clearFloatsProperty = PropertyFactory.enumString("clearFloats", ClearFloats.NONE, false, Vector.<String>([Category.PARAGRAPH]), ClearFloats.START, ClearFloats.END, ClearFloats.LEFT, ClearFloats.RIGHT, ClearFloats.BOTH, ClearFloats.NONE);
			return _clearFloatsProperty;
		}

		/** @private */
		static private var _styleNameProperty:Property;

		static public function get styleNameProperty():Property
		{
			if (!_styleNameProperty)
				_styleNameProperty = PropertyFactory.string("styleName", null, false, Vector.<String>([Category.STYLE]));
			return _styleNameProperty;
		}

		/** @private */
		static private var _linkNormalFormatProperty:Property;

		static public function get linkNormalFormatProperty():Property
		{
			if (!_linkNormalFormatProperty)
				_linkNormalFormatProperty = PropertyFactory.tlfProp("linkNormalFormat", null, true, Vector.<String>([Category.STYLE]));
			return _linkNormalFormatProperty;
		}

		/** @private */
		static private var _linkActiveFormatProperty:Property;

		static public function get linkActiveFormatProperty():Property
		{
			if (!_linkActiveFormatProperty)
				_linkActiveFormatProperty = PropertyFactory.tlfProp("linkActiveFormat", null, true, Vector.<String>([Category.STYLE]));
			return _linkActiveFormatProperty;
		}

		/** @private */
		static private var _linkHoverFormatProperty:Property;

		static public function get linkHoverFormatProperty():Property
		{
			if (!_linkHoverFormatProperty)
				_linkHoverFormatProperty = PropertyFactory.tlfProp("linkHoverFormat", null, true, Vector.<String>([Category.STYLE]));
			return _linkHoverFormatProperty;
		}

		/** @private */
		static private var _listMarkerFormatProperty:Property;

		static public function get listMarkerFormatProperty():Property
		{
			if (!_listMarkerFormatProperty)
				_listMarkerFormatProperty = PropertyFactory.listMarkerFormatProp("listMarkerFormat", null, true, Vector.<String>([Category.STYLE]));
			return _listMarkerFormatProperty;
		}

		/** @private */
		static private var _borderLeftWidthProperty:Property;

		static public function get borderLeftWidthProperty():Property
		{
			if (!_borderLeftWidthProperty)
				_borderLeftWidthProperty = PropertyFactory.number("borderLeftWidth", 0, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), 0, 128);
			return _borderLeftWidthProperty;
		}

		/** @private */
		static private var _borderRightWidthProperty:Property;

		static public function get borderRightWidthProperty():Property
		{
			if (!_borderRightWidthProperty)
				_borderRightWidthProperty = PropertyFactory.number("borderRightWidth", 0, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), 0, 128);
			return _borderRightWidthProperty;
		}

		/** @private */
		static private var _borderTopWidthProperty:Property;

		static public function get borderTopWidthProperty():Property
		{
			if (!_borderTopWidthProperty)
				_borderTopWidthProperty = PropertyFactory.number("borderTopWidth", 0, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), 0, 128);
			return _borderTopWidthProperty;
		}

		/** @private */
		static private var _borderBottomWidthProperty:Property;

		static public function get borderBottomWidthProperty():Property
		{
			if (!_borderBottomWidthProperty)
				_borderBottomWidthProperty = PropertyFactory.number("borderBottomWidth", 0, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), 0, 128);
			return _borderBottomWidthProperty;
		}

		/** @private */
		static private var _borderLeftColorProperty:Property;

		static public function get borderLeftColorProperty():Property
		{
			if (!_borderLeftColorProperty)
				_borderLeftColorProperty = PropertyFactory.uintOrEnum("borderLeftColor", BorderColor.TRANSPARENT, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), BorderColor.TRANSPARENT);
			return _borderLeftColorProperty;
		}

		/** @private */
		static private var _borderRightColorProperty:Property;

		static public function get borderRightColorProperty():Property
		{
			if (!_borderRightColorProperty)
				_borderRightColorProperty = PropertyFactory.uintOrEnum("borderRightColor", BorderColor.TRANSPARENT, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), BorderColor.TRANSPARENT);
			return _borderRightColorProperty;
		}

		/** @private */
		static private var _borderTopColorProperty:Property;

		static public function get borderTopColorProperty():Property
		{
			if (!_borderTopColorProperty)
				_borderTopColorProperty = PropertyFactory.uintOrEnum("borderTopColor", BorderColor.TRANSPARENT, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), BorderColor.TRANSPARENT);
			return _borderTopColorProperty;
		}

		/** @private */
		static private var _borderBottomColorProperty:Property;

		static public function get borderBottomColorProperty():Property
		{
			if (!_borderBottomColorProperty)
				_borderBottomColorProperty = PropertyFactory.uintOrEnum("borderBottomColor", BorderColor.TRANSPARENT, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), BorderColor.TRANSPARENT);
			return _borderBottomColorProperty;
		}

		/** @private */
		static private var _borderLeftPriorityProperty:Property;

		static public function get borderLeftPriorityProperty():Property
		{
			if (!_borderLeftPriorityProperty)
				_borderLeftPriorityProperty = PropertyFactory.number("borderLeftPriority", 0, false, Vector.<String>([Category.TABLE, Category.TABLECELL, Category.TABLECOLUMN, Category.TABLEROW]), -8000, 8000);
			return _borderLeftPriorityProperty;
		}

		/** @private */
		static private var _borderRightPriorityProperty:Property;

		static public function get borderRightPriorityProperty():Property
		{
			if (!_borderRightPriorityProperty)
				_borderRightPriorityProperty = PropertyFactory.number("borderRightPriority", 0, false, Vector.<String>([Category.TABLE, Category.TABLECELL, Category.TABLECOLUMN, Category.TABLEROW]), -8000, 8000);
			return _borderRightPriorityProperty;
		}

		/** @private */
		static private var _borderTopPriorityProperty:Property;

		static public function get borderTopPriorityProperty():Property
		{
			if (!_borderTopPriorityProperty)
				_borderTopPriorityProperty = PropertyFactory.number("borderTopPriority", 0, false, Vector.<String>([Category.TABLE, Category.TABLECELL, Category.TABLECOLUMN, Category.TABLEROW]), -8000, 8000);
			return _borderTopPriorityProperty;
		}

		/** @private */
		static private var _borderBottomPriorityProperty:Property;

		static public function get borderBottomPriorityProperty():Property
		{
			if (!_borderBottomPriorityProperty)
				_borderBottomPriorityProperty = PropertyFactory.number("borderBottomPriority", 0, false, Vector.<String>([Category.TABLE, Category.TABLECELL, Category.TABLECOLUMN, Category.TABLEROW]), -8000, 8000);
			return _borderBottomPriorityProperty;
		}

		/** @private */
		static private var _marginLeftProperty:Property;

		static public function get marginLeftProperty():Property
		{
			if (!_marginLeftProperty)
				_marginLeftProperty = PropertyFactory.number("marginLeft", 0, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), -8000, 8000);
			return _marginLeftProperty;
		}

		/** @private */
		static private var _marginRightProperty:Property;

		static public function get marginRightProperty():Property
		{
			if (!_marginRightProperty)
				_marginRightProperty = PropertyFactory.number("marginRight", 0, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), -8000, 8000);
			return _marginRightProperty;
		}

		/** @private */
		static private var _marginTopProperty:Property;

		static public function get marginTopProperty():Property
		{
			if (!_marginTopProperty)
				_marginTopProperty = PropertyFactory.number("marginTop", 0, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), -8000, 8000);
			return _marginTopProperty;
		}

		/** @private */
		static private var _marginBottomProperty:Property;

		static public function get marginBottomProperty():Property
		{
			if (!_marginBottomProperty)
				_marginBottomProperty = PropertyFactory.number("marginBottom", 0, false, Vector.<String>([Category.CONTAINER, Category.PARAGRAPH]), -8000, 8000);
			return _marginBottomProperty;
		}

		/** @private */
		static private var _cellSpacingProperty:Property;

		static public function get cellSpacingProperty():Property
		{
			if (!_cellSpacingProperty)
				_cellSpacingProperty = PropertyFactory.number("cellSpacing", 0, false, Vector.<String>([Category.TABLE]), 0, 1000);
			return _cellSpacingProperty;
		}

		/** @private */
		static private var _cellPaddingProperty:Property;

		static public function get cellPaddingProperty():Property
		{
			if (!_cellPaddingProperty)
				_cellPaddingProperty = PropertyFactory.numPercent("cellPadding", 0, true, Vector.<String>([Category.TABLE]), 0, 1000, "0%", "100%");
			return _cellPaddingProperty;
		}

		/** @private */
		static private var _tableWidthProperty:Property;

		static public function get tableWidthProperty():Property
		{
			if (!_tableWidthProperty)
				_tableWidthProperty = PropertyFactory.numPercent("tableWidth", "100%", false, Vector.<String>([Category.TABLE]), 0, 8000, "0%", "100%");
			return _tableWidthProperty;
		}

		/** @private */
		static private var _tableColumnWidthProperty:Property;

		static public function get tableColumnWidthProperty():Property
		{
			if (!_tableColumnWidthProperty)
				_tableColumnWidthProperty = PropertyFactory.numPercent("tableColumnWidth", 0, false, Vector.<String>([Category.TABLECOLUMN]), 0, 8000, "0%", "100%");
			return _tableColumnWidthProperty;
		}

		/** @private */
		static private var _minCellHeightProperty:Property;

		static public function get minCellHeightProperty():Property
		{
			if (!_minCellHeightProperty)
				_minCellHeightProperty = PropertyFactory.numEnum("minCellHeight", 2, false, Vector.<String>([Category.TABLE, Category.TABLECELL]), 2, 8000);
			return _minCellHeightProperty;
		}

		/** @private */
		static private var _maxCellHeightProperty:Property;

		static public function get maxCellHeightProperty():Property
		{
			if (!_maxCellHeightProperty)
				_maxCellHeightProperty = PropertyFactory.numEnum("maxCellHeight", 8000, false, Vector.<String>([Category.TABLE, Category.TABLECELL]), 2, 8000);
			return _maxCellHeightProperty;
		}

		/** @private */
		static private var _frameProperty:Property;

		static public function get frameProperty():Property
		{
			if (!_frameProperty)
				_frameProperty = PropertyFactory.enumString("frame", TableFrame.VOID, false, Vector.<String>([Category.TABLE]), TableFrame.VOID, TableFrame.ABOVE, TableFrame.BELOW, TableFrame.HSIDES, TableFrame.VSIDES, TableFrame.LHS, TableFrame.RHS, TableFrame.BOX, TableFrame.BORDER);
			return _frameProperty;
		}

		/** @private */
		static private var _rulesProperty:Property;

		static public function get rulesProperty():Property
		{
			if (!_rulesProperty)
				_rulesProperty = PropertyFactory.enumString("rules", TableRules.NONE, false, Vector.<String>([Category.TABLE]), TableRules.NONE, TableRules.GROUPS, TableRules.ROWS, TableRules.COLS, TableRules.ALL);
			return _rulesProperty;
		}

		static private var _description:Object;

		/** Property descriptions accessible by name. @private */
		static public function get description():Object
		{
			if (!_description)
			{
				_description  = {
					columnBreakBefore:columnBreakBeforeProperty
					, columnBreakAfter:columnBreakAfterProperty
					, containerBreakBefore:containerBreakBeforeProperty
					, containerBreakAfter:containerBreakAfterProperty
					, color:colorProperty
					, backgroundColor:backgroundColorProperty
					, lineThrough:lineThroughProperty
					, textAlpha:textAlphaProperty
					, backgroundAlpha:backgroundAlphaProperty
					, fontSize:fontSizeProperty
                    , xScale:xScaleProperty
                    , yScale:yScaleProperty
					, baselineShift:baselineShiftProperty
					, trackingLeft:trackingLeftProperty
					, trackingRight:trackingRightProperty
					, lineHeight:lineHeightProperty
					, breakOpportunity:breakOpportunityProperty
					, digitCase:digitCaseProperty
					, digitWidth:digitWidthProperty
					, dominantBaseline:dominantBaselineProperty
					, kerning:kerningProperty
					, ligatureLevel:ligatureLevelProperty
					, alignmentBaseline:alignmentBaselineProperty
					, locale:localeProperty
					, typographicCase:typographicCaseProperty
					, fontFamily:fontFamilyProperty
					, textDecoration:textDecorationProperty
					, fontWeight:fontWeightProperty
					, fontStyle:fontStyleProperty
					, whiteSpaceCollapse:whiteSpaceCollapseProperty
					, renderingMode:renderingModeProperty
					, cffHinting:cffHintingProperty
					, fontLookup:fontLookupProperty
					, textRotation:textRotationProperty
					, textIndent:textIndentProperty
					, paragraphStartIndent:paragraphStartIndentProperty
					, paragraphEndIndent:paragraphEndIndentProperty
					, paragraphSpaceBefore:paragraphSpaceBeforeProperty
					, paragraphSpaceAfter:paragraphSpaceAfterProperty
					, textAlign:textAlignProperty
					, textAlignLast:textAlignLastProperty
					, textJustify:textJustifyProperty
					, justificationRule:justificationRuleProperty
					, justificationStyle:justificationStyleProperty
					, direction:directionProperty
					, wordSpacing:wordSpacingProperty
					, tabStops:tabStopsProperty
					, leadingModel:leadingModelProperty
					, columnGap:columnGapProperty
					, paddingLeft:paddingLeftProperty
					, paddingTop:paddingTopProperty
					, paddingRight:paddingRightProperty
					, paddingBottom:paddingBottomProperty
					, columnCount:columnCountProperty
					, columnWidth:columnWidthProperty
					, firstBaselineOffset:firstBaselineOffsetProperty
					, verticalAlign:verticalAlignProperty
					, blockProgression:blockProgressionProperty
					, lineBreak:lineBreakProperty
					, listStyleType:listStyleTypeProperty
					, listStylePosition:listStylePositionProperty
					, listAutoPadding:listAutoPaddingProperty
					, clearFloats:clearFloatsProperty
					, styleName:styleNameProperty
					, linkNormalFormat:linkNormalFormatProperty
					, linkActiveFormat:linkActiveFormatProperty
					, linkHoverFormat:linkHoverFormatProperty
					, listMarkerFormat:listMarkerFormatProperty
					, borderLeftWidth:borderLeftWidthProperty
					, borderRightWidth:borderRightWidthProperty
					, borderTopWidth:borderTopWidthProperty
					, borderBottomWidth:borderBottomWidthProperty
					, borderLeftColor:borderLeftColorProperty
					, borderRightColor:borderRightColorProperty
					, borderTopColor:borderTopColorProperty
					, borderBottomColor:borderBottomColorProperty
					, marginLeft:marginLeftProperty
					, marginRight:marginRightProperty
					, marginTop:marginTopProperty
					, marginBottom:marginBottomProperty
					, cellSpacing:cellSpacingProperty
					, cellPadding:cellPaddingProperty
					, tableWidth:tableWidthProperty
					, tableColumnWidth:tableColumnWidthProperty
					, frame:frameProperty
					, rules:rulesProperty
					, borderLeftPriority:borderLeftPriorityProperty
					, borderRightPriority:borderRightPriorityProperty
					, borderTopPriority:borderTopPriorityProperty
					, borderBottomPriority:borderBottomPriorityProperty
					, minCellHeight:minCellHeightProperty
					, maxCellHeight:maxCellHeightProperty
				};
			}
			return _description;
		}

		/** @private */
		static private var _emptyTextLayoutFormat:ITextLayoutFormat;

		/**
		 * Returns an ITextLayoutFormat instance with all properties set to <code>undefined</code>.
		 * @private
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		static public function get emptyTextLayoutFormat():ITextLayoutFormat
		{
			if (_emptyTextLayoutFormat == null)
				_emptyTextLayoutFormat = new TextLayoutFormat();
			return _emptyTextLayoutFormat;
		}

		private static const _emptyStyles:Object = {};
		/** _styles is never null */
		private var _styles:Object;
		private var _sharedStyles:Boolean;

		/**
		 * Creates a new TextLayoutFormat object. All settings are empty or, optionally, are initialized from the
		 * supplied <code>initialValues</code> object.
		 * 
		 * @param initialValues optional instance from which to copy initial values.
		 * 
		 * @see #defaultFormat
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function TextLayoutFormat(initialValues:ITextLayoutFormat = null)
		{
			this.copy(initialValues);
		}

		private function writableStyles():void
		{
			if (_sharedStyles)
			{
				_styles = _styles == _emptyStyles ? {} : PropertyUtil.createObjectWithPrototype(_styles);
				_sharedStyles = false;
			}
		}

		/** @private Returns the internal styles object. */
		public function getStyles():Object
		{
			return _styles == _emptyStyles ? null : _styles;
		}

		/** @private */
		public function setStyles(val:Object, shared:Boolean):void
		{
			CONFIG::debug
			{
				assert(val, "BAD setStyles call"); }
			if (_styles != val)
			{
				_styles = val;
				_sharedStyles = shared;
			}
		}

		/** @private */
		public function clearStyles():void
		{
			_styles = _emptyStyles;
			_sharedStyles = true;
		}

		/** Returns the <code>coreStyles</code> on this TextLayoutFormat.  
		 * The coreStyles object includes the formats that are defined by TextLayoutFormat and are in TextLayoutFormat.description. The
		 * returned <code>coreStyles</code> object consists of an array of <em>stylename-value</em> pairs.
		 * 
		 * @see org.apache.royale.textLayout.formats.TextLayoutFormat
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get coreStyles():Object
		{
			return _styles == _emptyStyles ? null : PropertyUtil.shallowCopyInFilter(_styles, description);
		}

		/** Returns the <code>userStyles</code> on this TextLayoutFormat.  
		 * The userStyles object includes the formats that are defined by TextLayoutFormat and are not in TextLayoutFormat.description. The
		 * returned <code>userStyles</code> object consists of an array of <em>stylename-value</em> pairs.
		 * 
		 * @see org.apache.royale.textLayout.formats.TextLayoutFormat
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get userStyles():Object
		{
			return _styles == _emptyStyles ? null : PropertyUtil.shallowCopyNotInFilter(_styles, description);
		}

		/** Returns the styles on this TextLayoutFormat.  Note that the getter makes a copy of the  
		 * styles dictionary. The coreStyles object encapsulates all styles set in the format property including core and user styles. The
		 * returned object consists of an array of <em>stylename-value</em> pairs.
		 * 
		 * @see org.apache.royale.textLayout.formats.TextLayoutFormat
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get styles():Object
		{
			return _styles == _emptyStyles ? null : PropertyUtil.shallowCopy(_styles);
		}

		/** @private */
		public function setStyleByName(name:String, newValue:*):void
		{
			writableStyles();

			if (newValue !== undefined)
				_styles[name] = newValue;
			else
			{
				delete _styles[name];
				if (_styles[name] !== undefined)
				{
					_styles = PropertyUtil.shallowCopy(_styles);
					delete _styles[name];
				}
			}
		}

		/** Intentionally hidden so that overriders can override individual property setters */
		private function setStyleByProperty(styleProp:Property, newValue:*):void
		{
			var name:String = styleProp.name;
			newValue = styleProp.setHelper(_styles[name], newValue);
			setStyleByName(name, newValue);
		}

		/** Sets the style specified by the <code>styleProp</code> parameter to the value specified by the
		 * <code>newValue</code> parameter. 
		 *
		 * @param styleProp The name of the style to set.
		 * @param newValue The value to which to set the style.
		 *.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0

		 */
		public function setStyle(styleProp:String, newValue:*):void
		{
			/** redirect to existing property setters for overriders*/
			if (description.hasOwnProperty(styleProp))
				this[styleProp] = newValue;
			else
				setStyleByName(styleProp, newValue);
		}

		/** Returns the value of the style specified by the <code>styleProp</code> parameter, which specifies
		 * the style name.
		 *
		 * @param styleProp The name of the style whose value is to be retrieved.
		 *
		 * @return The value of the specified style. The type varies depending on the type of the style being
		 * accessed. Returns <code>undefined</code> if the style is not set.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function getStyle(styleProp:String):*
		{
			return _styles[styleProp];
		}

		/**
		 * Copies TextLayoutFormat settings from the <code>values</code> ITextLayoutFormat instance into this TextLayoutFormat object.
		 * If <code>values</code> is <code>null</code>, this TextLayoutFormat object is initialized with undefined values for all properties.
		 * @param values optional instance from which to copy values.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function copy(incoming:ITextLayoutFormat):void
		{
			if (this == incoming)
				return;
			var holder:TextLayoutFormat = incoming as TextLayoutFormat;
			if (holder)
			{
				_styles = holder._styles;
				_sharedStyles = true;
				holder._sharedStyles = true;
				return;
			}

			_styles = _emptyStyles;
			_sharedStyles = true;

			if (incoming)
			{
				for each (var prop:Property in TextLayoutFormat.description)
				{
					var val:* = incoming[prop.name];
					if (val !== undefined)
						this[prop.name] = val;
				}
			}
		}

		/**
		 * Concatenates the values of properties in the <code>incoming</code> ITextLayoutFormat instance
		 * with the values of this TextLayoutFormat object. In this (the receiving) TextLayoutFormat object, properties whose values are <code>FormatValue.INHERIT</code>,
		 * and inheriting properties whose values are <code>undefined</code> will get new values from the <code>incoming</code> object.
		 * Non-inheriting properties whose values are <code>undefined</code> will get their default values.
		 * All other property values will remain unmodified.
		 * 
		 * @param incoming instance from which values are concatenated.
		 * @see org.apache.royale.textLayout.formats.FormatValue#INHERIT
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function concat(incoming:ITextLayoutFormat):void
		{
			var holder:TextLayoutFormat = incoming as TextLayoutFormat;
			var prop:Property;
			if (holder)
			{
				var holderStyles:Object = holder._styles;
				for (var key:String in holderStyles)
				{
					prop = description[key];
					if (prop)
						setStyleByProperty(prop, prop.concatHelper(_styles[key], holderStyles[key]));
					else
						setStyleByName(key, PropertyUtil.defaultConcatHelper(_styles[key], holderStyles[key]));
				}
				return;
			}

			// Ignores userStyles
			for each (prop in TextLayoutFormat.description)
			{
				setStyleByProperty(prop, prop.concatHelper(_styles[prop.name], incoming[prop.name]));
			}
		}

		/**
		 * Concatenates the values of properties in the <code>incoming</code> ITextLayoutFormat instance
		 * with the values of this TextLayoutFormat object. In this (the receiving) TextLayoutFormat object, properties whose values are <code>FormatValue.INHERIT</code>,
		 * and inheriting properties whose values are <code>undefined</code> will get new values from the <code>incoming</code> object.
		 * All other property values will remain unmodified.
		 * 
		 * @param incoming instance from which values are concatenated.
		 * @see org.apache.royale.textLayout.formats.FormatValue#INHERIT
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function concatInheritOnly(incoming:ITextLayoutFormat):void
		{
			var holder:TextLayoutFormat = incoming as TextLayoutFormat;
			var prop:Property;

			if (holder)
			{
				var holderStyles:Object = holder._styles;
				for (var key:String in holderStyles)
				{
					prop = description[key];
					if (prop)
						setStyleByProperty(prop, prop.concatInheritOnlyHelper(_styles[key], holderStyles[key]));
					else
						setStyleByName(key, PropertyUtil.defaultConcatHelper(_styles[key], holderStyles[key]));
				}
				return;
			}

			// Ignores userStyles
			for each (prop in TextLayoutFormat.description)
			{
				setStyleByProperty(prop, prop.concatInheritOnlyHelper(_styles[prop.name], incoming[prop.name]));
			}
		}

		/**
		 * Replaces property values in this TextLayoutFormat object with the values of properties that are set in
		 * the <code>incoming</code> ITextLayoutFormat instance. Properties that are <code>undefined</code> in the <code>incoming</code>
		 * ITextLayoutFormat instance are not changed in this object.
		 * 
		 * @param incoming instance whose property values are applied to this TextLayoutFormat object.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function apply(incoming:ITextLayoutFormat):void
		{
			var holder:TextLayoutFormat = incoming as TextLayoutFormat;
			var val:*;

			if (holder)
			{
				var holderStyles:Object = holder._styles;
				for (var key:String in holderStyles)
				{
					CONFIG::debug
					{
						assert(holderStyles[key] !== undefined, "bad value in apply"); }
					val = holderStyles[key];
					if (val !== undefined)
						setStyle(key, val);
				}
				return;
			}

			for each (var prop:Property in TextLayoutFormat.description)
			{
				var name:String = prop.name;
				val = incoming[name];
				if (val !== undefined)
					setStyle(name, val);
			}
		}

		/**
		 * Compares properties in ITextLayoutFormat instance <code>p1</code> with properties in ITextLayoutFormat instance <code>p2</code>
		 * and returns <code>true</code> if all properties match.
		 * 
		 * @param p1 instance to compare to <code>p2</code>.
		 * @param p2 instance to compare to <code>p1</code>.
		 * 
		 * @return true if all properties match, false otherwise.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		static public function isEqual(p1:ITextLayoutFormat, p2:ITextLayoutFormat):Boolean
		{
			if (p1 == null)
				p1 = emptyTextLayoutFormat;
			if (p2 == null)
				p2 = emptyTextLayoutFormat;
			if (p1 == p2)
				return true;
			var p1Holder:TextLayoutFormat = p1 as TextLayoutFormat;
			var p2Holder:TextLayoutFormat = p2 as TextLayoutFormat;
			if (p1Holder && p2Holder)
				return PropertyUtil.equalStyles(p1Holder.getStyles(), p2Holder.getStyles(), TextLayoutFormat.description);

			for each (var prop:Property in TextLayoutFormat.description)
			{
				if (!prop.equalHelper(p1[prop.name], p2[prop.name]))
					return false;
			}

			return true;
		}

		/**
		 * Sets properties in this TextLayoutFormat object to <code>undefined</code> if they match those in the <code>incoming</code>
		 * ITextLayoutFormat instance.
		 * 
		 * @param incoming instance against which to compare this TextLayoutFormat object's property values.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function removeMatching(incoming:ITextLayoutFormat):void
		{
			if (incoming == null)
				return;

			var prop:Property;
			var holder:TextLayoutFormat = incoming as TextLayoutFormat;
			if (holder)
			{
				var holderStyles:Object = holder._styles;
				for (var key:String in holderStyles)
				{
					prop = description[key];
					if (prop)
					{
						if (prop.equalHelper(_styles[key], holderStyles[key]))
							this[key] = undefined;
					}
					else if (_styles[key] == holderStyles[key])
						setStyle(key, undefined);
				}
				return;
			}

			// ignore userStyles
			for each (prop in TextLayoutFormat.description)
			{
				if (prop.equalHelper(_styles[prop.name], incoming[prop.name]))
					this[prop.name] = undefined;
			}
		}

		/**
		 * Sets properties in this TextLayoutFormat object to <code>undefined</code> if they do not match those in the
		 * <code>incoming</code> ITextLayoutFormat instance.
		 * 
		 * @param incoming instance against which to compare this TextLayoutFormat object's property values.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function removeClashing(incoming:ITextLayoutFormat):void
		{
			if (incoming == null)
				return;

			var prop:Property;
			var holder:TextLayoutFormat = incoming as TextLayoutFormat;
			if (holder)
			{
				var holderStyles:Object = holder._styles;
				for (var key:String in holderStyles)
				{
					CONFIG::debug
					{
						assert(holderStyles[key] !== undefined, "bad value in removeClashing"); }
					prop = description[key];
					if (prop)
					{
						if (!prop.equalHelper(_styles[key], holderStyles[key]))
							this[key] = undefined;
					}
					else if (_styles[key] != holderStyles[key])
						setStyle(key, undefined);
				}
				return;
			}
			for each (prop in TextLayoutFormat.description)
			{
				if (!prop.equalHelper(_styles[prop.name], incoming[prop.name]))
					this[prop.name] = undefined;
			}
		}


		[Inspectable(enumeration="auto,always,inherit")]
		/**
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
			return _styles.columnBreakBefore;
		}

		public function set columnBreakBefore(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.columnBreakBeforeProperty, value);
		}


		[Inspectable(enumeration="auto,always,inherit")]
		/**
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
			return _styles.columnBreakAfter;
		}

		public function set columnBreakAfter(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.columnBreakAfterProperty, value);
		}


		[Inspectable(enumeration="auto,always,inherit")]
		/**
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
			return _styles.containerBreakBefore;
		}

		public function set containerBreakBefore(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.containerBreakBeforeProperty, value);
		}


		[Inspectable(enumeration="auto,always,inherit")]
		/**
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
			return _styles.containerBreakAfter;
		}

		public function set containerBreakAfter(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.containerBreakAfterProperty, value);
		}

		/**
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
			return _styles.color;
		}

		public function set color(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.colorProperty, value);
		}

		/**
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
			return _styles.backgroundColor;
		}

		public function set backgroundColor(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.backgroundColorProperty, value);
		}


		[Inspectable(enumeration="true,false,inherit")]
		/**
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
			return _styles.lineThrough;
		}

		public function set lineThrough(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.lineThroughProperty, value);
		}

		/**
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
			return _styles.textAlpha;
		}

		public function set textAlpha(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.textAlphaProperty, value);
		}

		/**
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
			return _styles.backgroundAlpha;
		}

		public function set backgroundAlpha(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.backgroundAlphaProperty, value);
		}

		/**
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
			return _styles.fontSize;
		}

		public function set fontSize(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.fontSizeProperty, value);
		}

		/**
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
			return _styles.xScale;
		}

		public function set xScale(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.xScaleProperty, value);
		}

		/**
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
			return _styles.yScale;
		}

		public function set yScale(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.yScaleProperty, value);
		}

		/**
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
			return _styles.baselineShift;
		}

		public function set baselineShift(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.baselineShiftProperty, value);
		}

		/**
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
			return _styles.trackingLeft;
		}

		public function set trackingLeft(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.trackingLeftProperty, value);
		}

		/**
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
			return _styles.trackingRight;
		}

		public function set trackingRight(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.trackingRightProperty, value);
		}

		/**
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
			return _styles.lineHeight;
		}

		public function set lineHeight(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.lineHeightProperty, value);
		}


		[Inspectable(enumeration="all,any,auto,none,inherit")]
		/**
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
			return _styles.breakOpportunity;
		}

		public function set breakOpportunity(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.breakOpportunityProperty, value);
		}


		[Inspectable(enumeration="default,lining,oldStyle,inherit")]
		/**
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
			return _styles.digitCase;
		}

		public function set digitCase(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.digitCaseProperty, value);
		}


		[Inspectable(enumeration="default,proportional,tabular,inherit")]
		/**
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
			return _styles.digitWidth;
		}

		public function set digitWidth(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.digitWidthProperty, value);
		}


		[Inspectable(enumeration="auto,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom,inherit")]
		/**
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
			return _styles.dominantBaseline;
		}

		public function set dominantBaseline(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.dominantBaselineProperty, value);
		}


		[Inspectable(enumeration="on,off,auto,inherit")]
		/**
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
			return _styles.kerning;
		}

		public function set kerning(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.kerningProperty, value);
		}


		[Inspectable(enumeration="minimum,common,uncommon,exotic,inherit")]
		/**
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
			return _styles.ligatureLevel;
		}

		public function set ligatureLevel(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.ligatureLevelProperty, value);
		}


		[Inspectable(enumeration="roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom,useDominantBaseline,inherit")]
		/**
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
			return _styles.alignmentBaseline;
		}

		public function set alignmentBaseline(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.alignmentBaselineProperty, value);
		}

		/**
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
			return _styles.locale;
		}

		public function set locale(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.localeProperty, value);
		}


		[Inspectable(enumeration="default,capsToSmallCaps,uppercase,lowercase,lowercaseToSmallCaps,inherit")]
		/**
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
			return _styles.typographicCase;
		}

		public function set typographicCase(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.typographicCaseProperty, value);
		}

		/**
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
			return _styles.fontFamily;
		}

		public function set fontFamily(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.fontFamilyProperty, value);
		}


		[Inspectable(enumeration="none,underline,inherit")]
		/**
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
			return _styles.textDecoration;
		}

		public function set textDecoration(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.textDecorationProperty, value);
		}


		[Inspectable(enumeration="normal,bold,inherit")]
		/**
		 * Weight of text. May be <code>FontWeight.NORMAL</code> for use in plain text, or <code>FontWeight.BOLD</code>. Applies only to device fonts (<code>fontLookup</code> property is set to org.apache.royale.text.engine.FontLookup.DEVICE).
		 * <p>Legal values are FontWeight.NORMAL, FontWeight.BOLD, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of FontWeight.NORMAL.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.text.engine.FontWeight
		 */
		public function get fontWeight():*
		{
			return _styles.fontWeight;
		}

		public function set fontWeight(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.fontWeightProperty, value);
		}


		[Inspectable(enumeration="normal,italic,inherit")]
		/**
		 * Style of text. May be <code>FontPosture.NORMAL</code>, for use in plain text, or <code>FontPosture.ITALIC</code> for italic. This property applies only to device fonts (<code>fontLookup</code> property is set to org.apache.royale.text.engine.FontLookup.DEVICE).
		 * <p>Legal values are FontPosture.NORMAL, FontPosture.ITALIC, FormatValue.INHERIT.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined during the cascade this property will inherit its value from an ancestor. If no ancestor has set this property, it will have a value of FontPosture.NORMAL.</p>
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
			return _styles.fontStyle;
		}

		public function set fontStyle(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.fontStyleProperty, value);
		}


		[Inspectable(enumeration="preserve,collapse,inherit")]
		/**
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
			return _styles.whiteSpaceCollapse;
		}

		public function set whiteSpaceCollapse(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.whiteSpaceCollapseProperty, value);
		}


		[Inspectable(enumeration="normal,cff,inherit")]
		/**
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
			return _styles.renderingMode;
		}

		public function set renderingMode(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.renderingModeProperty, value);
		}


		[Inspectable(enumeration="none,horizontalStem,inherit")]
		/**
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
			return _styles.cffHinting;
		}

		public function set cffHinting(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.cffHintingProperty, value);
		}


		[Inspectable(enumeration="device,embeddedCFF,inherit")]
		/**
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
			return _styles.fontLookup;
		}

		public function set fontLookup(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.fontLookupProperty, value);
		}


		[Inspectable(enumeration="rotate0,rotate180,rotate270,rotate90,auto,inherit")]
		/**
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
			return _styles.textRotation;
		}

		public function set textRotation(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.textRotationProperty, value);
		}

		/**
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
			return _styles.textIndent;
		}

		public function set textIndent(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.textIndentProperty, value);
		}

		/**
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
			return _styles.paragraphStartIndent;
		}

		public function set paragraphStartIndent(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.paragraphStartIndentProperty, value);
		}

		/**
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
			return _styles.paragraphEndIndent;
		}

		public function set paragraphEndIndent(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.paragraphEndIndentProperty, value);
		}

		/**
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
			return _styles.paragraphSpaceBefore;
		}

		public function set paragraphSpaceBefore(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.paragraphSpaceBeforeProperty, value);
		}

		/**
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
			return _styles.paragraphSpaceAfter;
		}

		public function set paragraphSpaceAfter(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.paragraphSpaceAfterProperty, value);
		}


		[Inspectable(enumeration="left,right,center,justify,start,end,inherit")]
		/**
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
			return _styles.textAlign;
		}

		public function set textAlign(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.textAlignProperty, value);
		}


		[Inspectable(enumeration="left,right,center,justify,start,end,inherit")]
		/**
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
			return _styles.textAlignLast;
		}

		public function set textAlignLast(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.textAlignLastProperty, value);
		}


		[Inspectable(enumeration="interWord,distribute,inherit")]
		/**
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
			return _styles.textJustify;
		}

		public function set textJustify(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.textJustifyProperty, value);
		}


		[Inspectable(enumeration="eastAsian,space,auto,inherit")]
		/**
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
			return _styles.justificationRule;
		}

		public function set justificationRule(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.justificationRuleProperty, value);
		}


		[Inspectable(enumeration="prioritizeLeastAdjustment,pushInKinsoku,pushOutOnly,auto,inherit")]
		/**
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
			return _styles.justificationStyle;
		}

		public function set justificationStyle(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.justificationStyleProperty, value);
		}


		[Inspectable(enumeration="ltr,rtl,inherit")]
		/**
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
			return _styles.direction;
		}

		public function set direction(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.directionProperty, value);
		}

		/**
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
			return _styles.wordSpacing;
		}

		public function set wordSpacing(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.wordSpacingProperty, value);
		}

		/**
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
			return _styles.tabStops;
		}

		public function set tabStops(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.tabStopsProperty, value);
		}


		[Inspectable(enumeration="romanUp,ideographicTopUp,ideographicCenterUp,ideographicTopDown,ideographicCenterDown,approximateTextField,ascentDescentUp,box,auto,inherit")]
		/**
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
			return _styles.leadingModel;
		}

		public function set leadingModel(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.leadingModelProperty, value);
		}

		/**
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
			return _styles.columnGap;
		}

		public function set columnGap(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.columnGapProperty, value);
		}

		/**
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
			return _styles.paddingLeft;
		}

		public function set paddingLeft(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.paddingLeftProperty, value);
		}

		/**
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
			return _styles.paddingTop;
		}

		public function set paddingTop(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.paddingTopProperty, value);
		}

		/**
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
			return _styles.paddingRight;
		}

		public function set paddingRight(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.paddingRightProperty, value);
		}

		/**
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
			return _styles.paddingBottom;
		}

		public function set paddingBottom(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.paddingBottomProperty, value);
		}

		/**
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
			return _styles.columnCount;
		}

		public function set columnCount(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.columnCountProperty, value);
		}

		/**
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
			return _styles.columnWidth;
		}

		public function set columnWidth(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.columnWidthProperty, value);
		}

		/**
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
			return _styles.firstBaselineOffset;
		}

		public function set firstBaselineOffset(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.firstBaselineOffsetProperty, value);
		}


		[Inspectable(enumeration="top,middle,bottom,justify,inherit")]
		/**
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
			return _styles.verticalAlign;
		}

		public function set verticalAlign(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.verticalAlignProperty, value);
		}


		[Inspectable(enumeration="rl,tb,inherit")]
		/**
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
			return _styles.blockProgression;
		}

		public function set blockProgression(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.blockProgressionProperty, value);
		}


		[Inspectable(enumeration="explicit,toFit,inherit")]
		/**
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
			return _styles.lineBreak;
		}

		public function set lineBreak(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.lineBreakProperty, value);
		}


		[Inspectable(enumeration="upperAlpha,lowerAlpha,upperRoman,lowerRoman,none,disc,circle,square,box,check,diamond,hyphen,arabicIndic,bengali,decimal,decimalLeadingZero,devanagari,gujarati,gurmukhi,kannada,persian,thai,urdu,cjkEarthlyBranch,cjkHeavenlyStem,hangul,hangulConstant,hiragana,hiraganaIroha,katakana,katakanaIroha,lowerAlpha,lowerGreek,lowerLatin,upperAlpha,upperGreek,upperLatin,inherit")]
		/**
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
			return _styles.listStyleType;
		}

		public function set listStyleType(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.listStyleTypeProperty, value);
		}


		[Inspectable(enumeration="inside,outside,inherit")]
		/**
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
			return _styles.listStylePosition;
		}

		public function set listStylePosition(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.listStylePositionProperty, value);
		}

		/**
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
			return _styles.listAutoPadding;
		}

		public function set listAutoPadding(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.listAutoPaddingProperty, value);
		}


		[Inspectable(enumeration="start,end,left,right,both,none,inherit")]
		/**
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
			return _styles.clearFloats;
		}

		public function set clearFloats(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.clearFloatsProperty, value);
		}

		/**
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
			return _styles.styleName;
		}

		public function set styleName(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.styleNameProperty, value);
		}

		/**
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
			return _styles.linkNormalFormat;
		}

		public function set linkNormalFormat(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.linkNormalFormatProperty, value);
		}

		/**
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
			return _styles.linkActiveFormat;
		}

		public function set linkActiveFormat(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.linkActiveFormatProperty, value);
		}

		/**
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
			return _styles.linkHoverFormat;
		}

		public function set linkHoverFormat(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.linkHoverFormatProperty, value);
		}

		/**
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
			return _styles.listMarkerFormat;
		}

		public function set listMarkerFormat(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.listMarkerFormatProperty, value);
		}

		/**
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
			return _styles.borderLeftWidth;
		}

		public function set borderLeftWidth(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.borderLeftWidthProperty, value);
		}

		/**
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
			return _styles.borderRightWidth;
		}

		public function set borderRightWidth(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.borderRightWidthProperty, value);
		}

		/**
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
			return _styles.borderTopWidth;
		}

		public function set borderTopWidth(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.borderTopWidthProperty, value);
		}

		/**
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
			return _styles.borderBottomWidth;
		}

		public function set borderBottomWidth(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.borderBottomWidthProperty, value);
		}

		/**
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
			return _styles.borderLeftColor;
		}

		public function set borderLeftColor(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.borderLeftColorProperty, value);
		}

		/**
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
			return _styles.borderRightColor;
		}

		public function set borderRightColor(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.borderRightColorProperty, value);
		}

		/**
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
			return _styles.borderTopColor;
		}

		public function set borderTopColor(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.borderTopColorProperty, value);
		}

		/**
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
			return _styles.borderBottomColor;
		}

		public function set borderBottomColor(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.borderBottomColorProperty, value);
		}

		/**
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
			return _styles.borderLeftPriority;
		}

		public function set borderLeftPriority(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.borderLeftPriorityProperty, value);
		}

		/**
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
			return _styles.borderRightPriority;
		}

		public function set borderRightPriority(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.borderRightPriorityProperty, value);
		}

		/**
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
			return _styles.borderTopPriority;
		}

		public function set borderTopPriority(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.borderTopPriorityProperty, value);
		}

		/**
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
			return _styles.borderBottomPriority;
		}

		public function set borderBottomPriority(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.borderBottomPriorityProperty, value);
		}

		/**
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
			return _styles.marginLeft;
		}

		public function set marginLeft(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.marginLeftProperty, value);
		}

		/**
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
			return _styles.marginRight;
		}

		public function set marginRight(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.marginRightProperty, value);
		}

		/**
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
			return _styles.marginTop;
		}

		public function set marginTop(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.marginTopProperty, value);
		}

		/**
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
			return _styles.marginBottom;
		}

		public function set marginBottom(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.marginBottomProperty, value);
		}

		/**
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
			return _styles.cellSpacing;
		}

		public function set cellSpacing(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.cellSpacingProperty, value);
		}

		/**
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
			return _styles.cellPadding;
		}

		public function set cellPadding(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.cellPaddingProperty, value);
		}

		/**
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
			return _styles.tableWidth;
		}

		public function set tableWidth(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.tableWidthProperty, value);
		}

		/**
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
			return _styles.tableColumnWidth;
		}

		public function set tableColumnWidth(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.tableColumnWidthProperty, value);
		}

		/**
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
			return _styles.minCellHeight;
		}

		public function set minCellHeight(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.minCellHeightProperty, value);
		}

		/**
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
			return _styles.maxCellHeight;
		}

		public function set maxCellHeight(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.maxCellHeightProperty, value);
		}


		[Inspectable(enumeration="void,above,below,hsides,vsides,lhs,rhs,box,border,inherit")]
		/**
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
			return _styles.frame;
		}

		public function set frame(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.frameProperty, value);
		}


		[Inspectable(enumeration="none,groups,rows,cols,all,inherit")]
		/**
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
			return _styles.rules;
		}

		public function set rules(value:*):void
		{
			setStyleByProperty(TextLayoutFormat.rulesProperty, value);
		}

		static private var _defaults:TextLayoutFormat;

		/**
		 * Returns a TextLayoutFormat object with default settings.
		 * This function always returns the same object.
		 * 
		 * @return a singleton instance of ITextLayoutFormat that is populated with default values.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		static public function get defaultFormat():ITextLayoutFormat
		{
			if (_defaults == null)
			{
				_defaults = new TextLayoutFormat();
				PropertyUtil.defaultsAllHelper(description, _defaults);
			}
			return _defaults;
		}

		/** @private */
		public static function resetModifiedNoninheritedStyles(stylesObject:Object):void
		{
			if (stylesObject is TextLayoutFormat)
			{
				// DO THIS possible optimization if (format.getStyles() == _emptyStyles) return;
				(stylesObject as TextLayoutFormat).writableStyles();
				stylesObject = (stylesObject as TextLayoutFormat).getStyles();
			}

			if (stylesObject.columnBreakBefore != undefined && stylesObject.columnBreakBefore != TextLayoutFormat.columnBreakBeforeProperty.defaultValue)
				stylesObject.columnBreakBefore = TextLayoutFormat.columnBreakBeforeProperty.defaultValue;
			if (stylesObject.columnBreakAfter != undefined && stylesObject.columnBreakAfter != TextLayoutFormat.columnBreakAfterProperty.defaultValue)
				stylesObject.columnBreakAfter = TextLayoutFormat.columnBreakAfterProperty.defaultValue;
			if (stylesObject.containerBreakBefore != undefined && stylesObject.containerBreakBefore != TextLayoutFormat.containerBreakBeforeProperty.defaultValue)
				stylesObject.containerBreakBefore = TextLayoutFormat.containerBreakBeforeProperty.defaultValue;
			if (stylesObject.containerBreakAfter != undefined && stylesObject.containerBreakAfter != TextLayoutFormat.containerBreakAfterProperty.defaultValue)
				stylesObject.containerBreakAfter = TextLayoutFormat.containerBreakAfterProperty.defaultValue;
			if (stylesObject.backgroundColor != undefined && stylesObject.backgroundColor != TextLayoutFormat.backgroundColorProperty.defaultValue)
				stylesObject.backgroundColor = TextLayoutFormat.backgroundColorProperty.defaultValue;
			if (stylesObject.backgroundAlpha != undefined && stylesObject.backgroundAlpha != TextLayoutFormat.backgroundAlphaProperty.defaultValue)
				stylesObject.backgroundAlpha = TextLayoutFormat.backgroundAlphaProperty.defaultValue;
			if (stylesObject.columnGap != undefined && stylesObject.columnGap != TextLayoutFormat.columnGapProperty.defaultValue)
				stylesObject.columnGap = TextLayoutFormat.columnGapProperty.defaultValue;
			if (stylesObject.paddingLeft != undefined && stylesObject.paddingLeft != TextLayoutFormat.paddingLeftProperty.defaultValue)
				stylesObject.paddingLeft = TextLayoutFormat.paddingLeftProperty.defaultValue;
			if (stylesObject.paddingTop != undefined && stylesObject.paddingTop != TextLayoutFormat.paddingTopProperty.defaultValue)
				stylesObject.paddingTop = TextLayoutFormat.paddingTopProperty.defaultValue;
			if (stylesObject.paddingRight != undefined && stylesObject.paddingRight != TextLayoutFormat.paddingRightProperty.defaultValue)
				stylesObject.paddingRight = TextLayoutFormat.paddingRightProperty.defaultValue;
			if (stylesObject.paddingBottom != undefined && stylesObject.paddingBottom != TextLayoutFormat.paddingBottomProperty.defaultValue)
				stylesObject.paddingBottom = TextLayoutFormat.paddingBottomProperty.defaultValue;
			if (stylesObject.columnCount != undefined && stylesObject.columnCount != TextLayoutFormat.columnCountProperty.defaultValue)
				stylesObject.columnCount = TextLayoutFormat.columnCountProperty.defaultValue;
			if (stylesObject.columnWidth != undefined && stylesObject.columnWidth != TextLayoutFormat.columnWidthProperty.defaultValue)
				stylesObject.columnWidth = TextLayoutFormat.columnWidthProperty.defaultValue;
			if (stylesObject.verticalAlign != undefined && stylesObject.verticalAlign != TextLayoutFormat.verticalAlignProperty.defaultValue)
				stylesObject.verticalAlign = TextLayoutFormat.verticalAlignProperty.defaultValue;
			if (stylesObject.lineBreak != undefined && stylesObject.lineBreak != TextLayoutFormat.lineBreakProperty.defaultValue)
				stylesObject.lineBreak = TextLayoutFormat.lineBreakProperty.defaultValue;
			if (stylesObject.clearFloats != undefined && stylesObject.clearFloats != TextLayoutFormat.clearFloatsProperty.defaultValue)
				stylesObject.clearFloats = TextLayoutFormat.clearFloatsProperty.defaultValue;
			if (stylesObject.styleName != undefined && stylesObject.styleName != TextLayoutFormat.styleNameProperty.defaultValue)
				stylesObject.styleName = TextLayoutFormat.styleNameProperty.defaultValue;
			if (stylesObject.borderLeftWidth != undefined && stylesObject.borderLeftWidth != TextLayoutFormat.borderLeftWidthProperty.defaultValue)
				stylesObject.borderLeftWidth = TextLayoutFormat.borderLeftWidthProperty.defaultValue;
			if (stylesObject.borderRightWidth != undefined && stylesObject.borderRightWidth != TextLayoutFormat.borderRightWidthProperty.defaultValue)
				stylesObject.borderRightWidth = TextLayoutFormat.borderRightWidthProperty.defaultValue;
			if (stylesObject.borderTopWidth != undefined && stylesObject.borderTopWidth != TextLayoutFormat.borderTopWidthProperty.defaultValue)
				stylesObject.borderTopWidth = TextLayoutFormat.borderTopWidthProperty.defaultValue;
			if (stylesObject.borderBottomWidth != undefined && stylesObject.borderBottomWidth != TextLayoutFormat.borderBottomWidthProperty.defaultValue)
				stylesObject.borderBottomWidth = TextLayoutFormat.borderBottomWidthProperty.defaultValue;
			if (stylesObject.borderLeftColor != undefined && stylesObject.borderLeftColor != TextLayoutFormat.borderLeftColorProperty.defaultValue)
				stylesObject.borderLeftColor = TextLayoutFormat.borderLeftColorProperty.defaultValue;
			if (stylesObject.borderRightColor != undefined && stylesObject.borderRightColor != TextLayoutFormat.borderRightColorProperty.defaultValue)
				stylesObject.borderRightColor = TextLayoutFormat.borderRightColorProperty.defaultValue;
			if (stylesObject.borderTopColor != undefined && stylesObject.borderTopColor != TextLayoutFormat.borderTopColorProperty.defaultValue)
				stylesObject.borderTopColor = TextLayoutFormat.borderTopColorProperty.defaultValue;
			if (stylesObject.borderBottomColor != undefined && stylesObject.borderBottomColor != TextLayoutFormat.borderBottomColorProperty.defaultValue)
				stylesObject.borderBottomColor = TextLayoutFormat.borderBottomColorProperty.defaultValue;
			if (stylesObject.marginLeft != undefined && stylesObject.marginLeft != TextLayoutFormat.marginLeftProperty.defaultValue)
				stylesObject.marginLeft = TextLayoutFormat.marginLeftProperty.defaultValue;
			if (stylesObject.marginRight != undefined && stylesObject.marginRight != TextLayoutFormat.marginRightProperty.defaultValue)
				stylesObject.marginRight = TextLayoutFormat.marginRightProperty.defaultValue;
			if (stylesObject.marginTop != undefined && stylesObject.marginTop != TextLayoutFormat.marginTopProperty.defaultValue)
				stylesObject.marginTop = TextLayoutFormat.marginTopProperty.defaultValue;
			if (stylesObject.marginBottom != undefined && stylesObject.marginBottom != TextLayoutFormat.marginBottomProperty.defaultValue)
				stylesObject.marginBottom = TextLayoutFormat.marginBottomProperty.defaultValue;
			if (stylesObject.cellSpacing != undefined && stylesObject.cellSpacing != TextLayoutFormat.cellSpacingProperty.defaultValue)
				stylesObject.cellSpacing = TextLayoutFormat.cellSpacingProperty.defaultValue;
			if (stylesObject.tableWidth != undefined && stylesObject.tableWidth != TextLayoutFormat.tableWidthProperty.defaultValue)
				stylesObject.tableWidth = TextLayoutFormat.tableWidthProperty.defaultValue;
			if (stylesObject.tableColumnWidth != undefined && stylesObject.tableColumnWidth != TextLayoutFormat.tableColumnWidthProperty.defaultValue)
				stylesObject.tableColumnWidth = TextLayoutFormat.tableColumnWidthProperty.defaultValue;
			if (stylesObject.frame != undefined && stylesObject.frame != TextLayoutFormat.frameProperty.defaultValue)
				stylesObject.frame = TextLayoutFormat.frameProperty.defaultValue;
			if (stylesObject.rules != undefined && stylesObject.rules != TextLayoutFormat.rulesProperty.defaultValue)
				stylesObject.rules = TextLayoutFormat.rulesProperty.defaultValue;
			if (stylesObject.borderBottomPriority != undefined && stylesObject.borderBottomPriority != TextLayoutFormat.borderBottomPriorityProperty.defaultValue)
				stylesObject.borderBottomPriority = TextLayoutFormat.borderBottomPriorityProperty.defaultValue;
			if (stylesObject.borderTopPriority != undefined && stylesObject.borderTopPriority != TextLayoutFormat.borderTopPriorityProperty.defaultValue)
				stylesObject.borderTopPriority = TextLayoutFormat.borderTopPriorityProperty.defaultValue;
			if (stylesObject.borderLeftPriority != undefined && stylesObject.borderLeftPriority != TextLayoutFormat.borderLeftPriorityProperty.defaultValue)
				stylesObject.borderLeftPriority = TextLayoutFormat.borderLeftPriorityProperty.defaultValue;
			if (stylesObject.borderRightPriority != undefined && stylesObject.borderRightPriority != TextLayoutFormat.borderRightPriorityProperty.defaultValue)
				stylesObject.borderRightPriority = TextLayoutFormat.borderRightPriorityProperty.defaultValue;
			if (stylesObject.minCellHeight != undefined && stylesObject.minCellHeight != TextLayoutFormat.minCellHeightProperty.defaultValue)
				stylesObject.minCellHeight = TextLayoutFormat.minCellHeightProperty.defaultValue;
			if (stylesObject.maxCellHeight != undefined && stylesObject.maxCellHeight != TextLayoutFormat.maxCellHeightProperty.defaultValue)
				stylesObject.maxCellHeight = TextLayoutFormat.maxCellHeightProperty.defaultValue;
		}

		/**
		 * Creates a new TextLayoutFormat object. All settings are empty or, optionally, are initialized from the
		 * supplied <code>initialValues</code> object.
		 * 
		 * @param initialValues optional instance from which to copy initial values. If an TextLayoutFormat object values are copied.
		 * Otherwise initialValues is treated like a ObjectMap or Object and iterated over.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public static function createTextLayoutFormat(initialValues:Object):TextLayoutFormat
		{
			var format:ITextLayoutFormat = initialValues as ITextLayoutFormat;
			var rslt:TextLayoutFormat = new TextLayoutFormat(format);
			if (format == null && initialValues)
			{
				for (var key:String in initialValues)
					rslt.setStyle(key, initialValues[key]);
			}
			return rslt;
		}
	}
}
