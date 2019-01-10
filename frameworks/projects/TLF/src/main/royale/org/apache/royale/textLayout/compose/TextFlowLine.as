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
package org.apache.royale.textLayout.compose
{
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.geom.Point;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.graphics.ICompoundGraphic;
	import org.apache.royale.graphics.PathBuilder;
	import org.apache.royale.graphics.SolidColor;
	import org.apache.royale.text.engine.Constants;
	import org.apache.royale.text.engine.ElementFormat;
	import org.apache.royale.text.engine.FontMetrics;
	import org.apache.royale.text.engine.ITextBlock;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.text.engine.TextRotation;
	import org.apache.royale.textLayout.compose.utils.AdornmentUtils;
	import org.apache.royale.textLayout.compose.utils.TextLineUtil;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.debug.Debugging;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.dummy.BoundsUtil;
	import org.apache.royale.textLayout.edit.ISelectionManager;
	import org.apache.royale.textLayout.edit.SelectionFormat;
	import org.apache.royale.textLayout.elements.ElementConstants;
	import org.apache.royale.textLayout.elements.IBackgroundManager;
	import org.apache.royale.textLayout.elements.IContainerFormattedElement;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IInlineGraphicElement;
	import org.apache.royale.textLayout.elements.IListItemElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ISubParagraphGroupElementBase;
	import org.apache.royale.textLayout.elements.ITableLeafElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.elements.LeadingUtils;
	import org.apache.royale.textLayout.elements.utils.GeometricElementUtils;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.Direction;
	import org.apache.royale.textLayout.formats.Float;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.JustificationRule;
	import org.apache.royale.textLayout.formats.LeadingModel;
	import org.apache.royale.textLayout.formats.LineBreak;
	import org.apache.royale.textLayout.formats.ListStylePosition;
	import org.apache.royale.textLayout.formats.TextAlign;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;
	import org.apache.royale.textLayout.utils.CharacterUtil;
	import org.apache.royale.textLayout.utils.Twips;
	import org.apache.royale.utils.ObjectMap;
	import org.apache.royale.utils.PointUtils;

	/** 
	 * The TextFlowLine class represents a single line of text in a text flow.
	 * 
	 * <p>Use this class to access information about how a line of text has been composed: its position, 
	 * height, width, and so on. When the text flow (TextFlow) is modified, the lines immediately before and at the  
	 * site of the modification are marked as invalid because they need to be recomposed. Lines after
	 * the site of the modification might not be damaged immediately, but they might be regenerated once the
	 * text is composed. You can access a TextFlowLine that has been damaged, but any values you access
	 * reflect the old state of the TextFlow. When the TextFlow is recomposed, it generates new lines and you can 
	 * get the new line for a given position by calling <code>TextFlow.flowComposer.findLineAtPosition()</code>.</p>
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public class TextFlowLine implements ITextFlowLine
	{
		// TODO temp setter
		public function set height(value:Number):void
		{
		}

		/** @private - the selection block cache */
		static private var _selectionBlockCache:ObjectMap;
		static private function get selectionBlockCache():ObjectMap{
			if(_selectionBlockCache == null)
				_selectionBlockCache = new ObjectMap(true);
			
			return _selectionBlockCache;
		}

		public function get composable():Boolean
		{
			return true;
		}

		private var _absoluteStart:int;		// text-offset of start of line - from beginning of the TextFlow
		private var _textLength:int;		// number of chars to next line (incl trailing spaces, etc.)
		private var _x:Number = 0;			// left edge of line; left as Number because it is user-settable
		private var _y:Number = 0;			// top edge of line; left as Number because it is user-settable
		private var _height:Number = 0;				// y advance
		private var _outerTargetWidth:Number = 0;	// width line is composed to, excluding indents
		private var _boundsLeftTW:int = 2;			// text line bounds: logical left
		private var _boundsRightTW:int = 1;			// text line bounds: logical right (if left > right, then it is not set)
		private var _para:IParagraphElement;				// owning paragraph
		private var _controller:IContainerController;	// what frame the line was composed into
		private var _columnIndex:int;					// column number in the container
		private var _adornCount:int = 0;
		static private const VALIDITY_MASK:uint = 7;		// 3 bits
		static private const ALIGNMENT_SHIFT:uint = 3;
		static private const ALIGNMENT_MASK:uint = 24; 		// 2 bits
		static private const NUMBERLINE_MASK:uint = 32;		// 1 bit
		static private const GRAPHICELEMENT_MASK:uint = 64;	// 1 bit
		private var _flags:uint;
		// added to support TextFlowLine when ITextLine not available
		protected var _ascent:Number;
		protected var _descent:Number;
		private var _targetWidth:Number;
		protected var _lineOffset:Number;
		private var _lineExtent:Number;	// content bounds logical width for the line
		private var _accumulatedLineExtent:Number;
		private var _accumulatedMinimumStart:Number;
		private var _numberLinePosition:int;

		/** Constructor - creates a new TextFlowLine instance. 
		 *  <p><strong>Note</strong>: No client should call this. It's exposed for writing your own composer.</p>
		 *
		 * @param textLine The ITextLine display object to use for this line.
		 * @param paragraph The paragraph (ParagraphElement) in which to place the line.
		 * @param outerTargetWidth The width the line is composed to, excluding indents.
		 * @param lineOffset The line's offset in pixels from the appropriate container inset (as dictated by paragraph direction and container block progression), prior to alignment of lines in the paragraph. 
		 * @param absoluteStart	The character position in the text flow at which the line begins.
		 * @param numChars	The number of characters in the line.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.text.engine.ITextLine
		 * @see org.apache.royale.textLayout.elements.ParagraphElement
		 * @see #absoluteStart
		 */
		public function TextFlowLine(textLine:ITextLine, paragraph:IParagraphElement, outerTargetWidth:Number = 0, lineOffset:Number = 0, absoluteStart:int = 0, numChars:int = 0)
		{
			initialize(paragraph, outerTargetWidth, lineOffset, absoluteStart, numChars, textLine);
		}

		/** @private */
		public function initialize(paragraph:IParagraphElement, outerTargetWidth:Number = 0, lineOffset:Number = 0, absoluteStart:int = 0, numChars:int = 0, textLine:ITextLine = null):void
		{
			_para = paragraph;
			_outerTargetWidth = outerTargetWidth;
			_absoluteStart = absoluteStart;
			_textLength = numChars;

			_adornCount = 0;
			_lineExtent = 0;
			_accumulatedLineExtent = 0;
			_accumulatedMinimumStart = Constants.MAX_LINE_WIDTH;

			_flags = 0;
			_controller = null;

			if (textLine)
			{
				textLine.userData = this;
				_targetWidth = textLine.specifiedWidth;
				_ascent = textLine.ascent;
				_descent = textLine.descent;
				// the docs say this is true
				CONFIG::debug
				{
					assert(textLine.textHeight == textLine.ascent + textLine.descent, "bad textheight"); }
				_lineOffset = lineOffset;
				setValidity(textLine.validity);
				CONFIG::debug
				{
					assert(textLine.validity == "valid", "Initializing TextFlowLine to invalid ITextLine"); }
				setFlag(textLine.hasGraphicElement ? GRAPHICELEMENT_MASK : 0, GRAPHICELEMENT_MASK);
			}
			else
				setValidity("invalid");
		}

		private function setFlag(value:uint, mask:uint):void
		{
			CONFIG::debug
			{
				assert((value | mask) == mask, "TFL:setFlag bad value"); }
			_flags = (_flags & ~mask) | value;
		}

		private function getFlag(mask:uint):uint
		{
			return _flags & mask;
		}

		/** @private */
		public function get heightTW():int
		{
			return Twips.to(_height);
		}

		/** @private */
		public function get outerTargetWidthTW():int
		{
			return Twips.to(_outerTargetWidth);
		}

		/** @private */
		public function get ascentTW():int
		{
			return Twips.to(_ascent);
		}

		/** @private */
		public function get targetWidthTW():int
		{
			return Twips.to(_targetWidth);
		}

		/** @private */
		public function get textHeightTW():int
		{
			return Twips.to(textHeight);
		}

		/** @private */
		public function get lineOffsetTW():int
		{
			return Twips.to(_lineOffset);
		}

		/** @private */
		public function get lineExtentTW():int
		{
			return Twips.to(_lineExtent);
		}

		/** @private */
		public function get hasGraphicElement():Boolean
		{
			return getFlag(GRAPHICELEMENT_MASK) != 0;
		}

		/** @private */
		public function get hasNumberLine():Boolean
		{
			return getFlag(NUMBERLINE_MASK) != 0;
		}

		/** @private */
		public function get numberLinePosition():Number
		{
			return Twips.from(_numberLinePosition);
		}

		/** @private */
		public function set numberLinePosition(position:Number):void
		{
			CONFIG::debug
			{
				assert(Twips.from(Twips.to(position)) == position, "Bad numberLinePosition"); }
			_numberLinePosition = Twips.to(position);
		}

		/**
		 * The height of the text line, which is equal to <code>ascent</code> plus <code>descent</code>. The 
		 * value is calculated based on the difference between the baselines that bound the line, either 
		 * ideographic top and bottom or ascent and descent depending on whether the baseline at y=0 
		 * is ideographic (for example, TextBaseline.IDEOGRAPHIC_TOP) or not. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.text.engine.TextBaseline TextBaseline
		 */
		public function get textHeight():Number
		{
			return _ascent + _descent;
		}

		/** 
		 * The horizontal position of the line relative to its container, expressed as the offset in pixels from the 
		 * left of the container.
		 * <p><strong>Note: </strong>Although this property is technically <code>read-write</code>, 
		 * you should treat it as <code>read-only</code>. The setter exists only to satisfy the
		 * requirements of the IVerticalJustificationLine interface that defines both a getter and setter for this property.
		 * Use of the setter, though possible, will lead to unpredictable results.
		 * </p>
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see #y
		 */
		public function get x():Number
		{
			return _x;
		}

		/** 
		 * This comment is ignored, but the setter should not be used and exists only to satisfy
		 * the IVerticalJustificationLine interface.
		 * @see org.apache.royale.textLayout.compose.IVerticalJustificationLine 
		 * @private 
		 */
		public function set x(lineX:Number):void
		{
			_x = lineX;
			// invalidate bounds
			_boundsLeftTW = 2;
			_boundsRightTW = 1;
		}

		/** @private */
		public function get xTW():int
		{
			return Twips.to(_x);
		}

		/** 
		 * The vertical position of the line relative to its container, expressed as the offset in pixels from the top 
		 * of the container.
		 * <p><strong>Note: </strong>Although this property is technically <code>read-write</code>, 
		 * you should treat it as <code>read-only</code>. The setter exists only to satisfy the
		 * requirements of the IVerticalJustificationLine interface that defines both a getter and setter for this property.
		 * Use of the setter, though possible, will lead to unpredictable results.
		 * </p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see #x
		 */
		public function get y():Number
		{
			return _y;
		}

		/** @private */
		public function get yTW():int
		{
			return Twips.to(_y);
		}

		/** This comment is ignored, but the setter should not be used and exists only to satisfy
		 * the IVerticalJustificationLine interface.
		 * @see org.apache.royale.textLayout.compose.IVerticalJustificationLine
		 * @private
		 */
		public function set y(lineY:Number):void
		{
			_y = lineY;
			// invalidate bounds
			_boundsLeftTW = 2;
			_boundsRightTW = 1;
		}

		/** @private */
		public function setXYAndHeight(lineX:Number, lineY:Number, lineHeight:Number):void
		{
			_x = lineX;
			_y = lineY;
			_height = lineHeight;
			// invalidate bounds
			_boundsLeftTW = 2;
			_boundsRightTW = 1;
		}

		/** 
		 * One of the values from TextFlowLineLocation for specifying a line's location within a paragraph.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.textLayout.elements.ParagraphElement
		 * @see TextFlowLineLocation
		 */
		public function get location():int
		{
			if (_para)
			{
				var lineStart:int;

				// Harbs 8-31-14 added handling of multiple textBlocks might need more work to handle end?
				var textLine:ITextLine = peekTextLine();
				if (textLine)
					lineStart = _absoluteStart - _para.getTextBlockAbsoluteStart(textLine.textBlock);
				else
					lineStart = _absoluteStart - _para.getAbsoluteStart();
				// Initialize settings for location
				if (lineStart == 0)		// we're at the start of the paragraph
					return _textLength == _para.textLength ? TextFlowLineLocation.ONLY : TextFlowLineLocation.FIRST;
				if (lineStart + textLength == _para.textLength)	// we're at the end of the para
					return TextFlowLineLocation.LAST;
			}
			return TextFlowLineLocation.MIDDLE;
		}

		/** 
		 * The controller (ContainerController object) for the container in which the line has been placed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see org.apache.royale.textLayout.container.ContainerController 
		 */
		public function get controller():IContainerController
		{
			return _controller;
		}

		/** The number of the column in which the line has been placed, with the first column being 0.
		 *		
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get columnIndex():int
		{
			return _columnIndex;
		}

		/**
		 *  @private 
		 * @royaleignorecoercion org.apache.royale.textLayout.container.ContainerController
		 */
		public function setController(cont:IContainerController, colNumber:int):void
		{
			_controller = cont;
			_columnIndex = colNumber;
		}

		/** The height of the line in pixels.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */
		public function get height():Number
		{
			return _height;
		}

		/** 
		 * @copy org.apache.royale.text.engine.ITextLine#ascent
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get ascent():Number
		{
			return _ascent;
		}

		/** 
		 * @copy org.apache.royale.text.engine.ITextLine#descent
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get descent():Number
		{
			return _descent;
		}

		/** 
		 * The line's offset in pixels from the appropriate container inset (as dictated by paragraph direction and container block progression), 
		 * prior to alignment of lines in the paragraph.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get lineOffset():Number
		{
			return _lineOffset;
		}

		/** 
		 * The paragraph (ParagraphElement) in which the line resides.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see org.apache.royale.textLayout.elements.ParagraphElement
		 */
		public function get paragraph():IParagraphElement
		{
			return _para;
		}

		/** 
		 * The location of the line as an absolute character position in the TextFlow object.
		 * 
		 * @return 	the character position in the text flow at which the line begins.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.textLayout.elements.TextFlow
		 */
		public function get absoluteStart():int
		{
			return _absoluteStart;
		}
		public function get textBlockStart():int
		{
			var start:int = absoluteStart;
			var paraStart:int = paragraph.getAbsoluteStart();
			start -= paraStart;
			var tbs:Vector.<ITextBlock> = paragraph.getTextBlocks();
			if(tbs.length > 1)
			{
				var textBlock:ITextBlock = paragraph.getTextBlockAtPosition(start);
				for(var i:int = 0; i < tbs.length; i++)
				{
					if(textBlock == tbs[i])
						break;
					start -= tbs[i].content.rawText.length;
				}
			}

			return start;


		}

		/** @private */
		public function setAbsoluteStart(val:int):void
		{
			_absoluteStart = val;
		}

		/** 
		 * The number of characters to the next line, including trailing spaces. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get textLength():int
		{
			return _textLength;
		}

		/** @private */
		public function setTextLength(val:int):void
		{
			_textLength = val;
			// assert(_validity == "invalid", "not already damaged");
			damage("invalid");
		}

		/** 
		 * The amount of space to leave before the line.
		 * <p>If the line is the first line of a paragraph that has a space-before applied, the line will have
		 * a <code>spaceBefore</code> value. If the line comes at the top of a column, <code>spaceBefore</code> is ignored. 
		 * Otherwise, the line follows another line in the column, and it is positioned vertically to insure that there is
		 * at least this much space left between this line and the last line of the preceding paragraph.</p> 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.textLayout.formats.TextLayoutFormat#paragraphSpaceBefore TextLayoutFormat.paragraphSpaceBefore
		 */
		public function get spaceBefore():Number
		{
			return (this.location & TextFlowLineLocation.FIRST) ? _para.computedFormat.paragraphSpaceBefore : 0;
		}

		/** 
		 * The amount of space to leave after the line.
		 * <p>If the line is the last line of a paragraph that has a space-after, the line will have
		 * a <code>spaceAfter</code> value. If the line comes at the bottom of a column, then the <code>spaceAfter</code>
		 * is ignored. Otherwise, the line comes before another line in the column, and the following line must be positioned vertically to
		 * insure that there is at least this much space left between this last line of the paragraph and the first
		 * line of the following paragraph.</p> 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.textLayout.formats.TextLayoutFormat#paragraphSpaceAfter TextLayoutFormat.paragraphSpaceAfter
		 */
		public function get spaceAfter():Number
		{
			return ((this.location & TextFlowLineLocation.LAST) ? _para.computedFormat.paragraphSpaceAfter : 0);
		}

		/** @private 
		 * Target width not including paragraph indents */
		public function get outerTargetWidth():Number
		{
			return _outerTargetWidth;
		}

		/** @private */
		public function set outerTargetWidth(val:Number):void
		{
			_outerTargetWidth = val;
		}

		/** @private  
		 * Amount of space used to break the line
		 * <p>The target width is the amount of space allowed for the line, including the space required for indents.</p>
		 */
		public function get targetWidth():Number
		{
			return _targetWidth;
		}

		/** 
		 * Returns the bounds of the line as a rectangle.
		 *
		 * @return a rectangle that represents the boundaries of the line.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function getBounds():Rectangle
		{
			var textLine:ITextLine = getTextLine(true);
			if (!textLine)
				return new Rectangle();

			// TODO: just use the textLine.x and textLine.y - after all getTextLine now sets them.
			// not going to change this right now though
			var bp:String = paragraph.getAncestorWithContainer().computedFormat.blockProgression;
			var shapeX:Number = this.x;
			var shapeY:Number = createShapeY(bp);
			if (bp == BlockProgression.TB)
				shapeY += descent - textLine.height;
			return new Rectangle(shapeX, shapeY, textLine.width, textLine.height);
		}

		private var _validities:Array;
		private function get validities():Array{
			if(_validities == null)
				_validities  = ["invalid", "possiblyInvalid", "static", "valid", FlowDamageType.GEOMETRY];
			
			return _validities;
		}

		private function setValidity(value:String):void
		{
			CONFIG::debug
			{
				assert(validities.indexOf(value) != -1, "Bad alignment passed to TextFlowLine"); }
			setFlag(validities.indexOf(value), VALIDITY_MASK);
		}

		/** The validity of the line. 
		 * <p>A line can be invalid if the text, the attributes applied to it, or the controller settings have
		 * changed since the line was created. An invalid line can still be displayed, and you can use it, but the values
		 * used will be the values at the time it was created. The line returned by <code>getTextLine()</code> also will be in an
		 * invalid state. </p>
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see #getTextLine()
		 * @see org.apache.royale.text.engine.ITextLine#validity ITextLine.validity
		 * @see FlowDamageType#GEOMETRY
		 */
		public function get validity():String
		{
			return validities[getFlag(VALIDITY_MASK)];
		}

		/** 
		 * The width of the line if it was not justified. For unjustified text, this value is the same as <code>textLength</code>. 
		 * For justified text, this value is what the length would have been without justification, and <code>textLength</code> 
		 * represents the actual line width. For example, when the following String is justified and assigned a width of 500, it 
		 * has an actual width of 500 but an unjustified width of 268.9921875. 
		 *
		 * @internal TBD: add graphic of justified line
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get unjustifiedTextWidth():Number
		{
			// hack - outerTargetWidth holds value from the factory
			var textLine:ITextLine = getTextLine(true);
			return textLine.unjustifiedTextWidth + (_outerTargetWidth - targetWidth);
		}

		/** @private */
		public function get lineExtent():Number
		{
			return _lineExtent;
		}

		/** @private */
		public function set lineExtent(value:Number):void
		{
			_lineExtent = value;
		}

		/** @private */
		public function get accumulatedLineExtent():Number
		{
			return _accumulatedLineExtent;
		}

		/** @private */
		public function set accumulatedLineExtent(value:Number):void
		{
			_accumulatedLineExtent = value;
		}

		/** @private */
		public function get accumulatedMinimumStart():Number
		{
			return _accumulatedMinimumStart;
		}

		/** @private */
		public function set accumulatedMinimumStart(value:Number):void
		{
			_accumulatedMinimumStart = value;
		}

		static private var _alignments:Array;
		static private function get alignments():Array{
			if(_alignments == null)
				_alignments = [TextAlign.LEFT, TextAlign.CENTER, TextAlign.RIGHT];
			
			return _alignments;
		}

		/** @private */
		public function get alignment():String
		{
			return alignments[getFlag(ALIGNMENT_MASK) >> ALIGNMENT_SHIFT];
		}

		/** @private */
		public function set alignment(value:String):void
		{
			CONFIG::debug
			{
				assert(alignments.indexOf(value) != -1, "Bad alignment passed to TextFlowLine"); }
			setFlag(alignments.indexOf(value) << ALIGNMENT_SHIFT, ALIGNMENT_MASK);
		}

		/** @private 
		 * True if the line needs composing. */
		public function isDamaged():Boolean
		{
			return (validity != "valid");
		}

		/** @private
		 * Mark the line as valid */
		public function clearDamage():void
		{
			CONFIG::debug
			{
				assert(validity == FlowDamageType.GEOMETRY, "can't clear damage other than geometry"); }
			setValidity("valid");
		}

		/** @private
		 * Mark the line as damaged */
		public function damage(damageType:String):void
		{
			// trace("TextFlowLine.damage ", this.start.toString(), this.textLength.toString());
			var current:String = validity;
			if (current == damageType || current == "invalid")
				return;	// totally damaged
			setValidity(damageType);
		}

		/** @private */
		/**
		 * Check if the line is visible by comparing a set rectangle to the supplied
		 * rectangle (all values in Twips).
		 * -1 BEFORE visible bounds
		 * 0 Visible
		 * 1 AFTER visible bounds
		 * @private
		 */
		public function testLineVisible(wmode:String, x:int, y:int, w:int, h:int):int
		{
			CONFIG::debug
			{
				assert(hasLineBounds(), "Bad call to TextFlowLine.isLineVisible"); }

			if (wmode == BlockProgression.RL)
			{
				if (_boundsRightTW >= x && _boundsLeftTW < x + w)
					return 0;
				return x < _boundsRightTW ? 1 : -1;
			}

			if (_boundsRightTW >= y && _boundsLeftTW < y + h)
				return 0;
			return y < _boundsRightTW ? -1 : 1;
		}

		public function oldTestLineVisible(wmode:String, x:int, y:int, w:int, h:int):Boolean
		{
			CONFIG::debug
			{
				assert(hasLineBounds(), "Bad call to TextFlowLine.isLineVisible"); }

			if (wmode == BlockProgression.RL)
				return _boundsRightTW >= x && _boundsLeftTW < x + w;

			return _boundsRightTW >= y && _boundsLeftTW < y + h;
		}

		/** @private
		 * Set the text line bounds rectangle, all values in Twips.
		 * If left > right, the rectangle is considered not to be set.
		 * @private
		 */
		public function cacheLineBounds(wmode:String, bndsx:Number, bndsy:Number, bndsw:Number, bndsh:Number):void
		{
			if (wmode == BlockProgression.RL)
			{
				_boundsLeftTW = Twips.to(bndsx);
				_boundsRightTW = Twips.to(bndsx + bndsw);
			}
			else
			{
				_boundsLeftTW = Twips.to(bndsy);
				_boundsRightTW = Twips.to(bndsy + bndsh);
			}
		}

		/** @private
		 * Check if the text line bounds are set. If the stored left
		 * value is > the right value, then the rectangle is not set.
		 * @private
		 */
		public function hasLineBounds():Boolean
		{
			return (_boundsLeftTW <= _boundsRightTW);
		}
		/** @private */
		CONFIG::debug
		public function toString():String
		{
			return "x:" + x + " y: " + y + " absoluteStart:" + absoluteStart + " textLength:" + textLength + " location: " + location + " validity: " + validity;
		}

		/** 
		 * Indicates whether the <code>org.apache.royale.text.engine.ITextLine</code> object for this TextFlowLine exists.  
		 * The value is <code>true</code> if the ITextLine object has <em>not</em> been garbage collected and 
		 * <code>false</code> if it has been.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.text.engine.ITextLine ITextLine
		 */
		public function get textLineExists():Boolean
		{
			return peekTextLine() != null;
		}

		/** @private
		 * Returns the associated ITextLine if there is one. Finds it by looking up in the ITextBlock.
		 */
		public function peekTextLine():ITextLine
		{
			var textLine:ITextLine;

			if (!paragraph)
				return null;

			// Look it up in the textBlock
			var textBlocks:Vector.<ITextBlock> = paragraph.getTextBlocks();
			for each (var textBlock:ITextBlock in textBlocks)
			{
				for (textLine = textBlock.firstLine; textLine; textLine = textLine.nextLine)
				{
					if (textLine.userData == this) // found it
						return textLine;
				}
			}
			return null;
		}

		/** 
		 * Returns the <code>org.apache.royale.text.engine.ITextLine</code> object for this line, which might be recreated 
		 * if it does not exist due to garbage collection. Set <code>forceValid</code> to <code>true</code>
		 * to cause the ITextLine to be regenerated. Returns null if the ITextLine cannot be recreated.
		 *.
		 * @param forceValid	if true, the ITextLine is regenerated, if it exists but is invalid.
		 *
		 * @return object for this line or <code>null</code> if the ITextLine object cannot be 
		 * recreated.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.text.engine.ITextLine ITextLine
		 */
		public function getTextLine(forceValid:Boolean = false):ITextLine
		{
			var textLine:ITextLine = peekTextLine();
			if (textLine && textLine.validity == FlowDamageType.GEOMETRY)
				createShape(paragraph.getTextFlow().computedFormat.blockProgression, textLine);
			else if (!textLine || (textLine.validity == "invalid" && forceValid))
			{
				/*	if (!textLine)
				{
				trace("text line does not exist: regenerating");
				textLine = peekTextLine();
				}
				else
				trace("textline is invalid: regenerated"); */
				if (isDamaged() && validity != FlowDamageType.GEOMETRY)
					return null;

				textLine = getTextLineInternal();
			}

			return textLine;
		}

		private function getTextLineInternal():ITextLine
		{
			// 8-31-14 Do we need to change this to handle multiple textBlocks?
			// Look it up in the textBlock
			var paraAbsStart:int = paragraph.getAbsoluteStart();

			// If we haven't found it yet, we need to regenerate it.
			// Regenerate the whole paragraph at once, up to the current position.
			var textBlock:ITextBlock = paragraph.getTextBlockAtPosition(absoluteStart - paraAbsStart);
			var currentLine:ITextLine = textBlock.firstLine;
			var flowComposer:IFlowComposer = paragraph.getTextFlow().flowComposer;
			var lineIndex:int = flowComposer.findLineIndexAtPosition(paraAbsStart);
			var previousLine:ITextLine = null;
			var textLine:ITextLine;
			do
			{
				var line:ITextFlowLine = flowComposer.getLineAt(lineIndex);
				CONFIG::debug
				{
					assert(line && line.paragraph == paragraph, "Expecting line in same paragraph"); }
				if (currentLine != null && currentLine.validity == "valid" && (line != this || currentLine.userData == line))
				{
					textLine = currentLine;
					currentLine = currentLine.nextLine;
				}
				else if (!line.composable)// TextFlowTableBlock
				{
					textLine = null;
					currentLine = null;
				}
				else
				{
					textLine = line.recreateTextLine(textBlock, previousLine);
					currentLine = null;
				}
				previousLine = textLine;
				++lineIndex;
			} while (line != this);

			// Put it in the cache, so we can find it there next time
			// textLineCache[this] = textLine;

			return textLine;
		}

		/**
		 *  @private Regenerate the ITextLine -- called when textLine has been gc'ed 
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IListItemElement
		 */
		public function recreateTextLine(textBlock:ITextBlock, previousLine:ITextLine):ITextLine
		{
			var textLine:ITextLine;

			var textFlow:ITextFlow = _para.getTextFlow();
			var bp:String = textFlow.computedFormat.blockProgression;
			var flowComposer:IFlowComposer = textFlow.flowComposer;
			var swfContext:ISWFContext = flowComposer.swfContext ? flowComposer.swfContext : SWFContext.globalSWFContext;

			var numberLine:ITextLine;
			var effLineOffset:Number = _lineOffset;
			if (hasNumberLine)
			{
				var boxStartTotalIndent:Number = this._lineOffset - _para.computedFormat.textIndent;
				numberLine = flowComposer.createNumberLine(_para.getParentByType("ListItemElement") as IListItemElement, _para, flowComposer.swfContext, boxStartTotalIndent);
				if (numberLine)
				{
					if (TextLineUtil.getNumberLineListStylePosition(numberLine) == ListStylePosition.INSIDE)
						effLineOffset += TextLineUtil.getNumberLineInsideLineWidth(numberLine);
				}
			}

			// trace("Recreating line from", absoluteStart, "to", absoluteStart + textLength);
//TODO implement line reuse
			// textLine = TextLineRecycler.getLineForReuse();
			// if (textLine)
			// {
			// 	CONFIG::debug
			// 	{
			// 		assert(textFlow.backgroundManager == null || textFlow.backgroundManager.getEntry(textLine) === undefined, "Bad ITextLine in recycler cache"); }
			// 	textLine = swfContext.callInContext(textBlock["recreateTextLine"], textBlock, [textLine, previousLine, _targetWidth, effLineOffset, true]);
			// }
			// else
				textLine = swfContext.callInContext(textBlock.createTextLine, textBlock, [previousLine, _targetWidth, effLineOffset, true]);

			if (textLine == null)
				return null;

			textLine.x = this.x;
			CONFIG::debug
			{
				Debugging.traceFTEAssign(textLine, "x", this.x);  }
			textLine.y = createShapeY(bp);
			CONFIG::debug
			{
				Debugging.traceFTEAssign(textLine, "y", createShapeY(bp));  }
			textLine.doubleClickEnabled = true;
			textLine.userData = this;

			// Regenerate adornments (e.g., underline & strikethru)
			if (_adornCount > 0)
			{
				var paraStart:int = _para.getAbsoluteStart();
				var elem:IFlowLeafElement = _para.findLeaf(this.absoluteStart - paraStart);
				var elemStart:int = elem.getAbsoluteStart();

				CONFIG::debug
				{
					assert(textLine.userData == this, "textLine doesn't point back to TextFlowLine"); }
				if (numberLine)
				{
					var listItemElement:IListItemElement = _para.getParentByType("ListItemElement") as IListItemElement;
					TextLineUtil.initializeNumberLinePosition(numberLine, listItemElement, _para, textLine.textWidth);
				}

				createAdornments(_para.getAncestorWithContainer().computedFormat.blockProgression, elem, elemStart, textLine, numberLine);

				if (numberLine && TextLineUtil.getNumberLineListStylePosition(numberLine) == ListStylePosition.OUTSIDE)
				{
					if (bp == BlockProgression.TB)
						numberLine.x = this.numberLinePosition;
					else
						numberLine.y = this.numberLinePosition;
				}
			}

			return textLine;
		}

		/** @private */
		public function createShape(bp:String, textLine:ITextLine):void
		{
			var newX:Number = this.x;
			// if (int(newX*20) != int(textLine.x*20))
			{
				textLine.x = newX;
				CONFIG::debug
				{
					Debugging.traceFTEAssign(textLine, "x", newX);  }
			}
			var newY:Number = createShapeY(bp);
			// if (int(newY*20) != int(textLine.y*20))
			{
				textLine.y = newY;
				CONFIG::debug
				{
					Debugging.traceFTEAssign(textLine, "y", newY);  }
			}
		}

		private function createShapeY(bp:String):Number
		{
			return bp == BlockProgression.RL ? y : y + _ascent;
		}

		/** @private 
		 * Scan through the format runs within the line, and draw any underline or strikethrough that might need it
		 */
		public function createAdornments(blockProgression:String, elem:IFlowLeafElement, elemStart:int, textLine:ITextLine, numberLine:ITextLine):void
		{
			CONFIG::debug
			{
				assert(elemStart == elem.getAbsoluteStart(), "bad elemStart passed to createAdornments"); }
			var endPos:int = _absoluteStart + _textLength;

			CONFIG::debug
			{
				assert(textLine.validity == "valid", "createAdornments: bad ITextLine validity"); }
			/*if (textLine.validity != "valid")
			{
			// This can happen if we are scrolling through text and lines have been released, 
			// then scrolled back into view before they're gc'ed. Then we have an invalid line in the TextFlowLine
			// cache, so we create a valid text line to calculate where the adornment shapes should go. The 
			// actual shapes will be added to the invalid (original) ITextLine in the TextFlowLine cache.
			textLine = getTextLineInternal();
			}*/

			// init adornments back to 0 - may be redoing the line in a new position
			// This can happen if there was damage earlier in the paragraph, so that the ITextLine was damaged (because all lines in block were damaged)
			// but the TextFlowLine is still considered OK (didn't cause a line break change).
			// CONFIG::debug { assert(_adornCount == 0 && _hasNumberLine == false,"createAdornments: adornments applied twice?"); }
			_adornCount = 0;

			if (numberLine)
			{
				_adornCount++;
				setFlag(NUMBERLINE_MASK, NUMBERLINE_MASK);
				textLine.numberLine = numberLine;
				CONFIG::debug
				{
					Debugging.traceFTECall(null, textLine, "addChildNumberLine", numberLine); }

				// handle background on the numberLine
				if (TextLineUtil.getNumberLineBackground(numberLine) != null)
				{
					var bgm:IBackgroundManager = elem.getTextFlow().getBackgroundManager();
					if (bgm)
						bgm.addNumberLine(textLine, numberLine);
				}
			}
			else
				setFlag(0, NUMBERLINE_MASK);

			for (;;)
			{
				_adornCount += AdornmentUtils.updateAdornments(elem, textLine, blockProgression);

				var elemFormat:ITextLayoutFormat = elem.format;
				var imeStatus:* = elemFormat ? elemFormat.getStyle("imeStatus") : undefined;
				if (imeStatus)
				{
					AdornmentUtils.updateIMEAdornments(elem, textLine, blockProgression, imeStatus as String);
				}
				elemStart += elem.textLength;
				if (elemStart >= endPos)
					break;
				elem = elem.getNextLeaf(_para);
				CONFIG::debug
				{
					assert(elem != null, "bad nextLeaf"); }
			}
		}

		/** @private 
		 * Scan through the format runs within the line, and figure out what the leading for the overall line is.
		 * The line's leading is equal to the maximum leading of any individual run within the line.
		 * The leading in an individual format run is calculated by looking at the leading attribute in the
		 * CharacterFormat. If it is set to a value, we just use that value. Otherwise, if it is set to AUTO,
		 * we calculate the leading based on the point size and the auto leading percentage from the ParagraphFormat.
		 */
		public function getLineLeading(bp:String, elem:IFlowLeafElement, elemStart:int):Number
		{
			CONFIG::debug
			{
				assert(elemStart == elem.getAbsoluteStart(), "bad elemStart passed to getLineLeading"); }
			var endPos:int = _absoluteStart + _textLength;
			var totalLeading:Number = 0;
			CONFIG::debug
			{
				assert(elem.getAncestorWithContainer() != null, "element with no container"); }
			for (;;)
			{
				// If there's only one element in the line, and it has 0 leading, try resetting the leading using the default algorithm. Important
				// for lines that contain only a float (which can otherwise recurse infinitely), and TCY spans in vertical text.
				var elemLeading:Number = elem.getEffectiveLineHeight(bp);
				if (!elemLeading && elem.textLength == this.textLength)
					elemLeading = TextLayoutFormat.lineHeightProperty.computeActualPropertyValue(elem.computedFormat.lineHeight, elem.computedFormat.fontSize * elem.computedFormat.yScale);
				totalLeading = Math.max(totalLeading, elemLeading);
				elemStart += elem.textLength;
				if (elemStart >= endPos)
					break;
				elem = elem.getNextLeaf(_para);
				CONFIG::debug
				{
					assert(elem != null, "bad nextLeaf"); }
				if (elem == null)
					break;
			}
			return totalLeading;
		}

		/** @private 
		 * Scan through the format runs within the line, and figure out what the typographic ascent (i.e. ascent relative to the 
		 * Roman baseline) for the overall line is. Normally it is the distance between the Roman and Ascent baselines, 
		 * but it may be adjusted upwards by the width/height of the GraphicElement.
		 */
		public function getLineTypographicAscent(elem:IFlowLeafElement, elemStart:int, textLine:ITextLine):Number
		{
			CONFIG::debug
			{
				assert(elemStart == elem.getAbsoluteStart(), "bad elemStart passed to getLineTypographicAscent"); }
			return TextLineUtil.getTextLineTypographicAscent(textLine ? textLine : getTextLine(), elem, elemStart, absoluteStart + textLength);
		}

		/** @private 
		 * Get the "line box" for the line as defined by the CSS visual formatting model (http://www.w3.org/TR/CSS2/visuren.html)
		 * Essentially, the union of all "inline boxes" on the line.
		 * @return A rectangle representing the line box. Top and Bottom are relative to the Roman baseline. Left and Right are ignored.
		 * May return null, for example, if the line only contains a float.
		 */
		public function getCSSLineBox(bp:String, elem:IFlowLeafElement, elemStart:int, swfContext:ISWFContext, effectiveListMarkerFormat:ITextLayoutFormat = null, numberLine:ITextLine = null):Rectangle
		{
			CONFIG::debug
			{
				assert(elem.getAncestorWithContainer() != null, "element with no container"); }
			CONFIG::debug
			{
				assert(elemStart == elem.getAbsoluteStart(), "bad elemStart passed to getCSSLineBox"); }

			var lineBox:Rectangle;

			var endPos:int = _absoluteStart + _textLength;
			var textLine:ITextLine = getTextLine();

			for (;;)
			{
				addToLineBox(elem.getCSSInlineBox(bp, textLine, _para, swfContext));

				elemStart += elem.textLength;
				if (elemStart >= endPos)
					break;

				elem = elem.getNextLeaf(_para);
				CONFIG::debug
				{
					assert(elem != null, "bad nextLeaf"); }
			}

			if (effectiveListMarkerFormat && numberLine)
			{
				// Para not available for number line, but the methods below handle null para correctly.
				var para:IParagraphElement = null;

				var ef:ElementFormat = GeometricElementUtils.computeElementFormatHelper(effectiveListMarkerFormat, para, swfContext);
				var metrics:FontMetrics = swfContext ? swfContext.callInContext(ef.getFontMetrics, ef, null, true) : ef.getFontMetrics();

				addToLineBox(GeometricElementUtils.getCSSInlineBoxHelper(effectiveListMarkerFormat, metrics, numberLine, para));
			}

			function addToLineBox(inlineBox:Rectangle):void
			{
				if (inlineBox)
					lineBox = lineBox ? lineBox.union(inlineBox) : inlineBox;
			}

			return lineBox;
		}

		// helper method to determine which subset of line is underlined
		// I believe this will be replaced by the eventSink mechanism
		// private function isTextlineSubsetOfSpan(element:FlowLeafElement): Boolean
		// {
		// var spanStart:int = element.getAbsoluteStart();
		// var spanEnd:int = spanStart + element.textLength;
		//
		// var lineStart:int = this.absoluteStart;
		// var lineEnd:int = this.absoluteStart + this._textLength;
		//
		// return spanStart <= lineStart && spanEnd >= lineEnd;
		// }
		// TODO remove reference to UIBase
		/**
		 *  Create a rectangle for selection
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		static private function createSelectionRect(selObj:ICompoundGraphic, color:uint, x:Number, y:Number, width:Number, height:Number):UIBase
		{
			// selObj.graphics.beginFill(color);
			selObj.fill = new SolidColor(color);
			// var cmds:Vector.<int> = new Vector.<int>();
			// var pathPoints:Vector.<Number> = new Vector.<Number>();

			var builder:PathBuilder = new PathBuilder(true);

			// set the start point - topLeft
			builder.moveTo(x, y);

			// line to topRight
			builder.lineTo(x + width, y);

			// line to botRight
			builder.lineTo(x + width, y + height);

			// line to botLeft
			builder.lineTo(x, y + height);

			// line to close the path - topLeft
			// Should auto-close in the ICompoundGraphic

			selObj.drawPathCommands(builder);

			return selObj as UIBase;
		}

		/** @private getSelectionShapesCacheEntry
		 * 
		 * creates and adds block selection(s) to the text container.  In most circumstances,
		 * this method will produce and add a single UIBase, but in certain circumstances,
		 * such as TCY in TTB text, will need to make multiple selection rectangles.
		 * 
		 * Examples:
		 * 1) horizontal - ABCDE
		 * 2) vertical - ABCDE
		 * 3) horizontal - ABcdE
		 * 4) vertical:		A
		 * 					B
		 * 				   cde
		 * 					F
		 * 
		 */
		private function getSelectionShapesCacheEntry(begIdx:int, endIdx:int, prevLine:ITextFlowLine, nextLine:ITextFlowLine, blockProgression:String):SelectionCache
		{
			if (isDamaged())
				return null;

			// 8-31-14 Do we need to adjust this for paras with multiple textBlocks?
			// get the absolute start of the paragraph.  Calculation is expensive, so just do this once.
			// var paraAbsStart:int = _para.getAbsoluteStart();
			var textLine:ITextLine = getTextLine();
			var paraAbsStart:int = _para.getTextBlockAbsoluteStart(textLine.textBlock);

			// if the indexes are identical and are equal to the start of the line, then
			// don't draw anything.  This prevents a bar being drawn on a following line when
			// selecting accross line boundaries
			// with exception for a selection that includes just the first character of an empty last line in the TextFlow
			if (begIdx == endIdx && paraAbsStart + begIdx == absoluteStart)
			{
				if (absoluteStart != _para.getTextFlow().textLength - 1)
					return null;
				endIdx++;
			}

			// the cached selection bounds and rects
			var selectionCache:SelectionCache = selectionBlockCache.get(this);
			if (selectionCache && selectionCache.begIdx == begIdx && selectionCache.endIdx == endIdx)
				return selectionCache;

			var drawRects:Array = new Array();
			// an array to store any tcy rectangles which need separate processing and may not exist
			var tcyDrawRects:Array = new Array();

			if (selectionCache == null)
			{
				selectionCache = new SelectionCache();
				selectionBlockCache.set(this,selectionCache);
			}
			else
			{
				selectionCache.clear();
			}
			selectionCache.begIdx = begIdx;
			selectionCache.endIdx = endIdx;

			var heightAndAdj:Array = getRomanSelectionHeightAndVerticalAdjustment(prevLine, nextLine);
			calculateSelectionBounds(textLine, drawRects, begIdx, endIdx, blockProgression, heightAndAdj);

			// iterate the blocks and create DisplayObjects to draw...
			for each (var drawRect:Rectangle in drawRects)
			{
				CONFIG::debug
				{
					assert(selectionCache != null, "If we're caching, selectionArray should never be null!"); }
				// we have to make new rectangles or the convertLineRectToGlobal will alter the cached ones!
				selectionCache.pushSelectionBlock(drawRect);
			}

			// allow the atoms to be garbage collected.
			// if (textLine) {
			// textLine.flushAtomData(); // Warning: Now does nothing
			// }

			return selectionCache;
		}

		/** @private - helper method to calculate all selection blocks within a line.
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ISubParagraphGroupElementBase
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IInlineGraphicElement
		 */
		public function calculateSelectionBounds(textLine:ITextLine, rectArray:Array, begIdx:int, endIdx:int, blockProgression:String, heightAndAdj:Array):void
		{
			// the direction of the text
			var direction:String = _para.computedFormat.direction;
			// get the absolute start of the paragraph.  Calculation is expensive, so just do this once.
			// var paraAbsStart:int = _para.getAbsoluteStart();
			var paraAbsStart:int = _para.getTextBlockAbsoluteStart(textLine.textBlock);
			// the current index.  used to iterate to the next element
			var curIdx:int = begIdx;
			// the current FlowLeafElement as determined by curIdx
			var curElem:IFlowLeafElement = null;
			// the highest glyph. Needed to normalize the rectangles we'll be building
			var largestRise:Number = 0;

			// blockRectArray holds each leaf's blocks which could be 1 or more
			var blockRectArray:Array = [];
			// floatRectArray holds the selection rects for any floats in the range.
			var floatRectArray:Array = null;
			// tcyDrawRects:Array
			var tcyDrawRects:Array = null;

			// do this loop and only afterwards perform the normalization and addition to the rectArr
			while (curIdx < endIdx)
			{
				curElem = _para.findLeaf(curIdx);
				// if we somehow got a 0 length element, then increment the index and continue
				if (curElem.textLength == 0)
				{
					++curIdx;
					continue;
				}
				else if (curElem is IInlineGraphicElement && (curElem as IInlineGraphicElement).computedFloat != Float.NONE)
				{
					if (floatRectArray == null)
						floatRectArray = [];

					var ilg:IInlineGraphicElement = curElem as IInlineGraphicElement;
					var floatInfo:FloatCompositionData = controller.getFloatAtPosition(paraAbsStart + curIdx);
					if (floatInfo)
					{
						var blockRect:Rectangle = new Rectangle(floatInfo.x - textLine.x, floatInfo.y - textLine.y, ilg.elementWidth, ilg.elementHeight);
						floatRectArray.push(blockRect);
					}
					++curIdx;
					continue;
				}
				// the number of potential glyphs to highlight. Could be larger than needed if we are only selecting part of it.
				var numCharsSelecting:int = curElem.textLength + curElem.getElementRelativeStart(_para) - curIdx;
				// special handling for TableLeafElements (do nothing)
				if (curElem is ITableLeafElement)
				{
					// if(floatRectArray == null)
					// floatRectArray = new Array();

					// var block:TextFlowTableBlock = TableElement(TableLeafElement(curElem).parent).getFirstBlock();
					// var blockRect:Rectangle = new Rectangle(floatInfo.x - textLine.x, floatInfo.y - textLine.y, ilg.elementWidth, ilg.elementHeight);
					// floatRectArray.push(new Rectangle(0,0,block.width,block.height));
					++curIdx;
					continue;
				}
				// the index of the last glyph to highlight. If a partial selection, use endIdx
				var endPos:int = (numCharsSelecting + curIdx) > endIdx ? endIdx : (numCharsSelecting + curIdx);

				// if this is not a TCY in vertical, the blocks should all be running in the same direction
				if (blockProgression != BlockProgression.RL || (textLine.getAtomTextRotation(textLine.getAtomIndexAtCharIndex(curIdx)) != TextRotation.ROTATE_0))
				{
					var leafBlockArray:Array = makeSelectionBlocks(textLine, curIdx, endPos, paraAbsStart, blockProgression, direction, heightAndAdj);
					// copy all the blocks into the blockRectArray - we'll normalize them later
					for (var leafBlockIter:int = 0; leafBlockIter < leafBlockArray.length; ++leafBlockIter)
					{
						blockRectArray.push(leafBlockArray[leafBlockIter]);
					}
				}
				else
				{
					var tcyBlock:IFlowElement = curElem.getParentByType("TCYElement");
					CONFIG::debug
					{
						assert(tcyBlock != null, "What kind of object is this that is ROTATE_0, but not TCY?");}

					// if this element is still encompassed by a SubParagraphGroupElementBase of some kind (either a link or a TCYBlock)
					// keep moving up to the parent.  Otherwise, the below code will go into an infinite loop.  bug 1905734
					var tcyParentRelativeEnd:int = tcyBlock.parentRelativeEnd;
					var subParBlock:ISubParagraphGroupElementBase = tcyBlock.getParentByType("SubParagraphGroupElementBase") as ISubParagraphGroupElementBase;
					while (subParBlock)
					{
						tcyParentRelativeEnd += subParBlock.parentRelativeStart;
						subParBlock = subParBlock.getParentByType("SubParagraphGroupElementBase") as ISubParagraphGroupElementBase;
					}

					var largestTCYRise:Number = 0;
					var lastTCYIdx:int = endIdx < tcyParentRelativeEnd ? endIdx : tcyParentRelativeEnd;
					var tcyRects:Array = new Array();

					while (curIdx < lastTCYIdx)
					{
						curElem = _para.findLeaf(curIdx);
						numCharsSelecting = curElem.textLength + curElem.getElementRelativeStart(_para) - curIdx;
						endPos = numCharsSelecting + curIdx > endIdx ? endIdx : numCharsSelecting + curIdx;
						var tcyRectArray:Array = makeSelectionBlocks(textLine, curIdx, endPos, paraAbsStart, blockProgression, direction, heightAndAdj);

						for (var tcyBlockIter:int = 0; tcyBlockIter < tcyRectArray.length; ++tcyBlockIter)
						{
							var tcyRect:Rectangle = tcyRectArray[tcyBlockIter];

							if (tcyRect.height > largestTCYRise)
							{
								largestTCYRise = tcyRect.height;
							}

							tcyRects.push(tcyRect);
						}
						curIdx = endPos;
					}

					if (!tcyDrawRects)
						tcyDrawRects = new Array();

					normalizeRects(tcyRects, tcyDrawRects, largestTCYRise, BlockProgression.TB, direction);
					continue;
				}

				// set the curIdx to the last char in the block
				curIdx = endPos;
			}

			// adding check for an empty set of draw rects.  If there are not recangles, skip this.
			// this can happen is there are ONLY TCY blocks and the whole line is selected.
			// Watson 2273832. - gak 02.09.09
			// if the whole line is selected
			if (blockRectArray.length > 0 && (paraAbsStart + begIdx) == absoluteStart && (paraAbsStart + endIdx) == (absoluteStart + textLength))
			{
				curElem = _para.findLeaf(begIdx);
				// if we have the entire line selected, but the first element is NOT the last, then
				// we will land up with a selection which is 1 character wider than it should be.
				if (((curElem.getAbsoluteStart() + curElem.textLength) < (absoluteStart + textLength)) && endPos >= 2)
				{
					// make sure that this is a white char and that we aren't deselecting the last
					// char in a line - esp important for scripts which don't use spaces ie Japanese
					var charCode:int = _para.getCharCodeAtPosition(endPos - 1);
					if (charCode != ElementConstants.kParagraphTerminator.charCodeAt(0) && CharacterUtil.isWhitespace(charCode))
					{
						var lastElemBlockArray:Array = makeSelectionBlocks(textLine, endPos - 1, endPos - 1, paraAbsStart, blockProgression, direction, heightAndAdj);
						var lastRect:Rectangle = lastElemBlockArray[lastElemBlockArray.length - 1];
						var modifyRect:Rectangle = blockRectArray[blockRectArray.length - 1] as Rectangle;

						if (blockProgression != BlockProgression.RL)
						{
							// if they have the same width, simply remove the last block
							if (modifyRect.width == lastRect.width)
							{
								blockRectArray.pop();
							}
							else
							{
								modifyRect.width -= lastRect.width;

								// if this is RTL, we need to shift the selection block over by the amount
								// we reduced it.
								if (direction == Direction.RTL)
									modifyRect.left -= lastRect.width;
							}
						}
						else
						{
							// if they have the same height, simply remove the last block
							if (modifyRect.height == lastRect.height)
							{
								blockRectArray.pop();
							}
							else
							{
								modifyRect.height -= lastRect.height;

								// if this is RTL, we need to shift the selection block down by the amount
								// we reduced it.
								if (direction == Direction.RTL)
									modifyRect.top += lastRect.height;
							}
						}
					}
				}
			}

			normalizeRects(blockRectArray, rectArray, largestRise, blockProgression, direction);
			// add in the TCY Rects
			if (tcyDrawRects && tcyDrawRects.length > 0)
			{
				for (var tcyIter:int = 0; tcyIter < tcyDrawRects.length; ++tcyIter)
				{
					rectArray.push(tcyDrawRects[tcyIter]);
				}
			}

			// float selections do not normalize, put them into the rect array now
			if (floatRectArray)
			{
				for (var floatIter:int = 0; floatIter < floatRectArray.length; ++floatIter)
				{
					rectArray.push(floatRectArray[floatIter]);
				}
			}
		}

		// TODO remove reference to UIBase
		private function createSelectionShapes(selObj:ICompoundGraphic, selFormat:SelectionFormat, container:IParentIUIBase, begIdx:int, endIdx:int, prevLine:ITextFlowLine, nextLine:ITextFlowLine):void
		{
			var contElement:IContainerFormattedElement = _para.getAncestorWithContainer();
			CONFIG::debug
			{
				assert(contElement != null, "para with no container"); }
			var blockProgression:String = contElement.computedFormat.blockProgression;

			var selCache:SelectionCache = getSelectionShapesCacheEntry(begIdx, endIdx, prevLine, nextLine, blockProgression);
			if (!selCache)
				return;

			// iterate the blocks and create DisplayObjects to draw...
			var drawRect:Rectangle;
			var color:uint = selFormat.rangeColor;

			if (_para && _para.getTextFlow())
			{
				var selMgr:ISelectionManager = _para.getTextFlow().interactionManager;
				if (selMgr && (selMgr.anchorPosition == selMgr.activePosition))
					color = selFormat.pointColor;
			}

			for each (drawRect in selCache.selectionBlocks)
			{
				drawRect = drawRect.clone();
				// if(blockProgression == BlockProgression.TB)
				// 	drawRect.y += nextLine.y - nextLine.ascent;
				// else
				// 	drawRect.x += nextLine.x - nextLine.ascent;//TODO does this make sense?
				convertLineRectToContainer(drawRect, true);
				createSelectionRect(selObj, color, drawRect.x, drawRect.y, drawRect.width, drawRect.height);
			}
		}

		/** @private 
		 * Get the height and vertical adjustment for the line's selection shape, assuming Western typographic rules
		 * where leading is included in selection.
		 * @return An array with two elements
		 * [0] height
		 * [1] vertical adjustment to counter 'align bottom' behavior. The remainder of the selection code assumes selection shape
		 * bottom is to be aligned with line descent. If this is not the case, vertical adjustment is set to an appropriate non-zero value. 
		 */
		public function getRomanSelectionHeightAndVerticalAdjustment(prevLine:ITextFlowLine, nextLine:ITextFlowLine):Array
		{
			var rectHeight:Number = 0;
			var verticalAdj:Number = 0; // Default to 'align bottom'.

			// This code erroneously assumed that it would only be called with a SPACE justifier and that AUTO would be up.  That is incorrect
			// because some scripts, like Korean, use an up leading model and the EAST_ASIAN justifier.  New code just performs the check
			if (LeadingUtils.useUpLeadingDirection(_para.getEffectiveLeadingModel()))
			{
				// "Space above, align bottom"
				// 1) Space above as dictated by first baseline offset for the first line or line leading otherwise (both obtained from the 'height' data member)
				// 2) Selection rectangle must at least include all of the text area
				rectHeight = Math.max(height, textHeight);

				// 3) Selection rectangle's bottom aligned with line descent; verticalAdj remains 0
			}
			else
			{
				// TODO-9/4/08-Is this the right way to check for first/last lines?
				var isFirstLine:Boolean = !prevLine || prevLine.controller != controller || prevLine.columnIndex != columnIndex;
				var isLastLine:Boolean = !nextLine || nextLine.controller != controller || nextLine.columnIndex != columnIndex || nextLine.paragraph.getEffectiveLeadingModel() == LeadingModel.ROMAN_UP;
				// I'm removing this line as it makes the assumption that AUTO leading dir is UP only for Roman text, which is incorrect.
				// Korean also uses UP leading but uses the EastAsian justifier. - gak 01.22.09
				// ||(nextLine.paragraph.computedFormat.leadingDirection == LeadingDirection.AUTO && nextLine.paragraph.computedFormat.justificationRule == JustificationRule.SPACE);

				if (isLastLine)
				{
					// There is no line after this one, or there is one which uses leading UP, so leading DOWN does not apply

					if (!isFirstLine)
					{
						// "Space above None, align bottom" (eqivalently, "Space below None, align top"):
						// 1) Only the text area should be selected
						rectHeight = textHeight;

						// 2) Selection rectangle's bottom aligned with line descent; verticalAdj remains 0
					}
					else
					{
						// "Space above, align bottom"
						// 1) Space above as dictated by first baseline offset
						// 2) Selection rectangle must at least include all of the text area
						rectHeight = Math.max(height, textHeight);
						// 3) Selection rectangle's bottom aligned with line descent; verticalAdj remains 0
					}
				}
				else
				{
					// There is a line after this one, so leading DOWN applies

					if (!isFirstLine)
					{
						// "Space below, align top"
						// 1) Space below as dictated by line leading (obtained from 'height' member of next line)
						// 2) Selection rectangle must at least include all of the text area
						rectHeight = Math.max(nextLine.height, textHeight);

						// 3) Selection rectangle's top to be aligned with line ascent, so its bottom to be at rectHeight - textLine.ascent,
						// not textLine.descent, set verticalAdj accordingly
						verticalAdj = rectHeight - textHeight; // same as rectHeight - textLine.ascent - textLine.descent
					}
					else
					{
						// Union of
						// 1) first line, leading up: In this case, rectangle height is the larger of line height and text height,
						// and the rectangle is shifted down by descent amount to align bottoms. So, top of rectangle is at:
						var top:Number = _descent - Math.max(height, textHeight);

						// 2) interior line, leading down: In this case, rectangle height is the larger of line leading and text height,
						// and the rectangle is shifted up by ascent amount to align tops. So, bottom of rectangle is at:
						var bottom:Number = Math.max(nextLine.height, textHeight) - _ascent;

						rectHeight = bottom - top;

						// 3) Selection rectangle's bottom to be at 'bottom', not the line's descent; set verticalAdj accordingly
						verticalAdj = bottom - _descent;
					}
				}
			}

			// If we don't have a line above us, then we need to pad the line a bit as well as make it shift up.
			// If we don't, then it overlaps the line below too much OR clips the top of the glyphs.
			if (!prevLine || prevLine.columnIndex != this.columnIndex || prevLine.controller != this.controller)
			{
				// make it taller - this is kinda a fudge, but we have no info to determine a good top.
				// if we don't do this, the selection rectangle will clip to the top of the glyphs and even
				// let parts stick out a bit.  So, re-add the descent and offset the rect by 50% so that
				// it appears to balance the top and bottom.
				rectHeight += this.descent;
				verticalAdj = Math.floor(this.descent / 2);
			}
			return [rectHeight, verticalAdj];
		}

		/** @private 
         * @suppress {uselessCode}
		 * 
		 * ? Get a list of rects of the characters in the given textline? Used to show selection? JF 
		 */
		private function makeSelectionBlocks(textLine:ITextLine, begIdx:int, endIdx:int, paraAbsStart:int, blockProgression:String, direction:String, heightAndAdj:Array):Array
		{
			CONFIG::debug
			{
				assert(begIdx <= endIdx, "Selection indexes are reversed!  How can this happen?!"); }

			var blockArray:Array = [];
			var blockRect:Rectangle = new Rectangle();
			var startElem:IFlowLeafElement = _para.findLeaf(begIdx);
			var startMetrics:Rectangle = startElem.getComputedFontMetrics().emBox;

			if (!textLine)
				textLine = getTextLine(true);

			// ++makeBlockPassCounter;
			// trace(makeBlockPassCounter + ") direction = " + direction + " blockProgression = " + blockProgression);

			// CNW: removed whole line optimization 5/18/10 - was yielding different results than code below and was no faster

			// trace(makeBlockPassCounter + ") begIdx = " + begIdx.toString() + " endIdx = " +  endIdx.toString());
			var begAtomIndex:int = textLine.getAtomIndexAtCharIndex(begIdx);
			var endAtomIndex:int = adjustEndElementForBidi(textLine, begIdx, endIdx, begAtomIndex, direction);

			// trace(makeBlockPassCounter + ") begAtomIndex = " + begAtomIndex.toString() + " endAtomIndex = " +  endAtomIndex.toString());
			CONFIG::debug
			{
				assert(begAtomIndex >= 0, "Invalid start index! begIdx = " + begIdx);}
			CONFIG::debug
			{
				assert(endAtomIndex >= 0, "Invalid end index! begIdx = " + endIdx);}

			if (direction == Direction.RTL && textLine.getAtomBidiLevel(endAtomIndex) % 2 != 0)
			{
				// if we are in RTL, anchoring the LTR text gets tricky.  Because the endElement is before the first
				// element - which is why we're in this code - the result can be a zero-width rectangle if the span of LTR
				// text breaks across line boundaries.  If that is the case, then the endAtomIndex value will be 0.  As
				// this is the less common case, assume that it isn't and make all other cases come first
				if (endAtomIndex == 0 && begIdx < endIdx - 1)
				{
					// since the endAtomIndex is 0, meaning that the LTR spans lines,
					// we want to grab the glyph before the endIdx which represents the last LTR glyph for the selection.
					// Make a recursive call into makeSelectionBlocks using and endIdx decremented by 1.
					blockArray = makeSelectionBlocks(textLine, begIdx, endIdx - 1, paraAbsStart, blockProgression, direction, heightAndAdj);
					var bidiBlock:Array = makeSelectionBlocks(textLine, endIdx - 1, endIdx - 1, paraAbsStart, blockProgression, direction, heightAndAdj);
					var bidiBlockIter:int = 0;
					while (bidiBlockIter < bidiBlock.length)
					{
						blockArray.push(bidiBlock[bidiBlockIter]);
						++bidiBlockIter;
					}
					return blockArray;
				}
			}

			var begIsBidi:Boolean = begAtomIndex != -1 ? isAtomBidi(textLine, begAtomIndex, direction) : false;
			var endIsBidi:Boolean = endAtomIndex != -1 ? isAtomBidi(textLine, endAtomIndex, direction) : false;

			if (begIsBidi || endIsBidi)
			{
				// this code needs to iterate over the glyphs starting at the begAtomIndex and going forward.
				// It doesn't matter is beg is bidi or not, we need to find a boundary, create a rect on it, then proceded.
				// use the value of begIsBidi for testing the consistency of the selection.

				// Example bidi text.  Note that the period comes at the left end of the line:
				//
				// Bidi state:		f f t t t t t	(true/false)
				// Element Index:0 1 2 3 4 5 6		(0 is the para terminator)
				// Chars:			. t o _ b e
				// Flow Index:	   6 0 1 2 3 4 (5) 	Note that these numbers represent the space between glyphs AND
				// 5(f)			that index 5 is both the space after the e and before the period.
				// but, the position 5 is not a valid cursor location.

				// the original code I implemented used the beg and endElement indexes however that fails because when the text
				// is mixed bidi/non-bidi, the indexes are only 1 char apart. This resulted in, for example, only the period in
				// a line getting selected when the text was bidi.   Instead, we're going to use the begIdx and endIdx and
				// recalculate the element indexes each time.  This is expensive, but I don't see an alternative. - gak 09.05.08
				var curIdx:int = begIdx;
				var incrementor:int = begIdx != endIdx ? 1 : 0;

				// the indexes used to draw the seleciton.  activeStart/End represent the
				// beginning of the selection shape atoms, while cur is the one we are testing.
				var activeStartIndex:int = begAtomIndex;
				var activeEndIndex:int = begAtomIndex;
				var curElementIndex:int = begAtomIndex;

				// when activeEndIsBidi no longer matches the bidi setting for the activeStartIndex, we will create the shape
				var activeEndIsBidi:Boolean = begIsBidi;

				do
				{
					// increment the index
					curIdx += incrementor;
					// get the next atom index
					curElementIndex = textLine.getAtomIndexAtCharIndex(curIdx);

					// calculate the bidi level for the - kinda cludgy, but if the bidi-text wraps, curElementIndex == -1
					// so just set it to false if this is the case.  It will get ignored in the subsequent check and curIdx
					// will == endIdx as this is the last glyph in the line - which is why the next is -1 - gak 09.12.08
					var curIsBidi:Boolean = (curElementIndex != -1) ? isAtomBidi(textLine, curElementIndex, direction) : false;

					if (curElementIndex != -1 && curIsBidi != activeEndIsBidi)
					{
						blockRect = makeBlock(textLine, curIdx, activeStartIndex, activeEndIndex, startMetrics, blockProgression, direction, heightAndAdj);
						blockArray.push(blockRect);

						// shift the activeStart/End indexes to the current
						activeStartIndex = curElementIndex;
						activeEndIndex = curElementIndex;
						// update the bidi setting
						activeEndIsBidi = curIsBidi;
					}
					else
					{
						// we don't get another chance to make a block, so if this is the last char, make the block before we bail out.
						// we have to check both equality and equality plus the incrementor because if we don't, then we'll miss a
						// character in the selection.
						if (curIdx == endIdx)
						{
							blockRect = makeBlock(textLine, curIdx, activeStartIndex, activeEndIndex, startMetrics, blockProgression, direction, heightAndAdj);
							blockArray.push(blockRect);
						}

						activeEndIndex = curElementIndex;
					}
				} while (curIdx < endIdx);
			}
			else
			{
				var testILG:IInlineGraphicElement = null;
				if (startElem is IInlineGraphicElement) // need this since skipAsCoercions is on
					startElem as IInlineGraphicElement;
				if (!testILG || testILG.effectiveFloat == Float.NONE || begIdx == endIdx)
				{
					blockRect = makeBlock(textLine, begIdx, begAtomIndex, endAtomIndex, startMetrics, blockProgression, direction, heightAndAdj);
					if (testILG && testILG.elementWidthWithMarginsAndPadding() != testILG.elementWidth)
					{	// Don't include margins or padding around inlines in the bounds
						var verticalText:Boolean = testILG.getTextFlow().computedFormat.blockProgression == BlockProgression.RL;
						var ilgFormat:ITextLayoutFormat = testILG.computedFormat;
						if (verticalText)
						{
							var paddingTop:Number = testILG.getEffectivePaddingTop();
							blockRect.top += paddingTop;	// don't include the left side indent in the selected area
							var paddingBottom:Number = testILG.getEffectivePaddingBottom();
							blockRect.bottom -= paddingBottom;
						}
						else
						{
							var paddingLeft:Number = testILG.getEffectivePaddingLeft();
							blockRect.left += paddingLeft;	// don't include the left side indent in the selected area
							var paddingRight:Number = testILG.getEffectivePaddingRight();
							blockRect.right -= paddingRight;
						}
					}
				}
				else
				{
					blockRect = BoundsUtil.getBounds(testILG.graphic, textLine);// testILG.graphic.getBounds(textLine);
				}

				blockArray.push(blockRect);
			}

			return blockArray;
		}

		/** @private 
		 * 
		 * ? Get the bounds of the supplied range of characters in the given textline? Used to show selection? JF 
		 */
		private function makeBlock(textLine:ITextLine, begTextIndex:int, begAtomIndex:int, endAtomIndex:int, startMetrics:Rectangle, blockProgression:String, direction:String, heightAndAdj:Array):Rectangle
		{
			var blockRect:Rectangle = new Rectangle();
			var globalStart:Point = new Point(0, 0);

			if (begAtomIndex > endAtomIndex)
			{
				// swap the start and end
				var tempEndIdx:int = endAtomIndex;
				endAtomIndex = begAtomIndex;
				begAtomIndex = tempEndIdx;
			}
			if (!textLine)
				textLine = getTextLine(true);

			// now that we have elements and they are in the right order for drawing, get their rectangles
			var begCharRect:Rectangle = textLine.getAtomBounds(begAtomIndex);
			// trace(makeBlockPassCounter + ") begCharRect = " + begCharRect.toString());

			var endCharRect:Rectangle = textLine.getAtomBounds(endAtomIndex);
			// trace(makeBlockPassCounter + ") endCharRect = " + endCharRect.toString());

			// Calculate the justificationRule value
			var justRule:String = _para.getEffectiveJustificationRule();
			// If this is TTB text and NOT TCY, as indicated by TextRotation.rotate0...
			if (blockProgression == BlockProgression.RL && textLine.getAtomTextRotation(begAtomIndex) != TextRotation.ROTATE_0)
			{
				globalStart.y = begCharRect.y;
				blockRect.height = begAtomIndex != endAtomIndex ? endCharRect.bottom - begCharRect.top : begCharRect.height;

				// re-ordered this code.  EAST_ASIAN is more common in vertical and should be the first option.
				if (justRule == JustificationRule.EAST_ASIAN)
				{
					blockRect.width = begCharRect.width;
				}
				else
				{
					blockRect.width = heightAndAdj[0];
					globalStart.x -= heightAndAdj[1];
				}
			}
			else
			{
				// given bidi text alternations, the endCharRect could be left of the begCharRect,
				// use whichever is farther left.
				globalStart.x = Math.min(begCharRect.x, endCharRect.x);
				// if we're here and the BlockProgression is TTB, then we're TCY.  Less frequent case, so make non-TCY
				// the first option...
				// NB - Never use baseline adjustments for TCY.  They don't make sense here.(I think) - gak 06.03.08
				if (blockProgression == BlockProgression.RL)
					globalStart.y = begCharRect.y + (startMetrics.width / 2); // TODO-9/5/8:Behavior for leading down TBD
				else// Harbs 6-13-17 Not sure how this used to work without this.
					globalStart.y = begCharRect.y;

				if (justRule != JustificationRule.EAST_ASIAN)
				{
					blockRect.height = heightAndAdj[0];
					if (blockProgression == BlockProgression.RL)
						globalStart.x -= heightAndAdj[1];
					else
						globalStart.y += heightAndAdj[1];
					// changed the width from a default of 2 to use the begCharRect.width so that point seletion
					// can choose to use the right or left side of the glyph when drawing a caret Watson 1876415/1876953- gak 08.19.09
					blockRect.width = begAtomIndex != endAtomIndex ? Math.abs(endCharRect.right - begCharRect.left) : begCharRect.width;
				}
				else
				{
					blockRect.height = begCharRect.height;

					// changed the width from a default of 2 to use the begCharRect.width so that point seletion
					// can choose to use the right or left side of the glyph when drawing a caret Watson 1876415/1876953- gak 08.19.09
					blockRect.width = begAtomIndex != endAtomIndex ? Math.abs(endCharRect.right - begCharRect.left) : begCharRect.width;
				}
			}

			blockRect.x = globalStart.x;
			blockRect.y = globalStart.y;
			if (blockProgression == BlockProgression.RL)
			{
				if (textLine.getAtomTextRotation(begAtomIndex) != TextRotation.ROTATE_0)
					blockRect.x -= textLine.descent;
				else // it's TCY
					blockRect.y -= (blockRect.height / 2);
			}
			else
			{
				blockRect.y += (textLine.descent - blockRect.height);
			}

			var tfl:ITextFlowLine = textLine.userData as ITextFlowLine;
			var curElem:IFlowLeafElement = _para.findLeaf(begTextIndex);
			var rotation:String;
			if (!curElem)
			{
				if (begTextIndex < 0)
					curElem = _para.getFirstLeaf();
				else if (begTextIndex >= _para.textLength)
					curElem = _para.getLastLeaf();
				rotation = curElem ? curElem.computedFormat.textRotation : TextRotation.ROTATE_0;
			}
			else
				rotation = curElem.computedFormat.textRotation;

			// handle rotation.  For horizontal text, rotations of 90 or 180 cause the text
			// to draw under the baseline in a cosistent location.  Vertical text is a bit more complicated
			// in that a 90 rotation puts it immediately to the left of the Em Box, whereas 180 is one quarter
			// of the way in the Em Box. Fix for Watson 1915930 - gak 02.17.09
			if (rotation == TextRotation.ROTATE_180 || rotation == TextRotation.ROTATE_90)
			{
				if (blockProgression != BlockProgression.RL)
					blockRect.y += (blockRect.height / 2);
				else
				{
					if (curElem.getParentByType("TCYElement") == null)
					{
						if (rotation == TextRotation.ROTATE_90)
							blockRect.x -= blockRect.width;
						else
							blockRect.x -= (blockRect.width * .75);
					}
					else
					{
						if (rotation == TextRotation.ROTATE_90)
							blockRect.y += blockRect.height;
						else
							blockRect.y += (blockRect.height * .75);
					}
				}
			}

			return blockRect;
		}

		/** @private
		 * 
		 * 
		 */
		public function convertLineRectToContainer(rect:Rectangle, constrainShape:Boolean):void
		{
			var textLine:ITextLine = getTextLine();

			/* var globalStart:Point = new Point(rect.x, rect.y);
			
			// convert to controller coordinates...
			// //trace(makeBlockPassCounter + ") globalStart = " + globalStart.toString());
			globalStart = textLine.localToGlobal(globalStart);
			// //trace(makeBlockPassCounter + ") localToGlobal.globalStart = " + globalStart.toString());
			globalStart = container.globalToLocal(globalStart);
			// //trace(makeBlockPassCounter + ") globalToLocal.globalStart = " + globalStart.toString());
			rect.x = globalStart.x;
			rect.y = globalStart.y; */

			// this is much simpler and actually more accurate - localToGlobal/globalToLocal does some rounding
			rect.x += textLine.x;
			rect.y += textLine.ascent; // += textLine.y; // baseline is 0 in flash.text.engine.TextLine;

			if (constrainShape)
			{
				var tf:ITextFlow = _para.getTextFlow();
				var columnRect:Rectangle = controller.columnState.getColumnAt(this.columnIndex);
				constrainRectToColumn(tf, rect, columnRect, controller.horizontalScrollPosition, controller.verticalScrollPosition, controller.compositionWidth, controller.compositionHeight);
			}
		}

		/** @private */
		static public function constrainRectToColumn(tf:ITextFlow, rect:Rectangle, columnRect:Rectangle, hScrollPos:Number, vScrollPos:Number, compositionWidth:Number, compositionHeight:Number):void
		{
			if (columnRect == null)
				return;
			if (tf.computedFormat.lineBreak == LineBreak.EXPLICIT)
				return;

			var bp:String = tf.computedFormat.blockProgression;
			var direction:String = tf.computedFormat.direction;

			if (bp == BlockProgression.TB && !isNaN(compositionWidth))
			{
				if (direction == Direction.LTR)
				{
					// make sure is doesn't go past the end of the container
					if (rect.left > (columnRect.x + columnRect.width + hScrollPos))
						rect.left = (columnRect.x + columnRect.width + hScrollPos);

					// make sure that if this is a selection and not a point selection, that
					// we don't go beyond the end of the container...
					if (rect.right > (columnRect.x + columnRect.width + hScrollPos))
						rect.right = (columnRect.x + columnRect.width + hScrollPos);
				}
				else
				{
					if (rect.right < (columnRect.x + hScrollPos))
						rect.right = (columnRect.x + hScrollPos);

					if (rect.left < (columnRect.x + hScrollPos))
						rect.left = (columnRect.x + hScrollPos);
				}
			}
			else if (bp == BlockProgression.RL && !isNaN(compositionHeight))
			{
				if (direction == Direction.LTR)
				{
					// make sure is doesn't go past the end of the container
					if (rect.top > (columnRect.y + columnRect.height + vScrollPos))
						rect.top = (columnRect.y + columnRect.height + vScrollPos);

					// make sure that if this is a selection and not a point selection, that
					// we don't go beyond the end of the container...
					if (rect.bottom > (columnRect.y + columnRect.height + vScrollPos))
						rect.bottom = (columnRect.y + columnRect.height + vScrollPos);
				}
				else
				{
					if (rect.bottom < (columnRect.y + vScrollPos))
						rect.bottom = (columnRect.y + vScrollPos);

					if (rect.top < (columnRect.y + vScrollPos))
						rect.top = (columnRect.y + vScrollPos);
				}
			}
		}

		// TODO remove reference to UIBase
		/** @private
		 * Helper method to hilight the portion of a block selection on this ITextLine.  A selection display is created and added to the line's TextFrame with ContainerController addSelectionShape.
		 * @param begIdx absolute index of start of selection on this line.
		 * @param endIdx absolute index of end of selection on this line.
		 */
		public function hiliteBlockSelection(selObj:ICompoundGraphic, selFormat:SelectionFormat, container:IParentIUIBase, begIdx:int, endIdx:int, prevLine:ITextFlowLine, nextLine:ITextFlowLine):void
		{
			// no container for overflow lines, or lines scrolled out
			if (isDamaged() || !_controller)
				return;

			var textLine:ITextLine = peekTextLine();
			if (!textLine || !textLine.parent)
				return;

			var paraStart:int = _para.getTextBlockAbsoluteStart(textLine.textBlock);
			begIdx -= paraStart;
			endIdx -= paraStart;

			createSelectionShapes(selObj, selFormat, container, begIdx, endIdx, prevLine, nextLine);
		}

		// TODO remove reference to UIBase
		/** @private
		 * Helper method to hilight a point selection on this ITextLine.  x,y,w,h of the selection are calculated and ContainerController.drawPointSelection is called 
		 * @param idx absolute index of the point selection.
		 */
		public function hilitePointSelection(selFormat:SelectionFormat, idx:int, container:IParentIUIBase, prevLine:ITextFlowLine, nextLine:ITextFlowLine):void
		{
			var rect:Rectangle = computePointSelectionRectangle(idx, container, prevLine, nextLine, true);
			if (rect)
				_controller.drawPointSelection(selFormat, rect.x, rect.y, rect.width, rect.height);
		}

		static private function setRectangleValues(rect:Rectangle, x:Number, y:Number, width:Number, height:Number):void
		{
			rect.x = x;
			rect.y = y;
			rect.width = width;
			rect.height = height;
		}

		static private var _localZeroPoint:Point;
		static private function get localZeroPoint():Point{
			if(_localZeroPoint == null)
				_localZeroPoint = new Point(0, 0);
			
			return _localZeroPoint;
		}
		static private var _localOnePoint:Point;
		static private function get localOnePoint():Point{
			if(_localOnePoint == null)
				_localOnePoint = new Point(1, 0);
			
			return _localOnePoint;
		}
		static private var _rlLocalOnePoint:Point;
		static private function get rlLocalOnePoint():Point{
			if(_rlLocalOnePoint == null)
				_rlLocalOnePoint = new Point(0, 1);
			
			return _rlLocalOnePoint;
		}

		// TODO generalize this so we're not relying on UIBase
		/** @private */
		public function computePointSelectionRectangle(idx:int, container:IParentIUIBase, prevLine:ITextFlowLine, nextLine:ITextFlowLine, constrainSelRect:Boolean):Rectangle
		{
			if (isDamaged() || !_controller)
				return null;

			// no container for overflow lines, or lines scrolled out
			var textLine:ITextLine = peekTextLine();
			if (!textLine || !textLine.parent)
				return null;
			// adjust to this paragraph's ITextBlock
			// I'm assuming this needs to be relative to the ITextBlock and not the paragraph -- Harbs
			idx -= _para.getTextBlockAbsoluteStart(textLine.textBlock);
			// idx -= _para.getAbsoluteStart();

			textLine = getTextLine(true);

			// endIdx will only differ if idx is altered when detecting TCY bounds
			var endIdx:int = idx;
			var elementIndex:int = textLine.getAtomIndexAtCharIndex(idx);
			CONFIG::debug
			{
				assert(elementIndex != -1, "Invalid point selection index! idx = " + idx); }

			var isTCYBounds:Boolean = false;
			var paraLeadingTCY:Boolean = false;

			var contElement:IContainerFormattedElement = _para.getAncestorWithContainer();
			CONFIG::debug
			{
				assert(contElement != null, "para with no container"); }
			var blockProgression:String = contElement.computedFormat.blockProgression;
			var direction:String = _para.computedFormat.direction;

			// need to check for TCY.  TCY cannot take input into it's head, but can in it's tail.
			if (blockProgression == BlockProgression.RL)
			{
				if (idx == 0)
				{
					if (textLine.getAtomTextRotation(0) == TextRotation.ROTATE_0)
						paraLeadingTCY = true;
				}
				else
				{
					var prevElementIndex:int = textLine.getAtomIndexAtCharIndex(idx - 1);
					if (prevElementIndex != -1)
					{
						// if this elem is TCY, then we need to back up one space and use the right bounds
						if (textLine.getAtomTextRotation(elementIndex) == TextRotation.ROTATE_0 && textLine.getAtomTextRotation(prevElementIndex) != TextRotation.ROTATE_0)
						{
							elementIndex = prevElementIndex;
							--idx;
							isTCYBounds = true;
						}
						else if (textLine.getAtomTextRotation(prevElementIndex) == TextRotation.ROTATE_0)
						{
							elementIndex = prevElementIndex;
							--idx;
							isTCYBounds = true;
						}
					}
				}
			}

			var heightAndAdj:Array = getRomanSelectionHeightAndVerticalAdjustment(prevLine, nextLine);
			var blockRectArray:Array = makeSelectionBlocks(textLine, idx, endIdx, _para.getTextBlockAbsoluteStart(textLine.textBlock), blockProgression, direction, heightAndAdj);
			CONFIG::debug
			{
				assert(blockRectArray.length == 1, "A point selection should return a single selection rectangle!"); }
			var rect:Rectangle = blockRectArray[0];

			convertLineRectToContainer(rect, constrainSelRect);

			var drawOnRight:Boolean = (direction == Direction.RTL);

			if ((drawOnRight && textLine.getAtomBidiLevel(elementIndex) % 2 == 0) || (!drawOnRight && textLine.getAtomBidiLevel(elementIndex) % 2 != 0))
			{
				drawOnRight = !drawOnRight;
			}

			// compute a width so that cursor is visually one pixel wide independent of scaling
			var zeroPoint:Point = PointUtils.localToGlobal(localZeroPoint, container);// container.localToGlobal(localZeroPoint);
			var cursorWidth:Number;

			if (blockProgression == BlockProgression.RL && textLine.getAtomTextRotation(elementIndex) != TextRotation.ROTATE_0)
			{
				var rlOnePoint:Point = PointUtils.localToGlobal(rlLocalOnePoint, container);// container.localToGlobal(rlLocalOnePoint);
				cursorWidth = zeroPoint.y - rlOnePoint.y;
				cursorWidth = cursorWidth == 0 ? 1 : Math.abs(1.0 / cursorWidth);
				// trace(zeroPoint,onePoint,cursorSize);
				if (!drawOnRight)
					setRectangleValues(rect, rect.x, !isTCYBounds ? rect.y : rect.y + rect.height, rect.width, cursorWidth);
				else
					setRectangleValues(rect, rect.x, !isTCYBounds ? rect.y + rect.height : rect.y, rect.width, cursorWidth);
			}
			else
			{
				var onePoint:Point = PointUtils.localToGlobal(localOnePoint, container);// container.localToGlobal(localOnePoint);
				cursorWidth = zeroPoint.x - onePoint.x;
				cursorWidth = cursorWidth == 0 ? 1 : Math.abs(1.0 / cursorWidth);
				// trace(zeroPoint,onePoint,cursorSize);
				// choose to use the right or left side of the glyph based on Direction when drawing a caret Watson 1876415/1876953
				// if the direction is ltr, then the cursor should be on the left side
				if (!drawOnRight)
					setRectangleValues(rect, !isTCYBounds ? rect.x : rect.x + rect.width, rect.y, cursorWidth, rect.height);
				else // otherwise, it should be on the right, unless it is TCY
					setRectangleValues(rect, !isTCYBounds ? rect.x + rect.width : rect.x, rect.y, cursorWidth, rect.height);
			}

			// allow the atoms to be garbage collected.
			// textLine.flushAtomData(); // Warning: Now does nothing

			return rect;
		}

		/** @private
		 * Three states.  Disjoint(0), Intersects(1), HeightContainedIn(2),  
		 */
		public function selectionWillIntersectScrollRect(scrollRect:Rectangle, begIdx:int, endIdx:int, prevLine:ITextFlowLine, nextLine:ITextFlowLine):int
		{
			var contElement:IContainerFormattedElement = _para.getAncestorWithContainer();
			CONFIG::debug
			{
				assert(contElement != null, "para with no container"); }
			var blockProgression:String = contElement.computedFormat.blockProgression;
			var textLine:ITextLine = getTextLine(true);

			if (begIdx == endIdx)
			{
				var pointSelRect:Rectangle = computePointSelectionRectangle(begIdx, UIBase(controller.container), prevLine, nextLine, false);
				if (pointSelRect)
				{
					if (scrollRect.containsRect(pointSelRect))
						return 2;
					if (scrollRect.intersects(pointSelRect))
						return 1;
				}
			}
			else
			{
				var paraStart:int;
				// 8-31-14 Assuming this should be from the textBlock. Keeping getAbsoluteStart() in case there's no textLine -- not sure if that's needed
				if (textLine)
					paraStart = _para.getTextBlockAbsoluteStart(textLine.textBlock);
				else
					paraStart = _para.getAbsoluteStart();
				var selCache:SelectionCache = this.getSelectionShapesCacheEntry(begIdx - paraStart, endIdx - paraStart, prevLine, nextLine, blockProgression);
				if (selCache)
				{
					// iterate the blocks and check for intersections
					var drawRect:Rectangle;
					for each (drawRect in selCache.selectionBlocks)
					{
						drawRect = drawRect.clone();
						// convertLineRectToContainer(container, drawRect);
						drawRect.x += textLine.x;
						drawRect.y += textLine.y;
						if (scrollRect.intersects(drawRect))
						{
							if (blockProgression == BlockProgression.RL)
							{
								// see if width is entirely contained in scrollRect
								if (drawRect.left >= scrollRect.left && drawRect.right <= scrollRect.right)
									return 2;
							}
							else
							{
								if (drawRect.top >= scrollRect.top && drawRect.bottom <= scrollRect.bottom)
									return 2;
							}
							return 1;
						}
					}
				}
			}
			return 0;
		}
		/** @private */
		CONFIG::debug
		private static function dumpAttribute(result:String, attributeName:String, attributeValue:Object):String
		{
			if (attributeValue)
			{
				result += " ";
				result += attributeName;
				result += "=\"";
				result += attributeValue.toString();
				result += "\"";
			}
			return result;
		}

		/** @private
		 */
		private function normalizeRects(srcRects:Array, dstRects:Array, largestRise:Number, blockProgression:String, direction:String):void
		{
			// the last rectangle in the list with a potential to merge
			var lastRect:Rectangle = null;
			var rectIter:int = 0;
			while (rectIter < srcRects.length)
			{
				// get the current rect and advance the iterator
				var rect:Rectangle = srcRects[rectIter++];

				// apply a new height if needed.
				if (blockProgression == BlockProgression.RL)
				{
					if (rect.width < largestRise)
					{
						rect.width = largestRise;
					}
				}
				else
				{
					if (rect.height < largestRise)
					{
						rect.height = largestRise;
					}
				}
				// if the lastRect is null, no need to perform calculation
				if (lastRect == null)
				{
					lastRect = rect;
				}
				else
				{
					// TCY has already been excluded, so no need to worry about it here...
					if (blockProgression == BlockProgression.RL)
					{
						// trace(normalCounter + ") lastRect = " + lastRect.toString());
						// trace(normalCounter + ") rect = " + rect.toString());

						// merge it in to the last rect
						if (lastRect.y < rect.y && (lastRect.y + lastRect.height) >= rect.top && lastRect.x == rect.x)
						{
							lastRect.height += rect.height;
						}
						else if (rect.y < lastRect.y && lastRect.y <= rect.bottom && lastRect.x == rect.x)
						{
							lastRect.height += rect.height;
							lastRect.y = rect.y;
						}
						else
						{
							// we have a break in the rectangles and should push last rect onto the draw list before continuing
							dstRects.push(lastRect);
							lastRect = rect;
						}
					}
					else
					{
						if (lastRect.x < rect.x && (lastRect.x + lastRect.width) >= rect.left && lastRect.y == rect.y)
						{
							lastRect.width += rect.width;
						}
						else if (rect.x < lastRect.x && lastRect.x <= rect.right && lastRect.y == rect.y)
						{
							lastRect.width += rect.width;
							lastRect.x = rect.x;
						}
						else
						{
							// we have a break in the rectangles and should push last rect onto the draw list before continuing
							dstRects.push(lastRect);
							lastRect = rect;
						}
					}
				}
				// if this is the last rectangle, we haven't added it, do so now.
				if (rectIter == srcRects.length)
					dstRects.push(lastRect);
			}
		}

		/** @private */
		private function adjustEndElementForBidi(textLine:ITextLine, begIdx:int, endIdx:int, begAtomIndex:int, direction:String):int
		{
			var endAtomIndex:int = begAtomIndex;

			if (endIdx != begIdx)
			{
				if (((direction == Direction.LTR && textLine.getAtomBidiLevel(begAtomIndex) % 2 != 0) || (direction == Direction.RTL && textLine.getAtomBidiLevel(begAtomIndex) % 2 == 0)) && textLine.getAtomTextRotation(begAtomIndex) != TextRotation.ROTATE_0)
					endAtomIndex = textLine.getAtomIndexAtCharIndex(endIdx);
				else
				{
					endAtomIndex = textLine.getAtomIndexAtCharIndex(endIdx - 1);
				}
			}

			if (endAtomIndex == -1 && endIdx > 0)
			{
				return adjustEndElementForBidi(textLine, begIdx, endIdx - 1, begAtomIndex, direction);
			}
			return endAtomIndex;
		}

		/** @private */
		private function isAtomBidi(textLine:ITextLine, elementIdx:int, direction:String):Boolean
		{
			if (!textLine)
				textLine = getTextLine(true);

			return (textLine.getAtomBidiLevel(elementIdx) % 2 != 0 && direction == Direction.LTR) || (textLine.getAtomBidiLevel(elementIdx) % 2 == 0 && direction == Direction.RTL);
		}

		/** @private */
		public function get adornCount():int
		{
			return _adornCount;
		}
		/** @private */
		CONFIG::debug
		public function dumpToXML():String
		{
			var result:String = new String("<line");

			result = dumpAttribute(result, "absoluteStart", absoluteStart);
			result = dumpAttribute(result, "textLength", textLength);
			result = dumpAttribute(result, "height", height);
			result = dumpAttribute(result, "spaceBefore", spaceBefore);

			result = dumpAttribute(result, "spaceAfter", spaceAfter);
			result = dumpAttribute(result, "location", location);
			result = dumpAttribute(result, "x", x);
			result = dumpAttribute(result, "y", y);
			result = dumpAttribute(result, "targetWidth", targetWidth);
			result = dumpAttribute(result, "lineOffset", _lineOffset);
			result += ">\n";

			var textLine:ITextLine = getTextLine(true);

			result += "<ITextBlock>";
			result += textLine.textBlock.dump();
			result += "</ITextBlock>";
			result += "<ITextLine>";
			result += textLine.dump();
			result += "</ITextLine>";

			result += "</line>";
			return result;
		}
	};
}

import org.apache.royale.geom.Rectangle;


/** @private - I would have defined this as tlf_internal, but that is not an option, so
 * making it private.
 * 
 * The SelectionCache is a structure designed to hold a few key data points needed to quickly
 * reconstruct a selection on a line:
 * 
 * a) the beginning and end indicies of the selection on the line
 * b) the regular selection rectangles
 * c) the irregular selection rectangles, such as TCY selection rects in vertical text
 * 
 **/
final class SelectionCache
{
	private var _begIdx:int = -1;
	private var _endIdx:int = -1;
	private var _selectionBlocks:Array = null;

	public function SelectionCache()
	{
	}

	public function get begIdx():int
	{
		return _begIdx;
	}

	public function set begIdx(val:int):void
	{
		_begIdx = val;
	}

	public function get endIdx():int
	{
		return _endIdx;
	}

	public function set endIdx(val:int):void
	{
		_endIdx = val;
	}

	public function pushSelectionBlock(drawRect:Rectangle):void
	{
		if (!_selectionBlocks)
			_selectionBlocks = new Array();

		_selectionBlocks.push(drawRect.clone());
	}

	public function get selectionBlocks():Array
	{
		return _selectionBlocks;
	}

	public function clear():void
	{
		_selectionBlocks = null;
		_begIdx = -1;
		_endIdx = -1;
	}
}
