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
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.compose.ISimpleCompose;
	import org.apache.royale.textLayout.compose.utils.ContextUtil;
	import org.apache.royale.textLayout.compose.utils.FactoryHelper;
	import org.apache.royale.textLayout.container.ScrollPolicy;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.Configuration;
	import org.apache.royale.textLayout.elements.IConfiguration;
	import org.apache.royale.textLayout.elements.ParagraphElement;
	import org.apache.royale.textLayout.elements.SpanElement;
	import org.apache.royale.textLayout.elements.TextFlow;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.LineBreak;
	import org.apache.royale.textLayout.utils.FactoryUtil;




/**
 * The StringTextLineFactory class provides a simple way to create TextLines from a string. 
 * 
 * <p>The text lines are static and are created using a single format and a single paragraph. 
 * The lines are created to fit in the specified bounding rectangle.</p>
 * 
 * <p>The StringTextLineFactory provides an efficient way to create TextLines, since it reuses single TextFlow,
 * ParagraphElement, SpanElement, and ContainerController objects across many repeated invocations. You can create a
 * single factory, and use it again and again. You can also reuse all the parts that are the same each time
 * you call it; for instance, you can reuse the various formats and the bounds.</p> 
 *
 * <p><b>Note:</b> To create static lines that use multiple formats or paragraphs, or that include
 * inline graphics, use a TextFlowTextLineFactory and a TextFlow object. </p>
 * 
 * <p><b>Note:</b> The StringTextLineFactory ignores the truncationIndicatorFormat property set in the truncationOptions when truncating text.</p>
 *  
 * @playerversion Flash 10
 * @playerversion AIR 1.5
 * @langversion 3.0
 *
 * @see org.apache.royale.textLayout.factory.TextFlowTextLineFactory TextFlowTextLineFactory
	 */
	public class StringTextLineFactory extends TextLineFactoryBase implements IStringTextLineFactory
	{
		private var _tf:TextFlow;
		private var _para:ParagraphElement;
		private var _span:SpanElement;
		private var _formatsChanged:Boolean;

		static private var _defaultConfiguration:IConfiguration = null;
		
		private var _configuration:IConfiguration;
		
		/** 
		 * The configuration used by the internal TextFlow object.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get configuration():IConfiguration
		{
			return _configuration; 
		}
		
		/** 
		 * The default configuration used by this factory if none is specified. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		static public function get defaultConfiguration():IConfiguration
		{
			if (!_defaultConfiguration)
			{
				_defaultConfiguration = Configuration.defaultConfiguration.clone();
				_defaultConfiguration.flowComposerClass = FactoryUtil.getDefaultFlowComposerClass();
				_defaultConfiguration.textFlowInitialFormat = null;
			}
			return _defaultConfiguration;
		}
		
		/** 
		 * Creates a StringTextLineFactory object.  
		 * 
		 * @param configuration The configuration object used to set the properties of the 
		 * internal TextFlow object used to compose lines produced by this factory. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function StringTextLineFactory(configuration:IConfiguration = null)
		{
			super();
			initialize(configuration);
		}
		
		private function initialize(config:IConfiguration):void
		{	
			_configuration = config ? config.getImmutableClone() : defaultConfiguration.getImmutableClone();
			_tf = new TextFlow(TLFFactory.defaultTLFFactory, _configuration);
			_para = new ParagraphElement();
			_span = new SpanElement();
			_para.replaceChildren(0, 0, _span);
			_tf.replaceChildren(0, 0, _para);
			
			_tf.flowComposer.addController(containerController);
			_formatsChanged = true;
		}
		
		/** 
		 * The character format. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get spanFormat():ITextLayoutFormat
		{
			return _span.format;
		}
		public function set spanFormat(format:ITextLayoutFormat):void
		{
			_span.format = format;
			_formatsChanged = true;
		}
		/** 
		 * The paragraph format. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get paragraphFormat():ITextLayoutFormat
		{
			return _para.format;
		}
		public function set paragraphFormat(format:ITextLayoutFormat):void
		{
			_para.format = format;
			_formatsChanged = true;
		}
		
		/** 
		 * The text flow format.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get textFlowFormat():ITextLayoutFormat
		{
			return _tf.format;
		}
		public function set textFlowFormat(format:ITextLayoutFormat):void
		{
			_tf.format = format;
			_formatsChanged = true;
		}
		
		/** 
		 * The text to convert into ITextLine objects.
		 * 
		 * <p>To produce TextLines, call <code>createTextLines()</code> after setting this
		 * <code>text</code> property and the desired formats.</p> 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get text():String
		{ return _span.text; }
		public function set text(string:String):void
		{
			_span.text = string;
		}
		
		/** @private  Used for measuring the truncation indicator */
		static private var _measurementFactory:StringTextLineFactory = null;
		static private function measurementFactory():StringTextLineFactory
		{
			if (_measurementFactory == null)
				_measurementFactory = new StringTextLineFactory();
			return _measurementFactory;
		}
		static private var _measurementLines:Array = null;
		static private function measurementLines():Array
		{
			if (_measurementLines == null)
				_measurementLines = new Array();
			return _measurementLines;
		}
		
		/** 
		 * Creates ITextLine objects using the text currently assigned to this factory object.
		 * 
		 * <p>The text lines are created using the currently assigned text and formats and
		 * are composed to fit the bounds assigned to the <code>compositionBounds</code> property.
		 * As each line is created, the factory calls the function specified in the 
		 * <code>callback</code> parameter. This function is passed the ITextLine object and
		 * is responsible for displaying the line.</p>
		 * 
		 * <p>To create a different set of lines, change any properties desired and call
		 * <code>createTextLines()</code> again.</p>
		 *  
		 * <p>Note that the scroll policies of the factory will control how many lines are generated.</p>
		 * 
		 * @param callback	The callback function called for each ITextLine object created.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function createTextLines(callback:Function):void
		{
			var saved:ISimpleCompose = TextLineFactoryBase.beginFactoryCompose();
			try
			{
				createTextLinesInternal(callback);
			}
			finally
			{
				FactoryHelper.staticComposer.lines.splice(0);
				if (_pass0Lines)
					_pass0Lines.splice(0);
				TextLineFactoryBase.endFactoryCompose(saved);
			}
		}
		
		/** Internal version preserves generated lines
		 */
		private function createTextLinesInternal(callback:Function):void
		{
			var measureWidth:Boolean  = !compositionBounds || isNaN(compositionBounds.width);
			var measureHeight:Boolean = !compositionBounds || isNaN(compositionBounds.height);

			CONFIG::debug { assert(_tf.flowComposer.numControllers == 1,"DisplayController bad number containers"); }
			CONFIG::debug { assert(containerController == _tf.flowComposer.getControllerAt(0),"ContainerController mixup"); }
			var bp:String = _tf.computedFormat.blockProgression;

			containerController.setCompositionSize(compositionBounds.width, compositionBounds.height);
			// override scroll policy if truncation options are set
			containerController.verticalScrollPolicy = truncationOptions ? ScrollPolicy.OFF : verticalScrollPolicy;
			containerController.horizontalScrollPolicy = truncationOptions ? ScrollPolicy.OFF : horizontalScrollPolicy;

			_isTruncated = false;
			_truncatedText = text;
			
			if (!_formatsChanged && ContextUtil.computeBaseSWFContext(_tf.flowComposer.swfContext) != ContextUtil.computeBaseSWFContext(swfContext))
				_formatsChanged = true;

			_tf.flowComposer.swfContext = swfContext;
			
			if (_formatsChanged)
			{
				_tf.normalize();
				_formatsChanged = false;
			}

			_tf.flowComposer.compose();
			
			// Need truncation if all the following are true
			// - truncation options exist
			// - content doesn't fit		
			if (truncationOptions)
				doTruncation(bp, measureWidth, measureHeight);
			
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
			
			if (_tf.backgroundManager)
				processBackgroundColors(_tf,callback,xadjust,compositionBounds.y,containerController.compositionWidth,containerController.compositionHeight);				
			callbackWithTextLines(callback,xadjust,compositionBounds.y);

			setContentBounds(controllerBounds);
			containerController.clearCompositionResults();
		}
		
		// Need truncation if all the following are true
		// - truncation options exist
		// - content doesn't fit		
		/** @private */
		public function doTruncation(bp:String, measureWidth:Boolean, measureHeight:Boolean):void
		{
			var bpString:String = _tf.computedFormat.blockProgression;
			if (!doesComposedTextFit(truncationOptions.lineCountLimit, _tf.textLength, bpString))
			{
				_isTruncated = true;
				var somethingFit:Boolean = false; // were we able to fit something?
				var originalText:String = _span.text;
				
				computeLastAllowedLineIndex (truncationOptions.lineCountLimit);	
				if (_truncationLineIndex >= 0)
				{
					// Estimate the initial truncation position using the following steps 
					
					// 1. Measure the space that the truncation indicator will take
					measureTruncationIndicator (compositionBounds, truncationOptions.truncationIndicator);
					
					// 2. Move target line for truncation higher by as many lines as the number of full lines taken by the truncation indicator
					_truncationLineIndex -= (_measurementLines.length -1);
					if (_truncationLineIndex >= 0)
					{
						var truncateAtCharPosition:int;
						
						if (_tf.computedFormat.lineBreak == LineBreak.EXPLICIT || (bpString == BlockProgression.TB ? measureWidth : measureHeight))
						{
							// 3., 4. Initial truncation position: end of the last allowed line 
							var line:ITextLine = FactoryHelper.staticComposer.lines[_truncationLineIndex] as ITextLine; 
							truncateAtCharPosition =  line.userData + line.rawTextLength;
						}
						else
						{
							// 3. Calculate allowed width (width left over from the last line of the truncation indicator)
							var targetWidth:Number = (bpString == BlockProgression.TB ? compositionBounds.width : compositionBounds.height); 
							if (paragraphFormat)
							{
								targetWidth -= (Number(paragraphFormat.paragraphSpaceAfter) + Number(paragraphFormat.paragraphSpaceBefore));
								if (_truncationLineIndex == 0)
									targetWidth -= paragraphFormat.textIndent;
							}
							
							var allowedWidth:Number = targetWidth - (_measurementLines[_measurementLines.length-1] as ITextLine).unjustifiedTextWidth;
							
							// 4. Get the initial truncation position on the target line given this allowed width 
							truncateAtCharPosition = getTruncationPosition(FactoryHelper.staticComposer.lines[_truncationLineIndex], allowedWidth);
						}
						
						// Save off the original lines: used in getNextTruncationPosition
						if (!_pass0Lines)
							_pass0Lines = new Array();
						_pass0Lines = FactoryHelper.staticComposer.swapLines(_pass0Lines);
						
						// Note that for the original lines to be valid when used, the containing text block should not be modified
						// Cloning the paragraph ensures this 
						_para = _para.deepCopy() as ParagraphElement; 
						_span = _para.getChildAt(0) as SpanElement;
						_tf.replaceChildren(0, 1, _para);
						_tf.normalize();
						
						// Replace all content starting at the inital truncation position with the truncation indicator
						_span.replaceText(truncateAtCharPosition, _span.textLength, truncationOptions.truncationIndicator);
						
						// The following loop executes repeatedly composing text until it fits
						// In each iteration, an atoms's worth of characters of original content is dropped
						do
						{
							_tf.flowComposer.compose();
							
							if (doesComposedTextFit(truncationOptions.lineCountLimit, _tf.textLength, bpString))
							{
								somethingFit = true;
								break; 
							}		
							
							if (truncateAtCharPosition == 0)
								break; // no original content left to make room for truncation indicator
							
							// Try again by truncating at the beginning of the preceding atom
							var newTruncateAtCharPosition:int = getNextTruncationPosition(truncateAtCharPosition);
							_span.replaceText(newTruncateAtCharPosition, truncateAtCharPosition, null);
							truncateAtCharPosition = newTruncateAtCharPosition;
							
						} while (true);
					}
					_measurementLines.splice(0);	// cleanup
				}
				
				if (somethingFit)
					_truncatedText = _span.text;
				else
				{
					_truncatedText = "";
					FactoryHelper.staticComposer.lines.splice(0); // return no lines
				}
				
				_span.text = originalText;
			}
		}
		
		/** @private 
		 * Gets the text that is composed in the preceding call to <code>createTextLines</code>
		 * If no truncation is performed, a string equal to <code>text</code> is returned. 
		 * If truncation is performed, but nothing fits, an empty string is returned.
		 * Otherwise, a substring of <code>text</code> followed by the truncation indicator is returned. 
		 */
		public function get truncatedText():String
		{ return _truncatedText; }
		private var _truncatedText:String;
		
		/** 
		 * Measures the truncation indicator using the same bounds and formats, but without truncation options
		 * Resultant lines are added to _measurementLines
		 */
		private function measureTruncationIndicator (compositionBounds:Rectangle, truncationIndicator:String):void
		{
			var originalLines:Array = FactoryHelper.staticComposer.swapLines(measurementLines()); // ensure we don't overwrite original lines
			var measureFactory:StringTextLineFactory = measurementFactory();
			measureFactory.compositionBounds = compositionBounds;
			measureFactory.text = truncationIndicator;
			measureFactory.spanFormat = spanFormat;
			measureFactory.paragraphFormat = paragraphFormat;
			measureFactory.textFlowFormat = textFlowFormat;
			measureFactory.truncationOptions = null;
			measureFactory.createTextLinesInternal(noopfunction);
			FactoryHelper.staticComposer.swapLines(originalLines); // restore
		}
		
		static private function noopfunction(o:Object):void	// No PMD
		{ }
		

		/** 
		 * Gets the truncation position on a line given the allowed width 
		 * - Must be at an atom boundary
		 * - Must scan the line for atoms in logical order, not physical position order
         * For example, given bi-di text ABאבCD
		 * atoms must be scanned in this order 
         * A, B, א
         * ג, C, D  
		 */
		private function getTruncationPosition (line:ITextLine, allowedWidth:Number):uint
		{			
			var consumedWidth:Number = 0;
			var charPosition:int = line.userData; 						// start of line
			
			while (charPosition < line.userData + line.rawTextLength)	// end of line
			{
				var atomIndex:int = line.getAtomIndexAtCharIndex(charPosition);
				var atomBounds:Rectangle = line.getAtomBounds(atomIndex); 
				consumedWidth += atomBounds.width;
				if (consumedWidth > allowedWidth)
					break;
					
				charPosition = line.getAtomTextBlockEndIndex(atomIndex);
			}
			
			// line.flushAtomData(); // Warning: Now does nothing
			return charPosition;
		}
		
	}
}
