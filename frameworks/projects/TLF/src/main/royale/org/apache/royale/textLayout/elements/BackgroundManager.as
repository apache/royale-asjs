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
package org.apache.royale.textLayout.elements
{
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.graphics.IGraphicShape;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.compose.ITextFlowLine;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.utils.ObjectMap;
	

	
	/** @private Manages bounds calculation and rendering of backgroundColor character format. */
	public class BackgroundManager implements IBackgroundManager	{
		public static var BACKGROUND_MANAGER_CACHE:ObjectMap = null;
		
		public static var TOP_EXCLUDED:String = "topExcluded";
		public static var BOTTOM_EXCLUDED:String = "bottomExcluded";
		public static var TOP_AND_BOTTOM_EXCLUDED:String = "topAndBottomExcluded";
		protected var _lineDict:ObjectMap;
		protected var _blockElementDict:ObjectMap;
		protected var _rectArray:Array;
		
		public function BackgroundManager()
		{ 
			_lineDict = new ObjectMap(true);
			_blockElementDict = new ObjectMap(true);
			_rectArray = new Array();
		}		
		
		//clear _rectArray, at the beginning of compose TextFlow
		public function clearBlockRecord():void
		{
			_rectArray.splice(0, _rectArray.length);
		}
		
		//insert the background or border rectangle into the front of _rectArray, to make sure the elements that have 
		//larger z-index will be drawn later
		public function addBlockRect(elem:IFlowElement, r:Rectangle, cc:IContainerController = null, style:String = null):void
		{
			var rect:Object = {};
			rect.r = r;
			rect.elem = elem;
			rect.cc = cc;
			rect.style = style;
			_rectArray.unshift(rect);
		}
		
		//register the elements that have background or border to _blockElementDict
		public function addBlockElement(elem:IFlowElement):void
		{
			//register the elements that have never been registered
			if(!_blockElementDict.hasOwnProperty(elem))
			{
				var format:ITextLayoutFormat = elem.computedFormat;
				var record:Object = {};
				record.backgroundColor = format.backgroundColor;
				record.backgroundAlpha = format.backgroundAlpha;
				
				record.borderLeftWidth = format.borderLeftWidth;
				record.borderRightWidth = format.borderRightWidth;
				record.borderTopWidth = format.borderTopWidth;
				record.borderBottomWidth = format.borderBottomWidth;
			

				record.borderLeftColor = format.borderLeftColor;
				record.borderRightColor = format.borderRightColor;
				record.borderTopColor = format.borderTopColor;
				record.borderBottomColor = format.borderBottomColor;
				
				_blockElementDict[elem] = record;
			}
		}
		
		
		public function addRect(tl:ITextLine, fle:IFlowLeafElement, r:Rectangle, color:uint, alpha:Number):void
		{
			var entry:Array = _lineDict[tl];
			if (entry == null)
				entry = _lineDict[tl] = new Array();
			
			var record:Object = {};
			record.rect = r;
			record.fle = fle;
			record.color = color;
			record.alpha = alpha;
			var fleAbsoluteStart:int = fle.getAbsoluteStart();
			
			for (var i:int = 0; i < entry.length; ++i)
			{
				var currRecord:Object = entry[i];
				if (currRecord.hasOwnProperty("fle") && currRecord.fle.getAbsoluteStart() == fleAbsoluteStart)
				{
					// replace it
					entry[i] = record;
					return;
				}
			}
			entry.push(record);
		}
		
		public function addNumberLine(tl:ITextLine, numberLine:ITextLine):void
		{
			var entry:Array = _lineDict[tl];
			if (entry == null)
				entry = _lineDict[tl] = new Array();
			entry.push({numberLine:numberLine});
		}

		
		public function finalizeLine(line:ITextFlowLine):void
		{ return; }	// nothing to do here
		
		/** @private */
		public function getEntry(line:ITextLine):*
		{
			return _lineDict ? _lineDict[line] : undefined; 
		}
		
		// This version is used for the TextLineFactory
		public function drawAllRects(textFlow:ITextFlow, bgShape:IGraphicShape, constrainWidth:Number, constrainHeight:Number):void
		{
//IGraphicShape is not approriate we need something more capable
			//draw background or border for block elements
//			var block:Object;
//			var rec:Rectangle;
//			var style:Object;
//			for(var idx:int = 0; idx < _rectArray.length; idx++)
//			{
//				block = _rectArray[idx];
//				rec = block.r;
//				style = _blockElementDict[block.elem];
//				
//				if(rec && style)
//				{
//					var g:Graphics = bgShape.graphics;
//					//draw background
//					if(style.backgroundColor != BackgroundColor.TRANSPARENT)
//					{
//						// The value 0 indicates hairline thickness; 
//						g.lineStyle(NaN, style.backgroundColor, style.backgroundAlpha, true);
//						g.beginFill(style.backgroundColor, style.backgroundAlpha);
//						g.drawRect(rec.x, rec.y, rec.width, rec.height);
//						g.endFill();
//					}
//					//draw top border
//					g.moveTo(rec.x + Math.floor(style.borderLeftWidth/2), rec.y + Math.floor(style.borderTopWidth/2));
//					if((block.style != BackgroundManager.TOP_EXCLUDED && block.style != BackgroundManager.TOP_AND_BOTTOM_EXCLUDED) &&
//						style.borderTopWidth != 0 && style.borderTopColor != BorderColor.TRANSPARENT)
//					{
//						g.lineStyle(style.borderTopWidth, style.borderTopColor, style.backgroundAlpha, true, "normal", CapsStyle.SQUARE);
//						g.lineTo(rec.x + rec.width - Math.floor(style.borderLeftWidth/2), rec.y + Math.floor(style.borderTopWidth/2));
//					}
//					//draw right border
//					g.moveTo(rec.x + rec.width - Math.floor(style.borderRightWidth/2), rec.y + Math.floor(style.borderTopWidth/2));
//					if(style.borderRightWidth != 0 && style.borderRightColor != BorderColor.TRANSPARENT)
//					{
//						g.lineStyle(style.borderRightWidth, style.borderRightColor, style.backgroundAlpha, true, "normal", CapsStyle.SQUARE);
//						g.lineTo(rec.x + rec.width - Math.floor(style.borderRightWidth/2), rec.y + rec.height- Math.floor(style.borderTopWidth/2));
//					}
//					//draw bottom border
//					g.moveTo(rec.x + rec.width - Math.floor(style.borderLeftWidth/2), rec.y + rec.height - Math.floor(style.borderBottomWidth/2));
//					if((block.style != BackgroundManager.BOTTOM_EXCLUDED && block.style != BackgroundManager.TOP_AND_BOTTOM_EXCLUDED) &&
//						style.borderBottomWidth != 0 && style.borderBottomColor != BorderColor.TRANSPARENT)
//					{
//						g.lineStyle(style.borderBottomWidth, style.borderBottomColor, style.backgroundAlpha, true, "normal", CapsStyle.SQUARE);
//						g.lineTo(rec.x + Math.floor(style.borderLeftWidth/2), rec.y + rec.height - Math.floor(style.borderBottomWidth/2));
//					}
//					//draw left border
//					g.moveTo(rec.x + Math.floor(style.borderLeftWidth/2), rec.y + rec.height - Math.floor(style.borderTopWidth/2));
//					if(style.borderLeftWidth != 0 && style.borderLeftColor != BorderColor.TRANSPARENT)
//					{
//						g.lineStyle(style.borderLeftWidth, style.borderLeftColor, style.backgroundAlpha, true, "normal", CapsStyle.SQUARE);
//						g.lineTo(rec.x + Math.floor(style.borderLeftWidth/2), rec.y + Math.floor(style.borderTopWidth/2));
//					}
//				}
//			}
//			//draw background for span
//			for (var line:Object in _lineDict)
//			{
//				var entry:Array = _lineDict[line];
//				if (entry.length)
//				{
//					var columnRect:Rectangle = entry[0].columnRect;	// set in TextLineFactoryBase.finalizeLine
//					var r:Rectangle;
//					var record:Object;
//					for(var i:int = 0; i<entry.length; ++i)
//					{
//						record = entry[i];
//						if (record.hasOwnProperty("numberLine"))
//						{
//							var numberLine:ITextLine = record.numberLine;
//							var backgroundManager:BackgroundManager = TextFlowLine.getNumberLineBackground(numberLine);
//							var numberEntry:Array = backgroundManager._lineDict[numberLine];
//							for (var ii:int = 0; ii < numberEntry.length; ii++)
//							{
//								var numberRecord:Object = numberEntry[ii];
//								r = numberRecord.rect;
//								r.x += line.x + numberLine.x;
//								r.y += line.y + numberLine.y;
//								TextFlowLine.constrainRectToColumn(textFlow, r, columnRect, 0, 0, constrainWidth, constrainHeight)						
//								
//								bgShape.graphics.beginFill(numberRecord.color, numberRecord.alpha);
//								bgShape.graphics.drawRect(r.x,r.y,r.width,r.height);
//								bgShape.graphics.endFill();
//							}
//						}
//						else
//						{
//							r = record.rect;
//							r.x += line.x;
//							r.y += line.y;
//							TextFlowLine.constrainRectToColumn(textFlow, r, columnRect, 0, 0, constrainWidth, constrainHeight)						
//							
//							bgShape.graphics.beginFill(record.color, record.alpha);
//							bgShape.graphics.drawRect(r.x,r.y,r.width,r.height);
//							bgShape.graphics.endFill();
//						}
//					}
//				}
//			}
		}		
		
		public function removeLineFromCache(tl:ITextLine):void
		{
			delete _lineDict[tl];
		}

		// This version is used for the TextFlow/flowComposer standard model
		public function onUpdateComplete(controller:IContainerController):void
		{
			var container:IParentIUIBase = controller.container;
			var bgShape:IUIBase;
			
			if(container && container.numElements)
			{
				bgShape = controller.getBackgroundShape();
//				bgShape.graphics.clear();
//				
//				//draw background or border for block elements
//				var rec:Rectangle;
//				var style:Object;
//				var block:Object;
//				for(var idx:int = 0; idx < _rectArray.length; idx++)
//				{
//					block = _rectArray[idx];
//					if(block.cc == controller)
//					{
//						style = _blockElementDict[block.elem];
//						if(style != null)
//						{
//							rec = block.r;
//							var g:Graphics = bgShape.graphics;
//							//draw background
//							if(style.backgroundColor != BackgroundColor.TRANSPARENT)
//							{
//								// The value 0 indicates hairline thickness; NaN removes line
//								g.lineStyle(NaN, style.backgroundColor, style.backgroundAlpha, true);
//								g.beginFill(style.backgroundColor, style.backgroundAlpha);
//								g.drawRect(rec.x, rec.y, rec.width, rec.height);
//								g.endFill();
//							}
//							//draw top border
//							g.moveTo(rec.x + Math.floor(style.borderLeftWidth/2), rec.y + Math.floor(style.borderTopWidth/2));
//							if((block.style != BackgroundManager.TOP_EXCLUDED && block.style != BackgroundManager.TOP_AND_BOTTOM_EXCLUDED) &&
//								style.borderTopWidth != 0 && style.borderTopColor != BorderColor.TRANSPARENT)
//							{
//								g.lineStyle(style.borderTopWidth, style.borderTopColor, style.backgroundAlpha, true, "normal", CapsStyle.SQUARE);
//								g.lineTo(rec.x + rec.width - Math.floor(style.borderLeftWidth/2), rec.y + Math.floor(style.borderTopWidth/2));
//							}
//							//draw right border
//							g.moveTo(rec.x + rec.width - Math.floor(style.borderRightWidth/2), rec.y + Math.floor(style.borderTopWidth/2));
//							if(style.borderRightWidth != 0 && style.borderRightColor != BorderColor.TRANSPARENT)
//							{
//								g.lineStyle(style.borderRightWidth, style.borderRightColor, style.backgroundAlpha, true, "normal", CapsStyle.SQUARE);
//								g.lineTo(rec.x + rec.width - Math.floor(style.borderRightWidth/2), rec.y + rec.height- Math.floor(style.borderTopWidth/2));
//							}
//							//draw bottom border
//							g.moveTo(rec.x + rec.width - Math.floor(style.borderLeftWidth/2), rec.y + rec.height - Math.floor(style.borderBottomWidth/2));
//							if((block.style != BackgroundManager.BOTTOM_EXCLUDED && block.style != BackgroundManager.TOP_AND_BOTTOM_EXCLUDED) &&
//								style.borderBottomWidth != 0 && style.borderBottomColor != BorderColor.TRANSPARENT)
//							{
//								g.lineStyle(style.borderBottomWidth, style.borderBottomColor, style.backgroundAlpha, true, "normal", CapsStyle.SQUARE);
//								g.lineTo(rec.x + Math.floor(style.borderLeftWidth/2), rec.y + rec.height - Math.floor(style.borderBottomWidth/2));
//							}
//							//draw left border
//							g.moveTo(rec.x + Math.floor(style.borderLeftWidth/2), rec.y + rec.height - Math.floor(style.borderTopWidth/2));
//							if(style.borderLeftWidth != 0 && style.borderLeftColor != BorderColor.TRANSPARENT)
//							{
//								g.lineStyle(style.borderLeftWidth, style.borderLeftColor, style.backgroundAlpha, true, "normal", CapsStyle.SQUARE);
//								g.lineTo(rec.x + Math.floor(style.borderLeftWidth/2), rec.y + Math.floor(style.borderTopWidth/2));
//							}
//						}
//					}
//				}
//				//draw background for span	
//				for(var childIdx:int = 0; childIdx<controller.textLines.length; ++childIdx)
//				{
//					var line:* = controller.textLines[childIdx];
//					// skip TextFlowTableBlocks
//					if(!(line is ITextLine))
//						continue;
//					var tl:ITextLine = line;
//					var entry:Array = _lineDict[tl];
//		
//					if (entry)
//					{
//						var r:Rectangle;
//						var tfl:TextFlowLine = tl.userData as TextFlowLine;
//						// assert we actually got a tlf from the userData
//						CONFIG::debug { assert(tfl != null, "BackgroundManager missing TextFlowLine!"); }
//						
//						for(var i:int = 0; i < entry.length; i++)
//						{
//							var record:Object = entry[i];
//							// two kinds of records - numberLines and regular
//							if (record.hasOwnProperty("numberLine"))
//							{
//								var numberLine:ITextLine = record.numberLine;
//								var backgroundManager:BackgroundManager = TextFlowLine.getNumberLineBackground(numberLine);
//								var numberEntry:Array = backgroundManager._lineDict[numberLine];
//								if(numberEntry)
//								{
//									for (var ii:int = 0; ii < numberEntry.length; ii++)
//									{
//										var numberRecord:Object = numberEntry[ii];
//										r = numberRecord.rect.clone();
//										r.x += numberLine.x;
//										r.y += numberLine.y;
//										tfl.convertLineRectToContainer(r, true);
//										
//										bgShape.graphics.beginFill(numberRecord.color, numberRecord.alpha);
//										bgShape.graphics.drawRect(r.x,r.y,r.width,r.height);
//										bgShape.graphics.endFill();
//									}
//								}
//							}
//							else
//							{
//								r = record.rect.clone();
//								tfl.convertLineRectToContainer(r, true);
//								
//								bgShape.graphics.beginFill(record.color, record.alpha);
//								bgShape.graphics.drawRect(r.x,r.y,r.width,r.height);
//								bgShape.graphics.endFill();
//							}
//						}
//					}
//				}
			}
		}
		
		public function getShapeRectArray():Array
		{
			return _rectArray;
		}
	}
}
