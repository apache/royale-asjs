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
	import org.apache.royale.text.engine.ITextBlock;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.compose.utils.ContextUtil;
	import org.apache.royale.textLayout.compose.utils.NumberlineUtil;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.debug.Debugging;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.ConfigSettings;
	import org.apache.royale.textLayout.elements.IBackgroundManager;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IListItemElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	



	
	[Exclude(name="initializeLines",kind="method")]
	[Exclude(name="addLine",kind="method")]
	[Exclude(name="lines",kind="property")]
	[Exclude(name="debugCheckTextFlowLines",kind="method")]
	[Exclude(name="checkFirstDamage",kind="method")]
	
	/** 
	 * The FlowComposerBase class is the base class for Text Layout Framework flow composer classes, which control the 
	 * composition of text lines in ContainerController objects.
	 *
	 * <p>FlowComposerBase is a utility class that implements methods and properties that are common
	 * to several types of flow composer. Application code would not typically instantiate or use this class
	 * (unless extending it to create a custom flow composer).</p>
	 * 
	 * @see org.apache.royale.textLayout.elements.TextFlow#flowComposer
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	 
	public class FlowComposerBase
	{
				// Composition data
		[ ArrayElementType("org.apache.royale.textLayout.compose.TextFlowLine") ]
		private var _lines:Array;	
		
		/** @private */
		protected var _textFlow:ITextFlow;
		
		/** Absolute start of the damage area -- first character in the flow that is dirty and needs to be recomposed. @private */
		protected var _damageAbsoluteStart:int;
		
		/** @private */
		protected var _swfContext:ISWFContext;
		
		/** Constructor. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public function FlowComposerBase()
		{
			_lines = new Array();
			_swfContext = null;
		}
		
		/** Returns the array of lines. @private */
		public function get lines():Array
		{ return _lines; }
		
		/** 
		 * @copy IFlowComposer#getLineAt()
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		 
		public function getLineAt(index:int):ITextFlowLine
		{ return _lines[index]; }
		
		/** @copy IFlowComposer#numLines 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public function get numLines():int
		{ return _lines.length; }
		
		/** 
		* The TextFlow object to which this flow composer is attached. 
		*
		* @see org.apache.royale.textLayout.elements.TextFlow
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*/
	 	
		public function get textFlow():ITextFlow
		{ return _textFlow; }
		
		/**
		 * The absolute position immediately preceding the first element in the text
		 * flow that requires composition and updating.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		public function get damageAbsoluteStart():int
		{
			return _damageAbsoluteStart;
		}
		
		/**
		 * Initialize the lines for the TextFlow.  Creates a single ITextFlowLine with no content. @private
		 */ 
		protected function initializeLines():void
		{
			var backgroundManager:IBackgroundManager = _textFlow ? _textFlow.backgroundManager : null;
			// remove all the lines we have now - cache for reuse
			if (TextLineRecycler.textLineRecyclerEnabled)
			{
				for each (var line:ITextFlowLine in _lines)
				{
					var textLine:ITextLine = line.peekTextLine();
					if (textLine && !textLine.parent)
					{
						// releasing all textLines so release each still connected textBlock
						if (textLine.validity != "invalid")
						{
							var textBlock:ITextBlock = textLine.textBlock;
							CONFIG::debug { Debugging.traceFTECall(null,textBlock,"releaseLines",textBlock.firstLine,textBlock.lastLine); }
							textBlock.releaseLines(textBlock.firstLine,textBlock.lastLine);
						}
						textLine.userData = null;
						TextLineRecycler.addLineForReuse(textLine);
						if (backgroundManager)
							backgroundManager.removeLineFromCache(textLine);
					}
				}
			}
			_lines.splice(0);
			_damageAbsoluteStart = 0;
			
			CONFIG::debug { checkFirstDamaged(); }
		}
		
		/** Make sure that there is a ITextFlowLine for all the content - even if compose has stopped early. @private */
		protected function finalizeLinesAfterCompose():void
		{
			var line:ITextFlowLine;
			if (_lines.length == 0)
			{
				// create a new line, with damage, that covers the entire area
				line = new TextFlowLine(null,null);
				line.setTextLength(textFlow.textLength);
				_lines.push(line);
			}
			else
			{
				line = _lines[_lines.length-1];
				var lineEnd:int = line.absoluteStart + line.textLength;
				if (lineEnd < textFlow.textLength)
				{
					line = new TextFlowLine(null,null);
					line.setAbsoluteStart(lineEnd);
					line.setTextLength(textFlow.textLength-lineEnd);
					_lines.push(line);
				}
			}			
		}
		
		/** 
		 * @copy IFlowComposer#updateLengths()
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		public function updateLengths(startPosition:int,deltaLength:int):void
		{
			var MAX_VALUE:int = 2147483647;
			// no lines yet - skip it
			if (numLines == 0)
				return;
				
			var line:ITextFlowLine;	// sratch line variable
			var lineIdx:int = findLineIndexAtPosition(startPosition);
				
			var damageStart:int = MAX_VALUE;			
			if (deltaLength > 0)
			{
				if (lineIdx == _lines.length)
				{
					line = _lines[_lines.length-1];
					CONFIG::debug { assert(line.absoluteStart+line.textLength == startPosition,"updateLengths bad startIdx"); }
					line.setTextLength(line.textLength + deltaLength);
				}
				else
				{
					line = _lines[lineIdx++];
					line.setTextLength(line.textLength + deltaLength);
				}
				damageStart = line.absoluteStart;
			}
			else
			{
				var lenToDel:int = -deltaLength;
				var curPos:int = 0;
				
				while (true)
				{
					line = _lines[lineIdx];
					// An empty span following a table can cause this.
					//if(line == null)
					//	break;
					
					line.setAbsoluteStart(line.absoluteStart + lenToDel + deltaLength);
					curPos = (startPosition > line.absoluteStart ? startPosition : line.absoluteStart);
					
					var lineEndIdx:int = line.absoluteStart + line.textLength;
					var deleteChars:int = 0;
					
					if (curPos + lenToDel <= lineEndIdx)		
					{
						if (curPos == line.absoluteStart)
							deleteChars = lenToDel;				//delete from begin of line to end of selection
						else if (curPos == startPosition)
							deleteChars = lenToDel;				//delete is all included in one line
						else
						{
							CONFIG::debug { assert(false, "insertText: should never happen");  }
						}								
					}
					else //(curPos + lenToDel > lineEndIdx)		//multiline delete
					{
						if (curPos == line.absoluteStart)
							deleteChars = line.textLength; 		//delete the whole line
						else
							deleteChars = lineEndIdx-curPos;	//delete from middle of line to end of line
					}		
						
					if (curPos == line.absoluteStart && curPos + deleteChars == lineEndIdx)		//the whole line is selected
					{
						lenToDel -= deleteChars;
						_lines.splice(lineIdx,1);			//lineIdx now points to the next line
					}
					else 									//partial line
					{
						if (damageStart > line.absoluteStart)
							damageStart = line.absoluteStart;
						line.setTextLength(line.textLength - deleteChars);
						lenToDel -= deleteChars;
						lineIdx++;
					}
					CONFIG::debug { assert(lenToDel >= 0,"updateLengths deleted too much"); }
					if (lenToDel <= 0)
							break;						
				}
			}
			
			for ( ; lineIdx < _lines.length; lineIdx++)
			{
				line = _lines[lineIdx];
				if (deltaLength >= 0)
					line.setAbsoluteStart(line.absoluteStart  + deltaLength);
				else
					line.setAbsoluteStart(line.absoluteStart > -deltaLength ? line.absoluteStart+deltaLength : 0);
			}
			
			if (_damageAbsoluteStart > damageStart)
				_damageAbsoluteStart = damageStart;
		}
		
		/** 
		 * @copy IFlowComposer#damage()
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		public function damage(startPosition:int, damageLength:int, damageType:String):void
		{
			if (ConfigSettings.usesDiscretionaryHyphens)
			{
				// damage everything from the beginning.  
				// The player tends to screw up if you start
				// composition in the middle and there are lines above broken on
				// hyphens.
				damageLength += startPosition;
				startPosition = 0;
			}
			
			if (_lines.length == 0 || textFlow.textLength == 0)
				return;
				
			// This case the damageStart is at the end of the text.  This can happen if the last paragraph is deleted
			if (startPosition == textFlow.textLength)
				return;
				
			CONFIG::debug { assert(startPosition + damageLength <= textFlow.textLength, "Damaging past end of flow!"); }

            // find the line at damageStart
            var lineIndex:int = findLineIndexAtPosition(startPosition);

            // Start damaging one line before the startPosition location in case some of the first "damaged" line will fit on the previous line.
            var leaf:IFlowLeafElement = textFlow.findLeaf(startPosition);
			if (leaf && lineIndex > 0)
				lineIndex--;

			if (lines[lineIndex].absoluteStart < _damageAbsoluteStart)
				_damageAbsoluteStart = _lines[lineIndex].absoluteStart;
				
			CONFIG::debug { assert(lineIndex < _lines.length && _lines[lineIndex].absoluteStart <= startPosition + damageLength, "Missing line"); }
			
			while (lineIndex < _lines.length)
			{
				var line:ITextFlowLine = _lines[lineIndex];
				
				// Changed to >= from >, as > seemed to damage too
				// many lines when editing tables. 
				// Should verify the correctness of this.
				if (line.absoluteStart >= startPosition+damageLength)
					break;
				
				line.damage(damageType);
				lineIndex++;
			}
		}
		
		/**
		 * @copy IFlowComposer#isDamaged()
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		 
		public function isDamaged(absolutePosition:int):Boolean
		{
			// Returns true if any text from _damageAbsoluteStart through absolutePosition needs to be recomposed
			
			// no lines - damaged
			if (_lines.length == 0)
				return true;
				
			CONFIG::debug { checkFirstDamaged(); }

			return _damageAbsoluteStart <= absolutePosition && _damageAbsoluteStart != textFlow.textLength;
		}


		/**
		 * @copy IFlowComposer#isPotentiallyDamaged()
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */

		public function isPotentiallyDamaged(absolutePosition:int):Boolean
		{
			return isDamaged(absolutePosition);
		}

		/** @private */
		CONFIG::debug public function checkFirstDamaged():void
		{
			// find the line at start
			if (_lines.length == 0)
				return;
				
			var lineIndex:int = findLineIndexAtPosition(0);
			while (lineIndex < _lines.length)
			{
				if (_lines[lineIndex].isDamaged())
				{
				//	trace("is damaged");
					CONFIG::debug { assert(_lines[lineIndex].absoluteStart >= _damageAbsoluteStart, "_damageAbsoluteStart doesn't match actual line value"); } 
					return;
				}
				++lineIndex;				
			}
		//	trace("not damaged");
			return;
		}
		/** 
		 * @copy IFlowComposer#findLineIndexAtPosition()
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public function findLineIndexAtPosition(absolutePosition:int,preferPrevious:Boolean = false):int
		{	
			var lo:int = 0;
			var hi:int = _lines.length-1;
			while (lo <= hi)
			{
				var mid:int = Math.floor((lo+hi)/2);
				var line:ITextFlowLine = _lines[mid];
				if (line.absoluteStart <= absolutePosition)
				{
					if (preferPrevious)
					{
						if (line.absoluteStart + line.textLength >= absolutePosition)
							return mid;
					}
					else
					{
						if (line.absoluteStart + line.textLength > absolutePosition)
							return mid;
					}
					lo = mid+1;
				}
				else
					hi = mid-1;
			}
			return _lines.length;
		}
		
		/**
		 * @copy IFlowComposer#findLineAtPosition()
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		 
		public function findLineAtPosition(absolutePosition:int,preferPrevious:Boolean = false):ITextFlowLine
		{
			return _lines[findLineIndexAtPosition(absolutePosition,preferPrevious)];
		}
		
		/**
		 * add a new line 
		 * Add a new line to the list of composed lines for the frame. Lines are sorted
		 * by the start location, and each line has a span. The start of the next line
		 * has to match the start of the previous line + the span of the previous line.
		 * The last line needs to end at the end of the text. Therefore, when we add a
		 * new line, we may need to adjust the span and/or start locations of other lines 
		 * in the text.
		 * @private
		 */
		public function addLine(newLine:ITextFlowLine,workIndex:int):void
		{
			var MAX_VALUE:int = 2147483647;
			CONFIG::debug { assert(workIndex == findLineIndexAtPosition(newLine.absoluteStart),"bad workIndex to TextFlow.addLine"); }
			CONFIG::debug { assert (!newLine.isDamaged(), "adding damaged line"); }
			var workLine:ITextFlowLine = _lines[workIndex];
			var afterLine:ITextFlowLine;
			var damageStart:int = MAX_VALUE;
			if (_damageAbsoluteStart == newLine.absoluteStart)
				_damageAbsoluteStart = newLine.absoluteStart + newLine.textLength;
				
			if (workLine == null)
				lines.push(newLine);
			else if((workLine is TextFlowTableBlock) && workLine != newLine)
				_lines.splice(workIndex,1,newLine);
			else if(newLine is TextFlowTableBlock)
			{
				if(workLine != newLine)
				{
					_lines.splice(workIndex,0,newLine);
					// set the next line absolute start to be rational for the next line...
					if(workLine.absoluteStart == newLine.absoluteStart)
						workLine.setAbsoluteStart(workLine.absoluteStart+1);
				}
			}
								
			else if (workLine.absoluteStart != newLine.absoluteStart)
			{
				if (workLine.absoluteStart + workLine.textLength > newLine.absoluteStart + newLine.textLength)
				{
					// Making a new line in the middle of an old one. Need to split the old one.
					afterLine = new TextFlowLine(null,newLine.paragraph);
					afterLine.setAbsoluteStart(newLine.absoluteStart + newLine.textLength);
					var oldCharCount:int = workLine.textLength;
					workLine.setTextLength(newLine.absoluteStart - workLine.absoluteStart);
					CONFIG::debug { assert(workLine.textLength != 0, "0 width line"); }
					afterLine.setTextLength((oldCharCount - newLine.textLength) - workLine.textLength);
					CONFIG::debug { assert(afterLine.textLength != 0, "0 width line"); }
					_lines.splice(workIndex + 1, 0, newLine, afterLine);
				}
				else
				{
					// We're composing ahead, so we need to split the line where we're at
					// This can happen if a table is getting composed, some cells can be composed before 
					// others that go before. 
					CONFIG::debug { assert(workLine.isDamaged(), "Uneven line boundary, but lines marked up to date"); }
					workLine.setTextLength(newLine.absoluteStart - workLine.absoluteStart);
					CONFIG::debug { assert(workLine.textLength != 0, "0 width line"); }
					afterLine = _lines[workIndex+1];
					afterLine.setTextLength((newLine.absoluteStart + newLine.textLength) - afterLine.absoluteStart);
					CONFIG::debug { assert(_lines[workIndex + 1].textLength != 0, "0 width line"); }
					afterLine.setAbsoluteStart(newLine.absoluteStart + newLine.textLength);
					_lines.splice(workIndex + 1, 0, newLine);
				}
				damageStart = workLine.absoluteStart;
			}
			else if (workLine.textLength > newLine.textLength)
			{
				// New line partially overlaps old line.
				// Keep the old line, but resize it so it comes after the new line.
				// Insert the new line at the old line's position
				workLine.setTextLength(workLine.textLength - newLine.textLength);
				CONFIG::debug { assert(workLine.textLength != 0, "0 width line"); }
				workLine.setAbsoluteStart(newLine.absoluteStart + newLine.textLength);
				workLine.damage("invalid");
				_lines.splice(workIndex, 0, newLine);
				damageStart = workLine.absoluteStart;
			}
			else 
			{
				var deleteCount:int = 1;
				// The new line completely overlaps the old line.
				// Insert the new line over the old line. If the line extents don't match,
				// fix-up the starting position & extent of the following line.
				if (workLine.textLength != newLine.textLength)
				{
					var amtRemaining:int = (newLine.textLength - workLine.textLength);
					var nextLine:int = workIndex + 1;
					while (amtRemaining > 0)
					{
						afterLine = _lines[nextLine];
						if (amtRemaining < afterLine.textLength)
						{
							afterLine.setTextLength(afterLine.textLength - amtRemaining);
							afterLine.damage("invalid");
							break;
						}
						else
						{
							deleteCount++;
							amtRemaining -= afterLine.textLength;
							nextLine++;
							afterLine = nextLine < _lines.length ? _lines[nextLine] : null;
						}
					}
					if (afterLine && afterLine.absoluteStart != newLine.absoluteStart + newLine.textLength)
					{
						afterLine.setAbsoluteStart(newLine.absoluteStart + newLine.textLength);
						afterLine.damage("invalid");
						CONFIG::debug { assert(afterLine.textLength != 0, "0 width line"); }
					}
					damageStart = newLine.absoluteStart + newLine.textLength;
				}
				// remove userData on the deleted lines so they can be recycled
				if (TextLineRecycler.textLineRecyclerEnabled)
				{
					var backgroundManager:IBackgroundManager = textFlow.backgroundManager;
					for (var recycleIdx:int = workIndex; recycleIdx < workIndex+deleteCount; recycleIdx++)
					{
						var textLine:ITextLine = ITextFlowLine(_lines[recycleIdx]).peekTextLine();
						if (textLine && !textLine.parent)
						{
							// lines shouldn't be valid here but lets check anyhow
							CONFIG::debug { assert(textLine.validity != "valid","caught a bug here"); }
							if (textLine.validity != "valid")	// recycle immediately if not parented
							{
								textLine.userData = null;
								TextLineRecycler.addLineForReuse(textLine);
								if (backgroundManager)
									backgroundManager.removeLineFromCache(textLine);
							}
						}
					}
				}
				_lines.splice(workIndex, deleteCount, newLine);
			}
	
			if (_damageAbsoluteStart > damageStart)
				_damageAbsoluteStart = damageStart;
			// CONFIG::debug { debugCheckTextFlowLines(false); }
	//		CONFIG::debug { checkFirstDamaged(); }	 enabling this will cause false positives due to _damageAbsoluteStart during composition not updated	when GEOMETRY_DAMAGE lines are cleared
		}
		
		/** 
		* The ISWFContext instance used to make FTE calls as needed. 
		*
		* <p>By default, the ISWFContext implementation is this FlowComposerBase object.
		* Applications can provide a custom implementation to use fonts
		* embedded in a different SWF file or to cache and reuse text lines.</p>
		* 
		* @see org.apache.royale.textLayout.compose.ISWFContext
		* 
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*/
 	
		public function get swfContext():ISWFContext
		{
			return _swfContext;
		}
		public function set swfContext(context:ISWFContext):void
		{
			if (context != _swfContext)
			{
				// swf contexts can be wrappers for other swf contexts - we're going to let the swfcontext give us a hint here
				if (textFlow)
				{
					var newBaseContext:ISWFContext =  ContextUtil.computeBaseSWFContext(context);
					var oldBaseContext:ISWFContext =  ContextUtil.computeBaseSWFContext(_swfContext);
	
					_swfContext = context;

					if (newBaseContext != oldBaseContext)
					{
						damage(0,textFlow.textLength,FlowDamageType.INVALID);
						textFlow.invalidateAllFormats();
					}
				}
				else
					_swfContext = context;				
			}
		}
		/** @private */
		public function createBackgroundManager():IBackgroundManager{ return null; }
		
		public function createNumberLine(listItemElement:IListItemElement, curParaElement:IParagraphElement, swfContext:ISWFContext, totalStartIndent:Number):ITextLine
		{
			return NumberlineUtil.createNumberLine(listItemElement, curParaElement, swfContext, totalStartIndent);
		}
		
		/**
		 * Validate that the lines associated with the flow are internally consistent. 
		 * @private
		 * The start of the next line has to match the start of the previous line + the 
		 * span of the previous line. The last line needs to end at the end of the flow,
		 * and the first line must be at the start of the text.
		 */
		CONFIG::debug public function debugCheckTextFlowLines(validateControllers:Boolean=true):int
		{
			var rslt:int = 0;
			var position:int = 0;
			var overflow:Boolean = false;
			for each (var line:ITextFlowLine in _lines)
			{
				// trace("validateLines:",lines.indexOf(line).toString()," ",line.start," ",line.textLength);
				rslt += assert(line.absoluteStart == position, "Line start incorrect");
				rslt += assert(line.textLength >= 0,"Invalind length");
				if (validateControllers)
				{
					var lineController:IContainerController = line.controller;
					if (lineController != null)
					{
						rslt += assert(overflow == false,"non overflow line after overflow line?");
						rslt += assert(line.absoluteStart >= line.controller.absoluteStart,"bad container mapping");
						rslt += assert(line.absoluteStart+line.textLength<= lineController.absoluteStart+lineController.textLength,"bad container mapping");
					}
					else
						overflow = true;
				}
				position += line.textLength;
			}
			return rslt;
		}		
	}
}
