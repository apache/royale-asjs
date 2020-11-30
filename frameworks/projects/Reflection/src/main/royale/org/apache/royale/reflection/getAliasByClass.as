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
package org.apache.royale.reflection {


COMPILE::SWF {
    import flash.utils.describeType;
}
/**
     * Retrieves a an alias for a class, based on an alias mapping, previously registered with
     * registerClassAlias, or possibly using [RemoteClass(alias='someAlias')] metadata
     *
     * @param classObject the class to retrieve the alias for
     * @return the most recently mapped alias, if found otherwise null
     */
    public function getAliasByClass(classObject:Class):String {
        var ret:String;
        if (classObject == null) throw new TypeError("Parameter classObject must be non-null.");
        COMPILE::SWF {
            ret= flash.utils.describeType(classObject).@alias;
            if (ret.length==0) ret = null;
        }

        COMPILE::JS {
            var info:* = classObject.prototype.ROYALE_CLASS_INFO;
            if (!info && ExtraData.hasData(classObject)) {
                info = ExtraData.getData(classObject)['ROYALE_CLASS_INFO'];
            }
            if (info) {
                ret = info.alias;
                if (ret == '') ret = null;
            } else ret=null;
        }
        return ret;
    }
}
