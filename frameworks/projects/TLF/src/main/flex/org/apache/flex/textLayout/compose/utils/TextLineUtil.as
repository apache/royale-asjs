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
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.IBackgroundManager;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IInlineGraphicElement;
	import org.apache.royale.textLayout.elements.IListItemElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.Direction;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.IListMarkerFormat;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.ListStylePosition;

	public class TextLineUtil
	{
		/** @private */
		static public function findNumberLine(textLine:ITextLine):ITextLine
		{
			return textLine.numberLine;
			// if (textLine == null)
			// 	return null;
			// // not always going to be a numberLine - listStyleType may be "none"
			// // have to hunt for it because inlinegraphics get pushed at the beginning
			// // risk here is that clients decorate TextLines with other TextLines.
			// for (var idx:int = 0; idx < textLine.numElements; idx++)
			// {
			// 	var numberLine:ITextLine = textLine.getElementAt(idx) as ITextLine;
			// 	if (numberLine && (numberLine.userData is NumberLineUserData))
			// 		break;
			// }
			// return numberLine;
		}

		/** @private */
		static public function getNumberLineListStylePosition(numberLine:ITextLine):String
		{
			return (numberLine.userData as NumberLineUserData).listStylePosition;
		}

		/** @private */
		static public function getNumberLineInsideLineWidth(numberLine:ITextLine):Number
		{
			return (numberLine.userData as NumberLineUserData).insideLineWidth;
		}

		/** @private */
		static public function getNumberLineSpanFormat(numberLine:ITextLine):ITextLayoutFormat
		{
			return (numberLine.userData as NumberLineUserData).spanFormat;
		}

		/** @private */
		static public function getNumberLineParagraphDirection(numberLine:ITextLine):String
		{
			return (numberLine.userData as NumberLineUserData).paragraphDirection;
		}

		/** @private */
		static public function setListEndIndent(numberLine:ITextLine, listEndIndent:Number):void
		{
			(numberLine.userData as NumberLineUserData).listEndIndent = listEndIndent;
		}

		/** @private */
		static public function getListEndIndent(numberLine:ITextLine):Number
		{
			return (numberLine.userData as NumberLineUserData).listEndIndent;
		}

		/** @private */
		static public function setNumberLineBackground(numberLine:ITextLine, background:IBackgroundManager):void
		{
			(numberLine.userData as NumberLineUserData).backgroundManager = background;
		}

		/** @private */
		static public function getNumberLineBackground(numberLine:ITextLine):IBackgroundManager
		{
			return (numberLine.userData as NumberLineUserData).backgroundManager;
		}

		/** @private */
		static public function initializeNumberLinePosition(numberLine:ITextLine, listItemElement:IListItemElement, curParaElement:IParagraphElement, totalWidth:Number):void
		{
			// use the listStylePosition on the ListItem (not the list)
			var listMarkerFormat:IListMarkerFormat = listItemElement.computedListMarkerFormat();
			var paragraphFormat:ITextLayoutFormat = curParaElement.computedFormat;
			// only applies on outside list markers
			var listEndIndent:Number = listMarkerFormat.paragraphEndIndent === undefined || listItemElement.computedFormat.listStylePosition == ListStylePosition.INSIDE ? 0 : (listMarkerFormat.paragraphEndIndent == FormatValue.INHERIT ? paragraphFormat.paragraphEndIndent : listMarkerFormat.paragraphEndIndent);

			TextLineUtil.setListEndIndent(numberLine, listEndIndent);

			// no more work needed for OUTSIDE positioning - its all done in the applyTextAlign code
			if (listItemElement.computedFormat.listStylePosition == ListStylePosition.OUTSIDE)
			{
				numberLine.x = numberLine.y = 0;
				return;
			}

			var bp:String = curParaElement.getTextFlow().computedFormat.blockProgression;
			var numberLineWidth:Number = TextLineUtil.getNumberLineInsideLineWidth(numberLine);

			if (bp == BlockProgression.TB)
			{
				if (paragraphFormat.direction == Direction.LTR)
					numberLine.x = -numberLineWidth;
				else
					numberLine.x = totalWidth + numberLineWidth - numberLine.textWidth;
				numberLine.y = 0;	// assumes same baseline as parent!!
			}
			else
			{
				if (paragraphFormat.direction == Direction.LTR)
					numberLine.y = -numberLineWidth;
				else
					numberLine.y = totalWidth + numberLineWidth - numberLine.textWidth;
				numberLine.x = 0;	// assumes same baseline as parent!!
			}
		}

		/** @private 
		 * Scan through the format runs within the line, and figure out what the typographic ascent (i.e. ascent relative to the 
		 * Roman baseline) for the overall line is. Normally it is the distance between the Roman and Ascent baselines, 
		 * but it may be adjusted upwards by the width/height of the GraphicElement.
		 */
		static public function getTextLineTypographicAscent(textLine:ITextLine, elem:IFlowLeafElement, elemStart:int, textLineEnd:int):Number
		{
			CONFIG::debug
			{
				assert(!elem || elemStart == elem.getAbsoluteStart(), "bad elemStart passed to getTextLineTypographicAscent"); }
			var rslt:Number = textLine.getBaselinePosition(org.apache.royale.text.engine.TextBaseline.ROMAN) - textLine.getBaselinePosition(org.apache.royale.text.engine.TextBaseline.ASCENT);

			if (textLine.hasGraphicElement)
			{
				for (;;)
				{
					if (elem is IInlineGraphicElement)
						rslt = Math.max(rslt, IInlineGraphicElement(elem).getTypographicAscent(textLine));
					elemStart += elem.textLength;
					if (elemStart >= textLineEnd)
						break;
					elem = elem.getNextLeaf();
					CONFIG::debug
					{
						assert(elem != null, "bad nextLeaf"); }
				}
			}
			return rslt;
		}

	}
}
