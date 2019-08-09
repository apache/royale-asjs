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
    
    
    [TestMeta(foo="class")]
    /**
     * @royalesuppresspublicvarwarning
     */
    public class TestClass2
    {
        //Note: do not change this test class unless you change the related tests to
        //support any changes that might appear when testing reflection into it
        
        public function TestClass2(blah:String)
        {
        
        }
        
        
        [TestMeta(foo="instanceMethod")]
        public function testMethod():void
        {
            _testReadWrite = "testMethod was called";
        }
        
        [TestMeta(foo="instanceMethod")]
        public function testMethodWithArgs(mandatory:String, optional:Boolean = true):Boolean
        {
            _testReadWrite = "testMethodWithArgs was called";
            return optional;
        }
        
        [TestMeta(foo="instanceVariable")]
        public var testVar:String = "testVar_val";
        
        [TestMeta(foo="instanceAccessor")]
        public function get testReadOnly():String
        {
            return _testReadWrite
        }
        
        [TestMeta(foo="instanceAccessor")]
        public function set testWriteOnly(value:String):void
        {
            _testReadWrite = value;
        }
        
        [TestMeta(foo="instanceAccessor")]
        public function get testReadWrite():String
        {
            return _testReadWrite
        }
        
        public function set testReadWrite(value:String):void
        {
            _testReadWrite = value;
        }
        
        [TestMeta(foo="staticMethod")]
        public static function testStaticMethod():void
        {
            _testStaticReadWrite = "testStaticMethod was called";
        }
        
        [TestMeta(foo="staticMethod")]
        public static function testStaticMethodWithArgs(mandatory:String, optional:Boolean = true):Boolean
        {
            _testStaticReadWrite = "testStaticMethodWithArgs was called";
            return optional;
        }
        
        [TestMeta(foo="staticVariable")]
        public static var testStaticVar:String = "testStaticVar_val";
        
        [TestMeta(foo="staticAccessor")]
        public static function get testStaticReadOnly():String
        {
            return _testStaticReadWrite
        }
        
        [TestMeta(foo="staticAccessor")]
        public static function set testStaticWriteOnly(value:String):void
        {
            _testStaticReadWrite = value;
        }
        
        [TestMeta(foo="staticAccessor")]
        public static function get testStaticReadWrite():String
        {
            return _testStaticReadWrite;
        }
        
        public static function set testStaticReadWrite(value:String):void
        {
            _testStaticReadWrite = value;
        }
        
        
        private static var _testStaticReadWrite:String = "staticAccessor_initial_value";
        private var _testReadWrite:String = "instanceAccessor_initial_value";
    }
}
