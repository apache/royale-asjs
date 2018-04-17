////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "Licens"); you may not use this file except in compliance with
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
package org.apache.royale.utils.cssclasslist
{
    import org.apache.royale.core.IUIBase;
    
    /**
     *  Add one or more class selectors to the component. If the specified class already 
     *  exist, the class will not be added.
     * 
     *  Use of these utility functions should not be mixed with modifying the component's
     *  className property at runtime.  Also the component's className property will not
     *  reflect modifications made with this API.
     *  
     *  @param component The component that will have selectors added or removed.  
     * 
     *  @param value A String with the style (or list of styles separated by an space) to
     *  add to the component.
     *  
     *  @langversion 3.0
     *  @productversion Royale 0.9.3
     *  @royaleignorecoercion HTMLElement
     */
    public function addStyles(component:IUIBase, value:String):void
    {
        COMPILE::JS
        {
            if (value.indexOf(" ") >= 0)
            {
                var classes:Array = value.split(" ");
                var element:HTMLElement = component.element as HTMLElement
                element.classList.add.apply(element.classList, classes);
            } 
            else
            {
                component.element.classList.add(value);
            }
        }
    }

}
