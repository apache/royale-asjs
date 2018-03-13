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
    import org.apache.royale.jewel.supportClasses.TextFieldBase;

    COMPILE::JS
    {
        import goog.events;
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
    }

    /**
     *  The TextField class implements the basic control for
     *  single-line text input.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.2
     */
	public class TextField extends TextFieldBase
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.2
         */
		public function TextField()
		{
			super();

            typeNames = "jewel textField";
		}

        COMPILE::JS
        private var _positioner:WrappedHTMLElement;

		COMPILE::JS
        /**
         * The HTMLElement used to position the component.
         */
        override public function get positioner():WrappedHTMLElement
		{
			return _positioner;
		}

		COMPILE::JS
        /**
         * @private
         */
        override public function set positioner(value:WrappedHTMLElement):void
		{
			_positioner = value;
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLDivElement
         * @royaleignorecoercion HTMLInputElement
         * @royaleignorecoercion HTMLLabelElement
         * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            var div:HTMLDivElement = document.createElement('div') as HTMLDivElement;
            div.className = typeNames;
            
            input = addElementToWrapper(this,'input') as HTMLInputElement;
            input.setAttribute('type', 'text');
            input.className = "vTextField--input";
            
            //attach input handler to dispatch royale change event when user write in textinput
            //goog.events.listen(element, 'change', killChangeHandler);
            goog.events.listen(input, 'input', textChangeHandler);
            
            label = document.createElement('label') as HTMLLabelElement;
            label.className = "vTextField--label";

            textNode = document.createTextNode('') as Text;
            label.appendChild(textNode);
            
            div.appendChild(input);
            div.appendChild(label);

            positioner = div as WrappedHTMLElement;
            (label as WrappedHTMLElement).royale_wrapper = this;
            _positioner.royale_wrapper = this;
            
            return element;
        }

	}
}
