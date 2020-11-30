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
    
    import org.apache.royale.reflection.TypeDefinition;
    
    [RemoteClass(alias="TestClass1_alias")]
    /**
     * @royalesuppresspublicvarwarning
     */
    public class TestClass1 implements ITestInterface
    {
        public function TestClass1(somethingElse:ITestInterface = null)
        {

        }
        
        [Bindable]
        [Event(name="foo", type="org.apache.royale.events.Event")]
        public var bindableVar:String;
        
        [Event(name="foo", type="org.apache.royale.events.Event")]
        public var temp:Boolean;
        
        public static var tempStatic:Boolean;
        
        public var typeDef:TypeDefinition;
        
        public var testVar:String = "testVar_val";
        
        public static var staticTestVar:String = "statictestVar_val";
        
        private var _atestval:String = "accessorTest_val";
        
        public function get accessorTest():String
        {
            return _atestval;
        }
        
        public function set accessorTest(val:String):void
        {
            _atestval = val;
        }
        
        private static var _staticAtestval:String = "staticAccessorTest_val";
        
        public static function get staticAccessorTest():String
        {
            return _staticAtestval;
        }
        
        public static function set staticAccessorTest(val:String):void
        {
            _staticAtestval = val;
        }
        
        [Bindable]
        public static var bindableStaticVar:String;
        
        [Bindable]
        public var bindableInstanceVar:String;
        
        
        public function someMethod(compulsoryArg:int, optArg:String = null):TestClass1
        {
            return null;
        }
        
        public static function someStaticMethod(compulsoryArg:int, optArg:String = null):TestClass1
        {
            return null;
        }
        
        public function get testAccessorType():TypeDefinition
        {
            return null;
        }
        
        public const instanceConstant:String = "instanceConstant_val";
        
        
        public static const staticConstant:String = "staticConstant_val";
        
        
    }
}
