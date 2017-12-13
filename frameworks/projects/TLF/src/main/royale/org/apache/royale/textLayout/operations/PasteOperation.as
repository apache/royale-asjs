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
	import org.apache.royale.textLayout.conversion.ConversionConstants;
	import org.apache.royale.textLayout.edit.ModelEdit;
	import org.apache.royale.textLayout.edit.SelectionState;
	import org.apache.royale.textLayout.edit.TextFlowEdit;
	import org.apache.royale.textLayout.edit.TextScrap;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;






	/**
	 * The PasteOperation class encapsulates a paste operation.
	 *
	 * <p>The specified range is replaced by the new content.</p>
	 * 
	 * <p><b>Note:</b> The edit manager is responsible for copying the 
	 * contents of the clipboard.</p>
	 * 
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */			
	public class PasteOperation extends FlowTextOperation
	{
		private var _textScrap:TextScrap;
		private var _numCharsAdded:int = 0;
		private var _deleteTextOperation:DeleteTextOperation;
		private var _applyParagraphSettings:Array;
		private var _pointFormat:ITextLayoutFormat;
		private var _applyPointFormat:ApplyFormatOperation;
		
		/** 
		 * Creates a PasteOperation object.
		 * 
		 * @param operationState Describes the insertion point or a range of text 
		 * to replace.
		 * @param textScrap The content to paste into the text flow.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function PasteOperation(operationState:SelectionState, textScrap:TextScrap)
		{
			_pointFormat = operationState.pointFormat;
			super(operationState);
			_textScrap = textScrap;
		}
		
		/** @private */
		public override function doOperation():Boolean
		{
			if (_textScrap != null)
			{
				if (absoluteStart != absoluteEnd)	
				{
					_deleteTextOperation = new DeleteTextOperation(originalSelectionState);
					_deleteTextOperation.doOperation();
				}
				
				var preserveScrapParagraph:Boolean = false;
				var plainText:Boolean = _textScrap.isPlainText();
				if (!plainText)
				{
					// If we're pasting formatted text into an empty paragraph, apply the paragraph settings from the scrap to the paragraph in the TextFlow
					var leaf:IFlowLeafElement = textFlow.findLeaf(absoluteStart);
					var paragraph:IParagraphElement = leaf.getParagraph();
					if (paragraph.textLength == 1)
						preserveScrapParagraph = true;
				}
				var nextInsertPosition:int = TextFlowEdit.insertTextScrap(textFlow, absoluteStart, _textScrap, plainText);
				if (textFlow.interactionManager)
					textFlow.interactionManager.notifyInsertOrDelete(absoluteStart, nextInsertPosition - absoluteStart);				
				_numCharsAdded = (nextInsertPosition - absoluteStart);
				
				if (preserveScrapParagraph)
				{
					applyPreserveSettings();
				} 
				else if (_pointFormat && plainText)
				{
					_applyPointFormat = new ApplyFormatOperation(new SelectionState(textFlow, absoluteStart, absoluteStart + _numCharsAdded), _pointFormat, null, null);
					_applyPointFormat.doOperation();
				}

				
				
			}
			return true;	
		}
		
		private function applyPreserveSettings():void
		{
			var scrap:ITextFlow = _textScrap.textFlow;
			var scrapParagraph:IParagraphElement = scrap.getFirstLeaf().getParagraph();
			
			_applyParagraphSettings = [];
			var format:TextLayoutFormat = new TextLayoutFormat(scrapParagraph.format);
			format.setStyle(ConversionConstants.MERGE_TO_NEXT_ON_PASTE, undefined);
			var applyParagraphFormat:ApplyFormatToElementOperation = new ApplyFormatToElementOperation(originalSelectionState, textFlow.findLeaf(absoluteStart).getParagraph(), format);
			applyParagraphFormat.doOperation();
			_applyParagraphSettings.push(applyParagraphFormat);			
			
			//bug #2826905
			if(scrap.numChildren > 1){
				var scrapEndParagraph:IParagraphElement = scrap.getLastLeaf().getParagraph();
				format = new TextLayoutFormat(scrapEndParagraph.format);
				format.setStyle(ConversionConstants.MERGE_TO_NEXT_ON_PASTE, undefined);
				var applyEndParagraphFormat:ApplyFormatToElementOperation = new ApplyFormatToElementOperation(originalSelectionState, textFlow.findLeaf(absoluteStart + scrap.textLength - 1).getParagraph(), format);
				applyEndParagraphFormat.doOperation();
				_applyParagraphSettings.push(applyEndParagraphFormat);
			}
		}
		
		/** @private */
		public override function undo():SelectionState
		{
			if (_textScrap != null)
			{
				if (_applyPointFormat)
					_applyPointFormat.undo(); 
				if (_applyParagraphSettings)
				{
					for (var i:int = _applyParagraphSettings.length - 1; i >= 0; --i)
						_applyParagraphSettings[i].undo();
				}
				ModelEdit.deleteText(textFlow, absoluteStart, absoluteStart + _numCharsAdded, false);
				if (_deleteTextOperation)
					_deleteTextOperation.undo();
			}
			return originalSelectionState;	
		}
	
		/** @private */
		public override function redo():SelectionState
		{
			if (_textScrap != null)
			{
				if (_deleteTextOperation)
					_deleteTextOperation.redo();
				var nextInsertPosition:int = TextFlowEdit.insertTextScrap(textFlow, absoluteStart, _textScrap, _textScrap.isPlainText());
				if (textFlow.interactionManager)
					textFlow.interactionManager.notifyInsertOrDelete(absoluteStart, nextInsertPosition - absoluteStart);		
				if (_applyParagraphSettings)
				{
					for (var i:int = _applyParagraphSettings.length - 1; i >= 0; --i)
						_applyParagraphSettings[i].redo();
				}
				if (_applyPointFormat)
					_applyPointFormat.redo(); 
			}
			return new SelectionState(textFlow, absoluteStart + _numCharsAdded, absoluteStart + _numCharsAdded,null);	
		}		

		/** 
		 * textScrap the text being pasted
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function get textScrap():TextScrap
		{ return _textScrap; }
		public function set textScrap(val:TextScrap):void
		{ _textScrap = val; }		
	}
}
