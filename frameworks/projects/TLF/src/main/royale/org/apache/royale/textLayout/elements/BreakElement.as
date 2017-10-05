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
	/** 
	 * The BreakElement class defines a line break, which provides for creating a line break in the text without 
	 * creating a new paragraph. It inserts a U+2028 character in the text of the paragraph.
	 *
	 * <p><strong>Note</strong>: This class exists primarily to support break <br/> tags in MXML markup. To create line breaks, 
	 * you can add newline characters (\n) directly into the text like this:</p>
	 *
	 * <listing version="3.0" >
	 * spanElement1.text += '\n';
	 * </listing>
	 *
	 * In markup, either FXG, TEXT_LAYOUT_FORMAT or MXML, you can simply insert a <br/> where you want the break.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 * @see ParagraphElement
	 * @see SpanElement
	 */
	public final class BreakElement extends SpecialCharacterElement implements IBreakElement
	{
		/** Constructor. 
		 *
		 * @playerversion Flash 10 
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function BreakElement() {
			super();
			this.text = '\u2028';
		}
		override public function get className():String{
			return "BreakElement";
		}

		/** @private */
		override protected function get abstract():Boolean {
			return false;
		}

		/** @private */
		public override function get defaultTypeName():String {
			return "br";
		}
	}
}
