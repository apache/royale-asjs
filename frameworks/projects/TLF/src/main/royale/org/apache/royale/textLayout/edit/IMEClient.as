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
package org.apache.royale.textLayout.edit
{
	import org.apache.royale.geom.Point;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.text.ime.CompositionAttributeRange;
	import org.apache.royale.text.ime.IIMEClient;
	import org.apache.royale.text.ime.IME;
	import org.apache.royale.textLayout.compose.IFlowComposer;
	import org.apache.royale.textLayout.compose.ITextFlowLine;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.elements.TextRange;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.IMEStatus;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;
	import org.apache.royale.textLayout.operations.ApplyFormatToElementOperation;
	import org.apache.royale.textLayout.operations.FlowOperation;
	import org.apache.royale.textLayout.operations.InsertTextOperation;
	import org.apache.royale.textLayout.utils.GeometryUtil;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.undo.IOperation;
	import org.apache.royale.utils.undo.UndoManager;

	internal class IMEClient implements IIMEClient
	{
		private var _editManager:EditManager;
		private var _undoManager:UndoManager;
		/** Maintain position of text we've inserted while in the middle of processing IME. */
		private var _imeAnchorPosition:int;		// start of IME text
		private var _imeLength:int;				// length of IME text
		private var _controller:IContainerController;		// controller that had focus at the start of the IME session -- we want this one to keep focus
		private var _closing:Boolean;
		CONFIG::debug
		{
			private var _imeOperation:IOperation; 	// IME in-progress edits - used for debugging to confirm that operation we're undoing is the one we did via IME
		}
		public function IMEClient(editManager:EditManager)
		{
			_editManager = editManager;
			_imeAnchorPosition = _editManager.absoluteStart;
			if (_editManager.textFlow)
			{
				var flowComposer:IFlowComposer = _editManager.textFlow.flowComposer;
				if (flowComposer)
				{
					var controllerIndex:int = flowComposer.findControllerIndexAtPosition(_imeAnchorPosition);
					_controller = flowComposer.getControllerAt(controllerIndex);
					if (_controller)
						_controller.setFocus();
				}
			}
			_closing = false;
			if (_editManager.undoManager == null)
			{
				_undoManager = new UndoManager();
				_editManager.setUndoManager(_undoManager);
			}
		}

		/** @private
		 * Handler function called when the selection has been changed.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function selectionChanged():void
		{
			// trace("IMEClient.selectionChanged", _editManager.anchorPosition, _editManager.activePosition);

			// If we change the selection to something outside the session, abort the
			// session. If we just moved the selection within the session, we tell the IME about the changes.
			if (_editManager.absoluteStart > _imeAnchorPosition + _imeLength || _editManager.absoluteEnd < _imeAnchorPosition)
			{
				// trace("selection changed to out of IME session");
				compositionAbandoned();
			}
			else
			{
				// This code doesn't with current version of Argo, but should work in future
				// trace("selection changed within IME session");
				// var imeCompositionSelectionChanged:Function = IME["compositionSelectionChanged"];
				// if (IME["compositionSelectionChanged"] !== undefined)
				// imeCompositionSelectionChanged(_editManager.absoluteStart - _imeAnchorPosition, _editManager.absoluteEnd - (_imeAnchorPosition + _imeLength));
			}
		}

		private function doIMEClauseOperation(selState:SelectionState, clause:int):void
		{
			var leaf:IFlowLeafElement = _editManager.textFlow.findLeaf(selState.absoluteStart);
			;
			var leafAbsoluteStart:int = leaf.getAbsoluteStart();
			var format:TextLayoutFormat = new TextLayoutFormat();
			format.setStyle(IMEStatus.IME_CLAUSE, clause.toString());
			_editManager.doOperation(new ApplyFormatToElementOperation(selState, leaf, format, selState.absoluteStart - leafAbsoluteStart, selState.absoluteEnd - leafAbsoluteStart));
		}

		private function doIMEStatusOperation(selState:SelectionState, attrRange:CompositionAttributeRange):void
		{
			var imeStatus:String;

			// Get the IME status from the converted & selected flags
			if (attrRange == null)
				imeStatus = IMEStatus.DEAD_KEY_INPUT_STATE;
			else if (!attrRange.converted)
			{
				if (!attrRange.selected)
					imeStatus = IMEStatus.NOT_SELECTED_RAW;
				else
					imeStatus = IMEStatus.SELECTED_RAW;
			}
			else
			{
				if (!attrRange.selected)
					imeStatus = IMEStatus.NOT_SELECTED_CONVERTED;
				else
					imeStatus = IMEStatus.SELECTED_CONVERTED;
			}

			// refind since the previous operation changed the spans
			var leaf:IFlowLeafElement = _editManager.textFlow.findLeaf(selState.absoluteStart);
			CONFIG::debug
			{
				assert(leaf != null, "found null FlowLeafELement at" + (selState.absoluteStart).toString()); }
			var leafAbsoluteStart:int = leaf.getAbsoluteStart();

			var format:TextLayoutFormat = new TextLayoutFormat();
			format.setStyle(IMEStatus.IME_STATUS, imeStatus);

			_editManager.doOperation(new ApplyFormatToElementOperation(selState, leaf, format, selState.absoluteStart - leafAbsoluteStart, selState.absoluteEnd - leafAbsoluteStart));
		}

		private function deleteIMEText(textFlow:ITextFlow):void
		{
			// Delete any leaves that have IME attributes applied
			var leaf:IFlowLeafElement = textFlow.getFirstLeaf();
			while (leaf)
			{
				if (leaf.getStyle(IMEStatus.IME_STATUS) !== undefined || leaf.getStyle(IMEStatus.IME_CLAUSE) !== undefined)
				{
					var leafFormat:TextLayoutFormat = new TextLayoutFormat(leaf.format);
					leafFormat.setStyle(IMEStatus.IME_STATUS, undefined);
					leafFormat.setStyle(IMEStatus.IME_CLAUSE, undefined);
					leaf.format = leafFormat;
					var absoluteStart:int = leaf.getAbsoluteStart();
					ModelEdit.deleteText(textFlow, absoluteStart, absoluteStart + leaf.textLength, false);
					leaf = textFlow.findLeaf(absoluteStart);
				}
				else
					leaf = leaf.getNextLeaf();
			}
		}

		private function rollBackIMEChanges():void
		{
			// Undo the previous interim ime operation, if there is one. This deletes any text that came in a previous updateComposition call.
			// Doing it via undo keeps the undo stack in sync. But if there's been an intervening direct model change, just delete the IME text
			// directly. It won't restore what we selected at the beginning of the IME session, but it's the best we can do.
			var previousIMEOperation:FlowOperation = _editManager.undoManager.peekUndo() as FlowOperation;
			if (_imeLength > 0 && previousIMEOperation && previousIMEOperation.endGeneration == _editManager.textFlow.generation && previousIMEOperation.canUndo())
			{
				CONFIG::debug
				{
					assert(_editManager.undoManager.peekUndo() == _imeOperation, "Unexpected operation in undo stack at end of IME update"); }
				if (_editManager.undoManager)
					_editManager.undoManager.undo();
				CONFIG::debug
				{
					assert(_editManager.undoManager.peekRedo() == _imeOperation, "Unexpected operation in redo stack at end of IME session"); }
				_editManager.undoManager.popRedo();
			}
			else		// there's been a model change since the last IME change that blocks undo, just find IME text and delete it.
			{
				_editManager.undoManager.popUndo();		// remove the operation we can't undo
				deleteIMEText(_editManager.textFlow);
			}
			_imeLength = 0; // prevent double deletion
			CONFIG::debug
			{
				_imeOperation = null; }
		}

		// IME-related functions
		public function updateComposition(text:String, attributes:Vector.<CompositionAttributeRange>, compositionStartIndex:int, compositionEndIndex:int):void
		{
			// CONFIG::debug { Debugging.traceOut("updateComposition ", compositionStartIndex, compositionEndIndex, text.length); }
			// CONFIG::debug { Debugging.traceOut("updateComposition selection ", _editManager.absoluteStart, _editManager.absoluteEnd); }

			// Undo the previous interim ime operation, if there is one. This deletes any text that came in a previous updateComposition call.
			// Doing it via undo keeps the undo stack in sync.
			if (_imeLength > 0)
				rollBackIMEChanges();

			if (text.length > 0)
			{
				// Insert the supplied string, using the current editing format.
				var pointFormat:ITextLayoutFormat = _editManager.getSelectionState().pointFormat;
				var selState:SelectionState = new SelectionState(_editManager.textFlow, _imeAnchorPosition, _imeAnchorPosition + _imeLength, pointFormat);

				_editManager.beginIMEOperation();

				if (_editManager.absoluteStart != _editManager.absoluteEnd)
					_editManager.deleteText();		// delete current selection

				var insertOp:InsertTextOperation = new InsertTextOperation(selState, text);
				_imeLength = text.length;
				_editManager.doOperation(insertOp);

				if (attributes && attributes.length > 0)
				{
					var attrLen:int = attributes.length;
					for (var i:int = 0; i < attrLen; i++)
					{
						var attrRange:CompositionAttributeRange = attributes[i];
						var clauseSelState:SelectionState = new SelectionState(_editManager.textFlow, _imeAnchorPosition + attrRange.relativeStart, _imeAnchorPosition + attrRange.relativeEnd);

						doIMEClauseOperation(clauseSelState, i);
						doIMEStatusOperation(clauseSelState, attrRange);
					}
				}
				else // composing accented characters
				{
					clauseSelState = new SelectionState(_editManager.textFlow, _imeAnchorPosition, _imeAnchorPosition + _imeLength, pointFormat);
					doIMEClauseOperation(clauseSelState, 0);
					doIMEStatusOperation(clauseSelState, null);
				}

				var newSelectionStart:int = _imeAnchorPosition + compositionStartIndex;
				var newSelectionEnd:int = _imeAnchorPosition + compositionEndIndex;
				if (_editManager.absoluteStart != newSelectionStart || _editManager.absoluteEnd != newSelectionEnd)
				{
					_editManager.selectRange(_imeAnchorPosition + compositionStartIndex, _imeAnchorPosition + compositionEndIndex);
				}

				CONFIG::debug
				{
					_imeOperation = null; }
				_editManager.endIMEOperation();
				CONFIG::debug
				{
					_imeOperation = _editManager.undoManager.peekUndo(); }
			}
		}

		public function confirmComposition(text:String = null, preserveSelection:Boolean = false):void
		{
			// trace("confirmComposition", text, preserveSelection);
			endIMESession();
		}

		public function compositionAbandoned():void
		{
			// trace("compositionAbandoned");

			// In Argo we could just do this:
			// IME.compositionAbandoned();
			// but for support in Astro/Squirt where this API is undefined we do this:
			var imeCompositionAbandoned:Function = IME["compositionAbandoned"];
			if (IME["compositionAbandoned"] !== undefined)
				imeCompositionAbandoned();
		}

		private function endIMESession():void
		{
			if (!_editManager || _closing)
				return;

			// trace("end IME session");

			_closing = true;

			// Undo the IME operation. We're going to re-add the text, without all the special attributes, as part of handling
			// the textInput event that comes next.
			if (_imeLength > 0)
				rollBackIMEChanges();

			if (_undoManager)
				_editManager.setUndoManager(null);

			// Clear IME state - tell EditManager to release IMEClient to finally close session
			_editManager.endIMESession();
			_editManager = null;
		}

		// CONFIG::debug
		// {		// debugging code for displaying IME bounds rectangle
		// private function displayRectInContainer(container:Sprite, r:Rectangle):void
		// {
		// var g:Graphics = container.graphics;
		// g.beginFill(0xff0000);
		// g.moveTo(r.x, r.y);
		// g.lineTo(r.right, r.y);
		// g.lineTo(r.right, r.bottom);
		// g.lineTo(r.x, r.bottom);
		// g.lineTo(r.x, r.y);
		// g.endFill();
		// }
		// }
		public function getTextBounds(startIndex:int, endIndex:int):Rectangle
		{
			if (startIndex >= 0 && startIndex < _editManager.textFlow.textLength && endIndex >= 0 && endIndex < _editManager.textFlow.textLength)
			{
				if (startIndex != endIndex)
				{
					var boundsResult:Array = GeometryUtil.getHighlightBounds(new TextRange(_editManager.textFlow, startIndex, endIndex));
					// bail out if we don't have any results to show
					if (boundsResult.length > 0)
					{
						var bounds:Rectangle = boundsResult[0].rect;
						var textLine:ITextLine = boundsResult[0].textLine;
						var resultTopLeft:Point = PointUtils.localToGlobal(bounds.topLeft, textLine);// textLine.localToGlobal(bounds.topLeft);
						var resultBottomRight:Point = PointUtils.localToGlobal(bounds.bottomRight, textLine);// textLine.localToGlobal(bounds.bottomRight);
						if (textLine.parent)
						{
							var containerTopLeft:Point = PointUtils.globalToLocal(resultTopLeft, textLine.parent);// textLine.parent.globalToLocal(resultTopLeft);
							var containerBottomLeft:Point = PointUtils.globalToLocal(resultBottomRight, textLine.parent);// textLine.parent.globalToLocal(resultBottomRight);
							// CONFIG::debug { displayRectInContainer(Sprite(textLine.parent), new Rectangle(containerTopLeft.x, containerTopLeft.y, containerBottomLeft.x - containerTopLeft.x, containerBottomLeft.y - containerTopLeft.y));}
							return new Rectangle(containerTopLeft.x, containerTopLeft.y, containerBottomLeft.x - containerTopLeft.x, containerBottomLeft.y - containerTopLeft.y);
						}
					}
				}
				else
				{
					var flowComposer:IFlowComposer = _editManager.textFlow.flowComposer;
					var lineIndex:int = flowComposer.findLineIndexAtPosition(startIndex);

					// Stick to the end of the last line
					if (lineIndex == flowComposer.numLines)
						lineIndex--;
					if (flowComposer.getLineAt(lineIndex).controller == _controller)
					{
						var line:ITextFlowLine = flowComposer.getLineAt(lineIndex);
						var previousLine:ITextFlowLine = lineIndex != 0 ? flowComposer.getLineAt(lineIndex - 1) : null;
						var nextLine:ITextFlowLine = lineIndex != flowComposer.numLines - 1 ? flowComposer.getLineAt(lineIndex + 1) : null;
						// CONFIG::debug { displayRectInContainer(_controller.container, line.computePointSelectionRectangle(startIndex, _controller.container, previousLine, nextLine, true));}
						return line.computePointSelectionRectangle(startIndex, _controller.container, previousLine, nextLine, true);
					}
				}
			}

			return new Rectangle(0, 0, 0, 0);
		}

		public function get compositionStartIndex():int
		{
			// trace("compositionStartIndex");
			return _imeAnchorPosition;
		}

		public function get compositionEndIndex():int
		{
			// trace("compositionEndIndex");
			return _imeAnchorPosition + _imeLength;
		}

		public function get verticalTextLayout():Boolean
		{
			// trace("verticalTextLayout ", _editManager.textFlow.computedFormat.blockProgression == BlockProgression.RL ? "true" : "false");
			return _editManager.textFlow.computedFormat.blockProgression == BlockProgression.RL;
		}

		public function get selectionActiveIndex():int
		{
			// trace("selectionActiveIndex");
			return _editManager.activePosition;
		}

		public function get selectionAnchorIndex():int
		{
			// trace("selectionAnchorIndex");
			return _editManager.anchorPosition;
		}

		public function selectRange(anchorIndex:int, activeIndex:int):void
		{
			_editManager.selectRange(anchorIndex, activeIndex);
		}

		public function setFocus():void
		{
			// TODO deal with stage and focus
			// if (_controller && _controller.container && _controller.container.stage && _controller.container.stage.focus != _controller.container)
			// _controller.setFocus();
		}

		/** 
		 * Gets the specified range of text from a component implementing ITextSupport.
		 * To retrieve all text in the component, do not specify values for <code>startIndex</code> and <code>endIndex</code>.
		 * Components which wish to support inline IME or web searchability should call into this method.
		 * Components overriding this method should ensure that the default values of <code>-1</code> 
		 * for <code>startIndex</code> and <code>endIndex</code> are supported.
		 * 
		 * @playerversion Flash 10.0
		 * @langversion 3.0
		 */
		public function getTextInRange(startIndex:int, endIndex:int):String
		{
			// trace("getTextInRange");
			// Check for valid indices
			var textFlow:ITextFlow = _editManager.textFlow;
			if (startIndex < -1 || endIndex < -1 || startIndex > (textFlow.textLength - 1) || endIndex > (textFlow.textLength - 1))
				return null;

			// Make sure they're in the right order
			if (endIndex < startIndex)
			{
				var tempIndex:int = endIndex;
				endIndex = startIndex;
				startIndex = tempIndex;
			}

			if (startIndex == -1)
				startIndex = 0;

			return textFlow.getText(startIndex, endIndex);
		}
	}
}
