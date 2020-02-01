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
package org.apache.royale.utils.css
{
    import org.apache.royale.core.IUIBase;
    
    /**
     *  Adds a CSS selector dynamically at runtime.
     *  
     *  @param selector The CSS selector.
     * 
     *  @param rule The CSS rule to apply.
     *  
     *  @langversion 3.0
     *  @productversion Royale 0.9.3
     *  @royalesuppressexport
     *  @royaleignorecoercion CSSStyleSheet
	 *  @royaleignorecoercion HTMLStyleElement
     */
    public function addDynamicSelector(selector:String, rule:String):void
    {
        COMPILE::JS
        {
            var selectorString:String = selector + ' { ' + rule + ' }';
            var element:HTMLStyleElement = document.getElementById("royale_dynamic_css") as HTMLStyleElement;
            if(element)
            {
                var sheet:CSSStyleSheet = element.sheet as CSSStyleSheet;
                //for 'insertRule' below, the index (2nd) argument is not optional in IE11, but is optional for modern browsers (with default value 0)
                sheet.insertRule(selectorString, 0);
            }
            else
            {
                var style:HTMLStyleElement = document.createElement('style') as HTMLStyleElement;
                style.type = 'text/css';
                style.id = "royale_dynamic_css";
                style.innerHTML = selectorString;
                document.getElementsByTagName('head')[0].appendChild(style);
            }
        }
    }

}
