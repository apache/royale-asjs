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
    }

	/*
	 *  Label probably should extend TextField directly,
	 *  but the player's APIs for TextLine do not allow
	 *  direct instantiation, and we might want to allow
	 *  Labels to be declared and have their actual
	 *  view be swapped out.
	 */

    /**
     *  The Label class implements the basic control for labeling
     *  other controls.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */    
    public class Label extends UIBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function Label()
		{
			super();
		}
		
        [Bindable("textChange")]
        /**
         *  The text to display in the label.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get text():String
		{
            COMPILE::SWF
            {                    
                return ITextModel(model).text;
            }
            COMPILE::JS
            {
                return element.innerHTML;
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
                this.element.innerHTML = value;
                this.dispatchEvent('textChange');                
            }

		}
		
        [Bindable("htmlChange")]
        /**
         *  The html-formatted text to display in the label.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
            model.addEventListener("textChange", repeaterListener);
            model.addEventListener("htmlChange", repeaterListener);
        }
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            element = document.createElement('span') as WrappedHTMLElement;
            positioner = element;
            element.flexjs_wrapper = this;
            element.style.whiteSpace = "nowrap";
            return element;
        }        

	}
}
