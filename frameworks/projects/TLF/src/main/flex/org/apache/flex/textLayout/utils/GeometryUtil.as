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
	import org.apache.royale.text.engine.ITextLine;
	
	import org.apache.royale.textLayout.compose.IFlowComposer;
	import org.apache.royale.textLayout.compose.ITextFlowLine;
	import org.apache.royale.textLayout.elements.TextRange;

	

	/** 
	 * Utilities for getting information about text geometry and bounds.
	 * The methods of this class are static and must be called using
	 * the syntax <code>GeometryUtil.method(<em>parameter</em>)</code>.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	//  [ExcludeClass]
	public final class GeometryUtil
	{
		/**
		 * Returns an array of line/rectangle object pairs describing the highlight area of the text 
		 * based on the content bounded within the indicies. The rectangles are the same as those which would be 
		 * created if the text were selected. May return one or more pair per line.
		 * 
		 * 
		 * @param range	- a TextRange describing the TextFlow as well as the beginning and end indicies
		 * @return Array - An array of TextLine and Rectangle pairs. The objects can be referenced as:
		 * 		obj.textLine - to access the TextLine object
		 *		obj.rect - to access the rectangle describing the selection in TextLine coordinates
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * Example Usage:
		 *  var theRect:Rectangle = returnArray[0].rect.clone(); 
		 *  var textLine:TextLine = returnArray[0].textLine; 
		 * 	var globalStart:Point = new Point(theRect.x, theRect.y);
		 *  globalStart = textLine.localToGlobal(globalStart);
		 *  globalStart = textLine.parent.globalToLocal(globalStart);
		 *  theRect.x = globalStart.x;
		 *  theRect.y = globalStart.y;
		 * 
		 *  [Make a new shape and draw the path into it. See flash.display.graphics]
		 *  textLine.parent.addChild(newShape);
		 */
		public static function getHighlightBounds(range:TextRange):Array
		{
			var flowComposer:IFlowComposer = range.textFlow.flowComposer;
			if (!flowComposer)
				return null;
			
			
			var resultShapes:Array = new Array();
			
			var begLine:int = flowComposer.findLineIndexAtPosition(range.absoluteStart);
			var endLine:int = range.absoluteStart == range.absoluteEnd ? begLine : flowComposer.findLineIndexAtPosition(range.absoluteEnd);
			
			// watch for going past the end
			if (endLine >= flowComposer.numLines)
				endLine = flowComposer.numLines-1;
					
			var prevLine:ITextFlowLine = begLine > 0 ? flowComposer.getLineAt(begLine-1) : null;
			var nextLine:ITextFlowLine;

			var line:ITextFlowLine = flowComposer.getLineAt(begLine); 			
			
			var mainRects:Array = [];
			
			for (var curLineIndex:int = begLine; curLineIndex <= endLine; curLineIndex++)
			{
				nextLine = curLineIndex != (flowComposer.numLines - 1) ? flowComposer.getLineAt(curLineIndex + 1) : null;
				
				
				var heightAndAdj:Array = line.getRomanSelectionHeightAndVerticalAdjustment(prevLine, nextLine);
				
				var textLine:ITextLine = line.getTextLine(true);

				line.calculateSelectionBounds(textLine, mainRects, 
					range.absoluteStart < line.absoluteStart ? line.absoluteStart - line.paragraph.getAbsoluteStart()
 															 : range.absoluteStart - line.paragraph.getAbsoluteStart(), 
					range.absoluteEnd > (line.absoluteStart + line.textLength) ? line.absoluteStart + line.textLength - line.paragraph.getAbsoluteStart()
																			   : range.absoluteEnd - line.paragraph.getAbsoluteStart(), 
					range.textFlow.computedFormat.blockProgression, heightAndAdj);
				
					
				for each(var rect:Rectangle in mainRects)
				{
					var obj:Object = {};	// NO PMD
					obj.textLine = textLine;
					obj.rect = rect.clone();
					
					resultShapes.push(obj);
				}
				mainRects.length = 0;
				
				var temp:ITextFlowLine = line;
				line = nextLine;
				prevLine = temp;
			}
			
			return resultShapes;
		}
	}
	
}
