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
	import org.apache.royale.textLayout.compose.utils.NumberlineUtil;
	import org.apache.royale.textLayout.compose.utils.TextLineUtil;
	import org.apache.royale.text.engine.Constants;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.debug.Debugging;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.Direction;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.VerticalAlign;

	


	// [ExcludeClass]
	/** Keeps track of internal state during composition. 
	 * 
	 * This is the simpler version, used when there are no floats, no wraps, no columns.
	 * @private
	 */
	public class SimpleCompose extends BaseCompose implements ISimpleCompose	{
		// reusable scratch TextFlowLine
		protected var workingLine:ITextFlowLine = new TextFlowLine(null, null);
		
		// resulting TextLines
		private var _lines:Array;
		
		// scratch aligns for VJ
		private var _vjLines:Array;
		
		// for figuring out when to do VJ
		private var vjBeginLineIndex:int = 0;
		private var vjDisableThisParcel:Boolean = false;
		private var vjType:String;
		
		// accumulator for absolute start computation to support truncation 
		private var _totalLength:Number;
		
		/** Constructor. */
		public function  SimpleCompose()
		{	
			super();
			_lines = new Array();
			_vjLines = new Array();
		}
		
		/** @private */
		protected override function createParcelList():ParcelList
		{
			return ParcelList.getParcelList();
		}
		/** @private */
		protected override function releaseParcelList(list:ParcelList):void
		{
			ParcelList.releaseParcelList(list);
		}	

		protected override function  initializeForComposer(composer:IFlowComposer, composeToPosition:int, controllerStartIndex:int, controllerEndIndex:int):void
		{
			// Always compose from the start of the flow
			_startController = composer.getControllerAt(0);
			_startComposePosition = 0;
			super.initializeForComposer(composer, composeToPosition, 0, controllerEndIndex);
			
			// vj support
			_vjLines.splice(0);
			vjBeginLineIndex = 0;
			vjDisableThisParcel = false;
			vjType =_startController.computedFormat.verticalAlign;
		}

		/** @private */
		public override function composeTextFlow(textFlow:ITextFlow, composeToPosition:int, controllerEndIndex:int):int
		{
			_flowComposer = textFlow.flowComposer as IFlowComposer;
			_curLine = workingLine;
			CONFIG::debug { assert (_curLine != null, "_curLine is null"); }
			// empty out lines array
			_lines.splice(0);
			// accumulator initialization
			_totalLength = 0;
			
			return super.composeTextFlow(textFlow, composeToPosition, controllerEndIndex);
		}
		
 		override protected function doVerticalAlignment(canVerticalAlign:Boolean,nextParcel:Parcel):void
 		{
			var vjParcel:Parcel = parcelList.currentParcel;

			if (canVerticalAlign && vjType != VerticalAlign.TOP && vjBeginLineIndex != _lines.length &&  !vjDisableThisParcel)
			{
				var controller:IContainerController = _curParcel.controller;
				var beginFloatIndex:int = 0;
				var endFloatIndex:int = 0;
				if (controller.numFloats > 0)
				{
					beginFloatIndex = controller.findFloatIndexAtOrAfter(_curParcelStart);
					endFloatIndex = controller.findFloatIndexAfter(_curElementStart + _curElementOffset);
				}
				applyVerticalAlignmentToColumn(vjParcel.controller,vjType,_vjLines,0,_vjLines.length, beginFloatIndex, endFloatIndex);
			}

			_vjLines.splice(0);
			vjBeginLineIndex = _lines.length;
			vjDisableThisParcel = false;
			if (nextParcel)
				vjType = nextParcel.controller.computedFormat.verticalAlign;
 		}
 		
		// all lines are visible in the factory
		override protected function isLineVisible(textLine:ITextLine):Boolean
		{ return textLine != null; }
		
		/** Called when we are finished composing a line. Handler for derived classes to override default behavior.  */
		override protected function endLine(textLine:ITextLine):void
		{
			super.endLine(textLine);
			
			_curLine.createShape(_blockProgression, textLine);
			
			if (textFlow.backgroundManager)
				textFlow.backgroundManager.finalizeLine(_curLine);
				
			textLine.userData = _totalLength; 		// store absolute start position in the userData field
			_totalLength += textLine.rawTextLength; // update length accumulator
			_lines.push(textLine);
			if (vjType != VerticalAlign.TOP)
				_vjLines.push(new VJHelper(textLine,_curLine.height));
				
			commitLastLineState(_curLine);	
		}

		public function get textFlow():ITextFlow
		{ return _textFlow; }
		
		private var _resetLineHandler:Function;
		
		/** Callback to the client to reset a line when its being rebroken */
		public function get resetLineHandler():Function
		{ return _resetLineHandler; }
		public function set resetLineHandler(val:Function):void
		{ _resetLineHandler = val; }
		
		/** @private */
		protected override function resetLine(textLine:ITextLine):void
		{
			super.resetLine(textLine);
			if (_resetLineHandler != null)
				_resetLineHandler(textLine);
		}
		
		/** @private */
		protected override function composeNextLine():ITextLine
		{
			CONFIG::debug { assert(!_previousLine || _previousLine.validity == "valid","Bad prevline: "+Debugging.getIdentity(_previousLine)); }
			
			var numberLine:ITextLine;
			// create numberLine if in a listElement
			if (_listItemElement && _listItemElement.getAbsoluteStart() == _curElementStart+_curElementOffset)
			{
				var isRTL:Boolean = _curParaElement.computedFormat.direction == Direction.RTL;
				numberLine = NumberlineUtil.createNumberLine(_listItemElement, _curParaElement, _flowComposer.swfContext, isRTL ? _parcelList.rightMargin : _parcelList.leftMargin);				
				pushInsideListItemMargins(numberLine);
			}
			
			// space to palce a line?			
			if (!_parcelList.getLineSlug(_lineSlug, 0, 0, _textIndent, _curParaFormat.direction == Direction.LTR))
				return null;
			
			var textLine:ITextLine;
			
			for (;;) 
			{
				for (;;)
				{	
					// generate new line
					CONFIG::debug { assert(!_parcelList.atEnd(), "failing to stop"); }
					CONFIG::debug { assert(_curElement is IFlowLeafElement, "element must be leaf before calling composeLine"); }
					
					textLine = createTextLine(_lineSlug.width, !_lineSlug.wrapsKnockOut /* don't allow emergency breaks next to floats or padded elements */);
					if (textLine)
						break;

					// force advance within the parcel to the next wider slug, or (if there are no more) to the next parcel
					var newDepth:Number = _curParcel.findNextTransition(_lineSlug.depth);
					if (newDepth < Number.MAX_VALUE)
					{
						_parcelList.addTotalDepth(newDepth - _lineSlug.depth);
						_parcelList.getLineSlug(_lineSlug, 0, 1, _textIndent, _curParaFormat.direction == Direction.LTR);
					}
					else
					{
						advanceToNextParcel();
						if (!_parcelList.atEnd())
							if (_parcelList.getLineSlug(_lineSlug, 0, 1, _textIndent, _curParaFormat.direction == Direction.LTR))
								continue;
						popInsideListItemMargins(numberLine);
						return null;
					}
				}

				
				// updates _lineSlug
				if (fitLineToParcel(textLine, true, numberLine))	// TODO!!!!!!
					break;		// we have a good line
				if (resetLineHandler != null)
					resetLineHandler(textLine);
				if (_parcelList.atEnd())		// keep going
				{
					popInsideListItemMargins(numberLine);
					return null;
				}
			}
			
			popInsideListItemMargins(numberLine);

			CONFIG::debug { assert(textLine != null, "textLine != null"); }		
			return textLine;
		}
        
        /** @private */
        public function swapLines(lines:Array):Array
        {
        	var current:Array = _lines;
        	_lines = lines;
        	return current;
        }

		/** Final adjustment on the content bounds. */
 		override protected function finalParcelAdjustment(controller:IContainerController):void
 		{
			CONFIG::debug { assert(controller.absoluteStart == 0,"SimpleCompose: multiple controllers not supported"); }

			var minX:Number = Constants.MAX_LINE_WIDTH;
 			var minY:Number = Constants.MAX_LINE_WIDTH;
 			var maxX:Number = -Constants.MAX_LINE_WIDTH;
			
			var verticalText:Boolean = _blockProgression == BlockProgression.RL;
			
			if (!isNaN(_parcelLogicalTop))
			{
				if (verticalText)
					maxX = _parcelLogicalTop;
				else
					minY = _parcelLogicalTop;
			}
			
			if (!_measuring)
			{
				if (verticalText)
					minY = _accumulatedMinimumStart;
				else
					minX = _accumulatedMinimumStart;			
			}
			else
			{
	 			var textLine:ITextLine;
	 			var startPos:int = 0;
				
				var firstLineAdjust:Number;
				var effectiveIndent:Number;
				var edgeAdjust:Number;
				var curPara:IParagraphElement;
				var curParaFormat:ITextLayoutFormat;
				var paddingVerticalAdjust:Number = 0;		// logical vertical adjustment due to padding on paragraph & divs
				var paddingHorizontalAdjust:Number = 0;		// logical horizontal adjustment due to padding on paragraph & divs
				var previousParagraph:IParagraphElement = null;
	
				for each (textLine in _lines)
				{
					var leaf:IFlowLeafElement = controller.textFlow.findLeaf(startPos);
					var para:IParagraphElement = leaf.getParagraph();
					if (para != previousParagraph)
					{
						// Recalculate padding values for the new paragraph
						paddingVerticalAdjust = 0;
						paddingHorizontalAdjust = 0;
						var fge:IFlowGroupElement = para;
						while (fge && fge.parent)
						{
							if (verticalText)
							{
								paddingVerticalAdjust += (fge.getEffectivePaddingRight() + fge.getEffectiveBorderRightWidth() + fge.getEffectiveMarginRight());
								paddingHorizontalAdjust += (fge.getEffectivePaddingTop() + fge.getEffectiveBorderTopWidth() + fge.getEffectiveMarginTop());
							}
							else
							{
								paddingVerticalAdjust += (fge.getEffectivePaddingTop() + fge.getEffectiveBorderTopWidth() + fge.getEffectiveMarginTop());
								paddingHorizontalAdjust += (fge.getEffectivePaddingLeft() + fge.getEffectiveBorderLeftWidth() + fge.getEffectiveMarginLeft());
							}
							fge = fge.parent;
						}
						previousParagraph = para;
					}
	
	            	// Check the logical vertical dimension first
	            	// If the lines have children, they may be inlines. The origin of the ITextLine is the baseline, 
	            	// which does not include the ascent of the inlines or the text. So we have to factor that in.
					// var verticalAdjust:Number = verticalText ? textLine.descent : textLine.ascent;
					var inlineAscent:Number = 0;
					if (textLine.numElements > 0)		// adjustjust logical vertical coord to take into account inlines
					{
						var leafStart:int = leaf.getAbsoluteStart();
						inlineAscent = TextLineUtil.getTextLineTypographicAscent(textLine, leaf, leafStart, startPos + textLine.rawTextLength);
					}
	
					// Figure out the logical horizontal adjustment
					CONFIG::debug { assert(curPara != para, "found it"); }
					if (curPara != para)
					{
						curParaFormat = para.computedFormat;
						if (curParaFormat.direction == Direction.LTR)
						{
							firstLineAdjust = Math.max(curParaFormat.textIndent, 0);
							effectiveIndent = curParaFormat.paragraphStartIndent;
						}
						else
						{
							firstLineAdjust = 0;
							effectiveIndent = curParaFormat.paragraphEndIndent;
						}
					}
					effectiveIndent += paddingHorizontalAdjust;
					
					edgeAdjust = textLine.textBlockBeginIndex == 0 ? effectiveIndent + firstLineAdjust : effectiveIndent;
					edgeAdjust = verticalText ? textLine.y - edgeAdjust : textLine.x - edgeAdjust;
					
					var numberLine:ITextLine = TextLineUtil.findNumberLine(textLine);
					
					if (numberLine)
					{
						var numberLineStart:Number = verticalText ? numberLine.y+textLine.y : numberLine.x+textLine.x;
						edgeAdjust = Math.min(edgeAdjust,numberLineStart);
					}
					
					if (verticalText)
					{
						minY = Math.min(edgeAdjust, minY);
			            maxX = Math.max(textLine.x + Math.max(inlineAscent,textLine.ascent) + paddingVerticalAdjust, maxX);
					}
					else
					{
						minX = Math.min(edgeAdjust, minX);
						if (inlineAscent < textLine.ascent)
							inlineAscent = textLine.ascent;
			           	minY = Math.min(textLine.y - (inlineAscent + paddingVerticalAdjust), minY);
			  		}
			  		startPos += textLine.rawTextLength;
   				}
			}
			
            // Don't make adjustments for tiny fractional values.
            /*if (minX != _parcelLeft && Math.abs(minX-_parcelLeft) >= 1)
         		_parcelLeft = minX;
            if (maxX != _parcelRight && Math.abs(maxX-_parcelRight) >= 1)
         		_parcelRight = maxX;
         	if (minY != _parcelTop && Math.abs(minY-_parcelTop) >= 1)
           		_parcelTop = minY;*/
			if (minX != Constants.MAX_LINE_WIDTH && Math.abs(minX-_parcelLeft) >= 1)
				_parcelLeft = minX;
			if (maxX != -Constants.MAX_LINE_WIDTH && Math.abs(maxX-_parcelRight) >= 1)
				_parcelRight = maxX;
			if (minY != Constants.MAX_LINE_WIDTH && Math.abs(minY-_parcelTop) >= 1)
				_parcelTop = minY;

 		}		
		
		public override function releaseAnyReferences():void
		{
			super.releaseAnyReferences();
			workingLine.initialize(null,0,0,0,0,null);
			resetLineHandler = null;
			// parcelList.releaseAnyReferences();
		}

		public function get lines():Array
		{
			return _lines;
		}
	}
}
import org.apache.royale.text.engine.ITextLine;
import org.apache.royale.textLayout.compose.IVerticalJustificationLine;

class VJHelper implements IVerticalJustificationLine
{
	private var _line:ITextLine;
	private var _height:Number;

	public function VJHelper(line:ITextLine,h:Number)
	{
		_line = line;
		_height = h;
	}
	public function get x():Number
	{ return _line.x; }
	public function set x(val:Number):void
	{ _line.x = val; }
		
	public function get y():Number
	{ return _line.y; }
	public function set y(val:Number):void
	{ _line.y = val; }
		
	public function get ascent():Number
	{ return _line.ascent; }
	public function get descent():Number
	{ return _line.descent; }
	public function get height():Number
	{
		return _height;
	}

	public function set height(value:Number):void
	{
	}
}
