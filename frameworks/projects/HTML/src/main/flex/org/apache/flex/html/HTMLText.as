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
package org.apache.flex.html
{
	import org.apache.flex.core.ITextModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
		import org.apache.flex.html.util.addElementToWrapper;
    }

    /**
     *  The HTMLText class implements the basic control for adding
     *  HTML formatted text.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public class HTMLText extends UIBase
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function HTMLText()
		{
			super();
		}

        [Bindable("htmlChange")]
        /**
         *  The html-formatted text to display in the HTMLText.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
                this.dispatchEvent('textChange');
            }
		}

        /**
         *  @private
         */
        COMPILE::SWF
        override public function addedToParent():void
        {
            super.addedToParent();
            model.addEventListener("htmlChange", repeaterListener);
        }

        /**
         * @royaleignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'span');

            className = "HTMLText";
            typeNames = "HTMLText";
            return element;
        }

	}
}
