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
package org.apache.royale.textLayout.elements.utils
{
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.text.engine.ElementFormat;
	import org.apache.royale.text.engine.FontDescription;
	import org.apache.royale.text.engine.FontMetrics;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.text.engine.TextBaseline;
	import org.apache.royale.text.engine.TextRotation;
	import org.apache.royale.text.engine.TypographicCase;
	import org.apache.royale.textLayout.compose.ISWFContext;
	import org.apache.royale.textLayout.debug.Debugging;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.formats.BaselineShift;
	import org.apache.royale.textLayout.formats.ColorName;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.TLFTypographicCase;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;
	import org.apache.royale.textLayout.utils.LocaleUtil;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.factory.TLFFactory;
	public class GeometricElementUtils
	{
		/** @private */
		public static function resolveDomBaseline(computedFormat:ITextLayoutFormat, para:IParagraphElement):String
		{
			CONFIG::debug { assert(computedFormat != null,"bad call to resolveDomBaseline"); }
			
			var domBase:String = computedFormat.dominantBaseline;
			if(domBase == FormatValue.AUTO)
			{
				if(computedFormat.textRotation == TextRotation.ROTATE_270 /*|| 
					this.computedFormat.blockProgression == BlockProgression.RL*/)
					domBase = TextBaseline.IDEOGRAPHIC_CENTER;
				else
				{
					//otherwise, avoid using the locale of the element and use the paragraph's locale
					if(para != null)
						domBase = para.getEffectiveDominantBaseline();
					else
						domBase = LocaleUtil.dominantBaseline(computedFormat.locale);
				}
			}
			
			return domBase;
		}
		/** @private 
		 * Get the "inline box" for an element with the specified computed format as defined by the CSS visual formatting model (http://www.w3.org/TR/CSS2/visuren.html)
		 * For a span, leading is applied equally above and below the em-box such that the box's height equals lineHeight. 
		 * Alignment relative to the baseline (using baselineShift, dominantBaseline, alignmentBaseline) is taken into account.
		 * @param	textLine		The containing text line
		 * @param	para			The containing para. Only used for resolving AUTO dominantBaseline value. 
		 * 							May be null, in which case the AUTO dominantBaseline value is resolved based on other attributes (such as the element's computed locale). 	
		 * @return 	A rectangle representing the inline box. Top and Bottom are relative to the line's Roman baseline. Left and Right are ignored.
		 */
		static public function getCSSInlineBoxHelper(computedFormat:ITextLayoutFormat, metrics:FontMetrics, textLine:ITextLine, para:IParagraphElement=null):Rectangle
		{
			var emBox:Rectangle 	= metrics.emBox;
			
			var ascent:Number 		= -emBox.top;
			var descent:Number 		= emBox.bottom;
			var textHeight:Number	= emBox.height;
			//TODO deal with horizontalScale and verticalScale
			var fontSize:Number 	= computedFormat.fontSize;
			var lineHeight:Number 	= TextLayoutFormat.lineHeightProperty.computeActualPropertyValue(computedFormat.lineHeight, fontSize);
			var halfLeading:Number	= (lineHeight - textHeight) / 2;
			
			// Apply half leading equally above and below the em box
			emBox.top -= halfLeading;
			emBox.bottom += halfLeading;
			
			// Account for the effect of dominantBaseline
			var computedDominantBaseline:String = resolveDomBaseline(computedFormat, para);
			switch (computedDominantBaseline)
			{
				case TextBaseline.ASCENT:
				case TextBaseline.IDEOGRAPHIC_TOP:
					emBox.offset(0, ascent); 
					break;
				
				case TextBaseline.IDEOGRAPHIC_CENTER:
					emBox.offset(0, ascent - textHeight/2);
					break;
				
				case TextBaseline.ROMAN:
					break;
				
				case TextBaseline.DESCENT:
				case TextBaseline.IDEOGRAPHIC_BOTTOM:
					emBox.offset(0, -descent);
			}
			
			// Account for the effect of alignmentBaseline
			var computedAlignmentBaseline:String = (computedFormat.alignmentBaseline == TextBaseline.USE_DOMINANT_BASELINE ? computedDominantBaseline : computedFormat.alignmentBaseline);
			emBox.offset(0, textLine.getBaselinePosition(computedAlignmentBaseline));
			
			// Account for the effect of baselineShift
			var baselineShift:Number;
			if (computedFormat.baselineShift == BaselineShift.SUPERSCRIPT)
				baselineShift = metrics.superscriptOffset * fontSize;
			else if (computedFormat.baselineShift == BaselineShift.SUBSCRIPT)
				baselineShift = metrics.subscriptOffset * fontSize;
			else
				baselineShift = -computedFormat.baselineShift;
			
			emBox.offset(0, baselineShift);
			
			return emBox;
		}
				/** @private */
		static public function computeElementFormatHelper(computedFormat:ITextLayoutFormat, para:IParagraphElement, swfContext:ISWFContext):ElementFormat
		{
			// compute the cascaded elementFormat
			var format:ElementFormat = new ElementFormat();
			CONFIG::debug { Debugging.traceFTECall(format,null,"new ElementFormat()"); }
			
			format.alignmentBaseline	= computedFormat.alignmentBaseline;
			format.alpha				= Number(computedFormat.textAlpha);
			format.breakOpportunity		= computedFormat.breakOpportunity;
			format.color				= (computedFormat.color is String) ? translateColor(computedFormat.color) : uint(computedFormat.color);
			format.dominantBaseline		= GeometricElementUtils.resolveDomBaseline(computedFormat, para);
			
			format.digitCase			= computedFormat.digitCase;
			format.digitWidth			= computedFormat.digitWidth;
			format.ligatureLevel		= computedFormat.ligatureLevel;
			format.fontSize				= Number(computedFormat.fontSize);
			format.xScale				= Number(computedFormat.xScale);
			format.yScale				= Number(computedFormat.yScale);
			format.kerning				= computedFormat.kerning;
			format.locale				= computedFormat.locale;
			//TODO adjust tracking based on xScale? Maybe it can be handled downstream.
			format.trackingLeft			= TextLayoutFormat.trackingLeftProperty.computeActualPropertyValue(computedFormat.trackingLeft,format.fontSize);
			format.trackingRight		= TextLayoutFormat.trackingRightProperty.computeActualPropertyValue(computedFormat.trackingRight,format.fontSize);
			format.textRotation			= computedFormat.textRotation;
			format.baselineShift 		= -(TextLayoutFormat.baselineShiftProperty.computeActualPropertyValue(computedFormat.baselineShift, format.fontSize));
			switch (computedFormat.typographicCase)
			{
				case TLFTypographicCase.LOWERCASE_TO_SMALL_CAPS:
					format.typographicCase = TypographicCase.CAPS_AND_SMALL_CAPS;
					break;
				case TLFTypographicCase.CAPS_TO_SMALL_CAPS:
					format.typographicCase = TypographicCase.SMALL_CAPS;
					break;
				/* Others map directly so handle it in the default case */
				default:
					format.typographicCase = computedFormat.typographicCase;
					break;
			}
			
			CONFIG::debug { Debugging.traceFTEAssign(format,"alignmentBaseline",format.alignmentBaseline); }
			CONFIG::debug { Debugging.traceFTEAssign(format,"alpha",format.alpha); }
			CONFIG::debug { Debugging.traceFTEAssign(format,"breakOpportunity",format.breakOpportunity); }
			CONFIG::debug { Debugging.traceFTEAssign(format,"color",format.color); }
			CONFIG::debug { Debugging.traceFTEAssign(format,"dominantBaseline",format.dominantBaseline); }
			CONFIG::debug { Debugging.traceFTEAssign(format,"digitCase",format.digitCase); }
			CONFIG::debug { Debugging.traceFTEAssign(format,"digitWidth",format.digitWidth); }
			CONFIG::debug { Debugging.traceFTEAssign(format,"ligatureLevel",format.ligatureLevel); }
			CONFIG::debug { Debugging.traceFTEAssign(format,"fontSize",format.fontSize); }
			CONFIG::debug { Debugging.traceFTEAssign(format,"kerning",format.kerning); }
			CONFIG::debug { Debugging.traceFTEAssign(format,"locale",format.locale); }
			CONFIG::debug { Debugging.traceFTEAssign(format,"trackingLeft",format.trackingLeft); }
			CONFIG::debug { Debugging.traceFTEAssign(format,"trackingRight",format.trackingRight); }
			CONFIG::debug { Debugging.traceFTEAssign(format,"typographicCase",format.typographicCase); }
			CONFIG::debug { Debugging.traceFTEAssign(format,"textRotation",format.textRotation); }
			CONFIG::debug { Debugging.traceFTEAssign(format,"baselineShift",format.baselineShift);	 }	
			
			// set the fontDesription in the cascadedFormat
			var fd:FontDescription = new FontDescription();
			fd.fontStyle = computedFormat.fontStyle;
			fd.fontName = computedFormat.fontFamily;
			var tf:ITextFlow = para.getTextFlow();
			if(tf)
				fd.fontLoader = tf.tlfFactory.textFactory.getFontLoader();
			else
				fd.fontLoader = TLFFactory.defaultTLFFactory.textFactory.getFontLoader();
//			fd.renderingMode = computedFormat.renderingMode;
//			fd.cffHinting = computedFormat.cffHinting;
			
			// the fontLookup may be override by the resolveFontLookupFunction
//			if (GlobalSettings.resolveFontLookupFunction == null)
//				fd.fontLookup = computedFormat.fontLookup;
//			else
//			{
//				fd.fontLookup = GlobalSettings.resolveFontLookupFunction(swfContext ? FlowComposerBase.computeBaseSWFContext(swfContext) : null, computedFormat);
//			}
			// and now give the fontMapper a shot at rewriting the FontDescription
//			var fontMapper:Function = GlobalSettings.fontMapperFunction;
//			if (fontMapper != null)
//				fontMapper(fd);
			CONFIG::debug { Debugging.traceFTECall(fd,null,"new FontDescription()"); }
//			CONFIG::debug { Debugging.traceFTEAssign(fd,"fontWeight",fd.fontWeight);	 }
			CONFIG::debug { Debugging.traceFTEAssign(fd,"fontStyle",fd.fontStyle);	 }
			CONFIG::debug { Debugging.traceFTEAssign(fd,"fontName",fd.fontName);	 }
//			CONFIG::debug { Debugging.traceFTEAssign(fd,"renderingMode",fd.renderingMode);	 }
//			CONFIG::debug { Debugging.traceFTEAssign(fd,"cffHinting",fd.cffHinting);	 }
//			CONFIG::debug { Debugging.traceFTEAssign(fd,"fontLookup",fd.fontLookup);	 }
			
			format.fontDescription = fd;
			CONFIG::debug { Debugging.traceFTEAssign(format,"fontDescription",fd); }
			
			//Moved code here because original code tried to access fontMetrics prior to setting the elementFormat.
			//Since getFontMetrics returns the value of blockElement.elementFormat.getFontMetrics(), we cannot call this
			//until after the element has been set. Watson 1820571 - gak 06.11.08
			// Adjust format for superscript/subscript
			//TODO adjust for x/y scale too? Not sure...
			if (computedFormat.baselineShift == BaselineShift.SUPERSCRIPT || 
				computedFormat.baselineShift == BaselineShift.SUBSCRIPT)
			{
				var fontMetrics:FontMetrics;
				if (swfContext)
					fontMetrics = swfContext.callInContext(format.getFontMetrics,format,null,true);
				else	
					fontMetrics = format.getFontMetrics();	
				if (computedFormat.baselineShift == BaselineShift.SUPERSCRIPT)
				{
					format.baselineShift = (fontMetrics.superscriptOffset * format.fontSize);
					format.fontSize = fontMetrics.superscriptScale * format.fontSize;
				}
				else // it's subscript
				{
					format.baselineShift = (fontMetrics.subscriptOffset * format.fontSize);
					format.fontSize = fontMetrics.subscriptScale * format.fontSize;
				}
				CONFIG::debug { Debugging.traceFTEAssign(format,"baselineShift",format.baselineShift); }
				CONFIG::debug { Debugging.traceFTEAssign(format,"fontSize",format.fontSize); }
			}			
			return format;
		}
				// mjzhang : fix for bug# 2758977 <s:p color="red"/> throws out of range error - can you do color lookup like Flex SDK
		/** @private */
		static private function translateColor(color:String):Number
		{
			var ret:Number = NaN;
			switch ( color.toLowerCase() )
			{
				case ColorName.BLACK:
					ret = 0x000000; break;
				case ColorName.BLUE:
					ret = 0x0000FF; break;
				case ColorName.GREEN:
					ret = 0x008000; break;
				case ColorName.GRAY: 
					ret = 0x808080; break;
				case ColorName.SILVER: 
					ret = 0xC0C0C0; break;
				case ColorName.LIME: 
					ret = 0x00FF00; break;
				case ColorName.OLIVE: 
					ret = 0x808000; break;
				case ColorName.WHITE: 
					ret = 0xFFFFFF; break;
				case ColorName.YELLOW: 
					ret = 0xFFFF00; break;
				case ColorName.MAROON: 
					ret = 0x800000; break;
				case ColorName.NAVY: 
					ret = 0x000080; break;
				case ColorName.RED: 
					ret = 0xFF0000; break;
				case ColorName.PURPLE: 
					ret = 0x800080; break;
				case ColorName.TEAL: 
					ret = 0x008080; break;
				case ColorName.FUCHSIA: 
					ret = 0xFF00FF; break;
				case ColorName.AQUA: 
					ret = 0x00FFFF; break;
				case ColorName.MAGENTA: 
					ret = 0xFF00FF; break;
				case ColorName.CYAN: 
					ret = 0x00FFFF; break;
				case ColorName.ORANGE:
					ret = 0xFFA500; break;
				case ColorName.DARK_GREY:
					ret = 0xA9A9A9; break;
				case ColorName.BROWN:
					ret = 0xA52A2A; break;
				case ColorName.TAN:
					ret = 0xD2B48C; break;
				case ColorName.LIGHT_GREY:
					ret = 0xD3D3D3; break;
				case ColorName.DARK_GREEN:
					ret = 0x006400; break;
				default : break;
			}
			
			return ret;
		}		
	}
}
