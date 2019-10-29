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
    
    
    import mx.utils.ObjectUtil;
    
    import org.apache.royale.test.asserts.*;
    import flexUnitTests.mxroyale.support.*;
    //import testshim.RoyaleUnitTestRunner;
    
    
    COMPILE::SWF
    {
        import flash.utils.Dictionary;
        import flash.utils.describeType;
        import flash.utils.ByteArray;
    }
    COMPILE::JS
    {
        import org.apache.royale.reflection.describeType;
        import org.apache.royale.reflection.TypeDefinition;
        import org.apache.royale.reflection.AccessorDefinition;
        import org.apache.royale.reflection.VariableDefinition;
        import org.apache.royale.reflection.MetaDataDefinition;
        import org.apache.royale.reflection.MetaDataArgDefinition;
        import org.apache.royale.reflection.MemberDefinitionBase;
        import org.apache.royale.reflection.isDynamicObject;
        import org.apache.royale.reflection.getAliasByClass;
        import org.apache.royale.reflection.getDefinitionByName;
        import org.apache.royale.reflection.getDynamicFields;
        
        import org.apache.royale.reflection.utils.getMembers;
        import org.apache.royale.reflection.utils.MemberTypes;
        
        import org.apache.royale.net.remoting.amf.AMFBinaryData;
        
        import goog.DEBUG;
    }
    import mx.collections.IList;
    import org.apache.royale.reflection.getQualifiedClassName;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class ObjectUtilTest
    {
    
        
        public static var isJS:Boolean = COMPILE::JS;
    

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
    
        public function getPlayerVersion():Number{
            COMPILE::SWF{
                import flash.system.Capabilities;
                var parts:Array = Capabilities.version.split(' ')[1].split(',');
                return Number( parts[0]+'.'+parts[1])
            }
            //something for js, indicating javascript 'playerversion' is consistent with more recent flash player versions:
            return 30;
        }
        
        private function verifyClassInfoJSONMatch(val1:String,val2:String):Boolean{
            if (val1 == val2) return true;
            if (val1.length != val2.length) return false;
            var v1:Object = JSON.parse(val1);
            var v2:Object = JSON.parse(val2);
            
            //basic checks:
            if (v1['name'] != v2['name']) return false;
    
            if (v1['dynamic'] != v2['dynamic']) return false;
    
            if (v1['alias'] != v2['alias']) return false;
    
            if (v1['properties'].length != v2['properties'].length) return false;
            //srcutinise properties
            //assume all properties have been stringified via jsonHelper or are numeric
            var arr1:Array = v1['properties'];
            var arr2:Array = v2['properties'];
            for each(var prop:Object in arr1) {
                if (arr2.indexOf(prop) == -1) return false;
            }
            
            if (v1['metadata'] == v2['metadata']) return true;
    
            trace('check metadata');
            return true;
            
        }
        
        private function jsonHelper(key:String, value:Object):Object{
            if (value is QName) {
                var qName:QName = QName(value);
                // there is no toJSON on the javascript version of QName, (perhaps there should be) so for now,
                //simply stringify the QNames...
                return "QName("+qName.toString()+")";
            }
            
            return value;
        }
    
        [Test]
        public function testArray():void{
            var arr:Array = [];

            var classInfo:Object = ObjectUtil.getClassInfo(arr);
            
            var expected:String = '{"name":"Array","alias":"","properties":[],"dynamic":true,"metadata":null}';
            
            
            var check:String = JSON.stringify(classInfo, jsonHelper);

            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected Array ObjectUtil.getClassInfo:'+check);
            
            
            arr[0]=99;
            classInfo= ObjectUtil.getClassInfo(arr);
            expected = '{"name":"Array","alias":"","properties":[0],"dynamic":true,"metadata":null}';
    
            check = JSON.stringify(classInfo, jsonHelper);

            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected Array ObjectUtil.getClassInfo:'+check);
            arr[9]=99;
            classInfo= ObjectUtil.getClassInfo(arr);
            expected = '{"name":"Array","alias":"","properties":[0,9],"dynamic":true,"metadata":null}';
    
            check = JSON.stringify(classInfo, jsonHelper);
 
            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected Array ObjectUtil.getClassInfo:'+check);
            //test excludes
            classInfo= ObjectUtil.getClassInfo(arr, [9]);
            expected = '{"name":"Array","alias":"","properties":[0],"dynamic":true,"metadata":null}';
    
            check = JSON.stringify(classInfo, jsonHelper);
    
            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected Array ObjectUtil.getClassInfo:'+check);
        }
    
    
        [Test]
        public function testObject():void{
            var obj:Object = {};

            var classInfo:Object = ObjectUtil.getClassInfo(obj);
            var expected:String = '{"name":"Object","alias":"","properties":[],"dynamic":true,"metadata":null}';
    

            var check:String = JSON.stringify(classInfo, jsonHelper);

            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected Object ObjectUtil.getClassInfo:'+check);
    
            obj['test'] = 'tested!';
            classInfo= ObjectUtil.getClassInfo(obj);
            expected = '{"name":"Object","alias":"","properties":["QName(test)"],"dynamic":true,"metadata":null}';
    
            check = JSON.stringify(classInfo, jsonHelper);
            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected Object ObjectUtil.getClassInfo:'+check);
    
            obj[0] = 99;
            classInfo= ObjectUtil.getClassInfo(obj);
            expected = '{"name":"Object","alias":"","properties":["QName(0)","QName(test)"],"dynamic":true,"metadata":null}';
    
            check = JSON.stringify(classInfo, jsonHelper);
            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected Object ObjectUtil.getClassInfo:'+check);
            //test excludes
            classInfo= ObjectUtil.getClassInfo(obj,[0]);
            expected = '{"name":"Object","alias":"","properties":["QName(test)"],"dynamic":true,"metadata":null}';
    
            check = JSON.stringify(classInfo, jsonHelper);
            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected Object ObjectUtil.getClassInfo:'+check);
        }
        
        [Test]
        public function testInstWithOverride():void{
            var inst:TestClass2 = new TestClass2();
    
            var classInfo:Object = ObjectUtil.getClassInfo(inst);
    
            var expected:String = '{"alias":"","dynamic":false,"properties":["QName(something)"],"metadata":null,"name":"flexUnitTests.mxroyale.support::TestClass2"}';
            var check:String = JSON.stringify(classInfo, jsonHelper);
            

            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected testInstWithOverride ObjectUtil.getClassInfo:'+check);
            
            //test excludes
            classInfo= ObjectUtil.getClassInfo(inst,['something']);
            expected = '{"alias":"","dynamic":false,"properties":[],"metadata":null,"name":"flexUnitTests.mxroyale.support::TestClass2"}';
    
            check = JSON.stringify(classInfo, jsonHelper);
            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected testInstWithOverride ObjectUtil.getClassInfo:'+check);
            
        }
    
        [Test]
        public function testInstWithCustomNamespace():void{
            import flexUnitTests.mxroyale.support.testnamespace;
            var inst:TestClass6 = new TestClass6();
            //test default
            var classInfo:Object = ObjectUtil.getClassInfo(inst);
            var expected:String = '{"name":"flexUnitTests.mxroyale.support::TestClass6","alias":"","properties":["QName(myAccessor)","QName(myVar)"],"dynamic":false,"metadata":null}';
            var check:String = JSON.stringify(classInfo, jsonHelper);
            
            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected testInstWithCustomNamespace ObjectUtil.getClassInfo:'+check);
    
            //test uris wildcard with custom namespaces
            var options:Object = { includeReadOnly: true, uris: ["*"], includeTransient: true };
            expected = '{"name":"flexUnitTests.mxroyale.support::TestClass6","alias":"","properties":["QName(http://testnamespace.com/mxroyale::myAccessor)","QName(http://testnamespace.com/mxroyale::myVar)","QName(myAccessor)","QName(myVar)"],"dynamic":false,"metadata":null}';
            classInfo = ObjectUtil.getClassInfo(inst, null, options);
            check = JSON.stringify(classInfo, jsonHelper);
            
            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected testInstWithCustomNamespace ObjectUtil.getClassInfo:'+check);
            
            //test using a direct namespace reference in 'uris'
            options = { includeReadOnly: true, uris: [testnamespace], includeTransient: true };
            expected = '{"name":"flexUnitTests.mxroyale.support::TestClass6","alias":"","properties":["QName(http://testnamespace.com/mxroyale::myAccessor)","QName(http://testnamespace.com/mxroyale::myVar)"],"dynamic":false,"metadata":null}';
            classInfo = ObjectUtil.getClassInfo(inst, null, options);
            check = JSON.stringify(classInfo, jsonHelper);
            
            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected testInstWithCustomNamespace ObjectUtil.getClassInfo:'+check);
    
            //test 'excludes' with custom namespace
            options = { includeReadOnly: true, uris: [testnamespace], includeTransient: true };
            expected = '{"name":"flexUnitTests.mxroyale.support::TestClass6","alias":"","properties":["QName(http://testnamespace.com/mxroyale::myVar)"],"dynamic":false,"metadata":null}';
            classInfo = ObjectUtil.getClassInfo(inst, ["myAccessor"], options);
            check = JSON.stringify(classInfo, jsonHelper);
            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected testInstWithCustomNamespace ObjectUtil.getClassInfo:'+check);

        }
        
        
        [Test]
        public function testDict():void{
            var inst:Object;
            var ref:TestClass2 = new TestClass2();
            COMPILE::SWF{
                inst = new Dictionary();
                inst[ref] = true;
                inst['string'] = 'StringPrim';
                inst[1] = 'NumericPrim';
            }
            COMPILE::JS{
                inst = new Map();
                inst.set(ref, true);
                inst.set('string', 'StringPrim');
                inst.set(1, 'NumericPrim');
            }
            var classInfo:Object = ObjectUtil.getClassInfo(inst);

            var pass:Boolean = true;
            var properties:Array = classInfo.properties;
            var idx:int = properties.indexOf(ref);
            if (idx == -1) pass=false;
            else properties.splice(idx,1);
            if (pass) {
                idx = properties.indexOf(1);
                if (idx == -1) pass=false;
                else properties.splice(idx,1);
            }
            if (pass) {
                if (properties.length != 1) pass = false;
                else {
                    //in this case it is not a QName, it is simply a string
                    pass = properties[0] == 'string';
                }
            }
            
            assertTrue(pass, 'unexpected Dict ObjectUtil.getClassInfo result');
    
        }
    
    
        [Test]
        public function testXML():void{
            var inst:XML = new XML();
           
            var classInfo:Object = ObjectUtil.getClassInfo(inst);
            var expected:String = '{"name":"XML","alias":null,"dynamic":false,"metadata":null,"properties":[]}';
    
            var check:String = JSON.stringify(classInfo, jsonHelper);

            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected XML ObjectUtil.getClassInfo result');
            
            inst = <root/>;
            classInfo = ObjectUtil.getClassInfo(inst);
            check = JSON.stringify(classInfo, jsonHelper);
            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected XML ObjectUtil.getClassInfo result');
    
            inst = <root test1="test" test2="test" xmlns:other="other" other:testother="testother"/>;
            expected = '{"name":"XML","alias":null,"dynamic":false,"metadata":null,"properties":["QName(@other::testother)","QName(@test1)","QName(@test2)"]}';
            classInfo = ObjectUtil.getClassInfo(inst);
            check = JSON.stringify(classInfo, jsonHelper);

            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected XML ObjectUtil.getClassInfo result');
    
            //XMLList - quick check
            inst = <root><child att1="child1"/><child att1="child2" att2="child2"/></root>;
            expected = '{"name":"XML","alias":null,"dynamic":false,"metadata":null,"properties":["QName(@att1)","QName(@att2)"]}';
    
            var list:XMLList = inst.child;
            classInfo = ObjectUtil.getClassInfo(list);
            check = JSON.stringify(classInfo, jsonHelper);
            assertTrue(verifyClassInfoJSONMatch(check, expected), 'unexpected XML ObjectUtil.getClassInfo result');
            
        }
        
        [Test]
        public function testToString():void{
            var item:TestClass6 = new TestClass6();
            
            //RoyaleUnitTestRunner.consoleOut(ObjectUtil.toString(item));
            
            assertEquals(ObjectUtil.toString(item),
                    ('(flexUnitTests.mxroyale.support::TestClass6)#0\n' +
                    '  myAccessor = "public accessor"\n' +
                    '  myVar = "publicMyVar"'),
                    'Unexpected ObjectUtil.toString result');
        }
    
    
        /*[Test]
        public function testCloning():void{
            var item:TestClass6 = new TestClass6();
        
            
        }*/
        
    }
}
