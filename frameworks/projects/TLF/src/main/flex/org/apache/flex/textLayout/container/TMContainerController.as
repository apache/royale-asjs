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
package org.apache.royale.textLayout.container
{
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.dummy.ContextMenu;
	import org.apache.royale.textLayout.edit.IInteractionEventHandler;
	import org.apache.royale.textLayout.formats.BlockProgression;

	public class TMContainerController extends ContainerController
	{
		private var _inputManager:TextContainerManager;

		public function TMContainerController(container:IParentIUIBase, compositionWidth:Number, compositionHeight:Number, tm:TextContainerManager)
		{
			super(container, compositionWidth, compositionHeight);
			_inputManager = tm;
			verticalScrollPolicy = tm.verticalScrollPolicy;
			horizontalScrollPolicy = tm.horizontalScrollPolicy;
		}

		public function get textContainerManager():TextContainerManager
		{
			return _inputManager;
		}

		/** Reroute to the TextContainerManger's override.  Reuse the one that's already been created. */
		protected override function createContextMenu():ContextMenu
		{
			return _inputManager.getContextMenu();
		}

		/** @private */
		protected override function get attachTransparentBackground():Boolean
		{
			return false;
		}

		/** @private */
		public function doUpdateVisibleRectangle():void
		{
			updateVisibleRectangle();
		}

		/** @private. Override clones and enhances parent class functionality. */
		protected override function updateVisibleRectangle():void
		{
			var xpos:Number;
			var ypos:Number;
			// see the adjustLines boolean in ContainerController.fillShapeChildren - this logic clones that and allows for skipping the scrollRect
			xpos = horizontalScrollPosition;
			if (effectiveBlockProgression == BlockProgression.RL && (verticalScrollPolicy != ScrollPolicy.OFF || horizontalScrollPolicy != ScrollPolicy.OFF))
				xpos -= !isNaN(compositionWidth) ? compositionWidth : contentWidth;

			ypos = verticalScrollPosition;

			_hasScrollRect = _inputManager.drawBackgroundAndSetScrollRect(xpos, ypos);
		}

		/** @private */
		public override function getInteractionHandler():IInteractionEventHandler
		{
			return _inputManager;
		}

		/** @private */
		public override function attachContextMenu():void
		{
			if (_inputManager.getContextMenu() != null)
				super.attachContextMenu();
		}

		/** @private */
		public override function removeContextMenu():void
		{
			// otherwise client is managing it
			if (_inputManager.getContextMenu())
				super.removeContextMenu();
		}

		// ////////////////////////////////////////////////////////////////////////////
		// push all these methods for manipulating the object list to the _inputmanager
		// ////////////////////////////////////////////////////////////////////////////
		protected override function getFirstTextLineChildIndex():int
		{
			return _inputManager.getFirstTextLineChildIndex();
		}

		protected override function addTextLine(textLine:ITextLine, index:int):void
		{
			_inputManager.addTextLine(textLine, index);
		}

		protected override function removeTextLine(textLine:ITextLine):void
		{
			_inputManager.removeTextLine(textLine);
		}

		protected override function addBackgroundShape(shape:IUIBase):void
		{
			_inputManager.addBackgroundShape(shape);
		}

		protected override function removeBackgroundShape(shape:IUIBase):void
		{
			_inputManager.removeBackgroundShape(shape);
		}

		protected override function addSelectionContainer(selectionContainer:IParentIUIBase):void
		{
			_inputManager.addSelectionContainer(selectionContainer);
		}

		protected override function removeSelectionContainer(selectionContainer:IParentIUIBase):void
		{
			_inputManager.removeSelectionContainer(selectionContainer);
		}

		protected override function addInlineGraphicElement(parent:IParentIUIBase, inlineGraphicElement:IUIBase, index:int):void
		{
			_inputManager.addInlineGraphicElement(parent, inlineGraphicElement, index);
		}

		protected override function removeInlineGraphicElement(parent:IParentIUIBase, inlineGraphicElement:IUIBase):void
		{
			_inputManager.removeInlineGraphicElement(parent, inlineGraphicElement);
		}
	}
}
