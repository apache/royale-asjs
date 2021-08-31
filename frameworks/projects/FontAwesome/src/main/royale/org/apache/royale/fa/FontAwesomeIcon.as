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
package org.apache.royale.fa
{
    COMPILE::JS
    {
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
    }
    import org.apache.royale.core.UIBase;

    /**
     *  Provide common features for all FontAwesome icons type
	 *  Usage example:
	 *  <fa:FontAwesomeIcon iconType="{FontAwesomeIconType.TWITTER}" />
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
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
         *  @productversion Royale 0.0
         *
         *  @royaleignorecoercion HTMLElement
		 * <inject_script>
		 *     var link = document.createElement("link");
		 *     link.setAttribute("rel", "stylesheet");
		 *     link.setAttribute("type", "text/css");
		 *     link.setAttribute("href", "http://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css");
		 *     document.head.appendChild(link);
		 * </inject_script>		 
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
        protected var _showBorder:Boolean;
        protected var _rotation:String;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "fa";

			var i:WrappedHTMLElement = addElementToWrapper(this,'i');
            
            textNode = document.createTextNode(iconType) as Text;
			textNode.textContent = '';
            i.appendChild(textNode);
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

        /**
         *  To increase icon sizes relative to their container,
         *  use the X1 (33% increase), X2, X3, X4, or X5.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *
         */
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

        /**
         *
         *  Set icons at a fixed width.
         *  Great to use when different icon widths throw off alignment.
         *  Especially useful in things like nav lists & list groups.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *
         */
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

        /**
         *  Show a border around the icon
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *
         */
        public function get showBorder():Boolean
        {
            return _showBorder;
        }

        public function set showBorder(value:Boolean):void
        {
            _showBorder = value;
            COMPILE::JS
            {
                element.classList.toggle('fa-border',_showBorder)
            }
        }

        /**
         *  Rotate icon
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *
         */
        COMPILE::JS
        public function get rotation():String
        {
            return _rotation;
        }

        COMPILE::JS
        public function set rotation(value:String):void
        {
            COMPILE::JS
            {
                element.classList.remove(value)
            }

            _rotation = value;

            COMPILE::JS
            {
                element.classList.add(value)
            }
        }
		
    }
}
