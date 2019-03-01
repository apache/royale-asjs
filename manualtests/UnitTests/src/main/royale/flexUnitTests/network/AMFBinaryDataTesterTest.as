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
	
	
	import flexUnitTests.network.support.TestClass1;
	import flexUnitTests.network.support.TestClass2;
	import flexUnitTests.network.support.TestClass3;
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
		/**
		 * @royaleigrnorecoercion TestClass1
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

	
		
	}
}
