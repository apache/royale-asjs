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

package mx.rpc.xml
{
    
    [ExcludeClass]
    
    /**
     * This internal utility class is used by SimpleXMLDecoder. The class is
     * basically a dynamic version of the String class (other properties can be
     * attached to it).
     *
     * When you try to get the value of a ComplexString, we attempt to convert the
     * value to a number or boolean before returning it.
     *
     * @private
     */
    internal dynamic class ComplexString
    {
        public var value:String;
        
        public function ComplexString(val:String)
        {
            super();
            value = val;
        }
        
        public function toString():String
        {
            return value;
        }
        
        COMPILE::JS {override}
        public function valueOf():*
        {
            return SimpleXMLDecoder.simpleType(value);
        }
    }
    
}
