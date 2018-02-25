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
package org.apache.royale.html.util
{
    import org.apache.royale.utils.StringTrimmer;

    /**
     * Adding or replacing css class in provided className.
     *
     * @param className The value of components className
     * @param newName New css class name which will be added or replace the old one in className
     * @param oldName Old css class name which will be replaced by newName
     *
     * @return The resulting className with added or replaced css class specified by newName
     */
    public function addOrReplaceClassName(className:String, newName:String, oldName:String = null):String
    {
        if (!newName)
        {
            return className;
        }

        if (newName && oldName && className)
        {
            var trimmedOldName:String = StringTrimmer.trim(oldName);
            if (className.indexOf(trimmedOldName) > -1)
            {
                return className.replace(trimmedOldName, StringTrimmer.trim(newName));
            }
            else
            {
                return className += " " + StringTrimmer.trim(newName);
            }
        }

        var isClassNameEmpty:Boolean = !className;

        if (isClassNameEmpty || !oldName)
        {
            if (isClassNameEmpty) className = "";

            return className += " " + StringTrimmer.trim(newName);
        }

        return className;
    }
}
