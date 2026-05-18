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
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}
	import org.apache.royale.style.elements.Span;
	import org.apache.royale.debugging.assert;

	/**
	 * Displays a small status indicator dot with an inner highlight.
	 */

	public class Status extends StyleUIBase
	{

		public function Status()
		{
			super();
		}

		COMPILE::JS
		private var span:Span;

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			var elem:WrappedHTMLElement = super.createElement();
			span = new Span();
			addElement(span);
			return elem;
		}
	}
}
