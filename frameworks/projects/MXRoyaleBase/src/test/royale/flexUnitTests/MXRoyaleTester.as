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
    import flexUnitTests.mxroyale.*
    
    [Suite]
    [RunWith("org.apache.royale.test.runners.SuiteRunner")]
    /**
     * @royalesuppresspublicvarwarning
     */
    public class MXRoyaleTester
    {
        public function MXRoyaleTester()
        {
        }

        public var acTest:CollectionsTest;
        public var objectUtilTest:ObjectUtilTest;
        public var flexSDK_ObjectUtilTests:FlexSDK_ObjectUtil_Tests;
        public var flexSDK_ObjectUtil_FLEX_34852_Tests:FlexSDK_ObjectUtil_FLEX_34852_Tests;
        public var flexSDK_ObjectUtil_Compare_Tests:FlexSDK_ObjectUtil_Compare_Tests;
        
    }
    
    
}
