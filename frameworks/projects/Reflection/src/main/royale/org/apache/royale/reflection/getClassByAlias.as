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
    import flash.net.getClassByAlias;
}
/**
     * Retrieves a class based on an alias mapping, previously registered with
     * registerClassAlias, or possibly using [RemoteClass(alias='someAlias')] metadata
     *
     * @param aliasName the alias name to use to look up the class definition
     * @return the class definition that has been mapped to by the registered
     *         alias, or null if no alias mapping exists.
     */
    public function getClassByAlias(aliasName:String):Class {
        COMPILE::SWF {
            return flash.net.getClassByAlias(aliasName);
        }

        COMPILE::JS {
            if (aliasName == null) throw new TypeError("Parameter aliasName must be non-null.");
            if (aliasName.length==0) throw new TypeError("Parameter aliasName must be non-empty string.");
            try
            {
                var klazz:Class = TypeDefinition.getClassByAlias(aliasName);
            }
            catch (e:Error)
            {
                throw new ReferenceError("Class "+aliasName+" could not be found.");
            }
            return klazz;
        }
    }
}
