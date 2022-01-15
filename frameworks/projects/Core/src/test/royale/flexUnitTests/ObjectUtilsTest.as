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
package flexUnitTests
{
	import org.apache.royale.core.Strand;
	import org.apache.royale.test.asserts.*;
	import org.apache.royale.utils.object.classFromInstance;
	import org.apache.royale.utils.object.objectsMatch;
	import org.apache.royale.test.asserts.assertFalse;
	import org.apache.royale.test.asserts.assertTrue;
	import org.apache.royale.utils.array.arraysMatch;

	public class ObjectUtilsTest
	{
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testClass():void
		{
			var strand:Strand = new Strand();
			assertEquals(classFromInstance(strand), Strand, "Error finding class from instance.");
		}
		[Test]
		public function testObjectsMatch():void
		{
			var first:Object = {name:"foo",age:10,human:false,children:[{name:"bar",age:1},{name:"baz",age:2}]}
			var second:Object = {name:"foo",age:10,human:false,children:[{name:"bar",age:1},{name:"baz",age:2}]}
			assertTrue(objectsMatch(first,second,true),"deep comparison of objects should match");
			assertFalse(objectsMatch(first,second,false),"shallow comparison of objects should not match");
		}
		[Test]
		public function testArraysMatch():void
		{
			var firstArray:Array = [1,2,3,4,"5",6];
			var secondArray:Array = [1,2,3,"4",5,6];

			assertFalse(arraysMatch(firstArray,secondArray,true),"deep comparison of mismatched simple array values should not match");
			assertFalse(arraysMatch(firstArray,secondArray,false),"shallow comparison of mismatched simple array values should not match");
			// assertFalse(objectsMatch(firstArray,secondArray,true),"deep comparison of mismatched simple array values should not match (using objectMatch)");
			// assertFalse(objectsMatch(firstArray,secondArray,false),"shallow comparison of mismatched simple array values should not match (using objectMatch)");


			firstArray = [1,2,3,4,5,6];
			secondArray = [1,2,3,4,5,6];
			assertTrue(arraysMatch(firstArray,secondArray,true),"deep comparison of like number values should match");
			assertTrue(arraysMatch(firstArray,secondArray,false),"shallow comparison of like number values should match");
			assertTrue(objectsMatch(firstArray,secondArray,true),"deep comparison of like number values should match (using objectMatch)");
			assertTrue(objectsMatch(firstArray,secondArray,false),"shallow comparison of like number values should match (using objectMatch)");

			secondArray.push(7);
			assertFalse(arraysMatch(firstArray,secondArray,true),"deep comparison should not match when lengths are different");
			assertFalse(arraysMatch(firstArray,secondArray,false),"shallow comparison should not match when lengths are different");
			// assertFalse(objectsMatch(firstArray,secondArray,true),"deep comparison should not match when lengths are different (using objectMatch)");
			// assertFalse(objectsMatch(firstArray,secondArray,false),"shallow comparison should not match when lengths are different (using objectMatch)");

			var first:Object = {name:"foo",age:10,human:false,children:[{name:"bar",age:1},{name:"baz",age:2}]}
			var second:Object = {name:"foo",age:10,human:false,children:[{name:"bar",age:1},{name:"baz",age:2}]}
			firstArray = [1,2,3,"4",5,first];
			secondArray = [1,2,3,"4",5,second];

			assertTrue(arraysMatch(firstArray,secondArray,true),"deep array comparison with nested object should match");
			assertFalse(arraysMatch(firstArray,secondArray,false),"shallow array comparison with nested object should not match");
			// assertTrue(objectsMatch(firstArray,secondArray,true),"deep array comparison with nested object should match (using objectMatch)");
			// assertFalse(objectsMatch(firstArray,secondArray,false),"shallow array comparison with nested object should not match (using objectMatch)");

		}
	}
}