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
package org.apache.royale.reflection.utils {
    
    import org.apache.royale.reflection.*;
    
    
    /**
     * 
     * @param memberDefinitions the member definitions to check
     * @param tags the metatags to search for
     * @param intoArray optional external Array to add matching definitions to 
     * @return array of matching members
     */
    public function filterForMetaTags(memberDefinitions:Array, tags:Array, intoArray:Array = null):Array {
        var ret:Array = intoArray ? intoArray : [];
        const l:uint = memberDefinitions.length;
        var tagCount:uint = tags.length;
        for (var i:uint = 0; i< l; i++) {
            var memberDefintion:MemberDefinitionBase = memberDefinitions[i];
            for (var j:uint = 0; j< tagCount; j++) {
                if (memberDefintion.retrieveMetaDataByName(tags[j]).length) {
                    ret.push(memberDefintion);
                    break;
                }
            }
        }
        return ret;
    }
    
    
}
