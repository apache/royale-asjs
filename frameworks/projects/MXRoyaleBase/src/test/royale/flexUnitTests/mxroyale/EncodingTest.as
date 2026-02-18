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
    
   
    import mx.system.System;
    import org.apache.royale.test.asserts.*;
    import flexUnitTests.mxroyale.support.*;

    import mx.utils.escapeMultiByte;
    /**
     * @royalesuppresspublicvarwarning
     */
    public class EncodingTest
    {
        
        
        
        public function getPlayerVersion():Number{
            COMPILE::SWF{
                import flash.system.Capabilities;
                var parts:Array = Capabilities.version.split(' ')[1].split(',');
                return Number( parts[0]+'.'+parts[1])
            }
            COMPILE::JS{
                //something for js, indicating javascript 'player version' is consistent with more recent flash player versions:
                return 32;
            }
        }
    

        [Before]
        public function setUp():void
        {
            //for flash - this is the default setting anyway, but let's be explicit
            System.useCodePage = false;
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
        
        private function repeat(str:String, times:int):String {
            var result:String = "";
            for (var i:int = 0; i < times; i++) {
                result += str;
            }
            return result;
        }
        
        private function createTestStringFromCodes(codes:Array):String{
            var result:String = "";
            for each(var code:int in codes) {
                result += String.fromCharCode(code);
            }
            return result;
        }
       
        // Basic Tests
        [Test]
        public function testSingleByteASCII():void {
            var result:String = escapeMultiByte("Hello");
            assertEquals(result, "Hello", "Single-byte ASCII characters were incorrectly encoded");
        }
        
        
        
        [Test]
        public function testNull():void {
            var result:String = escapeMultiByte(null);
            assertEquals(result, "null", "Null string encoding failed");
        }
        
        // Control Character Tests
        [Test]
        public function testNullCharacterTruncation():void {
            var result:String = escapeMultiByte("ABC\u0000DEF");
            assertEquals(result, "ABC", "Null character should truncate the string");
        }
        
        [Test]
        public function testLeadingNullCharacter():void {
            var result:String = escapeMultiByte("\u0000ABC");
            assertEquals(result, "", "Null character at start should result in empty string");
        }
        
        [Test]
        public function testControlCharacterEncodingRange():void {
            var result:String = escapeMultiByte("\u0001\u001F");
            assertEquals(result, "%01%1F", "Control characters should be encoded with their hex values");
        }
        
        // Multibyte Character Tests
        [Test]
        public function testMultipleMultibyteCharacters():void {
            var result:String = escapeMultiByte("こんにちは");
            assertEquals(result, "%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF",
                    "Multiple multibyte character encoding failed");
        }
        
       
        
        [Test]
        public function testMultibyteWithNullCharacter():void {
            var result:String = escapeMultiByte("あ\u0000い");
            assertEquals(result, "%E3%81%82", "Null character after multibyte should truncate properly");
        }
        
        // Mixed Content Tests
        [Test]
        public function testMixedASCIIAndMultibyte():void {
            var result:String = escapeMultiByte("Hello 世界");
            assertEquals(result, "Hello%20%E4%B8%96%E7%95%8C",
                    "Mixed ASCII and multibyte character encoding failed");
        }
        
        [Test]
        public function testMixedControlAndMultibyte():void {
            var result:String = escapeMultiByte("A\u001F\u0000C\u0002D");
            assertEquals(result, "A%1F", "String should be truncated at null character after control character");
        }
        
        
        // Boundary Tests
        [Test]
        public function testBoundaryValues():void {
            assertEquals(escapeMultiByte("~"), "%7E", "Highest ASCII character encoding failed");
            assertEquals(escapeMultiByte(String.fromCharCode(0x80)),
                    "%C2%80", "Lowest non-ASCII character encoding failed");
        }
        
        
        [Test]
        public function testBasicMultibyteCharacter():void {
            var result:String = escapeMultiByte("ñ"); // U+00F1
            assertEquals(result, "%C3%B1", "Basic multibyte character encoding failed");
        }
        
        
        [Test]
        public function testEmojiCharacter():void {
            var result:String = escapeMultiByte("😊"); // U+1F60A
            assertEquals(result, "%F0%9F%98%8A", "Emoji character encoding failed");
        }
        
        
        [Test]
        public function testEmptyString():void {
            var result:String = escapeMultiByte("");
            assertEquals(result, "", "Empty string encoding failed");
        }
        
        
        [Test]
        public function testControlCharacter():void {
            var result:String = escapeMultiByte("\n"); // Newline (U+000A)
            assertEquals(result, "%0A", "Control character (newline) encoding failed");
        }
        
        [Test]
        public function testSurrogatePairCharacter():void {
            var result:String = escapeMultiByte("\uD83D\uDE00"); // 😀 as surrogate pair
            assertEquals(result, "%F0%9F%98%80", "Surrogate pair character encoding failed");
        }
        
        [Test]
        public function testInvalidCharacters():void {
            var result:String = escapeMultiByte(String.fromCharCode(0xDC00)); // Lone low surrogate (U+DC00)
            assertEquals(result, "%EF%BF%BD", "Invalid character (lone surrogate) encoding failed");
        }
        
        
        
        [Test]
        public function testLoneHighSurrogates():void {
            var result:String = escapeMultiByte(createTestStringFromCodes([0xD800,0xD801]));
            //there seems to have been changes for flash player 13 and later, where results change for this test - the release notes do indicate some changes in unicode handling, which made explain the differences if some relevant low-level changes were made
            //we are aligning the behavior for js emulation to more recent flash player versions.
            var pass:Boolean = result == "%EF%BF%BD%EF%BF%BD" /* also confirmed in flash 35.0.0.204 with local testing via Adobe Animate */ ||  (getPlayerVersion()< 13 && result == "%EF%BF%BD" )/* observed in older versions of flash (also using Royale compiler) */
            assertEquals(pass, true, "Multiple lone high surrogates encoding failed");
        }
        
        [Test]
        public function testLoneLowSurrogates():void {
            var result:String = escapeMultiByte(createTestStringFromCodes([0xDC00,0xDC01]));
            assertEquals(result, "%EF%BF%BD%EF%BF%BD", "Multiple lone low surrogates encoding failed");
        }
        
        
        [Test]
        public function testInvalidUTF16():void {
            var pass:Boolean = getPlayerVersion() >= 51 ? true : (escapeMultiByte(String.fromCharCode(0x110000)) == "");
            assertEquals(pass, true, "Invalid UTF-16 character encoding failed");
        }
        
        [Test]
        public function testMixedSurrogates():void {
            var result:String = escapeMultiByte( createTestStringFromCodes([0xD800,0xDC00,0xDC01]));
            assertEquals(result, "%F0%90%80%80%EF%BF%BD", "Mixed surrogate pairs encoding failed");
        }
        
        [Test]
        public function testControlAndSurrogates():void {
            var result:String = escapeMultiByte("\n" + String.fromCharCode(0xD800) + String.fromCharCode(0xDC00));
            assertEquals(result, "%0A%F0%90%80%80", "Control characters and surrogate pairs encoding failed");
        }
        
        [Test]
        public function testWhitespace():void {
            assertEquals(escapeMultiByte("   "), "%20%20%20", "Spaces encoding failed");
            assertEquals(escapeMultiByte(" \t \t "), "%20%09%20%09%20", "Mixed spaces and tabs encoding failed");
        }
        
        [Test]
        public function testEmojiAndMultilingual():void {
            assertEquals(escapeMultiByte("😊🌏"), "%F0%9F%98%8A%F0%9F%8C%8F", "Emoji sequence encoding failed");
            assertEquals(escapeMultiByte("Hello 世界 Привет"), "Hello%20%E4%B8%96%E7%95%8C%20%D0%9F%D1%80%D0%B8%D0%B2%D0%B5%D1%82", "Multilingual character encoding failed");
        }
        
        [Test]
        public function testBinaryData():void {
            assertEquals(escapeMultiByte(String.fromCharCode(0x01) + String.fromCharCode(0xFF)), "%01%C3%BF", "Binary data encoding failed");
        }
        
        [Test]
        public function testSpecialCharacters():void {
            assertEquals(escapeMultiByte("!@#$%^&*()"), "%21%40%23%24%25%5E%26%2A%28%29", "Special characters encoding failed");
            assertEquals(escapeMultiByte("Hello@World$!"), "Hello%40World%24%21", "Mixed special characters and ASCII encoding failed");
        }
        
        
        [Test]
        public function testOverlappingSurrogates():void {
            var result:String = escapeMultiByte(createTestStringFromCodes([0xD800, 0xDC00, 0xD800, 0xD801, 0xDC00]));
            //another variation of results depending on flash player version... see earlier explanation.
            var pass:Boolean = result == "%F0%90%80%80%EF%BF%BD%F0%90%90%80" /* also confirmed in flash 35.0.0.204 with local testing via Adobe Animate */ ||  (getPlayerVersion()< 13 && result == "%F0%90%80%80%EF%BF%BD%EF%BF%BD" )/* observed in older versions of flash (also using Royale compiler) */
            assertEquals(pass, true,"Overlapping surrogates encoding failed");
        }
        
        [Test]
        public function testHighSurrogateFollowedByASCII():void {
            var result:String = escapeMultiByte(createTestStringFromCodes([0xD800, 0x41])); // 0x41 = 'A'
            //another variation of results depending on flash player version... see earlier explanation.
            var pass:Boolean = result == "%EF%BF%BDA" /* also confirmed in flash 35.0.0.204 with local testing via Adobe Animate */ ||  (getPlayerVersion()< 13 && result == "%EF%BF%BD" )/* observed in older versions of flash (also using Royale compiler) */
            assertEquals(pass, true, "High surrogate followed by ASCII encoding failed");
        }
        
        [Test]
        public function testLowSurrogatePrecededByASCII():void {
            var result:String = escapeMultiByte(createTestStringFromCodes([0x41, 0xDC00])); // 0x41 = 'A'
            assertEquals(result, "A%EF%BF%BD", "Low surrogate preceded by ASCII encoding failed");
        }
        
        [Test]
        public function testMultipleValidPairsWithSurrogatesInBetween():void {
            var result:String = escapeMultiByte(createTestStringFromCodes([0xD800, 0xDC00, 0xD801, 0xD800, 0xDC01]));
            //another variation of results depending on flash player version... see earlier explanation.
            var pass:Boolean = result == "%F0%90%80%80%EF%BF%BD%F0%90%80%81" /* also confirmed in flash 35.0.0.204 with local testing via Adobe Animate */ ||  (getPlayerVersion()< 13 && result == "%F0%90%80%80%EF%BF%BD%EF%BF%BD" )/* observed in older versions of flash (also using Royale compiler) */
            assertEquals(pass, true, "Repeated invalid code points encoding failed");
        }

        
        [Test]
        public function testNullCharacter():void {
            var result:String = escapeMultiByte(createTestStringFromCodes([0x0000]));
            assertEquals(result, "", "Null character encoding failed");
        }
        
        [Test]
        public function testRepeatedInvalidCodePoints():void {
            var result:String = escapeMultiByte(createTestStringFromCodes([0xD800, 0xD800, 0xD800]));
            var pass:Boolean = result == "%EF%BF%BD%EF%BF%BD%EF%BF%BD" /* also confirmed in flash 35.0.0.204 with local testing via Adobe Animate */ ||  (getPlayerVersion()< 13 && result == "" )/* observed in older versions of flash (also using Royale compiler) */
            assertEquals(pass, true, "Repeated invalid code points encoding failed");
        }
        
        [Test]
        public function testCharactersFromDifferentRanges():void {
            var result:String = escapeMultiByte(createTestStringFromCodes([0x0041, 0x20AC, 0x1F600])); // 'A', €, 😀
            var pass:Boolean = (getPlayerVersion() >= 51) ? (result == "A%E2%82%AC%F0%9F%98%80") : (result =="A%E2%82%AC%EF%98%80");
            assertEquals(pass, true, "Characters from different ranges encoding failed");
        }
        
        
        [Test]
        public function testEscapeSurrogates():void {
            var result:String = escapeMultiByte("\uD800\uDC00"); // First valid surrogate pair
            assertEquals(result, "%F0%90%80%80", "Surrogate pair encoding failed");
        }
        
        [Test]
        public function testEscapeHighSurrogateAlone():void {
            var result:String = escapeMultiByte("\uD800"); // High surrogate alone
            assertEquals(result, "%3F", "High surrogate alone encoding failed");
        }
        
        [Test]
        public function testEscapeLowSurrogateAlone():void {
            var result:String = escapeMultiByte("\uDC00"); // Low surrogate alone
            assertEquals(result, "%3F", "Low surrogate alone encoding failed");
        }
        
        [Test]
        public function testEscapeControlCharacters():void {
            var result:String = escapeMultiByte("\u0000\u001F\u007F");
            assertEquals(result, "", "Control characters encoding failed");
        }
        
        [Test]
        public function testEscapeMixedContent():void {
            var result:String = escapeMultiByte("hello\u00A9world"); // Copyright symbol
            assertEquals(result, "hello%C2%A9world", "Mixed ASCII and special character encoding failed");
        }
        
        [Test]
        public function testEscapeMaximumValidCodepoint():void {
            var result:String = escapeMultiByte("\uDBFF\uDFFF"); // U+10FFFF
            assertEquals(result, "%F4%8F%BF%BF", "Maximum valid codepoint encoding failed");
        }
        
        [Test]
        public function testEscapeNonCharacters():void {
            var result:String = escapeMultiByte("\uFFFE\uFFFF"); // Unicode non-characters
            assertEquals(result, "%EF%BF%BE%EF%BF%BF", "Unicode non-characters encoding failed");
        }
        
        [Test]
        public function testEscapeNull():void {
            var result:String = escapeMultiByte(null);
            assertEquals(result, "null", "Null string encoding failed");
        }
        
        [Test]
        public function testEscapeLongString():void {
            var input:String = repeat("あ", 1000); // Japanese character
            var expected:String = repeat("%E3%81%82", 1000);
            var result:String = escapeMultiByte(input);
            assertEquals(result, expected, "Long string encoding failed");
        }
        
        [Test]
        public function testEscapePrivateUseArea():void {
            var result:String = escapeMultiByte("\uE000"); // Private Use Area
            assertEquals(result, "%EE%80%80", "Private Use Area character encoding failed");
        }
        
        [Test]
        public function testEscapeSpecialSpaces():void {
            var result:String = escapeMultiByte("\u00A0\u2002"); // NBSP and EN SPACE
            assertEquals(result, "%C2%A0%E2%80%82", "Special space characters encoding failed");
        }
        
        [Test]
        public function testEscapeFullwidthCharacters():void {
            var result:String = escapeMultiByte("Ａ"); // Fullwidth A
            assertEquals(result, "%EF%BC%A1", "Fullwidth character encoding failed");
        }
        
        [Test]
        public function testEscapeCombiningCharacters():void {
            var result:String = escapeMultiByte("e\u0301"); // e with acute accent
            assertEquals(result, "e%CC%81", "Combining character encoding failed");
        }
        
        [Test]
        public function testControlCharacterAfterValidContent():void {
            var result:String = escapeMultiByte("ABC\u001F"); // Valid content followed by control character
            assertEquals(result, "ABC%1F", "Control character after valid content should return empty string");
        }
        
        [Test]
        public function testControlCharacterBeforeValidContent():void {
            var result:String = escapeMultiByte("\u001FABC"); // Control character followed by valid content
            assertEquals(result, "%1FABC", "Control character before valid content should return empty string");
        }
        
        [Test]
        public function testControlCharacterBetweenValidContent():void {
            var result:String = escapeMultiByte("AB\u001FC"); // Control character between valid content
            assertEquals(result, "AB%1FC", "Control character between valid content should return empty string");
        }
        
        [Test]
        public function testNullCharacterMidpoint():void {
            var result:String = escapeMultiByte("ABC\u0000DEF");
            assertEquals(result, "ABC", "Null character should truncate the string");
        }
        
        [Test]
        public function testNullCharacterAtStart():void {
            var result:String = escapeMultiByte("\u0000ABC");
            assertEquals(result, "", "Null character at start should result in empty string");
        }
        
        [Test]
        public function testControlCharacterEncoding():void {
            var result:String = escapeMultiByte("\u0001\u001F");
            assertEquals(result, "%01%1F", "Control characters should be encoded with % and their hex value");
        }
        
        [Test]
        public function testMixedControlCharacters():void {
            var result:String = escapeMultiByte("A\u0001B\u001FC");
            assertEquals(result, "A%01B%1FC", "Mixed content with control characters should be properly encoded");
        }
        
        [Test]
        public function testMultipleNullCharacters():void {
            var result:String = escapeMultiByte("A\u0000B\u0000C");
            assertEquals(result, "A", "String should be truncated at first null character");
        }
        
        [Test]
        public function testControlCharacterRange():void {
            // Test all control characters from 0x01 to 0x1F
            var result:String = "";
            for (var i:uint = 1; i < 32; i++) {
                result += escapeMultiByte(String.fromCharCode(i));
            }
            var expected:String = "%01%02%03%04%05%06%07%08%09%0A%0B%0C%0D%0E%0F%10%11%12%13%14%15%16%17%18%19%1A%1B%1C%1D%1E%1F";
            assertEquals(result, expected, "All control characters should be properly encoded");
        }
        
        [Test]
        public function testNullCharacterAfterMultibyte():void {
            var result:String = escapeMultiByte("あ\u0000い");
            assertEquals(result, "%E3%81%82", "Null character after multibyte should truncate properly");
        }
        
        [Test]
        public function testControlCharacterAfterMultibyte():void {
            var result:String = escapeMultiByte("あ\u001Fい");
            assertEquals(result, "%E3%81%82%1F%E3%81%84", "Control character between multibyte characters should be properly encoded");
        }
        
        [Test]
        public function testNullAndControlMixed():void {
            var result:String = escapeMultiByte("A\u001FB\u0000C\u0002D");
            assertEquals(result, "A%1FB", "Mixed null and control characters should handle truncation and encoding properly");
        }
        
        [Test]
        public function testNullCharacterAfterMultibyteChar():void {
            var result:String = escapeMultiByte("あ\u0000い");
            assertEquals(result, "%E3%81%82", "Null character after multibyte should truncate properly");
        }
        
        [Test]
        public function testMultipleNullCharactersInString():void {
            var result:String = escapeMultiByte("A\u0000B\u0000C");
            assertEquals(result, "A", "String should be truncated at first null character");
        }
        
        [Test]
        public function testControlAndNullCharacterMixed():void {
            var result:String = escapeMultiByte("A\u001FB\u0000C\u0002D");
            assertEquals(result, "A%1FB", "Mixed null and control characters should handle truncation and encoding properly");
        }
      
    }
}
