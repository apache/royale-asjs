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
    COMPILE::JS
    {
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
    }
    
    /**
     *  The Jewel SwitchRadio control lets the user make a single choice within a set of mutually exclusive choices.
     *  
     *  A SwitchRadio of a lever that can be moved back and forth indicating a binary condition
     *  that will be set or unset when the user clicks or touches it. SwitchRadios
     *  always appear in groups of two or more with the same <code>groupName</code> property.
     *   
     *  While they can be individually selected, can only be deselected by selecting 
     *  a different SwitchRadio in the same group (which deselects the rest of SwitchRadio).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.8
     */
    public class SwitchRadio extends RadioButton
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
		public function SwitchRadio()
		{
			super();
            typeNames = "jewel switch radio";
		}

        COMPILE::JS
		private var _spanSwitch:HTMLSpanElement;
		/**
         *  the span for the switch
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
		COMPILE::JS
		public function get spanSwitch():HTMLSpanElement {
			return _spanSwitch;
		} 
		COMPILE::JS
		public function set spanSwitch(value:HTMLSpanElement):void {
			_spanSwitch = value;
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLInputElement
         * @royaleignorecoercion HTMLSpanElement
         * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            icon = addElementToWrapper(this, 'input') as HTMLInputElement;
            icon.type = 'radio';
            icon.id = '_radio_' + Math.random();
            icon.value = String(value);
            
            spanSwitch = document.createElement('span') as HTMLSpanElement;
            spanSwitch.className = 'switch';

            textNode = document.createTextNode('') as Text;
            spanLabel = document.createElement('span') as HTMLSpanElement;
            spanLabel.className = 'label';
            spanLabel.appendChild(textNode);
            
            positioner = document.createElement('label') as WrappedHTMLElement;
            
            return element;
        }

        COMPILE::JS
        private var _positioner:WrappedHTMLElement;
        /**
         *  @copy org.apache.royale.core.IUIBase#positioner
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        COMPILE::JS
		override public function get positioner():WrappedHTMLElement
		{
			return _positioner;
		}
        COMPILE::JS
		override public function set positioner(value:WrappedHTMLElement):void
		{
			_positioner = value;
            _positioner.royale_wrapper = this;
			_positioner.appendChild(element);
            _positioner.appendChild(spanSwitch);
            _positioner.appendChild(spanLabel);
		}
	}
}
