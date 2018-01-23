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
    COMPILE::JS
    {
        import goog.DEBUG;
    }

    /**
     * Throws an error if the object is null.
     */
    public function notNull(obj:Object):void
    {
        COMPILE::SWF
        {
            if(obj == null)
                throw new Error("null not allowed");
        }
        COMPILE::JS
        {
            if(goog.DEBUG && obj == null)
            {
                var name:String = obj === null ? "null" : "undefined"
                throw new Error(name +" not allowed");

            }
        }
    }
}
