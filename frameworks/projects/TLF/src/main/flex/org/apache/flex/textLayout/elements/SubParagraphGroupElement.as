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

	

	
	/** 
     * The SubParagraphGroupElement is a grouping element for FlowLeafElements and other classes that extend SubParagraphGroupElementBase.
	 *
     * @see org.apache.royale.textLayout.elements.SubParagraphGroupElement
     * @see org.apache.royale.textLayout.elements.SubParagraphGroupElementBase
     * @see org.apache.royale.textLayout.elements.FlowLeafElement
     *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 */
	public final class SubParagraphGroupElement extends SubParagraphGroupElementBase implements ISubParagraphGroupElement
	{
        /** Constructor. 
         * For information on using this class, see <a href='http://blogs.adobe.com/tlf/2011/01/tlf-2-0-changes-subparagraphgroupelements-and-typename-applied-to-textfieldhtmlimporter-and-cssformatresolver.html'>TLF 2.0 SubParagraphGroupElement and typeName</a>.
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
	 	 */
		public function SubParagraphGroupElement()
		{ super(); }
		override public function get className():String{
			return "SubParagraphGroupElement";
		}
		
		/** @private */
		override protected function get abstract():Boolean
		{ return false; }
		
		/** @private */
		public override function get defaultTypeName():String
		{ return "g"; }
		
		/** @private Lowest level of precedence. */
		public override function get precedence():uint 
		{ return kMinSPGEPrecedence; }
		
		/** @private */
		override public function get allowNesting():Boolean
		{ return true; }
		
		/** @private */
		public override function mergeToPreviousIfPossible():Boolean
		{
			if (parent && !bindableElement && !hasActiveEventMirror())
			{
				var myidx:int = parent.getChildIndex(this);
				if (myidx != 0)
				{
					var sib:SubParagraphGroupElement = parent.getChildAt(myidx-1) as SubParagraphGroupElement;
					// if only one element has an event mirror use that event mirror
					// for the merged element; if both have active mirrors, do not merge
					if (sib == null || sib.hasActiveEventMirror())
						return false;
					
					if (equalStylesForMerge(sib))
					{						
						parent.removeChildAt(myidx);
						if (numChildren > 0)
							sib.replaceChildren(sib.numChildren,sib.numChildren,this.mxmlChildren);
						return true;
					}
				}
			} 
			return false;
		}
	}
}
