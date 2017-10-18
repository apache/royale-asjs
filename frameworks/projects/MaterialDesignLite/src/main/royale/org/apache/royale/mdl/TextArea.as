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
package org.apache.royale.mdl
{
	import org.apache.royale.events.Event;
    import org.apache.royale.mdl.beads.UpgradeElement;

    import org.apache.royale.mdl.supportClasses.TextFieldBase;
    
    COMPILE::JS
    {
        import goog.events;
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
    }
    
    /**
     *  The TextArea is a multiline input components.
     *
     *  The Material Design Lite (MDL) text area component is an enhanced version
     *  of the standard HTML <input type="textarea"> elements.
     *  A text area consists of a horizontal line indicating where keyboard input can
     *  occur and, typically, text that clearly communicates the intended contents of
     *  the text area. The MDL text area component provides various types of text fields,
     *  and allows you to add both display and click effects.
     *
     *  To get more functionaluty in TextArea you can use beads to float a label 
     *  or have a prompt for example.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */   
	public class TextArea extends TextFieldBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function TextArea()
		{
			super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}
		
        private var _rows:int = 2;
        /**
		 *  The number of rows in the textarea. Defaults to 2
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get rows():int
        {
            return _rows;
        }
        /**
         *  @private
         */
        public function set rows(value:int):void
        {
            _rows = value;

            COMPILE::JS 
            {
                input.setAttribute('rows', _rows);
            }
        }

        private var _maxrows:int = 0;
        /**
		 *  The max number of rows in the textarea.
		 *
         *  @default 0
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get maxrows():int
        {
            return _maxrows;
        }
        /**
         *  @private
         */
        public function set maxrows(value:int):void
        {
            _maxrows = value;

            COMPILE::JS 
            {
                input.setAttribute('maxrows', _maxrows);
            }
        }

        COMPILE::JS
        private var _positioner:WrappedHTMLElement;

		COMPILE::JS
        override public function get positioner():WrappedHTMLElement
		{
			return _positioner;
		}

		COMPILE::JS
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
            typeNames = "mdl-textfield mdl-js-textfield";

            var div:HTMLDivElement = document.createElement('div') as HTMLDivElement;
            div.className = typeNames;

            addBead(new UpgradeElement(div));

            input = addElementToWrapper(this,'textarea') as HTMLInputElement;
            input.setAttribute('type', 'text');
            input.setAttribute('rows', rows);
            //input.setAttribute('maxrows', maxrows);
            input.className = "mdl-textfield__input";
            
            //attach input handler to dispatch royale change event when user write in textinput
            //goog.events.listen(element, 'change', killChangeHandler);
            goog.events.listen(input, 'input', textChangeHandler);
            
            label = document.createElement('label') as HTMLLabelElement;
            label.className = "mdl-textfield__label";

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
