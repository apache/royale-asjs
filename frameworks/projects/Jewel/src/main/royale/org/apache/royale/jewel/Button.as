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
    import org.apache.royale.utils.ClassSelectorList;
    import org.apache.royale.core.ITextModel;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.events.IEventDispatcher;

    COMPILE::SWF
    {
    	import org.apache.royale.core.UIButtonBase;
    }

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.core.StyledUIBase;
        import org.apache.royale.html.util.addElementToWrapper;
    }

    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched when the user clicks on a button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
	[Event(name="click", type="org.apache.royale.events.MouseEvent")]

    /**
     *  Set a different class for rollOver events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    [Event(name="rollOver", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Set a different class for rollOut events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    [Event(name="rollOut", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseDown events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    [Event(name="mouseDown", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseUp events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    [Event(name="mouseUp", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseMove events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    [Event(name="mouseMove", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseOut events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    [Event(name="mouseOut", type="org.apache.royale.events.MouseEvent")]
    
	/**
	 *  Set a different class for mouseOver events so that
	 *  there aren't dependencies on the flash classes
	 *  on the JS side.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	[Event(name="mouseOver", type="org.apache.royale.events.MouseEvent")]
	/**
	 *  Set a different class for mouseWheel events so that
	 *  there aren't dependencies on the flash classes
	 *  on the JS side.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	[Event(name="mouseWheel", type="org.apache.royale.events.MouseEvent")]
	
	/**
	 *  Set a different class for doubleClick events so that
	 *  there aren't dependencies on the flash classes
	 *  on the JS side.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	[Event(name="doubleClick", type="org.apache.royale.events.MouseEvent")]


    [DefaultProperty("text")]

    /**
     *  The ButtonBase class is the base class for Button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    COMPILE::SWF
	public class Button extends UIButtonBase implements IStrand, IEventDispatcher, IUIBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function Button()
		{
			super();

            classSelectorList = new ClassSelectorList(this);
            typeNames = "jewel button";
		}

        protected var classSelectorList:ClassSelectorList;

        /**
         *  @copy org.apache.royale.html.Label#text
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get text():String
		{
            return ITextModel(model).text;
		}

        /**
         *  @private
         */
		public function set text(value:String):void
		{
            ITextModel(model).text = value;
		}

        /**
         *  @copy org.apache.royale.html.Label#html
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get html():String
		{
            return ITextModel(model).html;
		}

        /**
         *  @private
         */
		public function set html(value:String):void
		{
            ITextModel(model).html = value;
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
		 *  @productversion Royale 0.9.3
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

                classSelectorList.toggle("primary", value);
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
		 *  @productversion Royale 0.9.3
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

                classSelectorList.toggle("secondary", value);
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
		 *  @productversion Royale 0.9.3
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

                classSelectorList.toggle("emphasized", value);
            }
        }
	}

    /**
     *  The Button class that should show text.  This is the lightest weight
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
     *  @productversion Royale 0.9.3
     */
    COMPILE::JS
    public class Button extends StyledUIBase implements IStrand, IEventDispatcher, IUIBase
    {
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function Button()
		{
			super();
            typeNames = "jewel button";
		}

        /**
         *  @copy org.apache.royale.html.Label#text
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get text():String
		{
            return element.innerHTML;
		}

        /**
         *  @private
         */
		public function set text(value:String):void
		{
            this.element.innerHTML = value;
            this.dispatchEvent('textChange');
		}

        /**
         *  @copy org.apache.royale.html.Label#html
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get html():String
		{
            return element.innerHTML;
		}

        /**
         *  @private
         */
		public function set html(value:String):void
		{
            this.element.innerHTML = value;
            this.dispatchEvent('textChange');
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
		 *  @productversion Royale 0.9.3
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

                classSelectorList.toggle("primary", value);
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
		 *  @productversion Royale 0.9.3
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

                classSelectorList.toggle("secondary", value);
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
		 *  @productversion Royale 0.9.3
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

                classSelectorList.toggle("emphasized", value);
            }
        }
        
        /**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'button');
            element.setAttribute('type', 'button');
            /* AJH comment out until we figure out why it is needed
            if (org.apache.royale.core.ValuesManager.valuesImpl.getValue) {
                var impl:Object = org.apache.royale.core.ValuesManager.valuesImpl.
                    getValue(this, 'iStatesImpl');
            }*/
            return element;
        }
	}
}