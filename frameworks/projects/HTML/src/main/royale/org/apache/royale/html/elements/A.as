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
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
    }
    import org.apache.royale.html.TextNodeContainerBase;

	/**
	 *  The A(Anchor) class represents an HTML <a> anchor element
     *  
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class A extends TextNodeContainerBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function A()
		{
			super();
		}
		
        private var _href:String;
        /**
         *  the link url
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get href():String
		{
            return _href;   
		}
		public function set href(value:String):void
		{
            _href = value;
            setAttribute('href', value);
		}
        
		private var _target:String = "_self";
        /**
         *  the target attribute. Defaults to "_self"
		 *  Other options "_blank", "_parent", "_top"
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function get target():String
		{
            return _target;   
		}
		public function set target(value:String):void
		{
            _target = value;
            setAttribute('target', value);
		}
		
		private var _rel:String = "";
        /**
         *  The rel attribute specifies the relationship between the current document and the linked document.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function get rel():String
		{
            return _rel;   
		}
		public function set rel(value:String):void
		{
            _rel = value;
            setAttribute('rel', value);
		}
		
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'a');
            // element.setAttribute('href', _href);
            return element;
        }
    }
}
