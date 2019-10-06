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
    dynamic public class DynamicTestClass
    {
        //Note: do not change this test class unless you change the related tests to
        //support any changes that might appear when testing reflection into it
        
        /*public function DynamicTestClass(){
        
        }*/
        
        
        [TestMeta(foo="instanceMethod")]
        public function method():void
        {
        
        }
        
        [TestMeta(foo="instanceMethod")]
        public function methodWithArgs(mandatory:String, optional:Boolean = true):void
        {
            _test = mandatory;
        }
        
        [TestMeta(foo="instanceVariable")]
        public var testVar:String;
        
        [TestMeta(foo="instanceAccessor")]
        public function get testGetter():String
        {
            return null
        }
        
        [TestMeta(foo="instanceAccessor")]
        public function set testSetter(value:String):void
        {
        
        }
        
        private var _test:String;
        
        [TestMeta(foo="staticMethod")]
        public static function method():void
        {
        }
        
        [TestMeta(foo="staticMethod")]
        public static function methodWithArgs(mandatory:String, optional:Boolean = true):void
        {
        }
        
        [TestMeta(foo="staticVariable")]
        public static var testVar:String;
        
        [TestMeta(foo="staticAccessor")]
        public static function get testGetter():String
        {
            return null
        }
        
        [TestMeta(foo="staticAccessor")]
        public static function set testSetter(value:String):void
        {
        
        }
        
        private var private_var:Boolean;
        
        protected var protected_var:Boolean;
        
        private static var private_var:Boolean;
        
        protected static var protected_var:Boolean;
        
    }
}
