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
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.InlineGraphicElement;

	/**
	 * The InsertInlineGraphicOperation class encapsulates the modification of an existing inline graphic.
	 *
	 * @see org.apache.royale.textLayout.elements.InlineGraphicElement
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class ModifyInlineGraphicOperation extends FlowTextOperation
	{ 
		private var _source:Object;
		private var imageWidth:Object;
		private var imageHeight:Object;
		private var _options:Object;
		private var oldImage:IFlowElement;
		private var selPos:int = 0;
		
		/** 
		 * Creates a ModifyInlineGraphicsOperation object.
		 * 
		 * @param operationState Describes the insertion point. 
		 * If a range is selected, the operation deletes the contents of that range.
		 * @param	source	The graphic source (uri string, URLRequest, DisplayObject, or Class of an embedded asset). 
		 * @param	width	The width to assign (number of pixels, percent, or the string 'auto')
		 * @param	height	The height to assign (number of pixels, percent, or the string 'auto')
		 * @param	options	None supported
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function ModifyInlineGraphicOperation(operationState:SelectionState, source:Object, width:Object, height:Object, options:Object = null)
		{
			super(operationState);
							
			_source = source;
			_options = options;
			imageWidth = width;
			imageHeight = height;
		}
		
		/**	
		 * @copy org.apache.royale.textLayout.elements.InlineGraphicElement#source
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
		 * @copy org.apache.royale.textLayout.elements.InlineGraphicElement#width
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
		 * @copy org.apache.royale.textLayout.elements.InlineGraphicElement#height
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
		 * options are not supported
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
		
		/** @private */
		public override function doOperation():Boolean
		{
			selPos = absoluteStart;
			var img:InlineGraphicElement = textFlow.findLeaf(selPos) as InlineGraphicElement;
			if (img)
			{
				oldImage = img.shallowCopy(0,1);
				// only update changed things
				if (img.width != imageWidth)
					img.width = imageWidth;
				if (img.height != imageHeight)
					img.height = imageHeight;
				if (img.source != _source)
					img.source = _source;
				if (options && img.float != options.toString())
					img.float = options.toString();
			}
			
			return true;	
		}
	
		/** @private */
		public override function undo():SelectionState
		{
			var leafNode:IFlowElement = textFlow.findLeaf(selPos);
			var leafNodeParent:IFlowGroupElement = leafNode.parent;
			var elementIdx:int = leafNode.parent.getChildIndex(leafNode);
			leafNodeParent.replaceChildren(elementIdx, elementIdx + 1, oldImage);			

			return originalSelectionState; 
		}
	}
}
