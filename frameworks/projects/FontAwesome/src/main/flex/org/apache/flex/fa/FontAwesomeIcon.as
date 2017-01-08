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
package org.apache.flex.fa
{
    import org.apache.flex.core.UIBase;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;            
    }

    /**
     *  Provide common features for all FontAwesome icons type
	 *  Usage example:
	 *  <fa:FontAwesomeIcon iconType="{FontAwesomeIconType.TWITTER}" />
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
	 *
	 *
     */
    public class FontAwesomeIcon extends UIBase
    {
        /**
         *  constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         *
         *  @flexjsignorecoercion HTMLElement
		 * <inject_html>
		 *     <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
		 * </inject_html>		 
         */
        public function FontAwesomeIcon()
        {
            super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
        }

        COMPILE::JS
        protected var textNode:Text;
		protected var _iconType:String;
		protected var _size:String;
        protected var _fixedWidth:Boolean;

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 * @flexjsignorecoercion HTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "fa";

			var i:HTMLElement = document.createElement('i') as HTMLElement;
            
            textNode = document.createTextNode(iconType) as Text;
			textNode.textContent = '';
            i.appendChild(textNode); 

			element = i as WrappedHTMLElement;
            
            positioner = element;
			element.flexjs_wrapper = this;
            
            return element;
        }

        public function get iconType():String
        {
            return _iconType;
        }
		
		public function set iconType(value:String):void
		{
			COMPILE::JS
            {
                element.classList.remove(value);
            }

            _iconType = value;

            COMPILE::JS
            {
                element.classList.add(_iconType);
            }
		}
		
		
        public function get size():String
        {
            return _size;
        }
		
		public function set size(value:String):void
        {
            COMPILE::JS
            {
                element.classList.remove(value);
            }

            _size = value;

            COMPILE::JS
            {
                element.classList.add(value);
            }
        }

        public function get fixedWidth():Boolean
        {
            return _fixedWidth;
        }

        public function set fixedWidth(value:Boolean):void
        {
            _fixedWidth = value;
            COMPILE::JS
            {
                element.classList.toggle('fa-fw',_fixedWidth);
            }
        }
		
    }
}
