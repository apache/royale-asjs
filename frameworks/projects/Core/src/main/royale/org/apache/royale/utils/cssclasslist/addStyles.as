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
     *  Add one or more styles to the component. If the specified class already 
     *  exist, the class will not be added.
     *  
     *  @param value, a String with the style (or styles separated by an space) to
     *  add from the component. If the string is empty doesn't perform any action
     *  
     *  @langversion 3.0
     *  @productversion Royale 0.9.3
     */
    public function addStyles(wrapper:IUIBase, value:String):void
    {
        if (value == "") return;
        
        if (value.indexOf(" ") >= 0)
        {
            var classes:Array = value.split(" ");
            wrapper.element.classList.add.apply(wrapper.element.classList, classes);
        } else
        {
            wrapper.element.classList.add(value);
        }
    }

}
