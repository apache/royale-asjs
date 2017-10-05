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
	 * The TabElement class represents a &lt;tab/&gt; in the text flow. You assign tab stops as an array of TabStopFormat objects to the 
	 * <code>ParagraphElement.tabStops</code> property.
	 * 
	 * <p><strong>Note</strong>:This class exists primarily to support &lt;tab/&gt; in MXML markup. You can add tab characters (\t) directly 
	 * into the text like this:</p>
	 *
	 * <listing version="3.0" >
	 * spanElement1.text += '\t';
	 * </listing>
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 * @see org.apache.royale.textLayout.formats.TabStopFormat
	 * @see FlowElement#tabStops
	 * @see SpanElement
	 */
	 
	public final class TabElement extends SpecialCharacterElement
	{
		/** Constructor - creates a new TabElement instance. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function TabElement()
		{
			super();
			this.text = '\t';
		}
		override public function get className():String{
			return "TabElement";
		}
		
		/** @private */
		override protected function get abstract():Boolean
		{ return false; }

		/** @private */
		public override function get defaultTypeName():String
		{ return "tab"; }
	}
}
