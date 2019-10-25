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
package flexUnitTests.reflection.support
{
    
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class TestClass6
    {
        //Note: do not change this test class unless you change the related tests to
        //support any changes that might appear when testing reflection into it
    
        public static var myStaticVar:String = 'publicStaticMyVar';
    
        testnamespace static var myStaticVar:String = 'testnamespaceStaticMyVar';
    
        public static function myStaticMethod():String{
            return 'public myStaticMethod';
        }
    
        testnamespace static function myStaticMethod():String{
            return 'testnamespace myStaticMethod';
        }
    
        private static var _vstatic:String = 'public static accessor';
        public static function get myStaticAccessor():String{
            return _vstatic;
        }
    
        private static var _v2static:String = 'testnamespace static accessor';
        testnamespace static function get myStaticAccessor():String{
            return _v2static;
        }
        testnamespace static function set myStaticAccessor(value:String):void{
            _v2static = value;
        }
        
        
        
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
        
        private var _v2:String = 'testnamespace accessor';
        testnamespace function get myAccessor():String{
            return _v2;
        }
        testnamespace function set myAccessor(value:String):void{
            _v2 = value;
        }
        
    }
    
    
}
