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
package org.apache.royale.textLayout.factory
{
	import org.apache.royale.textLayout.compose.utils.FactoryHelper;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.text.engine.ITextBlock;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.compose.utils.NumberLineUserData;
	import org.apache.royale.textLayout.debug.Debugging;
	import org.apache.royale.textLayout.elements.IBackgroundManager;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;

	public class NumberLineFactory extends StringTextLineFactory implements INumberLineFactory
	{
		private var _listStylePosition:String;
		private var _markerFormat:ITextLayoutFormat;
		private var _backgroundManager:IBackgroundManager;

		public function get listStylePosition():String
		{
			return _listStylePosition;
		}

		public function set listStylePosition(val:String):void
		{
			_listStylePosition = val;
		}

		public function get markerFormat():ITextLayoutFormat
		{
			return _markerFormat;
		}

		public function set markerFormat(val:ITextLayoutFormat):void
		{
			_markerFormat = val;
			spanFormat = val;
		}

		public function get backgroundManager():IBackgroundManager
		{
			return _backgroundManager;
		}

		public function clearBackgroundManager():void
		{
			_backgroundManager = null;
		}

		/** @private */
		static public function calculateInsideNumberLineWidth(numberLine:ITextLine, bp:String):Number
		{
			var minVal:Number = Number.MAX_VALUE;
			var maxVal:Number = Number.MIN_VALUE;
			var idx:int = 0;
			var rect:Rectangle;

			if (bp == BlockProgression.TB)
			{
				for (; idx < numberLine.atomCount; idx++)
				{
					// trace(idx,numberLine.getAtomTextBlockBeginIndex(idx),numberLine.getAtomBounds(idx));
					if (numberLine.getAtomTextBlockBeginIndex(idx) != numberLine.rawTextLength - 1)
					{
						rect = numberLine.getAtomBounds(idx);
						minVal = Math.min(minVal, rect.x);
						maxVal = Math.max(maxVal, rect.right);
					}
				}
			}
			else
			{
				for (; idx < numberLine.atomCount; idx++)
				{
					// trace(idx,numberLine.getAtomTextBlockBeginIndex(idx),numberLine.getAtomBounds(idx));
					if (numberLine.getAtomTextBlockBeginIndex(idx) != numberLine.rawTextLength - 1)
					{
						rect = numberLine.getAtomBounds(idx);
						minVal = Math.min(minVal, rect.top);
						maxVal = Math.max(maxVal, rect.bottom);
					}
				}
			}
			// numberLine.flushAtomData(); // Warning: Now does nothing
			// trace("textWidth",numberLine.textWidth,maxVal-minVal);
			return maxVal > minVal ? maxVal - minVal : 0;
		}

		protected override function callbackWithTextLines(callback:Function, delx:Number, dely:Number):void
		{
			for each (var textLine:ITextLine in FactoryHelper.staticComposer.lines)
			{
				textLine.userData = new NumberLineUserData(listStylePosition, calculateInsideNumberLineWidth(textLine, textFlowFormat.blockProgression), _markerFormat, paragraphFormat.direction);
				var textBlock:ITextBlock = textLine.textBlock;
				if (textBlock)
				{
					CONFIG::debug
					{
						Debugging.traceFTECall(null, textBlock, "releaseLines", textBlock.firstLine, textBlock.lastLine); }
					textBlock.releaseLines(textBlock.firstLine, textBlock.lastLine);
				}
				textLine.x += delx;
				textLine.y += dely;
				textLine.validity = "static";
				CONFIG::debug
				{
					Debugging.traceFTEAssign(textLine, "validity", "static"); }
				callback(textLine);
			}
		}

		// save the backgroundManager for later use.  generate the background when the ITextLine is placed
		public override function processBackgroundColors(textFlow:ITextFlow, callback:Function, x:Number, y:Number, constrainWidth:Number, constrainHeight:Number):*
		{
			_backgroundManager = textFlow.backgroundManager;
			textFlow.clearBackgroundManager();
		}
	}
}
