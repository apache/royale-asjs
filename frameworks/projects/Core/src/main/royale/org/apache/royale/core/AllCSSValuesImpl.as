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
package org.apache.royale.core
{
    
    import org.apache.royale.utils.CSSUtils;

    /**
     *  The AllCSSValuesImpl class will eventually implement a full set of
     *  CSS lookup rules.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class AllCSSValuesImpl extends SimpleCSSValuesImpl
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function AllCSSValuesImpl()
		{
			super();
		}
    
        COMPILE::SWF
        override protected function get conditionCombiners() : Object
        {
            if (!_conditionCombiners)
            {
                _conditionCombiners = {};
                _conditionCombiners["class"] = ".";
                _conditionCombiners["id"] = "#";
                _conditionCombiners["pseudo"] = ':';
                _conditionCombiners["pseudo_element"] = '::';
                _conditionCombiners["attribute"] = '[';
            }
            return _conditionCombiners;
        }

        // As new styles are supported, they can be added to the list of style categories
        // that are currently defined within SimpleCSSValuesImpl, and overridden here.
        
        private var _defaultLengthUnit:String = "px";
        /**
         * The default value used when converting numbers in CSS to length units. Can be px, em, etc.
         * Defaults to px
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get defaultLengthUnit():String
        {
        	return _defaultLengthUnit;
        }

        public function set defaultLengthUnit(value:String):void
        {
        	_defaultLengthUnit = value;
        }
        protected var lengthProps:Array = [
            "width",
            "height",
            "top",
            "bottom",
            "margin",
            "padding",
            "borderWidth",
            "fontSize",
            "textShadow"
        ];
        protected function isLengthProp(prop:String):Boolean{
            if(lengthProps.indexOf(prop) != -1){
                return true;
            }
            // margin and padding can have variants
            if(prop.indexOf("margin")== 0){
                return true;
            }
            if(prop.indexOf("padding")== 0){
                return true;
            }
            return false;
        }
        COMPILE::JS
        override protected function processNumberStyle(prop:String,value:*):*{
            if (colorStyles[prop])
                value = CSSUtils.attributeFromColor(value);
            else if (isLengthProp(prop))
                return value + defaultLengthUnit;
            return value;
        }


    }
}
