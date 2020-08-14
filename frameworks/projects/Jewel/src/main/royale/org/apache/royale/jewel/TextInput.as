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
    import org.apache.royale.jewel.supportClasses.textinput.TextInputBase;

    /**
     *  The TextInput implements the jewel control for
     *  single-line text field. It dispatches a change event
     *  when the user input text.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class TextInput extends TextInputBase
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function TextInput()
		{
			super();

            typeNames = "jewel textinput";
		}
        
        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLInputElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            input = addElementToWrapper(this,'input') as HTMLInputElement;
            input.setAttribute('type', 'text');
            input.setAttribute('autocorrect', 'off');
            input.setAttribute('autocomplete', 'off');
            input.setAttribute('spellcheck', 'false');
            
            //attach input handler to dispatch royale change event when user write in textinput
            input.addEventListener("input", textChangeHandler)
            input.addEventListener("keypress", enterEventHandler, true);
            
            positioner = document.createElement('div') as WrappedHTMLElement;
            
            return element;
        }
	}
}
