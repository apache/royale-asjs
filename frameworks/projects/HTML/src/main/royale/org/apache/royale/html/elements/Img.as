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
	 *  The Img class represents an HTML <img> element
     *  
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class Img extends NodeElementBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function Img()
		{
			super();
		}

        private var _src:String;
        /**
         *  The img src
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function get src():String
        {
            COMPILE::SWF
            {
                return _src;
            }
            COMPILE::JS
            {
                return (element as HTMLImageElement).src;
            }
        }
        public function set src(value:String):void
        {
            COMPILE::SWF
            {
                _src = value;
            }

            COMPILE::JS
            {
                (element as HTMLImageElement).src = value;
            }
        }

        private var _alt:String;
        /**
         *  The img alt
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function get alt():String
        {
            COMPILE::SWF
            {
                return _alt;
            }
            COMPILE::JS
            {
                return (element as HTMLImageElement).alt;
            }
        }
        public function set alt(value:String):void
        {
            COMPILE::SWF
            {
                _alt = value;
            }

            COMPILE::JS
            {
                (element as HTMLImageElement).alt = value;
            }
        }		

        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this,'img');
        }
    }
}
