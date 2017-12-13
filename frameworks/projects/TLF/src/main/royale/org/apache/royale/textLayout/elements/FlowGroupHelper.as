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
	import org.apache.royale.reflection.getQualifiedClassName;
	
	public class FlowGroupHelper
	{
		public static function setMxmlChildren(group:IFlowGroupElement,array:Array):void
		{
						/* NOTE: all FlowElement implementers and overrides of mxmlChildren must specify [RichTextContent] metadata */

			// remove all existing children
			group.replaceChildren(0,group.numChildren);
			
			// In the text model, non-ParagraphFormattedElements (i.e. spans, images, links, TCY) cannot be children of a ContainerFormattedElement (TextFlow, IDivElement etc.)
			// They can only be children of paragraphs or subparagraph blocks. 
			// In XML, however, <p> elements can be implied (for example, a <span> may appear as a direct child of <flow>).  
			// So, while parsing the XML, if we enounter a non-ParagraphFormattedElement child of a ContainerFormattedElement 
			// 1. an explicitly created paragraph is used as the parent instead
			// 2. such explicitly created paragraphs are shared by adjacent flow elements provided there isn't an intervening ParagraphFormattedElement
			var effectiveParent:IFlowGroupElement = group; 
			
			// append them on the end		
			for each (var child:Object in array)
			{
				if (child is IFlowElement)
				{
					if (child is IParagraphFormattedElement)
					{
						// Reset due to possibly intervening FlowParagrpahElement; See note 2. above
						effectiveParent = group; 
					}
					else if (effectiveParent is IContainerFormattedElement)
					{
						// See note 1. above
						effectiveParent = ElementHelper.getParagraph();	// NO PMD
						effectiveParent.impliedElement = true;
						group.replaceChildren(group.numChildren, group.numChildren, effectiveParent);
					}
					if ( (child is ISpanElement) || (child is ISubParagraphGroupElementBase))
						child.bindableElement = true;
					effectiveParent.replaceChildren(effectiveParent.numChildren, effectiveParent.numChildren, IFlowElement(child) );
				}
				else if (child is String)
				{
					var s:ISpanElement = ElementHelper.getSpan();	// NO PMD
					s.text = String(child);
					s.bindableElement = true;
					s.impliedElement = true;
					
					if (effectiveParent is IContainerFormattedElement)
					{
						// See note 1. above
	 					effectiveParent = ElementHelper.getParagraph();	// No PMD
						group.replaceChildren(group.numChildren, group.numChildren, effectiveParent);
						effectiveParent.impliedElement = true;
					}
					effectiveParent.replaceChildren(effectiveParent.numChildren, effectiveParent.numChildren, s);
				}
				else if (child != null)
					throw new TypeError(GlobalSettings.resourceStringFunction("badMXMLChildrenArgument",[ getQualifiedClassName(child) ]));	// NO PMD
			}
		}
		public static function getText(group:IFlowGroupElement,text:String,relativeStart:int=0, relativeEnd:int=-1, paragraphSeparator:String="\n"):String{
			if (relativeEnd == -1 || relativeEnd >group. textLength)
				relativeEnd = group.textLength;
			
			if (relativeStart < 0)
				relativeStart = 0;
				
			var pos:int = relativeStart;
			for (var idx:int = group.findChildIndexAtPosition(relativeStart); idx >= 0 && idx < group.numChildren && pos < relativeEnd; idx++)
			{
				var child:IFlowElement = group.getChildAt(idx);
				var copyStart:int = pos - child.parentRelativeStart;
				var copyEnd:int = Math.min(relativeEnd - child.parentRelativeStart, child.textLength);
				text += child.getText(copyStart, copyEnd, paragraphSeparator);
				pos += copyEnd - copyStart;
				if (paragraphSeparator && child is IParagraphFormattedElement && pos < relativeEnd)
					text += paragraphSeparator;
			}
			return text;
			
		}
	}
}
