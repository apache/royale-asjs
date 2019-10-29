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
    import flexUnitTests.mxroyale.support.TestClass3;
    
    //import testshim.RoyaleUnitTestRunner;
    
    
    import org.apache.royale.test.asserts.assertEquals;
    import org.apache.royale.test.asserts.assertTrue;
    
    import mx.utils.*;
    
    public class FlexSDK_ObjectUtil_FLEX_34852_Tests
    {
    
        [Test]
        public function test_getValue_for_two_field_path_non_fileprivate():void
        {
            //given
            const streetPrefix:String = "Street no. ";
            const index:int = 1;
            var obj:TestClass3 = new TestClass3(index, "SomeObject", streetPrefix);
        
            //when
            var streetName:String = ObjectUtil.getValue(obj, ["address", "street"]) as String;
        
            //then
            assertEquals(streetPrefix + index, streetName);
        }
    
        [Test]
        public function test_getValue_for_one_field_path_non_fileprivate():void
        {
            //given
            const streetPrefix:String = "Street no. ";
            const index:int = 1;
            var obj:TestClass3 = new TestClass3(index, "SomeObject", streetPrefix);
        
            //when
            var result:* = ObjectUtil.getValue(obj, ["address"]);
        
            //then
            assertEquals(obj.address, result);
        }
        
        
        
        [Test]
        public function test_getValue_for_two_field_path():void
        {
            //given
            const streetPrefix:String = "Street no. ";
            const index:int = 1;
            var obj:ObjectUtil_FLEX_34852_VO = new ObjectUtil_FLEX_34852_VO(index, "SomeObject", streetPrefix);
            
            //when
            var streetName:String = ObjectUtil.getValue(obj, ["address", "street"]) as String;
            
            //then
            assertEquals(streetPrefix + index, streetName);
        }
        
        [Test]
        public function test_getValue_for_one_field_path():void
        {
            //given
            const streetPrefix:String = "Street no. ";
            const index:int = 1;
            var obj:ObjectUtil_FLEX_34852_VO = new ObjectUtil_FLEX_34852_VO(index, "SomeObject", streetPrefix);
            
            //when
            var result:* = ObjectUtil.getValue(obj, ["address"]);
            
            //then
            assertEquals(obj.address, result);
        }
        
        [Test]
        public function test_getValue_for_zero_field_path_returns_parameter():void
        {
            //given
            var obj:ObjectUtil_FLEX_34852_VO = new ObjectUtil_FLEX_34852_VO(1, "SomeObject", "Street no. ");
            
            //when
            var result:* = ObjectUtil.getValue(obj, null);
            
            //then
            assertEquals(obj, result);
        }
        
        [Test]
        public function test_getValue_for_null_object_returns_undefined():void
        {
            //given
            var obj:ObjectUtil_FLEX_34852_VO = null;
            
            //when
            var result:* = ObjectUtil.getValue(obj, ["address", "street"]);
            
            //then
            assertTrue(result === undefined);
        }
        
        [Test]
        public function test_getValue_for_wrong_path_returns_undefined():void
        {
            //given
            var obj:ObjectUtil_FLEX_34852_VO = new ObjectUtil_FLEX_34852_VO(1, "SomeObject", "Street no. ");
            
            //when
            var result:* = ObjectUtil.getValue(obj, ["address", "name"]);
            
            //then
            assertTrue(result === undefined);
        }
    }
}

class ObjectUtil_FLEX_34852_VO
{
    [Bindable]
    public var name:String;
    
    [Bindable]
    public var address:ObjectUtil_FLEX_34852_AddressVO;
    
    [Bindable]
    public var index:Number;
    
    public function ObjectUtil_FLEX_34852_VO(index:Number, namePrefix:String, streetPrefix:String)
    {
        this.index = index;
        this.name = namePrefix + index;
        this.address = new ObjectUtil_FLEX_34852_AddressVO(streetPrefix + index);
    }
}

class ObjectUtil_FLEX_34852_AddressVO
{
    [Bindable]
    public var street:String;
    
    public function ObjectUtil_FLEX_34852_AddressVO(street:String)
    {
        this.street = street;
    }
}
