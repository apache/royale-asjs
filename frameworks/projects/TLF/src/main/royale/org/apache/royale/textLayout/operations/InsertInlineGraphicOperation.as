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
	import org.apache.royale.textLayout.edit.ElementRange;
	import org.apache.royale.textLayout.edit.ParaEdit;
	import org.apache.royale.textLayout.edit.PointFormat;
	import org.apache.royale.textLayout.edit.SelectionState;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IInlineGraphicElement;
	import org.apache.royale.textLayout.elements.ISubParagraphGroupElementBase;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;




	

	/**
	 * The InsertInlineGraphicOperation class encapsulates the insertion of an inline
	 * graphic into a text flow.
	 *
	 * @see org.apache.royale.textLayout.elements.IInlineGraphicElement
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class InsertInlineGraphicOperation extends FlowTextOperation
	{
		private var delSelOp:DeleteTextOperation; 
		private var _source:Object;
		private var imageWidth:Object;
		private var imageHeight:Object;
		private var _options:Object;
		private var selPos:int = 0;
		private var _inlineGraphicElement:IInlineGraphicElement;
		
		/** 
		 * Creates an InsertInlineGraphicsOperation object.
		 * 
		 * @param operationState Describes the insertion point. 
		 * If a range is selected, the operation deletes the contents of that range.
		 * @param	source	The graphic source (uri string, URLRequest, DisplayObject, or Class of an embedded asset). 
		 * @param	width	The width to assign (number of pixels, percent, or the string 'auto')
		 * @param	height	The height to assign (number of pixels, percent, or the string 'auto')
		 * @param	options	The float to assign (String value, none for inline with text, left/right/start/end for float)
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function InsertInlineGraphicOperation(operationState:SelectionState, source:Object, width:Object, height:Object, options:Object = null)
		{
			super(operationState);
			
			if (absoluteStart != absoluteEnd)
				delSelOp = new DeleteTextOperation(operationState);
				
			_source = source;
			_options = options;
			imageWidth = width;
			imageHeight = height;
		}
		
		/**	
		 * @copy org.apache.royale.textLayout.elements.IInlineGraphicElement#source
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
 		 */
		public function get source():Object
		{
			return _source;
		}
		public function set source(value:Object):void
		{
			_source = value;
		}

		/** 
		 * @copy org.apache.royale.textLayout.elements.IInlineGraphicElement#width
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function get width():Object
		{
			return imageWidth;
		}
		public function set width(value:Object):void
		{
			imageWidth = value;
		}

		/** 
		 * @copy org.apache.royale.textLayout.elements.IInlineGraphicElement#height
		 * 
		 * @see org.apache.royale.textLayout.IInlineGraphicElement#height
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get height():Object
		{
			return imageHeight;
		}
		public function set height(value:Object):void
		{
			imageHeight = value;
		}
		
		/** 
		 * @copy org.apache.royale.textLayout.elements.IInlineGraphicElement#float
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get options():Object
		{
			return _options;
		}
		public function set options(value:Object):void
		{
			_options = value;
		}

		/** 
		 * The IInlineGraphicElement that was created by doOperation.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get newInlineGraphicElement():IInlineGraphicElement
		{
			return _inlineGraphicElement;
		}
		
		/** @private */
		public override function doOperation():Boolean
		{
			var pointFormat:ITextLayoutFormat;
			
			selPos = absoluteStart;
			if (delSelOp) 
			{
				var leafEl:IFlowLeafElement = textFlow.findLeaf(absoluteStart);
				var deleteFormat:PointFormat = new PointFormat(textFlow.findLeaf(absoluteStart).format);
				if (delSelOp.doOperation())
					pointFormat = deleteFormat;
			}
			else
				pointFormat = originalSelectionState.pointFormat;
				
			// lean left logic included
			var range:ElementRange = ElementRange.createElementRange(textFlow,selPos, selPos);		
			var leafNode:IFlowElement = range.firstLeaf;
			var leafNodeParent:IFlowGroupElement = leafNode.parent;
			while (leafNodeParent is ISubParagraphGroupElementBase)
			{
				var subParInsertionPoint:int = selPos - leafNodeParent.getAbsoluteStart();
				if (((subParInsertionPoint == 0) && (!(leafNodeParent as ISubParagraphGroupElementBase).acceptTextBefore())) ||
					((subParInsertionPoint == leafNodeParent.textLength) && (!(leafNodeParent as ISubParagraphGroupElementBase).acceptTextAfter())))
				{
					leafNodeParent = leafNodeParent.parent;
				} else {
					break;
				}
			}
			
			_inlineGraphicElement = ParaEdit.createImage(leafNodeParent, selPos - leafNodeParent.getAbsoluteStart(), _source, imageWidth, imageHeight, options, pointFormat);
			if (textFlow.interactionManager)
				textFlow.interactionManager.notifyInsertOrDelete(absoluteStart, 1);
			
			return true;
		}
	
		/** @private */
		public override function undo():SelectionState
		{
			var leafNode:IFlowElement = textFlow.findLeaf(selPos);
			var leafNodeParent:IFlowGroupElement = leafNode.parent;
			var elementIdx:int = leafNode.parent.getChildIndex(leafNode);
			leafNodeParent.replaceChildren(elementIdx, elementIdx + 1, null);			
					
			if (textFlow.interactionManager)
				textFlow.interactionManager.notifyInsertOrDelete(absoluteStart, -1);

			return delSelOp ? delSelOp.undo() : originalSelectionState; 
		}

		/**
		 * Re-executes the operation after it has been undone.
		 * 
		 * <p>This function is called by the edit manager, when necessary.</p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public override function redo():SelectionState
		{ 
			doOperation();
			return new SelectionState(textFlow,selPos+1,selPos+1,null);
		}

	}
}
