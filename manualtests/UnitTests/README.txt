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

DESCRIPTION

The UnitTests application is a very basic form of unit testing primarily
intended for FlexJS framework developers. It is a 'lite' version of a small portion of 
Flexunit code to support basic assertion tests.

This Flex application may be run as a Flash SWF or cross-compiled (using Falcon JX)
into JavaScript and HTML and run without Flash.

There is a convenience html page inside the top level testsview directory for hosting the tests side-by-side 
that permits developers to refresh the test builds simultaneously and compare results in the browser, including the 
ability to toggle between JS-Debug and JS-Release builds.
While this is primarily intended for framework developers, it may be useful as a starting point
for cross-compiled unit testing (during development only) in regular FlexJS projects.

FRAMEWORK DEVELOPER NOTES
To add new tests, follow the examples inside the flexUnitTests package, and add any new Test
group or category level class (the classes directly inside flexUnitTests package) into the top 
level TestClasses.as file. This should be all that is necessary to add new tests.

MetaData
[BeforeClass] -same as flexunit (typical: 'setupBeforClass')- runs a static method before the test class is instantiated
[AfterClass] -same as flexunit (typical: 'tearDownAfterClass')- runs a static method after the test class has been processed
[Before] -same as flexunit (typical: 'setup') - runs an instance method before the test class' test methods are processed
[After] -same as flexunit (typical: 'tearDown') - runs an instance method after the test class' test methods are processed
[Test] -same as flexunit (typical: 'testXXXX') - denotes a test method. No assumption about order of test methods being called should be made

[TestVariance(variance="JS",description="Reason for variation in JS expected results")]
The above is specific to this test app, and permits annotation of test methods where the expected results are different between compiler targets.
The variance key in the meta data should be either "SWF" or "JS". This is the compiler target with the result that is considered to be different
to what it ideally 'should be', but correct as per the current implementation of the framework. Usually this will be "JS". It indicates a known
but currently acceptable difference between compiler targets.


GENERAL NOTES

In its first working version this app only supports synchronous simple assertions and 
is intended to use test classes that are compatible with the flexunit tests that are 
used in the full framework build. Future versions may include more advanced features.

The cross-compilation to JavaScript often results in non-fatal warnings. Some of these warnings
should be addressed in future releases of the Falcon JX compiler.
