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
    
    
    /**
     * This is purely a convenience class for use of the constants in the utility methods
     * in this package which support bitwise selection of subsets of member types that they return
     * it is:
     * a) not reflectable in javascript output
     * and
     * b) using these constants does not create a dependency on the class itself in javascript output.
     *
     * @royalesuppressexport
     */
    public class MemberTypes {
        
        public static const VARIABLES:uint = 1;
        public static const ACCESSORS:uint = 2;
        public static const METHODS:uint = 4;
        public static const STATIC_ONLY:uint = 8;
    }
    
    
}
