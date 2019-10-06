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
    
    
    import org.apache.royale.test.asserts.*;
    
    import flexUnitTests.language.support.*;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class LanguageTesterIntUint
    {
    
        public static var isJS:Boolean = COMPILE::JS;
    
    
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
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
            assertTrue( intVal == 0,'Unexpected int check');
            
            intVal = (var3 as int);
            assertTrue( intVal == 0,'Unexpected int check');
            intVal = (var4 as int);
            assertTrue( intVal == 0,'Unexpected int check');
            intVal = (var5 as int);
            assertTrue( intVal == 0,'Unexpected int check');
            
            intVal = int(var3);
            assertTrue( intVal == 0,'Unexpected int check');
            intVal = int(var4);
            assertTrue( intVal == 0,'Unexpected int check');
            intVal = int(var5);
            assertTrue( intVal == 2,'Unexpected int check');
            
            intVal = new int(var3);
            assertTrue( intVal == 0,'Unexpected int check');
            intVal = new int(var4);
            assertTrue( intVal == 0,'Unexpected int check');
            intVal = new int(var5);
            assertTrue( intVal == 2,'Unexpected int check');
            
            
            assertFalse( val1 is int,'int check should be false');
            assertTrue( val2 is int,'int check should be true');
            
            assertFalse( val1 is uint,'uint check should be false');
            assertTrue( val2 is uint,'uint check should be true');
            
            var dyn:* = new clazz();
            
            assertTrue( dyn == 0,'Unexpected int check');
            assertTrue( dyn === 0,'Unexpected int check');
            
            
            assertTrue( int === int,'random check');
            
            assertTrue( new clazz(3.5) == 3,'Unexpected int check');
            
            assertFalse( dyn !== 0,'Unexpected int check');
            dyn = new clazz(3.5);
            intVal = dyn;
            assertTrue( intVal === 3,'Unexpected int check');
            assertTrue( new clazz(3.5) === 3,'Unexpected int check');
            
            //extra indirection
            var dynInt:* = var5;
            
            assertFalse( dynInt is clazz,'Unexpected int check');
            assertNull( dynInt as clazz,'Unexpected int check');
            assertTrue( clazz(dynInt) === 2,'Unexpected int check');
        }
        
        
        [Test]
        public function testUntypedMath():void
        {
            var val:int = 30;
            var c:Class = int;
            var untyped:* = val;
            var untyped2:* = new c(30);
            var untyped3:Object = new c(30);
            assertTrue( untyped3 == 30,'Unexpected int check');
            assertTrue( untyped3 === 30,'Unexpected int check');
            
            val += 1.5;
            untyped += 1.5;
            untyped2 += 1.5;
            assertTrue( val == 31,'Unexpected int check');
            assertTrue( val === 31,'Unexpected int check');
            
            assertTrue( untyped == 31.5,'Unexpected int check');
            assertTrue( untyped === 31.5,'Unexpected int check');
            
            assertTrue( untyped2 == 31.5,'Unexpected int check');
            assertTrue( untyped2 === 31.5,'Unexpected int check');
            
            untyped = new Number(30);
            assertTrue( untyped == 30,'Unexpected Number check');
            assertTrue( untyped === 30,'Unexpected Number check');
            
            var numClass:Class = Number;
            untyped = new numClass(30);
            assertTrue( untyped == 30,'Unexpected Number check');
            assertTrue( untyped === 30,'Unexpected Number check');
            assertTrue( 30 === untyped,'Unexpected Number check');
            
            untyped += 1.5;
            assertTrue( untyped == 31.5,'Unexpected Number check');
            assertTrue( untyped === 31.5,'Unexpected Number check');
            
        }
    
    
        [Test]
        //[TestVariance(variance="JS", description="Variance in js implementation with @royalesuppressresolveuncertain, strict equality can fail")]
        /**
         * @royalesuppressresolveuncertain c
         */
        public function testNoResolveUncertain():void
        {

            var c:Class = int;
            var untyped:* = new c(30);
            var expected:Boolean = isJS ? false : true;
            assertEquals(  expected, untyped === 30,'Unexpected int check');
            // b does not have suppression, only c does above (via @royalesuppressresolveuncertain c)
            expected = true;
            var b:Class = String;
           // c = String;
            untyped = new b(30);
            assertEquals(expected, untyped === '30', 'Unexpected String check');
        
        }
        
    }
}
