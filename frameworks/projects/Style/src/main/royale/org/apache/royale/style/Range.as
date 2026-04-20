// //////////////////////////////////////////////////////////////////////////////
// 
// Licensed to the Apache Software Foundation (ASF) under one or more
// contributor license agreements.  See the NOTICE file distributed with
// this work for additional information regarding copyright ownership.
// The ASF licenses this file to You under the Apache License, Version 2.0
// (the "License"); you may not use this file except in compliance with
// the License.  You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// 
// //////////////////////////////////////////////////////////////////////////////
package org.apache.royale.style
{
	import org.apache.royale.style.stylebeads.states.HasState;

	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.core.IHasLabel;
	import org.apache.royale.style.elements.Div;
	import org.apache.royale.style.elements.Span;
	import org.apache.royale.style.support.TextNode;
	import org.apache.royale.style.elements.I;
	import org.apache.royale.style.stylebeads.IStyleBead;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.stylebeads.utils.ScreenReader;
	import org.apache.royale.style.elements.Input;
	import org.apache.royale.style.skins.RangeSkin;

	public class Range extends Input
	{

		public function Range()
		{
			super();
		}
		
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			var elem:WrappedHTMLElement = super.createElement();
			type = "range";
			return elem;
		}
	}
}
