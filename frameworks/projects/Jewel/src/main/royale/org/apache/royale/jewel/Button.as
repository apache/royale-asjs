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
package org.apache.royale.jewel
{
    import org.apache.royale.html.Button;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.utils.cssclasslist.toggleStyle;
    }

    /**
     *  The Button class is a simple button.  Use TextButton for
     *  buttons that should show text.  This is the lightest weight
     *  button used for non-text buttons like the arrow buttons
     *  in a Scrollbar or NumericStepper.
     * 
     *  The most common view for this button is CSSButtonView that
     *  allows you to specify a backgroundImage in CSS that defines
     *  the look of the button.
     * 
     *  However, when used in ScrollBar and when composed in many
     *  other components, it is more common to assign a custom view
     *  to the button.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public class Button extends org.apache.royale.html.Button
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function Button()
		{
			super();

            
            typeNames = "jewel button";
		}

        private var _primary:Boolean = false;

        /**
		 *  A boolean flag to activate "primary" effect selector.
		 *  Applies primary color display effect.
         *  Colors are defined in royale-jewel.css
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.2
		 */
        public function get primary():Boolean
        {
            return _primary;
        }

        public function set primary(value:Boolean):void
        {
            if (_primary != value)
            {
                _primary = value;

                COMPILE::JS
                {
                    toggleStyle(element, "primary", value);
                }
            }
        }
        
        private var _secondary:Boolean = false;

        /**
		 *  A boolean flag to activate "secondary" effect selector.
		 *  Applies secondary color display effect.
         *  Colors are defined in royale-jewel.css
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.2
		 */
        public function get secondary():Boolean
        {
            return _secondary;
        }

        public function set secondary(value:Boolean):void
        {
            if (_secondary != value)
            {
                _secondary = value;

                COMPILE::JS
                {
                    toggleStyle(element, "secondary", value);
                }
            }
        }

        private var _emphasized:Boolean = false;

        /**
		 *  A boolean flag to activate "emphasized" effect selector.
		 *  Applies emphasized color display effect.
         *  Colors are defined in royale-jewel.css
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.2
		 */
        public function get emphasized():Boolean
        {
            return _emphasized;
        }

        public function set emphasized(value:Boolean):void
        {
            if (_emphasized != value)
            {
                _emphasized = value;

                COMPILE::JS
                {
                    toggleStyle(element, "emphasized", value);
                }
            }
        }
	}
}