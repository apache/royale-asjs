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
	 *  The Form class represents an HTML <form> element
     *  
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class Form extends NodeElementBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function Form()
		{
			super();
		}
		
        COMPILE::JS
        private function get form():HTMLFormElement
        {
            return element as HTMLFormElement;
        }


		COMPILE::SWF
        private var _method:String;
        /**
         *  The form method (either "post" or "get")
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function get method():String
        {
            COMPILE::SWF
            {
                return _method;
            }

            COMPILE::JS
            {
                return form.method;
            }
        }
        public function set method(value:String):void
        {
            COMPILE::SWF
            {
                _method = value;
            }
            COMPILE::JS
            {
                form.method = value;
            }
        }

        /**
         *  The form name
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        COMPILE::JS
        public function get name():String
        {
            return form.name;
        }
        COMPILE::JS
        public function set name(value:String):void
        {
            form.name = value;
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
        private var _target:String;
        /**
         *  The form target
         *  Acceptable values are _self _blank _parent _top or an iframe name
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function get target():String
        {
            COMPILE::SWF
            {
                return _target;
            }

            COMPILE::JS
            {
                return form.target;
            }
        }
        public function set target(value:String):void
        {
            COMPILE::SWF
            {
                _target = value;
            }
            COMPILE::JS
            {
                form.target = value;
            }
        }

        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this,'form');
        }
    }
}
