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
	import org.apache.royale.textLayout.elements.ConfigSettings;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.compose.utils.TextLineUtil;
	import org.apache.royale.text.engine.Constants;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.Direction;
	import org.apache.royale.textLayout.formats.Float;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.VerticalAlign;
	import org.apache.royale.textLayout.utils.Twips;
	


	/** Keeps track of internal state during composition. 
	 * 
	 * This is the simpler version, used when there are no floats, no wraps, no columns.
	 * @private
	 */
	public class ComposeState extends BaseCompose implements IComposeState	{
		/** Index of current line */
		protected var _curLineIndex:int;	
		
		// for figuring out when to do VJ
		protected var vjBeginLineIndex:int;
		protected var vjDisableThisParcel:Boolean;
		
		protected var _useExistingLine:Boolean;
		
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
		
		/**
		 *  @private
		 */
		public override function composeTextFlow(textFlow:ITextFlow, composeToPosition:int, controllerEndIndex:int):int
		{
			CONFIG::debug { assert(textFlow.flowComposer is IFlowComposer,"ComposeState.composeTextFlow requires textFlow with a StandardFlowComposer"); }
			_curLineIndex    = -1;		// unitialized: this will get set in composeParagraphElement
			_curLine = null;
					
			vjBeginLineIndex = 0;
			vjDisableThisParcel = false;
			
 			return super.composeTextFlow(textFlow, composeToPosition, controllerEndIndex);
		}
		
		protected override function initializeForComposer(composer:IFlowComposer,composeToPosition:int,controllerStartIndex:int, controllerEndIndex:int):void
		{
			           
			// start composing from the first damaged position. Update internal composition state as if we'd composed to here already.
			_startComposePosition = composer.damageAbsoluteStart;
			if (controllerStartIndex == -1)
			{
				var controllerIndex:int = composer.findControllerIndexAtPosition(_startComposePosition);
				if (controllerIndex == -1)
				{
					controllerIndex = composer.numControllers-1;
					// if off the end in the overflow - find the last non-zero controller
					while (controllerIndex != 0 && composer.getControllerAt(controllerIndex).textLength == 0)
						controllerIndex--;
				}
			}
			
			// if damage is in overflow after last controller we could get smart about that
			_startController = composer.getControllerAt(controllerIndex);
			CONFIG::debug { assert(_startController != null,"Bad start start controller"); }

			// Disable partial container composition if we have to vertically align the lines.
			if (_startController.computedFormat.verticalAlign != VerticalAlign.TOP)
				_startComposePosition = _startController.absoluteStart; 

			// Comment this line in to disable composing from the middle of a container.
		//	_startComposePosition = _startController.absoluteStart; 

			super.initializeForComposer(composer,composeToPosition, controllerIndex, controllerEndIndex);
		}
		
		/** @private */
		protected override function composeInternal(composeRoot:IFlowGroupElement,absStart:int):void
		{
			super.composeInternal(composeRoot,absStart);
			
			// mark all overflow lines as not being in any container or column
			if (_curElement)
			{
				var lineIndex:int = _curLineIndex;
				CONFIG::debug { assert(_curLineIndex == _flowComposer.findLineIndexAtPosition(_curElementStart + _curElementOffset),"bad _curLineIndex"); }
				while (lineIndex < _flowComposer.numLines)
					_flowComposer.getLineAt(lineIndex++).setController(null,-1);
			}
		}

 		override protected function doVerticalAlignment(canVerticalAlign:Boolean,nextParcel:Parcel):void
		{
			if (canVerticalAlign && _curParcel && vjBeginLineIndex != _curLineIndex &&  !vjDisableThisParcel)
			{
				var controller:IContainerController = _curParcel.controller;
				var vjtype:String = controller.computedFormat.verticalAlign;
				// Don't allow vertical justification if the line contains floats, since we don't support recomposing when lines are moved.
				if (vjtype == VerticalAlign.JUSTIFY)
				{
					for  (var i:int = controller.numFloats - 1; i >= 0 && canVerticalAlign; --i)
					{
						var floatInfo:FloatCompositionData = controller.getFloatAt(i);
						if (floatInfo.floatType != Float.NONE)
							canVerticalAlign = false;
							
					}
				}
				if (canVerticalAlign && vjtype != VerticalAlign.TOP)
				{	
					// Exclude overset lines
					var end:int = _flowComposer.findLineIndexAtPosition(_curElementStart + _curElementOffset);

					if (vjBeginLineIndex < end)
					{
						var beginFloatIndex:int = 0;
						var endFloatIndex:int = 0;
						var lines:Array = _flowComposer.lines;
						if (controller.numFloats > 0)
						{
							beginFloatIndex = controller.findFloatIndexAtOrAfter(lines[vjBeginLineIndex].absoluteStart);
							endFloatIndex = controller.findFloatIndexAfter(_curElementStart + _curElementOffset);
						}
						applyVerticalAlignmentToColumn(controller,vjtype,lines,vjBeginLineIndex,end-vjBeginLineIndex, beginFloatIndex, endFloatIndex);
					}
				}
			}
			
			// always reset these variables
			vjDisableThisParcel = false;
			vjBeginLineIndex = _curLineIndex;	
		}
		
		
		/** apply vj and adjust the parcel bounds */
		override protected function applyVerticalAlignmentToColumn(controller:IContainerController,vjType:String,lines:Array,beginIndex:int,numLines:int,beginFloatIndex:int,endFloatIndex:int):void
		{
			super.applyVerticalAlignmentToColumn(controller, vjType, lines, beginIndex, numLines, beginFloatIndex, endFloatIndex);
			
			// Reposition lines in case they got aligned after being added to _linesInView
			for each (var composedLine:Object in controller.composedLines)
			{
				if( !(composedLine is ITextLine) )
				{
					//only deal with TextLines. Not TableBlocks
					continue;
				}
				var textLine:ITextLine = composedLine as ITextLine;
				var line:ITextFlowLine = textLine.userData as ITextFlowLine;
				CONFIG::debug
				{
					for (var i:int = 0; i < _textFlow.flowComposer.numLines; ++i)
					{
						var tfl:ITextFlowLine = _textFlow.flowComposer.getLineAt(i);
						if (tfl == line)
							break;
					}
					assert(i < _textFlow.flowComposer.numLines, "Creating shape for unknown (old) line");
				}
				line.createShape(_blockProgression, textLine);
			}
		}
		
		/** Final adjustment on the content bounds. */
 		override protected function finalParcelAdjustment(controller:IContainerController):void
 		{
			CONFIG::debug { assert(_flowComposer.getLineAt(_flowComposer.findLineIndexAtPosition(_curParcelStart)).absoluteStart == _curParcelStart,"finalParcelAdjustment: bad _curParcelStart"); }

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
				var edgeAdjust:Number;
				var curPara:IParagraphElement;
				var curParaFormat:ITextLayoutFormat;
				var curParaDirection:String;
				
				for (var lineIndex:int = _flowComposer.findLineIndexAtPosition(_curParcelStart); lineIndex < _curLineIndex; lineIndex++)
	            {
					var line:ITextFlowLine = _flowComposer.getLineAt(lineIndex);
					
					// Now check the logical horizontal dimension
					CONFIG::debug { assert(line != null && line.paragraph != null, "found it");}
					
					if (line.paragraph != curPara)
					{
						curPara = line.paragraph;
						curParaFormat = curPara.computedFormat;
						curParaDirection = curParaFormat.direction;
						if (curParaDirection != Direction.LTR)
							edgeAdjust = curParaFormat.paragraphEndIndent;
					}
					
					if (curParaDirection == Direction.LTR)
						edgeAdjust = Math.max(line.lineOffset, 0);
					
					edgeAdjust = verticalText ? line.y - edgeAdjust : line.x - edgeAdjust;
					
					var numberLine:ITextLine = TextLineUtil.findNumberLine(line.getTextLine(true));
					
					if (numberLine)
					{
						var numberLineStart:Number = verticalText ? numberLine.y+line.y : numberLine.x+line.x;
						edgeAdjust = Math.min(edgeAdjust,numberLineStart);
					}
					
	             	if (verticalText)
	           			minY = Math.min(edgeAdjust, minY);
	             	else 
	           			minX = Math.min(edgeAdjust, minX);
	            }
			}
            
            // Don't make adjustments for tiny fractional values.
            if (minX != Constants.MAX_LINE_WIDTH && Math.abs(minX-_parcelLeft) >= 1)
         		_parcelLeft = minX;
            if (maxX != -Constants.MAX_LINE_WIDTH && Math.abs(maxX-_parcelRight) >= 1)
         		_parcelRight = maxX;
         	if (minY != Constants.MAX_LINE_WIDTH && Math.abs(minY-_parcelTop) >= 1)
           		_parcelTop = minY;
 		}
 			
		/**
		 *  @royaleignorecoercion org.apache.royale.textLayout.compose.IFlowComposer
		 */
		protected override function endTableBlock(block:ITextFlowTableBlock):void
		{
			super.endTableBlock(block);
			_flowComposer.addLine(block,_curLineIndex);
			
			commitLastLineState (_curLine);
			_curLineIndex++;
		}
		/** Called when we are finished composing a line. Handler for derived classes to override default behavior.  */
		/**
		 */
		override protected function endLine(textLine:ITextLine):void
		{
			super.endLine(textLine);

			if ( !_useExistingLine ) 		
				_flowComposer.addLine(_curLine,_curLineIndex);
			
			commitLastLineState (_curLine);
			_curLineIndex++;
		}		
		
		protected override function composeParagraphElement(elem:IParagraphElement, absStart:int):Boolean
		{				
			if (_curLineIndex < 0)
				_curLineIndex = _flowComposer.findLineIndexAtPosition(_curElementStart + _curElementOffset);

			return super.composeParagraphElement(elem, absStart);
		}
		
		/**
		 *  @private
		 */
		protected override function composeNextLine():ITextLine
		{			
			// mjzhang: this code adds for recompose a table row, we need to recorrect _curLineIndex parameter based on _curElementStart and _curElementOffset.
			//Harbs: I don't see a need for this now that I changed the table logic.
			//_curLineIndex = _flowComposer.findLineIndexAtPosition(_curElementStart + _curElementOffset);
			
			CONFIG::debug { assert(_curLineIndex == _flowComposer.findLineIndexAtPosition(_curElementStart + _curElementOffset),"bad _curLineIndex"); }

			// Find out how long a zero-logical height line can be in the parcel at the current position (depth). 
			// See if there is an existing line that is composed up-to-date matching the parcel width. If there is,
			// we try to reuse it, otherwise we create a new line. Once we have placed a line, we will recheck the
			// width in fitLineToParcel to make sure it fits at the (possibly changed) line height.
			var startCompose:int = _curElementStart + _curElementOffset - _curParaStart;
			var line:ITextFlowLine = _curLineIndex < _flowComposer.numLines ? _flowComposer.lines[_curLineIndex] : null;
			var useExistingLine:Boolean = line && (!line.isDamaged() || line.validity == FlowDamageType.GEOMETRY);
			if (ConfigSettings.usesDiscretionaryHyphens)
			{
				// if the line ends with a hyphen, don't use existing line because the player seems to mis-handle
				// starting the next line.
				if (useExistingLine && line.textLength > 0 &&
					line.paragraph.getCharCodeAtPosition(line.absoluteStart + line.textLength - 1) == 0xAD)
					useExistingLine = false;
			}
			var numberLine:ITextLine;
			
			// create numberLine if in a listElement
			if (_listItemElement && _listItemElement.getAbsoluteStart() == _curElementStart+_curElementOffset)
			{
				var peekLine:ITextLine;
				if (useExistingLine && (peekLine = line.peekTextLine()) != null)
				{
					// may be null
					numberLine = TextLineUtil.findNumberLine(peekLine);
				}
				else
				{
					var isRTL:Boolean = _curParaElement.computedFormat.direction == Direction.RTL;
					numberLine = NumberlineUtil.createNumberLine(_listItemElement, _curParaElement, _flowComposer.swfContext, isRTL ? _parcelList.rightMargin : _parcelList.leftMargin);
				}
				
				pushInsideListItemMargins(numberLine);
			}
			
			_parcelList.getLineSlug(_lineSlug, 0, 1, _textIndent, _curParaFormat.direction == Direction.LTR);
			
			if (useExistingLine && Twips.to(_lineSlug.width) != line.outerTargetWidthTW)
				useExistingLine = false;

			_curLine = useExistingLine ? line : null;
			var textLine:ITextLine;
			
			for (;;) 
			{
				while (!_curLine)
				{	
					useExistingLine = false;
					// generate new line
					CONFIG::debug { assert(!_parcelList.atEnd(), "failing to stop"); }
					CONFIG::debug { assert(_curElement is IFlowLeafElement, "element must be leaf before calling composeLine"); }					
					CONFIG::debug { validateLineStart(_previousLine, startCompose, _curParaElement); }
					
					textLine = createTextLine(_lineSlug.width, !_lineSlug.wrapsKnockOut /* don't allow emergency breaks next to floats or padded elements */);
					if (textLine)
						break;

					// force advance within the parcel to the next wider slug, or (if there are no more) to the next parcel
					var newDepth:Number = _curParcel.findNextTransition(_lineSlug.depth);
					if (newDepth < Number.MAX_VALUE)
					{
						_parcelList.addTotalDepth(newDepth - _lineSlug.depth);
						if (!_parcelList.getLineSlug(_lineSlug, 0, 1, _textIndent, _curParaFormat.direction == Direction.LTR))
							return null;
					}
					else 
					{
						advanceToNextParcel();
						if (!_parcelList.atEnd())
						{
							if (_parcelList.getLineSlug(_lineSlug, 0, 1, _textIndent, _curParaFormat.direction == Direction.LTR))
								continue;
						}
						popInsideListItemMargins(numberLine);
						return null;
					}						
				}
				
				// updates _lineSlug
				CONFIG::debug { assert(textLine || useExistingLine, "expected non-null textLine because we had to regenerate the line"); }
				if (!textLine)
					textLine = _curLine.getTextLine(true);
				if (fitLineToParcel(textLine, !useExistingLine, numberLine))
					break;	// we have a good line
				_curLine = null;	// keep looking
				if (_parcelList.atEnd())
				{
					popInsideListItemMargins(numberLine);
					return null;
				}
			}
			
			// Clear up user_invalid
			if (_curLine.validity == FlowDamageType.GEOMETRY)
				_curLine.clearDamage(); 
								
			_useExistingLine = useExistingLine;
			
			popInsideListItemMargins(numberLine);

			CONFIG::debug { assert(textLine != null, "textLine != null"); }			
			return textLine;
		}
		
		/** @private */
		override protected function createTextLine(
			targetWidth:Number,	// target width we're composing into
			allowEmergencyBreaks:Boolean	// true to allow words to break in the middle of narrow columns, false to force overset
			):ITextLine
        {		
			_curLine = new TextFlowLine(null, null);		// it will be initialized in BaseCompose.createTextLine
			var textLine:ITextLine = super.createTextLine(targetWidth, allowEmergencyBreaks);
			
			if (textLine)
	 			textLine.doubleClickEnabled = true;		// allow line to be the target of a double click event
			else
				_curLine = null;
 			
 			return textLine;
        }
        
        /** @private */
		CONFIG::debug private static function validateLineStart(previousLine:ITextLine, lineStart:int, paraNode:IParagraphElement):void
		{
			// If the lines have been released, don't validate
			if (lineStart != 0 && paraNode.getTextBlock().firstLine == null)
				return;
				
	       	var testStart:int = 0;
	    	var testLine:ITextLine = previousLine;
	    	while (testLine)
	    	{
				CONFIG::debug { assert(testLine.validity == "valid", "previous line in paragraph is not valid!"); }
	    		testStart += testLine.rawTextLength;
	    		testLine = testLine.previousLine;
	    	}
	    	assert(testStart == lineStart, "Bad lines");
			
      		assert(paraNode is IParagraphElement,"composeLine: paraNode must be a para"); 
			var prevLine:ITextFlowLine = previousLine ? previousLine.userData as ITextFlowLine : null;
			assert(!previousLine || prevLine != null, "prevLine null");
      		assert(!previousLine || !(prevLine.location & TextFlowLineLocation.LAST),"prevLine may not be from a different para"); 
		} 
	}
}
