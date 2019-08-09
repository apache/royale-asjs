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
    import org.apache.royale.test.Runtime;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class LanguageTesterTestVector
    {
        
        public static var isJS:Boolean = COMPILE::JS;
    
    
        public static function hasInsertAtRemoveAt():Boolean{
            //this checks the build for swf-version that has insertAt/removeAt support in Vector
            COMPILE::SWF{
                //see; http://fpdownload.macromedia.com/pub/labs/flashruntimes/shared/air19_flashplayer19_releasenotes.pdf
                // "Please use swf-version 30 or greater and namespace 19.0 or greater to access the new APIs."
                return Runtime.swfVersion >= 30;
            }
            COMPILE::JS {
                //always supported
                return true
            }
        }
        
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
        
        
        private function _mapper(item:Object, index:int, vector:Vector.<*>):Object
        {
            return new TestClass1();
        }
        
        [Test]
        public function testVectorBasic():void
        {
            
            var vi:Vector.<int> = new Vector.<int>();
            
            assertFalse( vi.fixed,'Unexpected Vector check');
            assertTrue( vi.length == 0,'Unexpected Vector check');
            
            vi = new Vector.<int>(20);
            
            assertFalse( vi.fixed,'Unexpected Vector check');
            assertTrue( vi.length == 20,'Unexpected Vector check');
            assertEquals( vi.toString(),'0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0','Unexpected Vector check');
            
            vi = new Vector.<int>(20, true);
            
            assertTrue( vi.fixed,'Unexpected Vector check');
            assertTrue( vi.length == 20,'Unexpected Vector check');
            assertEquals( vi.toString(),'0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0','Unexpected Vector check');
            
            var c:Class = Vector.<int>;
            
            //dynamic instantiation
            var n:* = new c();
            n.push(12);
            n.push(24);
            assertFalse( n.fixed,'Unexpected Vector check');
            assertTrue( n.length == 2,'Unexpected Vector check');
            assertEquals( n.toString(),'12,24','Unexpected Vector check');
            
            n = new c(20);
            assertFalse( n.fixed,'Unexpected Vector check');
            assertTrue( n.length == 20,'Unexpected Vector check');
            assertEquals( n.toString(),'0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0','Unexpected Vector check');
            
            n = new c(20, true);
            assertTrue( n.fixed,'Unexpected Vector check');
            assertTrue( n.length == 20,'Unexpected Vector check');
            assertEquals( n.toString(),'0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0','Unexpected Vector check');
            
            var source:Array = [1, '', false, NaN, {test: true}, undefined];
            
            //coercion
            vi = Vector.<int>(source);
            assertFalse( vi.fixed,'Unexpected Vector check');
            assertTrue( vi.length == 6,'Unexpected Vector check');
            assertEquals( vi.toString(),'1,0,0,0,0,0','Unexpected Vector check');
            
            var vb:Vector.<Boolean> = Vector.<Boolean>(source);
            assertFalse( vb.fixed,'Unexpected Vector check');
            assertTrue( vb.length == 6,'Unexpected Vector check');
            assertEquals( vb.toString(),'true,false,false,false,true,false','Unexpected Vector check');
            
            n = vb;
            assertFalse( n is Vector,'Unexpected Vector check');
            assertFalse( n is Array,'Unexpected Vector check');
            assertTrue( n is Vector.<Boolean>,'Unexpected Vector check');
            
            var vs:Vector.<String> = Vector.<String>(source);
            
            assertFalse( vs.fixed,'Unexpected Vector check');
            assertTrue( vs.length == 6,'Unexpected Vector check');
            assertEquals( vs.toString(),'1,,false,NaN,[object Object],null','Unexpected Vector check');
            
            var vstar:Vector.<*> = Vector.<*>(source);
            
            assertFalse( vstar.fixed,'Unexpected Vector check');
            assertTrue( vstar.length == 6,'Unexpected Vector check');
            assertEquals( vstar.toString(),'1,,false,NaN,[object Object],null','Unexpected Vector check');
            vstar.fixed = true;
            assertTrue( vstar.fixed,'Unexpected Vector check');
            
            var customClasses:Array = [null, new TestClass2(), undefined, new TestClass1()];
            
            var vcustom:Vector.<TestClass1> = Vector.<TestClass1>(customClasses);
            
            assertFalse( vcustom.fixed,'Unexpected Vector check');
            assertTrue( vcustom.length == 4,'Unexpected Vector check');
            assertTrue( vcustom[0] === null,'Unexpected Vector check');
            assertTrue( vcustom[1] is TestClass2,'Unexpected Vector check');
            assertTrue( vcustom[2] === null,'Unexpected Vector check');
            assertTrue( vcustom[3] is TestClass1,'Unexpected Vector check');
            
            var nested:Vector.<Vector.<TestClass1>> = Vector.<Vector.<TestClass1>>([vcustom, null, undefined, vcustom]);
            assertFalse( nested.fixed,'Unexpected Vector check');
            assertTrue( nested.length == 4,'Unexpected Vector check');
            assertTrue( nested[0] === vcustom,'Unexpected Vector check');
            assertTrue( nested[1] === null,'Unexpected Vector check');
            assertTrue( nested[2] === null,'Unexpected Vector check');
            assertTrue( nested[3] === vcustom,'Unexpected Vector check');
            
            //indirect/dynamic coercion
            c = Vector.<int>;
            var result:*;
            result = c(source);
            assertFalse( result.fixed,'Unexpected Vector check');
            assertTrue( result.length == 6,'Unexpected Vector check');
            assertFalse( result is Vector,'Unexpected Vector check');
            assertFalse( result is Array,'Unexpected Vector check');
            assertFalse( result is Vector.<*>,'Unexpected Vector check');
            assertTrue( result is Vector.<int>,'Unexpected Vector check');
            assertEquals( result.toString(),'1,0,0,0,0,0','Unexpected Vector check');
            
            c = Vector.<Boolean>;
            result = c(source);
            assertFalse( result.fixed,'Unexpected Vector check');
            assertTrue( result.length == 6,'Unexpected Vector check');
            assertFalse( result is Vector,'Unexpected Vector check');
            assertFalse( result is Array,'Unexpected Vector check');
            assertTrue( result is Vector.<*>,'Unexpected Vector check');
            assertTrue( result is Vector.<Boolean>,'Unexpected Vector check');
            assertEquals( result.toString(),'true,false,false,false,true,false','Unexpected Vector check');
            
            c = Vector.<String>;
            result = c(source);
            
            assertFalse( result.fixed,'Unexpected Vector check');
            assertTrue( result.length == 6,'Unexpected Vector check');
            assertFalse( result is Vector,'Unexpected Vector check');
            assertFalse( result is Array,'Unexpected Vector check');
            assertTrue( result is Vector.<*>,'Unexpected Vector check');
            assertTrue( result is Vector.<String>,'Unexpected Vector check');
            assertEquals( result.toString(),'1,,false,NaN,[object Object],null','Unexpected Vector check');
            
            c = Vector.<*>;
            result = c(source);
            
            assertFalse( result.fixed,'Unexpected Vector check');
            assertTrue( result.length == 6,'Unexpected Vector check');
            assertFalse( result is Vector,'Unexpected Vector check');
            assertFalse( result is Array,'Unexpected Vector check');
            assertTrue( result is Vector.<*>,'Unexpected Vector check');
            assertFalse( result is Vector.<Object>,'Unexpected Vector check');
            assertEquals( result.toString(),'1,,false,NaN,[object Object],null','Unexpected Vector check');
        }
        
        [Test]
        [TestVariance(variance="SWF",description="SWF tests for insertAt/removeAt are not run when swf version<30")]
        public function testFixedVectorBasicMethods():void
        {
            var nested:Vector.<Vector.<TestClass1>> = new Vector.<Vector.<TestClass1>>(20, false);
            
            var caughtError:Boolean;
            
            nested.fixed = true;
            try
            {
                caughtError = false;
                nested.pop();
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            try
            {
                caughtError = false;
                nested.push(null);
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            try
            {
                caughtError = false;
                nested.shift();
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            try
            {
                caughtError = false;
                nested.unshift(null);
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
    
            if (hasInsertAtRemoveAt()) {
                try
                {
                    caughtError = false;
                    nested['removeAt'](0);
                } catch (e:Error)
                {
                    caughtError = e is RangeError
                }
                
                assertTrue( caughtError,'Unexpected Vector check');
            
                try
                {
                    caughtError = false;
                    nested['insertAt'](0, null);
                } catch (e:Error)
                {
                    caughtError = e is RangeError
                }
    
                assertTrue( caughtError,'Unexpected Vector check');
            } else {
                //RoyaleUnitTestRunner.consoleOut('Variance: The current target does not have support for Vector insertAt/removeAt methods', 'warn')
            }
            
        }
    
        [Test]
        public function testString():void
        {
            var inst:Vector.<String> = new Vector.<String>();
            var something:* = undefined;
            inst[0] = null;
            inst[1] = undefined;
            inst[2] = '';
            inst[3] = new String();
            inst[4] = something;
            assertTrue( inst[0] === null,'unexpected coercion result');
            assertTrue( inst[1] === null,'unexpected coercion result');
            assertTrue( inst[2] === '','unexpected coercion result');
            assertTrue( inst[3] === '','unexpected coercion result');
            assertTrue( inst[4] === null,'unexpected coercion result');
        
            inst.push(undefined);
            assertTrue( inst.pop() === null,'unexpected coercion result');
            inst.push(something);
            assertTrue( inst.pop() === null,'unexpected coercion result');
        }
    
        [Test]
        public function testBoolean():void
        {
            var inst:Vector.<Boolean> = new Vector.<Boolean>();
            var nothing:* = undefined;
            var something:* = {};
            inst[0] = null;
            inst[1] = undefined;
            inst[2] = '';
            inst[3] = new String();
            inst[4] = nothing;
            inst[5] = something;
            assertTrue( inst[0] === false,'unexpected coercion result');
            assertTrue( inst[1] === false,'unexpected coercion result');
            assertTrue( inst[2] === false,'unexpected coercion result');
            assertTrue( inst[3] === false,'unexpected coercion result');
            assertTrue( inst[4] === false,'unexpected coercion result');
            assertTrue( inst[5] === true,'unexpected coercion result');
            
            inst.push(undefined);
            assertTrue( inst.pop() === false,'unexpected coercion result');
            inst.push(nothing);
            assertTrue( inst.pop() === false,'unexpected coercion result');
            inst.push(something);
            assertTrue( inst.pop() === true,'unexpected coercion result');
        }
    
        [Test]
        public function testClass():void
        {
            var inst:Vector.<Class> = new Vector.<Class>();
            var nothing:* = undefined;
            var something:* = Array;
            inst[0] = null;
            //@todo fix in compiler:
            inst[1] = undefined;
            inst[2] = String;
            inst[3] = nothing;
            inst[4] = something;
            inst[5] = uint;
            inst[6] = TestClass1;
            assertTrue( inst[0] === null, 'unexpected coercion result');
            assertTrue(inst[1] === null, 'unexpected coercion result');
            assertTrue(inst[2] === String, 'unexpected coercion result');
            assertTrue(inst[3] === null, 'unexpected coercion result');
            assertTrue(inst[4] === Array, 'unexpected coercion result');
            assertTrue(inst[5] === uint, 'unexpected coercion result');
            assertTrue(inst[6] === TestClass1, 'unexpected coercion result');
        
            inst.push(undefined);
            assertTrue(inst.pop() === null, 'unexpected coercion result');
            inst.push(nothing);
            assertTrue(inst.pop() === null,'unexpected coercion result');
            inst.push(something);
            assertTrue(inst.pop() === Array,'unexpected coercion result');
        }
    
        [Test]
        public function testFixedVectorMutationMethodCoercion():void
        {
            var tc1Vec:Vector.<TestClass1> = new Vector.<TestClass1>();
            
            var content:*  = new TestClass5();
    
            var caughtError:Boolean;
            try
            {
                caughtError = false;
                //not allowed, because TestClass5 does not coerce to TestClass1
                tc1Vec.push(content);
            } catch (e:Error)
            {
                caughtError = e is TypeError;
                
            }
            //even though it was an error, it has pushed null into the vector, so it
            //now has length of 1
            assertTrue( tc1Vec.length == 1,'Unexpected Vector check');
            assertTrue( caughtError,'Unexpected Vector check');
            assertNull( tc1Vec[0],'Unexpected Vector check');
    
            try
            {
                caughtError = false;
                //multiple args, with one valid at the start and end
                //when the first error is hit as the second item, that items, and the following items
                //are pushed as null
                //the nwe length is therefore increased by 4 here,
                //but the 2nd item is an error, so only the first one makes it in
                tc1Vec.push(new TestClass1(), content, content, new TestClass1());
            } catch (e:Error)
            {
                caughtError = e is TypeError;
            }
            //even though it had an extra 2 error elements, it has pushed null into the vector, so it
            //now has length of 5
            assertTrue( tc1Vec.length == 5,'Unexpected Vector check');
            assertTrue( caughtError,'Unexpected Vector check');
            assertNull( tc1Vec[0],'Unexpected Vector check');
            assertTrue( tc1Vec[1] is TestClass1,'Unexpected Vector check');
            assertNull( tc1Vec[2],'Unexpected Vector check');
            assertNull( tc1Vec[3],'Unexpected Vector check');
            assertNull( tc1Vec[4],'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                //similar to push, the first failed argument coercion (2nd argument here) results
                //in it and the remaining items being coerced to null and unshifted
                //so this also increases the length by 4, but only the first item makes
                //it in (and the error is thrown)
                tc1Vec.unshift(new TestClass1(), content, new TestClass1(), content);
            } catch (e:Error)
            {
                caughtError = e is TypeError;
            }
    
            assertTrue( tc1Vec.length == 9,'Unexpected Vector check');
            assertTrue( caughtError,'Unexpected Vector check');
            assertTrue( tc1Vec[0] is TestClass1,'Unexpected Vector check');
            assertNull( tc1Vec[1],'Unexpected Vector check');
            assertNull( tc1Vec[2],'Unexpected Vector check');
            assertNull( tc1Vec[3],'Unexpected Vector check');
            assertNull( tc1Vec[4],'Unexpected Vector check');
            assertTrue( tc1Vec[5] is TestClass1,'Unexpected Vector check');
            assertNull( tc1Vec[6],'Unexpected Vector check');
            assertNull( tc1Vec[7],'Unexpected Vector check');
            assertNull( tc1Vec[8],'Unexpected Vector check');
            
        }
        
        [Test]
        [TestVariance(variance="SWF",description="SWF tests for insertAt/removeAt are not run when swf version<30")]
        public function testVectorAdvancedMethods():void
        {
            
            var customClasses:Array = [null, new TestClass2(), undefined, new TestClass1()];
            
            var vcustom:Vector.<TestClass1> = Vector.<TestClass1>(customClasses);
            var vcustom2:Vector.<TestClass1> = vcustom.map(_mapper);
            
            assertTrue( vcustom2 != vcustom,'Unexpected Vector check');
            assertTrue( vcustom2[0] is TestClass1,'Unexpected Vector check');
            assertTrue( vcustom2[1] is TestClass1,'Unexpected Vector check');
            assertTrue( vcustom2[2] is TestClass1,'Unexpected Vector check');
            assertTrue( vcustom2[3] is TestClass1,'Unexpected Vector check');
            //remove 1 item at position 1 and replace it with a new TestClass2 instance
            var vcustom3:Vector.<TestClass1> = vcustom2.splice(1, 1, new TestClass2());
            assertTrue( vcustom3 != vcustom2,'Unexpected Vector check');
            assertTrue( vcustom3.length == 1,'Unexpected Vector check');
            assertTrue( vcustom2.length == 4,'Unexpected Vector check');
            assertTrue( vcustom3[0] is TestClass1,'Unexpected Vector check');
            assertTrue( vcustom2[1] is TestClass2,'Unexpected Vector check');
            
            
            if (hasInsertAtRemoveAt()) {
                vcustom3['insertAt'](0, new TestClass2());
                assertTrue( vcustom3.length == 2,'Unexpected Vector check');
                assertTrue( vcustom3[0] is TestClass2,'Unexpected Vector check');
                assertTrue( vcustom3[1] is TestClass1,'Unexpected Vector check');
    
                var removedItem:* = vcustom3['removeAt'](0);
                assertTrue( vcustom3.length == 1,'Unexpected Vector check');
                assertTrue( vcustom3[0] is TestClass1,'Unexpected Vector check');
                assertTrue( removedItem is TestClass2,'Unexpected Vector check');
    
                var tc1Vec:Vector.<TestClass1> = new Vector.<TestClass1>(4);
    
                //insert at invalid index:
                tc1Vec['insertAt'](6, new TestClass1());
                //no error, insertAt minimises the specified index to the Vector's length and inserts there
                assertTrue( tc1Vec.length == 5,'Unexpected Vector check');
                assertTrue( tc1Vec[4] is TestClass1,'Unexpected Vector check');
    
                var caughtError:Boolean;
                try
                {
                    caughtError = false;
                    tc1Vec['removeAt'](6);
                } catch (e:Error)
                {
                    caughtError = e is RangeError
                }
    
                try
                {
                    caughtError = false;
                    tc1Vec['removeAt'](-1);
                } catch (e:Error)
                {
                    caughtError = e is RangeError
                }
                assertTrue( tc1Vec.length == 4,'Unexpected Vector check');
                assertEquals( tc1Vec.toString(),'null,null,null,null','Unexpected Vector check');
                //no error
                assertFalse( caughtError,'Unexpected Vector check');
    
                try
                {
                    caughtError = false;
                    tc1Vec['insertAt'](-1, new TestClass1());
                } catch (e:Error)
                {
                    caughtError = e is RangeError
                }
    
                assertTrue( tc1Vec.length == 5,'Unexpected Vector check');
                //new item is at position 3
                assertNotNull( tc1Vec[3],'Unexpected Vector check');
                //moving the original content (null) from position 3 to 4
                assertNull( tc1Vec[4],'Unexpected Vector check');
                //no error
                assertFalse( caughtError,'Unexpected Vector check');
    
                try
                {
                    caughtError = false;
                    //even though this is out of range, it still works without error
                    tc1Vec['insertAt'](-200, new TestClass1());
                } catch (e:Error)
                {
                    caughtError = e is RangeError
                }
    
                assertTrue( tc1Vec.length == 6,'Unexpected Vector check');
                //new item is at position 0
                assertNotNull( tc1Vec[0],'Unexpected Vector check');
                //the other non-null item is now at postion 4
                assertNotNull( tc1Vec[4],'Unexpected Vector check');
                //no error
                assertFalse( caughtError,'Unexpected Vector check');
    
                try
                {
                    caughtError = false;
                    tc1Vec['removeAt'](-200);
                } catch (e:Error)
                {
                    caughtError = e is RangeError;
                }
    
                assertTrue( tc1Vec.length == 5,'Unexpected Vector check');
                //position 0 is now null
                assertNull( tc1Vec[0],'Unexpected Vector check');
                //the non-null item is now at postion 3
                assertNotNull( tc1Vec[3],'Unexpected Vector check');
                //no error
                assertFalse( caughtError,'Unexpected Vector check');
                
            }  else {
                //RoyaleUnitTestRunner.consoleOut('Variance: The current target does not have support for Vector insertAt/removeAt methods, so these are untested', 'warn')
            }
           
            
        }
    
        [Test]
        public function testSort():void{
            var vi:Vector.<int> = new <int>[1, 2, 3, 4, 5];
            vi.sort(Array.NUMERIC|Array.DESCENDING);
            assertEquals( vi.toString(),'5,4,3,2,1','Unexpected Vector check');
        }
        
        [Test]
        public function testVectorConcat():void
        {
            var source:Array = [1, '', false, NaN, {test: true}, undefined];
            var vi1:Vector.<int> = new <int>[1, 2, 3, 4, 5];
            var vi2:Vector.<int> = new <int>[5, 4, 3, 2, 1];
            var vu2:Vector.<uint> = new <uint>[5, 4, 3, 2, 1];
            var vi3:Vector.<int> = vi1.concat(vi2);
            assertEquals( vi3.toString(),'1,2,3,4,5,5,4,3,2,1','Unexpected Vector check');
            assertTrue( vi3 is Vector.<int>,'Unexpected Vector check');
            
            var caughtError:Boolean;
            try
            {
                caughtError = false;
                vi3 = vi1.concat(vu2);
            } catch (e:Error)
            {
                caughtError = e is TypeError
            }
            assertTrue( caughtError,'Unexpected Vector check');
            
            var vs:Vector.<String> = Vector.<String>(source);
            var testConcat:Vector.<String> = vs.concat(vs);
            assertEquals( testConcat.toString(),'1,,false,NaN,[object Object],null,1,,false,NaN,[object Object],null','Unexpected Vector check');
            assertTrue( testConcat is Vector.<String>,'Unexpected Vector check');
            
        }
    
    
        [Test]
        public function testVectorSlice():void
        {
            var source:Array = [1, '', false, NaN, {test: true}, undefined];
            var vi1:Vector.<int> = new <int>[1, 2, 3, 4, 5];
            var vi2:Vector.<int> = vi1.slice();
            assertEquals( vi2.toString(),'1,2,3,4,5','Unexpected Vector check');
            assertTrue( vi2 is Vector.<int>,'Unexpected Vector check');
            vi2 = vi1.slice(1);
            assertEquals( vi2.toString(),'2,3,4,5','Unexpected Vector check');
            assertTrue( vi2 is Vector.<int>,'Unexpected Vector check');
    
            vi2 = vi1.slice(0,0);
            assertEquals( vi2.toString(),'','Unexpected Vector check');
            assertTrue( vi2 is Vector.<int>,'Unexpected Vector check');
    
            vi2 = vi1.slice(1,-1);
            assertEquals( vi2.toString(),'2,3,4','Unexpected Vector check');
            assertTrue( vi2 is Vector.<int>,'Unexpected Vector check');
        
            var vs:Vector.<String> = Vector.<String>(source);
            var testSlice:Vector.<String> = vs.slice();
            assertEquals( testSlice.toString(),'1,,false,NaN,[object Object],null','Unexpected Vector check');
            assertTrue( testSlice is Vector.<String>,'Unexpected Vector check');
        
        }
        
        
        
        [Test]
        public function testVectorFilter():void
        {
            var vi1:Vector.<int> = new <int>[1, 2, 3, 4, 5, 4, 3, 2, 1];
            
            var f:Function = function (value:int, index:int, source:*):Boolean
            {
                return value > 2
            };
            
            var vi2:Vector.<int> = vi1.filter(f);
            assertEquals( vi2.toString(),'3,4,5,4,3','Unexpected Vector check');
            assertFalse( vi2 is Array,'Unexpected Vector check');
            assertTrue( vi2 is Vector.<int>,'Unexpected Vector check');
        }
        
        [Test]
        public function testVectorAsIs():void
        {
            var source:Array = [1, '', false, NaN, {test: true}, undefined];
            
            var vi:Vector.<int> = Vector.<int>(source);
            assertFalse( vi is Vector,'Unexpected Vector check');
            assertFalse( vi is Array,'Unexpected Vector check');
            assertTrue( vi is Vector.<int>,'Unexpected Vector check');
            assertFalse( vi is Vector.<*>,'Unexpected Vector check');
            
            var vu:Vector.<uint> = Vector.<uint>(source);
            assertFalse( vu is Vector,'Unexpected Vector check');
            assertFalse( vu is Array,'Unexpected Vector check');
            assertTrue( vu is Vector.<uint>,'Unexpected Vector check');
            assertFalse( vu is Vector.<*>,'Unexpected Vector check');
            
            var vn:Vector.<Number> = Vector.<Number>(source);
            assertFalse( vn is Vector,'Unexpected Vector check');
            assertFalse( vn is Array,'Unexpected Vector check');
            assertTrue( vn is Vector.<Number>,'Unexpected Vector check');
            assertFalse( vn is Vector.<*>,'Unexpected Vector check');
            
            var vb:Vector.<Boolean> = Vector.<Boolean>(source);
            assertFalse( vb is Vector,'Unexpected Vector check');
            assertFalse( vb is Array,'Unexpected Vector check');
            assertTrue( vb is Vector.<Boolean>,'Unexpected Vector check');
            assertTrue( vb is Vector.<*>,'Unexpected Vector check');
            
            var vs:Vector.<String> = Vector.<String>(source);
            assertFalse( vs is Vector,'Unexpected Vector check');
            assertFalse( vs is Array,'Unexpected Vector check');
            assertTrue( vs is Vector.<String>,'Unexpected Vector check');
            assertTrue( vs is Vector.<*>,'Unexpected Vector check');
            
            var vstar:Vector.<*> = Vector.<*>(source);
            assertFalse( vstar is Vector,'Unexpected Vector check');
            assertFalse( vstar is Array,'Unexpected Vector check');
            assertTrue( vstar is Vector.<*>,'Unexpected Vector check');
            assertTrue( vstar is Vector.<*>,'Unexpected Vector check');
            
            
            var customClasses:Array = [null, new TestClass2(), undefined, new TestClass1()];
            
            var vcustom:Vector.<TestClass1> = Vector.<TestClass1>(customClasses);
            
            assertFalse( vcustom is Vector,'Unexpected Vector check');
            assertFalse( vcustom is Array,'Unexpected Vector check');
            assertTrue( vcustom is Vector.<TestClass1>,'Unexpected Vector check');
            assertTrue( vcustom is Vector.<*>,'Unexpected Vector check');
    
            customClasses.push(new TestClass5());
            var oldDef:Vector.<TestClass1> = vcustom;
            //this is a coercion error
            var caughtError:Boolean;
            try
            {
                caughtError = false;
                vcustom = Vector.<TestClass1>(customClasses);
            } catch (e:Error)
            {
                caughtError = e is TypeError;
            }
    
            assertTrue( caughtError,'Unexpected Vector check');
            assertEquals( oldDef,vcustom,'Unexpected Vector check');
        }
        
        [Test]
        /**
         * @royalesuppresscompleximplicitcoercion Vector.<TestClass1>
         */
        public function testVectorAsIsIndirect():void
        {
            var source:Array = [1, '', false, NaN, {test: true}, undefined];
            
            var vi:Vector.<int> = Vector.<int>(source);
            assertFalse( vi is Vector,'Unexpected Vector check');
            assertFalse( vi is Array,'Unexpected Vector check');
            assertTrue( vi is Vector.<int>,'Unexpected Vector check');
            assertFalse( vi is Vector.<*>,'Unexpected Vector check');
            
            var vu:Vector.<uint> = Vector.<uint>(source);
            assertFalse( vu is Vector,'Unexpected Vector check');
            assertFalse( vu is Array,'Unexpected Vector check');
            assertTrue( vu is Vector.<uint>,'Unexpected Vector check');
            assertFalse( vu is Vector.<*>,'Unexpected Vector check');
            
            var vn:Vector.<Number> = Vector.<Number>(source);
            assertFalse( vn is Vector,'Unexpected Vector check');
            assertFalse( vn is Array,'Unexpected Vector check');
            assertTrue( vn is Vector.<Number>,'Unexpected Vector check');
            assertFalse( vn is Vector.<*>,'Unexpected Vector check');
            
            var vb:Vector.<Boolean> = Vector.<Boolean>(source);
            assertFalse( vb is Vector,'Unexpected Vector check');
            assertFalse( vb is Array,'Unexpected Vector check');
            assertTrue( vb is Vector.<Boolean>,'Unexpected Vector check');
            assertTrue( vb is Vector.<*>,'Unexpected Vector check');
            
            var vs:Vector.<String> = Vector.<String>(source);
            assertFalse( vs is Vector,'Unexpected Vector check');
            assertFalse( vs is Array,'Unexpected Vector check');
            assertTrue( vs is Vector.<String>,'Unexpected Vector check');
            assertTrue( vs is Vector.<*>,'Unexpected Vector check');
            
            var vstar:Vector.<*> = Vector.<*>(source);
            assertFalse( vstar is Vector,'Unexpected Vector check');
            assertFalse( vstar is Array,'Unexpected Vector check');
            assertTrue( vstar is Vector.<*>,'Unexpected Vector check');
            assertTrue( vstar is Vector.<*>,'Unexpected Vector check');
            
            
            var customClasses:Array = [null, new TestClass2(), undefined, new TestClass1()];
            
            var vcustom:Vector.<TestClass1> = Vector.<TestClass1>(customClasses);
            
            assertFalse( vcustom is Vector,'Unexpected Vector check');
            assertFalse( vcustom is Array,'Unexpected Vector check');
            assertTrue( vcustom is Vector.<TestClass1>,'Unexpected Vector check');
            assertTrue( vcustom is Vector.<*>,'Unexpected Vector check');
    
            var claZZ:Class = Vector.<TestClass1>;
            vcustom = claZZ(customClasses);
    
            assertFalse( vcustom is Vector,'Unexpected Vector check');
            assertFalse( vcustom is Array,'Unexpected Vector check');
            assertTrue( vcustom is Vector.<TestClass1>,'Unexpected Vector check');
            assertTrue( vcustom is Vector.<*>,'Unexpected Vector check');
        }
        
        [Test]
        public function testVectorLiteral():void
        {
            var test:* = 'hello';
            var vi:Vector.<int> = new <int>[1, 2, test, 4, 5];
            
            assertFalse( vi.fixed,'Unexpected Vector check');
            assertTrue( vi.length == 5,'Unexpected Vector check');
            assertEquals( vi.toString(),'1,2,0,4,5','Unexpected Vector check');
        }
        
        [Test]
        public function testVectorLengthIncreasedDefaults():void
        {
            var vi:Vector.<int> = new <int>[1, 2, 3, 4, 5];
            vi.length = 10;
            assertFalse( vi.fixed,'Unexpected Vector check');
            assertTrue( vi.length == 10,'Unexpected Vector check');
            assertEquals( vi.toString(),'1,2,3,4,5,0,0,0,0,0','Unexpected Vector check');
        }
        
        [TestVariance(variance="JS", description="Variance in js implementation for access to 'constructor' via Vector instance, js is specific vs. Vector.<*> in swf.")]
        [Test]
        public function testVectorConstructor():void
        {
            var vi:Vector.<int> = new <int>[1, 2, 3, 4, 5];
            assertTrue( vi['constructor'] === Vector.<int>,'Unexpected Vector check');
            
            var vui:Vector.<uint> = new <uint>[1, 2, 3, 4, 5];
            assertTrue( vui['constructor'] === Vector.<uint>,'Unexpected Vector check');
            
            var vn:Vector.<Number> = new <Number>[1, 2, 3, 4, 5];
            assertTrue( vn['constructor'] === Vector.<Number>,'Unexpected Vector check');
            
            var vs:Vector.<String> = new <String>[];
            //current variance in the javascript vs. avm implementations
            const expected:Class = isJS ? Vector.<String> : Vector.<*>;
            assertTrue( vs['constructor'] === expected,'Unexpected Vector check');
        }
    
        [Test]
        public function testVectorRemoveAtType():void{
            if (hasInsertAtRemoveAt()) {
                var customClasses:Array = [null, new TestClass2(), undefined, new TestClass1()];
    
                var vcustom:Vector.<TestClass1> = Vector.<TestClass1>(customClasses);
    
                COMPILE::SWF{
                    var tc1:TestClass1 = vcustom['removeAt'](1);
                }
                COMPILE::JS{
                    var tc1:TestClass1 = vcustom.removeAt(1);
                }
                assertTrue(tc1 != null, 'Unexpected Vector check');
                assertTrue(tc1 is TestClass1, 'Unexpected Vector check');
                assertTrue(tc1 is TestClass2, 'Unexpected Vector check');
            } else {
                assertTrue(true);
            }
           
        }
        
        
        private var _viTest:Vector.<int>;
        
        private function getVector():Vector.<int>
        {
            return _viTest;
        }
        
        [Test]
        public function testFixedVectorLengthChangeErrors():void
        {
            var vi:Vector.<int> = new <int>[1, 2, 3, 4, 5];
            vi.fixed = true;
            _viTest = vi;
            
            var caughtError:Boolean;
            try
            {
                caughtError = false;
                vi.length = 10;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                vi.length += 5;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                vi.length = vi.length + 5;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                vi.length++;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                vi.length--;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                ++vi.length;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                --vi.length;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                _viTest.length = 10;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                _viTest.length += 5;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                _viTest.length = _viTest.length + 5;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                _viTest.length++;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                _viTest.length--;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                ++_viTest.length;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                --_viTest.length;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                getVector().length = 10;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                getVector().length += 5;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                getVector().length = _viTest.length + 5;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                getVector().length++;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                getVector().length--;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                ++getVector().length;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                --getVector().length;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( caughtError,'Unexpected Vector check');
        }
        
        [Test]
        /**
         * no matter what the global setting is, do not suppress index checks inside this method:
         * @royalesuppressvectorindexcheck false
         */
        public function testRegularVectorIndexChecks():void
        {
            var vi:Vector.<int> = new <int>[1, 2, 3, 4, 5];
            //allowed, not an error:
            vi[5] = 6;
            assertTrue( vi.length == 6,'Unexpected Vector check');
            assertEquals( vi.toString(),'1,2,3,4,5,6', 'Unexpected Vector check');
            var caughtError:Boolean;
            try
            {
                caughtError = false;
                //not allowed, because even though fixed==false,
                //Vectors are not allowed to be sparse and
                //index is greater than current length of 6
                vi[7] = 8;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( vi.length == 6,'Unexpected Vector check');
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                vi.fixed = true;
                //not allowed, because it is now fixed length of 6 (after v[5] = 6 above)
                //so anything outside range of 0..5 is not permitted
                vi[6] = 7;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( vi.length == 6,'Unexpected Vector check');
            assertTrue( caughtError,'Unexpected Vector check');
    
            try
            {
                caughtError = false;
                //not allowed, because it is a non-uint index
                //only uint indices in range of 0..5 are permitted
                vi[1.5] = 0;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
    
            assertTrue( vi.length == 6,'Unexpected Vector check');
            assertTrue( caughtError,'Unexpected Vector check');
            
            try
            {
                caughtError = false;
                //this is a non-realistic example which should not be encountered in 'real' code
                //but is included here for coverage
                new Vector.<int>()[2] = 3;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            assertTrue( caughtError,'Unexpected Vector check');
        }
    
    
        [TestVariance(variance="JS", description="Variance in js implementation with @royalesuppressvectorindexcheck true, Vector instance can enter invalid state.")]
        [Test]
        /**
         * local avoidance of vector index checking (all cases)
         * no matter what the global setting is, always suppress inside this method:
         * @royalesuppressvectorindexcheck true
         * this will cause variance in the most Assertions
         */
        public function testSuppressedVectorIndexChecks():void
        {
            var vi:Vector.<int> = new <int>[1, 2, 3, 4, 5];
            //allowed, not an error:
            vi[5] = 6;
            assertTrue( vi.length == 6,'Unexpected Vector check');
            assertEquals( vi.toString(), '1,2,3,4,5,6','Unexpected Vector check');
            var caughtError:Boolean;
            try
            {
                caughtError = false;
                //not allowed, because even though fixed==false,
                //Vectors are not allowed to be sparse and
                //index is greater than current length of 6
                vi[7] = 8;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            assertTrue( vi.length == (isJS? 8 : 6),'Unexpected Vector check');
            assertTrue( caughtError === (isJS ? false : true),'Unexpected Vector check');
    
            try
            {
                caughtError = false;
                vi.fixed = true;
                //not allowed, because it is now fixed length of 6 (after v[5] = 6 above)
                //so anything outside range of 0..5 is not permitted
                vi[6] = 7;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
    
            assertTrue( vi.length == (isJS? 8 : 6),'Unexpected Vector check');
            assertTrue( caughtError === (isJS ? false : true),'Unexpected Vector check');
    
            try
            {
                caughtError = false;
                //not allowed, because it is a non-uint index
                //only uint indices in range of 0..5 are permitted
                vi[1.5] = 0;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
    
            assertTrue( vi.length == (isJS? 8 : 6),'Unexpected Vector check');
            assertTrue( caughtError === (isJS ? false : true),'Unexpected Vector check');
    
            try
            {
                caughtError = false;
                //this is a non-realistic example which should not be encountered in 'real' code
                //but is included here for coverage
                new Vector.<int>()[2] = 3;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            assertTrue( caughtError  === (isJS ? false : true),'Unexpected Vector check');
        }
    
        [TestVariance(variance="JS", description="Variance in js implementation with @royalesuppressvectorindexcheck {name here}, Vector instance can enter invalid state.")]
        [Test]
        /**
         * local avoidance of vector index checking (specific named case only)
         * no matter what the global setting is, do not suppress by default inside this method:
         * @royalesuppressvectorindexcheck false
         * aside from the above, suppress index checking specifically for an instance referenced as 'vi2':
         * @royalesuppressvectorindexcheck vi2
         * this will cause variance in the last Assertion
         */
        public function testSpecificSuppressedVectorIndexChecks():void
        {
            var vi:Vector.<int> = new <int>[1, 2, 3, 4, 5];
            //allowed, not an error:
            vi[5] = 6;
            assertTrue( vi.length == 6,'Unexpected Vector check');
            assertEquals( vi.toString(), '1,2,3,4,5,6','Unexpected Vector check');
            var caughtError:Boolean;
            try
            {
                caughtError = false;
                //not allowed, because even though fixed==false,
                //Vectors are not allowed to be sparse and
                //index is greater than current length of 6
                vi[7] = 8;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
    
            assertTrue( vi.length == 6,'Unexpected Vector check');
            assertTrue( caughtError,'Unexpected Vector check');
    
            try
            {
                caughtError = false;
                vi.fixed = true;
                //not allowed, because it is now fixed length of 6 (after v[5] = 6 above)
                //so anything outside range of 0..5 is not permitted
                vi[6] = 7;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
    
            assertTrue( vi.length == 6,'Unexpected Vector check');
            assertTrue( caughtError,'Unexpected Vector check');
    
            try
            {
                caughtError = false;
                //not allowed, because it is a non-uint index
                //only uint indices in range of 0..5 are permitted
                vi[1.5] = 0;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
    
            assertTrue( vi.length == 6,'Unexpected Vector check');
            assertTrue( caughtError,'Unexpected Vector check');
            
            var vi2:Vector.<int> = vi;
            try
            {
                caughtError = false;
                //not allowed, because it is a non-uint index
                //only uint indices in range of 0..5 are permitted
                vi2[1.5] = 0;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
        
            assertTrue( vi2.length == 6,'Unexpected Vector check');
            assertTrue( caughtError === (isJS ? false : true),'Unexpected Vector check');
        }
        
        
        //these accessors/methods etc also serve to visually inspect
        //the doc comment '@type' annotation in js-debug
        //it should be:  @type {Array}
        protected function get instGetterTest():Vector.<String> {
            return new Vector.<String>();
        }
    
        protected static function get getterTest():Vector.<String> {
            return new Vector.<String>();
        }
    
    
        protected function instGetTestVector():Vector.<String> {
            return new Vector.<String>();
        }
    
        protected static function getTestVector():Vector.<String> {
            return new Vector.<String>();
        }
        
        protected var instMyVec:Vector.<String> = new Vector.<String>() ;
    
        protected static var myVec:Vector.<String> = new Vector.<String>() ;
    
        protected static var myVec2:Vector.<TestClass1> = new Vector.<TestClass1>() ;
    
        [Test]
        public function testGetter():void{
            var vString:Vector.<String> = instGetterTest;
    
            assertTrue( vString is Vector.<String>,'Unexpected Vector check');
            assertFalse( vString is Array,'Unexpected Vector check');
            
            vString = instMyVec;
    
            assertTrue( vString is Vector.<String>,'Unexpected Vector check');
            assertFalse( vString is Array,'Unexpected Vector check');
    
            vString = instGetTestVector();
    
            assertTrue( vString is Vector.<String>,'Unexpected Vector check');
            assertFalse( vString is Array,'Unexpected Vector check');
            
            //static
            vString = getterTest;
    
            assertTrue( vString is Vector.<String>,'Unexpected Vector check');
            assertFalse( vString is Array,'Unexpected Vector check');
    
            vString = getTestVector();
    
            assertTrue( vString is Vector.<String>,'Unexpected Vector check');
            assertFalse( vString is Array,'Unexpected Vector check');
    
            vString = myVec;
    
            assertTrue( vString is Vector.<String>,'Unexpected Vector check');
            assertFalse( vString is Array,'Unexpected Vector check');
        }
    
        [Test]
        public function checkInterface():void{
            var v:Vector.<ITestInterface> = new <ITestInterface>[];
            v.push(new TestClass1());
            assertTrue( v.length == 1,'Unexpected Vector check');
            assertTrue( v[0] is TestClass1,'Unexpected Vector check');
        
            v=new Vector.<ITestInterface>();
            v.push(new TestClass1());
            assertTrue( v.length == 1,'Unexpected Vector check');
            assertTrue( v[0] is TestClass1,'Unexpected Vector check');
        
            v = Vector.<ITestInterface>([new TestClass1()]);
            assertTrue( v.length == 1,'Unexpected Vector check');
            assertTrue( v[0] is TestClass1,'Unexpected Vector check');
            var err:Boolean;
            try {
                v.push(new TestClass5())
            } catch (e:Error)
            {
                err=true;
            }
            assertTrue( err,'Unexpected Vector check');
        }
    
        [Test]
        public function testFilePrivate():void{
            //specifically tested because of qualified name variations for javascript at compiler level
            //literal:
            var v:Vector.<PrivateClass> = new <PrivateClass>[];
            v.push(new PrivateClass());
            assertTrue( v.length == 1,'Unexpected Vector check');
            assertTrue( v[0] is PrivateClass,'Unexpected Vector check');
            //normal constructor:
            v=new Vector.<PrivateClass>();
            v.push(new PrivateClass());
            assertTrue( v.length == 1,'Unexpected Vector check');
            assertTrue( v[0] is PrivateClass,'Unexpected Vector check');
            //coercion
            v = Vector.<PrivateClass>([]);
            v.push(new PrivateClass());
            assertTrue( v.length == 1,'Unexpected Vector check');
            assertTrue( v[0] is PrivateClass,'Unexpected Vector check');
        
        }
        
    }
}


class PrivateClass {
    
    public function PrivateClass(){
    
    }
}
