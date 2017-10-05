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
package org.apache.royale.textLayout.compose.utils
{
	import org.apache.royale.textLayout.utils.NumberFactoryUtil;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.compose.ISWFContext;
	import org.apache.royale.textLayout.compose.SWFContext;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.ILinkElement;
	import org.apache.royale.textLayout.elements.IListElement;
	import org.apache.royale.textLayout.elements.IListItemElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.LinkState;
	import org.apache.royale.textLayout.factory.INumberLineFactory;
	import org.apache.royale.textLayout.formats.Direction;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.IListMarkerFormat;
	import org.apache.royale.textLayout.formats.ListStylePosition;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;

	public class NumberlineUtil
	{
		static private var numberLineFactory:INumberLineFactory;

		/**
		*
		* @private Logic to generate and position the ITextLine containing the numbering for a listElement's first line 
		* @royaleignorecoercion org.apache.royale.textLayout.elements.ILinkElement
		* @royaleignorecoercion org.apache.royale.textLayout.elements.IListElement
		 */
		static public function createNumberLine(listItemElement:IListItemElement, curParaElement:IParagraphElement, swfContext:ISWFContext, totalStartIndent:Number):ITextLine
		{
			CONFIG::debug
			{
				assert(swfContext != SWFContext.globalSWFContext, "TextFlowLine.createNumberLine: don't pass globalswfcontext"); }
			if (numberLineFactory == null)
			{
				numberLineFactory = NumberFactoryUtil.getNumberFactory();
				numberLineFactory.compositionBounds = new Rectangle(0, 0, NaN, NaN);
			}
			numberLineFactory.swfContext = swfContext;

			var listMarkerFormat:IListMarkerFormat = listItemElement.computedListMarkerFormat();

			// use the listStylePosition on the ListItem (not the list)
			numberLineFactory.listStylePosition = listItemElement.computedFormat.listStylePosition;

			var listElement:IListElement = listItemElement.parent as IListElement;
			var paragraphFormat:TextLayoutFormat = new TextLayoutFormat(curParaElement.computedFormat);
			var boxStartIndent:Number = paragraphFormat.direction == Direction.LTR ? listElement.getEffectivePaddingLeft() + listElement.getEffectiveBorderLeftWidth() + listElement.getEffectiveMarginLeft() : listElement.getEffectivePaddingRight() + listElement.getEffectiveBorderRightWidth() + listElement.getEffectiveMarginRight();
			// this just gets the first line but that's the only one we use.  could have used paragraphStartIndent or padding/margins.
			// do it this way so that negative indents are supported.  TODO revisit when box model work is complete
			paragraphFormat.apply(listMarkerFormat);
			// Fix bug 2800975 ListMarkerFormat.paragraphStartIndent not applied properly in Inside lists.
			paragraphFormat.textIndent += totalStartIndent;
			if (numberLineFactory.listStylePosition == ListStylePosition.OUTSIDE)
				paragraphFormat.textIndent -= boxStartIndent;
			numberLineFactory.paragraphFormat = paragraphFormat; // curParaElement.computedFormat;
			numberLineFactory.textFlowFormat = curParaElement.getTextFlow().computedFormat;

			// suppress the formatting of any links
			var firstLeaf:IFlowLeafElement = curParaElement.getFirstLeaf();
			var parentLink:ILinkElement = firstLeaf.getParentByType("LinkElement") as ILinkElement;
			// record the topmost parent link
			var highestParentLinkLinkElement:ILinkElement;
			var linkStateArray:Array = [];
			while (parentLink)
			{
				highestParentLinkLinkElement = parentLink;
				linkStateArray.push(parentLink.linkState);
				parentLink.chgLinkState(LinkState.SUPPRESSED);
				parentLink = parentLink.getParentByType("LinkElement") as ILinkElement;
			}

			// spanFormat to use for the markers
			var spanFormat:TextLayoutFormat = new TextLayoutFormat(firstLeaf.computedFormat);

			// now restore the formatting of any links
			parentLink = firstLeaf.getParentByType("LinkElement") as ILinkElement;
			while (parentLink)
			{
				linkStateArray.push(parentLink.linkState);
				parentLink.chgLinkState(linkStateArray.shift());
				parentLink = parentLink.getParentByType("LinkElement") as ILinkElement;
			}

			// forces recompute of computedFormat of all leaf nodes of highestParentLinkLinkElement
			if (highestParentLinkLinkElement)
			{
				var leaf:IFlowLeafElement = highestParentLinkLinkElement.getFirstLeaf();
				while (leaf)
				{
					leaf.calculateComputedFormat();
					leaf = leaf.getNextLeaf(highestParentLinkLinkElement);
				}
			}

			// finalize the spanFormat for the marker
			var markerFormat:TextLayoutFormat = new TextLayoutFormat(spanFormat);
			TextLayoutFormat.resetModifiedNoninheritedStyles(markerFormat);
			var holderStyles:Object = (listMarkerFormat as TextLayoutFormat).getStyles();
			for (var key:String in holderStyles)
			{
				// only copy TextLayoutFormat properties
				if (TextLayoutFormat.description[key] !== undefined)
				{
					var val:* = holderStyles[key];
					markerFormat[key] = (val !== FormatValue.INHERIT) ? val : spanFormat[key];
				}
			}
			numberLineFactory.markerFormat = markerFormat;
			numberLineFactory.text = listElement.computeListItemText(listItemElement, listMarkerFormat);

			// expect one or zero lines - technically with beforeContent and afterContent more than one line can be generated.  This could be more like a float!!
			// also need to expect a backgroundColor
			var rslt:Array = [];
			numberLineFactory.createTextLines(function(o:UIBase):void
			{
				rslt.push(o);
			});

//TODO make sure this works
			// position it relative to the parent line - later need to take inside/outside into account
			var numberLine:ITextLine = rslt[0] as ITextLine;
			if (numberLine)
			{
				CONFIG::debug
				{
					assert(numberLine.validity == "static", "Invalid validity on numberLine"); }
				// TODO deal with mouseEnabled and mouseChildren
				// numberLine.mouseEnabled = false;
				// numberLine.mouseChildren = false;
				TextLineUtil.setNumberLineBackground(numberLine, numberLineFactory.backgroundManager);
			}
			numberLineFactory.clearBackgroundManager();

			return numberLine;
		}
		
	}
}
