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

    import mx.utils.unescapeMultiByte;
    /**
     * @royalesuppresspublicvarwarning
     */
    public class DecodingTest
    {
    
        
        public static var isJS:Boolean = COMPILE::JS;
    

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
        
        
        [Test]
        public function testBasicASCII():void {
            var result:String = unescapeMultiByte("hello");
            assertEquals(result, "hello", "Basic ASCII decoding failed");
        }
        
        [Test]
        public function testEmptyString():void {
            var result:String = unescapeMultiByte("");
            assertEquals(result, "", "Empty string handling failed");
        }
        
        [Test]
        public function testValidPercentEncoding():void {
            var result:String = unescapeMultiByte("%20");
            assertEquals(result, " ", "Valid percent encoding (%20) decoding failed");
        }
        
        [Test]
        public function testControlCharacters():void {
            var result:String = unescapeMultiByte("%0A%09");
            assertEquals(result, "\n\t", "Control character decoding (%0A%09) failed");
        }
        
        [Test]
        public function testSpecialCharacters():void {
            var result:String = unescapeMultiByte("%25");
            assertEquals(result, "%", "Special character decoding (%25) failed");
        }
        
        [Test]
        public function testMalformedSequenceInvalidHex():void {
            var result:String = unescapeMultiByte("%ZZ");
            assertEquals(result, "Z", "Malformed sequence (%ZZ) handling failed");
            
        }
        
        [Test]
        public function testMalformedSequenceSingleValidHexDigit():void {
            var result:String = unescapeMultiByte("%AZ");
            assertEquals(result, "", "Malformed sequence (%AZ) handling failed");
        }
        
        [Test]
        public function testMixedContent():void {
            var result:String = unescapeMultiByte("hello%20world");
            assertEquals(result, "hello world", "Mixed content decoding (hello%20world) failed");
        }
        
        [Test]
        public function testTruncatedSequencePercent():void {
            var result:String = unescapeMultiByte("%");
            assertEquals(result, "", "Truncated sequence (%) handling failed");
        }
        
        [Test]
        public function testTruncatedSequenceSingleHex():void {
            var result:String = unescapeMultiByte("%A");
            assertEquals(result, "", "Truncated sequence (%A) handling failed");
        }
        
        [Test]
        public function testTruncatedSequenceMalformedHex():void {
            var result:String = unescapeMultiByte("%Z");
            assertEquals(result, "", "Truncated sequence (%Z) handling failed");
        }
        
        [Test]
        public function testLongInputString():void {
            var longInput:String = repeat("%20", 1000);
            var longOutput:String = repeat(" ", 1000);
            var result:String = unescapeMultiByte(longInput);
            assertEquals(result, longOutput, "Long input string handling failed");
        }
        
        [Test]
        public function testDeferredMultibyteCharacterDecoding():void {
            var result:String = unescapeMultiByte("%u3053%u3093%u306b%u3061%u306f");
            assertEquals(result, "30533093306b3061306f", "Deferred multibyte character decoding (%uXXXX) failed");
        }
        
        [Test]
        public function testTruncatedThreeByteSequence():void {
            var result:String = unescapeMultiByte("%E2%82");
            assertEquals(result, "â", "Truncated three-byte sequence (%E2%82) decoding failed");
        }
        
        [Test]
        public function testInvalidContinuationByte():void {
            var result:String = unescapeMultiByte("%C2%41");
            assertEquals(result, "ÂA", "Invalid continuation byte (%C2%41) decoding failed");
        }
        
        [Test]
        public function testInvalidLeadingByte():void {
            var result:String = unescapeMultiByte("%FF");
            assertEquals(result, "ÿ", "Invalid leading byte (%FF) decoding failed");
        }
        
        [Test]
        public function testBadHexCode():void {
            var result:String = unescapeMultiByte("%G0");
            assertEquals(result, "0", "Bad hex code (%G0) decoding failed");
        }
        
        [Test]
        public function testMixedContentWithTruncatedSequence():void {
            var result:String = unescapeMultiByte("hello%E2%82world");
            assertEquals(result, "helloâworld", "Mixed content with truncated sequence failed");
        }
        

      
        [Test]
        public function testInvalidSecondByteInFourByteSequence():void {
            var result:String = unescapeMultiByte("%F0%41%A7%89"); // Invalid second byte (expected `10xxxxxx`)
            assertEquals(result, "ðA§", "Invalid second byte in four-byte sequence (%F0%41%A7%89) decoding failed");
        }
  
        [Test]
        public function testInvalidThirdByteInFourByteSequence():void {
            var result:String = unescapeMultiByte("%F0%A4%41%89"); // Invalid third byte (expected `10xxxxxx`)
            assertEquals(result, "ð¤A", "Invalid third byte in four-byte sequence (%F0%A4%41%89) decoding failed");
        }
        
    
        [Test]
        public function testInvalidFourthByteInFourByteSequence():void {
            var result:String = unescapeMultiByte("%F0%A4%A7%41"); // Invalid fourth byte (expected `10xxxxxx`)
            assertEquals(result, "ð¤§A", "Invalid fourth byte in four-byte sequence (%F0%A4%A7%41) decoding failed");
        }
   
        [Test]
        public function testCompletelyInvalidFourByteSequence():void {
            var result:String = unescapeMultiByte("%F0%41%42%43"); // All continuation bytes invalid
            assertEquals(result, "ðABC", "Completely invalid four-byte sequence (%F0%41%42%43) decoding failed");
        }
        
        [Test]
        public function testMixedContentWithInvalidBytes():void {
            var result:String = unescapeMultiByte("hi%C2%41%G0there");
            assertEquals(result, "hiÂA0there", "Mixed content with invalid bytes failed");//hiÂA0there
        }
        
        
        [Test]
        public function testNull():void {
            var str:String = null;
            var result:String = unescapeMultiByte(str);
            assertEquals(result, "null", "Null reference failed");//hiÂA0there
        }
        
        [Test]
        public function testMultibyteSequenceInvalidHex():void {
            var result:String = unescapeMultiByte("%E3%ZZ");
            assertEquals(result, "ãZ" , "Multibyte sequence with invalid hex decoding failed");
        }
        
        [Test]
        public function testMultibyteSequenceInvalidHex2():void {
            var result:String = unescapeMultiByte("%E3%Z");
            assertEquals(result, "ã" , "Multibyte sequence with invalid hex decoding failed");
        }
        
        [Test]
        public function testMissingContinuationByte():void {
            var result:String = unescapeMultiByte("%E3%81");
            assertEquals(result, "ã", "Multibyte sequence with missing continuation byte decoding failed");
        }
        
        [Test]
        public function testMultibyteSequenceTruncated():void {
            var result:String = unescapeMultiByte("%E3%81%82%");
            assertEquals(result, "あ", "Multibyte sequence truncated at end of string decoding failed");
        }
        
        [Test]
        public function testMixedContinuationBytes():void {
            var result:String = unescapeMultiByte("%F0%A4%41%89");
            assertEquals(result, "ð¤A", "Mixed valid and invalid continuation bytes decoding failed");
        }
        
        [Test]
        public function testCompletelyInvalidMultibyteSequence():void {
            var result:String = unescapeMultiByte("%F0%41%42%43");
            assertEquals(result, "ðABC", "Completely invalid multibyte sequence decoding failed");
        }
        

        [Test]
        public function testBoundaryValidHexEncoding():void {
            var result:String = unescapeMultiByte("%7E"); // '~' is the last ASCII character
            assertEquals(result, "~", "Boundary valid hex encoding (%7E) decoding failed");
        }
        
        [Test]
        public function testUnpairedHighSurrogate():void {
            var result:String = unescapeMultiByte("%ED%A0%80"); // U+D800 (high surrogate, unpaired)
            assertEquals(result.length, 1 , "Unpaired high surrogate decoding failed");
            var code:uint = result.charCodeAt(0);
            assertEquals(code, 0xd800 , "Unpaired high surrogate decoding failed");
        }
        
        [Test]
        public function testUnpairedLowSurrogate():void {
            var result:String = unescapeMultiByte("%ED%B0%80"); // U+DC00 (low surrogate, unpaired)
            assertEquals(result.length, 1 , "Unpaired high surrogate decoding failed");
            var code:uint = result.charCodeAt(0);
            assertEquals(code, 0xdc00 , "Unpaired high surrogate decoding failed");
        }
        
        [Test]
        public function testOverlongEncoding():void {
            var result:String = unescapeMultiByte("%C0%A1"); // Overlong encoding of 'A' (U+0041)
            assertEquals(result, "À¡", "Overlong encoding decoding failed");
        }
        
        [Test]
        public function testInvalidLeadingByteRange():void {
            var result:String = unescapeMultiByte("%F5%80%80%80"); // Invalid leading byte (> U+10FFFF)
            //&lt;񀀀&gt; to be equal to &lt;�&gt; 
            assertEquals(result, "񀀀", "Invalid leading byte range decoding failed");
        }
        
        [Test]
        public function testMixedEncodings():void {
            var result:String = unescapeMultiByte("hello%20%E3%81%82world%25");
            assertEquals(result, "hello あworld%", "Mixed encodings decoding failed");
        }
        //--
        [Test]
        public function testValidFourByteSequenceFlashCompatible():void {
            var result:String = unescapeMultiByte("%F5%80%80%80");
            assertEquals(result, "񀀀", "Valid 4-byte sequence (%F5%80%80%80) decoding failed");
        }
        
        [Test]
        public function testValidMaxUnicodeCodePoint():void {
            var result:String = unescapeMultiByte("%F4%8F%BF%BF"); // U+10FFFF
            assertEquals(result, "\uDBFF\uDFFF", "Valid 4-byte sequence (%F4%8F%BF%BF) decoding failed");
        }
        
        [Test]
        public function testInvalidOverlongFourByteSequence():void {
            var result:String = unescapeMultiByte("%F0%80%80%80"); // Overlong encoding for U+0000
            assertEquals(result, "ð", "Invalid 4-byte sequence (overlong %F0%80%80%80) decoding failed");
        }
        
        [Test]
        public function testInvalidFourByteSequenceBadContinuation():void {
            var result:String = unescapeMultiByte("%F5%80%80%ZZ");
            assertEquals(result, "õZ", "Invalid 4-byte sequence (bad continuation %F5%80%80%ZZ) decoding failed");
        }
        
        [Test]
        public function testMixedContentWithValidAndInvalidFourByteSequences():void {
            var result:String = unescapeMultiByte("hello%F5%80%80%80world%F0%80%80%80");
            assertEquals(result, "hello񀀀worldð", "Mixed content with valid and invalid 4-byte sequences decoding failed");
        }
        
        
        [Test]
        public function testConsecutiveOverlongEncodings():void {
            var result:String = unescapeMultiByte("%C0%A1%C0%A1%C0%A1");
            assertEquals(result, "À¡À¡À¡", "Multiple consecutive overlong encodings failed");
        }
        
        [Test]
        public function testMixedValidInvalidEdgeCases():void {
            var result:String = unescapeMultiByte("%20%FF%C2%41%F0%28%8C%28");
            assertEquals(result, " ÿÂAð((", "Mixed valid/invalid edge cases failed");
        }
        
        [Test]
        public function testMixedUnicodeAndUtf8Sequences():void {
            var result:String = unescapeMultiByte("%u3042%E3%81%82");//
            assertEquals(result, "3042あ", "Mixed Unicode and UTF-8 sequence handling failed");
        }
        
        [Test]
        public function testConsecutiveInvalidSequences():void {
            var result:String = unescapeMultiByte("%FF%FF%FF");
            assertEquals(result, "ÿÿÿ", "Consecutive invalid sequences handling failed");
        }
        
        [Test]
        public function testSurrogatePairBoundaries():void {
            var result:String = unescapeMultiByte("%F4%8F%BF%BE"); // Just before max Unicode
            assertEquals(result, "\uDBFF\uDFFE", "Near-maximum Unicode code point handling failed");
        }
        
        [Test]
        public function testPartialSurrogatePair():void {
            var result:String = unescapeMultiByte("%F4%8F"); // Incomplete surrogate pair
            assertEquals(result, "ô", "Partial surrogate pair handling failed");
        }
        
        
        [Test]
        public function testRepeatedInvalidContinuations():void {
            var result:String = unescapeMultiByte("%C2%80%80%80");
            assertEquals(result, "", "Repeated invalid continuation bytes failed");
        }
        
        [Test]
        public function testMixedPercentAndUnicodeSequences():void {
            var result:String = unescapeMultiByte("hello%u3042%20world%E3%81%82");
            assertEquals(result, "hello3042 worldあ", "Mixed percent and Unicode sequences failed");
        }
        
        [Test]
        public function testMixedUnicodeAndControlCharacters():void {
            var result:String = unescapeMultiByte("%u3042%0A%u3044");
            assertEquals(result, "3042\n3044", "Mixed Unicode and control characters failed");
        }
        
        [Test]
        public function testPartialUnicodeSequence():void {
            var result:String = unescapeMultiByte("%u304");
            assertEquals(result, "304", "Partial Unicode sequence handling failed");
        }
        
        [Test]
        public function testInvalidUnicodeSequence():void {
            //note: %u encoding is not supported for this anyway
            var result:String = unescapeMultiByte("%u%%%");
            assertEquals(result, "", "Invalid Unicode sequence handling failed");
        }
        
        [Test]
        public function testConsecutivePercentCharacters():void {
            var result:String = unescapeMultiByte("%%%%");
            assertEquals(result, "", "Consecutive percent characters handling failed");
        }
        
        [Test]
        public function testMixedValidInvalidUnicodeSequences():void {
            var result:String = unescapeMultiByte("%u3042%u123G%u3044");
            //note: %u encoding is not supported for this anyway
            assertEquals(result, "3042123G3044", "Mixed valid/invalid Unicode sequences failed");
        }
        
        [Test]
        public function testEmptyUnicodeSequence():void {
            var result:String = unescapeMultiByte("%u");
            //note: %u encoding is not supported for this anyway
            assertEquals(result, "", "Empty Unicode sequence handling failed");
        }
        
        [Test]
        public function testSequentialPercentEncodings():void {
            var result:String = unescapeMultiByte("%20%20%20%20");
            assertEquals(result, "    ", "Sequential percent encodings failed");
        }
        
        [Test]
        public function testMixedValidInvalidPercentEncodings():void {
            var result:String = unescapeMultiByte("%20%ZZ%41%QQ");
            assertEquals(result, " ZAQ", "Mixed valid/invalid percent encodings failed");
        }
        
        [Test]
        public function testOverlappingPercentSequences():void {
            var result:String = unescapeMultiByte("%%%41%%42");
            assertEquals(result, "A42", "Overlapping percent sequences failed");
        }
        
        [Test]
        public function testThreeByteSequenceWithInvalidMiddleByte():void {
            var result:String = unescapeMultiByte("%E2%ZZ%80");
            assertEquals(result, "âZ", "Three-byte sequence with invalid middle byte failed");
        }
        
        [Test]
        public function testIncompletePercentAtStringEnd():void {
            var result:String = unescapeMultiByte("test%");
            assertEquals(result, "test", "Incomplete percent at string end failed");
        }
        
        [Test]
        public function testMixedASCIIAndInvalidSequences():void {
            var result:String = unescapeMultiByte("a%FFb%ZZc%80d");
            assertEquals(result, "aÿbZcd", "Mixed ASCII and invalid sequences failed");
        }
        
        [Test]
        public function testSequentialMalformedHexCodes():void {
            var result:String = unescapeMultiByte("%GG%HH%II");
            assertEquals(result, "GHI", "Sequential malformed hex codes failed");
        }
        
        [Test]
        public function testMixedPercentAndInvalidContinuation():void {
            var result:String = unescapeMultiByte("%C2%80%80%C2");
            assertEquals(result, "Â", "Mixed percent and invalid continuation bytes failed");
        }
        
        [Test]
        public function testPercentFollowedByEndOfString():void {
            var result:String = unescapeMultiByte("test%C2");
            assertEquals(result, "testÂ", "Percent followed by valid hex at end of string failed");
        }
        
        [Test]
        public function testInvalidLeadingByteWithValidHex():void {
            var result:String = unescapeMultiByte("%F8%80%80%80%80");
            assertEquals(result, "ø", "Invalid leading byte with valid continuation bytes failed");
        }
        
        [Test]
        public function testMixedValidPercentAndText():void {
            var result:String = unescapeMultiByte("hello%C2%80there%FF");
            assertEquals(result, "hellothereÿ", "Mixed valid percent encodings and text failed");
        }
        
        [Test]
        public function testAlternatingValidInvalidBytes():void {
            var result:String = unescapeMultiByte("%41%ZZ%42%YY%43");
            assertEquals(result, "AZBYC", "Alternating valid/invalid byte sequences failed");
        }
        
        [Test]
        public function testLeadingByteFollowedByPercent():void {
            var result:String = unescapeMultiByte("%C2%");
            assertEquals(result, "Â", "Leading byte followed by lone percent failed");
        }
        
        [Test]
        public function testDoublePercentAtEndOfSequence():void {
            var result:String = unescapeMultiByte("%C2%80%%");
            assertEquals(result, "", "Double percent at end of valid sequence failed");
        }
      
    }
}
