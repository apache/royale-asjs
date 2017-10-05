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
package org.apache.royale.textLayout.compose
{
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.Float;
	import org.apache.royale.textLayout.formats.VerticalAlign;

	

	
	/** @private
	 * Adjust line positions according to verticalAlign settings.  Vertical alignment is perpendicular
	 * to the linebreak direction.
	 */
	public final class VerticalJustifier
	{
		[ ArrayElementType("org.apache.royale.textLayout.compose.IVerticalJustificationLine") ] 
		/** Vertical justify the subset of lines from startIndext to startIndex to numLines according to the rule specified by verticalAlignAttr.  
		 * The assumption is that they are all the lines in a single column of cont. 
		 * @see text.formats.VerticalAlign
		 * @return adjustment applied to the first line in the column.
		 * */
		static public function applyVerticalAlignmentToColumn(controller:IContainerController, verticalAlignAttr:String, lines:Array, startIndex:int, numLines:int,beginFloatIndex:int,endFloatIndex:int):Number
		{
			// var helper:IVerticalAdjustmentHelper;
			var helper:Object;
			if (controller.rootElement.computedFormat.blockProgression == BlockProgression.RL)
				helper = new RL_VJHelper(controller);
			else
				helper = new TB_VJHelper(controller);
				
			CONFIG::debug { assert(startIndex + numLines <= lines.length && numLines > 0,"applyVerticalAlignmentToColumn: bad indices"); }
									
			var i:int;
			var rslt:Number;
			
			switch(verticalAlignAttr) 
			{
				case VerticalAlign.MIDDLE:
				case VerticalAlign.BOTTOM:
					var lastLine:IVerticalJustificationLine = lines[(startIndex + numLines) - 1];
					var bottom:Number = helper.getBottom(lastLine, controller, beginFloatIndex, endFloatIndex);
					rslt = (verticalAlignAttr == VerticalAlign.MIDDLE) ? helper.computeMiddleAdjustment(bottom) : helper.computeBottomAdjustment(bottom);
					for (i = startIndex; i < startIndex + numLines; i++)	// Adjust line positions
						helper.applyAdjustment(lines[i]);
					for (var floatIndex:int = beginFloatIndex; floatIndex < endFloatIndex; floatIndex++)	// Adjust float positions
					{
						var floatInfo:FloatCompositionData = controller.getFloatAt(floatIndex);
						if (floatInfo.floatType != Float.NONE)
							helper.applyAdjustmentToFloat(floatInfo);	
					}
					break;
				case VerticalAlign.JUSTIFY:
					rslt = helper.computeJustifyAdjustment(lines, startIndex, numLines);
					helper.applyJustifyAdjustment(lines, startIndex, numLines);
					break;
			}

			//for (i = startIndex; i < startIndex + numLines; i++)
			//	trace("x=", sc[i].x, "y=", sc[i].y, "yAdj=", yAdj);
			return rslt;
		}
	}
}

import org.apache.royale.textLayout.compose.FloatCompositionData;
import org.apache.royale.textLayout.compose.IVerticalJustificationLine;
import org.apache.royale.textLayout.compose.ITextFlowLine;
import org.apache.royale.textLayout.container.IContainerController;
import org.apache.royale.textLayout.elements.IInlineGraphicElement;
import org.apache.royale.textLayout.formats.Float;

// interface IVerticalAdjustmentHelper
// {
// 	function getBottom(line:IVerticalJustificationLine, controller:IContainerController, beginFloat:int, endFloat:int):Number;
	
// 	function computeMiddleAdjustment(bottom:Number):Number;
// 	function applyAdjustment(line:IVerticalJustificationLine):void;
// 	function applyAdjustmentToFloat(floatInfo:FloatCompositionData):void;
	
// 	function computeBottomAdjustment(bottom:Number):Number;
	
// 	function computeJustifyAdjustment(lineArray:Array, firstLine:int, numLines:int):Number;
// 	function applyJustifyAdjustment(lineArray:Array, firstLine:int, numLines:int):void;
// }

class TB_VJHelper/* implements IVerticalAdjustmentHelper*/
{
	

	
	private var _textFrame:IContainerController;
	private var adj:Number;
	
	public function TB_VJHelper(tf:IContainerController):void
	{
		_textFrame = tf;
	}
	
	public function getBottom(line:IVerticalJustificationLine, controller:IContainerController, beginFloat:int, endFloat:int):Number
	{
		var maxBottom:Number = getBaseline(line) + line.descent;
		for (var i:int = beginFloat; i < endFloat; ++i)
		{
			var floatInfo:FloatCompositionData = controller.getFloatAt(i);
			if (floatInfo.floatType != Float.NONE)
			{
				var ilg:IInlineGraphicElement = controller.rootElement.findLeaf(floatInfo.absolutePosition) as IInlineGraphicElement;
				maxBottom = Math.max(maxBottom, floatInfo.y + ilg.elementHeightWithMarginsAndPadding());
			}
		}
		return maxBottom;
	}
	
	public function getBottomOfLine(line:IVerticalJustificationLine):Number
	{
		return getBaseline(line) + line.descent;
	}
	
	private function getBaseline(line:IVerticalJustificationLine):Number
	{
		if (line is ITextFlowLine)
			return line.y + line.ascent;
		else
			return line.y;
	}
	
	private function setBaseline(line:IVerticalJustificationLine, pos:Number):void
	{
		if (line is ITextFlowLine)
			line.y = pos - line.ascent;
		else
			line.y = pos;
	}
	
	// half of the available adjustment added to each y to shift the lines half way down the frame
	public function computeMiddleAdjustment(contentBottom:Number):Number
	{
		var frameBottom:Number = _textFrame.compositionHeight - Number(_textFrame.getTotalPaddingBottom());
		adj = (frameBottom - contentBottom) / 2;
		if (adj < 0)
			adj = 0; // no space available to redistribute
		return adj;
	}
	// the baseline of the last line should be at the bottom of the frame - paddingBottom.
	public function computeBottomAdjustment(contentBottom:Number):Number
	{
		var frameBottom:Number = _textFrame.compositionHeight - Number(_textFrame.getTotalPaddingBottom());
		adj = frameBottom - contentBottom;
		if (adj < 0)
			adj = 0; // no space available to redistribute
		return adj;
	}

	public function applyAdjustment(line:IVerticalJustificationLine):void
	{
		line.y = line.y + adj;
	}
	
	public function applyAdjustmentToFloat(floatInfo:FloatCompositionData):void
	{
		floatInfo.y += adj;
	}
	
	// one line: untouched, two lines: first line untouched and descent of last line at the bottom of the frame, 
	// and more than two lines: line spacing increased proportionally, with first line untouched and descent of last line at the bottom of the frame
	[ ArrayElementType("org.apache.royale.textLayout.compose.IVerticalJustificationLine") ]
	public function computeJustifyAdjustment(lineArray:Array, firstLineIndex:int, numLines:int):Number
	{
		adj = 0;
		
		if (numLines == 1)
		{
			return 0;	// do nothing
		}
		
		// first line unchanged	
		var firstLine:IVerticalJustificationLine = lineArray[firstLineIndex];
		var firstBaseLine:Number =  getBaseline(firstLine);

		// descent of the last line on the bottom of the frame	
		var lastLine:IVerticalJustificationLine = lineArray[firstLineIndex + numLines - 1];
		var frameBottom:Number = _textFrame.compositionHeight - Number(_textFrame.getTotalPaddingBottom());
		var allowance:Number = frameBottom - getBottomOfLine(lastLine);
		if (allowance < 0)
		{
			return 0; // Some text scrolled out; don't justify
		}
		var lastBaseLine:Number = getBaseline(lastLine); 
	
		adj = allowance/(lastBaseLine - firstBaseLine); // multiplicative factor by which the space between consecutive lines is increased 
		return adj;
	}
	
	[ ArrayElementType("org.apache.royale.textLayout.compose.IVerticalJustificationLine") ]
	public function applyJustifyAdjustment(lineArray:Array, firstLineIndex:int, numLines:int):void
	{ 
		if (numLines == 1 || adj == 0)
			return;	// do nothing
			
		var firstLine:IVerticalJustificationLine = lineArray[firstLineIndex];
		var prevBaseLine:Number = getBaseline(firstLine);
		var prevBaseLineUnjustified:Number = prevBaseLine;
		
		var line:IVerticalJustificationLine;
		var currBaseLine:Number;
		var currBaseLineUnjustified:Number;
		
		for (var i:int = 1; i < numLines; i++)
		{
			line = lineArray[i + firstLineIndex];
			currBaseLineUnjustified = getBaseline(line);
			
			// Space between consecutive baselines scaled up by the calculated factor
			currBaseLine = prevBaseLine  + (currBaseLineUnjustified - prevBaseLineUnjustified)*(1 + adj);
			setBaseline(line, currBaseLine);
			
			prevBaseLineUnjustified = currBaseLineUnjustified;
			prevBaseLine = currBaseLine;
		}
	}
}

class RL_VJHelper/* implements IVerticalAdjustmentHelper*/
{
	


	private var _textFrame:IContainerController;
	private var adj:Number = 0;
	
	public function RL_VJHelper(tf:IContainerController):void
	{
		_textFrame = tf;
	}
	
	public function getBottom(lastLine:IVerticalJustificationLine, controller:IContainerController, beginFloat:int, endFloat:int):Number
	{
		var frameWidth:Number = _textFrame.compositionWidth - Number(_textFrame.getTotalPaddingLeft());
		var maxLeft:Number = (frameWidth + lastLine.x - lastLine.descent);
		for (var i:int = beginFloat; i < endFloat; ++i)
		{
			var floatInfo:FloatCompositionData = controller.getFloatAt(i);
			if (floatInfo.floatType != Float.NONE)
				maxLeft = Math.min(maxLeft, floatInfo.x + frameWidth);
		}
		return maxLeft;
	}
	
	// half of the available adjustment added to each x to shift the lines half way left across the frame
	public function computeMiddleAdjustment(contentLeft:Number):Number
	{
		adj = contentLeft / 2;
		if (adj < 0)
			adj = 0; // no space available to redistribute
		return -adj;
	}
	// the baseline of the last line should be at the bottom of the frame - paddingLeft.
	public function computeBottomAdjustment(contentLeft:Number):Number
	{
		adj = contentLeft;
		if (adj < 0)
			adj = 0; // no space available to redistribute
		return -adj;
	}
	
	public function applyAdjustment(line:IVerticalJustificationLine):void
	{
		line.x = (line.x - adj);
	}
	
	public function applyAdjustmentToFloat(floatInfo:FloatCompositionData):void
	{
		floatInfo.x -= adj;
	}
	
	// one line: untouched, two lines: first line untouched and descent of last line at the bottom of the frame, 
	// and more than two lines: line spacing increased proportionally, with first line untouched and descent of last line at the bottom of the frame
	[ ArrayElementType("org.apache.royale.textLayout.compose.IVerticalJustificationLine") ]
	public function computeJustifyAdjustment(lineArray:Array, firstLineIndex:int, numLines:int):Number
	{ 
		adj = 0;
		
		if (numLines == 1)
			return 0;	// do nothing
			
		// first line unchanged
		var firstLine:IVerticalJustificationLine = lineArray[firstLineIndex];
		var firstBaseLine:Number =  firstLine.x;
		
		// descent of the last line on the left of the frame	
		var lastLine:IVerticalJustificationLine = lineArray[firstLineIndex + numLines - 1];
		var frameLeft:Number =  Number(_textFrame.getTotalPaddingLeft()) - _textFrame.compositionWidth;
		var allowance:Number = (lastLine.x - lastLine.descent) - frameLeft;
		if (allowance < 0)
		{
			return 0; // Some text scrolled out; don't justify
		}
		var lastBaseLine:Number = lastLine.x;  
		
		adj = allowance/(firstBaseLine - lastBaseLine);  // multiplicative factor by which the space between consecutive lines is increased 
		return -adj;
	}
	
	[ ArrayElementType("org.apache.royale.textLayout.compose.IVerticalJustificationLine") ]
	public function applyJustifyAdjustment(lineArray:Array, firstLineIndex:int, numLines:int):void
	{
		if (numLines == 1 || adj == 0)
			return;	// do nothing
			
		var firstLine:IVerticalJustificationLine = lineArray[firstLineIndex];
		var prevBaseLine:Number = firstLine.x;
		var prevBaseLineUnjustified:Number = prevBaseLine;
		
		var line:IVerticalJustificationLine;
		var currBaseLine:Number;
		var currBaseLineUnjustified:Number;
		
		for (var i:int = 1; i < numLines; i++)
		{
			line = lineArray[i + firstLineIndex];
			currBaseLineUnjustified = line.x;
			
			// Space between consecutive baselines scaled up by the calculated factor
			currBaseLine = prevBaseLine - (prevBaseLineUnjustified - currBaseLineUnjustified)*(1 + adj);
			line.x = currBaseLine;
			
			prevBaseLineUnjustified = currBaseLineUnjustified;
			prevBaseLine = currBaseLine;
		}		
	}
	
}
