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
            XML.setSettings(XML.defaultSettings());
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

        /**
         *
         * dev use for creating expected tracking sequences ([SWF] output as a reference)
         */
        private static function consoleOut(message:String, type:String = 'log', ...args):void
        {
            args.unshift(message + '\n');
            COMPILE::JS {
                args.unshift('[JS]');
                console[type].apply(console, args);
            }
            COMPILE::SWF{
                import flash.external.ExternalInterface;

                if (ExternalInterface.available)
                {
                    try
                    {
                        args.unshift('[SWF]');
                        const method:String = 'console.' + type + '.apply';
                        ExternalInterface.call(method, null, args);
                    } catch (e:Error)
                    {
                    }
                }
            }
        }

        /**
         *
         * dev use for creating expected tracking sequences ([SWF] output as a reference)
         */
        private function expectify(array:Array, message:String = null):String{
            array = array.slice();
            var l:uint = array.length;
            for (var i:uint = 0; i<l;i++) {
                var s:String =array[i];
                s= "'" + s.split('\\n').join('\\\\n') + "'";
                array[i] = s;
            }
            var out:String = '[\n'+array.join(',\n')+'\n]';
            if (message) {
                consoleOut(message);
            }
            consoleOut(out)
            return out;
        }


        private function isExpected(expected:Array):Boolean{
            if (!tracking) return false;
            if (expected.length != tracking.length) {
                consoleOut('mismatch in length ');
                consoleOut('expected len:'+expected.length);
                consoleOut('got      len:'+tracking.length);
                return false;
            }
            for (var i:uint=0;i<expected.length;i++){
                if (expected[i] != tracking[i]) {
                    consoleOut('mismatch at '+i);
                    consoleOut('expected:'+expected[i]);
                    consoleOut('got     :'+tracking[i]);
                    return false;
                }
            }
            return true;
        }


        private var tracking:Array;
        private function trackChanges(currentTarget:Object, command:String, target:Object, value:Object, detail:Object):void{
            var trackingRecord:String=
                    "[ command="+command+", currentTarget="+currentTarget+", target="+target+", value="+stringifyValue(value)+", detail="+stringifyValue(detail);
            trackingRecord = trackingRecord.split('\n').join('\\n');
            const targetType:String = target!=null ? getQualifiedClassName(target) : '{'+target+'}';
            const targetIsCurrentTarget:String = (target === currentTarget) + '';
            const valueType:String = value!=null ? getQualifiedClassName(value): '{'+value+'}';
            trackingRecord += ', targetType='+targetType+', targetIsCurrent:'+targetIsCurrentTarget+', valueType='+valueType + ']';
            tracking.push(trackingRecord)
        }

        private function stringifyValue(value:Object):String{
            var ret:String;
            if (value is XML) {
                var xml:XML = XML(value);
                var nodeKind:String = xml.nodeKind();
                switch(nodeKind) {
                    case 'element' :
                        var val:String = xml.toXMLString();
                        ret = '['+nodeKind+': '+val+']';
                        break
                    case 'attribute':
                        ret =  '['+nodeKind+':'+xml.name()+'="'+xml.text()+'"]';
                        break;
                    case 'text':
                        ret =  '['+nodeKind+':"'+xml.text().toString()+'"]';
                        break;
                    default:
                        ret = '['+nodeKind+':{not stringified}]';
                        break;
                }
            } else {
                ret = value +'';
            }
            return ret;
        }


        private function setNotifier(value:XML, reset:Boolean=true):void{
            if (reset) {
                tracking=[];
            }
            value.setNotification(trackChanges);
        }

        private function setChildrenNotifiers(value:Object):void{
            var children:XMLList = value is XML ? XML(value).children() : value as XMLList;
            for each(var child:XML in children) {
                setNotifier(child, false);
            }
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
                '[ command=nodeAdded, currentTarget=test, target=test, value=[text:""], detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]'
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
                '[ command=nodeAdded, currentTarget=<xml>\\n  <test/>\\n</xml>, target=<xml>\\n  <test/>\\n</xml>, value=[element: <test/>], detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]'
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
                '[ command=nodeRemoved, currentTarget=, target=, value=[element: <child/>], detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]'
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
                '[ command=nodeChanged, currentTarget=<xml>\\n  <childX/>\\n  <child2/>\\n</xml>, target=<xml>\\n  <childX/>\\n  <child2/>\\n</xml>, value=[element: <childX/>], detail=[element: <child1/>], targetType=XML, targetIsCurrent:true, valueType=XML]'
            ]

            assertTrue(isExpected(expected), 'unexpected XML notifications');


            xml = <xml><childA/><childB/><childA/><childB/><childA/><childB/></xml>;
            childX = <childX/>;

            setNotifier(xml);

            xml.replace('childB',childX);

            expected = [
                '[ command=nodeRemoved, currentTarget=<xml>\\n  <childA/>\\n  <childB/>\\n  <childA/>\\n  <childB/>\\n  <childA/>\\n</xml>, target=<xml>\\n  <childA/>\\n  <childB/>\\n  <childA/>\\n  <childB/>\\n  <childA/>\\n</xml>, value=[element: <childB/>], detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]',
                '[ command=nodeRemoved, currentTarget=<xml>\\n  <childA/>\\n  <childB/>\\n  <childA/>\\n  <childA/>\\n</xml>, target=<xml>\\n  <childA/>\\n  <childB/>\\n  <childA/>\\n  <childA/>\\n</xml>, value=[element: <childB/>], detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]',
                '[ command=nodeChanged, currentTarget=<xml>\\n  <childA/>\\n  <childX/>\\n  <childA/>\\n  <childA/>\\n</xml>, target=<xml>\\n  <childA/>\\n  <childX/>\\n  <childA/>\\n  <childA/>\\n</xml>, value=[element: <childX/>], detail=[element: <childB/>], targetType=XML, targetIsCurrent:true, valueType=XML]'
            ]
           // expectify(tracking, 'testReplaceNode')
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
                '[ command=textSet, currentTarget=testAtt, target=testAtt, value=testAtt, detail=null, targetType=XML, targetIsCurrent:false, valueType=String]',
                '[ command=nodeAdded, currentTarget=testAtt, target=testAtt, value=[text:""], detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]'
            ]


            assertTrue(isExpected(expected), 'unexpected XML notifications');
            //reset the tracking:
            setNotifier(xml);
            xml.@something = att;

            expected = [
                '[ command=attributeAdded, currentTarget=testAtt, target=testAtt, value=something, detail=testAtt, targetType=XML, targetIsCurrent:true, valueType=String]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');


            setNotifier(xml);
            xml.appendChild(att);

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


        [Test]
        public function testSetChildren():void
        {
            var xml:XML = <xml><one/><two/><three/></xml>;

            setNotifier(xml);
            var alternateChildren:XMLList = XMLList("<childOne/><childTwo/><childThree/>");

            xml.setChildren(alternateChildren);


            var expected:Array = [
                '[ command=nodeRemoved, currentTarget=<xml>\\n  <one/>\\n  <two/>\\n</xml>, target=<xml>\\n  <one/>\\n  <two/>\\n</xml>, value=[element: <three/>], detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]',
                '[ command=nodeRemoved, currentTarget=<xml>\\n  <one/>\\n</xml>, target=<xml>\\n  <one/>\\n</xml>, value=[element: <two/>], detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]',
                '[ command=nodeChanged, currentTarget=<xml>\\n  <childOne/>\\n  <childTwo/>\\n  <childThree/>\\n</xml>, target=<xml>\\n  <childOne/>\\n  <childTwo/>\\n  <childThree/>\\n</xml>, value=[element: <childOne/>], detail=[element: <one/>], targetType=XML, targetIsCurrent:true, valueType=XML]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');

            setNotifier(xml);
            alternateChildren = new XMLList();
            xml.setChildren(alternateChildren);

            expected = [
                '[ command=nodeRemoved, currentTarget=<xml>\\n  <childOne/>\\n  <childTwo/>\\n</xml>, target=<xml>\\n  <childOne/>\\n  <childTwo/>\\n</xml>, value=[element: <childThree/>], detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]',
                '[ command=nodeRemoved, currentTarget=<xml>\\n  <childOne/>\\n</xml>, target=<xml>\\n  <childOne/>\\n</xml>, value=[element: <childTwo/>], detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');
            xml = <xml/>;
            setNotifier(xml);
            alternateChildren = XMLList("<childOne/><childTwo/><childThree/>");
            xml.setChildren(alternateChildren);
            expected = [
                '[ command=nodeAdded, currentTarget=<xml>\\n  <childOne/>\\n  <childTwo/>\\n  <childThree/>\\n</xml>, target=<xml>\\n  <childOne/>\\n  <childTwo/>\\n  <childThree/>\\n</xml>, value=[element: <childOne/>], detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');
            xml = <xml><one>some text</one></xml>;
            setNotifier(xml);
            alternateChildren = XMLList("<childOne/><childTwo/><childThree/>");
            xml.setChildren(alternateChildren);
            expected = [
                '[ command=nodeChanged, currentTarget=<xml>\\n  <childOne/>\\n  <childTwo/>\\n  <childThree/>\\n</xml>, target=<xml>\\n  <childOne/>\\n  <childTwo/>\\n  <childThree/>\\n</xml>, value=[element: <childOne/>], detail=[element: <one>some text</one>], targetType=XML, targetIsCurrent:true, valueType=XML]'
            ]
            assertTrue(isExpected(expected), 'unexpected XML notifications');

            //check what the children do (if anything)
            xml = <xml><one/><two/><three/></xml>;
            setNotifier(xml);
            alternateChildren = XMLList("<childOne/><childTwo/><childThree/>");
            xml.setChildren(alternateChildren);
            xml.setChildren(alternateChildren);
            expected = [
                '[ command=nodeRemoved, currentTarget=<xml>\\n  <one/>\\n  <two/>\\n</xml>, target=<xml>\\n  <one/>\\n  <two/>\\n</xml>, value=[element: <three/>], detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]',
                '[ command=nodeRemoved, currentTarget=<xml>\\n  <one/>\\n</xml>, target=<xml>\\n  <one/>\\n</xml>, value=[element: <two/>], detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]',
                '[ command=nodeChanged, currentTarget=<xml>\\n  <childOne/>\\n  <childTwo/>\\n  <childThree/>\\n</xml>, target=<xml>\\n  <childOne/>\\n  <childTwo/>\\n  <childThree/>\\n</xml>, value=[element: <childOne/>], detail=[element: <one/>], targetType=XML, targetIsCurrent:true, valueType=XML]',
                '[ command=nodeRemoved, currentTarget=<xml>\\n  <childOne/>\\n  <childTwo/>\\n</xml>, target=<xml>\\n  <childOne/>\\n  <childTwo/>\\n</xml>, value=[element: <childThree/>], detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]',
                '[ command=nodeRemoved, currentTarget=<xml>\\n  <childOne/>\\n</xml>, target=<xml>\\n  <childOne/>\\n</xml>, value=[element: <childTwo/>], detail=null, targetType=XML, targetIsCurrent:true, valueType=XML]',
                '[ command=nodeChanged, currentTarget=<xml>\\n  <childOne/>\\n  <childTwo/>\\n  <childThree/>\\n</xml>, target=<xml>\\n  <childOne/>\\n  <childTwo/>\\n  <childThree/>\\n</xml>, value=[element: <childOne/>], detail=[element: <childOne/>], targetType=XML, targetIsCurrent:true, valueType=XML]'
            ]

            assertTrue(isExpected(expected), 'unexpected XML notifications');


        }


    }
}
