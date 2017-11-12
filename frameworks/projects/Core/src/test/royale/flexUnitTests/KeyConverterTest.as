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
    import org.apache.royale.utils.date.*;
    import org.apache.royale.core.Strand;
    import org.apache.royale.events.utils.KeyConverter;
    import org.apache.royale.test.asserts.*;
    
    public class KeyConverterTest
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
        public function testConvertKeyCode():void
        {
            assertEquals("Backspace", KeyConverter.convertKeyCode(8), "Should be Backspace");
            assertEquals("Tab", KeyConverter.convertKeyCode(9), "Should be Tab");
            assertEquals("Enter", KeyConverter.convertKeyCode(13), "Should be Enter");
            assertEquals("ShiftLeft", KeyConverter.convertKeyCode(16), "Should be ShiftLeft");

            assertEquals("KeyA", KeyConverter.convertKeyCode(65), "Should be KeyA");
            assertEquals("KeyD", KeyConverter.convertKeyCode(68), "Should be KeyD");
            assertEquals("KeyG", KeyConverter.convertKeyCode(71), "Should be KeyG");
            assertEquals("KeyJ", KeyConverter.convertKeyCode(74), "Should be KeyJ");
            assertEquals("KeyM", KeyConverter.convertKeyCode(77), "Should be KeyM");
            assertEquals("KeyP", KeyConverter.convertKeyCode(80), "Should be KeyP");
            assertEquals("KeyS", KeyConverter.convertKeyCode(83), "Should be KeyS");
            assertEquals("KeyV", KeyConverter.convertKeyCode(86), "Should be KeyV");
            assertEquals("KeyZ", KeyConverter.convertKeyCode(90), "Should be KeyZ");

            assertEquals("Digit0", KeyConverter.convertKeyCode(48), "Should be Digit0");
            assertEquals("Digit1", KeyConverter.convertKeyCode(49), "Should be Digit1");
            assertEquals("Digit2", KeyConverter.convertKeyCode(50), "Should be Digit2");
            assertEquals("Digit3", KeyConverter.convertKeyCode(51), "Should be Digit3");
            assertEquals("Digit4", KeyConverter.convertKeyCode(52), "Should be Digit4");
            assertEquals("Digit5", KeyConverter.convertKeyCode(53), "Should be Digit5");
            assertEquals("Digit6", KeyConverter.convertKeyCode(54), "Should be Digit6");
            assertEquals("Digit7", KeyConverter.convertKeyCode(55), "Should be Digit7");
            assertEquals("Digit8", KeyConverter.convertKeyCode(56), "Should be Digit8");
            assertEquals("Digit9", KeyConverter.convertKeyCode(57), "Should be Numpad9");
            
            assertEquals("Numpad0", KeyConverter.convertKeyCode(96), "Should be Numpad0");
            assertEquals("Numpad1", KeyConverter.convertKeyCode(97), "Should be Numpad1");
            assertEquals("Numpad2", KeyConverter.convertKeyCode(98), "Should be Numpad2");
            assertEquals("Numpad3", KeyConverter.convertKeyCode(99), "Should be Numpad3");
            assertEquals("Numpad4", KeyConverter.convertKeyCode(100), "Should be Numpad4");
            assertEquals("Numpad5", KeyConverter.convertKeyCode(101), "Should be Numpad5");
            assertEquals("Numpad6", KeyConverter.convertKeyCode(102), "Should be Numpad6");
            assertEquals("Numpad7", KeyConverter.convertKeyCode(103), "Should be Numpad7");
            assertEquals("Numpad8", KeyConverter.convertKeyCode(104), "Should be Numpad8");
            assertEquals("Numpad9", KeyConverter.convertKeyCode(105), "Should be Numpad9");
            assertEquals("NumpadAdd", KeyConverter.convertKeyCode(107), "Should be NumpadAdd");
            
            assertEquals("F1", KeyConverter.convertKeyCode(112));
            assertEquals("F2", KeyConverter.convertKeyCode(113));
            assertEquals("F3", KeyConverter.convertKeyCode(114));
            assertEquals("F4", KeyConverter.convertKeyCode(115));
            assertEquals("F5", KeyConverter.convertKeyCode(116));
            assertEquals("F6", KeyConverter.convertKeyCode(117));
            assertEquals("F7", KeyConverter.convertKeyCode(118));
            assertEquals("F8", KeyConverter.convertKeyCode(119));
            assertEquals("F9", KeyConverter.convertKeyCode(120));
            assertEquals("F10", KeyConverter.convertKeyCode(121));
            assertEquals("F11", KeyConverter.convertKeyCode(122));
        }

        [Test]
        public function testConvertCharCode():void
        {
            assertEquals("0", KeyConverter.convertCharCode(48));
            assertEquals("1", KeyConverter.convertCharCode(49));
            assertEquals("2", KeyConverter.convertCharCode(50));
            assertEquals("3", KeyConverter.convertCharCode(51));
            assertEquals("4", KeyConverter.convertCharCode(52));
            assertEquals("5", KeyConverter.convertCharCode(53));
            assertEquals("6", KeyConverter.convertCharCode(54));
            assertEquals("7", KeyConverter.convertCharCode(55));
            assertEquals("8", KeyConverter.convertCharCode(56));
            assertEquals("9", KeyConverter.convertCharCode(57));
            assertEquals("A", KeyConverter.convertCharCode(65));

        }
    }
}
