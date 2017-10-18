
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
	import org.apache.royale.textLayout.edit.SelectionState;
	import org.apache.royale.textLayout.edit.TextClipboard;
	import org.apache.royale.textLayout.edit.TextScrap;




	
	/**
	 * The CopyOperation class encapsulates a copy operation.
	 * 
	 * <p><b>Note:</b> The operation is responsible for copying the 
	 * text scrap to the clipboard. Undonig a copy operation does not restore
	 * the original clipboard state.</p>
	 * 
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class CopyOperation extends FlowTextOperation
	{		
		/** 
		 * Creates a CopyOperation object.
		 * 
		 * @param operationState The range of text to be copied.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function CopyOperation(operationState:SelectionState)
		{
			super(operationState);
		}
		
		
		/** @private */
		public override function doOperation():Boolean
		{
			if (originalSelectionState.activePosition != originalSelectionState.anchorPosition)
				TextClipboard.setContents(TextScrap.createTextScrap(originalSelectionState));		
			return true;
		}
		
		/** @private */
		public override function undo():SelectionState
		{				
			return originalSelectionState;	
		}
	
		/** @private */
		public override function redo():SelectionState
		{
			return originalSelectionState;	

		}		
		
		/** @private */
		public override function canUndo():Boolean
		{ return false; }
	}
}
