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
package org.apache.flex.mdl
{
	import org.apache.flex.core.UIBase;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;            
    }

	/**
	 *  The Badge class provides a MDL UI-like appearance for a badge.
	 *  A Badge is an onscreen notification element consists of a small circle, 
     *  typically containing a number or other characters, that appears in 
     *  proximity to another object
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class Badge extends UIBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function Badge()
		{
			super();
		}
		
        private var _type:Number = 0;
        public static const LINK_TYPE:Number = 0;
        public static const TEXT_TYPE:Number = 1;
        public static const CONTAINER_TYPE:Number = 2;

        /**
         *  the type of badge
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get type():Number
		{
            return _type;   
		}

		public function set type(value:Number):void
		{
            _type = value;
            
            COMPILE::JS
            {
                if(value == LINK_TYPE)
                {
                    var link:HTMLElement = document.createElement('a') as HTMLElement;
                    link.setAttribute('href', linkUrl);
                    link.setAttribute('data-badge', dataBadge);
                    link.appendChild(textNode);
                    link.className = 'mdl-badge';
                    
                    element.parentNode.replaceChild(link, element);


                    element = link as WrappedHTMLElement;
                } 
                else if(value == TEXT_TYPE)
                {  
                    var span:HTMLSpanElement = document.createElement('span') as HTMLSpanElement;
                    span.setAttribute('data-badge', dataBadge);
                    span.appendChild(textNode); 
                    span.className = 'mdl-badge';

                    element.parentNode.replaceChild(span, element);
                    
                    element = span as WrappedHTMLElement;
                } 
                else if(value == CONTAINER_TYPE)
                {
                    var div:HTMLDivElement = document.createElement('div') as HTMLDivElement;
                    div.setAttribute('data-badge', dataBadge);
                    div.appendChild(textNode); 
                    div.className = 'mdl-badge material-icons';

                    element.parentNode.replaceChild(div, element);
                    
                    element = div as WrappedHTMLElement;
                }
                
                positioner = element;
                positioner.style.position = 'relative';
                element.flexjs_wrapper = this;
                
            }
		}

        private var _text:String = "";

        /**
         *  The text of the link
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
                return _text;
            }
            COMPILE::JS
            {
                return textNode.nodeValue;
            }
		}

		public function set text(value:String):void
		{
            COMPILE::SWF
            {
                _text = value;
            }
            COMPILE::JS
            {
                textNode.nodeValue = value;
            }
		}
        
        private var _linkUrl:String = "#";

        /**
         *  the link url
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get linkUrl():String
		{
            return _linkUrl;   
		}

		public function set linkUrl(value:String):void
		{
            _linkUrl = value;
            
            COMPILE::JS
            {
                (element as HTMLElement).setAttribute('href', value);
            }
		}


        private var _dataBadge:Number = 0;

		/**
		 *  The current value of the Badge that appers inside the circle.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get dataBadge():Number
		{
			return _dataBadge;
		}
		public function set dataBadge(value:Number):void
		{
			_dataBadge = value;

			COMPILE::JS
			{
				(element as HTMLElement).setAttribute('data-badge', _dataBadge.toString());
			}
		}
		
        COMPILE::JS
        private var textNode:Text;
		
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 * @flexjsignorecoercion HTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			var a:HTMLElement = document.createElement('a') as HTMLElement;
            a.setAttribute('href', linkUrl);
            a.setAttribute('data-badge', dataBadge);

            textNode = document.createTextNode('') as Text;
            a.appendChild(textNode); 

			element = a as WrappedHTMLElement;
            
            positioner = element;
            positioner.style.position = 'relative';
			element.flexjs_wrapper = this;
            
            className = typeNames = 'mdl-badge';

            return element;
        }
    }
}
