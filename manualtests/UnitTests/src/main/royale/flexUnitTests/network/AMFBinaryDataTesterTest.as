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
package flexUnitTests.network
{
	
	
	import flexUnitTests.network.support.DynamicPropertyWriter;
	import flexUnitTests.network.support.DynamicTestClass2;
	import flexUnitTests.network.support.TestClass1;
	import flexUnitTests.network.support.TestClass2;
	import flexUnitTests.network.support.TestClass3;
	import flexUnitTests.network.support.TestClass4;
	import flexUnitTests.network.support.DynamicTestClass;
	
	import flexunit.framework.Assert;
    import org.apache.royale.net.remoting.amf.AMFBinaryData;
	import org.apache.royale.reflection.*;


    public class AMFBinaryDataTesterTest
	{

		[Before]
		public function setUp():void {
		}

		[After]
		public function tearDown():void {
		}

		[BeforeClass]
		public static function setUpBeforeClass():void {
		}

		[AfterClass]
		public static function tearDownAfterClass():void {
		}


		//util check functions
		private static function bytesMatchExpectedData(bd:AMFBinaryData,expected:Array,offset:int=0):Boolean{
			var len:uint = expected.length;
			var end:uint=offset+len;
			for (var i:int=offset;i<end;i++) {
				var check:uint = bd.readByteAt(i);
				if (expected[i-offset]!=check) {
					// trace('failed at ',i,expected[i-offset],check);
					return false;
				}
			}
			return true;
		}
		
		private static function dynamicKeyCountMatches(forObject:Object, expectedCount:uint):Boolean{
			var keyCount:uint=0;
			for (var key:String in forObject) {
				keyCount++;
			}
			return keyCount === expectedCount;
			
		}

		[Test]
		public function testStringObjectEncoding():void{
			var ba:AMFBinaryData = new AMFBinaryData();
			var testString:String = 'testString';
			
			ba.writeObject(testString);
			
			Assert.assertEquals("post-write length was not correct", ba.length, 12);
			Assert.assertEquals("post-write position was not correct", ba.position, 12);
			ba.position = 0;
			var readString:String = ba.readObject() as String;
			Assert.assertEquals("post-write read of written string was not correct", readString, testString);
		}
		
		[Test]
		public function testBooleanObjectEncoding():void{
			var ba:AMFBinaryData = new AMFBinaryData();
			
			ba.writeObject(false);
			ba.writeObject(true);
			
			Assert.assertEquals("post-write length was not correct", ba.length, 2);
			Assert.assertEquals("post-write position was not correct", ba.position, 2);
			ba.position = 0;

			Assert.assertTrue("post-write read of written boolean was not correct", ba.readObject() === false);
			Assert.assertTrue("post-write read of written boolean was not correct", ba.readObject() === true);
		}
		
		[Test]
		public function testNumberEncoding():void{
			var ba:AMFBinaryData = new AMFBinaryData();
			
			
			ba.writeObject(NaN);
			ba.writeObject(1.0);
			ba.writeObject(-1.0);
			ba.writeObject(1.5);
			ba.writeObject(-1.5);
			ba.writeObject(Infinity);
			ba.writeObject(-Infinity);
			
			Assert.assertEquals("post-write length was not correct", ba.length, 52);
			Assert.assertEquals("post-write position was not correct", ba.position, 52);
			ba.position = 0;
			
			var num:Number = ba.readObject();
			Assert.assertTrue("post-write read of written Number was not correct", (num is Number));
			Assert.assertTrue("post-write read of written Number was not correct", isNaN(num));
			num = ba.readObject();
			Assert.assertTrue("post-write read of written Number was not correct", (num is Number));
			Assert.assertTrue("post-write read of written Number was not correct", num === 1.0);
			num = ba.readObject();
			Assert.assertTrue("post-write read of written Number was not correct", (num is Number));
			Assert.assertTrue("post-write read of written Number was not correct", num === -1.0);
			num = ba.readObject();
			Assert.assertTrue("post-write read of written Number was not correct", (num is Number));
			Assert.assertTrue("post-write read of written Number was not correct", num === 1.5);
			num = ba.readObject();
			Assert.assertTrue("post-write read of written Number was not correct", (num is Number));
			Assert.assertTrue("post-write read of written Number was not correct", num === -1.5);
			num = ba.readObject();
			Assert.assertTrue("post-write read of written Number was not correct", (num is Number));
			Assert.assertTrue("post-write read of written Number was not correct", !isFinite(num));
			Assert.assertTrue("post-write read of written Number was not correct", (num > 0));
			num = ba.readObject();
			Assert.assertTrue("post-write read of written Number was not correct", (num is Number));
			Assert.assertTrue("post-write read of written Number was not correct", !isFinite(num));
			Assert.assertTrue("post-write read of written Number was not correct", (num < 0));
		}
		
		
		[Test]
		public function testArrayInstance():void {
			var ba:AMFBinaryData = new AMFBinaryData();
			var instance:Array = [];
			ba.writeObject(instance);

			Assert.assertEquals("post-write length was not correct", ba.length, 3);
			Assert.assertEquals("post-write position was not correct", ba.position, 3);
			
			instance = [99];
			ba.length = 0;
			ba.writeObject(instance);
			ba.position = 0;
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[9, 3, 1, 4, 99]));
			instance = ba.readObject() as Array;
			Assert.assertTrue("post-write read did not match expected result", instance.length == 1 && instance[0] == 99);
			//sparse array
			instance =[];
			instance[100]='100';
			ba.length = 0;
			ba.writeObject(instance);
			Assert.assertEquals("post-write length was not correct", ba.length, 9);
			Assert.assertEquals("post-write position was not correct", ba.position, 9);
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[9, 1, 7, 49, 48, 48, 6, 0, 1]));
			//check that read matches
			ba.position = 0;
			instance = ba.readObject();
			
			Assert.assertEquals("post-write read was not correct", instance.length, 101);
			Assert.assertEquals("post-write read was not correct", instance[100], '100');
			Assert.assertTrue("post-write read was not correct", instance[0] === undefined);
			//sparse with associative content
			instance=[];
			instance['test'] = true;
			instance[10] = 'I am number 10';
			ba.length = 0;
			ba.writeObject(instance);
			Assert.assertEquals("post-write length was not correct", ba.length, 28);
			Assert.assertEquals("post-write position was not correct", ba.position, 28);
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[9, 1, 5, 49, 48, 6, 29, 73, 32, 97, 109, 32, 110, 117, 109, 98, 101, 114, 32, 49, 48, 9, 116, 101, 115, 116, 3, 1]));
			
			//check that read matches
			ba.position = 0;
			instance = ba.readObject();
			Assert.assertEquals("post-write read was not correct", instance.length, 11);
			Assert.assertEquals("post-write read was not correct", instance[10], 'I am number 10');
			Assert.assertEquals("post-write read was not correct", instance['test'], true);
			Assert.assertTrue("post-write read was not correct", instance[0] === undefined);
			
			//edge cases
			instance=[];
			//length ==2 and Object.keys().length ==2
			//but no dense keys;
			instance[1]=true;
			instance['test'] = true;
			ba.length = 0;
			ba.writeObject(instance);
			Assert.assertEquals("post-write length was not correct", ba.length, 12);
			Assert.assertEquals("post-write position was not correct", ba.position, 12);
			
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[9, 1, 3, 49, 3, 9, 116, 101, 115, 116, 3, 1]));
			
			//empty array with length
			instance = new Array(100);
			Assert.assertEquals("pre-write array length was not correct", instance.length, 100);
			ba.length = 0;
			ba.writeObject(instance);
			Assert.assertEquals("post-write length was not correct", ba.length, 3);
			Assert.assertEquals("post-write position was not correct", ba.position, 3);
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[9, 1, 1]));
			
			ba.position = 0;
			instance = ba.readObject() as Array;
			//although the Array had a length of 100 on write, it has length zero on read:
			Assert.assertTrue("post-write read did not match expected value", instance.length == 0);
			
			var ar:Array = [1,2,3];
			var f:Function = function():void{trace('func')};
			ar['__AS3__.vec'] = f;
			ba.length=0;
			ba.writeObject(ar);
			Assert.assertEquals("post-write length was not correct", ba.length, 9);
			Assert.assertEquals("post-write position was not correct", ba.position, 9);
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[9, 7, 1, 4, 1, 4, 2, 4, 3]));
			ar = [f, 1, 2, 3, f];
			ba.length=0;
			ba.writeObject(ar);
			Assert.assertEquals("post-write length was not correct", ba.length, 15);
			Assert.assertEquals("post-write position was not correct", ba.position, 15);
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[9, 1, 3, 49, 4, 1, 3, 50, 4, 2, 3, 51, 4, 3, 1]));
			//post write read is an array with length of 4 instead of 5.
			ba.position = 0;
			ar = ba.readObject();
			Assert.assertEquals("post-write read length was not correct", ar.length, 4);
			
			
			ar = [Object, 1, 2, 3, Object];
			ba.length=0;
			ba.writeObject(ar);
			Assert.assertEquals("post-write length was not correct", ba.length, 15);
			Assert.assertEquals("post-write position was not correct", ba.position, 15);
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[9, 11, 1, 10, 11, 1, 1, 4, 1, 4, 2, 4, 3, 10, 2]));
			
			
		}
		
		
		[Test]
		public function testAnonObject():void{
			var ba:AMFBinaryData = new AMFBinaryData();
			
			var instance:Object = {};
			ba.writeObject(instance);
			
			Assert.assertEquals("post-write length was not correct", ba.length, 4);
			Assert.assertEquals("post-write position was not correct", ba.position, 4);
			ba.position = 0;

			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[10, 11, 1, 1]));
			instance = ba.readObject();
			Assert.assertTrue("post-write read did not match expected result", dynamicKeyCountMatches(instance, 0));
			
			var obj1:Object = {test:true};
			var obj2:Object = {test:'maybe'};
			var obj3:Object = {test:true};
			ba.length = 0;
			ba.writeObject([obj1, obj2, obj3]);
			ba.position = 0;
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[9, 7, 1, 10, 11, 1, 9, 116, 101, 115, 116, 3, 1, 10, 1, 0, 6, 11, 109, 97, 121, 98, 101, 1, 10, 1, 0, 3, 1]));
			
		}
		
		
		[Test]
		public function testFunction():void{
			var ba:AMFBinaryData = new AMFBinaryData();
			//functions are always encoded as undefined
			var instance:Function = function():void {};
			ba.writeObject(instance);
			
			Assert.assertEquals("post-write length was not correct", ba.length, 1);
			Assert.assertEquals("post-write position was not correct", ba.position, 1);
			ba.position = 0;
			
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[0]));
			instance = ba.readObject();
			
			Assert.assertTrue("post-write read did not match expected result", instance === null);
			
			//for a property that has a function value, the property is also undefined
			var objectWithFunction:Object = {'function': function():void {}};
			ba.length=0;
			ba.writeObject(objectWithFunction);
			
			Assert.assertEquals("post-write length was not correct", ba.length, 4);
			Assert.assertEquals("post-write position was not correct", ba.position, 4);
			ba.position = 0;
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[10, 11, 1, 1]));
			
			//the dynamic deserialized object has no key for the function value
			var obj:Object = ba.readObject();
			Assert.assertTrue("post-write read did not match expected result", dynamicKeyCountMatches(obj,0));
			
			ba.length=0;
			var tc4:TestClass4 = new TestClass4();
			tc4.testField1 =function():void {};
			
			ba.writeObject(tc4);
			Assert.assertEquals("post-write length was not correct", ba.length, 15);
			Assert.assertEquals("post-write position was not correct", ba.position, 15);
			
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[10, 19, 1, 21, 116, 101, 115, 116, 70, 105, 101, 108, 100, 49, 0]));
			
		}


		[Test]
		/**
		 * @royaleignorecoercion TestClass1
		 */
		public function testBasicClassInstance():void
		{
			var ba:AMFBinaryData = new AMFBinaryData();
			
			var instance:TestClass1 = new TestClass1();
			ba.writeObject(instance);
			
			Assert.assertEquals("post-write length was not correct", ba.length, 16);
			Assert.assertEquals("post-write position was not correct", ba.position, 16);
			
			ba.position = 0;
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[10, 19, 1, 21, 116, 101, 115, 116, 70, 105, 101, 108, 100, 49, 6, 1]));
			ba.position = 0;
			
			var anonObject:Object = ba.readObject();
			
			Assert.assertTrue('post-write read did not match expected value', anonObject['testField1'] === instance.testField1 );
			
			var multipleDifferentInstances:Array = [new TestClass1(), new TestClass2()];
			ba.length = 0;
			ba.writeObject(multipleDifferentInstances);
			
			Assert.assertEquals("post-write length was not correct", ba.length, 24);
			Assert.assertEquals("post-write position was not correct", ba.position, 24);
			ba.position = 0;
			
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[9, 5, 1, 10, 19, 1, 21, 116, 101, 115, 116, 70, 105, 101, 108, 100, 49, 6, 1, 10, 19, 1, 0, 3]));
			
		}

		[Test]
		public function testDynamicClassInstance():void
		{
			var ba:AMFBinaryData = new AMFBinaryData();
			var instance:DynamicTestClass = new DynamicTestClass();
			ba.writeObject(instance);
			
			Assert.assertEquals("post-write length was not correct", ba.length, 25);
			Assert.assertEquals("post-write position was not correct", ba.position, 25);
			ba.position = 0;
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[10, 27, 1, 39, 115, 101, 97, 108, 101, 100, 73, 110, 115, 116, 97, 110, 99, 101, 80, 114, 111, 112, 49, 2, 1]));
			
			instance['someDynamicField'] = 'nonSealedPropValue';
			
			ba.writeObject(instance);
			Assert.assertEquals("post-write length was not correct", ba.length, 62);
			Assert.assertEquals("post-write position was not correct", ba.position, 62);
			ba.position = 0;
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[10, 27, 1, 39, 115, 101, 97, 108, 101, 100, 73, 110, 115, 116, 97, 110, 99, 101, 80, 114, 111, 112, 49, 2, 33, 115, 111, 109, 101, 68, 121, 110, 97, 109, 105, 99, 70, 105, 101, 108, 100, 6, 37, 110, 111, 110, 83, 101, 97, 108, 101, 100, 80, 114, 111, 112, 86, 97, 108, 117, 101, 1]));
			
			var instanceAnon:Object = ba.readObject();
			Assert.assertTrue('post-write read did not match expected value', instanceAnon['someDynamicField'] === 'nonSealedPropValue' );
			
			
		}
		
		[Test]
		public function testByteArray():void{
			//on swf it is native ByteArray that encodes to 'ByteArray', in js it is AMFBinaryData
			COMPILE::SWF{
				import flash.utils.ByteArray;
				var source:ByteArray = new ByteArray();
			}
			
			COMPILE::JS{
				var source:AMFBinaryData = new AMFBinaryData();
			}
			
			for (var i:uint=0;i<26;i++) source.writeByte(i);
			var ba:AMFBinaryData = new AMFBinaryData();
			var holder:Array = [source, source];
			
			ba.writeObject(holder);
			Assert.assertEquals("post-write error length was not correct", ba.length, 33);
			Assert.assertEquals("post-write error position was not correct", ba.position, 33);
			ba.position = 0;
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[9, 5, 1, 12, 53, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 12, 2]));
		}


		[Test]
		public function testExternalizable():void
		{
			var ba:AMFBinaryData = new AMFBinaryData();
			var test3:TestClass3 = new TestClass3();
			//TestClass3 is externalizable and does not have an alias, this is an error in flash
			
			var err:Error;
			try {
				ba.writeObject(test3);
			} catch(e:Error) {
				err = e;
			}

			Assert.assertTrue("externalizable writing should fail without an alias registered", err != null);
			Assert.assertEquals("post-write error length was not correct", ba.length, 1);
			Assert.assertEquals("post-write error position was not correct", ba.position, 1);
			ba.position = 0;
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[10]));
			
			ba.length=0;
			//register an alias
			registerClassAlias('TestClass3', TestClass3);
			ba.writeObject(test3);
			Assert.assertEquals("post-write length was not correct", ba.length, 18);
			Assert.assertEquals("post-write position was not correct", ba.position, 18);
			
			ba.position = 0;
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[10, 7, 21, 84, 101, 115, 116, 67, 108, 97, 115, 115, 51, 9, 3, 1, 6, 0]));
			
			test3.content[0] = (test3.content[0]).split("").reverse().join("");
			ba.writeObject(test3);
			Assert.assertEquals("post-write length was not correct", ba.length, 28);
			Assert.assertEquals("post-write position was not correct", ba.position, 28);
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[10, 7, 21, 84, 101, 115, 116, 67, 108, 97, 115, 115, 51, 9, 3, 1, 6, 21, 51, 115, 115, 97, 108, 67, 116, 115, 101, 84]));
			
			ba.position=0;
			var test3Read:TestClass3 = ba.readObject() as TestClass3;

			//proof that it created a new instance, and that the reversed content string content is present in the new instance
			Assert.assertTrue("post-write read did not match expected data", test3Read.content[0] == test3.content[0]);
			
		}
		
		
		[Test]
		public function testDynamicPropertyWriter():void{
			var ba:AMFBinaryData = new AMFBinaryData();
			var instance:DynamicTestClass2 = new DynamicTestClass2();
			instance['_underscore'] = 'pseudo - private value';
			instance['raining'] = 'cats and dogs';
			
			ba.writeObject(instance);
			
			Assert.assertEquals("post-write length was not correct", ba.length, 84);
			Assert.assertEquals("post-write position was not correct", ba.position, 84);
			
			//in this case the order of encoding the dynamic fields is not defined. So we need to account for the valid serialization options of either output sequence of the two fields
			var raining_then_underscore:Array = [10, 27, 1, 39, 115, 101, 97, 108, 101, 100, 73, 110, 115, 116, 97, 110, 99, 101, 80, 114, 111, 112, 49, 2, 15, 114, 97, 105, 110, 105, 110, 103, 6, 27, 99, 97, 116, 115, 32, 97, 110, 100, 32, 100, 111, 103, 115, 23, 95, 117, 110, 100, 101, 114, 115, 99, 111, 114, 101, 6, 45, 112, 115, 101, 117, 100, 111, 32, 45, 32, 112, 114, 105, 118, 97, 116, 101, 32, 118, 97, 108, 117, 101, 1];
			var underscore_then_raining:Array = [10, 27, 1, 39, 115, 101, 97, 108, 101, 100, 73, 110, 115, 116, 97, 110, 99, 101, 80, 114, 111, 112, 49, 2, 23, 95, 117, 110, 100, 101, 114, 115, 99, 111, 114, 101, 6, 45, 112, 115, 101, 117, 100, 111, 32, 45, 32, 112, 114, 105, 118, 97, 116, 101, 32, 118, 97, 108, 117, 101, 15, 114, 97, 105, 110, 105, 110, 103, 6, 27, 99, 97, 116, 115, 32, 97, 110, 100, 32, 100, 111, 103, 115, 1];
			
			ba.position=0;
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba, raining_then_underscore) || bytesMatchExpectedData(ba, underscore_then_raining));
			
			//now test the same instance with an IDynamicPropertyWriter that ignores the underscored field, only outputting the 'raining' field
			ba.length = 0;
			AMFBinaryData.dynamicPropertyWriter = new DynamicPropertyWriter();
			ba.writeObject(instance);
			Assert.assertEquals("post-write length was not correct", ba.length, 48);
			Assert.assertEquals("post-write position was not correct", ba.position, 48);
			ba.position=0;
			Assert.assertTrue("post-write bytes did not match expected data", bytesMatchExpectedData(ba,[10, 27, 1, 39, 115, 101, 97, 108, 101, 100, 73, 110, 115, 116, 97, 110, 99, 101, 80, 114, 111, 112, 49, 2, 15, 114, 97, 105, 110, 105, 110, 103, 6, 27, 99, 97, 116, 115, 32, 97, 110, 100, 32, 100, 111, 103, 115, 1]));
			
			//remove the custom dynamicPropertyWriter
			AMFBinaryData.dynamicPropertyWriter = null;
			
		}

		[Test]
		public function testXML():void{
			var ba:AMFBinaryData = new AMFBinaryData();
			var xml:XML = <xml><item/></xml>;
			
			ba.writeObject(xml);
			ba.position = 0;
			
			var xml2:XML = ba.readObject() as XML;
			
			//javascript toXMLString pretty printing does not match exactly flash...
			Assert.assertTrue('XML round-tripping failed', xml.toXMLString() === xml2.toXMLString());
		}
		
	}
}
