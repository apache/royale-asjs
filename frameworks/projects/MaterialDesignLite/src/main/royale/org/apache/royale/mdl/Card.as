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
package org.apache.royale.mdl
{
	import org.apache.royale.html.Group;

	COMPILE::JS
    {
        import org.apache.royale.core.CSSClassList;
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
	 *  @productversion Royale 0.8
	 */
	public class Card extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function Card()
		{
			super();

            typeNames = "mdl-card";

            COMPILE::JS
            {
                _classList = new CSSClassList();
            }
		}

        COMPILE::JS
        private var _classList:CSSClassList;

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
		 *  @productversion Royale 0.8
		 */
        public function get shadow():Number
        {
            return _shadow;
        }

        public function set shadow(value:Number):void
        {
			if (_shadow != value)
            {
                COMPILE::JS
                {
                    if (value == 2 || value == 3 || value == 4 || value == 6 || value == 8 || value == 16)
                    {
                        var classVal:String = "mdl-shadow--" + _shadow + "dp";
                        _classList.remove(classVal);

                        classVal = "mdl-shadow--" + value + "dp";
						_classList.add(classVal);

                        _shadow = value;

                        setClassName(computeFinalClassNames());
                    }
                }
            }
        }

		COMPILE::JS
		override protected function computeFinalClassNames():String
		{
			return _classList.compute() + super.computeFinalClassNames();
		}
	}
}
