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
    import flexUnitTests.xml.*
    
    [Suite]
    [RunWith("org.apache.royale.test.runners.SuiteRunner")]
    /**
     * @royalesuppresspublicvarwarning
     */
    public class XMLTester
    {
        public function XMLTester()
        {
           
            //var arr:Array = [XMLTesterGeneralTest, XMLTesterStringifyTest, XMLListTesterGeneralTest, XMLNamespaceTest];
        }
    
    
        public var xmlTesterGeneralTest:XMLTesterGeneralTest;
    
        public var xmlTesterStringifyTest:XMLTesterStringifyTest;
    
        public var xmlListTesterGeneralTest:XMLListTesterGeneralTest;
    
        public var xmlNamespaceTest:XMLNamespaceTest;
    
        public var xmlNamespaceClassTest:XMLNamespaceClassTest;
    
        public var xmlQNameTest:XMLQNameTest;
    
        public var xmlNamespaceQueries:XMLTesterNamespaceQueries;

        public var xmllistInterationTests:XMLListTesterIterationlTest;

        public var xmlLiteralTest:XMLLiteralTest;
        
    }
}
