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
package org.apache.royale.textLayout.utils
{
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.text.engine.ITextBlock;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.compose.IFactoryComposer;
	import org.apache.royale.textLayout.compose.IFlowComposer;
	import org.apache.royale.textLayout.compose.ITextFlowLine;
	import org.apache.royale.textLayout.compose.ITextFlowTableBlock;
	import org.apache.royale.textLayout.compose.ParcelList;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.container.ITextContainerManager;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.IBackgroundManager;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ITableCellElement;
	import org.apache.royale.textLayout.elements.ITableRowElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.elements.ITableElement;
	import org.apache.royale.textLayout.formats.BackgroundColor;
	import org.apache.royale.textLayout.formats.BorderColor;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;

	public class BackgroundUtil
	{
		public static function collectTableBlock(_textFlow:ITextFlow, block:ITextFlowTableBlock, controller:IContainerController):void
		{
			// add block rect for each cell in table block

			var bb:IBackgroundManager;
			var r:Rectangle;
			// var composer:IFlowComposer;

			var cells:Vector.<ITableCellElement> = block.getTableCells();
			for each (var cell:ITableCellElement in cells)
			{
				if (hasBorderOrBackground(cell))
				{
					if (!_textFlow.backgroundManager)
						_textFlow.getBackgroundManager();
					bb = _textFlow.backgroundManager;

					bb.addBlockElement(cell);

					var row:ITableRowElement = cell.getRow();
					r = new Rectangle(cell.x, cell.y + block.y, cell.width, row.composedHeight);
					bb.addBlockRect(cell, r, controller);
				}
			}
			// block.y;
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ITableElement
		 */
		public static function collectBlock(_textFlow:ITextFlow, elem:IFlowGroupElement, _parcelList:ParcelList = null, tableComposeNotFromBeginning:Boolean = false, tableOutOfView:Boolean = false):void
		{
			var bb:IBackgroundManager;
			var r:Rectangle;
			// var controller:IContainerController;
			var composer:IFlowComposer;

			if (elem)
			{
				if (hasBorderOrBackground(elem))
				{
					// mark the paragraph that has border or background
					if (!_textFlow.backgroundManager)
						_textFlow.getBackgroundManager();
					bb = _textFlow.backgroundManager;

					// IBackgroundManager should not be null here
					CONFIG::debug
					{
						assert(_textFlow.backgroundManager != null, "IBackgroundManager should not be null");
					}

					bb.addBlockElement(elem);

					composer = _textFlow.flowComposer;
					if (composer && elem.textLength > 1)
					{
						if (elem is ITableElement)
						{
							// Do we need to do anything for table elements? Not sure...
							var tab:ITableElement = elem as ITableElement;
						}
						else // for elements like ParagraphElement, DivElement, ListItemElement, ListElement, TextFlow
						{
							var tb:ITextBlock = null;
							var p:IParagraphElement = elem.getFirstLeaf().getParagraph();
							if (p)
								tb = p.getTextBlock();
							while (!tb && p)
							{
								p = p.getNextParagraph();
								tb = p.getTextBlock();
							}

							if (composer is IFlowComposer && composer.numLines > 0)
							{
								// get the first line and the last line
								var firstLine:ITextFlowLine = null;
								var lastLine:ITextFlowLine = null;

								if (tb && tb.firstLine)
								{
									firstLine = tb.firstLine.userData;

									do
									{
										tb = p.getTextBlock();
										if (tb && tb.lastLine)
											lastLine = tb.lastLine.userData;
										var leaf:IFlowLeafElement = p.getLastLeaf().getNextLeaf(elem);
										if (leaf)
											p = leaf.getParagraph();
										else
											p = null;
									} while (p);
								}
								if (firstLine && lastLine)
								{
									var startColumnIndex:int = firstLine.columnIndex;
									var startController:IContainerController = firstLine.controller;
									var endColumnIndex:int = lastLine.columnIndex;
									var endController:IContainerController = lastLine.controller;
									if (startController && endController)
									{
										if (startController == endController && endColumnIndex == startColumnIndex)
										{
											r = startController.columnState.getColumnAt(startColumnIndex);
											r.top = firstLine.y;
											r.bottom = lastLine.y + lastLine.height;
											bb.addBlockRect(elem, r, startController);
										}
										else
										{
											// start part
											if (startController != endController)
											{
												for (var sIdx:int = startController.columnCount - 1; sIdx > startColumnIndex; sIdx--)
												{
													r = startController.columnState.getColumnAt(sIdx);
													bb.addBlockRect(elem, r, startController);
												}
											}
											if (endColumnIndex != startColumnIndex)
											{
												r = startController.columnState.getColumnAt(startColumnIndex);
												r.top = firstLine.y;
												bb.addBlockRect(elem, r, startController);
											}
											// center part, all parcel should be painted
											var passFirstController:Boolean = false;
											for (var aidx:Number = 0; aidx < composer.numControllers; aidx++)
											{
												var cc:IContainerController = composer.getControllerAt(aidx);
												if (passFirstController)
												{
													for (var cidx:int = 0; cidx < cc.columnCount; cidx++)
													{
														r = cc.columnState.getColumnAt(cidx);
														bb.addBlockRect(elem, r, cc);
													}
												}
												if (cc == endController)
													break;
												if (cc == startController)
													passFirstController = true;
											}
											// end part
											if (startController != endController)
											{
												for (var eIdx:int = 0; eIdx < endColumnIndex; eIdx++)
												{
													r = endController.columnState.getColumnAt(eIdx);
													bb.addBlockRect(elem, r, endController);
												}
											}
											r = endController.columnState.getColumnAt(endColumnIndex);
											r.bottom = lastLine.y + lastLine.height;
											bb.addBlockRect(elem, r, endController);
										}
									}
								}
							}
							// the first time display for TCM
							else if (composer is IFactoryComposer)
							{
								var fLine:ITextLine = null;
								var lLine:ITextLine = null;

								if (tb && tb.firstLine)
								{
									fLine = tb.firstLine;

									do
									{
										tb = p.getTextBlock();
										if (tb && tb.lastLine)
											lLine = tb.lastLine;
										var leafF:IFlowLeafElement = p.getLastLeaf().getNextLeaf(elem);
										if (leafF)
											p = leafF.getParagraph();
										else
											p = null;
									} while (p);
								}
								if (fLine && lLine)
								{
									if ((composer as Object).hasOwnProperty("tcm"))
									{
										var tcm:ITextContainerManager = (composer as Object).tcm;
										if (tcm)
										{
											r = new Rectangle(0, fLine.y - fLine.height, tcm.compositionWidth, lLine.y - fLine.y + fLine.height);
											bb.addBlockRect(elem, r, composer.getControllerAt(0));
										}
									}
								}
							}
						}
					}
				}
			}
		}

		public static function hasBorderOrBackground(elem:IFlowElement):Boolean
		{
			var format:ITextLayoutFormat = elem.computedFormat;
			if (format.backgroundColor != BackgroundColor.TRANSPARENT)
				return true;

			if (format.borderLeftWidth != 0 || format.borderRightWidth != 0 || format.borderTopWidth != 0 || format.borderBottomWidth != 0)
				if (format.borderLeftColor != BorderColor.TRANSPARENT || format.borderRightColor != BorderColor.TRANSPARENT || format.borderTopColor != BorderColor.TRANSPARENT || format.borderBottomColor != BorderColor.TRANSPARENT)
					return true;
			return false;
		}
	}
}
