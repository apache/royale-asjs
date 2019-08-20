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
package org.apache.royale.jewel.supportClasses.button
{
    COMPILE::SWF
    {
    	import org.apache.royale.core.UIButtonBase;
    }

    COMPILE::JS
    {
        import org.apache.royale.core.StyledUIBase;
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
    }
    
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.ITextModel;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.utils.ClassSelectorList;
    import org.apache.royale.utils.IClassSelectorListSupport;

    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched when the user clicks on a button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
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
     *  @productversion Royale 0.9.4
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
     *  @productversion Royale 0.9.4
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
     *  @productversion Royale 0.9.4
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
     *  @productversion Royale 0.9.4
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
     *  @productversion Royale 0.9.4
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
     *  @productversion Royale 0.9.4
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
	 *  @productversion Royale 0.9.4
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
	 *  @productversion Royale 0.9.4
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
	 *  @productversion Royale 0.9.4
	 */
	[Event(name="doubleClick", type="org.apache.royale.events.MouseEvent")]

    /**
     *  The Jewel BasicButton class is a simple button.  Use Jewel Button for
     *  buttons that should show text.
     * 
     *  BasicButton is a commonly used rectangular button. It looks like it can be pressed 
     *  and allow users to take actions, and make choices, with a single click or tap. It typically
     *  use event listeners to perform an action when the user interact with the control. When a user
     *  clicks the mouse or tap with the finger this control it dispatches a click event.
     *  
     *  This is the lightest weight button used for non-text buttons like the arrow buttons
     *  in a Scrollbar or NumericStepper.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    COMPILE::SWF
	public class BasicButton extends UIButtonBase implements IStrand, IUIBase, IEventDispatcher, IClassSelectorListSupport
	{
        public static const PRIMARY:String = "primary";
        public static const SECONDARY:String = "secondary";
        public static const EMPHASIZED:String = "emphasized";

        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function BasicButton()
		{
			super();

            classSelectorList = new ClassSelectorList(this);
            typeNames = "jewel button";
		}

        protected var classSelectorList:ClassSelectorList;

        private var _emphasis:String;
        /**
		 *  Activate "emphasis" effect selector. Applies emphasis color display effect.
         *  Possible values are constants (PRIMARY, SECONDARY, EMPHASIZED)
         *  Colors are defined in royale-jewel.css
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get emphasis():String
        {
            return _emphasis;
        }
        [Inspectable(category="General", enumeration="primary,secondary,emphasized")]
        public function set emphasis(value:String):void
        {
            if (_emphasis != value)
            {
                if(_emphasis)
                {
                    classSelectorList.toggle(_emphasis, false);
                }
                _emphasis = value;

                classSelectorList.toggle(_emphasis, value);
            }
        }

        /**
         * Add a class selector to the list.
         * 
         * @param name Name of selector to add.
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
         */
        public function addClass(name:String):void
        {
            // To implement.need to implement this interface or extensions will not compile
        }

        /**
         * Removes a class selector from the list.
         * 
         * @param name Name of selector to remove.
         *
         * @royaleignorecoercion HTMLElement
         * @royaleignorecoercion DOMTokenList
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
         */
        public function removeClass(name:String):void
        {
            // To implement.need to implement this interface or extensions will not compile
        }

        /**
         * Add or remove a class selector to/from the list.
         * 
         * @param name Name of selector to add or remove.
         * @param value True to add, False to remove.
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
         */
        public function toggleClass(name:String, value:Boolean):void
        {
            // To implement.need to implement this interface or extensions will not compile
        }

        /**
		 *  Search for the name in the element class list 
		 *
         *  @param name Name of selector to find.
         *  @return return true if the name is found or false otherwise.
         * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function containsClass(name:String):Boolean
        {
            return false;
        }
    }

    /**
     *  The Jewel BasicButton class is a simple button.  Use Jewel Button for
     *  buttons that should show text.
     * 
     *  BasicButton is a commonly used rectangular button. It looks like it can be pressed 
     *  and allow users to take actions, and make choices, with a single click or tap. It typically
     *  use event listeners to perform an action when the user interact with the control. When a user
     *  clicks the mouse or tap with the finger this control it dispatches a click event.
     *  
     *  This is the lightest weight button used for non-text buttons like the arrow buttons
     *  in a Scrollbar or NumericStepper.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    COMPILE::JS
    public class BasicButton extends StyledUIBase implements IStrand, IUIBase, IEventDispatcher, IClassSelectorListSupport
    {
        public static const PRIMARY:String = "primary";
        public static const SECONDARY:String = "secondary";
        public static const EMPHASIZED:String = "emphasized";

        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function BasicButton()
		{
			super();
            typeNames = "jewel button";
		}

        private var _emphasis:String;
        /**
		 *  Activate "emphasis" effect selector. Applies emphasis color display effect.
         *  Possible values are constants (PRIMARY, SECONDARY, EMPHASIZED).
         *  Left without value to get the default look (light or dark.)
         *  Colors are defined in jewel theme CSS
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get emphasis():String
        {
            return _emphasis;
        }
        public function set emphasis(value:String):void
        {
            if (_emphasis != value)
            {
                if(_emphasis)
                {
                    removeClass(_emphasis);
                }
                _emphasis = value;

                addClass(_emphasis);
            }
        }

        /**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion org.apache.royale.html.util.addElementToWrapper
         */
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this, 'button');
            element.setAttribute('type', 'button');
            
            return element;
        }
	}
}