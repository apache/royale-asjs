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
	import org.apache.royale.core.UIBase;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.compose.FloatCompositionData;
	import org.apache.royale.textLayout.compose.IFlowComposer;
	import org.apache.royale.textLayout.compose.ISimpleCompose;
	import org.apache.royale.textLayout.compose.utils.FactoryHelper;
	import org.apache.royale.textLayout.container.ScrollPolicy;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.ParagraphElement;
	import org.apache.royale.textLayout.elements.SpanElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.Float;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;

/**
 * The TextFlowTextLineFactory class provides a simple way to create TextLines for displaying text from a text flow.
 * 
 * <p>The text lines are static and created fit in a single bounding rectangle, but can have multiple paragraphs and formats as well as
 * inline graphics. To create ITextLine objects directly from a string, use StringTextLineFactory.</p> 
 *
 * <p><b>Note:</b> When using inline graphics, the <code>source</code> property of the InlineGraphicElement object 
 * must either be an instance of a DisplayObject or a Class object representing an embedded asset. 
 * URLRequest objects cannot be used. The width and height of the inline graphic at the time the line 
 * is created is used to compose the flow. </p>
 * 
 * @playerversion Flash 10
 * @playerversion AIR 1.5
 * @langversion 3.0
 *
 * @see org.apache.royale.textLayout.elements.TextFlow TextFlow
 * @see org.apache.royale.textLayout.factory.StringTextLineFactory StringTextLineFactory
*/
	public class TextFlowTextLineFactory extends TextLineFactoryBase
	{
		/** 
		 * Creates a TextFlowTextLineFactory object. 
		 * 
 		 * @playerversion Flash 10
 		 * @playerversion AIR 1.5
 		 * @langversion 3.0
 		 */
		public function TextFlowTextLineFactory()
		{
			super();
		}

		/**
		 * Creates ITextLine objects from the specified text flow.
		 * 
		 * <p>The text lines are composed to fit the bounds assigned to the <code>compositionBounds</code> property.
		 * As each line is created, the factory calls the function specified in the 
		 * <code>callback</code> parameter. This function is passed the ITextLine object and
		 * is responsible for displaying the line. If a line has a background color, the factory also calls the
		 * callback function with a Shape object containing a rectangle of the background color.</p>
		 * 
		 * <p>Note that the scroll policies of the factory will control how many lines are generated.</p>
		 * 
		 * @param callback function to call with each generated ITextLine object.  
		 * The callback will be called with a Shape object representing any background color (if present), 
		 * and with ITextLine objects for the text.
		 * @param textFlow The TextFlow from which the lines are created.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */	
		public function createTextLines(callback:Function,textFlow:ITextFlow):void
		{
			var saved:ISimpleCompose = TextLineFactoryBase.beginFactoryCompose();
			try
			{
				createTextLinesInternal(callback,textFlow);
			}
			finally
			{
				textFlow.changeFlowComposer(null,false);
				FactoryHelper.staticComposer.lines.splice(0);
				if (_pass0Lines)
					_pass0Lines.splice(0);
				TextLineFactoryBase.endFactoryCompose(saved);
			}
		}
		private  function createTextLinesInternal(callback:Function,textFlow:ITextFlow):void
		{
			var measureWidth:Boolean  = isNaN(compositionBounds.width);
			
			var bp:String = textFlow.computedFormat.blockProgression;
						
			var helper:IFlowComposer = createFlowComposer();
			
			helper.swfContext = swfContext;

			helper.addController(containerController);
			textFlow.flowComposer = helper; 
			textFlow.clearBackgroundManager();
			// this assertion is for TCM.  It's valid in other cases to use the factory but Links won't work and graphics may not load properly
			CONFIG::debug { assert(!this.hasOwnProperty("tcm") || textFlow.mustUseComposer() == false,"Factory composing in TCM when interaction needed"); }
			
			_isTruncated = false;
			
			// compose
			containerController.setCompositionSize(compositionBounds.width, compositionBounds.height);
			containerController.verticalScrollPolicy = truncationOptions ? ScrollPolicy.OFF : verticalScrollPolicy;
			containerController.horizontalScrollPolicy = truncationOptions ? ScrollPolicy.OFF : horizontalScrollPolicy;
			textFlow.normalize();
			textFlow.applyUpdateElements(true);

			helper.compose();
		
			// Need truncation if all the following are true
			// - truncation options exist
			// - content doesn't fit		
			if (truncationOptions && !doesComposedTextFit(truncationOptions.lineCountLimit, textFlow.textLength, bp))
			{
				_isTruncated = true;
				var somethingFit:Boolean = false; // were we able to fit something?

				computeLastAllowedLineIndex (truncationOptions.lineCountLimit);	
				if (_truncationLineIndex >= 0)
				{					
					// Create a span for the truncation indicator
					var truncationIndicatorSpan:SpanElement = new SpanElement();
					truncationIndicatorSpan.text = truncationOptions.truncationIndicator; 
					truncationIndicatorSpan.id = "truncationIndicator"; // prevents merging with other spans 
					if (truncationOptions.truncationIndicatorFormat)
						truncationIndicatorSpan.format = truncationOptions.truncationIndicatorFormat;
					
					var hostFormat:ITextLayoutFormat = textFlow.hostFormat;
					
					// Initial truncation position: end of the last allowed line
					var line:ITextLine = FactoryHelper.staticComposer.lines[_truncationLineIndex] as ITextLine; 
					var truncateAtCharPosition:int =  line.userData + line.rawTextLength;
					
					// Save off the original lines: used in getNextTruncationPosition
					// Note that for the original lines to be valid when used, the containing text block should not be modified
					// Cloning the text flow before modifying it ensures that
					if (!_pass0Lines)
						_pass0Lines = new Array();
					_pass0Lines = FactoryHelper.staticComposer.swapLines(_pass0Lines); 

					// The following loop executes repeatedly composing text until it fits
					// In each iteration, an atoms's worth of characters of original content is dropped 
					do
					{
						// Clone the part of the flow before the truncation position  
						textFlow = textFlow.deepCopy(0, truncateAtCharPosition) as ITextFlow;
						// TODO-2/18/2009-deepCopy does not copy hostTextLayoutFormat
						if (hostFormat)
							textFlow.hostFormat = hostFormat;
						
						// Find a parent for the truncation span
						var parent:IFlowGroupElement;
						var lastLeaf:IFlowLeafElement = textFlow.getLastLeaf();
						if (lastLeaf)
						{
							parent = lastLeaf.parent;
							// Set format to match the leaf if none specified 
							if (!truncationOptions.truncationIndicatorFormat)
								truncationIndicatorSpan.format = lastLeaf.format;
						}
						else
						{
							parent = new ParagraphElement();
							textFlow.addChild(parent);
						}
					
						// Append the truncation span (after severing it from the previous flow)
						if (truncationIndicatorSpan.parent)
							truncationIndicatorSpan.parent.removeChild(truncationIndicatorSpan);
						parent.addChild(truncationIndicatorSpan);
						
						textFlow.flowComposer = helper;
						textFlow.normalize();
						
						helper.compose();
			
						if (doesComposedTextFit(truncationOptions.lineCountLimit, textFlow.textLength, bp))
						{
							somethingFit = true;
							break; 
						}		
						
						if (truncateAtCharPosition == 0)
							break; // no original content left to make room for truncation indicator
						
						// Try again by truncating at the beginning of the preceding atom
						truncateAtCharPosition = getNextTruncationPosition(truncateAtCharPosition, true);

					} while (true);
				}
				
				if (_truncatedTextFlowCallback != null)
					_truncatedTextFlowCallback (somethingFit ? textFlow : null);
					
				if (!somethingFit)
					FactoryHelper.staticComposer.lines.splice(0); // return no lines
			}
			
			var xadjust:Number = compositionBounds.x;
			// toptobottom sets zero to the right edge - adjust the locations
			var controllerBounds:Rectangle = containerController.getContentBounds();
			if (bp == BlockProgression.RL)
				xadjust += (measureWidth ? controllerBounds.width : compositionBounds.width);	
			
			// apply x and y adjustment to the bounds
			controllerBounds.left += xadjust;
			controllerBounds.right += xadjust;
			controllerBounds.top += compositionBounds.y;
			controllerBounds.bottom += compositionBounds.y;
			
			if (textFlow.backgroundManager)
				processBackgroundColors(textFlow,callback,xadjust,compositionBounds.y,containerController.compositionWidth,containerController.compositionHeight);				
			callbackWithTextLines(callback,xadjust,compositionBounds.y);

			setContentBounds(controllerBounds);
			containerController.clearCompositionResults();
		}
		
		/** @private - documented in base class */
		override protected function callbackWithTextLines(callback:Function,delx:Number,dely:Number):void
		{
			super.callbackWithTextLines(callback, delx, dely);
			
			// Handle floats and inlines as well
			var numFloats:int = containerController.numFloats;
			for (var i:int = 0; i < numFloats; ++i)
			{
				var floatInfo:FloatCompositionData = containerController.getFloatAt(i);
				//TODO Figure out how to generalize this with interfaces
				var inlineHolder:UIBase = new UIBase();	// NO PMD
				inlineHolder.alpha = floatInfo.alpha;
				//TODO handle transforms using beads.
//				if (floatInfo.matrix)
//					inlineHolder.transform.matrix = floatInfo.matrix;
				inlineHolder.x += floatInfo.x;
				inlineHolder.y += floatInfo.y;
				inlineHolder.addElement(floatInfo.graphic);
				if (floatInfo.floatType == Float.NONE)
					floatInfo.parent.addElement(inlineHolder);
				else 
				{
					inlineHolder.x += delx;
					inlineHolder.y += dely;
					callback(inlineHolder);
				}
			}
		}
		
		/** @private 
		 * Test hook: Sets a callback function for getting the truncated text flow.
		 * This function is only called if truncation is performed. It takes a single parameter which will have the following value:
		 * null, if nothing fits
		 * A text flow representing the truncated text (containing inital text from the original text flow followed by the truncation indicator), otherwise 
		 */
		public function set truncatedTextFlowCallback(val:Function):void
		{ _truncatedTextFlowCallback = val; }
		
		private var _truncatedTextFlowCallback:Function;
	}
}
