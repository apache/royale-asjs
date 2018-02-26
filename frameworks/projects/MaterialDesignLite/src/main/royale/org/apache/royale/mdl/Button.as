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
    import org.apache.royale.html.TextButton;
    import org.apache.royale.mdl.beads.UpgradeElement;
    import org.apache.royale.mdl.supportClasses.IMaterialIconProvider;
    import org.apache.royale.mdl.materialIcons.IMaterialIcon;
   
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
    }
    
    /**
     *  The Button class provides a Material Design Library UI-like appearance for
     *  a Button.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
	public class Button extends TextButton implements IMaterialIconProvider
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function Button()
		{
			super();

            typeNames = "mdl-button mdl-js-button";

            addBead(new UpgradeElement());
		}
        
        /**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			return addElementToWrapper(this,'button');
		}

        private var _materialIcon:IMaterialIcon;
        /**
		 *  A material icon to use with the button.
         *  Optional
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get materialIcon():IMaterialIcon
        {
            return _materialIcon;
        }
        public function set materialIcon(value:IMaterialIcon):void
        {
            _materialIcon = value;

            COMPILE::JS
            {
                 addElement(_materialIcon);
            }
        }

        private var _fab:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-button--fab" effect selector.
         *  Applies fab (circular) display effect. Mutually exclusive with raised, mini-fab, and icon.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get fab():Boolean
        {
            return _fab;
        }
        public function set fab(value:Boolean):void
        {
            if (_fab != value)
            {
                _fab = value;

                COMPILE::JS
                {
                    adjustTypeNames("mdl-button--fab", value);
                }
            }
        }

        private var _raised:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-button--raised" effect selector.
         *  Applies raised display effect. Mutually exclusive with fab, mini-fab, and icon.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get raised():Boolean
        {
            return _raised;
        }
        public function set raised(value:Boolean):void
        {
            if (_raised != value)
            {
                _raised = value;
                COMPILE::JS
                {
                    adjustTypeNames("mdl-button--raised", value);
                }
            }
        }
        COMPILE::JS
        private function adjustTypeNames(type:String,add:Boolean):void
        {
            type = " " + type;
            var typeLength:int = type.length;
            var typeIdx:int = typeNames.indexOf(type);
            var adjust:Boolean = false;
            if(add && typeIdx == -1)
            {
                typeNames += type;
                adjust = true;
            }
            else if(!add && typeIdx != -1)
            {
                typeNames = typeNames.substr(typeIdx,typeLength);
                adjust = true;
            }
            if(adjust)
            {
                var cl:String = className;
                setClassName((cl ? cl + " " : "") + typeNames);                
            }
        }

        private var _colored:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-button--colored" effect selector.
         *  Applies colored display effect (primary or accent color, depending on the type of button).
         *  Colors are defined in material.min.css
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get colored():Boolean
        {
            return _colored;
        }
        public function set colored(value:Boolean):void
        {
            if (_colored != value)
            {
                _colored = value;

                COMPILE::JS
                {
                    adjustTypeNames("mdl-button--colored", value);
                }
            }
        }

        private var _accent:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-button--accent" effect selector.
		 *  Applies accent color display effect.
         *  Colors are defined in material.min.css.
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get accent():Boolean
        {
            return _accent;
        }
        public function set accent(value:Boolean):void
        {
            if (_accent != value)
            {
                _accent = value;

                COMPILE::JS
                {
                    adjustTypeNames("mdl-button--accent", value);
                }
            }
        }

        private var _primary:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-button--primary" effect selector.
		 *  Applies primary color display effect.
         *  Colors are defined in material.min.css
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
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
                    adjustTypeNames("mdl-button--primary", value);
                }
            }
        }

        private var _minifab:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-button--mini-fab" effect selector.
		 *  Applies mini-fab (small fab circular) display effect.
         *  Mutually exclusive with raised, fab, and icon
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get minifab():Boolean
        {
            return _minifab;
        }
        public function set minifab(value:Boolean):void
        {
            if (_minifab != value)
            {
                _minifab = value;

                COMPILE::JS
                {
                    adjustTypeNames("mdl-button--mini-fab", value);
                }
            }
        }

        private var _icon:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-button--icon" effect selector.
		 *  Applies icon (small plain circular) display effect.
         *  Mutually exclusive with raised, fab, and mini-fab
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get icon():Boolean
        {
            return _icon;
        }
        public function set icon(value:Boolean):void
        {
            if (_icon != value)
            {
                _icon = value;

                COMPILE::JS
                {
                    adjustTypeNames("mdl-button--icon", value);
                }
            }
        }

        protected var _ripple:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-js-ripple-effect" effect selector.
		 *  Applies ripple click effect. May be used in combination with any other classes
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get ripple():Boolean
        {
            return _ripple;
        }
        public function set ripple(value:Boolean):void
        {
            if (_ripple != value)
            {
                _ripple = value;

                COMPILE::JS
                {
                    adjustTypeNames("mdl-js-ripple-effect", value);
                }
            }
        }
	}
}
