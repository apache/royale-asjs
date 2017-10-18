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
package org.apache.royale.textLayout.elements {
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.IListMarkerFormat;

	

	
	/** 
	 * <p> ListItemElement is an item in a list. It most commonly contains one or more ParagraphElement objects, but could
	 * also have children of type DivElement or ListElement. A ListItemElement always appears within a ListElement.</p>
	 *
	 * <p>A ListItemElement has automatically generated content that appears before the regular content of the list. This is called
	 * the <i>marker</i>, and it is what visually distinguishes the list item. The listStyleType property governs how the marker
	 * is generated and allows the user to control whether the list item is marked with a bullet, a number, or alphabetically.
	 * The listStylePosition governs where the marker appears relative to the list item; specifically it may appear outside, in the 
	 * margin of the list, or inside, beside the list item itself. The ListMarkerFormat defines the TextLayoutFormat of the marker
	 * (by default this will be the same as the list item), as well as an optional suffix that goes at the end of the marker. For 
	 * instance, for a numbered list, it is common to have a "." as a suffix that appears after the number. The ListMarkerFormat also
	 * allows specification of text that goes at the start of the marker, and for numbered lists allows control over the numbering.</p>
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 * @see ParagraphElement
	 * @see org.apache.royale.textLayout.formats.ITextLayoutFormat#listStyleType
	 * @see org.apache.royale.textLayout.formats.ITextLayoutFormat#listStylePosition
	 * @see org.apache.royale.textLayout.formats.ListMarkerFormat
	 */
	public final class ListItemElement extends ContainerFormattedElement implements IListItemElement
	{	
		private const MAX_VALUE:int = 2147483647;
		/** @private Helps figure out the list number.  Use MAX_VALUE when not set */
		public var _listNumberHint:int = MAX_VALUE;
		
		/** @private */
		override protected function get abstract():Boolean
		{ return false; }
		
		/** @private */
		public override function get defaultTypeName():String
		{ return "li"; }
		
		override public function get className():String{
			return "ListItemElement";
		}

		/** @private - make more efficient? save and damage results as need be */
		public function computedListMarkerFormat():IListMarkerFormat
		{
			var format:IListMarkerFormat = this.getUserStyleWorker("ListMarkerFormat") as IListMarkerFormat;
			if (format == null)
			{
				var tf:ITextFlow = this.getTextFlow();
				if (tf)
					format = tf.configuration.defaultListMarkerFormat;
			}

			return format;
		}
		
		/**
		 *  @private ListItems must begin with zero or more divs with a paragraph
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public function normalizeNeedsInitialParagraph():Boolean
		{
			var p:IFlowGroupElement = this;
			while (p)
			{
				p = p.getChildAt(0) as IFlowGroupElement;
				if (p is IParagraphElement)
					return false;
				if (!(p is IDivElement))
					return true;
			}
			return true;
		}
		
		/** @private */
		public override function normalizeRange(normalizeStart:uint,normalizeEnd:uint):void
		{
			super.normalizeRange(normalizeStart,normalizeEnd);
			
			_listNumberHint = MAX_VALUE;
			
			// A listItem must have a Paragraph at the start. 
			// note not all browsers behave this way.
			if (normalizeNeedsInitialParagraph())
			{
				var p:IParagraphElement = ElementHelper.getParagraph();
				replaceChildren(0,0,p);	
				p.normalizeRange(0,p.textLength);	
			}
		}
		
		/** @private */
		public function getListItemNumber(listMarkerFormat:IListMarkerFormat = null):int
		{
			CONFIG::debug { assert(parent != null,"invalid call to ListItemElement.getListItemNumber"); }
			
			if (_listNumberHint == MAX_VALUE)
			{
				if (listMarkerFormat == null)
					listMarkerFormat = 	computedListMarkerFormat();
				
				var counterReset:Object = listMarkerFormat.counterReset;
					
				if (counterReset && counterReset.hasOwnProperty("ordered"))
					_listNumberHint = counterReset.ordered;
				else
				{
					// search backwards for a ListItemElement and call getListItemNumber on it
					var idx:int = parent.getChildIndex(this);
					
					_listNumberHint = 0;	// if none is found this is zero
								
					while (idx > 0)
					{
						idx--;
						var sibling:ListItemElement = parent.getChildAt(idx) as ListItemElement;
						if (sibling)
						{
							_listNumberHint = sibling.getListItemNumber();
							break;
						}
					}
				}
				
				// increment the counter
				var counterIncrement:Object = listMarkerFormat.counterIncrement;
				_listNumberHint += (counterIncrement && counterIncrement.hasOwnProperty("ordered")) ? counterIncrement.ordered : 1;
			}

			return _listNumberHint;
		}
		
		// Fix bug 2800975 ListMarkerFormat.paragraphStartIndent not applied properly in Inside lists.
		/** @private */
		public override function getEffectivePaddingLeft():Number
		{
			if(getTextFlow().computedFormat.blockProgression == BlockProgression.TB)
			{
				if(computedFormat.paddingLeft == FormatValue.AUTO)
				{
						if (computedFormat.listMarkerFormat !==undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
						{
							return  computedFormat.listMarkerFormat.paragraphStartIndent;
						}
					return 0;
						
				}
				else
				{
					if (computedFormat.listMarkerFormat !==undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
					{
						return computedFormat.paddingLeft+computedFormat.listMarkerFormat.paragraphStartIndent;
					}
					return computedFormat.paddingLeft;
				}
			}
			else
			{
				return 0;
			}
		}
		/** @private */
		public override function getEffectivePaddingTop():Number
		{
			if(getTextFlow().computedFormat.blockProgression == BlockProgression.RL)
			{
				if(computedFormat.paddingTop == FormatValue.AUTO)
				{
					if (computedFormat.listMarkerFormat !==undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
					{
						return  computedFormat.listMarkerFormat.paragraphStartIndent;
					}
					return 0;
					
				}
				else
				{
					if (computedFormat.listMarkerFormat !==undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
					{
						return computedFormat.paddingTop+computedFormat.listMarkerFormat.paragraphStartIndent;
					}
					return computedFormat.paddingTop;
				}
			}
			else
			{
				return 0;
			}
		}
		/** @private */
		public override function getEffectivePaddingRight():Number
		{
			if(getTextFlow().computedFormat.blockProgression == BlockProgression.TB)
			{
				if(computedFormat.paddingRight == FormatValue.AUTO)
				{
					if (computedFormat.listMarkerFormat !==undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
					{
						return  computedFormat.listMarkerFormat.paragraphStartIndent;
					}
					return 0;
					
				}
				else
				{
					if (computedFormat.listMarkerFormat !==undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
					{
						return computedFormat.paddingRight+computedFormat.listMarkerFormat.paragraphStartIndent;
					}
					return computedFormat.paddingRight;
				}
			}
			else
			{
				return 0;
			}
		}
		
		/** @private */
		public override function getEffectivePaddingBottom():Number
		{
			if(getTextFlow().computedFormat.blockProgression == BlockProgression.RL)
			{
				if(computedFormat.paddingBottom == FormatValue.AUTO)
				{
					if (computedFormat.listMarkerFormat !==undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
					{
						return  computedFormat.listMarkerFormat.paragraphStartIndent;
					}
					return 0;
					
				}
				else
				{
					if (computedFormat.listMarkerFormat !==undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
					{
						return computedFormat.paddingBottom+computedFormat.listMarkerFormat.paragraphStartIndent;
					}
					return computedFormat.paddingBottom;
				}
			}
			else
			{
				return 0;
			}
		}
		
		
	}
}
