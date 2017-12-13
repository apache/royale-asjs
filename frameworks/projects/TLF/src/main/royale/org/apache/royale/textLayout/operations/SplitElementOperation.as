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
package org.apache.royale.textLayout.operations {
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.edit.ElementMark;
	import org.apache.royale.textLayout.edit.IMemento;
	import org.apache.royale.textLayout.edit.ModelEdit;
	import org.apache.royale.textLayout.edit.SelectionState;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.IListItemElement;
	import org.apache.royale.textLayout.elements.ISubParagraphGroupElementBase;
	import org.apache.royale.textLayout.formats.ListMarkerFormat;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;

	





	/**
	 * The SplitElementOperation class encapsulates a change that splits any IFlowGroupElement into two elements.
	 *
	 * This operation splits target at operationState.absoluteStart.
	 * 
	 * @see org.apache.royale.textLayout.elements.ParagraphElement
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */			
	public class SplitElementOperation extends FlowTextOperation
	{
		//range for block delete
		private var delSelOp:DeleteTextOperation;		

		// describes the target
		private var _targetMark:ElementMark;
		
		// moment to undo
		private var _memento:IMemento;
		
		// new element to return to client
		private var _newElement:IFlowGroupElement;
		/** 
		 * Creates a SplitElementOperation object.  This operation deletes a block selection and then splits the target at absoluteStart.  The block selection should not cause target to be deleted.
		 * Target is a IFlowGroupElement but may not be a LinkElement, TCYElement or SubParagraphGroupElement.
		 * 
		 * @param operationState Describes the point at which to split the element.
		 * If a range of text is specified, the contents of the range are deleted.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function SplitElementOperation(operationState:SelectionState, targetElement:IFlowGroupElement)
		{
			super(operationState);
			this.targetElement = targetElement;
		}
		
		/** 
		 * Specifies the element this operation modifies.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get targetElement():IFlowGroupElement
		{
			return _targetMark.findElement(originalSelectionState.textFlow) as IFlowGroupElement;
		}
		public function set targetElement(value:IFlowGroupElement):void
		{
			_targetMark = new ElementMark(value,0);
		}
		
		/** 
		 * Returns the new element created by doOperation.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get newElement():IFlowGroupElement
		{ return _newElement; }
		
		/** @private */
		public override function doOperation():Boolean
		{ 
			var target:IFlowGroupElement = targetElement;
			
			if (absoluteStart < absoluteEnd)
			{
				// watch out for total deletion of target
				var targStart:int = target.getAbsoluteStart();
				var targEnd:int   = targStart + target.textLength;
				
				delSelOp = new DeleteTextOperation(originalSelectionState);
				delSelOp.doOperation();
				
				if (absoluteStart <= targStart && targEnd <= absoluteEnd)
				{
					// completely deleted
					if (target is IParagraphElement)
						target = textFlow.findAbsoluteParagraph(absoluteStart);
					else
						target = null;	
				}
				else
					target = targetElement;	// recalculate
				
			}
			
			// SubParagraphGroupElements don't split as the target - they just merge again in normalize.  
			// Consider some sort of way to do this.  Generally has to be combined with another operation or somehow marked as don't merge
			// make sure it hasn't been deleted during the delete phase
			if (target != null && !(target is ISubParagraphGroupElementBase) && target.getTextFlow() == textFlow)
			{
				var oldLength:int = textFlow.textLength;
				var relativePosition:int = absoluteStart-target.getAbsoluteStart();
				_memento = ModelEdit.splitElement(textFlow,target,relativePosition);
				_newElement = target.parent.getChildAt(target.parent.getChildIndex(target)+1) as IFlowGroupElement;

				// fix for 2702736 - when splitting a IListItemElement, make sure not to clone the counterReset marker format - it creates unexpected results, new items don't increment
				if(_newElement is IListItemElement && 
					_newElement.listMarkerFormat && 
					_newElement.listMarkerFormat.counterReset !== undefined)
				{
					var listMarkerFormat:ListMarkerFormat = new ListMarkerFormat(_newElement.listMarkerFormat);
					listMarkerFormat.counterReset = undefined;
					_newElement.listMarkerFormat = listMarkerFormat;
				}
				
				
				if( target is IParagraphElement )
				{
					// fix for bug#2948473 - when splitting, the contain/column break settings will not be copied to the
					// new paragraph element
					var newFormat:TextLayoutFormat = new TextLayoutFormat(_newElement.format);
					newFormat.containerBreakAfter = undefined;
					newFormat.containerBreakBefore = undefined;
					newFormat.columnBreakAfter = undefined;
					newFormat.columnBreakBefore = undefined;
					_newElement.format = newFormat;
					
					if (textFlow.interactionManager && oldLength != textFlow.textLength)
						textFlow.interactionManager.notifyInsertOrDelete(absoluteStart, textFlow.textLength-oldLength);
				}
						
					
			}

			return true;
		}
	
		/** @private */
		public override function undo():SelectionState
		{ 
			if (_memento)
				_memento.undo();	
			_newElement = null;
			
			return absoluteStart < absoluteEnd ? delSelOp.undo() : originalSelectionState;
		}
		
		/** @private */
		public override function redo():SelectionState
		{
			super.redo();
			return textFlow.interactionManager.getSelectionState();
		}
	}
}
