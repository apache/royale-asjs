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
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.text.engine.ContentElement;
	import org.apache.royale.text.engine.ElementFormat;
	import org.apache.royale.text.engine.FontMetrics;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.text.engine.TextElement;
	import org.apache.royale.textLayout.compose.ISWFContext;
	import org.apache.royale.textLayout.debug.Debugging;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.utils.GeometricElementUtils;
	import org.apache.royale.textLayout.events.FlowElementEventDispatcher;
	import org.apache.royale.textLayout.events.ModelChange;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;

	/** Base class for FlowElements that appear at the lowest level of the flow hierarchy. FlowLeafElement objects have
	 * no children and include InlineGraphicElement objects and SpanElement objects.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 * @see InlineGraphicElement
	 * @see SpanElement
	 */
	public class FlowLeafElement extends FlowElement implements IFlowLeafElement
	{
		/** Holds the content of the leaf @private */
		protected var _blockElement:ContentElement;
		/** @private
		 * Holds the text for the leaf element - unless there's a valid blockElement, 
		 * in which case the text is in the rawText field of the blockElement.
		 */
		protected var _text:String;	// holds the text property if the blockElement is null
		private var _hasAttachedListeners:Boolean;	// true if FTE eventMirror may be in use
		/** @private The event dispatcher that acts as an event mirror */
		public var _eventMirror:FlowElementEventDispatcher = null;

		/** 
		 * Base class - invoking new FlowLeafElement() throws an error exception. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 */
		public function FlowLeafElement()
		{
			_hasAttachedListeners = false;
			super();
		}

		override public function get className():String
		{
			return "FlowLeafElement";
		}

		// TODO this should not be here!
		public function set text(value:String):void
		{
			// do nothing
		}

		/** @private */
		override public function createContentElement():void
		{
			CONFIG::debug
			{
				assert(_blockElement != null, "_blockElement not allocated in derived class"); }
			if (_computedFormat)
			{
				_blockElement.elementFormat = computeElementFormat();
				CONFIG::debug
				{
					Debugging.traceFTEAssign(_blockElement, "elementFormat", _blockElement.elementFormat); }
			}
			if (parent)
				parent.insertBlockElement(this, _blockElement);
		}

		/** @private */
		override public function releaseContentElement():void
		{
			_blockElement = null;
			_computedFormat = null;
		}

		// private function blockElementExists():Boolean
		// {
		// return _blockElement != null;
		// }
		/** @private */
		public function getBlockElement():ContentElement
		{
			if (!_blockElement)
				createContentElement();
			return _blockElement;
		}

		/** @private
		 * Gets the EventDispatcher associated with this FlowElement.  Use the functions
		 * of EventDispatcher such as <code>setEventHandler()</code> and <code>removeEventHandler()</code> 
		 * to capture events that happen over this FlowLeafElement object.  The
		 * event handler that you specify will be called after this FlowElement object does
		 * the processing it needs to do.
		 * 
		 * Note that the event dispatcher will only dispatch FlowElementMouseEvent events.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.events.EventDispatcher
		 * @see org.apache.royale.textLayout.events.FlowElementMouseEvent
		 */
		public override function getEventMirror():IEventDispatcher
		{
			if (!_eventMirror)
				_eventMirror = new FlowElementEventDispatcher(this);
			return _eventMirror;
		}

		/** @private
		 * Checks whether an event dispatcher is attached, and if so, if the event dispatcher
		 * has any active listeners.
		 */
		public override function hasActiveEventMirror():Boolean
		{
			return _eventMirror && (_eventMirror._listenerCount != 0);
		}

		/** @private This is done so that the TextContainerManager can discover EventMirrors in a TextFlow. */
		public override function appendElementsForDelayedUpdate(tf:ITextFlow, changeType:String):void
		{
			if (changeType == ModelChange.ELEMENT_ADDED)
			{
				if (this.hasActiveEventMirror())
				{
					tf.incInteractiveObjectCount();
					getParagraph().incInteractiveChildrenCount() ;
				}
			}
			else if (changeType == ModelChange.ELEMENT_REMOVAL)
			{
				if (this.hasActiveEventMirror())
				{
					tf.decInteractiveObjectCount();
					getParagraph().decInteractiveChildrenCount() ;
				}
			}
			super.appendElementsForDelayedUpdate(tf, changeType);
		}

		/**
		 * The text associated with the FlowLeafElement:
		 * <p><ul>
		 * <li>The value for SpanElement subclass will be one character less than <code>textLength</code> if this is the last span in a ParagraphELement.</li>
		 * <li>The value for BreakElement subclass is a U+2028</li>
		 * <li>The value for TabElement subclass is a tab</li>
		 * <li>The value for InlineGraphicElement subclass is U+FDEF</li>
		 * </ul></p>
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.textLayout.elements.SpanElement#replaceText()
		 */
		public function get text():String
		{
			return _text;
		}

		/** @private */
		public function getElementFormat():ElementFormat
		{
			if (!_blockElement)
				createContentElement();
			return _blockElement.elementFormat;
		}

		/** @private */
		public override function setParentAndRelativeStart(newParent:IFlowGroupElement, newStart:int):void
		{
			if (newParent == parent)
				return;

			var hasBlock:Boolean = _blockElement != null;

			if (_blockElement && parent && parent.hasBlockElement())	// remove textElement from the parent content
				parent.removeBlockElement(this, _blockElement);
			if (newParent && !newParent.hasBlockElement() && _blockElement)
				newParent.createContentElement();

			super.setParentAndRelativeStart(newParent, newStart);

			// Update the FTE ContentElement structure. If the parent has FTE elements, then create FTE elements for the leaf node
			// if it doesn't already have them, and add them in. If the parent does not have FTE elements, release the leaf's FTE
			// elements also so they match.
			if (parent)
			{
				if (parent.hasBlockElement())
				{
					if (!_blockElement)
						createContentElement();
					else if (hasBlock)	// don't do this if the _blockElement was constructed as side-effect of setParentAndRelativeStart; in that case, it's already attached
						parent.insertBlockElement(this, _blockElement);
				}
				else if (_blockElement)
					releaseContentElement();
			}
		}

		/** @private Only used by SpanElement.splitAtPosition */
		public function quickInitializeForSplit(sibling:FlowLeafElement, newSpanLength:int, newSpanTextElement:TextElement):void
		{
			setTextLength(newSpanLength);
			_blockElement = newSpanTextElement;
			if (_blockElement)
				_text = _blockElement.text;
			quickCloneTextLayoutFormat(sibling);
			var tf:ITextFlow = sibling.getTextFlow();
			if (tf == null || tf.formatResolver == null)
			{
				_computedFormat = sibling._computedFormat;
				if (_blockElement)
					_blockElement.elementFormat = sibling.getElementFormat();
			}
		}

		/**
		 * Returns the next FlowLeafElement object.  
		 * 
		 * @param limitElement	Specifies FlowGroupElement on whose last leaf to stop looking. A value of null (default) 
		 * 	means search till no more elements.
		 * @return 	next FlowLeafElement or null if at the end
		 *
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */
		public function getNextLeaf(limitElement:IFlowGroupElement = null):IFlowLeafElement
		{
			if (!parent)
				return null;
			return parent.getNextLeafHelper(limitElement, this);
		}

		/**
		 * Returns the previous FlowLeafElement object.  
		 * 
		 * @param limitElement	Specifies the FlowGroupElement on whose first leaf to stop looking.   null (default) means search till no more elements.
		 * @return 	previous leafElement or null if at the end
		 *
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */
		public function getPreviousLeaf(limitElement:IFlowGroupElement = null):IFlowLeafElement
		{
			if (!parent)
				return null;
			return parent.getPreviousLeafHelper(limitElement, this);
		}

		/** @private */
		public override function getCharAtPosition(relativePosition:int):String
		{
			return _text ? _text.charAt(relativePosition) : "";
		}

		/** @private */
		public override function normalizeRange(normalizeStart:uint, normalizeEnd:uint):void
		{
			// this does the cascade - potential optimization to skip it if the _blockElement isn't attached
			if (_blockElement)
				calculateComputedFormat();
		}

		/** Returns the FontMetrics object for the span. The properties of the FontMetrics object describe the 
		 * emBox, strikethrough position, strikethrough thickness, underline position, 
		 * and underline thickness for the specified font. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.text.engine.FontMetrics
		 * @see org.apache.royale.text.engine.ElementFormat#getFontMetrics()
		 *
		 * @return font metrics associated with the span
		 */
		public function getComputedFontMetrics():FontMetrics
		{
			if (!_blockElement)
				createContentElement();
			if (!_blockElement)
				return null;
			var ef:ElementFormat = _blockElement.elementFormat;
			if (!ef)
				return null;

			var tf:ITextFlow = getTextFlow();
			if (tf && tf.flowComposer && tf.flowComposer.swfContext)
				return tf.flowComposer.swfContext.callInContext(ef.getFontMetrics, ef, null, true);
			COMPILE::SWF
			{
				return ef.getFontMetrics();
			}
			COMPILE::JS
			{
				var metrics:FontMetrics = ef.getFontMetrics();
				metrics.underlineOffset *= ef.fontSize * ef.yScale;
				metrics.underlineThickness *= ef.fontSize * ef.yScale;
				metrics.strikethroughOffset *= ef.fontSize * ef.yScale;
				metrics.strikethroughThickness *= ef.fontSize * ef.yScale;
				return metrics;
			}
		}

		/** @private */
		public function computeElementFormat():ElementFormat
		{
			CONFIG::debug
			{
				assert(_computedFormat != null, "bad call to computeElementFormat"); }

			var tf:ITextFlow = getTextFlow();
			return GeometricElementUtils.computeElementFormatHelper(_computedFormat, getParagraph(), tf && tf.flowComposer ? tf.flowComposer.swfContext : null);
		}

		/** 
		 * The computed text format attributes that are in effect for this element.
		 * Takes into account the inheritance of attributes.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.textLayout.formats.ITextLayoutFormat
		 */
		public override function get computedFormat():ITextLayoutFormat
		{
			if (!_computedFormat)
			{
				_computedFormat = doComputeTextLayoutFormat();

				if (_blockElement)
				{
					_blockElement.elementFormat = computeElementFormat();
					CONFIG::debug
					{
						Debugging.traceFTEAssign(_blockElement, "elementFormat", _blockElement.elementFormat); }
				}
			}
			return _computedFormat;
		}

		/** Returns the calculated lineHeight from this element's properties.  @private */
		public function getEffectiveLineHeight(blockProgression:String):Number
		{
			// ignore the leading on a TCY Block. If the element is in a TCYBlock, it has no leading
			if (blockProgression == BlockProgression.RL && (parent.className == "TCYElement"))
				return 0;
			CONFIG::debug
			{
				assert(_computedFormat != null, "Missing _computedFormat in FlowLeafElement.getEffectiveLineHeight"); }
			return TextLayoutFormat.lineHeightProperty.computeActualPropertyValue(computedFormat.lineHeight, getEffectiveFontSize());
		}

		/** @private 
		 * Get the "inline box" for the element as defined by the CSS visual formatting model (http://www.w3.org/TR/CSS2/visuren.html)
		 * @param	blockProgression	Block progression
		 * @param	textLine			The containing text line
		 * @param	para				The containing para. Only used for resolving AUTO dominantBaseline value. 
		 * 								May be null, in which case the AUTO dominantBaseline value is resolved based on other attributes (such as the element's computed locale). 	
		 * @param	swfContext			The SWF context in which certain method calls (such as the one used to get font metrics) are made
		 * 								May be null in which case the current SWF context is used.
		 * @return 						Null if the element is not "inline"
		 * 								Otherwise, a rectangle representing the inline box. Top and Bottom are relative to the line's Roman baseline. Left and Right are ignored.
		 */
		public function getCSSInlineBox(blockProgression:String, textLine:ITextLine, para:IParagraphElement = null, swfContext:ISWFContext = null):Rectangle
		{
			// TODO-9/27/10: TCYs typically don't affect leading, but this may not be appropriate for LeadingModel.BOX
			if (blockProgression == BlockProgression.RL && (parent.className == "TCYElement"))
				return null;

			return GeometricElementUtils.getCSSInlineBoxHelper(computedFormat, getComputedFontMetrics(), textLine, para);
		}

		/** Returns the fontSize from this element's properties.
		 * We multiply by yScale because the important dimension of the font size is the vertical size.
		 * @private */
		public function getEffectiveFontSize():Number
		{
			return Number(computedFormat.fontSize * computedFormat.yScale);
		}
		/** @private */
		CONFIG::debug
		public override function debugCheckFlowElement(depth:int = 0, extraData:String = ""):int
		{
			// debugging function that asserts if the flow element tree is in an invalid state

			var rslt:int = super.debugCheckFlowElement(depth, " fte:" + getDebugIdentity(_blockElement) + " " + extraData);

			// TODO: eventually these tests will be valid for InlineGraphicElement elements as well
			if (!(IFlowLeafElement is InlineGraphicElement))
			{
				rslt += assert(textLength != 0 || bindableElement || (parent is ISubParagraphGroupElementBase && parent.numChildren == 1), "FlowLeafElement with zero textLength must be deleted");
				rslt += assert(parent is IParagraphElement || parent is ISubParagraphGroupElementBase, "FlowLeafElement must have a ParagraphElement or SubParagraphGroupElementBase parent");
			}
			return rslt;
		}
	}
}
