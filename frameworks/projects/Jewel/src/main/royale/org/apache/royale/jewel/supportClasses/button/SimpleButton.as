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
    import org.apache.royale.utils.ClassSelectorList;
    import org.apache.royale.utils.IClassSelectorListSupport;
    import org.apache.royale.utils.IEmphasis;
    }
    COMPILE::JS
    {
    import org.apache.royale.core.StyledUIBase;
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
    }
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.events.IEventDispatcher;

    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched when the user clicks on a button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
	[Event(name="click", type="org.apache.royale.events.MouseEvent")]

    /**
     *  Dispatched when the user moves onto a button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    [Event(name="rollOver", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Dispatched when the user moves out a button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    [Event(name="rollOut", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Dispatched when the user press mouse over a button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    [Event(name="mouseDown", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Dispatched when the user release mouse over a button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    [Event(name="mouseUp", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Dispatched when the user moves mouse pointer over a button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    [Event(name="mouseMove", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Dispatched when the user moves mouse pointer out of a button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    [Event(name="mouseOut", type="org.apache.royale.events.MouseEvent")]
    
	/**
	 *  Dispatched when the user moves onto a button.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	[Event(name="mouseOver", type="org.apache.royale.events.MouseEvent")]

	/**
	 *  Dispatched when the user scrolls mouse whell over a button.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	[Event(name="mouseWheel", type="org.apache.royale.events.MouseEvent")]
	
	/**
	 *  Dispatched when the user double-click over a button.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	[Event(name="doubleClick", type="org.apache.royale.events.MouseEvent")]

    /**
     *  The Jewel SimpleButton class is a simple button.  Use Jewel Button for
     *  buttons that should show text.
     * 
     *  SimpleButton is a commonly used rectangular button. It looks like it can be pressed 
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
     *  @productversion Royale 0.9.6
     */
    COMPILE::SWF
	public class SimpleButton extends UIButtonBase implements IStrand, IUIBase, IEventDispatcher, IClassSelectorListSupport, IEmphasis
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function SimpleButton()
		{
			super();

            classSelectorList = new ClassSelectorList(this);
            typeNames = "jewel button";
		}

        protected var classSelectorList:ClassSelectorList;

        private var _emphasis:String;
        /**
		 *  Applies emphasis color display. Possible constant values are: PRIMARY, SECONDARY, EMPHASIZED.
         *  Colors are defined in royale jewel theme CSS.
         * 
         *  Left without value to get the default look (light or dark).
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
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
                    toggleClass(_emphasis, false);
                }
                _emphasis = value;

                toggleClass(_emphasis, value);
            }
        }

        private var _outlined:Boolean;
        /**
		 *  Applies outlined style to the button. This combines with the emphasis styles
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
        public function get outlined():Boolean
        {
            return _outlined;
        }
        public function set outlined(value:Boolean):void
        {
            if (_outlined != value)
            {
                _outlined = value;

                _outlined ? addClass("outlined") : removeClass("outlined");
            }
        }

        private var _unboxed:Boolean;
        /**
		 *  Applies unboxed style to the button. This combines with the emphasis styles
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
        public function get unboxed():Boolean
        {
            return _unboxed;
        }
        public function set unboxed(value:Boolean):void
        {
            if (_unboxed != value)
            {
                _unboxed = value;

                _unboxed ? addClass("unboxed") : removeClass("unboxed");
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
         * @productversion Royale 0.9.6
         */
        public function addClass(name:String):void
        {
            // To implement. Need to implement this interface or extensions will not compile
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
         * @productversion Royale 0.9.6
         */
        public function removeClass(name:String):void
        {
            // To implement. Need to implement this interface or extensions will not compile
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
         * @productversion Royale 0.9.6
         */
        public function toggleClass(name:String, value:Boolean):void
        {
            // To implement. Need to implement this interface or extensions will not compile
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
		 *  @productversion Royale 0.9.6
		 */
		public function containsClass(name:String):Boolean
        {
            return false;
        }

        /**
		 *  Replace a class for a new one
		 *
         *  @param oldClass Name of selector to remove.
         *  @param newClass Name of selector to set.
         * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
        public function replaceClass(oldClass:String, newClass:String = null):void
        {
            // To implement. Need to implement this interface or extensions will not compile
        }
    }

    /**
     *  The Jewel SimpleButton class is a simple button.  Use Jewel Button for
     *  buttons that should show text.
     * 
     *  SimpleButton is a commonly used rectangular button. It looks like it can be pressed 
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
     *  @productversion Royale 0.9.6
     */
    COMPILE::JS
    public class SimpleButton extends StyledUIBase implements IStrand, IUIBase, IEventDispatcher
    {
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function SimpleButton()
		{
			super();
            typeNames = "jewel button";
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

        private var _outlined:Boolean;
        /**
		 *  Applies outlined style to the button. This combines with the emphasis styles
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
        public function get outlined():Boolean
        {
            return _outlined;
        }
        public function set outlined(value:Boolean):void
        {
            if (_outlined != value)
            {
                _outlined = value;

                _outlined ? addClass("outlined") : removeClass("outlined");
            }
        }
        
        private var _unboxed:Boolean;
        /**
		 *  Applies unboxed style to the button. This combines with the emphasis styles
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
        public function get unboxed():Boolean
        {
            return _unboxed;
        }
        public function set unboxed(value:Boolean):void
        {
            if (_unboxed != value)
            {
                _unboxed = value;

                _unboxed ? addClass("unboxed") : removeClass("unboxed");
            }
        }
	}
}