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
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.factory.ITLFFactory;
	import org.apache.royale.textLayout.factory.TLFFactory;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	
	public class ElementHelper
	{
		static public function normalizeContainerFormatRange(container:IContainerFormattedElement):void
		{
			// is this an absolutely element?
			if (container.numChildren == 0)
			{
				var p:IParagraphElement = ElementHelper.getParagraph();
				if (container.canOwnFlowElement(p))
				{
					p.replaceChildren(0,0,ElementHelper.getSpan());
					container.replaceChildren(0,0,p);	
					CONFIG::debug { assert(container.textLength == 1,"bad textlength"); }
					p.normalizeRange(0,p.textLength);	
				}
			}	
		}
		static public function normalizeSubParagraphRange(range:ISubParagraphGroupElementBase):void
		{
						// empty subparagraphgroups not allowed after normalize
			if (range.numChildren == 0 && range.parent != null)
			{
				var s:SpanElement = new SpanElement();
				range.replaceChildren(0,0,s);
				s.normalizeRange(0,s.textLength);
			}
			
		}


		public static function getDefaultTextFlow(factory:ITLFFactory=null):ITextFlow
		{
			if(!factory)
				factory = TLFFactory.defaultTLFFactory;
			return new TextFlow(factory);
		}
		public static function getTerminator(para:IParagraphElement,newLeaf:IFlowElement):ISpanElement
		{
			var s:SpanElement = new SpanElement();
			s.format = newLeaf ? newLeaf.format : para.terminatorSpan.format;
			s.addParaTerminator();
			return s;
		}
		public static function getList():IListElement
		{
			return new ListElement();
		}
		public static function getListItem():IListItemElement
		{
			return new ListItemElement();
		}
		public static function getParagraph():IParagraphElement
		{
			var p:IParagraphElement = new ParagraphElement();
			p.replaceChildren(0, 0, new SpanElement());
			p.normalizeRange(0, p.textLength);
			return p;
		}
		public static function getSpan():ISpanElement
		{
			return new SpanElement();
		}
		public static function getLink():ILinkElement
		{
			return new LinkElement();
		}
		public static function getTCY():ITCYElement
		{
			return new TCYElement();
		}
		public static function getInline():IInlineGraphicElement
		{
			return new InlineGraphicElement();
		}
		public static function getTableCell():ITableCellElement
		{
			return new TableCellElement();
		}
		public static function getTableRow(format:ITextLayoutFormat=null):ITableRowElement
		{
			return new TableRowElement(format);
		}
		public static function getSpanText(children:Array):String
		{
			var str:String = "";
			var len:int = children.length;
			for(var i:int=0;i<len;i++)
			{
				var elem:Object = children[i];
				if (elem is String)
					str += elem as String;
				else if (elem is Number)	// TODO: remove the Number else if when we can test with the most recent compilers.  The [RichTextContent] metadata fixes the issue
					str += elem.toString();
				else if (elem is BreakElement)
					str += String.fromCharCode(0x2028);
				else if (elem is TabElement)
				{
					// Add a placeholder (from Unicode private use area) instead of '\t' because the latter is 
					// stripped during white space collapse. After white space collapse, we will change the placeholder
					// to '\t' 
					str += String.fromCharCode(0xE000);
				}	
				else if (elem != null)
					throw new TypeError(GlobalSettings.resourceStringFunction("badMXMLChildrenArgument",[ getQualifiedClassName(elem) ]));	// NO PMD
					
			}
			return str;
		}
	}
}
