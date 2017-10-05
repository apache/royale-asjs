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

	


	/**
	 * A read only class that describes a range of contiguous text. Such a range occurs when you select a
	 * section of text. The range consists of the anchor point of the selection, <code>anchorPosition</code>,
	 * and the point that is to be modified by actions, <code>activePosition</code>.  As block selections are 
	 * modified and extended <code>anchorPosition</code> remains fixed and <code>activePosition</code> is modified.  
	 * The anchor position may be placed in the text before or after the active position.
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
 	 * @langversion 3.0
	 *
	 * @see org.apache.royale.textLayout.elements.TextFlow TextFlow
	 * @see org.apache.royale.textLayout.edit.SelectionState SelectionState
	 */
	public class TextRange
	{
		/** The TextFlow of the selection.
 	 	 */
		private var _textFlow:ITextFlow;
		
		// current range of selection
		/** Anchor point of the current selection, as an absolute position in the TextFlow. */
		private var _anchorPosition:int;
		/** Active end of the current selection, as an absolute position in the TextFlow. */
		private var _activePosition:int;
		
		private function clampToRange(index:int):int
		{
			if (index < 0)
				return 0;
			if (index > _textFlow.textLength)
				return _textFlow.textLength;
			return index;
		}
		
		/** Constructor - creates a new TextRange instance.  A TextRange can be (-1,-1), indicating no range, or a pair of 
		* values from 0 to <code>TextFlow.textLength</code>.
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 * @param	root	the TextFlow associated with the selection.
		 * @param anchorIndex	the index position of the anchor in the selection. The first position in the text is position 0.
		 * @param activeIndex	the index position of the active location in the selection. The first position in the text is position 0. 
		 *
		 * @see FlowElement#textLength
		 */		
		public function TextRange(root:ITextFlow,anchorIndex:int,activeIndex:int)
		{
			_textFlow = root;
			
			if (anchorIndex != -1 || activeIndex != -1)
			{
				anchorIndex = clampToRange(anchorIndex);
				activeIndex = clampToRange(activeIndex);
			}
			
			_anchorPosition = anchorIndex;
			_activePosition = activeIndex;
		}
		
		/** Update the range with new anchor or active position values.
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 *  @param newAnchorPosition	the anchor index of the selection.
		 *  @param newActivePosition	the active index of the selection.
		 *  @return true if selection is changed.
		 */
		public function updateRange(newAnchorPosition:int,newActivePosition:int):Boolean
		{
			if (newAnchorPosition != -1 || newActivePosition != -1)
			{
				newAnchorPosition = clampToRange(newAnchorPosition);
				newActivePosition = clampToRange(newActivePosition);
			}
			
			if (_anchorPosition != newAnchorPosition || _activePosition != newActivePosition)
			{
				_anchorPosition = newAnchorPosition;
				_activePosition = newActivePosition;
				return true;
			}
			return false;
		}
		
		/** Returns the TextFlow associated with the selection.
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */						
		public function get textFlow():ITextFlow
		{ return _textFlow; }
		public function set textFlow(value:ITextFlow):void
		{ _textFlow = value; }
		
		/** Anchor position of the selection, as an absolute position in the TextFlow.
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */								
		public function get anchorPosition():int
		{ return _anchorPosition; }
		public function set anchorPosition(value:int):void
		{ _anchorPosition = value; }
		
		/** Active position of the selection, as an absolute position in the TextFlow.
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */										
		public function get activePosition():int
		{ return _activePosition; }
		public function set activePosition(value:int):void
		{ _activePosition = value; }
		
		/** Start of the selection, as an absolute position in the TextFlow.
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */										
		public function get absoluteStart():int
		{ return _activePosition < _anchorPosition ? _activePosition : _anchorPosition; }
		public function set absoluteStart(value:int):void
		{
			if (_activePosition < _anchorPosition)
				_activePosition = value;
			else
				_anchorPosition = value;
		}
		
		/** End of the selection, as an absolute position in the TextFlow.
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */								
		public function get absoluteEnd():int
		{ return _activePosition > _anchorPosition ? _activePosition : _anchorPosition; }
		public function set absoluteEnd(value:int):void
		{
			if (_activePosition > _anchorPosition)
				_activePosition = value;
			else
				_anchorPosition = value;
		}		
	}
}
