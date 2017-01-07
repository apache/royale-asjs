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
package org.apache.flex.mdl.supportClasses
{
	import org.apache.flex.events.Event;
	import org.apache.flex.html.TextInput;
    
    import org.apache.flex.mdl.supportClasses.ITextField;
    
    COMPILE::JS
    {
        import goog.events;
        import org.apache.flex.core.WrappedHTMLElement;            
    }
    
    /**
     *  The TextFieldBase class is the base class for TextField and TextArea MDL controls
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */    
	public class TextFieldBase extends org.apache.flex.html.TextInput implements ITextField
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function TextFieldBase()
		{
			super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

        COMPILE::JS
        {
            private var _textNode:Text;

            /**
             *  @copy org.apache.flex.mdl.supportClasses.ITextField#textNode
             *
             *  @langversion 3.0
             *  @playerversion Flash 10.2
             *  @playerversion AIR 2.6
             *  @productversion FlexJS 0.0
             */
            public function get textNode():Text
            {
                return _textNode;
            }

            public function set textNode(value:Text):void
            {
                _textNode = value;
            }

            private var _input:HTMLInputElement;

            /**
             *  @copy org.apache.flex.mdl.supportClasses.ITextField#input
             *
             *  @langversion 3.0
             *  @playerversion Flash 10.2
             *  @playerversion AIR 2.6
             *  @productversion FlexJS 0.0
             */
            public function get input():HTMLInputElement
            {
                return _input;
            }

            public function set input(value:HTMLInputElement):void
            {
                _input = value;
            }

            private var _label:HTMLLabelElement;

            public function get label():HTMLLabelElement
            {
                return _label;
            }

            public function set label(value:HTMLLabelElement):void
            {
                _label = value;
            }
        }

        private var _className:String;

        /**
         * since we have a div surronding the main input, we need to 
         * route the class assignaments to div
         */
        override public function set className(value:String):void
		{
			if (_className != value)
			{
                COMPILE::JS
                {
                    positioner.className = typeNames ? value + ' ' + typeNames : value;             
                }
				_className = value;
				dispatchEvent(new Event("classNameChanged"));
			}
		}

        private var _floatingLabel:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-textfield--floating-label" effect selector.
         *  Applies floating label effect.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get floatingLabel():Boolean
        {
            return _floatingLabel;
        }
        public function set floatingLabel(value:Boolean):void
        {
            _floatingLabel = value;

            COMPILE::JS
            {
                positioner.classList.toggle("mdl-textfield--floating-label", _floatingLabel);
            }
        }

        private var _isInvalid:Boolean = false;
        /**
		 *  A boolean flag to activate "is-invalid" effect selector.
         *  Defines the textfield as invalid on initial load.Optional
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get isInvalid():Boolean
        {
            return _isInvalid;
        }
        public function set isInvalid(value:Boolean):void
        {
            _isInvalid = value;

            COMPILE::JS
            {
                positioner.classList.toggle("is-invalid", _isInvalid);
            }
        }
	}
}
