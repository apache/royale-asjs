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
	import org.apache.flex.core.ContainerBase;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;            
    }
	
    /**
     *  The Menu class creates a MDL menu
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */    
	public class Menu extends ContainerBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function Menu()
		{
			super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
        }
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-menu mdl-js-menu mdl-menu--top-left";

            element = document.createElement('ul') as WrappedHTMLElement;
            
            positioner = element;
            element.flexjs_wrapper = this;
            
            return element;
        }

        private var _dataMdlFor:String;

		/**
		 *  The id value of the associated button that opens this menu.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get dataMdlFor():String
		{
			return _dataMdlFor;
		}
		public function set dataMdlFor(value:String):void
		{
			_dataMdlFor = value;

            COMPILE::JS
            {
                element.setAttribute('for', dataMdlFor);
            }
		}

        protected var _ripple:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-js-ripple-effect" effect selector.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get ripple():Boolean
        {
            return _ripple;
        }
        public function set ripple(value:Boolean):void
        {
            _ripple = value;

            className += (_ripple ? " mdl-js-ripple-effect" : "");
        }     

	}
}
