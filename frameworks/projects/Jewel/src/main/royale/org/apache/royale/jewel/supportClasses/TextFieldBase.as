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
package org.apache.royale.jewel.supportClasses
{
	import org.apache.royale.events.Event;
	import org.apache.royale.html.TextInput;
    
    import org.apache.royale.jewel.supportClasses.ITextField;
    
    COMPILE::JS
    {
        import goog.events;
        import org.apache.royale.core.WrappedHTMLElement;        
    }
    
    /**
     *  The TextFieldBase class is the base class for TextField and TextArea Jewel controls
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.2
     */    
	public class TextFieldBase extends TextInput implements ITextField
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.2
         */
		public function TextFieldBase()
		{
			super();
		}

        COMPILE::JS
        {
            private var _textNode:Text;
            /**
             *  @copy org.apache.royale.jewel.supportClasses.ITextField#textNode
             *
             *  @langversion 3.0
             *  @playerversion Flash 10.2
             *  @playerversion AIR 2.6
             *  @productversion Royale 0.9.2
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
             *  @copy org.apache.royale.jewel.supportClasses.ITextField#input
             *
             *  @langversion 3.0
             *  @playerversion Flash 10.2
             *  @playerversion AIR 2.6
             *  @productversion Royale 0.9.2
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
            /**
             *  @copy org.apache.royale.jewel.supportClasses.ITextField#label
             *
             *  @langversion 3.0
             *  @playerversion Flash 10.2
             *  @playerversion AIR 2.6
             *  @productversion Royale 0.9.2
             */
            public function get label():HTMLLabelElement
            {
                return _label;
            }

            public function set label(value:HTMLLabelElement):void
            {
                _label = value;
            }
        }

        COMPILE::JS
        /**
		 *  override UIBase to affect positioner instead of element
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.2
		 */
		override protected function setClassName(value:String):void
		{
			positioner.className = value;           
		}

        private var _isInvalid:Boolean = false;
        /**
		 *  A boolean flag to activate "is-invalid" effect selector.
         *  Defines the textfield as invalid on initial load.
         *  Optional
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.2
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
                typeNames = positioner.className;
            }
        }
	}
}
