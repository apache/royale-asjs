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
	import org.apache.royale.reflection.getQualifiedClassName;
	import org.apache.royale.text.engine.ContentElement;
	import org.apache.royale.text.engine.EastAsianJustifier;
	import org.apache.royale.text.engine.GroupElement;
	import org.apache.royale.text.engine.ITextBlock;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.text.engine.LineJustification;
	import org.apache.royale.text.engine.SpaceJustifier;
	import org.apache.royale.text.engine.TabAlignment;
	import org.apache.royale.text.engine.TabStop;
	import org.apache.royale.text.engine.TextRotation;
	import org.apache.royale.textLayout.compose.ITextFlowLine;
	import org.apache.royale.textLayout.debug.Debugging;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.Direction;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.JustificationRule;
	import org.apache.royale.textLayout.formats.LeadingModel;
	import org.apache.royale.textLayout.formats.LineBreak;
	import org.apache.royale.textLayout.formats.TabStopFormat;
	import org.apache.royale.textLayout.formats.TextAlign;
	import org.apache.royale.textLayout.formats.TextJustify;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;
	import org.apache.royale.textLayout.property.PropertyUtil;
	import org.apache.royale.textLayout.utils.CharacterUtil;
	import org.apache.royale.textLayout.utils.LocaleUtil;
	import org.apache.royale.textLayout.elements.ITextFlow;
	


	/** 
	 * The ParagraphElement class represents a paragraph in the text flow hierarchy. Its parent
	 * is a ParagraphFormattedElement, and its children can include spans (SpanElement), images 
	 * (inLineGraphicElement), links (LinkElement) and TCY (Tatechuuyoko - ta-tae-chu-yo-ko) elements (TCYElement). The 
	 * paragraph text is stored in one or more SpanElement objects, which define ranges of text that share the same attributes. 
	 * A TCYElement object defines a small run of Japanese text that runs perpendicular to the line, as in a horizontal run of text in a 
	 * vertical line. A TCYElement can also contain multiple spans.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * 
	 * @see InlineGraphicElement
	 * @see LinkElement
	 * @see SpanElement
	 * @see TCYElement
	 * @see ITextFlow
	 */
	 
	public final class ParagraphElement extends ParagraphFormattedElement implements IParagraphElement	{
		//private var _textBlock:ITextBlock;
		private var _terminatorSpan:ISpanElement;
		
		private var _interactiveChildrenCount:int;
		/** Constructor - represents a paragraph in a text flow. 
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*/
	 	
		public function ParagraphElement()
		{
			super();
			_terminatorSpan = null;
			_interactiveChildrenCount = 0 ;
		}
		override public function get className():String
		{
			return "ParagraphElement";
		}
		public function get interactiveChildrenCount():int
		{
			return _interactiveChildrenCount;
		}
		
		/** @private */
		public function createTextBlock():void
		{
			var tf:ITextFlow = getTextFlow();
			if(!tf)// if it's not in a text flow, we cannot create text blocks yet
				return;
//			CONFIG::debug { assert(_textBlock == null,"createTextBlock called when there is already a textblock"); }
			calculateComputedFormat();	// recreate the format BEFORE the _textBlock is created
			var tbs:Vector.<ITextBlock> = getTextBlocks();
			//tbs.length = 0;
			var tableCount:int = 0;
			if(tbs.length == 0 && !(getChildAt(0) is ITableElement) )
				tbs.push(tf.tlfFactory.textFactory.getTextBlock());
			//getTextBlocks()[0] = new ITextBlock();
//			CONFIG::debug { Debugging.traceFTECall(_textBlock,null,"new ITextBlock()"); }
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:IFlowElement = getChildAt(i);
				if(child is ITableElement)
					tableCount++;
//					tbs.push(new ITextBlock());
				else
				{
					//child.releaseContentElement();
					//child.createContentElement();
				}
			}
			while(tableCount >= tbs.length)
				tbs.push(tf.tlfFactory.textFactory.getTextBlock());
			
			for (i = 0; i < numChildren; i++)
			{
				child = getChildAt(i);
				child.createContentElement();
			}
			tbs.length = tableCount + 1;
			var tb:ITextBlock;
			for each(tb in tbs){
				updateTextBlock(tb);
			}
		}
		private function updateTextBlockRefs():void
		{
			var tbs:Vector.<ITextBlock> = getTextBlocks();
			if(tbs.length == 0)
				return;//nothing to do
			var tbIdx:int = 0;
			var tb:ITextBlock = tbs[tbIdx];
			var items:Array = [];
			var child:IFlowElement;
			for (var i:int = 0; i < numChildren; i++)
			{
				child = getChildAt(i);
				if(child is ITableElement)
				{
					tb.userData = items;
					if(++tbIdx == tbs.length)
						return;
					tb = tbs[tbIdx];
					tb.userData = null;

					//Advance to the next one.
					if(++tbIdx == tbs.length)
						return;
					tb = tbs[tbIdx];
					items = [];
					continue;
				}
				items.push(child);
			}
			tb.userData = items;
		}
		private function removeTextBlock(tb:ITextBlock):void
		{
			var tbs:Vector.<ITextBlock> = getTextBlocks();
			if(tbs)
			{
				var idx:int = getTextBlocks().indexOf(tb);
				if(idx > -1)
				{
					tbs.splice(idx,1);
				}
			}
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.compose.ITextFlowLine
		 */
		private function releaseTextBlockInternal(tb:ITextBlock):void
		{
			if (!tb)
				return;
			
			if (tb.firstLine)	// A ITextBlock may have no firstLine if it has previously been released.
			{
				for (var textLineTest:ITextLine = tb.firstLine; textLineTest != null; textLineTest = textLineTest.nextLine)
				{	
					if(textLineTest.numElements != 0)
					{	
						//if the number of adornments added does not match the number of children on the textLine
						//then a third party has added adornments.  Don't recycle the line or the adornment will be
						//lost.
						var tfl:ITextFlowLine = textLineTest.userData as ITextFlowLine;
						if(tfl.adornCount != textLineTest.numElements)
							return;
					}
				}
				
				CONFIG::debug { Debugging.traceFTECall(null,tb,"releaseLines",tb.firstLine, tb.lastLine); }				
				tb.releaseLines(tb.firstLine, tb.lastLine);	
			}	
			var items:Array = tb.userData;
			if(items)
			{
				var len:int = items.length;
				for (var i:int = 0; i < len; i++)
				{
					var child:FlowElement = items[i];
					child.releaseContentElement();
				}
				items.length = 0;
			}
			tb.content = null;
			removeTextBlock(tb);
		}
		/** @private */
		public function releaseTextBlock(tb:ITextBlock=null):void
		{
			updateTextBlockRefs();
			if(tb)
			{
				releaseTextBlockInternal(tb);
				return;
			}
			var tbs:Vector.<ITextBlock> = getTextBlocks();
			for each(var textBlock:ITextBlock in tbs)
			{
				releaseTextBlockInternal(textBlock);
			}
			//_textBlock = null;
			if (_computedFormat)
				_computedFormat = null;
		}
		private var _textBlocks:Vector.<ITextBlock>;
		public function getTextBlocks():Vector.<ITextBlock>
		{
			if(_textBlocks == null)
				_textBlocks = new Vector.<ITextBlock>();
			return _textBlocks;
		}
		/** ITextBlock where the text of the paragraph is kept. @private */
		public function getTextBlock():ITextBlock
		{
			if (!getTextBlocks().length)
				createTextBlock();
			
			return getTextBlocks()[0]; 
		}
		/** Last ITextBlock where the text of the paragraph is kept. @private */
		public function getLastTextBlock():ITextBlock
		{
			var tbs:Vector.<ITextBlock> = getTextBlocks();
			if(!tbs.length)
				createTextBlock();
			
			return tbs[tbs.length-1];
		}

		/** Get ITextBlock at specified position. @private */
		public function getTextBlockAtPosition(pos:int):ITextBlock
		{
			var curPos:int = 0;
			var posShift:int = 0;
			var tables:Vector.<ITableElement> = getTables();
			if(!tables.length)
				return getTextBlock();
			
			for each(var table:ITableElement in tables)
			{
				if(table.getElementRelativeStart(this) < pos)
					posShift++;
			}
			var tbs:Vector.<ITextBlock> = getTextBlocks();
			for each(var tb:ITextBlock in tbs)
			{
				if(tb.content == null)
					return tb;
				curPos += tb.content.rawText.length;
				if(curPos + posShift > pos)
				{
					if(getTextBlockStart(tb) > pos)
						return null;
					return tb;
				}
			}
			return null;
		}
		
		public function getTextBlockAbsoluteStart(tb:ITextBlock):int
		{
			var start:int = getTextBlockStart(tb);
			if(start < 0)
				start = 0;
			return getAbsoluteStart() + start;
		}
		public function getTextBlockStart(tb:ITextBlock):int
		{
//			var i:int;
			var curPos:int = 0;
			var tbs:Vector.<ITextBlock> = getTextBlocks();
			if(tbs.length == 0)
				return -1;
			var tables:Vector.<ITableElement> = getTables();
			for each(var curTB:ITextBlock in tbs)
			{
				for each(var table:ITableElement in tables)
				{
					if(table.getElementRelativeStart(this) <= curPos)
					{
						curPos++;
						tables.splice(tables.indexOf(table),1);
					}
				}
				if(tb == curTB)
					return curPos;
				if(tb.content)
					curPos += curTB.content.rawText.length;
			}
			
			return -1;
		}
		
		private function getTables():Vector.<ITableElement>
		{
			var tables:Vector.<ITableElement> = new Vector.<ITableElement>();
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:IFlowElement = getChildAt(i);
				if(child is ITableElement)
					tables.push(child as ITableElement);
			}
			return tables;
		}

		/** ITextBlock where the text of the paragraph is kept, or null if we currently don't have one. @private */
		public function peekTextBlock():ITextBlock
		{ 
			return getTextBlocks().length == 0 ? null : getTextBlocks()[0];
		}
		
		/** @private */
		public function releaseLineCreationData():void
		{
			// CONFIG::debug { assert(Configuration.playerEnablesArgoFeatures,"bad call to releaseLineCreationData"); }
			var tbs:Vector.<ITextBlock> = getTextBlocks();
			for each(var tb:ITextBlock in tbs)
			{
				tb["releaseLineCreationData"]();
			}
		}
		
		/**
		*  @private
		*  @royaleemitcoercion org.apache.royale.text.engine.GroupElement
		*/
		public override function createContentAsGroup(pos:int=0):GroupElement
		{
			var tb:ITextBlock = getTextBlockAtPosition(pos);
			if(!tb)
				tb = getTextBlockAtPosition(pos-1);
			var group:GroupElement = tb.content as GroupElement;
			if (!group)
			{
				var originalContent:ContentElement = tb.content;
				
				group = new GroupElement();
				CONFIG::debug { Debugging.traceFTECall(group,null,"new GroupElement()"); }
				tb.content = group;
				CONFIG::debug { Debugging.traceFTEAssign(tb,"content",group); }

				if (originalContent)
				{
					var gc:Vector.<ContentElement> = new Vector.<ContentElement>();
					CONFIG::debug { Debugging.traceFTECall(gc,null,"new Vector.<ContentElement>()"); }
					gc.push(originalContent);
					CONFIG::debug { Debugging.traceFTECall(null,gc,"push",originalContent); }
					group.replaceElements(0,0,gc);
					CONFIG::debug { Debugging.traceFTECall(null,group,"replaceElements",0,0,gc); }
				}
				
				// Now we've got to force damage the entire paragraph, because we restructured it in FTE.
				if (tb.firstLine && textLength)
				{
					var textFlow:ITextFlow = getTextFlow();
					if (textFlow)
						textFlow.damage(getAbsoluteStart(), textLength, "invalid", false);
				}
			}
			return group;
 		}
 		
 		/** @private */
		public override function removeBlockElement(child:IFlowElement, block:ContentElement):void
		{
			var tb:ITextBlock = getTextBlockAtPosition(child.getElementRelativeStart(this));
			if(!tb)
				tb = getTextBlock();
			
			if(tb.content == null)
				return;
			var relativeStart:int = child.getElementRelativeStart(this);

			if (getChildrenInTextBlock(relativeStart).length < 2)
			{
				if (block is GroupElement)
				{
					// see insertBlockElement
//					CONFIG::debug { assert(_textBlock.content != block,"removeBlockElement: bad call to removeBlockElement"); }
//					CONFIG::debug { assert(_textBlock.content is GroupElement,"removeBlockElement: bad content"); }
//					CONFIG::debug { assert(GroupElement(_textBlock.content).elementCount == 1,"removeBlockElement: bad element count"); }
//					CONFIG::debug { assert(GroupElement(_textBlock.content).getElementAt(0) == block,"removeBlockElement: bad group content"); }
					GroupElement(tb.content).replaceElements(0,1,null);
//					CONFIG::debug { Debugging.traceFTECall(null,_textBlock.content,"replaceElements",0,1,null); }
				}
				tb.content = null;
//				CONFIG::debug { Debugging.traceFTEAssign(_textBlock,"content",null); }
			}
			else if(block.groupElement)
			{
				var idx:int = getChildIndexInBlock(child);
				var group:GroupElement = GroupElement(tb.content);
				CONFIG::debug { assert(group.elementCount == numChildren,"Mismatched group and elementCount"); }
				group.replaceElements(idx,idx+1,null);
				if(group.elementCount == 0)
					return;
				CONFIG::debug { Debugging.traceFTECall(null,group,"replaceElements",idx,idx+1,null); }
				if (numChildren == 2)	// its going to be one so ungroup
				{
					// ungroup - need to take it out first as inlinelements can only have one parent
					var elem:ContentElement = group.getElementAt(0);
					CONFIG::debug { Debugging.traceFTECall(elem,group,"getElementAt",0); }
					if (!(elem is GroupElement))
					{
						group.replaceElements(0,1,null);
						CONFIG::debug { Debugging.traceFTECall(null,group,"replaceElements",0,1,null); }
						tb.content = elem;
						CONFIG::debug { Debugging.traceFTEAssign(tb,"content",elem); }
					}
				}
			}
			else {
				//trace("1");
				//tb.content = null;
			}
		}
		
		
		/** @private */
		public override function hasBlockElement():Boolean
		{
			return getTextBlocks().length > 0;
		}
		
		/** @private */
		override public function createContentElement():void
		{
			createTextBlock();
		}
		
		/** @private */
		private function getChildrenInTextBlock(pos:int):Array
		{
			var retVal:Array = [];
			if(numChildren == 0)
				return retVal;
			if(numChildren == 1)
			{
				retVal.push(getChildAt(0));
				return retVal;
			}
			var chldrn:Array = mxmlChildren.slice();
			for(var i:int = 0; i<chldrn.length;i++)
			{
				if(chldrn[i] is ITableElement)
				{
					if(chldrn[i].parentRelativeStart < pos)
					{
						retVal.length = 0;
						continue;
					}
					if(chldrn[i].parentRelativeStart >= pos)
						break;
				}
				retVal.push(chldrn[i]);		
			}
			return retVal;
		}
		
		/** @private */
		public override function insertBlockElement(child:IFlowElement, block:ContentElement):void
		{
			var relativeStart:int = child.getElementRelativeStart(this);
			var tb:ITextBlock = getTextBlockAtPosition(relativeStart);
			if(!tb)
				tb = getTextBlockAtPosition(relativeStart-1);
			
			if(!tb)
			{
				child.releaseContentElement();
				return;
			}
			if (getTextBlocks().length == 0)
			{
				child.releaseContentElement();
				createTextBlock();	// does the whole tree
				return;
			}
			var gc:Vector.<ContentElement>;	// scratch var
			var group:GroupElement;			// scratch
			if (getChildrenInTextBlock(relativeStart).length < 2)
			{
				if (block is GroupElement)
				{
					// this case forces the Group to be in a Group so that following FlowLeafElements aren't in a SubParagraphGroupElementBase's group
					gc = new Vector.<ContentElement>();
					CONFIG::debug { Debugging.traceFTECall(gc,null,"new Vector.<ContentElement>()"); }
					gc.push(block);
					CONFIG::debug { Debugging.traceFTECall(null,gc,"push",block); }
					group = new GroupElement(gc);
					CONFIG::debug { Debugging.traceFTECall(group,null,"new GroupElement",gc); }
					tb.content = group;
//					CONFIG::debug { Debugging.traceFTEAssign(_textBlock,"content",group); }
				}
				else
				{
//TODO commented this out. Was there any reason it was here?
					// if(block.groupElement)
					// {
					// 	block.groupElement.elementCount;
					// }
					tb.content = block;
//					CONFIG::debug { Debugging.traceFTEAssign(_textBlock,"content",block);  }
				}
			}
			else
			{
				group = createContentAsGroup(relativeStart);
				var idx:int = getChildIndexInBlock(child);
				gc = new Vector.<ContentElement>();
				CONFIG::debug { Debugging.traceFTECall(gc,null,"new Vector.<ContentElement>"); }
				gc.push(block);
				CONFIG::debug { Debugging.traceFTECall(null,gc,"push",block); }
				// If elements in the middle (i.e. ones in the process of being added) were missed, the idx can be too high.
				// The missed ones will be inserted later.
				if(idx > group.elementCount)
					idx = group.elementCount;
				group.replaceElements(idx,idx,gc);
				CONFIG::debug { Debugging.traceFTECall(null,group,"replaceElements",idx,idx,gc); }
			}
		}
		
		private function getChildIndexInBlock(elem:IFlowElement):int
		{
			var relIdx:int = 0;
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:IFlowElement = getChildAt(i);
				if(child == elem)
					return relIdx;
				relIdx++;
				if(child is ITableElement)
					relIdx = 0;
			}
			return -1;
		}
		
		/** @private */
		override protected function get abstract():Boolean
		{ return false;	}	
		
		/** @private */
		public override function get defaultTypeName():String
		{ return "p"; }

		public function removeEmptyTerminator():void
		{
			if(numChildren == 1 && _terminatorSpan && _terminatorSpan.textLength == 1)
			{
				_terminatorSpan.removeParaTerminator();
				super.replaceChildren(0, 1);
				this._terminatorSpan = null;
			}
		}
		/** @private */
		public override function replaceChildren(beginChildIndex:int,endChildIndex:int,...rest):void
		{
			var applyParams:Array;

			do{
				if(_terminatorSpan)
				{
					var termIdx:int = getChildIndex(_terminatorSpan);
					if(termIdx > 0 && termIdx < beginChildIndex && _terminatorSpan.textLength == 1)
					{
						super.replaceChildren(termIdx, termIdx+1);
						_terminatorSpan = null;
						if(beginChildIndex >= termIdx)
						{
							beginChildIndex--;
							if(rest.length == 0) // delete of terminator was already done.
								break;
						}
						if(endChildIndex >= termIdx && beginChildIndex != endChildIndex)
							endChildIndex--;
					}
				}
				
				// makes a measurable difference - rest.length zero and one are the common cases
				if (rest.length == 1)
					applyParams = [beginChildIndex, endChildIndex, rest[0]];
				else
				{
					applyParams = [beginChildIndex, endChildIndex];
					if (rest.length != 0)
						applyParams = applyParams.concat.apply(applyParams, rest);
				}
//TODO fix super				
				super.replaceChildren.apply(this, applyParams);
				
			}while(false);
			
			ensureTerminatorAfterReplace();
			// ensure correct text blocks
			createTextBlock();
		}
		
		public override function splitAtPosition(relativePosition:int):IFlowElement
		{
			// need to handle multiple TextBlocks
			// maybe not. It might be handled in replaceChildren().
			return super.splitAtPosition(relativePosition);
		}
		/**
		 *  @private
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ISpanElement
		 */
		public function ensureTerminatorAfterReplace():void
		{
			//lose reference to terminator if it was removed or not a direct child.
			if(_terminatorSpan && _terminatorSpan.parent != this)
			{
				_terminatorSpan.removeParaTerminator();
				_terminatorSpan = null;
			}
			
			var newLastLeaf:IFlowLeafElement = getLastLeaf();
			if (_terminatorSpan != newLastLeaf)
			{
				if(_terminatorSpan)
					_terminatorSpan.removeParaTerminator();
				if (newLastLeaf && _terminatorSpan)
				{
					if(_terminatorSpan.textLength == 0 && !_terminatorSpan.id)
					{
						var termIdx:int = getChildIndex(_terminatorSpan);
						super.replaceChildren(termIdx, termIdx+1);
					}
					this._terminatorSpan = null;
				}
				if(newLastLeaf)
				{
					if (newLastLeaf is ISpanElement)
					{
						(newLastLeaf as ISpanElement).addParaTerminator();
						this._terminatorSpan = newLastLeaf as ISpanElement;
					}
					else
					{
						var s:ISpanElement = ElementHelper.getTerminator(this, newLastLeaf);
						super.replaceChildren(numChildren,numChildren,s);
						this._terminatorSpan = s;
					}
				}
				else
					_terminatorSpan = null;
			}
			//merge terminator span to previous if possible
			if(_terminatorSpan && _terminatorSpan.textLength == 1)
			{
				var prev:IFlowLeafElement = _terminatorSpan.getPreviousLeaf(this);
				if(prev && prev.parent == this && prev is ISpanElement)
				{
					_terminatorSpan.mergeToPreviousIfPossible();
				}
			}
		}
		
		/** @private */
		public function updateTerminatorSpan(splitSpan:ISpanElement,followingSpan:ISpanElement):void
		{
			if (_terminatorSpan == splitSpan)
				_terminatorSpan = followingSpan;
		}

		[RichTextContent]
		/** @private NOTE: all FlowElement implementers and overrides of mxmlChildren must specify [RichTextContent] metadata */
		public override function set mxmlChildren(array:Array):void
		{
			// remove all existing children
			replaceChildren(0,numChildren);
			
			for each (var child:Object in array)
			{
				if (child is IFlowElement)
				{
					if ((child is ISpanElement) || (child is ISubParagraphGroupElementBase))
						child.bindableElement = true;
					
					// Note: calling super.replaceChildren because we don't want to transfer para terminator each time
					super.replaceChildren(numChildren, numChildren, child as IFlowElement);
				}
				else if (child is String)
				{
					var s:ISpanElement = ElementHelper.getSpan();
					s.text = String(child);
					s.bindableElement = true;
					
					// Note: calling super.replaceChildren because we don't want to transfer para terminator each time
					super.replaceChildren(numChildren, numChildren, s);
				}
				else if (child != null)
					throw new TypeError(GlobalSettings.resourceStringFunction("badMXMLChildrenArgument",[ getQualifiedClassName(child) ]));
			}
			
			// Now ensure para terminator
			ensureTerminatorAfterReplace();
			
			// recreate text blocks to handle possible TableElement changes
			createTextBlock();
		}
		
		/** @private
 		 */
		public override function getText(relativeStart:int=0, relativeEnd:int=-1, paragraphSeparator:String="\n"):String
		{
			// Optimization for getting text of the entire paragraph
			if (relativeStart == 0 && (relativeEnd == -1 || relativeEnd >= textLength-1) && getTextBlocks().length)
			{
				var tb:ITextBlock;
				var tbs:Vector.<ITextBlock> = getTextBlocks();
				var text:String = "";
				for each(tb in tbs)
				{
					text = text + getTextInBlock(tb);
				}
				if(tb.content && tb.content.rawText)
					return text.substring(0, text.length - 1);
				return text;
			}
			return super.getText(relativeStart, relativeEnd, paragraphSeparator);
		}
		private function getTextInBlock(tb:ITextBlock):String{
			if(!tb.content || !tb.content.rawText)
				return "";
			return tb.content.rawText;
		}
		
		/** Returns the paragraph that follows this one, or null if there are no more paragraphs. 
		 *
		 * @return the next paragraph or null if there are no more paragraphs.
		 *
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 * 
	 	 * @see #getPreviousParagraph()
		 *  @royaleignorecoercion org.apache.royale.textLayout.elements.ParagraphElement
		 */
		public function getNextParagraph():IParagraphElement
		{
			var nextLeaf:IFlowLeafElement = getLastLeaf().getNextLeaf();
			return nextLeaf ? nextLeaf.getParagraph() as ParagraphElement : null;
		}
	
		/** Returns the paragraph that precedes this one, or null, if this paragraph is the first one 
		 * in the ITextFlow. 
		 *
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
	 	 * @see #getNextParagraph()
	 	 */
		public function getPreviousParagraph():IParagraphElement
		{
			var previousLeaf:IFlowLeafElement = getFirstLeaf().getPreviousLeaf();
			return previousLeaf ? previousLeaf.getParagraph() : null;
		}
	
		/** 
		 * Scans backward from the supplied position to find the location
		 * in the text of the previous atom and returns the index. The term atom refers to 
		 * both graphic elements and characters (including groups of combining characters), the 
		 * indivisible entities that make up a text line.
		 * 
		 * @param relativePosition  position in the text to start from, counting from 0
		 * @return index in the text of the previous cluster
		 *
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
	 	 * @see org.apache.royale.text.engine.ITextLine
		 */
		 
		public function findPreviousAtomBoundary(relativePosition:int):int
		{
			var tb:ITextBlock = getTextBlockAtPosition(relativePosition);
			if(!tb || !tb.content)
				return relativePosition-1;
			
			var tbStart:int = getTextBlockStart(tb);
			var textBlockPos:int = relativePosition - tbStart;
            var tl:ITextLine = tb.getTextLineAtCharIndex(textBlockPos);
			if (ConfigSettings.usesDiscretionaryHyphens && tl != null)
			{
				var currentAtomIndex:int = tl.getAtomIndexAtCharIndex(textBlockPos);
                //trace("relpos", relativePosition, "atomIndex", currentAtomIndex);
                var isRTL:Boolean = tl.getAtomBidiLevel(currentAtomIndex) == 1;
                if (isRTL)
                {
//                   var foo:int = tb.findPreviousAtomBoundary(textBlockPos);
                   if (currentAtomIndex == 0)
                   {
                       // when cursor is left of all characters (end of line)
                       // atomIndex is 0, so compensate
                       if (tl.atomCount > 0)
                       {
                           while (--textBlockPos)
                           {
							   --relativePosition;
                               if (tl.getAtomIndexAtCharIndex(textBlockPos) != currentAtomIndex)
                                   break;
                           }
                       }
                   }
                   else
                   {
                       while (--relativePosition && --textBlockPos)
                       {
                           if (tl.getAtomIndexAtCharIndex(textBlockPos) != currentAtomIndex)
                               break;
                       }
                   }
                   if (CharacterUtil.isLowSurrogate(getText(relativePosition, relativePosition + 1).charCodeAt(0)))
				   {
					   relativePosition--;
					   textBlockPos--;
				   }
				   
                   //trace("previous", relativePosition, foo);
                }
                else
                {
    				if (currentAtomIndex == 0)
    				{
    					tl = tl.previousLine;
    					if (!tl)
						{
							if(tb != _textBlocks[0])
								return relativePosition-1;
							return -1;
						}
    					// need this when 0x2028 line separator in use
    					if (tl.textBlockBeginIndex + tl.rawTextLength == textBlockPos)
    						return tl.textBlockBeginIndex + tl.rawTextLength - 1 + tbStart;
    					return tl.textBlockBeginIndex + tl.rawTextLength + tbStart;
    				}
    				while (--relativePosition && --textBlockPos)
    				{
    					if (tl.getAtomIndexAtCharIndex(textBlockPos) < currentAtomIndex)
    						break;
    				}
                    if (CharacterUtil.isLowSurrogate(getText(relativePosition, relativePosition + 1).charCodeAt(0)))
					{
						relativePosition--;
						textBlockPos--;
					}
                }
				return relativePosition;
			}
            var pos:int = tb.findPreviousAtomBoundary(textBlockPos);
			if(pos >= 0)
				pos += tbStart;
            //trace("previous", relativePosition, pos);
			return pos;
		}

		/** 
		 * Scans ahead from the supplied position to find the location
		 * in the text of the next atom and returns the index. The term atom refers to 
		 * both graphic elements and characters (including groups of combining characters), the 
		 * indivisible entities that make up a text line.
		 * 
		 * @param relativePosition  position in the text to start from, counting from 0
		 * @return index in the text of the following atom
		 *
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
	 	 * @see org.apache.royale.text.engine.ITextLine
		 */
		 
		public function findNextAtomBoundary(relativePosition:int):int
		{
			var tb:ITextBlock = getTextBlockAtPosition(relativePosition);
			if(!tb || !tb.content)
				return relativePosition+1;
			var tbStart:int = getTextBlockStart(tb);
			var textBlockPos:int = relativePosition - tbStart;
            var tl:ITextLine = tb.getTextLineAtCharIndex(textBlockPos);
			if (ConfigSettings.usesDiscretionaryHyphens && tl != null)
			{
				var currentAtomIndex:int = tl.getAtomIndexAtCharIndex(textBlockPos);
                //trace("relpos", relativePosition, "atomIndex", currentAtomIndex);
                var isRTL:Boolean = tl.getAtomBidiLevel(currentAtomIndex) == 1;
                if (isRTL)
                {
//                    var foo:int = tb.findNextAtomBoundary(textBlockPos);
                    if (currentAtomIndex == 0)
                    {
                        while (++textBlockPos)
                        {
							++relativePosition;
                            if (tl.getAtomIndexAtCharIndex(textBlockPos) != currentAtomIndex)
                                break;
                        }
                    }
                    else
                    {
                        while (++textBlockPos)
                        {
							++relativePosition;
                            if (tl.getAtomIndexAtCharIndex(textBlockPos) != currentAtomIndex)
                                break;
                        }
                    }
                    if (CharacterUtil.isHighSurrogate(getText(relativePosition, relativePosition + 1).charCodeAt(0)))
					{
						relativePosition++;
						textBlockPos++;
					}
                    //trace("next", relativePosition, foo);
                }
                else
                {
    				if (currentAtomIndex == tl.atomCount - 1)
    				{
    					tl = tl.nextLine;
    					if (!tl)
						{
							if(tb != _textBlocks[_textBlocks.length-1])
								return relativePosition+1;
							return -1;
						}
    					return tl.textBlockBeginIndex + tbStart;
    				}
    				while (++textBlockPos)
    				{
						++relativePosition;
    					if (tl.getAtomIndexAtCharIndex(textBlockPos) > currentAtomIndex)
    						break;
    				}
                    if (CharacterUtil.isHighSurrogate(getText(relativePosition, relativePosition + 1).charCodeAt(0)))
					{
						relativePosition++;
						textBlockPos++;
					}
                }
				return relativePosition;
			}
			var pos:int = tb.findNextAtomBoundary(textBlockPos);
			if(pos >= 0)
				pos += tbStart;
            //trace("next", relativePosition, pos);
            return pos;
		}
		
		/** @private */
		public override function getCharAtPosition(relativePosition:int):String
		{
			var foundTB:ITextBlock = getTextBlockAtPosition(relativePosition);
			if(!foundTB)
				return "\u0016";
			var tables:Vector.<ITableElement> = getTables();
			var pos:int = relativePosition;
			for each(var table:ITableElement in tables)
			{
				if(table.getElementRelativeStart(this) < pos)
					relativePosition--;
			}
			var tbs:Vector.<ITextBlock> = getTextBlocks();
			for each(var tb:ITextBlock in tbs)
			{
				if(foundTB == tb)
					break;
				if(tb)
					relativePosition -= tb.content.rawText.length;
				else
					relativePosition -= 1;//TODO was this needed? this.getText()
			}
			return foundTB.content.rawText.charAt(relativePosition);
		} 

		/** 
		 * Returns the index of the previous word boundary in the text.
		 * 
		 * <p>Scans backward from the supplied position to find the previous position
		 * in the text that starts or ends a word. </p>
		 * 
		 * @param relativePosition  position in the text to start from, counting from 0
		 * @return index in the text of the previous word boundary
		 *
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		 
		public function findPreviousWordBoundary(relativePosition:int):int
		{	
			if (relativePosition == 0)
				return 0;
			var prevCharCode:int = getCharCodeAtPosition(relativePosition - 1);
			if (CharacterUtil.isWhitespace(prevCharCode))
			{				
				while (CharacterUtil.isWhitespace(prevCharCode) && ((relativePosition - 1) > 0))
				{
					relativePosition--;
					prevCharCode = getCharCodeAtPosition(relativePosition - 1);
				}
				return relativePosition;
			}
			var block:ITextBlock = getTextBlockAtPosition(relativePosition);
			if(block == null)
				block = getTextBlockAtPosition(--relativePosition);
			var pos:int = getTextBlockStart(block);
			if(pos < 0)
				pos = 0;
			return relativePosition == pos ? pos : pos + block.findPreviousWordBoundary(relativePosition - pos);
		}

		/** 
		 * Returns the index of the next word boundary in the text.
		 * 
		 * <p>Scans ahead from the supplied position to find the next position
		 * in the text that starts or ends a word. </p>
		 * 
		 * @param relativePosition  position in the text to start from, counting from 0
		 * @return  index in the text of the next word boundary
		 * 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		 
		public function findNextWordBoundary(relativePosition:int):int
		{	
			if (relativePosition == textLength) 
				return textLength;
			var curCharCode:int = getCharCodeAtPosition(relativePosition);
			if (CharacterUtil.isWhitespace(curCharCode))
			{
				while (CharacterUtil.isWhitespace(curCharCode) && relativePosition < (textLength - 1))
				{
					relativePosition++;
					curCharCode = getCharCodeAtPosition(relativePosition);
				}
				return relativePosition;
			}
			var block:ITextBlock = getTextBlockAtPosition(relativePosition);
			if(block == null)
				block = getTextBlockAtPosition(--relativePosition);
			var pos:int = getTextBlockStart(block);
			if(pos < 0)
				pos = 0;
			return pos + block.findNextWordBoundary(relativePosition - pos);
		}
		
		static private var _defaultTabStops:Vector.<TabStop>;
		static private const defaultTabWidth:int = 48;		// matches default tabs setting in Argo
		static private const defaultTabCount:int = 20;
		
		static private function initializeDefaultTabStops():void
		{
			_defaultTabStops = new Vector.<TabStop>(defaultTabCount, true);
			for (var i:int = 0; i < defaultTabCount; ++i)
				_defaultTabStops[i] = new TabStop(TextAlign.START, defaultTabWidth * i);
		}
		
		private function updateTextBlock(textBlock:ITextBlock=null):void
		{
			if(!textBlock)
				textBlock = getTextBlock();
			// find the ancestor with a container and use its format for various settings
			var containerElement:IContainerFormattedElement = getAncestorWithContainer();
			if (!containerElement)
				return;
				
			var containerElementFormat:ITextLayoutFormat = containerElement ? containerElement.computedFormat : TextLayoutFormat.defaultFormat;
			
			var lineJust:String;
			if (computedFormat.textAlign == TextAlign.JUSTIFY)
			{
				lineJust = (_computedFormat.textAlignLast == TextAlign.JUSTIFY) ?
					LineJustification.ALL_INCLUDING_LAST :
					LineJustification.ALL_BUT_LAST;
					
				// We don't allow explicit line breaks and justification together because it results in very strange (invisible) lines
				if (containerElementFormat.lineBreak == LineBreak.EXPLICIT)
					lineJust = LineJustification.UNJUSTIFIED;
			}
			else
				lineJust = LineJustification.UNJUSTIFIED;
		
			
			var makeJustRuleStyle:String = this.getEffectiveJustificationStyle();
			
			var justRule:String = this.getEffectiveJustificationRule();
				
			// set the justifier in the ITextBlock
			if (justRule == JustificationRule.SPACE)
			{
				var spaceJustifier:SpaceJustifier = new SpaceJustifier(_computedFormat.locale,lineJust,false);
				spaceJustifier.letterSpacing = _computedFormat.textJustify == TextJustify.DISTRIBUTE ? true : false;

				// These three properties have to be set in the correct order so that consistency checks done
				// in the Player on set are never violated
				var newMinimumSpacing:Number = PropertyUtil.toNumberIfPercent(_computedFormat.wordSpacing.minimumSpacing)/100;
				var newMaximumSpacing:Number = PropertyUtil.toNumberIfPercent(_computedFormat.wordSpacing.maximumSpacing)/100;
				var newOptimumSpacing:Number = PropertyUtil.toNumberIfPercent(_computedFormat.wordSpacing.optimumSpacing)/100; 
				spaceJustifier.minimumSpacing = Math.min(newMinimumSpacing, spaceJustifier.minimumSpacing);
				spaceJustifier.maximumSpacing = Math.max(newMaximumSpacing, spaceJustifier.maximumSpacing);
				spaceJustifier.optimumSpacing = newOptimumSpacing;
				spaceJustifier.minimumSpacing = newMinimumSpacing;
				spaceJustifier.maximumSpacing = newMaximumSpacing;

				CONFIG::debug { Debugging.traceFTECall(spaceJustifier,null,"new SpaceJustifier",_computedFormat.locale,lineJust,spaceJustifier.letterSpacing); }
				textBlock.textJustifier = spaceJustifier;
				CONFIG::debug { Debugging.traceFTEAssign(textBlock,"textJustifier",spaceJustifier); }
				textBlock.baselineZero = LeadingUtils.getLeadingBasis(this.getEffectiveLeadingModel());
				CONFIG::debug { Debugging.traceFTEAssign(textBlock,"baselineZero",textBlock.baselineZero);  }
			}
			else
			{
				var eastAsianJustifier:Object = new EastAsianJustifier(_computedFormat.locale,lineJust, makeJustRuleStyle);
				if( /*Configuration.versionIsAtLeast(10,3) &&*/ eastAsianJustifier.hasOwnProperty("composeTrailingIdeographicSpaces")){
					eastAsianJustifier.composeTrailingIdeographicSpaces = true;
				}
				CONFIG::debug { Debugging.traceFTECall(eastAsianJustifier,null,"new EastAsianJustifier",_computedFormat.locale,lineJust,makeJustRuleStyle); }
				textBlock.textJustifier = eastAsianJustifier as EastAsianJustifier;
				CONFIG::debug { Debugging.traceFTEAssign(textBlock,"textJustifier",eastAsianJustifier);  }
				textBlock.baselineZero = LeadingUtils.getLeadingBasis(this.getEffectiveLeadingModel());
				CONFIG::debug { Debugging.traceFTEAssign(textBlock,"baselineZero",textBlock.baselineZero);  }
			}
			
			textBlock.bidiLevel = _computedFormat.direction == Direction.LTR ? 0 : 1;
			CONFIG::debug { Debugging.traceFTEAssign(textBlock,"bidiLevel",textBlock.bidiLevel);  }

			textBlock.lineRotation = containerElementFormat.blockProgression == BlockProgression.RL ? TextRotation.ROTATE_90 : TextRotation.ROTATE_0;
			CONFIG::debug { Debugging.traceFTEAssign(textBlock,"lineRotation",textBlock.lineRotation);  }
			
			if (_computedFormat.tabStops && _computedFormat.tabStops.length != 0)
			{
				//create a vector of TabStops and assign it to tabStops in textBlock
				var tabStops:Vector.<TabStop> = new Vector.<TabStop>();
				CONFIG::debug { Debugging.traceFTECall(tabStops,null,"new Vector.<TabStop>()"); }
				for each(var tsa:TabStopFormat in _computedFormat.tabStops)
				{
					var token:String = tsa.decimalAlignmentToken==null ? "" : tsa.decimalAlignmentToken;
					var alignment:String = tsa.alignment==null ? TabAlignment.START : tsa.alignment;
					var tabStop:TabStop = new TabStop(alignment,Number(tsa.position),token);
					// this next line when uncommented works around bug 1912782
					if (tsa.decimalAlignmentToken != null) var garbage:String = "x" + tabStop.decimalAlignmentToken;
					CONFIG::debug { Debugging.traceFTECall(tabStop,null,"new TabStop",tabStop.alignment,tabStop.position,tabStop.decimalAlignmentToken); }
					tabStops.push(tabStop);
					CONFIG::debug { Debugging.traceFTECall(null,tabStops,"push",tabStop); }
				}
				textBlock.tabStops = tabStops;
				CONFIG::debug { Debugging.traceFTEAssign(textBlock,"tabStops",tabStops);  }
			} //TODO make sure the Text Engine sets default tab stops
			// else if (GlobalSettings.enableDefaultTabStops && !Configuration.playerEnablesArgoFeatures)
			// {
			// 	// 	Player versions prior to 10.1 do not set up any default tabStops. As a workaround, if enableDefaultTabs
			// 	//	is true, TLF will set up default tabStops in the case where there are no tabs defined. 
			// 	if (_defaultTabStops == null)
			// 		initializeDefaultTabStops();
			// 	textBlock.tabStops = _defaultTabStops;
			// 	CONFIG::debug { Debugging.traceFTEAssign(textBlock,"tabStops",_defaultTabStops);  }
			// }
			else
			{
				textBlock.tabStops = null;
				CONFIG::debug { Debugging.traceFTEAssign(textBlock,"tabStops",null);  }
			}		 
		}
		
		/** @private */
		public override function get computedFormat():ITextLayoutFormat
		{
			if (!_computedFormat)
			{
				super.computedFormat;
				var tbs:Vector.<ITextBlock> = getTextBlocks();
				for each(var tb:ITextBlock in tbs)
					updateTextBlock(tb);
					
			}
			return _computedFormat;
		}

		/** @private */
		public override function canOwnFlowElement(elem:IFlowElement):Boolean
		{
			return elem is IFlowLeafElement || elem is ISubParagraphGroupElementBase || elem is ITableElement;
		}
		
		/** @private */
		public override function normalizeRange(normalizeStart:uint,normalizeEnd:uint):void
		{
			var idx:int = findChildIndexAtPosition(normalizeStart);
			if (idx != -1 && idx < numChildren)
			{
				var child:IFlowElement = getChildAt(idx);
				normalizeStart = normalizeStart-child.parentRelativeStart;
				
				CONFIG::debug { assert(normalizeStart >= 0, "bad normalizeStart in normalizeRange"); }
				for (;;)
				{
					// watch out for changes in the length of the child
					var origChildEnd:int = child.parentRelativeStart+child.textLength;
					child.normalizeRange(normalizeStart,normalizeEnd-child.parentRelativeStart);
					var newChildEnd:int = child.parentRelativeStart+child.textLength;
					normalizeEnd += newChildEnd-origChildEnd;	// adjust
					
					// no zero length children
					if (child.textLength == 0 && !child.bindableElement)
						replaceChildren(idx,idx+1);
					else if (child.mergeToPreviousIfPossible())
					{
						var prevElement:IFlowElement = this.getChildAt(idx-1);
						// possibly optimize the start to the length of prevelement before the merge
						prevElement.normalizeRange(0,prevElement.textLength);
					}
					else
						idx++;

					if (idx == numChildren)
					{
						// check if last child is an empty SubPargraphBlock and remove it
						if (idx != 0)
						{
							var lastChild:IFlowElement = this.getChildAt(idx-1);
							if (lastChild is ISubParagraphGroupElementBase && lastChild.textLength == 1 && !lastChild.bindableElement)
								replaceChildren(idx-1,idx);
						}
						break;
					}
					
					// next child
					child = getChildAt(idx);
					
					if (child.parentRelativeStart > normalizeEnd)
						break;
						
					normalizeStart = 0;		// for the next child	
				}
			}
			
			// empty paragraphs not allowed after normalize
			if (numChildren == 0 || textLength == 0)
			{
				var s:ISpanElement = ElementHelper.getSpan();
				replaceChildren(0,0,s);
				s.normalizeRange(0,s.textLength);
			}
		}
		
		/** @private */
		public function getEffectiveLeadingModel():String
		{
			return computedFormat.leadingModel == LeadingModel.AUTO ? LocaleUtil.leadingModel(computedFormat.locale) : computedFormat.leadingModel;
		}
		
		/** @private */
		public function getEffectiveDominantBaseline():String
		{
			return computedFormat.dominantBaseline == FormatValue.AUTO ? LocaleUtil.dominantBaseline(computedFormat.locale) : computedFormat.dominantBaseline;
		}
		
		/** @private */
		public function getEffectiveJustificationRule():String
		{
			return computedFormat.justificationRule == FormatValue.AUTO ? LocaleUtil.justificationRule(computedFormat.locale) : computedFormat.justificationRule;
		}
		
		/** @private */
		public function getEffectiveJustificationStyle():String
		{
			return computedFormat.justificationStyle == FormatValue.AUTO ? LocaleUtil.justificationStyle(computedFormat.locale) : computedFormat.justificationStyle;
		}
		
		
		/** @private */
		CONFIG::debug public override function debugCheckFlowElement(depth:int = 0, extraData:String = ""):int
		{
			var tb:ITextBlock = getTextBlock();
			var rslt:int = super.debugCheckFlowElement(depth," fte:"+getDebugIdentity(tb)+" "+extraData);
			
			// now check the character count and then the last character 
			
			if (tb)
			{
				var contentLength:int = tb.content && tb.content.rawText ? tb.content.rawText.length : 0;
				rslt += assert(contentLength == textLength,"Bad paragraph length mode:"+textLength.toString()+" _textBlock:" + contentLength.toString());

				var groupElement:GroupElement = tb.content as GroupElement;
				if (groupElement)
					assert(groupElement.elementCount == numChildren,"Mismatched group and elementCount"); 
				else if (tb.content)
					assert(1 == numChildren,"Mismatched group and elementCount"); 
				else 
					assert(0 == numChildren,"Mismatched group and elementCount"); 
			}
			rslt += assert(numChildren == 0 || textLength > 0,"Para must have at least one text char");
			return rslt;
		}
		

		
		public function incInteractiveChildrenCount() : void
		{
			++ _interactiveChildrenCount ;
		}
		public function decInteractiveChildrenCount() : void
		{
			-- _interactiveChildrenCount ;
		}
		
		public function hasInteractiveChildren() : Boolean
		{
			return _interactiveChildrenCount != 0 ;
		}

		public function get terminatorSpan():ISpanElement
		{
			return _terminatorSpan;
		}

	}
}
