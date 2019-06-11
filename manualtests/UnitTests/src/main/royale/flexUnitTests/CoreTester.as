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
    import flexUnitTests.core.*
    
    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    /**
     *  @royalesuppresspublicvarwarning
     */
    public class CoreTester
    {
        public function CoreTester()
        {
            // for JS, force-link these classes in the output
            var arr:Array = [StrandTesterTest, BinaryDataTesterTest, MD5Test, ArrayTesterTest];
        }
        
        // in JS, using a class as a type won't include the class in
        // the output since types are not chcked in JS.  It is when
        // the actual class is referenced that it will be included
        // in the output.
        // Is there a reason to use reflection to gather the set
        // of tests?  I would think an array of tests would wokr
        // better and allow you to define order.
        public var strandTesterTest:StrandTesterTest;
        public var binaryDataTesterTest:BinaryDataTesterTest;
        public var md5Test:MD5Test;
    
        public var arrayTest:ArrayTesterTest;
    }
}
