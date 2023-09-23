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
    
    import org.apache.royale.test.Runtime;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class XMLListTesterGeneralTest
    {
        public static var isJS:Boolean = COMPILE::JS;
        
        
        private var settings:Object;
        
        public static function getSwfVersion():uint{
            COMPILE::SWF{
                return Runtime.swfVersion;
            }
            COMPILE::JS {
                //this mimics the version of the flash player that has xml toString support 'fixed'
                return 21
            }
        }
        
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
        
        
        [Test]
        public function testXMLListBoolean():void
        {
            
            var xmllist:XMLList = XMLList(true);
            assertTrue( xmllist.length() == 1, 'XMLList length was unexpected');
            assertTrue( xmllist[0].nodeKind() == 'text', 'XMLList content was unexpected');
            assertTrue( xmllist.toString() == 'true', 'XMLList content was unexpected');
    
            xmllist = XMLList(false);
            assertTrue( xmllist.length() == 1, 'XMLList length was unexpected');
            assertTrue( xmllist[0].nodeKind() == 'text', 'XMLList content was unexpected');
            assertTrue( xmllist.toString() == 'false', 'XMLList content was unexpected');
        }
    
    
        [Test]
        public function testXMLListNull():void
        {
            var xmllist:XMLList;
            var caughtError:Boolean = false;
            try{
                xmllist = XMLList(null);
            } catch(e:Error) {
                caughtError = true;
            }
            //as3 docs say this is an error, but it is not (in AVM)
            assertFalse( caughtError, 'XMLList error status was unexpected');
            assertTrue( xmllist.length() == 0, 'XMLList length was unexpected');

        }
    
        [Test]
        public function testXMLListNumber():void
        {
            var xmllist:XMLList = XMLList(99.9);
            assertTrue( xmllist.length() == 1, 'XMLList length was unexpected');
            assertTrue( xmllist[0].nodeKind() == 'text', 'XMLList content was unexpected');
            assertTrue( xmllist.toString() == '99.9', 'XMLList content was unexpected');
            
        }
    
        [Test]
        public function testXMLListString():void
        {
            var xmllist:XMLList = XMLList('test');
            assertTrue( xmllist.length() == 1, 'XMLList length was unexpected');
            assertTrue( xmllist[0].nodeKind() == 'text', 'XMLList content was unexpected');
            assertTrue( xmllist.toString() == 'test', 'XMLList content was unexpected');
            
            xmllist = XMLList('');
            assertTrue( xmllist.length() == 0, 'XMLList length was unexpected');
        }
    
        [Test]
        public function testXMLListUndefined():void
        {
            var xmllist:XMLList;
            var caughtError:Boolean = false;
            try{
                xmllist = XMLList(undefined);
            } catch(e:Error) {
                caughtError = true;
            }
    
            //as3 docs say this is an error, but it is not (in AVM)
            assertFalse( caughtError, 'XMLList error status was unexpected');
            assertTrue( xmllist.length() == 0, 'XMLList length was unexpected');
        
        }
    
    
        [Test]
        public function testXMLListObject():void
        {
            var xmllist:XMLList  = XMLList({});
    
            //as3 docs say this is an error, but it is not (in AVM)
            assertTrue( xmllist.length() == 1, 'XMLList length was unexpected');
            assertTrue( xmllist[0].nodeKind() == 'text', 'XMLList content was unexpected');
            assertTrue( xmllist.toString() == '[object Object]', 'XMLList content was unexpected');
        
        }
    
        [Test]
        public function testXMLListFromStringContent():void
        {
            var contentString:String = '<size description="Medium" xmlns:fx="http://ns.adobe.com/mxml/2009" >\n' +
                    '  <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '  <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '</size>\n' +
                    '<size description="Large" xmlns:fx="http://ns.adobe.com/mxml/2009" >\n' +
                    '  <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '  <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '</size>\n' +
                    '<size description="Small" xmlns:fx="http://ns.adobe.com/mxml/2009" >\n' +
                    '  <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '  <color_swatch image="navy_cardigan.jpg">Navy</color_swatch>\n' +
                    '  <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '</size>\n' +
                    '<size description="Medium" xmlns:fx="http://ns.adobe.com/mxml/2009" >\n' +
                    '  <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '  <color_swatch image="navy_cardigan.jpg">Navy</color_swatch>\n' +
                    '  <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '  <color_swatch image="black_cardigan.jpg">Black</color_swatch>\n' +
                    '</size>\n' +
                    '<size description="Large" xmlns:fx="http://ns.adobe.com/mxml/2009" >\n' +
                    '  <color_swatch image="navy_cardigan.jpg">Navy</color_swatch>\n' +
                    '  <color_swatch image="black_cardigan.jpg">Black</color_swatch>\n' +
                    '</size>\n' +
                    '<size description="Extra Large" xmlns:fx="http://ns.adobe.com/mxml/2009" >\n' +
                    '  <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '  <color_swatch image="black_cardigan.jpg">Black</color_swatch>\n' +
                    '</size>';
            
            var xmllist:XMLList  = XMLList(contentString);
        

            assertTrue( xmllist.length() == 6, 'XMLList length was unexpected');
            //use length here to account for variation in attribute/namespace sequence outputs
            assertTrue( xmllist.toXMLString().length == 1431, 'XMLList length was unexpected');
        }

        [Test]
        public function testWithDecl():void{

            var list:XMLList = new XMLList('<?xml version="1.0" encoding="utf-8"?><success>false</success><retryable>false</retryable><localStatus>SESSION_NO_SUCH_CUSTOMER</localStatus>');
            assertEquals(list.length(), 3, 'unexpected parsing result for list content');

        }

        [Test]
        public function testAssignmentRange():void{

            var list:XMLList = new XMLList('<?xml version="1.0" encoding="utf-8"?><success>false</success><retryable>false</retryable><localStatus>SESSION_NO_SUCH_CUSTOMER</localStatus>');
            assertEquals(list.length(), 3, 'unexpected parsing result for list content');
            //out of range index assignment
            list[10] = <message>You cannot login, please check with tech support</message>;

            assertEquals(list.length(), 4, 'unexpected length result for list content');
            assertEquals(list[3].toXMLString(),'<message>You cannot login, please check with tech support</message>', 'unexpected list content' );
            var hadError:Boolean;
            try{
                list.@attr = 'testAtt'
            } catch (e:Error) {
                hadError = true;
            }
            assertTrue(hadError, 'expected an error');
        }



        [Test]
        public function testCoercion():void{
            var source:XML = <data>
                <row>
                    <Item someattribute="item1Att">item1</Item>
                </row>
                <row>
                    <Item someattribute="item2Att">item2</Item>
                </row>
            </data>;

            var list:XMLList = XMLList(source);
            assertEquals(list.length(), 1, 'unexpected XMLList length');
            assertEquals(source.row.length(), 2, 'unexpected XMLList length');

            assertEquals(list.row.length(), 2, 'unexpected XMLList length');
            var alt:XMLList = XMLList(list)
            assertEquals(alt.length(), 1, 'unexpected XMLList length');
            assertEquals(alt.row.length(), 2, 'unexpected XMLList length');
            assertEquals(alt, list, 'unexpected XMLList equality');
            assertStrictlyEquals(alt, list, 'unexpected XMLList strict equality');
            assertStrictlyEquals(alt[0], source, 'unexpected XMLList content strict equality');

        }


        [Test]
        public function testAddition():void{

            var list:XMLList = new XMLList('<?xml version="1.0" encoding="utf-8"?><success>false</success><retryable>false</retryable><localStatus>SESSION_NO_SUCH_CUSTOMER</localStatus>');
            assertEquals(list.length(), 3, 'unexpected parsing result for list content');
            var something:XML = <something>something</something>;
            var prepend:Object = something;
            var origList:XMLList;
            var newList:XMLList;

            newList = XMLList(prepend) + list;




            assertEquals(newList.toString(),
                    '<something>something</something>\n' +
                    '<success>false</success>\n' +
                    '<retryable>false</retryable>\n' +
                    '<localStatus>SESSION_NO_SUCH_CUSTOMER</localStatus>', 'unexpected list concatenation result');

            var orig:XML = something;
            var newList2:XMLList ;
            newList2 = something + list;


            assertStrictlyEquals(orig, something,'should be the same instance');

            assertEquals(newList2.toString(),
                    '<something>something</something>\n' +
                    '<success>false</success>\n' +
                    '<retryable>false</retryable>\n' +
                    '<localStatus>SESSION_NO_SUCH_CUSTOMER</localStatus>', 'unexpected list concatenation result');

            origList = list;

            list += newList;

            //in XMLList case, +=, to be explicit, does not append to the original instance, it creates a new instance
            assertNotEquals(origList, list,'should be a new instance');

            assertEquals(list.toString(),
                    '<success>false</success>\n' +
                    '<retryable>false</retryable>\n' +
                    '<localStatus>SESSION_NO_SUCH_CUSTOMER</localStatus>\n' +
                    '<something>something</something>\n' +
                    '<success>false</success>\n' +
                    '<retryable>false</retryable>\n' +
                    '<localStatus>SESSION_NO_SUCH_CUSTOMER</localStatus>', 'unexpected list concatenation result');


            var source:XML = <xml><child name="1"><item id="item1" category="unknown"/></child><child name="2"><item id="item2" category="unknown"/></child><child name="3"><item id="item3" category="unknown"/></child><child name="4"><item id="item4" category="unknown"/></child></xml>;


            var itemIds:XMLList = source.child.item.@id;

            var childList:XMLList = source.child;


            var combined:XMLList = childList+itemIds;

            //IE11 can have attribute order inverted
            var firstPartA:String ='<child name="1">\n' +
                    '  <item id="item1" category="unknown"/>\n' +
                    '</child>\n' +
                    '<child name="2">\n' +
                    '  <item id="item2" category="unknown"/>\n' +
                    '</child>\n' +
                    '<child name="3">\n' +
                    '  <item id="item3" category="unknown"/>\n' +
                    '</child>\n' +
                    '<child name="4">\n' +
                    '  <item id="item4" category="unknown"/>\n' +
                    '</child>\n'
            var firstPartB:String ='<child name="1">\n' +
                    '  <item category="unknown" id="item1"/>\n' +
                    '</child>\n' +
                    '<child name="2">\n' +
                    '  <item category="unknown" id="item2"/>\n' +
                    '</child>\n' +
                    '<child name="3">\n' +
                    '  <item category="unknown" id="item3"/>\n' +
                    '</child>\n' +
                    '<child name="4">\n' +
                    '  <item category="unknown" id="item4"/>\n' +
                    '</child>\n';

            var lastPart:String = 'item1\n' +
                    'item2\n' +
                    'item3\n' +
                    'item4';

            var combinedString:String = combined.toString();
            var mustBeExpected:Boolean = combinedString == (firstPartA + lastPart) || combinedString == (firstPartB + lastPart);

            assertTrue(mustBeExpected, 'unexpected list concatenation result');

            var test:Object = <xml>test</xml>;
            var xmlInst:XML = <xml><child selected="false"/><child selected="true"/></xml>;

            var check:XMLList = XMLList(test) + xmlInst.descendants().(@selected == 'true');
            assertEquals(check.toString(), '<xml>test</xml>\n' +
                    '<child selected="true"/>', 'unexpected XMLList addition result');

            check = XMLList(test) + xmlInst.descendants().@selected;
            assertEquals(check.toString(), '<xml>test</xml>\n' +
                    'false\n' +'true', 'unexpected XMLList addition result');

            check = XMLList(test) + xmlInst.child;
            assertEquals(check.toString(), '<xml>test</xml>\n' +
                    '<child selected="false"/>\n' +'<child selected="true"/>', 'unexpected XMLList addition result');


            check = XMLList(test) + xmlInst.child[0];
            assertEquals(check.toString(), '<xml>test</xml>\n' +
                    '<child selected="false"/>' , 'unexpected XMLList addition result');

            check = XMLList(test) + xmlInst.child.@['selected'];
            assertEquals(check.toString(), '<xml>test</xml>\n' +
                    'false\n' +'true' , 'unexpected XMLList addition result');

            check = XMLList(test) + xmlInst['child'];
            assertEquals(check.toString(), '<xml>test</xml>\n' +
                    '<child selected="false"/>\n' +'<child selected="true"/>', 'unexpected XMLList addition result');

            check = getList() + xmlInst['child'];
            assertEquals(check.toString(), '<xml>test</xml>\n' +
                    '<child selected="false"/>\n' +'<child selected="true"/>', 'unexpected XMLList addition result');


            check = getList() + xmlInst['child'] + getList();
            assertEquals(check.toString(), '<xml>test</xml>\n' +
                    '<child selected="false"/>\n' +'<child selected="true"/>\n' + '<xml>test</xml>', 'unexpected XMLList addition result');

            check = (getList() + xmlInst['child']) + getList();
            assertEquals(check.toString(), '<xml>test</xml>\n' +
                    '<child selected="false"/>\n' +'<child selected="true"/>\n' + '<xml>test</xml>', 'unexpected XMLList addition result');

            check = getList() + (xmlInst['child'] + getList());
            assertEquals(check.toString(), '<xml>test</xml>\n' +
                    '<child selected="false"/>\n' +'<child selected="true"/>\n' + '<xml>test</xml>', 'unexpected XMLList addition result');

        }

        private function getList():XMLList{
            var test:Object = <xml>test</xml>;
            return  XMLList(test);
        }

        [Test]
        public function testEquality():void{
            var node:XML = <type type="without name attribute"/>;

            var list:XMLList = node.@name;
            var Null:* = null;
            var Undefined:* = undefined;
//the above is just so the very last trace comparison below does not give warnings or errors in compiler, the earlier checks can also be done with the literal null/undefined

            assertFalse(node.@name == "", 'unexpected equality with empty string for empty list');
            assertFalse((node.@name == Null))//false
            assertTrue((node.@name == Undefined))//true in flash (false in Royale)

            //The following passes in flash, but fails in JS:
            // assertFalse((list.valueOf() == Null))//false in flash (true in Royale)
            assertFalse((list.valueOf() == ""))//false in flash (true in Royale)
            assertTrue((list.valueOf() == Undefined))//true in flash (false in Royale)
//conclusion: XMLList.valueOf should return undefined for empty list
//but in JS, list.valueOf() == Null, because:
            assertTrue((Null == Undefined))//true
        }

        [Test]
        public function testListCoercion():void{
            var node:XML = <type type="without name attribute"><val>2</val></type>;

            var emptyList:XMLList = node.@name;
            var typeList:XMLList = node.@type;
            var someValList:XMLList;
            var nullList:XMLList = null;

            var str:String = emptyList;
            assertTrue(str == '');

            str = nullList;
            assertTrue(str === null);

            str = 'test'+emptyList;
            assertTrue(str == 'test');

            str = 'list '+typeList+emptyList;
            assertTrue(str == 'list without name attribute');

            str = typeList+emptyList + ' is how I would describe that node';
            assertTrue(str == 'without name attribute is how I would describe that node');

            var n:Number = Number(emptyList);
            assertTrue(n == 0);

            n = Number(nullList);
            assertTrue(n == 0);

            n = 1+emptyList;
            assertTrue(n == 1);

            var b:Boolean = Boolean(emptyList);
            assertTrue(b === true);

            b = emptyList || false;
            assertTrue(b === true);

            //non-empty coercion example
            someValList = node.val;
            n = 1+someValList; // this should be string concatenation ultimately coerced to Number
            assertTrue(n === 12);

            n = 1+nullList; // this should be string concatenation ultimately coerced to Number
            assertTrue(n === 1);

            //check again with inline lists
            str = node.@name;
            assertTrue(str == '');

            str = 'test'+node.@name;
            assertTrue(str == 'test');

            str = 'list '+node.@type+node.@name;
            assertTrue(str == 'list without name attribute');

            str = node.@type + node.@name + ' is how I would describe that node';
            assertTrue(str == 'without name attribute is how I would describe that node');

            n = Number(node.@name);
            assertTrue(n == 0);

            n = 1 + node.@name;
            assertTrue(n == 1);

            n = 1+node.val;
            assertTrue(n === 12);

            //tests with non-XMLish member access
            var thing:TestClassLocal = new TestClassLocal();
            str = thing.myXMLList;
            assertTrue(str === null);

            thing.myXMLList = new XMLList();
            str = thing.myXMLList;
            assertTrue(str == '');

            str = thing.myXMLList.notAChild;
            assertTrue(str == '');
            privateRef = thing;

            var inst:XMLListTesterGeneralTest  = this;
            str = inst.privateRef.myXMLList.notAChild;
            assertTrue(str == '');
        }
        private var privateRef:TestClassLocal;
    }
}
class TestClassLocal {

    public var myXMLList:XMLList;
}