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
    import org.apache.royale.events.KeyboardEvent;

    COMPILE::SWF
    {
        import flash.events.KeyboardEvent;
    }

    import org.apache.royale.events.utils.KeyboardEventConverter;
    import org.apache.royale.test.asserts.*;
    
    public class KeyboardEventConverterTest
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
        public function testConvert():void
        {
            COMPILE::SWF{
                var oEv:flash.events.KeyboardEvent = new flash.events.KeyboardEvent("keyUp");
                oEv.keyCode = 66;
                oEv.charCode = 66;
                var nEv:org.apache.royale.events.KeyboardEvent = KeyboardEventConverter.convert(oEv);
                assertEquals("keyUp", nEv.type);
                oEv = new flash.events.KeyboardEvent("keyDown");
                oEv.keyCode = 66;
                oEv.charCode = 66;
                nEv = KeyboardEventConverter.convert(oEv);
                assertEquals("keyDown", nEv.type);
            }
            COMPILE::JS{
                var oEv:Object = {"type":"keyUp","keyCode":66,"charCode":66};
                var nEv:org.apache.royale.events.KeyboardEvent = KeyboardEventConverter.convert(oEv);
                assertEquals("keyUp", nEv.type);
                oEv = {"type":"keyDown","keyCode":66,"charCode":66};
                nEv = KeyboardEventConverter.convert(oEv);
                assertEquals("keyDown", nEv.type);
            }
        }

    }
}
