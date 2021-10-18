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
package flexUnitTests.mxroyale
{
   // import testshim.RoyaleUnitTestRunner;
    
    import org.apache.royale.test.asserts.assertEquals;
    
    import org.apache.royale.test.asserts.assertFalse;
    import org.apache.royale.test.asserts.assertTrue;
    
    import mx.utils.*;
    
    public class FlexSDK_ObjectUtil_Compare_Tests
    {
        private static const A_SMALLER_THAN_B:int = -1;
        private static const A_LARGER_THAN_B:int = 1;
        private static const A_EQUAL_TO_B:int = 0;
    
        [Test]
        public function test_object_is_smaller_when_first_property_smaller_even_if_second_property_larger():void
        {
            //given
           // var objectA:Object = {propertyA:1, propertyB:23};
           // var objectB:Object = {propertyA:45, propertyB:2};
    
            var objectA:Object = {'propertyA':1, 'propertyB':23};
            var objectB:Object = {'propertyA':45, 'propertyB':2};
        
            //when
            var compareResult:int = ObjectUtil.compare(objectA, objectB);
        
            //then
            assertEquals(A_SMALLER_THAN_B, compareResult);
        }
    
        [Test]
        public function test_object_is_larger_when_first_property_larger_even_if_second_property_smaller():void
        {
            //given
           // var objectA:Object = {propertyA:45, propertyB:2};
           // var objectB:Object = {propertyA:1, propertyB:23};
    
            var objectA:Object = {'propertyA':45, 'propertyB':2};
            var objectB:Object = {'propertyA':1, 'propertyB':23};
        
            //when
            var compareResult:int = ObjectUtil.compare(objectA, objectB);
        
            //then
            assertEquals(A_LARGER_THAN_B, compareResult);
        }
    
        [Test]
        public function test_object_is_smaller_even_when_common_properties_equal_but_missing_extra_properties():void
        {
            //given
            //var objectA:Object = {propertyA:45};
            //var objectB:Object = {propertyA:45, propertyB:2};
    
            var objectA:Object = {'propertyA':45};
            var objectB:Object = {'propertyA':45, 'propertyB':2};
        
            //when
            var compareResult:int = ObjectUtil.compare(objectA, objectB);
        
            //then
            assertEquals(A_SMALLER_THAN_B, compareResult);
        }
    
        [Test]
        public function test_object_is_smaller_even_when_common_property_larger_but_missing_extra_properties():void
        {
            //given
            //var objectA:Object = {propertyA:46};
            //var objectB:Object = {propertyA:45, propertyB:2};
    
            var objectA:Object = {'propertyA':46};
            var objectB:Object = {'propertyA':45, 'propertyB':2};
        
            //when
            var compareResult:int = ObjectUtil.compare(objectA, objectB);
        
            //then
            assertEquals(A_SMALLER_THAN_B, compareResult);
        }
    
        [Test]
        public function test_sealed_class_instance_larger_than_anonymous_object_with_same_properties_and_same_values():void
        {
            //given
            var objectA:PersonVO = new PersonVO("John", 23);
            var objectB:Object = {name:"John", age:23};
        
            //when
            var compareResult:int = ObjectUtil.compare(objectA, objectB);
        
            //then
            assertEquals(A_LARGER_THAN_B, compareResult);
        }
    
        [Test]
        public function test_sealed_class_instance_larger_than_dynamic_class_instance_with_same_properties_and_same_values():void
        {
            //given
            var objectA:PersonVO = new PersonVO("John", 23);
            var objectB:DynamicPersonVO = new DynamicPersonVO("John", 23);
        
            //when
            var compareResult:int = ObjectUtil.compare(objectA, objectB);
        
            //then
            assertEquals(A_LARGER_THAN_B, compareResult);
        }
    
        [Test]
        public function test_null_and_undefined_are_seen_equal():void
        {
            //given
            //var objectA:Object = {propertyA:45, propertyB:null};
            //var objectB:Object = {propertyA:45, propertyB:undefined};
    
            var objectA:Object = {'propertyA':45, 'propertyB':null};
            var objectB:Object = {'propertyA':45, 'propertyB':undefined};
        
            //when
            var compareResult:int = ObjectUtil.compare(objectA, objectB);
        
            //then
            assertEquals(A_EQUAL_TO_B, compareResult);
        }
    
        [Test]
        public function test_NaN_seen_larger_than_largest_number():void
        {
            //given
            //var objectA:Object = {propertyA:Number.MAX_VALUE};
           // var objectB:Object = {propertyA:NaN};
    
            var objectA:Object = {'propertyA':Number.MAX_VALUE};
            var objectB:Object = {'propertyA':NaN};
        
            //when
            var compareResult:int = ObjectUtil.compare(objectA, objectB);
        
            //then
            assertEquals(A_SMALLER_THAN_B, compareResult);
        }
    }
}

class PersonVO
{
    public var name:String;
    public var age:uint;
    
    public function PersonVO(name:String, age:uint)
    {
        this.name = name;
        this.age = age;
    }
}

dynamic class DynamicPersonVO extends PersonVO
{
    public function DynamicPersonVO(name:String, age:uint)
    {
        super(name, age);
    }
}

