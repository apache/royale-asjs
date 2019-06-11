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
package flexUnitTests.language
{
    
    
    import flexunit.framework.Assert;
    
    import flexUnitTests.language.support.*;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class LanguageTesterIntUint
    {
        
        public static var isJS:Boolean;
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
            var js:Boolean;
            COMPILE::JS {
                js = true;
            }
            isJS = js;
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
        }
        
        [Before]
        public function setUp():void
        {
        
        }
        
        [After]
        public function tearDown():void
        {
        }
        
        
        [Test]
        public function testNumerics():void
        {
            var val1:Number = 2.5;
            var val2:Number = 2;
            var var3:String = '';
            var var4:String = '0';
            var var5:String = '2';
            
            var clazz:Class = int;
            var intVal:int = (val1 as int);
            Assert.assertTrue('Unexpected int check', intVal == 0);
            
            intVal = (var3 as int);
            Assert.assertTrue('Unexpected int check', intVal == 0);
            intVal = (var4 as int);
            Assert.assertTrue('Unexpected int check', intVal == 0);
            intVal = (var5 as int);
            Assert.assertTrue('Unexpected int check', intVal == 0);
            
            intVal = int(var3);
            Assert.assertTrue('Unexpected int check', intVal == 0);
            intVal = int(var4);
            Assert.assertTrue('Unexpected int check', intVal == 0);
            intVal = int(var5);
            Assert.assertTrue('Unexpected int check', intVal == 2);
            
            intVal = new int(var3);
            Assert.assertTrue('Unexpected int check', intVal == 0);
            intVal = new int(var4);
            Assert.assertTrue('Unexpected int check', intVal == 0);
            intVal = new int(var5);
            Assert.assertTrue('Unexpected int check', intVal == 2);
            
            
            Assert.assertFalse('int check should be false', val1 is int);
            Assert.assertTrue('int check should be true', val2 is int);
            
            Assert.assertFalse('uint check should be false', val1 is uint);
            Assert.assertTrue('uint check should be true', val2 is uint);
            
            var dyn:* = new clazz();
            
            Assert.assertTrue('Unexpected int check', dyn == 0);
            Assert.assertTrue('Unexpected int check', dyn === 0);
            
            
            Assert.assertTrue('random check', int === int);
            
            Assert.assertTrue('Unexpected int check', new clazz(3.5) == 3);
            
            Assert.assertFalse('Unexpected int check', dyn !== 0);
            dyn = new clazz(3.5);
            intVal = dyn;
            Assert.assertTrue('Unexpected int check', intVal === 3);
            Assert.assertTrue('Unexpected int check', new clazz(3.5) === 3);
            
            //extra indirection
            var dynInt:* = var5;
            
            Assert.assertFalse('Unexpected int check', dynInt is clazz);
            Assert.assertNull('Unexpected int check', dynInt as clazz);
            Assert.assertTrue('Unexpected int check', clazz(dynInt) === 2);
        }
        
        
        [Test]
        public function testUntypedMath():void
        {
            var val:int = 30;
            var c:Class = int;
            var untyped:* = val;
            var untyped2:* = new c(30);
            var untyped3:Object = new c(30);
            Assert.assertTrue('Unexpected int check', untyped3 == 30);
            Assert.assertTrue('Unexpected int check', untyped3 === 30);
            
            val += 1.5;
            untyped += 1.5;
            untyped2 += 1.5;
            Assert.assertTrue('Unexpected int check', val == 31);
            Assert.assertTrue('Unexpected int check', val === 31);
            
            Assert.assertTrue('Unexpected int check', untyped == 31.5);
            Assert.assertTrue('Unexpected int check', untyped === 31.5);
            
            Assert.assertTrue('Unexpected int check', untyped2 == 31.5);
            Assert.assertTrue('Unexpected int check', untyped2 === 31.5);
            
            untyped = new Number(30);
            Assert.assertTrue('Unexpected Number check', untyped == 30);
            Assert.assertTrue('Unexpected Number check', untyped === 30);
            
            var numClass:Class = Number;
            untyped = new numClass(30);
            Assert.assertTrue('Unexpected Number check', untyped == 30);
            Assert.assertTrue('Unexpected Number check', untyped === 30);
            Assert.assertTrue('Unexpected Number check', 30 === untyped);
            
            untyped += 1.5;
            Assert.assertTrue('Unexpected Number check', untyped == 31.5);
            Assert.assertTrue('Unexpected Number check', untyped === 31.5);
            
        }
        
    }
}
