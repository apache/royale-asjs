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
    public class TestClass4 extends TestClass2
    {
        //Note: do not change this test class unless you change the related tests to
        //support any changes that might appear when testing reflection into it
        
        public function TestClass4()
        {
            super("");
        }
        
        
        [TestMeta(foo="instanceMethod")]
        public function testMethod2():void
        {
        
        }
        
        [TestMeta(foo="instanceMethod")]
        public function testMethodWithArgs2(mandatory:String, optional:Boolean = true):void
        {
        
        }
        
        [TestMeta(foo="instanceVariable")]
        public var testVar2:String;
        
        [TestMeta(foo="instanceAccessor")]
        public function get testReadonly2():String
        {
            return null
        }
        
        [TestMeta(foo="instanceAccessor")]
        public function set testWriteonly2(value:String):void
        {
        
        }
        
        [TestMeta(foo="instanceAccessor")]
        public function get testReadeWrite2():String
        {
            return null
        }
        
        public function set testReadeWrite2(value:String):void
        {
        
        }
        
        [TestMeta(foo="staticMethod")]
        public static function testStaticMethod():void
        {
        }
        
        [TestMeta(foo="staticMethod")]
        public static function testStaticMethodWithArgs(mandatory:String, optional:Boolean = true):void
        {
        }
        
        [TestMeta(foo="staticVariable")]
        public static var testStaticVar:String;
        
        [TestMeta(foo="staticAccessor")]
        public static function get testStaticReadonly():String
        {
            return null
        }
        
        [TestMeta(foo="staticAccessor")]
        public static function set testStaticWriteonly(value:String):void
        {
        
        }
        
        [TestMeta(foo="staticAccessor")]
        public static function get testStaticReadeWrite():String
        {
            return null
        }
        
        public static function set testStaticReadeWrite(value:String):void
        {
        
        }
        
    }
}
