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
    import org.apache.flex.html.TextButton;            
    
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }
    
    /**
     *  The Button class provides a Material Design Library UI-like appearance for
     *  a Button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class Button extends TextButton
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function Button()
		{
			super();
		}

        /**
		 * @private
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
            element = document.createElement('button') as WrappedHTMLElement;
            //element.setAttribute('type', 'button');
            
            positioner = element;
            positioner.style.position = 'relative';
            element.flexjs_wrapper = this;

            element.className = 'mdl-button mdl-js-button';
			className = "";
			typeNames = "MDLButton";
			return element;
		}

        public static const RAISED_EFFECT:String = "mdl-button--raised";
        public static const FAB_EFFECT:String = "mdl-button--fab";
        public static const MINI_FAB_EFFECT:String = "mdl-button--mini-fab";
        public static const ICON_EFFECT:String = "mdl-button--icon";
        public static const COLORED_EFFECT:String = "mdl-button--colored";
        public static const PRIMARY_EFFECT:String = "mdl-button--primary";
        public static const ACCENT_EFFECT:String = "mdl-button--accent";
        public static const RIPPLE_EFFECT:String = "mdl-js-ripple-effect";

        private var _mdlEffect:String = "";

        public function get mdlEffect():String
        {
            return _mdlEffect;
        }
        
        public function set mdlEffect(value:String):void
        {
            _mdlEffect = value;
            COMPILE::JS 
            {
                element.className = 'mdl-button mdl-js-button ' + _mdlEffect;
            }
        }
	}
}
