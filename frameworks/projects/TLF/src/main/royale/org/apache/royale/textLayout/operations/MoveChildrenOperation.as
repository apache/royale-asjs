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
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.edit.MementoList;
	import org.apache.royale.textLayout.edit.ModelEdit;
	import org.apache.royale.textLayout.edit.SelectionState;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.ListElement;
	import org.apache.royale.textLayout.elements.ListItemElement;
	import org.apache.royale.textLayout.elements.TextFlow;
	
	/**
	 * The MoveChildrenOperation class allows moving a set of siblings out of its immediate parent chain, and the operation removes any empty ancestor chain left behind.
	 *
	 * @see org.apache.royale.textLayout.elements.FlowElement
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class MoveChildrenOperation extends FlowTextOperation
	{	
		private var _source:IFlowGroupElement;
		private var _sourceIndex:int;
		private var _numChildren:int;
		private var _destination:IFlowGroupElement;
		private var _destinationIndex:int;
		private var _mementoList:MementoList;
		
		/** 
		 * Creates a MoveChildrenOperation object. 
		 * 
		 * <p>This operation moves a consecutive number of children of source into the destination
		 * context.  Also, if moving the children leaves the source element with no children, then
		 * source will be removed.  The removal is done recursively such that if source's parent
		 * becomes empty from the removal of source, it too will be deleted, and on up the parent chain.</p>
		 * 
		 * @param operationState Specifies the SelectionState of this operation
		 * @param source Specifies the parent of the item(s) to move.
		 * @param sourceIndex Specifies the index of the first item to move.
		 * @param numChildren Specifies the number of children to move.
		 * @param destination Specifies the new parent of the items.
		 * @param destinationIndex Specifies the new child index of the first element.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function MoveChildrenOperation(operationState:SelectionState, source:IFlowGroupElement, sourceIndex:int, numChildren:int, destination:IFlowGroupElement, destinationIndex:int)
		{
			super(operationState);
			_source = source;
			_sourceIndex = sourceIndex;
			_numChildren = numChildren;
			_destination = destination;
			_destinationIndex = destinationIndex;
			_mementoList = new MementoList(operationState.textFlow);
		}
		
		/** Specifies the parent of the item(s) to move.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get source():IFlowGroupElement
		{ return _source; }
		public function set source(val:IFlowGroupElement):void
		{ _source = val; }
		
		/** Specifies the number of children to move.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get sourceIndex():int
		{ return _sourceIndex; }
		public function set sourceIndex(val:int):void
		{ _sourceIndex = val; }
		
		/** Specifies the index of the first item to move.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get numChildren():int
		{ return _numChildren; }
		public function set numChildren(val:int):void
		{ _numChildren = val; }
		
		/** Specifies the new parent of the items.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get destination():IFlowGroupElement
		{ return _destination; }
		public function set destination(val:IFlowGroupElement):void
		{ _destination = val; }
		
		/** Specifies the new child index of the first element.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get destinationIndex():int
		{ return _destinationIndex; }
		public function set destinationIndex(val:int):void
		{ _destinationIndex = val; }
		
		/**
		 *  @private
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public override function doOperation():Boolean
		{

			CONFIG::debug
			{
				assert(_destination != null, "MoveChildrenOperation attempted on a null target");
				assert(_source != null, "MoveChildrenOperation attempted on a null element");
			}

			var insertContext:IFlowGroupElement;
			
			for(var count:int = 0; count < _numChildren; count++)
			{
				// special case for list items moving into non-list parent - move the children of the item and remove the item
				if(_source.getChildAt(_sourceIndex) is ListItemElement && !(_destination is ListElement))
				{
					for(var count2:int = 0; count2 = (_source.getChildAt(_sourceIndex) as IFlowGroupElement).numChildren; count2++)
					{
						_mementoList.push(ModelEdit.moveElement(textFlow, (_source.getChildAt(_sourceIndex) as IFlowGroupElement).getChildAt(0), _destination, _destinationIndex++));
					}
					_mementoList.push(ModelEdit.removeElements(textFlow, _source, _sourceIndex, 1));
				}
				else
				{
					_mementoList.push(ModelEdit.moveElement(textFlow, _source.getChildAt(_sourceIndex), _destination, _destinationIndex++));
				}
			}
			
			var parent:IFlowGroupElement = _source;
			var idx:int;
			while(parent.numChildren == 0 && !(parent is TextFlow))
			{
				idx = parent.parent.getChildIndex(parent);
				parent = parent.parent;
				_mementoList.push(ModelEdit.removeElements(textFlow, parent, idx, 1));
				insertContext = parent;
			}
			
			if(parent is ListElement)
			{
				insertContext = parent.parent;
				idx = parent.parent.getChildIndex(parent);
			}
			
			return true;
		}
		
		/** @private */ 
		public override function undo():SelectionState
		{
			_mementoList.undo();
			return originalSelectionState; 
		}
		
		/** @private */ 
		public override function redo():SelectionState
		{
			_mementoList.redo();
			return originalSelectionState; 
		}
	}
}
