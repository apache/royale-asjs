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
package flexUnitTests.network.support
{
   
    import flexUnitTests.network.support.testnamespace;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class TestClass6
    {
        //Note: do not change this test class unless you change the related tests to
        //support any changes that might appear when testing reflection into it
        
        public function TestClass6()
        {
        
        }
        
        
        public var myVar:String = 'publicMyVar';
        
        testnamespace var myVar:String = 'testnamespaceMyVar';
        
        public function myMethod():String{
            return 'public myMethod';
        }
    
        testnamespace function myMethod():String{
            return 'testnamespace myMethod';
        }
    
        private var _v:String = 'public accessor';
        public function get myAccessor():String{
            return _v;
        }
    
        public function set myAccessor(value:String):void{
            _v = value;
        }
        
        private var _v2:String = 'testnamespace accessor';
        testnamespace function get myAccessor():String{
            return _v2;
        }
    
        testnamespace function set myAccessor(value:String):void{
            _v2 = value;
        }
        
        
    }
    
    
}
