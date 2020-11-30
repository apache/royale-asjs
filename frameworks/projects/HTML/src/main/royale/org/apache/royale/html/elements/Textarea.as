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
	 *  The Textarea class represents an HTML <textarea> element
     *  
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class Textarea extends NodeElementBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function Textarea()
		{
			super();
		}
		
		/**
		 * @royaleignorecoercion HTMLTextAreaElement
		 */
        COMPILE::JS
        private function get textarea():HTMLTextAreaElement
        {
            return element as HTMLTextAreaElement;
        }

		COMPILE::SWF
        private var _autofocus:Boolean;
        /**
         *  Whether the textarea is autofocused
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
                return textarea.autofocus;
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
                textarea.autofocus = value;
            }
        }

		COMPILE::SWF
        private var _cols:uint = 20;
        /**
         *  Width of textarea in (average) character widths
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function get cols():uint
        {
            COMPILE::SWF
            {
                return _cols;
            }

            COMPILE::JS
            {
                return textarea.cols;
            }
        }
        public function set cols(value:uint):void
        {
            COMPILE::SWF
            {
                _cols = value;
            }
            COMPILE::JS
            {
                textarea.cols = value;
            }
        }

		COMPILE::SWF
        private var _rows:uint;
        /**
         *  Number of visible lines
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function get rows():uint
        {
            COMPILE::SWF
            {
                return _rows;
            }

            COMPILE::JS
            {
                return textarea.rows;
            }
        }
        public function set rows(value:uint):void
        {
            COMPILE::SWF
            {
                _rows = value;
            }
            COMPILE::JS
            {
                textarea.rows = value;
            }
        }

		COMPILE::SWF
        private var _disabled:Boolean;
        /**
         *  Whether the textarea is disabled
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
                return textarea.disabled;
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
                textarea.disabled = value;
            }
        }

        /**
         *  The textarea name
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        COMPILE::JS
        public function get name():String
        {
            return textarea.name;
        }
        COMPILE::JS
        public function set name(value:String):void
        {
            textarea.name = value;
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

        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this,'textarea');
        }
    }
}
