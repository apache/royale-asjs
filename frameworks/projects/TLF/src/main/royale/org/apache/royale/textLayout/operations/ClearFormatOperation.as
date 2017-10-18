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
package org.apache.royale.textLayout.operations
{
	import org.apache.royale.textLayout.edit.ElementRange;
	import org.apache.royale.textLayout.edit.ParaEdit;
	import org.apache.royale.textLayout.edit.PointFormat;
	import org.apache.royale.textLayout.edit.SelectionState;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;


		
	/**
	 * The ClearFormatOperation class encapsulates a way to undefine formats.
	 * 
	 * <p>An UndefineFormatOperation undefines properties set in the leaf format to the text in the 
	 * specified range (no change is made if the specified range is a single point). 
	 * It undefines properties set in the paragraph format to any paragraphs at least partially within the range 
	 * (or a single paragraph if the range is a single point). 
	 * And it undefines properties set in the container format to any containers at least partially within the range 
	 * (or a single container if the range is a single point).</p>
	 *
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class ClearFormatOperation extends FlowTextOperation
	{
		private var applyLeafFormat:ITextLayoutFormat;
		private var applyParagraphFormat:ITextLayoutFormat;
		private var applyContainerFormat:ITextLayoutFormat;

		// helper array of styles to revert
		// each entry has a begIdx, endIdx, ContainerFormat
		private var undoLeafArray:Array;	
		private var undoParagraphArray:Array;	
		private var undoContainerArray:Array;	
		
		/** 
		 * Creates an ClearFormatOperation object.
		 *
		 *  @param operationState	Defines the text range to which the format is applied.
		 *  @param leafFormat	 The format whose set values indicate properties to undefine to LeafFlowElement objects in the selected range.
		 *  @param paragraphFormat The format whose set values indicate properties to undefine to ParagraphElement objects in the selected range.
		 *  @param containerFormat The format whose set values indicate properties to undefine to ContainerController objects in the selected range.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */		
		public function ClearFormatOperation(operationState:SelectionState, leafFormat:ITextLayoutFormat, paragraphFormat:ITextLayoutFormat, containerFormat:ITextLayoutFormat = null)
		{
			super(operationState);
			this.leafFormat = leafFormat;
			this.paragraphFormat = paragraphFormat;
			this.containerFormat = containerFormat;
		}

		/** 
		 * The format properties to undefine on the leaf elements in the range.
		 * 
		 * <p>If the range of this operation is a point, or if <code>leafFormat</code> is <code>null</code>,
		 * then no leaf element formats are changed.</p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get leafFormat():ITextLayoutFormat
		{
			return applyLeafFormat;
		}
		public function set leafFormat(value:ITextLayoutFormat):void
		{
			applyLeafFormat = value ? new TextLayoutFormat(value) : null;
		}
		
		/** 
		 * The format properties to undefine on the paragraphs in the range.
		 * 
		 * <p>The formats of any paragraphs at least partially within the range are updated. 
		 * If the range of this operation is a point, then a single paragraph is updated.
		 * If <code>paragraphFormat</code> is <code>null</code>, then no paragraph formats are changed.</p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get paragraphFormat():ITextLayoutFormat
		{
			return applyParagraphFormat;
		}
		public function set paragraphFormat(value:ITextLayoutFormat):void
		{
			applyParagraphFormat = value ? new TextLayoutFormat(value) : null;
		}
		
		/** 
		 * The format properties to undefine on the containers in the range.
		 * 
		 * <p>The formats of any containers at least partially within the range are updated. 
		 * If the range of this operation is a point, then a single container is updated.
		 * If <code>containerFormat</code> is <code>null</code>, then no container formats are changed.</p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get containerFormat():ITextLayoutFormat
		{
			return applyContainerFormat;
		}
		public function set containerFormat(value:ITextLayoutFormat):void
		{
			applyContainerFormat = value ? new TextLayoutFormat(value) : null;
		}
		
		private function doInternal():SelectionState
		{
			var anyNewSelectionState:SelectionState;

			// Apply character format
			if (applyLeafFormat)
			{
				if (absoluteStart != absoluteEnd)
				{
					var range:ElementRange = ElementRange.createElementRange(textFlow, absoluteStart,absoluteEnd);
					
					var begSel:int = range.absoluteStart;
					var endSel:int = range.absoluteEnd;
					if(endSel == textFlow.textLength - 1)
						++endSel;
						
				//	CONFIG::debug { if (begSel != absoluteStart || endSel != absoluteEnd) trace("found mismatch ApplyFormatOperation"); }
					if (!undoLeafArray)
					{
						undoLeafArray = new Array();
						ParaEdit.cacheStyleInformation(textFlow,begSel,endSel,undoLeafArray);
					}
					ParaEdit.applyTextStyleChange(textFlow,begSel,endSel,null,applyLeafFormat);
				}
				else if (originalSelectionState.selectionManagerOperationState && textFlow.interactionManager)
				{
					// on point selection remember pendling leaf formats for next char typed
					
					anyNewSelectionState = originalSelectionState.clone();
					// This is only a partial implementation - see watson bug 
					// here if the format is pending we can clear it
					// The bug is that we don't remember any pending clear that's not set in pointFormat on the next character typed
					var newFormat:PointFormat = new PointFormat(anyNewSelectionState.pointFormat);
					for (var prop:String in TextLayoutFormat.description)
					{
						if (applyLeafFormat[prop] !== undefined)
							newFormat[prop] = undefined;
					}
					anyNewSelectionState.pointFormat = newFormat;
				}				
			}

			if (applyParagraphFormat)
			{
				if (!undoParagraphArray)
				{
					undoParagraphArray = new Array();
					ParaEdit.cacheParagraphStyleInformation(textFlow,absoluteStart, absoluteEnd,undoParagraphArray);
				}
				ParaEdit.applyParagraphStyleChange(textFlow,absoluteStart, absoluteEnd, null, applyParagraphFormat);
			}
			if (applyContainerFormat)
			{
				if (!undoContainerArray)
				{
					undoContainerArray = new Array();
					ParaEdit.cacheContainerStyleInformation(textFlow,absoluteStart,absoluteEnd,undoContainerArray);
				}
				ParaEdit.applyContainerStyleChange(textFlow,absoluteStart,absoluteEnd, null, applyContainerFormat);
			}
			return anyNewSelectionState;
		}
		
		/** @private */
		public override function doOperation():Boolean
		{ 
			var newSelectionState:SelectionState = doInternal();
			if (newSelectionState && textFlow.interactionManager)
				textFlow.interactionManager.setSelectionState(newSelectionState);
			return true;
		}

		override public function redo():SelectionState
		{
			var newSelectionState:SelectionState = doInternal();
			return newSelectionState? newSelectionState : originalSelectionState;
		}		

		/** @private */
		public override function undo():SelectionState
		{ 
			var obj:Object;
			
			// Undo character format changes
			for each (obj in undoLeafArray)
				ParaEdit.setTextStyleChange(textFlow,obj.begIdx,obj.endIdx,obj.style);

			// Undo paragraph format changes
			for each (obj in undoParagraphArray)
				ParaEdit.setParagraphStyleChange(textFlow,obj.begIdx,obj.endIdx,obj.attributes);

			// Undo container format changes
			for each (obj in undoContainerArray)
				ParaEdit.setContainerStyleChange(obj);

			return originalSelectionState;
		}
		
	}
}
