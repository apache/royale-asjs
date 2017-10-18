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
package org.apache.royale.textLayout.edit
{
	import org.apache.royale.textLayout.conversion.ConversionConstants;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ISpanElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.elements.TextRange;

	


	/**
	 * The TextScrap class represents a fragment of a text flow.
	 * 
	 * <p>A TextScrap is a holding place for all or part of a TextFlow. A range of text can be copied 
	 * from a TextFlow into a TextScrap, and pasted from the TextScrap into another TextFlow.</p>
	 *
	 * @see org.apache.royale.textLayout.elements.TextFlow
	 * @see org.apache.royale.textLayout.edit.SelectionManager
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
 	 * @langversion 3.0
	*/	
	public class TextScrap
	{	
		private var _textFlow:ITextFlow;
		private var _plainText:int;		/* flag to tell if text in scrap is plain or formatted: -1 = unknown, 0 = false, 1 = true

		// These are duplicates of same entries in TextConverter, here to avoid dragging in more code caused by compiler bug.
		// Remove this when http://bugs.adobe.com/jira/browse/ASC-4092 is fixed. 
		/** @private */
		static public const MERGE_TO_NEXT_ON_PASTE:String = "mergeToNextOnPaste";
		
		/**
		 * Creates a TextScrap object.
		 * 
		 * <p>Use the <code>createTextScrap()</code> method to create a TextScrap object from
		 * a range of text represented by a TextRange object.</p>
		 *  
		 * @param textFlow if set, the new TextScrap object contains the entire text flow.
		 * Otherwise, the TextScrap object is empty.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */												
		public function TextScrap(textFlow:ITextFlow = null)
		{
			_textFlow = textFlow;
			_textFlow.flowComposer = null;	// no flowcomposer in a TextScrap
			_plainText = -1;
		}

		/**
		 * Creates a TextScrap object from a range of text represented by a TextRange object.
		 * 
		 * @param range the TextRange object representing the range of text to copy.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */
		public static function createTextScrap(range:TextRange):TextScrap
		{
			var startPos:int = range.absoluteStart;
			var endPos:int = range.absoluteEnd;
			var theFlow:ITextFlow = range.textFlow;
			
			if (!theFlow || startPos >= endPos) 
				return null;
			var newTextFlow:ITextFlow = theFlow.deepCopy(startPos, endPos) as ITextFlow;
			newTextFlow.normalize();
			var retTextScrap:TextScrap = new TextScrap(newTextFlow);
			if (newTextFlow.textLength > 0)
			{
				var fl:IFlowElement = newTextFlow.getLastLeaf();
				
				var srcElem:IFlowElement = theFlow.findLeaf(endPos - 1);
				var copyElem:IFlowElement = newTextFlow.getLastLeaf();
				if ((copyElem is ISpanElement) && (!(srcElem is ISpanElement)))
					copyElem = newTextFlow.findLeaf(newTextFlow.textLength - 2);
				
				while (copyElem && srcElem)
				{
					if (endPos < srcElem.getAbsoluteStart() + srcElem.textLength)
						copyElem.setStyle(ConversionConstants.MERGE_TO_NEXT_ON_PASTE, "true");
					copyElem = copyElem.parent;
					srcElem = srcElem.parent;
				}
				return retTextScrap;
			}
			return null;
		}
		
		/** 
		 * Gets the TextFlow that is currently in the TextScrap.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */												
		public function get textFlow():ITextFlow
		{
			return _textFlow;
		}
		
		/**
		 * Creates a duplicate copy of this TextScrap object.
		 * 
		 * @return TextScrap A copy of this TextScrap.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */
		public function clone():TextScrap
		{
			return new TextScrap(textFlow.deepCopy() as ITextFlow);
		}

		/** Marks the TextScrap's content as being either plain or formatted */
		public function setPlainText(plainText:Boolean):void
		{
			_plainText = plainText ? 0 : 1;
		}
		
		/** 
		 * Returns true if the text is plain text (not formatted)
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */												
		public function isPlainText():Boolean
		{
			var foundAttributes:Boolean = false;
			
			if (_plainText == -1)
			{
				for (var i:int = _textFlow.numChildren - 1; i >= 0; --i)
					_textFlow.getChildAt(i).applyFunctionToElements(isPlainElement);
				_plainText = foundAttributes ? 1 : 0;
			}
			return _plainText == 0;
			
			function isPlainElement(element:IFlowElement):Boolean
			{
				if (!(element is IParagraphElement) && !(element is ISpanElement))
				{
					foundAttributes = true;
					return true;
				}
				var styles:Object = element.styles;
				if (styles)
				{
					for (var prop:String in styles)
					{
						if (prop != ConversionConstants.MERGE_TO_NEXT_ON_PASTE)
						{
							foundAttributes = true;
							return true;		// stops iteration
						}
					}
				}
				return false;
			}
		}
	} // end TextScrap class
} // end package
