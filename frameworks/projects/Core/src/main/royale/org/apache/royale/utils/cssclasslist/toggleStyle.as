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
     *  Adds or removes a single style (class selector name). 
     * 
     *  Use of these utility functions should not be mixed with modifying the component's
     *  className property at runtime.  Also the component's className property will not
     *  reflect modifications made with this API.
     * 
     *  @param component The component that will have selectors added or removed.  
     * 
     *  @param value If the selector name exists it is removed and the return value is false.
     *  If the style does not exist, it is added to the element, and the return value is true.
     * 
     *  @param force A Boolean value that forces the class to be added 
     *  or removed, regardless of whether or not it already existed.
     * 
     *  @langversion 3.0
     *  @productversion Royale 0.9.3
     */
    public function toggleStyle(component:IUIBase, value:String, force:Boolean = false):Boolean
    {
        COMPILE::JS
        {
            return component.element.classList.toggle(value, force);
        }
        COMPILE::SWF
        {
            // TODO (aharui) SWF Implementation
            return true;
        }
    }
}
