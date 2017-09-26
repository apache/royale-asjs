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
package org.apache.flex.mdl
{
	import org.apache.flex.html.H1;

	COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
		import org.apache.flex.html.addElementToWrapper;
    }
	
	/**
	 *  The FooterHeading class is an extended H1 heading used in MDL footer
	 *  drop down section.
	 *  
	 *  (This is implemented as a class H4 and not as a bead that decorates other html text
	 *  classes since MDL generate the same visuals for all of them)
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class FooterHeading extends H1
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function FooterHeading()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

		/**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 * @flexjsignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-mega-footer__heading";

			addElementToWrapper(this,'h1');
            textNode = document.createTextNode('') as Text;
            element.appendChild(textNode);
            return element;
		}
	}
}
