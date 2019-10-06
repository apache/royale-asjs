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
	import org.apache.royale.textLayout.edit.SelectionState;
	import org.apache.royale.textLayout.edit.TextScrap;




	
	/**
	 * The CutOperation class encapsulates a cut operation.
	 *
	 * <p>The specified range is removed from the text flow.</p>
	 * 
	 * <p><b>Note:</b> The edit manager is responsible for copying the 
	 * text scrap to the clipboard. Undoing a cut operation does not restore
	 * the original clipboard state.</p>
	 * 
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class CutOperation extends FlowTextOperation
	{
		private var _tScrap:TextScrap;
		private var _deleteTextOperation:DeleteTextOperation;
		
		/** 
		 * Creates a CutOperation object.
		 * 
		 * @param operationState The range of text to be cut.
		 * @param scrapToCut A copy of the deleted text.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function CutOperation(operationState:SelectionState, scrapToCut:TextScrap)
		{
			super(operationState);
			if (absoluteStart < absoluteEnd)
				_tScrap = scrapToCut;
		}
		
		
		/** @private */
		public override function doOperation():Boolean
		{
			_deleteTextOperation = new DeleteTextOperation(originalSelectionState);
			return _deleteTextOperation.doOperation();
		}
		
		/** @private */
		public override function undo():SelectionState
		{
			return _deleteTextOperation.undo();
		}
	
		/** @private */
		public override function redo():SelectionState
		{
			return _deleteTextOperation.redo();
		}
		
		/** 
		 * scrapToCut the original removed text
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function get scrapToCut():TextScrap
		{ return _tScrap; }
		public function set scrapToCut(val:TextScrap):void
		{ _tScrap = val; }
		
	}
}
