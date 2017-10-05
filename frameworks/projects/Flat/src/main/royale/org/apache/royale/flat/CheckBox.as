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
package org.apache.royale.flat
{
    COMPILE::SWF
    {
        import org.apache.royale.html.CheckBox;            
    }
    COMPILE::JS
    {
        import org.apache.royale.core.UIBase;
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.events.Event;
        import org.apache.royale.html.util.addElementToWrapper;
    }

    /**
     *  The CheckBox class provides a FlatUI-like appearance for
     *  a CheckBox.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    COMPILE::SWF
	public class CheckBox extends org.apache.royale.html.CheckBox
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function CheckBox()
		{
			super();
		}
	}
    
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched when the user checks or un-checks the CheckBox.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="change", type="org.apache.royale.events.Event")]
    
    COMPILE::JS
    public class CheckBox extends UIBase
    {
        
        private var input:HTMLInputElement;
        private var checkbox:HTMLSpanElement;
        private var label:HTMLLabelElement;
        private var textNode:Text;
        
        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLLabelElement
         * @royaleignorecoercion HTMLInputElement
         * @royaleignorecoercion HTMLSpanElement
         * @royaleignorecoercion Text
         */
        override protected function createElement():WrappedHTMLElement
        {
                label = addElementToWrapper(this,'label') as HTMLLabelElement;
                
                input = document.createElement('input') as HTMLInputElement;
                input.type = 'checkbox';
                input.className = 'checkbox-input';
                input.addEventListener('change', selectionChangeHandler, false);
                label.appendChild(input);
                
                checkbox = document.createElement('span') as HTMLSpanElement;
                checkbox.className = 'checkbox-icon';
                checkbox.addEventListener('mouseover', mouseOverHandler, false);
                checkbox.addEventListener('mouseout', mouseOutHandler, false);
                label.appendChild(checkbox);
                
                textNode = document.createTextNode('') as Text;
                label.appendChild(textNode);
                label.className = 'CheckBox';
                typeNames = 'CheckBox';
                
                positioner.style.position = 'relative';
                (input as WrappedHTMLElement).royale_wrapper = this;
                (checkbox as WrappedHTMLElement).royale_wrapper = this;
                return element;
            };
        
        
        /**
         */
        private function mouseOverHandler(event:Event):void
        {
            checkbox.className = 'checkbox-icon-hover';
        }
        
        /**
         */
        private function mouseOutHandler(event:Event):void
        {
            if (input.checked)
                checkbox.className = 'checkbox-icon-checked';
            else
                checkbox.className = 'checkbox-icon';
        }
        
        
        /**
         */
        private function selectionChangeHandler(event:Event):void
        {
            if (input.checked)
                checkbox.className = 'checkbox-icon-checked';
            else
                checkbox.className = 'checkbox-icon';
        }
        
        
        public function get text():String
        {
            return textNode.nodeValue;
        }
        
        public function set text(value:String):void
        {
            textNode.nodeValue = value;
        }
        
        public function get selected():Boolean
        {
            return input.checked;
        }
        
        public function set selected(value:Boolean):void
        {
            input.checked = value;
            if (value)
                checkbox.className = 'checkbox-icon-checked';
            else
                checkbox.className = 'checkbox-icon';
        }

    }

}
