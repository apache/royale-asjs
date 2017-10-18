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
	import org.apache.royale.text.engine.TextRotation;
	import org.apache.royale.textLayout.debug.Debugging;
	import org.apache.royale.textLayout.formats.BlockProgression;
	
	/** 
	 * The TCYElement (Tatechuuyoko - ta-tae-chu-yo-ko) class is a subclass of SubParagraphGroupElementBase that causes
	 * text to draw horizontally within a vertical line.  Traditionally, it is used to make small
	 * blocks of non-Japanese text or numbers, such as dates, more readable.  TCY can be applied to 
	 * horizontal text, but has no effect on drawing style unless and until it is turned vertically.
	 * 
	 * TCY blocks which contain no text will be removed from the text flow during the normalization process.
	 * <p>
	 * In the example below, the image on the right shows TCY applied to the number 57, while the
	 * image on the left has no TCY formatting.</p>
	 * <p><img src="../../../images/textLayout_TCYElement.png" alt="TCYElement" border="0"/>
	 * </p>
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 * @see TextFlow
	 * @see ParagraphElement
	 * @see SpanElement
	 */
	public final class TCYElement extends SubParagraphGroupElementBase implements ITCYElement
	{
		/** Constructor - creates a new TCYElement instance.
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
	 	 */
		public function TCYElement()
		{
			super();
		}
		override public function get className():String{
			return "TCYElement";
		}
		
		/** @private */
		override public function createContentElement():void
		{
			super.createContentElement();
			updateTCYRotation();
		}
		
		/** @private */
		override protected function get abstract():Boolean
		{ return false; }
		
		/** @private */
		public override function get defaultTypeName():String
		{ return "tcy"; }
		
		/** @private */
        public override function get precedence():uint { return 100; }
		
		/** @private */
		public override function mergeToPreviousIfPossible():Boolean
		{	
			if (parent && !bindableElement)
			{
				var myidx:int = parent.getChildIndex(this);
				if (myidx != 0)
				{
					var prevEl:TCYElement = parent.getChildAt(myidx - 1) as TCYElement;
					if(prevEl)
					{
						while(this.numChildren > 0)
						{
							var xferEl:IFlowElement = this.getChildAt(0);
							replaceChildren(0, 1);
							prevEl.replaceChildren(prevEl.numChildren, prevEl.numChildren, xferEl);
						}
						parent.replaceChildren(myidx, myidx + 1);								
						return true;
					}		
				}
			}
			
			return false;
		}
		
		/** @private */
		public override function acceptTextBefore():Boolean 
		{ 
			return false; 
		}
		
		/** @private */
		public override function setParentAndRelativeStart(newParent:IFlowGroupElement,newStart:int):void
		{
			super.setParentAndRelativeStart(newParent,newStart);
			updateTCYRotation();
		}
		
		/** @private */
		public override function formatChanged(notifyModelChanged:Boolean = true):void
		{
			super.formatChanged(notifyModelChanged);
			updateTCYRotation();
		}
		
		
		/** @private */
		private function updateTCYRotation():void
		{
			var contElement:IContainerFormattedElement = getAncestorWithContainer();
			if (groupElement)
			{
				groupElement.textRotation = (contElement && contElement.computedFormat.blockProgression == BlockProgression.RL) ? TextRotation.ROTATE_270 : TextRotation.ROTATE_0;
				CONFIG::debug { Debugging.traceFTEAssign(groupElement,"textRotation",groupElement.textRotation); }
			}
		}
	}
	
	
}
