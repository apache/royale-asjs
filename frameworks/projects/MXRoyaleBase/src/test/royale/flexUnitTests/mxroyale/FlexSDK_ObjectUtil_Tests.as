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
    //import testshim.RoyaleUnitTestRunner;
    
    COMPILE::SWF{
        import flash.utils.Dictionary;
        import flash.utils.Proxy;
    }
    
    

    import org.apache.royale.test.asserts.assertEquals;
    
    import org.apache.royale.test.asserts.assertFalse;
    import org.apache.royale.test.asserts.assertTrue;
    
    import mx.utils.*;
    
    public class FlexSDK_ObjectUtil_Tests
    {
        //--------------------------------------------------------------------------
        //
        //  isDynamicObject()
        //
        //--------------------------------------------------------------------------
        
        [Test]
        public function test_dynamic_class_instance_recognized_as_dynamic_object():void
        {
            //then
            assertTrue(ObjectUtil.isDynamicObject(new DynamicVO("John")));
        }
        
        [Test]
        public function test_anonymous_class_instance_recognized_as_dynamic_object():void
        {
            //then
            assertTrue(ObjectUtil.isDynamicObject({name:"John"}));
        }
        
        [Test]
        public function test_array_instance_recognized_as_dynamic_object():void
        {
            //then
            assertTrue(ObjectUtil.isDynamicObject([]));
        }
        
        [Test]
        public function test_XML_instance_recognized_as_dynamic_object():void
        {
            //then
            assertTrue(ObjectUtil.isDynamicObject(new XML()));
        }
        
        [Test]
        public function test_Proxy_instance_recognized_as_sealed_object_instance():void
        {
            //then
            COMPILE::SWF{
                assertFalse(ObjectUtil.isDynamicObject(new Proxy()));
            }
            COMPILE::JS{
                const ProxyClass:Object = window['Proxy'];
                /*if (ProxyClass)
                    assertFalse(ObjectUtil.isDynamicObject(new ProxyClass()));
                else {
                    assertTrue(false, "this browser target does not have native Proxy support");
                }*/
                //@todo
                assertTrue(true, 'Proxy not yet emulated on JS');
            }
        }
        
        [Test]
        public function test_ObjectProxy_with_implicit_target_object_instance_recognized_as_dynamic_instance():void
        {
            //then
            assertTrue(ObjectUtil.isDynamicObject(new ObjectProxy()));
        }
        
        [Test]
        public function test_ObjectProxy_with_explicit_target_object_instance_recognized_as_dynamic_instance():void
        {
            //then
            assertTrue(ObjectUtil.isDynamicObject(new ObjectProxy({})));
        }
        
        [Test]
        public function test_dictionary_instance_recognized_as_dynamic_object():void
        {
            //then
            COMPILE::SWF{
                assertTrue(ObjectUtil.isDynamicObject(new Dictionary()));
            }
            COMPILE::JS{
                assertTrue(ObjectUtil.isDynamicObject(new Map()));
            }
        }
        
        [Test]
        public function test_sealed_class_instance_recognized_as_non_dynamic_object():void
        {
            //then
            assertFalse(ObjectUtil.isDynamicObject(new NonDynamicVO("John")));
        }
        
        [Test]
        public function test_null_does_not_throw_fatal():void
        {
            //then
            assertFalse(ObjectUtil.isDynamicObject(null));
        }
        
        //--------------------------------------------------------------------------
        //
        //  getEnumerableProperties()
        //
        //--------------------------------------------------------------------------
        
        [Test]
        public function test_enumerable_properties_of_anonymous_object():void
        {
            //given
            //var object:Object = {name:"John", age:32}; // Does not survive minification in JS
            var object:Object = {'name':"John", 'age':32}; //Safe on JS and SWF
            
            //when
            var enumerableProperties:Array = ObjectUtil.getEnumerableProperties(object);
           // RoyaleUnitTestRunner.consoleOut('test_enumerable_properties_of_anonymous_object:'+enumerableProperties.join(','))
            //then
            assertTrue(ArrayUtil.arrayValuesMatch(["age", "name"], enumerableProperties));
        }
        
        [Test]
        public function test_enumerable_properties_of_null():void
        {
            //when
            var enumerableProperties:Array = ObjectUtil.getEnumerableProperties(null);
            
            //then
            assertEquals(0, enumerableProperties.length);
        }
        
        [Test]
        public function test_enumerable_properties_of_dictionary():void
        {
            //given
            COMPILE::SWF{
                var object:Dictionary = new Dictionary(false);
                object["name"] = "John";
                object["age"] = 9;
            }
            COMPILE::JS{
                var object:Map = new Map();
                object.set("name", "John");
                object.set("age", 9);
            }
            
            //when
            var enumerableProperties:Array = ObjectUtil.getEnumerableProperties(object);
            
            //then
            assertTrue(ArrayUtil.arrayValuesMatch(["age", "name"], enumerableProperties));
        }
        
        [Test]
        public function test_enumerable_properties_of_dynamic_class_instance():void
        {
            //given
            var object:DynamicVO = new DynamicVO("John");
            object["age"] = 9;
            object["height"] = 6.1;
            
            //when
            var enumerableProperties:Array = ObjectUtil.getEnumerableProperties(object);
            
            //then
            assertTrue(ArrayUtil.arrayValuesMatch(["height", "age"], enumerableProperties));
        }
        
        [Test]
        public function test_enumerable_properties_of_associative_array():void
        {
            //given
            var object:Array = [];
            object["age"] = 9;
            object["name"] = "John";
            
            //when
            var enumerableProperties:Array = ObjectUtil.getEnumerableProperties(object);
            
            //then
            assertTrue(ArrayUtil.arrayValuesMatch(["age", "name"], enumerableProperties));
        }
        
        [Test]
        public function test_enumerable_properties_of_indexed_array():void
        {
            //given
            var object:Array = [9, "John"];
            
            //when
            var enumerableProperties:Array = ObjectUtil.getEnumerableProperties(object);
            //RoyaleUnitTestRunner.consoleOut('test_enumerable_properties_of_indexed_array :'+enumerableProperties.join(","))
            //then
            assertTrue(ArrayUtil.arrayValuesMatch([0, 1], enumerableProperties));
        }
        
        [Test]
        public function test_enumerable_properties_of_manually_indexed_array():void
        {
            //given
            var object:Array = [];
            object[3] = 9;
            object[5] = "John";
            
            //when
            var enumerableProperties:Array = ObjectUtil.getEnumerableProperties(object);
            
            //then
            assertTrue(ArrayUtil.arrayValuesMatch([3, 5], enumerableProperties));
        }
        
        [Test]
        public function test_enumerable_properties_of_sealed_class_instance():void
        {
            //given
            var object:Object = new NonDynamicVO("John");
            
            //when
            var enumerableProperties:Array = ObjectUtil.getEnumerableProperties(object);
            
            //then
            assertEquals(0, enumerableProperties.length);
        }
        
        
        //--------------------------------------------------------------------------
        //
        //  valuesAreSubsetOfObject()
        //
        //--------------------------------------------------------------------------
        
        [Test]
        public function test_empty_anonymous_object_is_subset_of_empty_anonymous_instance():void
        {
            //then
            assertTrue(ObjectUtil.valuesAreSubsetOfObject({}, {}));
        }
        
        [Test]
        public function test_empty_anonymous_object_is_subset_of_sealed_class_instance():void
        {
            //then
            assertTrue(ObjectUtil.valuesAreSubsetOfObject({}, new NonDynamicVO("John")));
        }
        
        [Test]
        public function test_empty_anonymous_object_is_subset_of_dynamic_class_instance():void
        {
            //then
            assertTrue(ObjectUtil.valuesAreSubsetOfObject({}, new DynamicVO("John")));
        }
        
        [Test]
        public function test_anonymous_object_with_same_name_is_subset_of_similar_dynamic_class_instance():void
        {
            //then
            assertTrue(ObjectUtil.valuesAreSubsetOfObject({name:"John"}, new DynamicVO("John")));
        }
        
        [Test]
        public function test_anonymous_object_with_same_properties_and_values_is_subset_of_similar_dynamic_class_instance_with_one_property_manually_set():void
        {
            //given
            var john:DynamicVO = new DynamicVO("John");
            john.age = 23;
            john.height = 6;
            
            //then
            assertTrue(ObjectUtil.valuesAreSubsetOfObject({name:"John", age:23}, john));
        }
        
        [Test]
        public function test_anonymous_object_with_different_name_is_not_subset_of_similar_dynamic_class_instance():void
        {
            //then
            assertFalse(ObjectUtil.valuesAreSubsetOfObject({name:"Max"}, new DynamicVO("John")));
        }
        
        [Test]
        public function test_anonymous_object_with_same_name_is_subset_of_similar_sealed_class_instance():void
        {
            //then
            assertTrue(ObjectUtil.valuesAreSubsetOfObject({name:"John"}, new NonDynamicVO("John")));
        }
        
        [Test]
        public function test_anonymous_object_with_different_name_is_not_subset_of_similar_sealed_class_instance():void
        {
            //then
            assertFalse(ObjectUtil.valuesAreSubsetOfObject({name:"Max"}, new NonDynamicVO("John")));
        }
        
        [Test]
        public function test_anonymous_object_with_extra_property_is_not_subset_of_similar_sealed_class_instance():void
        {
            //then
            assertFalse(ObjectUtil.valuesAreSubsetOfObject({name:"Max", age:23}, new NonDynamicVO("John")));
        }
        
        [Test]
        public function test_sealed_object_is_a_subset_of_itself():void
        {
            //given
            var max:NonDynamicVO = new NonDynamicVO("Max");
            
            //then
            assertTrue(ObjectUtil.valuesAreSubsetOfObject(max, max));
        }
        
        [Test]
        public function test_sealed_object_is_not_a_subset_of_similar_dynamic_object():void
        {
            //then
            assertFalse(ObjectUtil.valuesAreSubsetOfObject(new NonDynamicVO("Max"), {name:"Max"}));
        }
        
        [Test]
        public function test_sealed_object_is_not_a_subset_of_similar_sealed_object():void
        {
            //then
            assertFalse(ObjectUtil.valuesAreSubsetOfObject(new NonDynamicVO("Max"), new NonDynamicVO("Max")));
        }
    }
}

dynamic class DynamicVO
{
    public var name:String;
    
    public function DynamicVO(name:String)
    {
        this.name = name;
    }
}

class NonDynamicVO
{
    public var name:String;
    
    public function NonDynamicVO(name:String)
    {
        this.name = name;
    }
}
