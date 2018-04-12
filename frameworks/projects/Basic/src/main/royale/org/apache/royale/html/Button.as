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
package org.apache.royale.html
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
    COMPILE::SWF
    {
    	import org.apache.royale.core.UIButtonBase;
    }
    COMPILE::JS
    {
        import org.apache.royale.core.UIBase;
		import org.apache.royale.core.WrappedHTMLElement;
    }
    import org.apache.royale.core.ValuesManager;
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
     *  @productversion Royale 0.0
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
     *  @productversion Royale 0.0
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
     *  @productversion Royale 0.0
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
     *  @productversion Royale 0.0
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
     *  @productversion Royale 0.0
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
     *  @productversion Royale 0.0
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
     *  @productversion Royale 0.0
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
	 *  @productversion Royale 0.0
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
	 *  @productversion Royale 0.0
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
	 *  @productversion Royale 0.0
	 */
	[Event(name="doubleClick", type="org.apache.royale.events.MouseEvent")]
	
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
    public class Button extends ButtonBase
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
		}

        /**
		 * @private
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			super.createElement();
			typeNames = "Button";
			return element;
		}
	}
    
}
