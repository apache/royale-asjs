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
package org.apache.royale.utils.undo
{
			
	/** 
	* The UndoManager class manages the history of editing operations on a text flow so
	* that these operations can be undone and redone.
	* 
	* <p>The undo manager maintains two stacks of IOperation objects. When a reversible
	* operation is executed, it is placed on the undo stack. If that operation is undone,
	* it is removed from the undo stack, reversed, and placed on the redo stack. Likewise, 
	* if that operation is then redone, it is removed from the redo stack, re-executed, and
	* then placed onto the undo stack again. If another operation is executed first, the redo 
	* stack is cleared.</p>
	* 
	* <p>If the TextFlow is modified directly (not via
	* calls to the edit manager, but directly via calls to the managed FlowElement objects), then the edit manager
	* clears the undo stack to prevent the stack from getting out of sync with the current state.</p>
	* 
	* 
	*  @langversion 3.0
	*  @playerversion Flash 10.2
	*  @playerversion AIR 2.6
	*  @productversion Royale 0.0
	*
	* @see flashx.textLayout.edit.EditManager
	*/
	public class UndoManager implements IUndoManager
	{
		private var undoStack:Vector.<IOperation>;
		private var redoStack:Vector.<IOperation>;
		
		private var _undoAndRedoItemLimit:int = 25;

		/**
		* Creates an UndoManager object.
		* 
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
		*/	
		public function UndoManager()
		{
			undoStack = new Vector.<IOperation>;
			redoStack = new Vector.<IOperation>;
		}
		
		/**
		* @copy IUndoManager#clearAll()
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
		*/	
		public function clearAll():void
		{
			undoStack.length = 0;
			redoStack.length = 0;			
		}
		
		/**
		* @copy IUndoManager#canUndo()
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
		*/
		public function canUndo():Boolean
		{
			return undoStack.length > 0;
		}
		
		/**
		* @copy IUndoManager#peekUndo()
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
		*/
		public function peekUndo():IOperation
		{
			return undoStack.length > 0 ? undoStack[undoStack.length-1] : null;
		}
		
		/**
		* @copy IUndoManager#popUndo()
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
	  *  @royaleignorecoercion org.apache.royale.utils.undo.IOperation
		*/
		public function popUndo():IOperation
		{
			return IOperation(undoStack.pop());
		}

		/**
		* @copy IUndoManager#pushUndo()
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
		*/
		public function pushUndo(operation:IOperation):void
		{
			undoStack.push(operation);
			trimUndoRedoStacks();
		}
		
		/**
		* @copy IUndoManager#canRedo()
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
		*/
		public function canRedo():Boolean
		{
			return redoStack.length > 0;
		}

		/**
		* @copy IUndoManager#clearRedo()
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
		*/
		public function clearRedo():void
		{
			redoStack.length = 0;
		}

		/**
		* @copy IUndoManager#peekRedo()
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
		*/
		public function peekRedo():IOperation
		{
			return redoStack.length > 0 ? redoStack[redoStack.length-1] : null;
		}
		
		/**
		* @copy IUndoManager#popRedo()
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
	  *  @royaleignorecoercion org.apache.royale.utils.undo.IOperation
		*/
		public function popRedo():IOperation
		{
			return IOperation(redoStack.pop());
		}

		/**
		* @copy IUndoManager#pushRedo()
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
		*/
		public function pushRedo(operation:IOperation):void
		{
			redoStack.push(operation);
			trimUndoRedoStacks();
		}

		/**
		* @copy IUndoManager#undoAndRedoItemLimit
		* @tiptext The maximum number of undoable or redoable operations to track. 
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
		*/
		public function get undoAndRedoItemLimit():int
		{ return _undoAndRedoItemLimit; }
		public function set undoAndRedoItemLimit(value:int):void
		{ 
			_undoAndRedoItemLimit = value;
			trimUndoRedoStacks();
		}

		/** 
		* @copy IUndoManager#undo()
		* @see flashx.textLayout.edit.IEditManager#undo()
		* 
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
		*/
		public function undo():void
		{
			if (canUndo())
			{
				var undoOp:IOperation = popUndo();
				undoOp.performUndo();
			}
		}
		
		/** 
		* @copy IUndoManager#redo()
		* 
		* @see flashx.textLayout.edit.IEditManager#redo()
		* 
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
		*/
		public function redo():void
		{
			if (canRedo())
			{
				var redoOp:IOperation = popRedo();
				redoOp.performRedo();
			}			
		}									
		
		/** trim the sizes of the undo/redo stacks to the maximum limits */
		private function trimUndoRedoStacks():void
		{
			// trim the undoStack and the redoStack so its in bounds 
			var numItems:int = undoStack.length + redoStack.length;
			if (numItems > _undoAndRedoItemLimit)
			{
				// trim redoStack first
				var numToSplice:int = Math.min(numItems-_undoAndRedoItemLimit,redoStack.length);
				if (numToSplice)
				{
					redoStack.splice(0,numToSplice);
					numItems = undoStack.length+redoStack.length;
				} 
				// trim some undoable items
				if (numItems > _undoAndRedoItemLimit)
				{
					numToSplice = Math.min(numItems-_undoAndRedoItemLimit,undoStack.length);
					undoStack.splice(0,numToSplice);
				}
			}
		}
	}
}
