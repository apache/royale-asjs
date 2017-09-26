/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.flex.svg
{
  COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }

	import org.apache.flex.core.ContainerBase;

	public class DOMWrapper extends ContainerBase
	{

		/**
		 * Constructor
		 *
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
        public function DOMWrapper()
        {
			super();
        }
		
		/**
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			element = document.createElementNS('http://www.w3.org/2000/svg', 'foreignObject') as WrappedHTMLElement;
			element.style.left = "0px";
			element.style.top = "0px";
			//element.offsetParent = null;
			return element;
		}


	}
}
