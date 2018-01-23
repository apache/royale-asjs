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
	import org.apache.royale.textLayout.compose.IFlowComposer;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ISubParagraphGroupElementBase;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.formats.Category;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;
	import org.apache.royale.textLayout.property.PropertyUtil;

	/**
	 * The ElementRange class represents the range of objects selected within a text flow.
	 * 
	 * <p>The beginning elements 
	 * (such as <code>firstLeaf</code>) are always less than or equal to the end elements (in this case, <code>lastLeaf</code>)
	 * for each pair of values in an element range.</p>
	 * 
	 * @see org.apache.royale.textLayout.elements.TextFlow
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public class ElementRange
	{
		private var _absoluteStart:int;
		private var _absoluteEnd:int;
		private var _firstLeaf:IFlowLeafElement;
		private var _lastLeaf:IFlowLeafElement;
		private var _firstParagraph:IParagraphElement;
		private var _lastParagraph:IParagraphElement;
		private var _textFlow:ITextFlow;

		/** 
		 * The absolute text position of the IFlowLeafElement object that contains the start of the range.
		 *  
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get absoluteStart():int
		{
			return _absoluteStart;
		}

		public function set absoluteStart(value:int):void
		{
			_absoluteStart = value;
		}

		/** 
		 * The absolute text position of the IFlowLeafElement object that contains the end of the range. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get absoluteEnd():int
		{
			return _absoluteEnd;
		}

		public function set absoluteEnd(value:int):void
		{
			_absoluteEnd = value;
		}

		/** 
		 * The IFlowLeafElement object that contains the start of the range. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get firstLeaf():IFlowLeafElement
		{
			return _firstLeaf;
		}

		public function set firstLeaf(value:IFlowLeafElement):void
		{
			_firstLeaf = value;
		}

		/** 
		 * The IFlowLeafElement object that contains the end of the range. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get lastLeaf():IFlowLeafElement
		{
			return _lastLeaf;
		}

		public function set lastLeaf(value:IFlowLeafElement):void
		{
			_lastLeaf = value;
		}

		/** 
		 * The IParagraphElement object that contains the start of the range. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get firstParagraph():IParagraphElement
		{
			return _firstParagraph;
		}

		public function set firstParagraph(value:IParagraphElement):void
		{
			_firstParagraph = value;
		}

		/** 
		 * The IParagraphElement object that contains the end of the range. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get lastParagraph():IParagraphElement
		{
			return _lastParagraph;
		}

		public function set lastParagraph(value:IParagraphElement):void
		{
			_lastParagraph = value;
		}

		/** 
		 * The TextFlow object that contains the range. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get textFlow():ITextFlow
		{
			return _textFlow;
		}

		public function set textFlow(value:ITextFlow):void
		{
			_textFlow = value;
		}
		// This constructor function is here just to silence a compile warning in Eclipse. There
		// appears to be no way to turn the warning off selectively.
		/** @private */
		CONFIG::debug
		public function ElementRange()
		{
			super();
		}

		// NOTE: We've been back and forth on this - should a range selection show null attributes or beginning of range attributes?
		// After looking at this for a while I want it to show beginning of range attributes.  Two main reasons
		// 1. If the range contains different objects but homogoneous settings we should show the attributes.
		// 2. If we show null attributes on a range selection there's no way to, for example, turn BOLD off.
		// Try this at home - restore the old code. Select the entire text.  Turn Bold on.  Can't turn bold off.
		// Please don't revert this without further discussion.
		// Ideally we would have a way of figuring out which attributes are homogoneous over the selection range
		// and which were not and showing, for example, a "half-checked" bold item.  We'd have to work this out for all the properties.
		// OLD CODE that shows null attribute settings on a range selection
		// var charAttr:ICharacterFormat = selRange.begElem == selRange.endElem ? selRange.begElem.computedCharacterFormat : new CharacterFormat();
		// var paraAttr:IParagraphFormat = selRange.begPara == selRange.endPara ? selRange.begPara.computedParagraphFormat : new ParagraphFormat();
		/** 
		 * The format attributes of the container displaying the range. 
		 * 
		 * <p>If the range spans more than one container, the format of the first container is returned.</p>
		 *  
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get containerFormat():ITextLayoutFormat
		{
			// see NOTE above before changing!!
			var container:IContainerController;
			var flowComposer:IFlowComposer = _textFlow.flowComposer;
			if (flowComposer)
			{
				var idx:int = flowComposer.findControllerIndexAtPosition(absoluteStart);
				if (idx != -1)
					container = flowComposer.getControllerAt(idx);
			}
			return container ? container.computedFormat : _textFlow.computedFormat;
		}

		/** 
		 * The format attributes of the paragraph containing the range. 
		 * 
		 * <p>If the range spans more than one paragraph, the format of the first paragraph is returned.</p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get paragraphFormat():ITextLayoutFormat
		{
			// see NOTE above before changing!!
			return firstParagraph.computedFormat;
		}

		/** 
		 * The format attributes of the characters in the range. 
		 * 
		 * <p>If the range spans more than one FlowElement object, which means that more than one
		 * character format may exist within the range, the format of the first FlowElement object is returned.</p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get characterFormat():ITextLayoutFormat
		{
			// see NOTE above before changing!!
			return firstLeaf.computedFormat;
		}

		/**
		 * Gets the character format attributes that are common to all characters in the text range or current selection.
		 * 
		 * <p>Format attributes that do not have the same value for all characters in the element range are set to 
		 * <code>null</code> in the returned TextLayoutFormat instance.</p>
		 * 
		 * @return The common character style settings
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function getCommonCharacterFormat():TextLayoutFormat
		{
			var leaf:IFlowLeafElement = firstLeaf;
			var attr:TextLayoutFormat = new TextLayoutFormat(leaf.computedFormat);

			for (;;)
			{
				if (leaf == lastLeaf)
					break;
				leaf = leaf.getNextLeaf();
				attr.removeClashing(leaf.computedFormat);
			}

			return PropertyUtil.extractInCategory(TextLayoutFormat, TextLayoutFormat.description, attr, Category.CHARACTER, false) as TextLayoutFormat;
		}

		/**
		 * Gets the paragraph format attributes that are common to all paragraphs in the element range.
		 * 
		 * <p>Format attributes that do not have the same value for all paragraphs in the element range are set to 
		 * <code>null</code> in the returned TextLayoutFormat instance.</p>
		 * 	 
		 * @return The common paragraph style settings
		 * 
		 * @see org.apache.royale.textLayout.edit.ISelectionManager#getCommonParagraphFormat
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function getCommonParagraphFormat():TextLayoutFormat
		{
			var para:IParagraphElement = firstParagraph;
			var attr:TextLayoutFormat = new TextLayoutFormat(para.computedFormat);
			for (;;)
			{
				if (para == lastParagraph)
					break;
				para = _textFlow.findAbsoluteParagraph(para.getAbsoluteStart() + para.textLength);
				attr.removeClashing(para.computedFormat);
			}
			return PropertyUtil.extractInCategory(TextLayoutFormat, TextLayoutFormat.description, attr, Category.PARAGRAPH, false) as TextLayoutFormat;
		}

		/**
		 * Gets the container format attributes that are common to all containers in the element range.
		 * 
		 * <p>Format attributes that do not have the same value for all containers in the element range are set to 
		 * <code>null</code> in the returned TextLayoutFormat instance.</p>
		 * 	 
		 * @return The common paragraph style settings
		 * 
		 * @see org.apache.royale.textLayout.edit.ISelectionManager#getCommonParagraphFormat	 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function getCommonContainerFormat():TextLayoutFormat
		{
			var flowComposer:IFlowComposer = _textFlow.flowComposer;
			if (!flowComposer)
				return null;

			var index:int = flowComposer.findControllerIndexAtPosition(this.absoluteStart);
			if (index == -1)
				return null;
			var controller:IContainerController = flowComposer.getControllerAt(index);
			var attr:TextLayoutFormat = new TextLayoutFormat(controller.computedFormat);
			while (controller.absoluteStart + controller.textLength < absoluteEnd)
			{
				index++;
				if (index == flowComposer.numControllers)
					break;
				controller = flowComposer.getControllerAt(index);
				attr.removeClashing(controller.computedFormat);
			}

			return PropertyUtil.extractInCategory(TextLayoutFormat, TextLayoutFormat.description, attr, Category.CONTAINER, false) as TextLayoutFormat;
		}

		/** 
		 * Creates an ElementRange object.
		 * 
		 * @param textFlow	the text flow
		 * @param beginIndex absolute text position of the first character in the text range
		 * @param endIndex one beyond the absolute text position of the last character in the text range
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		static public function createElementRange(textFlow:ITextFlow, absoluteStart:int, absoluteEnd:int):ElementRange
		{
			var rslt:ElementRange = new ElementRange();
			if (absoluteStart == absoluteEnd)
			{
				rslt.absoluteStart = rslt.absoluteEnd = absoluteStart;
				rslt.firstLeaf = textFlow.findLeaf(rslt.absoluteStart);
				rslt.firstParagraph = rslt.firstLeaf.getParagraph();
				// rslt.begContainer = rslt.endContainer = selState.textFlow.findAbsoluteContainer(rslt.begElemIdx);
				adjustForLeanLeft(rslt);
				rslt.lastLeaf = rslt.firstLeaf;
				rslt.lastParagraph = rslt.firstParagraph;
			}
			else
			{
				// order the selection points
				if (absoluteStart < absoluteEnd)
				{
					rslt.absoluteStart = absoluteStart;
					rslt.absoluteEnd = absoluteEnd;
				}
				else
				{
					rslt.absoluteStart = absoluteEnd;
					rslt.absoluteEnd = absoluteStart;
				}
				rslt.firstLeaf = textFlow.findLeaf(rslt.absoluteStart);
				rslt.lastLeaf = textFlow.findLeaf(rslt.absoluteEnd);
				// back up one element if the end of the selection is the start of an element
				// otherwise a block selection of a span looks like it includes discreet selection ranges
				if (((rslt.lastLeaf == null) && (rslt.absoluteEnd == textFlow.textLength)) || (rslt.absoluteEnd == rslt.lastLeaf.getAbsoluteStart()))
					rslt.lastLeaf = textFlow.findLeaf(rslt.absoluteEnd - 1);

				rslt.firstParagraph = rslt.firstLeaf.getParagraph();
				rslt.lastParagraph = rslt.lastLeaf.getParagraph();

				// rslt.begContainer = selState.textFlow.findAbsoluteContainer(rslt.begElemIdx);
				// rslt.endContainer = selState.textFlow.findAbsoluteContainer(rslt.endElemIdx);
				// if (rslt.endElemIdx == rslt.endContainer.relativeStart)
				// rslt.endContainer = rslt.endContainer.preventextContainer;

				// if the end of the range includes the next to last character in a paragraph
				// expand it to include the paragraph teriminate character
				if (rslt.absoluteEnd == rslt.lastParagraph.getAbsoluteStart() + rslt.lastParagraph.textLength - 1)
				{
					rslt.absoluteEnd++;
					rslt.lastLeaf = rslt.lastParagraph.getLastLeaf();
				}
			}
			rslt.textFlow = textFlow;

			return rslt;
		}

		static private function adjustForLeanLeft(rslt:ElementRange):void
		{
			// If we're at the start of a leaf element, look to the previous leaf element and see if it shares the same
			// parent. If so, we're going to move the selection to the end of the previous element so it takes on
			// the formatting of the character to the left. We don't want to do this if the previous element is in
			// a different character, across link or tcy boundaries, etc.
			if (rslt.firstLeaf.getAbsoluteStart() == rslt.absoluteStart)
			{
				var previousNode:IFlowLeafElement = rslt.firstLeaf.getPreviousLeaf(rslt.firstParagraph);
				if (previousNode && previousNode.getParagraph() == rslt.firstLeaf.getParagraph())
				{
					if ((!(previousNode.parent is ISubParagraphGroupElementBase) || (previousNode.parent as ISubParagraphGroupElementBase).acceptTextAfter()) && (!(rslt.firstLeaf.parent is ISubParagraphGroupElementBase) || previousNode.parent === rslt.firstLeaf.parent))
						rslt.firstLeaf = previousNode;
				}
			}
		}
	}
}
