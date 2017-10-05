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
package org.apache.royale.textLayout.compose.utils
{
	import org.apache.royale.textLayout.elements.utils.GeometricElementUtils;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.textLayout.dummy.BoundsUtil;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.ISubParagraphGroupElementBase;
	import org.apache.royale.textLayout.formats.Float;
	import org.apache.royale.graphics.SolidColor;
	import org.apache.royale.textLayout.elements.ITCYElement;
	import org.apache.royale.text.engine.TextBaseline;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.graphics.SolidColorStroke;
	import org.apache.royale.textLayout.formats.JustificationRule;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.graphics.PathBuilder;
	import org.apache.royale.graphics.ICompoundGraphic;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.formats.BackgroundColor;
	import org.apache.royale.textLayout.formats.TextDecoration;
	import org.apache.royale.text.engine.TextRotation;
	import org.apache.royale.textLayout.compose.ITextFlowLine;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.textLayout.elements.InlineGraphicElementStatus;
	import org.apache.royale.textLayout.elements.IInlineGraphicElement;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;
	import org.apache.royale.textLayout.formats.BaselineShift;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.textLayout.formats.IMEStatus;
	import org.apache.royale.text.engine.FontMetrics;
	import org.apache.royale.textLayout.utils.CharacterUtil;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;

	public class AdornmentUtils
	{
				/** @private */
		public static function getSpanBoundsOnLine(element:IFlowLeafElement,textLine:ITextLine, blockProgression:String):Array
		{
			var line:ITextFlowLine = textLine.userData as ITextFlowLine;
			var paraStart:int = line.paragraph.getAbsoluteStart();
			var lineEnd:int = (line.absoluteStart + line.textLength) - paraStart;
			var spanStart:int = element.getAbsoluteStart() - paraStart;		// get start pos relative to the paragraph (which might not be the parent)
			var endPos:int = spanStart + element.text.length;		// so we don't include the paragraph terminator character, if present
		
			// Clip to start of line	
			var startPos:int = Math.max(spanStart, line.absoluteStart - paraStart);
			
			// Clip to end of line	
			// Heuristic for detecting spaces at the end of the line and eliminating them from the range so they won't be underlined.
			if (endPos >= lineEnd)
			{
				endPos = lineEnd;
				var spanText:String = element.text;
				while (endPos > startPos && CharacterUtil.isWhitespace(spanText.charCodeAt(endPos - spanStart - 1)))
					--endPos;
			}

			var mainRects:Array = [];
			line.calculateSelectionBounds(textLine, mainRects, startPos, endPos, blockProgression, [ line.textHeight,0]);
			return mainRects;
		}
		
				/** @private */
		static public function calculateStrikeThrough(element:IFlowLeafElement, textLine:ITextLine, blockProgression:String, metrics:FontMetrics):Number
		{
			if(element.className == "InlineGraphicElement" && IInlineGraphicElement(element).graphic && IInlineGraphicElement(element).status == InlineGraphicElementStatus.READY)
				return calculateGraphicStrikeThrough(IInlineGraphicElement(element), textLine, blockProgression, metrics);
			else
				return calculateLeafStrikeThrough(element, textLine, blockProgression, metrics);
			
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IParentIUIBase
		 * @royaleignorecoercion org.apache.royale.textLayout.compose.ITextFlowLine
		 */
		static private function calculateGraphicStrikeThrough(element:IInlineGraphicElement, textLine:ITextLine, blockProgression:String, metrics:FontMetrics):Number
		{
			var stOffset:Number = 0;
            var inlineHolder:IParentIUIBase = element.placeholderGraphic.parent as IParentIUIBase;
            if (inlineHolder)
            {
                if(blockProgression != BlockProgression.RL)
                    stOffset = Object(element.placeholderGraphic.parent).y + (element.elementHeight/2 + Number(element.getEffectivePaddingTop()));
                else
                {
                    var paddingRight:Number = element.getEffectivePaddingRight();
                    var line:ITextFlowLine = textLine.userData as ITextFlowLine;
                    var elemIdx:int = element.getAbsoluteStart() - line.absoluteStart;
                    if(textLine.getAtomTextRotation(elemIdx) != TextRotation.ROTATE_0)
                        stOffset = Object(element.placeholderGraphic.parent).x - (element.elementHeight/2 + paddingRight);
                    else
                        stOffset = Object(element.placeholderGraphic.parent).x - (element.elementWidth/2 + paddingRight);
                }
            }
            
            return blockProgression == BlockProgression.TB ? stOffset : -stOffset;
		}
		static private function calculateLeafStrikeThrough(element:IFlowLeafElement, textLine:ITextLine, blockProgression:String, metrics:FontMetrics):Number
		{
			var underlineAndStrikeThroughShift:int = 0;	
			var effectiveFontSize:Number = element.getEffectiveFontSize();
			if (element.computedFormat.baselineShift == BaselineShift.SUPERSCRIPT)
			{
				underlineAndStrikeThroughShift = -(metrics.superscriptOffset * effectiveFontSize);
			} else if (element.computedFormat.baselineShift == BaselineShift.SUBSCRIPT)
			{
				underlineAndStrikeThroughShift = -(metrics.subscriptOffset * (effectiveFontSize / metrics.subscriptScale));
			} else {
				underlineAndStrikeThroughShift = TextLayoutFormat.baselineShiftProperty.computeActualPropertyValue(element.computedFormat.baselineShift, effectiveFontSize);
			}
			
			//grab the dominantBaseline and alignmentBaseline strings
			var domBaselineString:String = GeometricElementUtils.resolveDomBaseline(element.computedFormat, element.getParagraph());
			var alignmentBaselineString:String = element.computedFormat.alignmentBaseline;
			
			//this value represents the position of the baseline used to align this text
			var alignDomBaselineAdjustment:Number = textLine.getBaselinePosition(domBaselineString);
			
			//if the alignment baseline differs from the dominant, then we need to apply the delta between the
			//dominant and the alignment to determine the line along which the glyphs are lining up...
			if(alignmentBaselineString != org.apache.royale.text.engine.TextBaseline.USE_DOMINANT_BASELINE && 
				alignmentBaselineString != domBaselineString)
			{
				alignDomBaselineAdjustment = textLine.getBaselinePosition(alignmentBaselineString);
				//take the alignmentBaseline offset and make it relative to the dominantBaseline
			}
			
			
			//first, establish the offset relative to the glyph based in fontMetrics data
			var stOffset:Number = metrics.strikethroughOffset;
			
			
			//why are we using the stOffset?  Well, the stOffset effectively tells us where the mid-point
			//of the glyph is.  By using this value, we can determine how we need to offset the underline.
			//now adjust the value.  If it is center, then the glyphs are aligned along the ST position already
			if(domBaselineString == org.apache.royale.text.engine.TextBaseline.IDEOGRAPHIC_CENTER)
			{
				stOffset = 0;
			}
			else if(domBaselineString == org.apache.royale.text.engine.TextBaseline.IDEOGRAPHIC_TOP || 
				domBaselineString == org.apache.royale.text.engine.TextBaseline.ASCENT)
			{
				stOffset *= -2;  //if the glyphs are top or ascent, then we need to invert and double the offset
				stOffset -= (2 * metrics.strikethroughThickness);
			}
			else if(domBaselineString == org.apache.royale.text.engine.TextBaseline.IDEOGRAPHIC_BOTTOM || 
				domBaselineString == org.apache.royale.text.engine.TextBaseline.DESCENT)
			{
				stOffset *= 2; //if they're bottom, then we need to simply double it
				stOffset += (2 * metrics.strikethroughThickness);
			}
			else //Roman
			{
				stOffset -= metrics.strikethroughThickness;
			}
			
			
			//Now apply the actual dominant baseline position to the offset
			stOffset += (alignDomBaselineAdjustment - underlineAndStrikeThroughShift);
			return stOffset;
		}
				/** @private return number of shapes added */
		static public function updateAdornments(element:IFlowLeafElement, tLine:ITextLine, blockProgression:String):int
		{
			CONFIG::debug { assert(element.computedFormat != null,"invalid call to updateAdornments"); }
			
			// Don't underline for floats
			if(element.className == "InlineGraphicElement" && Object(element).effectiveFloat != Float.NONE)
				return 0;
			if(element.className == "TableLeafElement")
				return 0;

			// Only work on lines with strikethrough or underline
			if (element.computedFormat.textDecoration == TextDecoration.UNDERLINE || element.computedFormat.lineThrough || element.computedFormat.backgroundAlpha > 0 && element.computedFormat.backgroundColor != BackgroundColor.TRANSPARENT)
			{
				var spanBoundsArray:Array = getSpanBoundsOnLine(element, tLine, blockProgression);
				for (var i:int = 0; i < spanBoundsArray.length; i++)
					updateAdornmentsOnBounds(element, tLine, blockProgression, spanBoundsArray[i]);
				return spanBoundsArray.length ;
			}
			return 0;
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IParagraphElement
		 */
		static private function updateAdornmentsOnBounds(element:IFlowLeafElement, tLine:ITextLine, blockProgression:String, spanBounds:Rectangle):void
		{
			CONFIG::debug { assert(element.computedFormat != null,"invalid call to updateAdornmentsOnBounds"); }

			var metrics:FontMetrics = element.getComputedFontMetrics();

			var backgroundOnly:Boolean = !(element.computedFormat.textDecoration == TextDecoration.UNDERLINE || element.computedFormat.lineThrough);
				
			if (!backgroundOnly)
			{
				var shape:ICompoundGraphic;
				shape = element.getTextFlow().tlfFactory.getCompoundGraphic();
				shape.alpha = Number(element.computedFormat.textAlpha);
				var builder:PathBuilder = new PathBuilder();
				shape.stroke = new SolidColorStroke();
						
				var stOffset:Number = calculateStrikeThrough(element,tLine, blockProgression, metrics);
				var ulOffset:Number = calculateUnderlineOffset(element, stOffset, blockProgression, metrics, tLine);
				var offset:Number = tLine.getAdornmentOffsetBase();
				ulOffset += offset;
				stOffset += offset;
			}
						
			if (blockProgression != BlockProgression.RL)
			{
				addBackgroundRect (element, tLine, metrics, spanBounds, true); 

				if (element.computedFormat.textDecoration == TextDecoration.UNDERLINE)
				{
					shape.stroke.setLineStyle(metrics.underlineThickness, element.computedFormat.color as uint);
					builder.moveTo(spanBounds.topLeft.x, ulOffset);
					builder.lineTo(spanBounds.topLeft.x + spanBounds.width, ulOffset);
					shape.drawPathCommands(builder);
					builder.clear();
//					g.lineStyle(metrics.underlineThickness, _computedFormat.color as uint);
//					g.moveTo(spanBounds.topLeft.x, ulOffset);
//					g.lineTo(spanBounds.topLeft.x + spanBounds.width, ulOffset);
				}
				
				if((element.computedFormat.lineThrough))
				{
					shape.stroke.setLineStyle(metrics.strikethroughThickness, element.computedFormat.color as uint);
					builder.moveTo(spanBounds.topLeft.x, stOffset);
					builder.lineTo(spanBounds.topLeft.x + spanBounds.width, stOffset);
					shape.drawPathCommands(builder);
					builder.clear();
					
//					g.lineStyle(metrics.strikethroughThickness, _computedFormat.color as uint);
//					g.moveTo(spanBounds.topLeft.x, stOffset);
//					g.lineTo(spanBounds.topLeft.x + spanBounds.width, stOffset);
				}
			}
			else
			{
				//is this TCY?
				var line:ITextFlowLine = tLine.userData as ITextFlowLine;
				var elemIdx:int = element.getAbsoluteStart() - line.absoluteStart;
				
				//elemIdx can sometimes be negative if the text is being wrapped due to a
				//resize gesture - in which case the tLine has not necessarily been updated.
				//If the elemIdx is invalid, just treat it like it's normal ttb text - gak 07.08.08
				if (elemIdx < 0 || tLine.atomCount <= elemIdx || tLine.getAtomTextRotation(elemIdx) != TextRotation.ROTATE_0)
				{
					addBackgroundRect (element, tLine, metrics, spanBounds, false);

					if (element.computedFormat.textDecoration == TextDecoration.UNDERLINE)
					{
						shape.stroke.setLineStyle(metrics.underlineThickness, element.computedFormat.color as uint);
						builder.moveTo(ulOffset, spanBounds.topLeft.y);
						builder.lineTo(ulOffset, spanBounds.topLeft.y + spanBounds.height);
						shape.drawPathCommands(builder);
						builder.clear();
						
//						g.lineStyle(metrics.underlineThickness, _computedFormat.color as uint);
//						g.moveTo(ulOffset, spanBounds.topLeft.y);
//						g.lineTo(ulOffset, spanBounds.topLeft.y + spanBounds.height);
					}
					
					if (element.computedFormat.lineThrough == true)
					{
						shape.stroke.setLineStyle(metrics.strikethroughThickness, element.computedFormat.color as uint);
						builder.moveTo(-stOffset, spanBounds.topLeft.y);
						builder.lineTo(-stOffset, spanBounds.topLeft.y + spanBounds.height);
						shape.drawPathCommands(builder);
						builder.clear();
	
//						g.lineStyle(metrics.strikethroughThickness, _computedFormat.color as uint);
//						g.moveTo(-stOffset, spanBounds.topLeft.y);
//						g.lineTo(-stOffset, spanBounds.topLeft.y + spanBounds.height);															
					}
				}
				else
				{
					addBackgroundRect (element, tLine, metrics, spanBounds, true, true); 
					
					if (!backgroundOnly)
					{
						//it is TCY!
						var tcyParent:ITCYElement =  element.getParentByType("TCYElement") as ITCYElement;
						CONFIG::debug{ assert(tcyParent != null, "What kind of object is this that is ROTATE_0, but not TCY?");}
						
						//if the locale of the paragraph is Chinese, we need to adorn along the left and not right side.
						var tcyPara:IParagraphElement = element.getParentByType("ParagraphElement") as IParagraphElement;
						var lowerLocale:String = tcyPara.computedFormat.locale.toLowerCase();
						var adornRight:Boolean = (lowerLocale.indexOf("zh") != 0);
						
						
						//only perform calculations for TCY adornments when we are on the last leaf.  ONLY the last leaf matters
						if((element.getAbsoluteStart() + element.textLength) == (tcyParent.getAbsoluteStart() + tcyParent.textLength))
						{
							var tcyAdornBounds:Rectangle = new Rectangle();
							calculateAdornmentBounds(tcyParent, tLine, blockProgression, tcyAdornBounds);
							
							if (element.computedFormat.textDecoration == TextDecoration.UNDERLINE)
							{
								shape.stroke.setLineStyle(metrics.underlineThickness, element.computedFormat.color as uint);
//								g.lineStyle(metrics.underlineThickness, _computedFormat.color as uint);
								var baseULAdjustment:Number = metrics.underlineOffset + (metrics.underlineThickness/2);
								var xCoor:Number = adornRight ? spanBounds.right : spanBounds.left;
								if(!adornRight)
									baseULAdjustment = -baseULAdjustment;
								
								builder.moveTo(xCoor + baseULAdjustment, tcyAdornBounds.top);
								builder.lineTo(xCoor + baseULAdjustment, tcyAdornBounds.bottom);
								shape.drawPathCommands(builder);
								builder.clear();
								
//								g.moveTo(xCoor + baseULAdjustment, tcyAdornBounds.top);
//								g.lineTo(xCoor + baseULAdjustment, tcyAdornBounds.bottom);
							}
	
							if (element.computedFormat.lineThrough == true)
							{
								var tcyMid:Number = spanBounds.bottomRight.x - tcyAdornBounds.x;
								tcyMid /= 2;
								tcyMid += tcyAdornBounds.x;
								
								shape.stroke.setLineStyle(metrics.strikethroughThickness, element.computedFormat.color as uint);
								builder.moveTo(tcyMid, tcyAdornBounds.top);
								builder.lineTo(tcyMid, tcyAdornBounds.bottom);
								shape.drawPathCommands(builder);
								builder.clear();
								
//								g.lineStyle(metrics.strikethroughThickness, _computedFormat.color as uint);
//								g.moveTo(tcyMid, tcyAdornBounds.top);
//								g.lineTo(tcyMid, tcyAdornBounds.bottom);
							}
						}
					}
				}
			}
			
		 	// Add the shape as a child of the ITextLine. In some cases, the textLine we passed through may not be the same one that's
			// in the TextFlowLine textLineCache. This can happen if the TextFlowLine's textLine is invalid and a child of the 
			// container. In that case, we generated a valid ITextLine and passed it in as tLine so that we have correct metrics 
			// for generating the adornment shapes.
			if (shape)
			{
	 			var peekLine:ITextLine = (tLine.userData as ITextFlowLine).peekTextLine();
				CONFIG::debug{ assert(peekLine == null || peekLine == tLine || peekLine.validity == "invalid", "Valid/invalid mismatch"); }
				// CONFIG::debug{ assert(peekLine == null || peekLine == TextFlowLine(tLine.userData).getTextLine(false), "Valid/invalid mismatch"); }
				if (peekLine && tLine != peekLine)
				{
					// belief is that this line of code is never hit
					CONFIG::debug { assert(false,"updateAdornmentsOnBounds: peekLine doesn't match textLine"); }
					tLine = peekLine;
				}
				tLine.addElement(shape);
			}
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.compose.ITextFlowLine
		 */
		public static function updateIMEAdornments(element:IFlowLeafElement,tLine:ITextLine, blockProgression:String, imeStatus:String):void
		{
			// Don't underline for floats
			if(element.className == "InlineGraphicElement" && Object(element).effectiveFloat != Float.NONE)
				return;

			if(element.className == "TableLeafElement")
				return ;

			var metrics:FontMetrics = element.getComputedFontMetrics();
			var spanBoundsArray:Array = getSpanBoundsOnLine(element,tLine, blockProgression);
			//this is pretty much always going to have a length of 1, but just to be sure...
			for (var i:int = 0; i < spanBoundsArray.length; i++)
			{
				//setup ime variables
				var imeLineThickness:int = 1;
				var imeLineColor:uint = 0x000000;
				var imeLineStartX:Number = 0;
				var imeLineStartY:Number = 0;
				var imeLineEndX:Number = 0;
				var imeLineEndY:Number = 0;
				
				//selected text draws with 2 px
				if(imeStatus == IMEStatus.SELECTED_CONVERTED || imeStatus == IMEStatus.SELECTED_RAW)
				{
					imeLineThickness = 2;
				}
				//Raw or deadkey text draws with grey
				if(imeStatus == IMEStatus.SELECTED_RAW || imeStatus == IMEStatus.NOT_SELECTED_RAW
					|| imeStatus == IMEStatus.DEAD_KEY_INPUT_STATE)
				{
					imeLineColor = 0xA6A6A6;
				}
				
				var spanBounds:Rectangle = spanBoundsArray[i] as Rectangle;
				var stOffset:Number = calculateStrikeThrough(element, tLine, blockProgression, metrics);
				var ulOffset:Number = calculateUnderlineOffset(element, stOffset, blockProgression, metrics, tLine);
				
				if (blockProgression != BlockProgression.RL)
				{
					imeLineStartX = spanBounds.topLeft.x + 1;
					imeLineEndX = spanBounds.topLeft.x + spanBounds.width - 1;
					imeLineStartY = ulOffset;
					imeLineEndY = ulOffset;
				}
				else
				{
					//is this TCY?
					var line:ITextFlowLine = tLine.userData as ITextFlowLine;
					var elemIdx:int = element.getAbsoluteStart() - line.absoluteStart;
					imeLineStartY = spanBounds.topLeft.y + 1;
					imeLineEndY = spanBounds.topLeft.y + spanBounds.height - 1;
					
					//elemIdx can sometimes be negative if the text is being wrapped due to a
					//resize gesture - in which case the tLine has not necessarily been updated.
					//If the elemIdx is invalid, just treat it like it's normal ttb text - gak 07.08.08
					if(elemIdx < 0 || tLine.atomCount <= elemIdx || tLine.getAtomTextRotation(elemIdx) != TextRotation.ROTATE_0)
					{
						imeLineStartX = ulOffset;
						imeLineEndX = ulOffset;
					}
					else
					{
						//it is TCY!
						var tcyParent:ITCYElement =  element.getParentByType("TCYElement") as ITCYElement;
						CONFIG::debug{ assert(tcyParent != null, "What kind of object is this that is ROTATE_0, but not TCY?");}
						
						//only perform calculations for TCY adornments when we are on the last leaf.  ONLY the last leaf matters
						if((element.getAbsoluteStart() + element.textLength) == (tcyParent.getAbsoluteStart() + tcyParent.textLength))
						{
							var tcyAdornBounds:Rectangle = new Rectangle();	// NO PMD
							calculateAdornmentBounds(tcyParent, tLine, blockProgression, tcyAdornBounds);
							var baseULAdjustment:Number = metrics.underlineOffset + (metrics.underlineThickness/2);
							
							imeLineStartY = tcyAdornBounds.top + 1;
							imeLineEndY = tcyAdornBounds.bottom - 1;
							imeLineStartX = spanBounds.bottomRight.x + baseULAdjustment;
							imeLineEndX = spanBounds.bottomRight.x + baseULAdjustment;
						}
					}
				}
				
				//Build the shape
				var selObj:ICompoundGraphic = element.getTextFlow().tlfFactory.getCompoundGraphic();	// NO PMD
				//TODO - this is probably going to need to be overridable in the full implementation
				selObj.alpha = 1;
				selObj.fill = new SolidColor(imeLineColor);
//				selObj.graphics.beginFill(imeLineColor);
				
				selObj.stroke = new SolidColorStroke(imeLineColor,imeLineThickness,selObj.alpha);
//				selObj.graphics.lineStyle(imeLineThickness, imeLineColor, selObj.alpha);
//				selObj.graphics.moveTo(imeLineStartX, imeLineStartY);
//				selObj.graphics.lineTo(imeLineEndX, imeLineEndY);
				var builder:PathBuilder = new PathBuilder(true);
				builder.moveTo(imeLineStartX, imeLineStartY);
				builder.lineTo(imeLineEndX, imeLineEndY);
				selObj.drawPathCommands(builder);
//				selObj.graphics.endFill();
				tLine.addElement(selObj);
			}
		}
	
		static public function calculateUnderlineOffset(element:IFlowLeafElement, stOffset:Number, blockProgression:String, metrics:FontMetrics, textLine:ITextLine):Number
		{
			if(element.className == "InlineGraphicElement" && IInlineGraphicElement(element).graphic && IInlineGraphicElement(element).status == InlineGraphicElementStatus.READY)
				return calculateGraphicUnderlineOffset(IInlineGraphicElement(element), stOffset, blockProgression, metrics, textLine);
			else
				return calculateLeafUnderlineOffset(element, stOffset, blockProgression, metrics, textLine);
		
		}
		
		static private function calculateLeafUnderlineOffset(element:IFlowLeafElement, stOffset:Number, blockProgression:String, metrics:FontMetrics, textLine:ITextLine):Number
		{
			var ulOffset:Number = metrics.underlineOffset + metrics.underlineThickness;
			var baseSTAdjustment:Number = metrics.strikethroughOffset;
			
			//based on the stOffset - which really represents the middle of the glyph, set the ulOffset
			//which will always be relative.  Note that simply using the alignDomBaselineAdjustment is not enough
			if(blockProgression != BlockProgression.RL)
				ulOffset += (stOffset - baseSTAdjustment) + metrics.underlineThickness/2;
			else
			{	
				var para:IParagraphElement = element.getParagraph();

				if (para.computedFormat.locale.toLowerCase().indexOf("zh") == 0)
				{
					ulOffset = -ulOffset;
					ulOffset -= (stOffset - baseSTAdjustment + (metrics.underlineThickness*2));
				}
				else
					ulOffset -= (-ulOffset + stOffset + baseSTAdjustment + (metrics.underlineThickness/2));
			}
			
			return ulOffset;
		}
	
	        /**
         *  @private 
         *  @royaleignorecoercion org.apache.royale.core.IParentIUIBase
         */
        static private function calculateGraphicUnderlineOffset(element:IInlineGraphicElement, stOffset:Number, blockProgression:String, metrics:FontMetrics, tLine:ITextLine):Number
        {
            var para:IParagraphElement = element.getParagraph();
            var ulOffset:Number = 0;
            var inlineHolder:IParentIUIBase = element.placeholderGraphic.parent as IParentIUIBase;
            if (inlineHolder)
            {
                if(blockProgression == BlockProgression.TB)
                    ulOffset = inlineHolder.y + element.elementHeightWithMarginsAndPadding();
                else
                {                   
                    if (para.computedFormat.locale.toLowerCase().indexOf("zh") == 0)
                    {
                        ulOffset = inlineHolder.x - element.elementHeightWithMarginsAndPadding();
                        ulOffset -= metrics.underlineOffset + (metrics.underlineThickness/2);
                        return ulOffset;
                    }
                    else
                        ulOffset = inlineHolder.x - element.getEffectivePaddingLeft();
                }
            }   
            ulOffset += metrics.underlineOffset + (metrics.underlineThickness/2);
            
            var justRule:String = para.getEffectiveJustificationRule();
            if(justRule == JustificationRule.EAST_ASIAN)
                ulOffset += 1;
        
            return ulOffset;
        }
		
				/** @private
		 * Adds the background rectangle (if needed), making adjustments for glyph shifting as appropriate
		 */
		 static private function addBackgroundRect(element:IFlowLeafElement, tLine:ITextLine, metrics:FontMetrics, spanBounds:Rectangle, horizontalText:Boolean, isTCY:Boolean=false):void
		 {
			if(element.computedFormat.backgroundAlpha == 0 || element.computedFormat.backgroundColor == BackgroundColor.TRANSPARENT)
				return;
				
			var tf:ITextFlow = element.getTextFlow();
			// ensure the TextFlow has a background manager - but its only supported with the StandardFlowComposer at this time			
			if (!tf.getBackgroundManager())
				return;
					
			// The background rectangle usually needs to coincide with the passsed-in span bounds.
			var r:Rectangle = spanBounds.clone();
			
			// With constrained glyph shifting (such as when superscript/subscript are in use), we'd like the
			// background rectangle to follow the glyphs. Not so for arbitrary glyph shifting (such as when 
			// baseline shift or baseline alignment are in use)	 	
			// TODO-06/12/2009: Need to figure out adjustment for TCY background rect. No adjustment for now.
			if (!isTCY && (element.computedFormat.baselineShift == BaselineShift.SUPERSCRIPT || element.computedFormat.baselineShift == BaselineShift.SUBSCRIPT))
			{	
				// The atom bounds returned by FTE do not reflect the effect of glyph shifting.
				// We approximate this effect by making the following assumptions (strikethrough/underline code does the same)
				// - The strike-through adornment runs through the center of the glyph
				// - The Roman baseline is halfway between the center and bottom (descent)
				// Effectively, the glyph's descent equals the strike-through offset, and its ascent is three times that
				
				var desiredExtent:Number; // The desired extent of the rectangle in the block progression direction
				var baselineShift:Number; 
				var fontSize:Number = element.getEffectiveFontSize();
				var baseStrikethroughOffset:Number = metrics.strikethroughOffset + metrics.strikethroughThickness/2;
				
				if (element.computedFormat.baselineShift == BaselineShift.SUPERSCRIPT)
				{
					// The rectangle needs to sit on the line's descent and must extend far enough to accommodate the
					// ascender of the glyph (that has moved up because of superscript)
					
					var glyphAscent:Number = -3 * baseStrikethroughOffset; // see assumptions above
					baselineShift = -metrics.superscriptOffset * fontSize;
					var lineDescent:Number = tLine.getBaselinePosition(TextBaseline.DESCENT) - tLine.getBaselinePosition(TextBaseline.ROMAN);
					
					desiredExtent = glyphAscent  + baselineShift + lineDescent;
					if (horizontalText)
					{
						if (desiredExtent > r.height)
						{
							r.y -= desiredExtent - r.height;
							r.height = desiredExtent;
						}
					}
					else
					{
						if (desiredExtent > r.width)
							r.width = desiredExtent;
					}
				}
				else
				{
					// The rectangle needs to hang from the line's ascent and must extend far enough to accommodate the
					// descender of the glyph (that has moved down because of superscript)
					
					var glyphDescent:Number = -baseStrikethroughOffset; // see assumptions above
					baselineShift = metrics.subscriptOffset * fontSize; 
					var lineAscent:Number = tLine.getBaselinePosition(TextBaseline.ROMAN) - tLine.getBaselinePosition(TextBaseline.ASCENT);
					
					desiredExtent = lineAscent + baselineShift + glyphDescent;
					if (horizontalText)
					{
						if (desiredExtent > r.height)
							r.height = desiredExtent;
					}
					else
					{
						if (desiredExtent > r.width)
						{
							r.x -= desiredExtent - r.width;
							r.width = desiredExtent;
						}
					}
				}
			}
			
			tf.backgroundManager.addRect(tLine, element, r, element.computedFormat.backgroundColor, element.computedFormat.backgroundAlpha);	 
		}
		
				/**
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 *  @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowLeafElement
		 */
		static public function calculateAdornmentBounds(spg:ISubParagraphGroupElementBase, tLine:ITextLine, blockProgression:String, spgRect:Rectangle):void
		{
			var childCount:int = 0;
			while(childCount < spg.numChildren)
			{
				var curChild:IFlowElement = spg.getChildAt(childCount) as IFlowElement;
				var curFlowLeaf:IFlowLeafElement = curChild as IFlowLeafElement;
				if(!curFlowLeaf && curChild is ISubParagraphGroupElementBase)
				{
					calculateAdornmentBounds(curChild as ISubParagraphGroupElementBase, tLine, blockProgression, spgRect);
					++childCount;
					continue;
				}
				
				CONFIG::debug{ assert(curFlowLeaf != null, "The TCY contains a non-FlowLeafElement!  Cannot calculate mirror!");}
				var curBounds:Rectangle = null;
				if(!(curFlowLeaf is IInlineGraphicElement))
					curBounds = getSpanBoundsOnLine(curFlowLeaf, tLine, blockProgression)[0];
				else
				{
					curBounds = BoundsUtil.getBounds(curFlowLeaf as IUIBase, tLine);// (curFlowLeaf as InlineGraphicElement).graphic.getBounds(tLine);
				}
				
				if(childCount != 0)
				{
					if(curBounds.top < spgRect.top)
						spgRect.top = curBounds.top;
						
					if(curBounds.bottom > spgRect.bottom)
						spgRect.bottom = curBounds.bottom;
					
					if(spgRect.x > curBounds.x)
						spgRect.x = curBounds.x;
				}
				else
				{
					spgRect.top = curBounds.top;
					spgRect.bottom = curBounds.bottom;
					spgRect.x = curBounds.x;
				}
				++childCount;
			}
		}
		
	}
}
