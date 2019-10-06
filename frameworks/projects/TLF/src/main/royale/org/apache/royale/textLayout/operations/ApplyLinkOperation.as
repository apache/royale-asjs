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
	import org.apache.royale.textLayout.edit.IMemento;
	import org.apache.royale.textLayout.edit.ModelEdit;
	import org.apache.royale.textLayout.edit.SelectionState;
	import org.apache.royale.textLayout.edit.TextFlowEdit;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.LinkElement;
	
	/**
	 * The ApplyLinkOperation class encapsulates a link creation or modification operation.
	 *
	 * @see org.apache.royale.textLayout.elements.LinkElement
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */			
	public class ApplyLinkOperation extends FlowTextOperation
	{
		private var _hrefString:String;
		private var _target:String;
		private var _extendToLinkBoundary:Boolean;
		private var _memento:IMemento;
		private var _linkElement:LinkElement;

		/** 
		 * Creates an ApplyLinkOperation object.
		 * 
		 * @param operationState	The text range to which the operation is applied.
		 * @param href The URI to be associated with the link.  If href is an empty string, 
		 * the URI of links in the selection are removed.
		 * @param target The target of the link.
		 * @param extendToLinkBoundary Whether to extend the selection to include the entire 
		 * text of any existing links overlapped by the selection, and then apply the change.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function ApplyLinkOperation(operationState:SelectionState, href:String, target:String, extendToLinkBoundary:Boolean)
		{
			super(operationState);
		
			_hrefString = href;
			_target = target;
			_extendToLinkBoundary = extendToLinkBoundary;
		}
		
		/** 
		 * The URI to be associated with the link.  If href is an empty string, 
		 * the URI of links in the selection are removed.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get href():String
		{
			return _hrefString;
		}
		public function set href(value:String):void
		{
			_hrefString = value;
		}
		
		/**
		 * The target of the link.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get target():String
		{
			return _target;
		}
		public function set target(value:String):void
		{
			_target = value;
		}
		
		/**
		 * Whether to extend the selection to include the entire 
		 * text of any existing links overlapped by the selection, and then apply the change.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get extendToLinkBoundary():Boolean
		{
			return _extendToLinkBoundary;
		}
		public function set extendToLinkBoundary(value:Boolean):void
		{
			_extendToLinkBoundary = value;
		}

		/** 
		 * The LinkElement that was created by doOperation.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 2.0
		 * @langversion 3.0 
		 */
		public function get newLinkElement():LinkElement
		{
			return _linkElement;
		}
		

		
		/** @private */
		public override function doOperation():Boolean
		{
			var leaf:IFlowLeafElement;
			if (absoluteStart == absoluteEnd)
				return false;
			
			if (_extendToLinkBoundary)
			{
				leaf = textFlow.findLeaf(absoluteStart);
				var link:LinkElement = leaf.getParentByType("LinkElement") as LinkElement;
				if (link)
				{
					absoluteStart = link.getAbsoluteStart();
				}
				
				leaf = textFlow.findLeaf(absoluteEnd-1);
				link = leaf.getParentByType("LinkElement") as LinkElement;
				if (link)
				{
					absoluteEnd = link.getAbsoluteStart() + link.textLength;
				}
			}
			//save off so that we can restore the flow on undo			
			_memento = ModelEdit.saveCurrentState(textFlow, absoluteStart, absoluteEnd);
				
			if (_hrefString && _hrefString != "")
			{
				var madeLink:Boolean = TextFlowEdit.makeLink(textFlow, absoluteStart, absoluteEnd, _hrefString, _target);
				if (!madeLink) 
				{
					_memento = null;
					return false;
				}
				else
				{
					leaf = textFlow.findLeaf(absoluteStart);
					_linkElement = leaf.getParentByType("LinkElement") as LinkElement;
				}
			}
			else
			{
				TextFlowEdit.removeLink(textFlow, absoluteStart, absoluteEnd);				
			} 
			return true;
		}
		
		/** @private */
		public override function undo():SelectionState
		{
			if (_memento)
				_memento.undo();
			return originalSelectionState;				
		}
	
		/** @private */
		public override function redo():SelectionState
		{
			if (absoluteStart != absoluteEnd && _memento)
			{
				if (_hrefString != "")
				{
					TextFlowEdit.makeLink(textFlow, absoluteStart, absoluteEnd, _hrefString, _target);
				}
				else
				{
					TextFlowEdit.removeLink(textFlow, absoluteStart, absoluteEnd);				
				} 
			}
			return originalSelectionState;	
		}
	}
}
