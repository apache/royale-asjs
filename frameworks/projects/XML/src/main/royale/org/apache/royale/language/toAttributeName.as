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
package org.apache.royale.language
{

   
    COMPILE::JS
     /**
     *
     * @royaleignorecoercion QName
     * @royalesuppressexport
     */
    [Exclude]
    public function toAttributeName(name:*):QName
    {
        const typeName:String = typeof name;
        if (name == null || typeName == 'number'|| typeName == 'boolean') {
            throw new TypeError('invalid xml name');
        }

        var qname:QName;
        //@todo: typeName == 'object' && ... className=='QName' etc here (avoid Language.is)
        if (name is QName) {
            if (QName(name).isAttribute) qname = name as QName;
            else {
                qname = new QName(name);
                qname.setIsAttribute(true);
            }
        } else {
            var str:String = name.toString();
            //normalize
            var idx:int = str.indexOf('@');
            if (idx != -1) str = str.slice(idx+1);
            qname = new QName(str);
            qname.setIsAttribute(true);
        }
        return qname;
    }
}
