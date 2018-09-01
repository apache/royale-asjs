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
	import org.apache.royale.core.StyledUIBase;
    import org.apache.royale.core.ITextModel;
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
    }


    /**
     *  The ErrorTip class implements the basic control for displaying
     *  error text.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    public class ErrorTip extends StyledUIBase
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function ErrorTip()
		{
			super();
            typeNames = "jewel errorTip";
            COMPILE::SWF
			{
				mouseEnabled = false;
			}
		}

        COMPILE::JS
        protected var textNode:Text;

        COMPILE::JS
        private var _text:String = "";

        /**
         *  The text to display in the error tip.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get text():String
		{
            COMPILE::SWF
            {
                return ITextModel(model).text;
            }
            COMPILE::JS
            {
                return _text;
            }
		}

        /**
         *  @private
         */
		public function set text(value:String):void
		{
            COMPILE::SWF
            {
                ITextModel(model).text = value;
            }
            COMPILE::JS
            {
                if (textNode)
                {
                    _text = value;
                    textNode.nodeValue = value;
                }
            }

		}

        /**
         *  The html-formatted text to display in the error tip.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get html():String
		{
            COMPILE::SWF
            {
                return ITextModel(model).html;
            }
            COMPILE::JS
            {
                return element.innerHTML;
            }
		}

        /**
         *  @private
         */
		public function set html(value:String):void
        {
            COMPILE::SWF
            {
                ITextModel(model).html = value;
            }
            COMPILE::JS
            {
                this.element.innerHTML = value;
            }
        }

        private var _multiline:Boolean;
        /**
		 *  A boolean flag to activate "multiline" effect selector.
		 *  Allow the error tip to have more than one line if needed
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
        public function get multiline():Boolean
        {
            return _multiline;
        }

        public function set multiline(value:Boolean):void
        {
            if (_multiline != value)
            {
                _multiline = value;
                toggleClass("multiline", _multiline);
            }
        }


        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'div');

            textNode = document.createTextNode(_text) as Text;
            element.appendChild(textNode);
            
            positioner = element;

            positioner.style.position = "absolute";
			positioner.style.pointerEvents = "none";

            return element;
        }

	}
}