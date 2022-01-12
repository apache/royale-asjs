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
package {
    /**
     * Caution - this is for advanced use only and will easily cause problems if used incorrectly.
     * This specific static method has special treatment by the compiler.
     * It should only ever be 'called' with a String literal as an argument.
     * The String literal is then output by the compiler as-is, inline, as native javascript code.
     *
     * Example (not realistic):
     * var f:Function = jsUnsafeNativeInline("function(a){console.log(a)}");
     *
     *  @langversion 3.0
     *  @productversion Royale 0.9.9
     */
    public function jsUnsafeNativeInline(script:String):*{
        throw new Error('This should never appear in code or execute');
    }
    
}
