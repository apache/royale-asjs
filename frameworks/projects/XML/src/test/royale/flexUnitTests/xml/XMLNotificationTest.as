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
package flexUnitTests.xml
{
    
    
    import org.apache.royale.test.asserts.*;
    import org.apache.royale.reflection.getQualifiedClassName


    /**
     * @royalesuppresspublicvarwarning
     */
    public class XMLNotificationTest
    {
    
        public static var isJS:Boolean = COMPILE::JS;
    
        private var settings:Object;
        
        [Before]
        public function setUp():void
        {
            settings = XML.settings();
        }
        
        [After]
        public function tearDown():void
        {
            XML.setSettings(settings);
        }
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
        }


        private function isExpected(expected:Array):Boolean{
            if (!tracking) return false;
            if (expected.length != tracking.length) {
                return false;
            }
            for (var i:uint=0;i<expected.length;i++){
                if (expected[i] != tracking[i]) {
                    return false;
                }
            }
            return true;
        }

        private var tracking:Array;

        public function trackChanges(currentTarget:Object, command:String, target:Object, value:Object, detail:Object, callee:Function = null):void{
            var trackingRecord:String=
            "[ command="+command+", currentTarget="+currentTarget+", target="+target+", value="+value+", detail="+detail;
            trackingRecord = trackingRecord.split('\n').join('\\n');
            const targetType:String = target!=null ? getQualifiedClassName(target) : '{'+target+'}';
            const targetIsCurrentTarget:String = (target === currentTarget) + '';
            const valueType:String = value!=null ? getQualifiedClassName(value): '{'+value+'}';
            trackingRecord += ', targetType='+targetType+', targetIsCurrent:'+targetIsCurrentTarget+', valueType='+valueType + ']';
            tracking.push(trackingRecord)
        }

        private function setNotifier(value:XML):void{
            tracking=[];
            value.setNotification(trackChanges);
        }


        [Test]
        public function testLanguageFidelity():void
        {
            var xml:XML = <xml/>;
            setNotifier(xml);
            //we are just going to test that normal XML language support remains valid after any implementation variations are applied:

            assertTrue( xml instanceof XML, 'unexpected type check');

            assertTrue( xml is XML, 'unexpected type check');

            assertTrue( getQualifiedClassName(xml) == 'XML', 'unexpected type check');

        }
        
        
        [Test]
        public function testText():void
        {
            var xml:XML = <xml/>;
            setNotifier(xml);
            xml.appendChild('test');

            var expected:Array = [
                '[ command=textSet, currentTarget=test, target=test, value=test, detail=null, targetType=XML, targetIsCurrent:false, valueType=String]',
                '[ command=nodeAdded, currentTarget=test, target=test, value=test, detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');
            
        }

        [Test]
        public function testAppendNode():void
        {
            var xml:XML = <xml/>;
            setNotifier(xml);
            xml.appendChild(<test/>);
            var expected:Array = [
                '[ command=nodeAdded, currentTarget=<xml>\\n  <test/>\\n</xml>, target=<xml>\\n  <test/>\\n</xml>, value=, detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');

        }


        [Test]
        public function testRemoveNode():void
        {
            var xml:XML = <xml/>;
            var child:XML = <child/>;
            xml.appendChild(child);
            setNotifier(xml);

            var children:XMLList = xml.child;
            delete children[0];

            var expected:Array = [
                '[ command=nodeRemoved, currentTarget=, target=, value=, detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');

        }


        [Test]
        public function testReplaceNode():void
        {
            var xml:XML = <xml><child1/><child2/></xml>;
            var childX:XML = <childX/>;

            setNotifier(xml);

            xml.replace('child1',childX);


            var expected:Array = [
                '[ command=nodeChanged, currentTarget=<xml>\\n  <childX/>\\n  <child2/>\\n</xml>, target=<xml>\\n  <childX/>\\n  <child2/>\\n</xml>, value=, detail=, targetType=XML, targetIsCurrent:true, valueType=XML]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');
        }


        [Test]
        public function testSetNamespace():void
        {
            var xml:XML = <xml/>;
            setNotifier(xml);
            var namespace:Namespace = new Namespace('test', 'testuri')
            xml.setNamespace(namespace)

            var expected:Array = [
                '[ command=namespaceSet, currentTarget=, target=, value=testuri, detail=null, targetType=XML, targetIsCurrent:true, valueType=Namespace]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');

        }


        [Test]
        public function testSetAttribute():void
        {
            var xml:XML = <xml/>;
            setNotifier(xml);

            xml.@att = "testAtt";

            var expected:Array = [
                '[ command=attributeAdded, currentTarget=, target=, value=att, detail=testAtt, targetType=XML, targetIsCurrent:true, valueType=String]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');
            var att:XML = xml.@att[0];
            xml = <xml/>;
            setNotifier(xml);
            xml.appendChild(att);

            expected = [
                '[ command=textSet, currentTarget=testAtt, target=testAtt, value=testAtt, detail=null, targetType=XML, targetIsCurrent:false, valueType=String]' ,
                '[ command=nodeAdded, currentTarget=testAtt, target=testAtt, value=testAtt, detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');
            //reset the tracking:
            setNotifier(xml);
            xml.@something = att;


            expected = [
                '[ command=attributeAdded, currentTarget=testAtt, target=testAtt, value=something, detail=testAtt, targetType=XML, targetIsCurrent:true, valueType=String]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');

        }


        [Test]
        public function testRemoveAttribute():void
        {
            var xml:XML = new XML('<xml test="testAtt"/>')
            setNotifier(xml);

            delete xml.@test;

            var expected:Array = [
                '[ command=attributeRemoved, currentTarget=, target=, value=test, detail=testAtt, targetType=XML, targetIsCurrent:true, valueType=String]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');


            xml = new XML('<xml xmlns:other="something" other:test="testAtt"/>')
            setNotifier(xml);

            var attributes:XMLList = xml.attributes();
            delete attributes[0];
            //expect the same (ignore namespace)
            assertTrue(isExpected(expected), 'unexpected XML notifications');

        }

        [Test]
        public function testChangeAttribute():void
        {
            var xml:XML = new XML('<xml test="testAtt"/>')
            setNotifier(xml);


            xml.@test = 'testAtt2';


            var expected:Array = [
                '[ command=attributeChanged, currentTarget=, target=, value=test, detail=testAtt, targetType=XML, targetIsCurrent:true, valueType=String]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');


        }



        [Test]
        public function testSetName():void
        {
            var xml:XML = <xml/>;

            setNotifier(xml);
            xml.setName(new QName('test'));

            var expected:Array = [
                '[ command=nameSet, currentTarget=, target=, value=test, detail=xml, targetType=XML, targetIsCurrent:true, valueType=QName]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');

            setNotifier(xml);
            xml.setName('test2');
            expected = [
                '[ command=nameSet, currentTarget=, target=, value=test2, detail=test, targetType=XML, targetIsCurrent:true, valueType=String]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');
        }



        
    }
}
