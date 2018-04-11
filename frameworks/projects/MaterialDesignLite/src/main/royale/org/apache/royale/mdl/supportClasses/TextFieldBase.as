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
package org.apache.royale.mdl.supportClasses
{
	import org.apache.royale.events.Event;
	import org.apache.royale.html.TextInput;
    import org.apache.royale.core.IBead;

    import org.apache.royale.mdl.supportClasses.ITextField;

    COMPILE::JS
    {
        import goog.events;
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.core.CSSClassList;
    }
    
    /**
     *  The TextFieldBase class is the base class for TextField and TextArea MDL controls
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */    
	public class TextFieldBase extends TextInput implements ITextField
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function TextFieldBase()
		{
			super();

            COMPILE::JS
            {
                _classList = new CSSClassList();
            }
		}

        COMPILE::JS
        {
            private var _classList:CSSClassList;
            private var _textNode:Text;
            /**
             *  @copy org.apache.royale.mdl.supportClasses.ITextField#textNode
             *
             *  @langversion 3.0
             *  @playerversion Flash 10.2
             *  @playerversion AIR 2.6
             *  @productversion Royale 0.8
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
             *  @copy org.apache.royale.mdl.supportClasses.ITextField#input
             *
             *  @langversion 3.0
             *  @playerversion Flash 10.2
             *  @playerversion AIR 2.6
             *  @productversion Royale 0.8
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
             *  @copy org.apache.royale.mdl.supportClasses.ITextField#label
             *
             *  @langversion 3.0
             *  @playerversion Flash 10.2
             *  @playerversion AIR 2.6
             *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
		 */
		override protected function setClassName(value:String):void
		{
			positioner.className = value;           
		}

        private var _floatingLabel:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-textfield--floating-label" effect selector.
         *  Applies floating label effect.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get floatingLabel():Boolean
        {
            return _floatingLabel;
        }
        public function set floatingLabel(value:Boolean):void
        {
            if (_floatingLabel != value)
            {
                _floatingLabel = value;

                COMPILE::JS
                {
                    var classVal:String = "mdl-textfield--floating-label";
                    value ? _classList.add(classVal) : _classList.remove(classVal);
                    setClassName(computeFinalClassNames());
                }
            }
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
		 *  @productversion Royale 0.8
		 */
        public function get isInvalid():Boolean
        {
            return _isInvalid;
        }

        public function set isInvalid(value:Boolean):void
        {
            if (_isInvalid != value)
            {
                _isInvalid = value;

                COMPILE::JS
                {
                    var classVal:String = "is-invalid";
                    value ? _classList.add(classVal) : _classList.remove(classVal);
                    setClassName(computeFinalClassNames());
                }
            }
        }

        COMPILE::JS
        override protected function computeFinalClassNames():String
        {
            return _classList.compute() + super.computeFinalClassNames();
        }
	}
}
