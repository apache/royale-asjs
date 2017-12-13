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
package org.apache.royale.textLayout.elements
{
	import org.apache.royale.text.engine.GroupElement;
	import org.apache.royale.text.engine.TextElement;
	
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.debug.Debugging;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.events.ModelChange;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;
	import org.apache.royale.textLayout.formats.WhiteSpaceCollapse;

	import org.apache.royale.textLayout.utils.CharacterUtil;
	

			
	[DefaultProperty("mxmlChildren")]
	
	/** 
	* The SpanElement class represents a run of text that has a single set of formatting attributes applied. SpanElement 
	* objects contain the text in a paragraph. A simple paragraph (ParagraphElement) includes one or more SpanElement objects. 
	*
	* <p>A ParagraphElement will have a single SpanElement object if all the text in the paragraph shares the same set of 
	* attributes. It has multiple SpanElement objects if the text in the paragraph has multiple formats.</p>
	*
	* @playerversion Flash 10
	* @playerversion AIR 1.5
	* @langversion 3.0
	*
	* @see FlowElement
	* @see ParagraphElement
	* @see TextFlow
     	*/
	public class SpanElement extends FlowLeafElement implements ISpanElement
	{	
		
		/** Constructor - creates a SpanElement object to hold a run of text in a paragraph.
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*/
	 	
		public function SpanElement()
		{
			super();
		}
		override public function get className():String
		{
			return "SpanElement";
		}
		
		/** @private */
		override public function createContentElement():void
		{
			if (_blockElement && _blockElement.textBlock)
				return;
			
			calculateComputedFormat();	// BEFORE creating the element
			_blockElement = new TextElement(_text,null);			
			CONFIG::debug { Debugging.traceFTECall(_blockElement,null,"new TextElement()"); }
			CONFIG::debug { Debugging.traceFTEAssign(_blockElement, "text", _text); }
			super.createContentElement();
		}
		
		/** @private */
		public override function shallowCopy(startPos:int = 0, endPos:int = -1):IFlowElement
		{
			if (endPos == -1)
				endPos = textLength;
				
			// Note to callers: If you are calling this function outside a try/catch, do ensure that the 
			// state of the model is coherent before the call.
			var retFlow:SpanElement = super.shallowCopy(startPos, endPos) as SpanElement;
						
			var startSpan:int = 0;
			var endSpan:int = startSpan + textLength;
			
			var leafElStartPos:int = startSpan >= startPos ? startSpan : startPos;
			var leafElEndPos:int =  endSpan < endPos ? endSpan : endPos;
			if (leafElEndPos == textLength && hasParagraphTerminator)
				--leafElEndPos;
				
			if (leafElStartPos > leafElEndPos)
				throw RangeError(GlobalSettings.resourceStringFunction("badShallowCopyRange"));
			
			if (((leafElStartPos != endSpan) && CharacterUtil.isLowSurrogate(_text.charCodeAt(leafElStartPos))) ||
				((leafElEndPos != 0) && CharacterUtil.isHighSurrogate(_text.charCodeAt(leafElEndPos-1))))
					throw RangeError(GlobalSettings.resourceStringFunction("badSurrogatePairCopy"));
			
			if (leafElStartPos != leafElEndPos)
				retFlow.replaceText(0, retFlow.textLength,  _text.substring(leafElStartPos, leafElEndPos));
			
			return retFlow;
		}	
	
		/** @private */
		override protected function get abstract():Boolean
		{ return false; }		
		
		/** @private */
		public override function get defaultTypeName():String
		{ return "span"; }

		/** @private */
		public override function get text():String
		{
			// test textLength cause this is a property and the debugger may run this calculation in intermediate states
			if (textLength == 0)
				return "";
			
			return hasParagraphTerminator ? _text.substr(0,textLength-1) : _text;
		}
		/** 
		 * Receives the String of text that this SpanElement object holds.
		 *
		 * <p>The text of a span does not include the carriage return (CR) at the end of the paragraph
		 * but it is included in the value of <code>textLength</code>.</p>
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	
//TODO this is only override because we temporarily added a setter to FlowLeafElement
	 	override public function set text(textValue:String):void
		{
			//original code stripped breaking and tab characters.  new code moved to collapseWhitevar newLineTabPattern:RegExp = /[\n\r\t]/g;
			replaceText(0,textLength, textValue); 
		} 
		
		/** @private */
		public override function getText(relativeStart:int=0, relativeEnd:int=-1, paragraphSeparator:String="\n"):String
		{
			if (relativeEnd == -1)
				relativeEnd = textLength;
			
			if (textLength && relativeEnd == textLength && hasParagraphTerminator)
				--relativeEnd;		// don't include terminator
			return _text ? _text.substring(relativeStart, relativeEnd) : "";
		}

		[RichTextContent]
		/** 
		 * Sets text based on content within span tags; always deletes existing children.
		 * This property is intended for use during MXML compiled import in Flex. Flash Professional ignores this property.
         * When TLF markup elements have other
		 * TLF markup elements as children, the children are assigned to this property.
		 *
		 * @throws TypeError If array element is not a SpecialCharacterElement or a String.
		 * @param array - an array of elements within span tags. Each element of array must be a SpecialCharacterElement or a String.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
		public function get mxmlChildren():Array
		{
			return [ text ];
		}
		public function set mxmlChildren(array:Array):void
		{
			/* NOTE: all FlowElement implementers and overrides of mxmlChildren must specify [RichTextContent] metadata */

			var str:String = ElementHelper.getSpanText(array);
			replaceText(0,textLength, str); 
		}
		
		
		/** 
		 * Specifies whether this SpanElement object terminates the paragraph. The SpanElement object that terminates a 
		 * paragraph has an extra, hidden character at the end. This character is added automatically by the component and is
		 * included in the value of the <code>textLength</code> property.
		 * 
		 * @private */
		 
		public function get hasParagraphTerminator():Boolean
		{
			var p:IParagraphElement = getParagraph();
			return (p && p.getLastLeaf() == this); 
		}
		
		/** @private */
		CONFIG::debug public function verifyParagraphTerminator():void
		{
			assert(_text && _text.length && _text.charAt(_text.length-1) == ElementConstants.kParagraphTerminator,
				"attempting to remove para terminator when it doesn't exist");
		}
		
		
		/**
		 * Makes a shallow copy of this SpanElement between 2 character positions
		 * and returns it as a FlowElement.  Unlike deepCopy, shallowCopy does
		 * not copy any of the children of this SpanElement.
		 * 
		 */
		 
		 // If I have a sequence of different sorts of spaces (e.g., en quad, hair space), would I want them converted down to one space? Probably not.
		 // For now, u0020 is the only space character we consider for eliminating duplicates, though u00A0 (non-breaking space) is potentially eligible. 
		 private static const _dblSpacePattern:RegExp = /[\u0020]{2,}/g;
		 // Tab, line feed, and carriage return
		 private static const _newLineTabPattern:RegExp = /[\u0009\u000a\u000d]/g;
		 private static const _tabPlaceholderPattern:RegExp = new RegExp("\\" + "uE000", "g");
		 
		//  static private const anyPrintChar:RegExp = /[^\s]/g;
		 // Consider only tab, line feed, carriage return, and space as characters used for pretty-printing. 
		 // While debatable, this is consistent with what CSS does. 
		 static private const anyPrintChar:RegExp = /[^\u0009\u000a\u000d\u0020]/g; 

		 /** @private */
		public override function applyWhiteSpaceCollapse(collapse:String):void
		{
			var ffc:ITextLayoutFormat = this.formatForCascade;
			var wsc:* = ffc ? ffc.whiteSpaceCollapse : undefined;
			if (wsc !== undefined && wsc != FormatValue.INHERIT)
				collapse = wsc;
				
			var origTxt:String = text;
			var tempTxt:String = origTxt;
				
			if (!collapse /* null == default value == COLLAPSE */ || collapse == WhiteSpaceCollapse.COLLAPSE)
			{
				// The span was added automatically when a String was passed to replaceChildren.
				// If it contains only whitespace, we remove the text.
				if (impliedElement && parent != null)
				{
					// var matchArray:Array = tempTxt.search(anyPrintChar);
					if (tempTxt.search(anyPrintChar) == -1)
					{
						parent.removeChild(this);
						return;
					}
				}
				
				// For now, replace the newlines and tabs inside the element with a space.
				// This is necessary for support of compiled mxml files that have newlines and tabs, because
				// these are most likely not intended to be part of the text content, but only there so the
				// text can be conveniently edited in the mxml file. Later on we need to add standalone elements
				// for <br/> and <tab/>. Note that tab character is not supported in HTML.	
				tempTxt = tempTxt.replace(_newLineTabPattern, " ");

				// Replace sequences of 2 or more whitespace characters with single space
				tempTxt = tempTxt.replace(_dblSpacePattern, " ");
			}
			
			// Replace tab placeholders (used for tabs that are expected to survive whitespace collapse) with '\t'
			tempTxt = tempTxt.replace(_tabPlaceholderPattern, '\t');
			if (tempTxt != origTxt)
				replaceText(0, textLength, tempTxt);

			super.applyWhiteSpaceCollapse(collapse);
		}
		
		/** 
		 * Updates the text in text span based on the specified start and end positions. To insert text, set the end position
		 * equal to the start position. To append text to the existing text in the span, set the start position and the
		 * end position equal to the length of the existing text.
		 *
		 * <p>The replaced text includes the start character and up to but not including the end character.</p>
		 * 
		 *  @param relativeStartPosition The index position of the beginning of the text to be replaced, 
		 *   relative to the start of the span. The first character in the span is at position 0.
		 *  @param relativeEndPosition The index one position after the last character of the text to be replaced, 
		 *   relative to the start of the span. Set this value equal to <code>relativeStartPos</code>
		 *   for an insert. 
		 *  @param textValue The replacement text or the text to add, as the case may be.
		 * 
		 *  @throws RangeError The <code>relativeStartPosition</code> or <code>relativeEndPosition</code> specified is out of 
		 * range or a surrogate pair is being split as a result of the replace.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
		 */
		 
		public function replaceText(relativeStartPosition:int, relativeEndPosition:int, textValue:String):void
		{
			// Note to callers: If you are calling this function outside a try/catch, do ensure that the 
			// state of the model is coherent before the call.
			if (relativeStartPosition < 0 || relativeEndPosition > textLength || relativeEndPosition < relativeStartPosition)
				throw RangeError(GlobalSettings.resourceStringFunction("invalidReplaceTextPositions"));	


			if ((relativeStartPosition != 0 && relativeStartPosition != textLength && CharacterUtil.isLowSurrogate(_text.charCodeAt(relativeStartPosition))) ||
				(relativeEndPosition != 0 && relativeEndPosition != textLength && CharacterUtil.isHighSurrogate(_text.charCodeAt(relativeEndPosition-1))))
					throw RangeError (GlobalSettings.resourceStringFunction("invalidSurrogatePairSplit"));
				
			if (hasParagraphTerminator)
			{
				CONFIG::debug { assert(textLength > 0,"invalid span"); }
				if (relativeStartPosition == textLength)
					relativeStartPosition--;
				if (relativeEndPosition == textLength)
					relativeEndPosition--;
			}
			
			if (relativeEndPosition != relativeStartPosition)
				modelChanged(ModelChange.TEXT_DELETED,this,relativeStartPosition,relativeEndPosition-relativeStartPosition);
			
			replaceTextInternal(relativeStartPosition,relativeEndPosition,textValue);
			
			if (textValue && textValue.length)
				modelChanged(ModelChange.TEXT_INSERTED,this,relativeStartPosition,textValue.length);
		}
		private function replaceTextInternal(startPos:int, endPos:int, textValue:String):void
		{			
			var textValueLength:int = textValue == null ? 0 : textValue.length;
			var deleteTotal:int = endPos-startPos;
			var deltaChars:int =  textValueLength - deleteTotal;
			if (_blockElement)
			{
				(_blockElement as TextElement).replaceText(startPos,endPos,textValue);
				_text = _blockElement.rawText;
				CONFIG::debug { Debugging.traceFTECall(null,_blockElement as TextElement,"replaceText",startPos,endPos,textValue); }
			}
			else if (_text)
			{
				if (textValue)
					_text = _text.slice(0, startPos) + textValue + _text.slice(endPos, _text.length);
				else
					_text = _text.slice(0, startPos) + _text.slice(endPos, _text.length);
			}
			else
				_text = textValue;
			
			if (deltaChars != 0)
			{
				updateLengths(getAbsoluteStart() + startPos, deltaChars, true);
				deleteContainerText(endPos,deleteTotal);
				
				if (textValueLength != 0)
				{
					var enclosingContainer:IContainerController = getEnclosingController(startPos);
					if (enclosingContainer)
						enclosingContainer.setTextLength(enclosingContainer.textLength + textValueLength);
				}
			}

			CONFIG::debug { 
				assert(textLength == (_text ? _text.length : 0),"span textLength doesn't match the length of the text property, text property length is " + _text.length.toString() + " textLength property is " + textLength.toString());
				assert(_blockElement == null || _blockElement.rawText == _text,"mismatched text");
			}
		}
	
		/** @private */
		public function addParaTerminator():void
		{
			CONFIG::debug 
			{ 
				// TODO: Is this assert valid? Do we prevent users from adding para terminators themselves? 
				if (_blockElement && _blockElement.rawText && _blockElement.rawText.length)
					assert(_blockElement.rawText.charAt(_blockElement.rawText.length-1) != ElementConstants.kParagraphTerminator,"adding para terminator twice");
			}

			if(_text && _text.substr(-1) == ElementConstants.kParagraphTerminator)// terminator exists. Bail out.
				return;
			replaceTextInternal(textLength,textLength,ElementConstants.kParagraphTerminator);
			
			CONFIG::debug 
			{ 
				// TODO: Is this assert valid? Do we prevent users from adding para terminators themselves? 
				if (_blockElement)
					assert(_blockElement.rawText.charAt(_blockElement.rawText.length-1) == ElementConstants.kParagraphTerminator,"adding para terminator failed");
			}			
			
			modelChanged(ModelChange.TEXT_INSERTED,this,textLength-1,1);
		}
		/** @private */
		public function removeParaTerminator():void
		{
			CONFIG::debug 
			{ 
				assert(_text && _text.length && _text.charAt(_text.length-1) == ElementConstants.kParagraphTerminator,
					"attempting to remove para terminator when it doesn't exist");
			}
			if(!_text || _text.substr(-1) != ElementConstants.kParagraphTerminator)// no terminator exists. Bail out.
				return;

			replaceTextInternal(textLength-1,textLength,"");
			modelChanged(ModelChange.TEXT_DELETED,this,textLength > 0 ? textLength-1 : 0,1);
		}
		// **************************************** 
		// Begin tree modification support code
		// ****************************************

		/** 
		 * Splits this SpanElement object at the specified position and returns a new SpanElement object for the content
		 * that follows the specified position. 
		 *
		 * <p>This method throws an error if you attempt to split a surrogate pair. In Unicode UTF-16, a surrogate pair is a pair of 
		 * 16-bit code units (a high code unit and a low code unit) that represent one of the abstract Unicode characters 
		 * that cannot be represented in a single 16-bit word. The 16-bit high code unit is in the range of D800 to DBFF. The
		 * 16-bit low code unit is in the range of DC00 to DFFF.</p>
		 * 
		 * @param relativePosition - relative position in the span to create the split
		 * @return - the newly created span. 
		 * @throws RangeError <code>relativePosition</code> is less than 0 or greater than textLength or a surrogate pair is being split.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 * 
	 	 * @private
	 	 */
	 	 
		public override function splitAtPosition(relativePosition:int):IFlowElement
		{
			// Note to callers: If you are calling this function outside a try/catch, do ensure that the 
			// state of the model is coherent before the call.
			if (relativePosition < 0 || relativePosition > textLength)
				throw RangeError(GlobalSettings.resourceStringFunction("invalidSplitAtPosition"));
			
			if ((relativePosition < textLength) && CharacterUtil.isLowSurrogate(String(text).charCodeAt(relativePosition)))
				throw RangeError (GlobalSettings.resourceStringFunction("invalidSurrogatePairSplit"));
			
			var newSpan:ISpanElement = new SpanElement();
			// clone styling information
			newSpan.id = this.id;
			newSpan.typeName = this.typeName;			
			
			if (parent)
			{
				var newBlockElement:TextElement;
				var newSpanLength:int = textLength - relativePosition;
				if (_blockElement)
				{
					// optimized version leverages player APIs
					// TODO: Jeff to add split on TextElement so we don't have to go find a group every time
					var group:GroupElement = parent.createContentAsGroup(getElementRelativeStart(parent));
					
					var elementIndex:int = group.getElementIndex(_blockElement);
					
					CONFIG::debug { assert(elementIndex == parent.getChildIndex(this),"bad group index"); }
					CONFIG::debug { assert(elementIndex != -1 && elementIndex < group.elementCount,"bad span split"); }
					//trace("GROUP BEFORE: " + group.rawText);
					//trace("BLOCK BEFORE: " + group.block.content.rawText);
					//trace("calling group.splitTextElement("+elementIndex.toString()+","+relativePosition.toString()+")");
					group.splitTextElement(elementIndex, relativePosition);
					CONFIG::debug { Debugging.traceFTECall(null,group,"splitTextElement",elementIndex,relativePosition); }

					//trace("GROUP AFTER: " + group.rawText);
					//trace("BLOCK AFTER: " + group.block.content.rawText);
					
					// no guarantee on how the split works
					_blockElement = group.getElementAt(elementIndex);
					_text = _blockElement.rawText;
					CONFIG::debug { Debugging.traceFTECall(_blockElement,group,"getElementAt",elementIndex); }
					newBlockElement = group.getElementAt(elementIndex+1) as TextElement;
					CONFIG::debug { Debugging.traceFTECall(newBlockElement,group,"getElementAt",elementIndex+1); }
				}
				else if (relativePosition < textLength)
				{
					newSpan.text = _text.substr(relativePosition);
					_text = _text.substring(0, relativePosition);
				}

				// Split this span at the offset, into two equivalent spans
				modelChanged(ModelChange.TEXT_DELETED,this,relativePosition,newSpanLength);
				newSpan.quickInitializeForSplit(this, newSpanLength, newBlockElement);

				setTextLength(relativePosition);
			
				// slices it in, sets the parent and the start
				parent.addChildAfterInternal(this,newSpan);	
				
				var p:IParagraphElement = this.getParagraph();
				p.updateTerminatorSpan(this,newSpan);
				
				parent.modelChanged(ModelChange.ELEMENT_ADDED,newSpan,newSpan.parentRelativeStart,newSpan.textLength);
			}
			else
			{
				// this version also works if para is non-null but may not be as efficient.
				newSpan.format = format;

				// could be we are splitting 
				if (relativePosition < textLength)
				{
					newSpan.text = String(this.text).substr(relativePosition);
					replaceText(relativePosition,textLength,null);
				}
			}
			
			return newSpan;
		}
		
		/** @private */
		public override function normalizeRange(normalizeStart:uint,normalizeEnd:uint):void
		{
			if (this.textLength == 1 && !bindableElement)
			{
				var p:IParagraphElement = getParagraph();
				if (p && p.getLastLeaf() == this)
				{
					var prevLeaf:IFlowLeafElement = getPreviousLeaf(p);
					if (prevLeaf)
					{
						if (!TextLayoutFormat.isEqual(this.format, prevLeaf.format))
							this.format = prevLeaf.format;
					}
				}
			}
			super.normalizeRange(normalizeStart,normalizeEnd);
		}

		/** @private */
		public override function mergeToPreviousIfPossible():Boolean
		{
			if (parent && !bindableElement)
			{
				var myidx:int = parent.getChildIndex(this);
				if (myidx != 0)
				{
					var sib:SpanElement = parent.getChildAt(myidx-1) as SpanElement;
					// If the previous sibling is a TableElement, we need to preserve the span.
					if(sib.className == "TableElement")
						return false;
					// If the element we're checking for merge has only the terminator, and the previous element
					// is not a Span, then we always merge with the previous span (NOT the previous sib). 
					// We just remove this span, and add the terminator to the previous span.
					if (!sib && this.textLength == 1 && this.hasParagraphTerminator)
					{
						var p:IParagraphElement = getParagraph();
						if (p)
						{
							var prevLeaf:IFlowLeafElement = getPreviousLeaf(p) as SpanElement;
							if (prevLeaf)
							{
								parent.removeChildAt(myidx);
								return true;
							}
						}
					}

					if (!(sib is SpanElement))
						return false;
					
					
					// If this has an active event mirror do not merge
					if (this.hasActiveEventMirror())
						return false;
					var thisIsSimpleTerminator:Boolean = textLength == 1 && hasParagraphTerminator;
					// if sib has an active event mirror still merge if this is a simple terminator span
					if (sib.hasActiveEventMirror() && !thisIsSimpleTerminator)
						return false;
					
					// always merge if this is just a terminator
					if (thisIsSimpleTerminator || equalStylesForMerge(sib))
					{
						CONFIG::debug { assert(this.parent == sib.parent, "Should never merge two spans with different parents!"); }
						CONFIG::debug { assert(TextLayoutFormat.isEqual(this.formatForCascade,sib.formatForCascade) || (this.textLength == 1 && this.hasParagraphTerminator), "Bad merge!"); }

						// Merge the spans
						var siblingInsertPosition:int = sib.textLength;
						sib.replaceText(siblingInsertPosition, siblingInsertPosition, this.text);
						parent.removeChildAt(myidx);
						return true;
					}
				}
			} 
			return false;
		}
		
		// **************************************** 
		// Begin debug support code
		// ****************************************	
		
		/** @private */
		CONFIG::debug public override function debugCheckFlowElement(depth:int = 0, extraData:String = ""):int
		{
			// debugging function that asserts if the flow element tree is in an invalid state
			
			var rslt:int = super.debugCheckFlowElement(depth,"text:"+String(text).substr(0,32)+" "+extraData);

			assert(_blockElement == null || _blockElement.rawText == _text,"debugCheckFlowElement: mismatched text");
			var textLen:int = textLength;
			if (_text)
				rslt += assert(textLen == _text.length,"span is different than its textElement, span text length is " + _text.length.toString() + " expecting " + textLen.toString());
			else	
				rslt += assert(textLen == 0,"span is different than its textElement, span text length is null expecting " + textLen.toString());
			rslt += assert(this != getParagraph().getLastLeaf() || (_text.length >= 1 && _text.substr(_text.length-1,1) == ElementConstants.kParagraphTerminator),"last span in paragraph must end with terminator");
			return rslt;
		}
	}
}
