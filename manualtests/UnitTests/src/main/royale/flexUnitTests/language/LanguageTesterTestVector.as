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
    
    import testshim.RoyaleUnitTestRunner;
    
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
                return RoyaleUnitTestRunner.swfVersion >= 30;
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
            
            Assert.assertFalse('Unexpected Vector check', vi.fixed);
            Assert.assertTrue('Unexpected Vector check', vi.length == 0);
            
            vi = new Vector.<int>(20);
            
            Assert.assertFalse('Unexpected Vector check', vi.fixed);
            Assert.assertTrue('Unexpected Vector check', vi.length == 20);
            Assert.assertEquals('Unexpected Vector check', '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', vi.toString());
            
            vi = new Vector.<int>(20, true);
            
            Assert.assertTrue('Unexpected Vector check', vi.fixed);
            Assert.assertTrue('Unexpected Vector check', vi.length == 20);
            Assert.assertEquals('Unexpected Vector check', '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', vi.toString());
            
            var c:Class = Vector.<int>;
            
            //dynamic instantiation
            var n:* = new c();
            n.push(12);
            n.push(24);
            Assert.assertFalse('Unexpected Vector check', n.fixed);
            Assert.assertTrue('Unexpected Vector check', n.length == 2);
            Assert.assertEquals('Unexpected Vector check', '12,24', n.toString());
            
            n = new c(20);
            Assert.assertFalse('Unexpected Vector check', n.fixed);
            Assert.assertTrue('Unexpected Vector check', n.length == 20);
            Assert.assertEquals('Unexpected Vector check', '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', n.toString());
            
            n = new c(20, true);
            Assert.assertTrue('Unexpected Vector check', n.fixed);
            Assert.assertTrue('Unexpected Vector check', n.length == 20);
            Assert.assertEquals('Unexpected Vector check', '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', n.toString());
            
            var source:Array = [1, '', false, NaN, {test: true}, undefined];
            
            //coercion
            vi = Vector.<int>(source);
            Assert.assertFalse('Unexpected Vector check', vi.fixed);
            Assert.assertTrue('Unexpected Vector check', vi.length == 6);
            Assert.assertEquals('Unexpected Vector check', '1,0,0,0,0,0', vi.toString());
            
            var vb:Vector.<Boolean> = Vector.<Boolean>(source);
            Assert.assertFalse('Unexpected Vector check', vb.fixed);
            Assert.assertTrue('Unexpected Vector check', vb.length == 6);
            Assert.assertEquals('Unexpected Vector check', 'true,false,false,false,true,false', vb.toString());
            
            n = vb;
            Assert.assertFalse('Unexpected Vector check', n is Vector);
            Assert.assertFalse('Unexpected Vector check', n is Array);
            Assert.assertTrue('Unexpected Vector check', n is Vector.<Boolean>);
            
            var vs:Vector.<String> = Vector.<String>(source);
            
            Assert.assertFalse('Unexpected Vector check', vs.fixed);
            Assert.assertTrue('Unexpected Vector check', vs.length == 6);
            Assert.assertEquals('Unexpected Vector check', '1,,false,NaN,[object Object],null', vs.toString());
            
            var vstar:Vector.<*> = Vector.<*>(source);
            
            Assert.assertFalse('Unexpected Vector check', vstar.fixed);
            Assert.assertTrue('Unexpected Vector check', vstar.length == 6);
            Assert.assertEquals('Unexpected Vector check', '1,,false,NaN,[object Object],null', vstar.toString());
            vstar.fixed = true;
            Assert.assertTrue('Unexpected Vector check', vstar.fixed);
            
            var customClasses:Array = [null, new TestClass2(), undefined, new TestClass1()];
            
            var vcustom:Vector.<TestClass1> = Vector.<TestClass1>(customClasses);
            
            Assert.assertFalse('Unexpected Vector check', vcustom.fixed);
            Assert.assertTrue('Unexpected Vector check', vcustom.length == 4);
            Assert.assertTrue('Unexpected Vector check', vcustom[0] === null);
            Assert.assertTrue('Unexpected Vector check', vcustom[1] is TestClass2);
            Assert.assertTrue('Unexpected Vector check', vcustom[2] === null);
            Assert.assertTrue('Unexpected Vector check', vcustom[3] is TestClass1);
            
            var nested:Vector.<Vector.<TestClass1>> = Vector.<Vector.<TestClass1>>([vcustom, null, undefined, vcustom]);
            Assert.assertFalse('Unexpected Vector check', nested.fixed);
            Assert.assertTrue('Unexpected Vector check', nested.length == 4);
            Assert.assertTrue('Unexpected Vector check', nested[0] === vcustom);
            Assert.assertTrue('Unexpected Vector check', nested[1] === null);
            Assert.assertTrue('Unexpected Vector check', nested[2] === null);
            Assert.assertTrue('Unexpected Vector check', nested[3] === vcustom);
            
            //indirect/dynamic coercion
            c = Vector.<int>;
            var result:*;
            result = c(source);
            Assert.assertFalse('Unexpected Vector check', result.fixed);
            Assert.assertTrue('Unexpected Vector check', result.length == 6);
            Assert.assertFalse('Unexpected Vector check', result is Vector);
            Assert.assertFalse('Unexpected Vector check', result is Array);
            Assert.assertFalse('Unexpected Vector check', result is Vector.<*>);
            Assert.assertTrue('Unexpected Vector check', result is Vector.<int>);
            Assert.assertEquals('Unexpected Vector check', '1,0,0,0,0,0', result.toString());
            
            c = Vector.<Boolean>;
            result = c(source);
            Assert.assertFalse('Unexpected Vector check', result.fixed);
            Assert.assertTrue('Unexpected Vector check', result.length == 6);
            Assert.assertFalse('Unexpected Vector check', result is Vector);
            Assert.assertFalse('Unexpected Vector check', result is Array);
            Assert.assertTrue('Unexpected Vector check', result is Vector.<*>);
            Assert.assertTrue('Unexpected Vector check', result is Vector.<Boolean>);
            Assert.assertEquals('Unexpected Vector check', 'true,false,false,false,true,false', result.toString());
            
            c = Vector.<String>;
            result = c(source);
            
            Assert.assertFalse('Unexpected Vector check', result.fixed);
            Assert.assertTrue('Unexpected Vector check', result.length == 6);
            Assert.assertFalse('Unexpected Vector check', result is Vector);
            Assert.assertFalse('Unexpected Vector check', result is Array);
            Assert.assertTrue('Unexpected Vector check', result is Vector.<*>);
            Assert.assertTrue('Unexpected Vector check', result is Vector.<String>);
            Assert.assertEquals('Unexpected Vector check', '1,,false,NaN,[object Object],null', result.toString());
            
            c = Vector.<*>;
            result = c(source);
            
            Assert.assertFalse('Unexpected Vector check', result.fixed);
            Assert.assertTrue('Unexpected Vector check', result.length == 6);
            Assert.assertFalse('Unexpected Vector check', result is Vector);
            Assert.assertFalse('Unexpected Vector check', result is Array);
            Assert.assertTrue('Unexpected Vector check', result is Vector.<*>);
            Assert.assertFalse('Unexpected Vector check', result is Vector.<Object>);
            Assert.assertEquals('Unexpected Vector check', '1,,false,NaN,[object Object],null', result.toString());
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
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            try
            {
                caughtError = false;
                nested.push(null);
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            try
            {
                caughtError = false;
                nested.shift();
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            try
            {
                caughtError = false;
                nested.unshift(null);
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
    
            if (hasInsertAtRemoveAt()) {
                try
                {
                    caughtError = false;
                    nested['removeAt'](0);
                } catch (e:Error)
                {
                    caughtError = e is RangeError
                }
                
                Assert.assertTrue('Unexpected Vector check', caughtError);
            
                try
                {
                    caughtError = false;
                    nested['insertAt'](0, null);
                } catch (e:Error)
                {
                    caughtError = e is RangeError
                }
    
                Assert.assertTrue('Unexpected Vector check', caughtError);
            } else {
                RoyaleUnitTestRunner.consoleOut('Variance: The current target does not have support for Vector insertAt/removeAt methods', 'warn')
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
            Assert.assertTrue('unexpected coercion result', inst[0] === null);
            Assert.assertTrue('unexpected coercion result', inst[1] === null);
            Assert.assertTrue('unexpected coercion result', inst[2] === '');
            Assert.assertTrue('unexpected coercion result', inst[3] === '');
            Assert.assertTrue('unexpected coercion result', inst[4] === null);
        
            inst.push(undefined);
            Assert.assertTrue('unexpected coercion result', inst.pop() === null);
            inst.push(something);
            Assert.assertTrue('unexpected coercion result', inst.pop() === null);
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
            Assert.assertTrue('unexpected coercion result', inst[0] === false);
            Assert.assertTrue('unexpected coercion result', inst[1] === false);
            Assert.assertTrue('unexpected coercion result', inst[2] === false);
            Assert.assertTrue('unexpected coercion result', inst[3] === false);
            Assert.assertTrue('unexpected coercion result', inst[4] === false);
            Assert.assertTrue('unexpected coercion result', inst[5] === true);
            
            inst.push(undefined);
            Assert.assertTrue('unexpected coercion result', inst.pop() === false);
            inst.push(nothing);
            Assert.assertTrue('unexpected coercion result', inst.pop() === false);
            inst.push(something);
            Assert.assertTrue('unexpected coercion result', inst.pop() === true);
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
            Assert.assertTrue('unexpected coercion result', inst[0] === null);
            Assert.assertTrue('unexpected coercion result', inst[1] === null);
            Assert.assertTrue('unexpected coercion result', inst[2] === String);
            Assert.assertTrue('unexpected coercion result', inst[3] === null);
            Assert.assertTrue('unexpected coercion result', inst[4] === Array);
            Assert.assertTrue('unexpected coercion result', inst[5] === uint);
            Assert.assertTrue('unexpected coercion result', inst[6] === TestClass1);
            
            inst.push(undefined);
            Assert.assertTrue('unexpected coercion result', inst.pop() === null);
            inst.push(nothing);
            Assert.assertTrue('unexpected coercion result', inst.pop() === null);
            inst.push(something);
            Assert.assertTrue('unexpected coercion result', inst.pop() === Array);
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
            Assert.assertTrue('Unexpected Vector check', tc1Vec.length == 1);
            Assert.assertTrue('Unexpected Vector check', caughtError);
            Assert.assertNull('Unexpected Vector check', tc1Vec[0]);
    
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
            Assert.assertTrue('Unexpected Vector check', tc1Vec.length == 5);
            Assert.assertTrue('Unexpected Vector check', caughtError);
            Assert.assertNull('Unexpected Vector check', tc1Vec[0]);
            Assert.assertTrue('Unexpected Vector check', tc1Vec[1] is TestClass1);
            Assert.assertNull('Unexpected Vector check', tc1Vec[2]);
            Assert.assertNull('Unexpected Vector check', tc1Vec[3]);
            Assert.assertNull('Unexpected Vector check', tc1Vec[4]);
            
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
    
            Assert.assertTrue('Unexpected Vector check', tc1Vec.length == 9);
            Assert.assertTrue('Unexpected Vector check', caughtError);
            Assert.assertTrue('Unexpected Vector check', tc1Vec[0] is TestClass1);
            Assert.assertNull('Unexpected Vector check', tc1Vec[1]);
            Assert.assertNull('Unexpected Vector check', tc1Vec[2]);
            Assert.assertNull('Unexpected Vector check', tc1Vec[3]);
            Assert.assertNull('Unexpected Vector check', tc1Vec[4]);
            Assert.assertTrue('Unexpected Vector check', tc1Vec[5] is TestClass1);
            Assert.assertNull('Unexpected Vector check', tc1Vec[6]);
            Assert.assertNull('Unexpected Vector check', tc1Vec[7]);
            Assert.assertNull('Unexpected Vector check', tc1Vec[8]);
            
        }
        
        [Test]
        [TestVariance(variance="SWF",description="SWF tests for insertAt/removeAt are not run when swf version<30")]
        public function testVectorAdvancedMethods():void
        {
            
            var customClasses:Array = [null, new TestClass2(), undefined, new TestClass1()];
            
            var vcustom:Vector.<TestClass1> = Vector.<TestClass1>(customClasses);
            var vcustom2:Vector.<TestClass1> = vcustom.map(_mapper);
            
            Assert.assertTrue('Unexpected Vector check', vcustom2 != vcustom);
            Assert.assertTrue('Unexpected Vector check', vcustom2[0] is TestClass1);
            Assert.assertTrue('Unexpected Vector check', vcustom2[1] is TestClass1);
            Assert.assertTrue('Unexpected Vector check', vcustom2[2] is TestClass1);
            Assert.assertTrue('Unexpected Vector check', vcustom2[3] is TestClass1);
            //remove 1 item at position 1 and replace it with a new TestClass2 instance
            var vcustom3:Vector.<TestClass1> = vcustom2.splice(1, 1, new TestClass2());
            Assert.assertTrue('Unexpected Vector check', vcustom3 != vcustom2);
            Assert.assertTrue('Unexpected Vector check', vcustom3.length == 1);
            Assert.assertTrue('Unexpected Vector check', vcustom2.length == 4);
            Assert.assertTrue('Unexpected Vector check', vcustom3[0] is TestClass1);
            Assert.assertTrue('Unexpected Vector check', vcustom2[1] is TestClass2);
            
            
            if (hasInsertAtRemoveAt()) {
                vcustom3['insertAt'](0, new TestClass2());
                Assert.assertTrue('Unexpected Vector check', vcustom3.length == 2);
                Assert.assertTrue('Unexpected Vector check', vcustom3[0] is TestClass2);
                Assert.assertTrue('Unexpected Vector check', vcustom3[1] is TestClass1);
    
                var removedItem:* = vcustom3['removeAt'](0);
                Assert.assertTrue('Unexpected Vector check', vcustom3.length == 1);
                Assert.assertTrue('Unexpected Vector check', vcustom3[0] is TestClass1);
                Assert.assertTrue('Unexpected Vector check', removedItem is TestClass2);
    
                var tc1Vec:Vector.<TestClass1> = new Vector.<TestClass1>(4);
    
                //insert at invalid index:
                tc1Vec['insertAt'](6, new TestClass1());
                //no error, insertAt minimises the specified index to the Vector's length and inserts there
                Assert.assertTrue('Unexpected Vector check', tc1Vec.length == 5);
                Assert.assertTrue('Unexpected Vector check', tc1Vec[4] is TestClass1);
    
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
                Assert.assertTrue('Unexpected Vector check', tc1Vec.length == 4);
                Assert.assertEquals('Unexpected Vector check', 'null,null,null,null', tc1Vec.toString());
                //no error
                Assert.assertFalse('Unexpected Vector check', caughtError);
    
                try
                {
                    caughtError = false;
                    tc1Vec['insertAt'](-1, new TestClass1());
                } catch (e:Error)
                {
                    caughtError = e is RangeError
                }
    
                Assert.assertTrue('Unexpected Vector check', tc1Vec.length == 5);
                //new item is at position 3
                Assert.assertNotNull('Unexpected Vector check', tc1Vec[3]);
                //moving the original content (null) from position 3 to 4
                Assert.assertNull('Unexpected Vector check', tc1Vec[4]);
                //no error
                Assert.assertFalse('Unexpected Vector check', caughtError);
    
                try
                {
                    caughtError = false;
                    //even though this is out of range, it still works without error
                    tc1Vec['insertAt'](-200, new TestClass1());
                } catch (e:Error)
                {
                    caughtError = e is RangeError
                }
    
                Assert.assertTrue('Unexpected Vector check', tc1Vec.length == 6);
                //new item is at position 0
                Assert.assertNotNull('Unexpected Vector check', tc1Vec[0]);
                //the other non-null item is now at postion 4
                Assert.assertNotNull('Unexpected Vector check', tc1Vec[4]);
                //no error
                Assert.assertFalse('Unexpected Vector check', caughtError);
    
                try
                {
                    caughtError = false;
                    tc1Vec['removeAt'](-200);
                } catch (e:Error)
                {
                    caughtError = e is RangeError;
                }
    
                Assert.assertTrue('Unexpected Vector check', tc1Vec.length == 5);
                //position 0 is now null
                Assert.assertNull('Unexpected Vector check', tc1Vec[0]);
                //the non-null item is now at postion 3
                Assert.assertNotNull('Unexpected Vector check', tc1Vec[3]);
                //no error
                Assert.assertFalse('Unexpected Vector check', caughtError);
                
            }  else {
                RoyaleUnitTestRunner.consoleOut('Variance: The current target does not have support for Vector insertAt/removeAt methods, so these are untested', 'warn')
            }
           
            
        }
    
        [Test]
        public function testSort():void{
            var vi:Vector.<int> = new <int>[1, 2, 3, 4, 5];
            vi.sort(Array.NUMERIC|Array.DESCENDING);
            Assert.assertEquals('Unexpected Vector check', '5,4,3,2,1', vi.toString());
        }
        
        [Test]
        public function testVectorConcat():void
        {
            var source:Array = [1, '', false, NaN, {test: true}, undefined];
            var vi1:Vector.<int> = new <int>[1, 2, 3, 4, 5];
            var vi2:Vector.<int> = new <int>[5, 4, 3, 2, 1];
            var vu2:Vector.<uint> = new <uint>[5, 4, 3, 2, 1];
            var vi3:Vector.<int> = vi1.concat(vi2);
            Assert.assertEquals('Unexpected Vector check', '1,2,3,4,5,5,4,3,2,1', vi3.toString());
            Assert.assertTrue('Unexpected Vector check', vi3 is Vector.<int>);
            
            var caughtError:Boolean;
            try
            {
                caughtError = false;
                vi3 = vi1.concat(vu2);
            } catch (e:Error)
            {
                caughtError = e is TypeError
            }
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            var vs:Vector.<String> = Vector.<String>(source);
            var testConcat:Vector.<String> = vs.concat(vs);
            Assert.assertEquals('Unexpected Vector check', '1,,false,NaN,[object Object],null,1,,false,NaN,[object Object],null', testConcat.toString());
            Assert.assertTrue('Unexpected Vector check', testConcat is Vector.<String>);
            
        }
    
    
        [Test]
        public function testVectorSlice():void
        {
            var source:Array = [1, '', false, NaN, {test: true}, undefined];
            var vi1:Vector.<int> = new <int>[1, 2, 3, 4, 5];
            var vi2:Vector.<int> = vi1.slice();
            Assert.assertEquals('Unexpected Vector check', '1,2,3,4,5', vi2.toString());
            Assert.assertTrue('Unexpected Vector check', vi2 is Vector.<int>);
            vi2 = vi1.slice(1);
            Assert.assertEquals('Unexpected Vector check', '2,3,4,5', vi2.toString());
            Assert.assertTrue('Unexpected Vector check', vi2 is Vector.<int>);
    
            vi2 = vi1.slice(0,0);
            Assert.assertEquals('Unexpected Vector check', '', vi2.toString());
            Assert.assertTrue('Unexpected Vector check', vi2 is Vector.<int>);
    
            vi2 = vi1.slice(1,-1);
            Assert.assertEquals('Unexpected Vector check', '2,3,4', vi2.toString());
            Assert.assertTrue('Unexpected Vector check', vi2 is Vector.<int>);
        
            var vs:Vector.<String> = Vector.<String>(source);
            var testSlice:Vector.<String> = vs.slice();
            Assert.assertEquals('Unexpected Vector check', '1,,false,NaN,[object Object],null', testSlice.toString());
            Assert.assertTrue('Unexpected Vector check', testSlice is Vector.<String>);
        
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
            Assert.assertEquals('Unexpected Vector check', '3,4,5,4,3', vi2.toString());
            Assert.assertFalse('Unexpected Vector check', vi2 is Array);
            Assert.assertTrue('Unexpected Vector check', vi2 is Vector.<int>);
        }
        
        [Test]
        public function testVectorAsIs():void
        {
            var source:Array = [1, '', false, NaN, {test: true}, undefined];
            
            var vi:Vector.<int> = Vector.<int>(source);
            Assert.assertFalse('Unexpected Vector check', vi is Vector);
            Assert.assertFalse('Unexpected Vector check', vi is Array);
            Assert.assertTrue('Unexpected Vector check', vi is Vector.<int>);
            Assert.assertFalse('Unexpected Vector check', vi is Vector.<*>);
            
            var vu:Vector.<uint> = Vector.<uint>(source);
            Assert.assertFalse('Unexpected Vector check', vu is Vector);
            Assert.assertFalse('Unexpected Vector check', vu is Array);
            Assert.assertTrue('Unexpected Vector check', vu is Vector.<uint>);
            Assert.assertFalse('Unexpected Vector check', vu is Vector.<*>);
            
            var vn:Vector.<Number> = Vector.<Number>(source);
            Assert.assertFalse('Unexpected Vector check', vn is Vector);
            Assert.assertFalse('Unexpected Vector check', vn is Array);
            Assert.assertTrue('Unexpected Vector check', vn is Vector.<Number>);
            Assert.assertFalse('Unexpected Vector check', vn is Vector.<*>);
            
            var vb:Vector.<Boolean> = Vector.<Boolean>(source);
            Assert.assertFalse('Unexpected Vector check', vb is Vector);
            Assert.assertFalse('Unexpected Vector check', vb is Array);
            Assert.assertTrue('Unexpected Vector check', vb is Vector.<Boolean>);
            Assert.assertTrue('Unexpected Vector check', vb is Vector.<*>);
            
            var vs:Vector.<String> = Vector.<String>(source);
            Assert.assertFalse('Unexpected Vector check', vs is Vector);
            Assert.assertFalse('Unexpected Vector check', vs is Array);
            Assert.assertTrue('Unexpected Vector check', vs is Vector.<String>);
            Assert.assertTrue('Unexpected Vector check', vs is Vector.<*>);
            
            var vstar:Vector.<*> = Vector.<*>(source);
            Assert.assertFalse('Unexpected Vector check', vstar is Vector);
            Assert.assertFalse('Unexpected Vector check', vstar is Array);
            Assert.assertTrue('Unexpected Vector check', vstar is Vector.<*>);
            Assert.assertTrue('Unexpected Vector check', vstar is Vector.<*>);
            
            
            var customClasses:Array = [null, new TestClass2(), undefined, new TestClass1()];
            
            var vcustom:Vector.<TestClass1> = Vector.<TestClass1>(customClasses);
            
            Assert.assertFalse('Unexpected Vector check', vcustom is Vector);
            Assert.assertFalse('Unexpected Vector check', vcustom is Array);
            Assert.assertTrue('Unexpected Vector check', vcustom is Vector.<TestClass1>);
            Assert.assertTrue('Unexpected Vector check', vcustom is Vector.<*>);
    
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
    
            Assert.assertTrue('Unexpected Vector check', caughtError);
            Assert.assertEquals('Unexpected Vector check', oldDef,vcustom);
        }
        
        [Test]
        /**
         * @royalesuppresscompleximplicitcoercion Vector.<TestClass1>
         */
        public function testVectorAsIsIndirect():void
        {
            var source:Array = [1, '', false, NaN, {test: true}, undefined];
            
            var vi:Vector.<int> = Vector.<int>(source);
            Assert.assertFalse('Unexpected Vector check', vi is Vector);
            Assert.assertFalse('Unexpected Vector check', vi is Array);
            Assert.assertTrue('Unexpected Vector check', vi is Vector.<int>);
            Assert.assertFalse('Unexpected Vector check', vi is Vector.<*>);
            
            var vu:Vector.<uint> = Vector.<uint>(source);
            Assert.assertFalse('Unexpected Vector check', vu is Vector);
            Assert.assertFalse('Unexpected Vector check', vu is Array);
            Assert.assertTrue('Unexpected Vector check', vu is Vector.<uint>);
            Assert.assertFalse('Unexpected Vector check', vu is Vector.<*>);
            
            var vn:Vector.<Number> = Vector.<Number>(source);
            Assert.assertFalse('Unexpected Vector check', vn is Vector);
            Assert.assertFalse('Unexpected Vector check', vn is Array);
            Assert.assertTrue('Unexpected Vector check', vn is Vector.<Number>);
            Assert.assertFalse('Unexpected Vector check', vn is Vector.<*>);
            
            var vb:Vector.<Boolean> = Vector.<Boolean>(source);
            Assert.assertFalse('Unexpected Vector check', vb is Vector);
            Assert.assertFalse('Unexpected Vector check', vb is Array);
            Assert.assertTrue('Unexpected Vector check', vb is Vector.<Boolean>);
            Assert.assertTrue('Unexpected Vector check', vb is Vector.<*>);
            
            var vs:Vector.<String> = Vector.<String>(source);
            Assert.assertFalse('Unexpected Vector check', vs is Vector);
            Assert.assertFalse('Unexpected Vector check', vs is Array);
            Assert.assertTrue('Unexpected Vector check', vs is Vector.<String>);
            Assert.assertTrue('Unexpected Vector check', vs is Vector.<*>);
            
            var vstar:Vector.<*> = Vector.<*>(source);
            Assert.assertFalse('Unexpected Vector check', vstar is Vector);
            Assert.assertFalse('Unexpected Vector check', vstar is Array);
            Assert.assertTrue('Unexpected Vector check', vstar is Vector.<*>);
            Assert.assertTrue('Unexpected Vector check', vstar is Vector.<*>);
            
            
            var customClasses:Array = [null, new TestClass2(), undefined, new TestClass1()];
            
            var vcustom:Vector.<TestClass1> = Vector.<TestClass1>(customClasses);
            
            Assert.assertFalse('Unexpected Vector check', vcustom is Vector);
            Assert.assertFalse('Unexpected Vector check', vcustom is Array);
            Assert.assertTrue('Unexpected Vector check', vcustom is Vector.<TestClass1>);
            Assert.assertTrue('Unexpected Vector check', vcustom is Vector.<*>);
    
            var claZZ:Class = Vector.<TestClass1>;
            vcustom = claZZ(customClasses);
    
            Assert.assertFalse('Unexpected Vector check', vcustom is Vector);
            Assert.assertFalse('Unexpected Vector check', vcustom is Array);
            Assert.assertTrue('Unexpected Vector check', vcustom is Vector.<TestClass1>);
            Assert.assertTrue('Unexpected Vector check', vcustom is Vector.<*>);
        }
        
        [Test]
        public function testVectorLiteral():void
        {
            var test:* = 'hello';
            var vi:Vector.<int> = new <int>[1, 2, test, 4, 5];
            
            Assert.assertFalse('Unexpected Vector check', vi.fixed);
            Assert.assertTrue('Unexpected Vector check', vi.length == 5);
            Assert.assertEquals('Unexpected Vector check', '1,2,0,4,5', vi.toString());
        }
        
        [Test]
        public function testVectorLengthIncreasedDefaults():void
        {
            var vi:Vector.<int> = new <int>[1, 2, 3, 4, 5];
            vi.length = 10;
            Assert.assertFalse('Unexpected Vector check', vi.fixed);
            Assert.assertTrue('Unexpected Vector check', vi.length == 10);
            Assert.assertEquals('Unexpected Vector check', '1,2,3,4,5,0,0,0,0,0', vi.toString());
        }
        
        [TestVariance(variance="JS", description="Variance in js implementation for access to 'constructor' via Vector instance, js is specific vs. Vector.<*> in swf.")]
        [Test]
        public function testVectorConstructor():void
        {
            var vi:Vector.<int> = new <int>[1, 2, 3, 4, 5];
            Assert.assertTrue('Unexpected Vector check', vi['constructor'] === Vector.<int>);
            
            var vui:Vector.<uint> = new <uint>[1, 2, 3, 4, 5];
            Assert.assertTrue('Unexpected Vector check', vui['constructor'] === Vector.<uint>);
            
            var vn:Vector.<Number> = new <Number>[1, 2, 3, 4, 5];
            Assert.assertTrue('Unexpected Vector check', vn['constructor'] === Vector.<Number>);
            
            var vs:Vector.<String> = new <String>[];
            //current variance in the javascript vs. avm implementations
            const expected:Class = isJS ? Vector.<String> : Vector.<*>;
            Assert.assertTrue('Unexpected Vector check', vs['constructor'] === expected);
        }
        
        [Test]
        public function testVectorRemoveAtType():void{
            var customClasses:Array = [null, new TestClass2(), undefined, new TestClass1()];
    
            var vcustom:Vector.<TestClass1> = Vector.<TestClass1>(customClasses);
            
            var tc1:TestClass1 = vcustom.removeAt(1);
            Assert.assertTrue('Unexpected Vector check', tc1 != null);
            Assert.assertTrue('Unexpected Vector check', tc1 is TestClass1);
            Assert.assertTrue('Unexpected Vector check', tc1 is TestClass2);
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
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                vi.length += 5;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                vi.length = vi.length + 5;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                vi.length++;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                vi.length--;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                ++vi.length;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                --vi.length;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                _viTest.length = 10;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                _viTest.length += 5;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                _viTest.length = _viTest.length + 5;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                _viTest.length++;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                _viTest.length--;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                ++_viTest.length;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                --_viTest.length;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                getVector().length = 10;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                getVector().length += 5;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                getVector().length = _viTest.length + 5;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                getVector().length++;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                getVector().length--;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                ++getVector().length;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
            try
            {
                caughtError = false;
                --getVector().length;
            } catch (e:Error)
            {
                caughtError = e is RangeError
            }
            
            Assert.assertTrue('Unexpected Vector check', caughtError);
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
            Assert.assertTrue('Unexpected Vector check', vi.length == 6);
            Assert.assertEquals('Unexpected Vector check', '1,2,3,4,5,6', vi.toString());
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
            
            Assert.assertTrue('Unexpected Vector check', vi.length == 6);
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
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
            
            Assert.assertTrue('Unexpected Vector check', vi.length == 6);
            Assert.assertTrue('Unexpected Vector check', caughtError);
    
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
    
            Assert.assertTrue('Unexpected Vector check', vi.length == 6);
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
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
            Assert.assertTrue('Unexpected Vector check', caughtError);
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
            Assert.assertTrue('Unexpected Vector check', vi.length == 6);
            Assert.assertEquals('Unexpected Vector check', '1,2,3,4,5,6', vi.toString());
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
            
            Assert.assertTrue('Unexpected Vector check', vi.length == (isJS? 8 : 6));
            Assert.assertTrue('Unexpected Vector check', caughtError === (isJS ? false : true));
    
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
    
            Assert.assertTrue('Unexpected Vector check', vi.length == (isJS? 8 : 6));
            Assert.assertTrue('Unexpected Vector check', caughtError === (isJS ? false : true));
    
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
    
            Assert.assertTrue('Unexpected Vector check', vi.length == (isJS? 8 : 6));
            Assert.assertTrue('Unexpected Vector check', caughtError === (isJS ? false : true));
    
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
            Assert.assertTrue('Unexpected Vector check', caughtError  === (isJS ? false : true));
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
            Assert.assertTrue('Unexpected Vector check', vi.length == 6);
            Assert.assertEquals('Unexpected Vector check', '1,2,3,4,5,6', vi.toString());
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
    
            Assert.assertTrue('Unexpected Vector check', vi.length == 6);
            Assert.assertTrue('Unexpected Vector check', caughtError);
    
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
    
            Assert.assertTrue('Unexpected Vector check', vi.length == 6);
            Assert.assertTrue('Unexpected Vector check', caughtError);
    
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
    
            Assert.assertTrue('Unexpected Vector check', vi.length == 6);
            Assert.assertTrue('Unexpected Vector check', caughtError);
            
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
        
            Assert.assertTrue('Unexpected Vector check', vi2.length == 6);
            Assert.assertTrue('Unexpected Vector check', caughtError === (isJS ? false : true));
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
    
            Assert.assertTrue('Unexpected Vector check', vString is Vector.<String>);
            Assert.assertFalse('Unexpected Vector check', vString is Array);
            
            vString = instMyVec;
    
            Assert.assertTrue('Unexpected Vector check', vString is Vector.<String>);
            Assert.assertFalse('Unexpected Vector check', vString is Array);
    
            vString = instGetTestVector();
    
            Assert.assertTrue('Unexpected Vector check', vString is Vector.<String>);
            Assert.assertFalse('Unexpected Vector check', vString is Array);
            
            //static
            vString = getterTest;
    
            Assert.assertTrue('Unexpected Vector check', vString is Vector.<String>);
            Assert.assertFalse('Unexpected Vector check', vString is Array);
    
            vString = getTestVector();
    
            Assert.assertTrue('Unexpected Vector check', vString is Vector.<String>);
            Assert.assertFalse('Unexpected Vector check', vString is Array);
    
            vString = myVec;
    
            Assert.assertTrue('Unexpected Vector check', vString is Vector.<String>);
            Assert.assertFalse('Unexpected Vector check', vString is Array);
        }
        
        [Test]
        public function checkInterface():void{
            var v:Vector.<ITestInterface> = new <ITestInterface>[];
            v.push(new TestClass1());
            Assert.assertTrue('Unexpected Vector check', v.length == 1);
            Assert.assertTrue('Unexpected Vector check', v[0] is TestClass1);
 
            v=new Vector.<ITestInterface>();
            v.push(new TestClass1());
            Assert.assertTrue('Unexpected Vector check', v.length == 1);
            Assert.assertTrue('Unexpected Vector check', v[0] is TestClass1);
    
            v = Vector.<ITestInterface>([new TestClass1()]);
            Assert.assertTrue('Unexpected Vector check', v.length == 1);
            Assert.assertTrue('Unexpected Vector check', v[0] is TestClass1);
            var err:Boolean;
            try {
                v.push(new TestClass5())
            } catch (e:Error)
            {
                err=true;
            }
            Assert.assertTrue('Unexpected Vector check', err);
        }
    
        [Test]
        public function testFilePrivate():void{
            //specifically tested because of qualified name variations for javascript at compiler level
            //literal:
            var v:Vector.<PrivateClass> = new <PrivateClass>[];
            v.push(new PrivateClass());
            Assert.assertTrue('Unexpected Vector check', v.length == 1);
            Assert.assertTrue('Unexpected Vector check', v[0] is PrivateClass);
            //normal constructor:
            v=new Vector.<PrivateClass>();
            v.push(new PrivateClass());
            Assert.assertTrue('Unexpected Vector check', v.length == 1);
            Assert.assertTrue('Unexpected Vector check', v[0] is PrivateClass);
            //coercion
            v = Vector.<PrivateClass>([]);
            v.push(new PrivateClass());
            Assert.assertTrue('Unexpected Vector check', v.length == 1);
            Assert.assertTrue('Unexpected Vector check', v[0] is PrivateClass);
            
        }
        
    }
}


class PrivateClass {
    
    public function PrivateClass(){
    
    }
}
