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
package org.apache.royale.debugging
{

    /**
     * If this method has been called with forObject previously, this method returns true, otherwise if this is the first time,
     * it returns false
     */
    public function alreadyRecorded(forObject:Object):Boolean
    {
        var recorded:Boolean = true;
        COMPILE::SWF
        {
             if (!map[forObject])  {
                 map[forObject] = true;
                 recorded = false;
             }
        }
        COMPILE::JS
        {
           if (!map.has(forObject)) {
               map.set(forObject, true);
               recorded = false;
           }
        }

        return recorded;
    }
}

COMPILE::SWF{
    import flash.utils.Dictionary;
}


COMPILE::JS
var map:WeakMap = new WeakMap();


COMPILE::SWF
var map:Dictionary = new Dictionary(true)
