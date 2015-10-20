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
package org.apache.flex.html
{
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
    COMPILE::AS3
    {
    	import org.apache.flex.core.UIButtonBase;
    }
    COMPILE::JS
    {
        import org.apache.flex.core.UIBase;
    }
    import org.apache.flex.core.ValuesManager;
    import org.apache.flex.events.IEventDispatcher;
    
	
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched when the user clicks on a button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	[Event(name="click", type="org.apache.flex.events.Event")]

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
     *  @productversion FlexJS 0.0
     */
    COMPILE::AS3
	public class Button extends UIButtonBase implements IStrand, IEventDispatcher, IUIBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function Button()
		{
			super();
		}
	}
    
    COMPILE::JS
    public class Button extends UIBase implements IStrand, IEventDispatcher, IUIBase
    {
        /**
         */
        override protected function createElement()
        {
            element = document.createElement('button');
            element.setAttribute('type', 'button');
            
            positioner = element;
            positioner.style.position = 'relative';
            element.flexjs_wrapper = this;
            
            /* AJH comment out until we figure out why it is needed
            if (org.apache.flex.core.ValuesManager.valuesImpl.getValue) {
                var impl:Object = org.apache.flex.core.ValuesManager.valuesImpl.
                    getValue(this, 'iStatesImpl');
            }*/
            
            return element;
        }        

    }        

}
