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
	import org.apache.flex.html.Group;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
		import org.apache.flex.html.addElementToWrapper;
    }

	/**
	 *  The Card class is a self-contained pieces of paper with data.
	 *  The Material Design Lite (MDL) card component is a user interface element
	 *  representing a virtual piece of paper that contains related data — such as a
	 *  photo, some text, and a link — that are all about a single subject.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class Card extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function Card()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-card";
			return addElementToWrapper(this,'div');
        }

		protected var _shadow:Number = 0;
        /**
		 *  A boolean flag to activate "mdl-shadow--Xdp" effect selector.
		 *  Assigns variable shadow depths (0, 2, 3, 4, 6, 8, or 16) to card
		 *
		 *  Cards are a convenient means of coherently displaying related content
		 *  that is composed of different types of objects. They are also well-suited
		 *  for presenting similar objects whose size or supported actions can vary
		 *  considerably, like photos with captions of variable length. Cards have
		 *  a constant width and a variable height, depending on their content.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
        public function get shadow():Number
        {
            return _shadow;
        }
        public function set shadow(value:Number):void
        {
			COMPILE::JS
			{
				element.classList.remove("mdl-shadow--" + _shadow + "dp");

				if(value == 2 || value == 3 || value == 4 || value == 6 || value == 8 || value == 16)
				{
					_shadow = value;

					element.classList.add("mdl-shadow--" + _shadow + "dp");
				}

				typeNames = element.className;
			}
        }
	}
}
