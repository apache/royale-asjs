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
    import org.apache.flex.core.ValuesManager;
    import org.apache.flex.events.IEventDispatcher;
    COMPILE::SWF
    {
    	import org.apache.flex.core.UIButtonBase;
    }
    COMPILE::JS
    {
        import org.apache.flex.core.UIBase;
		import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.html.util.addElementToWrapper;
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
     *  @productversion FlexJS 0.0
     */
	[Event(name="click", type="org.apache.flex.events.MouseEvent")]

    /**
     *  The ButtonBase class is the base class for Button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
	public class ButtonBase extends UIButtonBase implements IStrand, IEventDispatcher, IUIBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ButtonBase()
		{
			super();
		}
	}
    
    COMPILE::JS
    public class ButtonBase extends UIBase implements IStrand, IEventDispatcher, IUIBase
    {
        /**
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'button');
            element.setAttribute('type', 'button');
            /* AJH comment out until we figure out why it is needed
            if (org.apache.flex.core.ValuesManager.valuesImpl.getValue) {
                var impl:Object = org.apache.flex.core.ValuesManager.valuesImpl.
                    getValue(this, 'iStatesImpl');
            }*/
            return element;
        }        

    }        

}
