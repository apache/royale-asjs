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
package org.apache.royale.html.elements
{
	import org.apache.royale.core.UIBase;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
    }
    import org.apache.royale.html.NodeElementBase;

	/**
	 *  The Button class represents an HTML <button> element
     *  
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class Button extends NodeElementBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function Button()
		{
			super();
		}
		
        COMPILE::JS
        private function get button():HTMLButtonElement
        {
            return element as HTMLButtonElement;
        }

		COMPILE::SWF
        private var _autofocus:Boolean;
        /**
         *  Whether the button is autofocused
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function get autofocus():Boolean
        {
            COMPILE::SWF
            {
                return _autofocus;
            }

            COMPILE::JS
            {
                return button.autofocus;
            }
        }
        public function set autofocus(value:Boolean):void
        {
            COMPILE::SWF
            {
                _autofocus = value;
            }
            COMPILE::JS
            {
                button.autofocus = value;
            }
        }

		COMPILE::SWF
        private var _disabled:Boolean;
        /**
         *  Whether the button is disabled
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function get disabled():Boolean
        {
            COMPILE::SWF
            {
                return _disabled;
            }

            COMPILE::JS
            {
                return button.disabled;
            }
        }
        public function set disabled(value:Boolean):void
        {
            COMPILE::SWF
            {
                _disabled = value;
            }
            COMPILE::JS
            {
                button.disabled = value;
            }
        }

        /**
         *  The button name
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        COMPILE::JS
        public function get name():String
        {
            return button.name;
        }
        COMPILE::JS
        public function set name(value:String):void
        {
            button.name = value;
        }

        COMPILE::SWF
        override public function get name():String
        {
            return super.name;
        }
        COMPILE::SWF
        override public function set name(value:String):void
        {
            super.name = value;
        }

		COMPILE::SWF
        private var _type:String;
        /**
         *  The button type
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function get type():String
        {
            COMPILE::SWF
            {
                return _type;
            }

            COMPILE::JS
            {
                return button.type;
            }
        }
        public function set type(value:String):void
        {
            COMPILE::SWF
            {
                _type = value;
            }
            COMPILE::JS
            {
                button.type = value;
            }
        }

        COMPILE::SWF
        private var _value:String = "";

        /**
         *  The current value of the control
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function get value():String
		{
            COMPILE::SWF
            {
                return _value;
            }
            COMPILE::JS
            {
                return button.value;
            }
		}

		public function set value(value:String):void
		{
            COMPILE::SWF
            {
                _value = value;
            }
            COMPILE::JS
            {
                button.value = value;
            }
		}

        
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this,'button');
        }
    }
}
