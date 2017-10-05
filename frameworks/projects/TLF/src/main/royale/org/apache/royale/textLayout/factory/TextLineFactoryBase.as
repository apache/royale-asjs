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
	import org.apache.royale.textLayout.compose.ISimpleCompose;
	import org.apache.royale.textLayout.compose.utils.FactoryHelper;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.graphics.IGraphicShape;
	import org.apache.royale.svg.GraphicShape;
	import org.apache.royale.text.engine.ITextBlock;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.compose.IFactoryComposer;
	import org.apache.royale.textLayout.compose.IFlowComposer;
	import org.apache.royale.textLayout.compose.ISWFContext;
	import org.apache.royale.textLayout.compose.SimpleCompose;
	import org.apache.royale.textLayout.container.ContainerUtil;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.container.ScrollPolicy;
	import org.apache.royale.textLayout.debug.Debugging;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.ITextFlow;

	


	[Exclude(name="containerController",kind="property")]	
	[Exclude(name="setContentBounds",kind="method")]
	[Exclude(name="callbackWithTextLines",kind="method")]
	[Exclude(name="doesComposedTextFit",kind="method")]
	[Exclude(name="getNextTruncationPosition",kind="method")]


/**
 * The TextLineFactoryBase class serves as the base class for the Text Layout Framework text line factories.
 * 
 * <p><b>Note:</b> Application code does not typically need to create or use a TextLineFactoryBase object directly.
 * Use one of the derived text factory classes instead.</p>
 *  
 * @playerversion Flash 10
 * @playerversion AIR 1.5
 * @langversion 3.0
 *
 * @see org.apache.royale.textLayout.elements.TextFlow
*/
	public class TextLineFactoryBase implements ITextLineFactory
	{
		/** Requested logical bounds to wrap to */
		private var _compositionBounds:Rectangle;

		/** Bounds of composition results - where the text landed */
		private var _contentBounds:Rectangle;
		
		/** @private */
		protected var _isTruncated:Boolean = false;
		
		private var _horizontalScrollPolicy:String;
		private var _verticalScrollPolicy:String;
		private var _truncationOptions:TruncationOptions;
		private var _containerController:IContainerController;

//TODO figure out what this should be
		static private var _tc:IParentIUIBase;
		static private function get tc():IParentIUIBase{
			if(_tc == null)
				_tc = new UIBase();
			
			return _tc;
		}
		
		private var _swfContext:ISWFContext;
		
		/** @private */
		static private      var _savedFactoryComposer:ISimpleCompose;

		/** @private */		
		protected var _truncationLineIndex:int; 	// used during truncation
		/** @private */		
		protected var _pass0Lines:Array; 		// used during truncation
		
		/** @private return the next factory composer that will be used */
		static public function peekFactoryCompose():ISimpleCompose
		{
			if (_savedFactoryComposer == null)
				_savedFactoryComposer = new SimpleCompose();
			return _savedFactoryComposer;
		}
		
		/** @private support recursive calls into the factory */
		static public function beginFactoryCompose():ISimpleCompose
		{
			var rslt:ISimpleCompose = FactoryHelper.staticComposer;
			FactoryHelper.staticComposer = peekFactoryCompose();
			_savedFactoryComposer = null;
			return rslt;
		}
		
		/** @private support recursive calls into the factory */
		static public function endFactoryCompose(prevComposer:ISimpleCompose):void
		{
			_savedFactoryComposer = FactoryHelper.staticComposer;
			FactoryHelper.staticComposer = prevComposer;
		}
		
		/** 
		 * Base-class constructor for text line factories.
		 *  
 		 * <p><b>Note:</b> Application code does not typically need to create or use a TextLineFactoryBase object directly.
		 * Use one of the derived text factory classes instead.</p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function TextLineFactoryBase()
		{
			_containerController = ContainerUtil.getController(tc);
			_horizontalScrollPolicy = _verticalScrollPolicy = String(ScrollPolicy.scrollPolicyPropertyDefinition.defaultValue);
		}
		
		/**
		 * The rectangle within which text lines are created.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get compositionBounds():Rectangle
		{
			return _compositionBounds;
		}
		
		public function set compositionBounds(value:Rectangle):void
		{
			_compositionBounds = value;
		}
		
		/**
		 * The smallest rectangle in which the layed-out content fits.
		 * 
		 * <p><b>Note:</b> Truncated lines are not included in the size calculation.</p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function getContentBounds():Rectangle
		{
			return _contentBounds;
		}
		
		/** @private */
		protected function setContentBounds(controllerBounds:Rectangle):void
		{
			_contentBounds = controllerBounds;
			_contentBounds.offset(compositionBounds.left, compositionBounds.top);
		}
		
		/** 
		* The ISWFContext instance used to make FTE calls as needed. 
		*
		* <p>By default, the ISWFContext implementation is this FlowComposerBase object.
		* Applications can provide a custom implementation to use fonts
		* embedded in a different SWF file or to cache and reuse text lines.</p>
		* 
		* @see org.apache.royale.textLayout.compose.ISWFContext
		* 
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*/
 	
		public function get swfContext():ISWFContext
		{
			return _swfContext;
		}
		public function set swfContext(value:ISWFContext):void
		{
			_swfContext = value;
		}
		
		/** 
		 * Specifies the options for truncating the text if it doesn't fit in the composition bounds.
		 *  
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get truncationOptions():TruncationOptions
		{
			return _truncationOptions;
		}
		public function set truncationOptions(value:TruncationOptions):void
		{
			_truncationOptions = value;
		}
		
		/** 
		 * Indicates whether text was truncated when lines were last created.
		 *  
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get isTruncated():Boolean
		{
			return _isTruncated;
		}

		/** 
		 * Specifies how lines are created when the composition bounds are not large enough.
		 *  
		 * <p>If set to <code>ScrollPolicy.ON</code> or <code>ScrollPolicy.AUTO</code>, all lines
		 * are created. It is the your responsibility to scroll lines in the viewable area (and to
		 * mask lines outside this area, if necessary). If set to <code>ScrollPolicy.OFF</code>, then 
		 * only lines that fit within the composition bounds are created.</p>
		 * 
		 * <p>If the <code>truncationOptions</code> property is set, the scroll policy is ignored 
		 * (and treated as <code>ScrollPolicy.OFF</code>).</p> 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see org.apache.royale.textLayout.compose.StandardFlowComposer
		 * @see org.apache.royale.textLayout.container.ScrollPolicy
		 * @see #truncationOptions
	 	 */
	 	 
	 	public function get horizontalScrollPolicy():String
		{
			return _horizontalScrollPolicy;
		}
		public function set horizontalScrollPolicy(scrollPolicy:String):void
		{
			_horizontalScrollPolicy =  scrollPolicy;
		}
		
		/** 
		 * Specifies how lines are created when the composition bounds are not large enough.
		 *  
		 * <p>If set to <code>ScrollPolicy.ON</code> or <code>ScrollPolicy.AUTO</code>, all lines
		 * are created. It is the your responsibility to scroll lines in the viewable area (and to
		 * mask lines outside this area, if necessary). If set to <code>ScrollPolicy.OFF</code>, then 
		 * only lines that fit within the composition bounds are created.</p>
		 * 
		 * <p>If the <code>truncationOptions</code> property is set, the scroll policy is ignored 
		 * (and treated as <code>ScrollPolicy.OFF</code>).</p> 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see org.apache.royale.textLayout.compose.StandardFlowComposer
		 * @see org.apache.royale.textLayout.container.ScrollPolicy
		 * @see #truncationOptions
	 	 */
	 	 
		public function get verticalScrollPolicy():String
		{
			return _verticalScrollPolicy;
		}
		public function set verticalScrollPolicy(scrollPolicy:String):void
		{
			_verticalScrollPolicy =  scrollPolicy;
		}		
				
		/** @private */
		protected function get containerController():IContainerController
		{
			return _containerController;
		}
		
		/** 
		 * Sends the created ITextLine objects to the client using the supplied callback function.
		 * 
		 * <p>This method sets the <code>x</code> and <code>y</code> properties of the line.</p>
		 * 
		 * @param callback the callback function supplied by the factory user
		 * @param delx the horizontal offset
		 * @param dely the vertical offset
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		protected function callbackWithTextLines(callback:Function,delx:Number,dely:Number):void
		{
			for each (var textLine:ITextLine in FactoryHelper.staticComposer.lines)
			{
				var textBlock:ITextBlock = textLine.textBlock;
				if (textBlock)
				{
					CONFIG::debug { Debugging.traceFTECall(null,textBlock,"releaseLines",textBlock.firstLine, textBlock.lastLine); }	
					textBlock.releaseLines(textBlock.firstLine,textBlock.lastLine);
				}
				textLine.userData = null;
				textLine.x += delx;
				textLine.y += dely;
				textLine.validity = "static";
				CONFIG::debug { Debugging.traceFTEAssign(textLine,"validity","static"); }
				callback(textLine);
			}
		}
		
		/**
		 * Indicates whether the composed text fits in the line count limit and includes all text
		 *  
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */	
		protected function doesComposedTextFit (lineCountLimit:int, textLength:uint, blockProgression:String):Boolean
		{
			if (lineCountLimit != TruncationOptions.NO_LINE_COUNT_LIMIT && FactoryHelper.staticComposer.lines.length > lineCountLimit)
				return false; // Line count limit exceded
			
			var lines:Array = FactoryHelper.staticComposer.lines;
		
			if (!lines.length)
				return textLength ? false /* something to compose, but no line could fit */ : true /* nothing to compose */; 
				
			// This code is only called when scrolling if OFF, so only lines that fit in bounds are generated
			// Just check if the last line reaches the end of flow
			var lastLine:ITextLine = lines[lines.length - 1] as ITextLine;
			return lastLine.userData + lastLine.rawTextLength == textLength;
		}
		
		/** 
		 * Gets the next truncation position by shedding an atom's worth of characters.
		 * 
		 * @param truncateAtCharPosition the current truncation candidate position.
		 * @param multiPara <code>true</code> if text has more than one paragraph.
		 * 
		 * @returns the next candidate truncation position.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		protected function getNextTruncationPosition(truncateAtCharPosition:int, multiPara:Boolean=false):int
		{
			// 1. Get the position of the last character of the preceding atom
			truncateAtCharPosition--; // truncateAtCharPosition-1, because truncateAtCharPosition is an atom boundary
			
			// Note: The current set of lines may not contain the next truncation position because the truncation indicator
			// could combine with original content to form a word that does not afford a suitable break opportunity. 
			// The combined word would then move to the next line, which may not have been composed if the bounds were exceeded.
			// Therefore, this function needs to use the original lines (from before truncation is attempted). 
			CONFIG::debug 
			{ 
				assert(_pass0Lines != null, "getNextTruncationPosition called before saving off lines from the first pass at composition"); 
				assert(_truncationLineIndex < _pass0Lines.length, "index out of range in getNextTruncationPosition");
			}
			
			// 2. Find the new target line (i.e., the line that has the new truncation position) 
			// If the last truncation position was at the beginning of the target line, the new position may have moved to a previous line
			// In any case, the new truncation position lies in the vicinity of the previous target line, so a linear search suffices
			var line:ITextLine = _pass0Lines[_truncationLineIndex] as ITextLine;
			do
			{
				if (truncateAtCharPosition >= line.userData && truncateAtCharPosition < line.userData + line.rawTextLength)
					break;
				if (truncateAtCharPosition < line.userData)
					line = _pass0Lines[--_truncationLineIndex] as ITextLine;
				else
				{
					CONFIG::debug {	assert(false, "truncation position should decrease monotonically");	}
				}	
			}
			while (true);

			var paraStart:int = multiPara ?  line.userData - line.textBlockBeginIndex : 0;
			
			// 3. Get the line atom index at this position			
			var atomIndex:int = line.getAtomIndexAtCharIndex(truncateAtCharPosition - paraStart);
			
			// 4. Get the char index for this atom index
			var nextTruncationPosition:int = line.getAtomTextBlockBeginIndex(atomIndex) + paraStart;
			
			//line.flushAtomData(); // Warning: Now does nothing
			
			return nextTruncationPosition;
		} 
		/** @private */
		public function createFlowComposer():IFlowComposer
		{
			return FactoryHelper.getComposer();
		}			
		
		/** @private
		 * Calculates the last line that fits in the line count limit
		 * The result is stored in  _truncationLineIndex
		 * 
		 * Note: This code is only called when scrolling is OFF, so only lines that fit in bounds are generated
		 */
		public function computeLastAllowedLineIndex (lineCountLimit:int):void
		{			
			_truncationLineIndex = FactoryHelper.staticComposer.lines.length - 1;

			// if line count limit is smaller, use that
			if (lineCountLimit != TruncationOptions.NO_LINE_COUNT_LIMIT && lineCountLimit <= _truncationLineIndex)
				_truncationLineIndex = lineCountLimit - 1;
		}
		
		
		/** @private helper to process the background colors.  default implementation creates a shape and passes it to the callback */
		public function processBackgroundColors(textFlow:ITextFlow,callback:Function,x:Number,y:Number,constrainWidth:Number,constrainHeight:Number):*
		{
			CONFIG::debug { assert(textFlow.backgroundManager != null,"Bad call to processBackgroundColors"); }
			var bgShape:IGraphicShape = new GraphicShape();
			textFlow.backgroundManager.drawAllRects(textFlow,bgShape,constrainWidth,constrainHeight);
			bgShape.x = x;
			bgShape.y = y;
			callback(bgShape);
			textFlow.clearBackgroundManager();
		}
	}

} // end package







