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
package org.apache.flex.flat
{
    COMPILE::SWF
    {
        import org.apache.flex.html.CheckBox;            
    }
    COMPILE::JS
    {
        import org.apache.flex.core.UIBase;
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.events.Event;
    }

    /**
     *  The CheckBox class provides a FlatUI-like appearance for
     *  a CheckBox.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
	public class CheckBox extends org.apache.flex.html.CheckBox
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function CheckBox()
		{
			super();
		}
	}
    
    COMPILE::JS
    public class CheckBox extends UIBase
    {
        
        private var input:HTMLInputElement;
        private var checkbox:HTMLSpanElement;
        private var label:HTMLLabelElement;
        private var textNode:Text;
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLLabelElement
         * @flexjsignorecoercion HTMLInputElement
         * @flexjsignorecoercion HTMLSpanElement
         * @flexjsignorecoercion Text
         */
        override protected function createElement():WrappedHTMLElement
        {
                label = document.createElement('label') as HTMLLabelElement;
                element = label as WrappedHTMLElement;
                
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
                
                positioner = element;
                
                (input as WrappedHTMLElement).flexjs_wrapper = this;
                (checkbox as WrappedHTMLElement).flexjs_wrapper = this;
                element.flexjs_wrapper = this;
                
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
