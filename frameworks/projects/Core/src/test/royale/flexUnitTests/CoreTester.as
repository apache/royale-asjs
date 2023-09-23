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
    import flexUnitTests.language.*
    
    [Suite]
    [RunWith("org.apache.royale.test.runners.SuiteRunner")]
    public class CoreTester
    {
        
        //language tests
        public var languageTestIs:LanguageTesterTestIs;
        public var languageTestIntUint:LanguageTesterIntUint;
        public var languageTestVector:LanguageTesterTestVector;
        public var languageTestClass:LanguageTesterTestClass;
        public var languageTestLoopVariants:LanguageTesterTestLoopVariants;
        public var languageTestArraySort:LanguageTesterArraySort;
        public var languageTesttryCatch:LanguageTesterTestTryCatch;
        
        //core tests
        public var strandTesterTest:StrandTesterTest;
		public var binaryDataTesterTest:BinaryDataTesterTest;
		public var arrayUtilsTest:ArrayUtilsTest;
		public var dateUtilsTest:DateUtilsTest;
        public var keyConverterTest:KeyConverterTest;
        public var keyboardEventConverterTest:KeyboardEventConverterTest;
        public var stringUtilsTest:StringUtilsTest;
        public var sanitizerTest:SanitizeTest;
        public var eventsTest:EventsTest;
        public var objectUtilTests:ObjectUtilsTest;
        public var functionalTests:FunctionalTests;
        public var taskTests:TaskTests;

    }
}
