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
package org.apache.royale.test.runners
{
	/**
	 * @private
	 * Metadata used by tests.
	 */
	internal class TestMetadata
	{
		/**
		 * Indicates that a method is a test.
		 */
		public static const TEST:String = "Test";

		/**
		 * Indicates that a <code>[Test]</code> method should be skipped.
		 */
		public static const IGNORE:String = "Ignore";

		/**
		 * Indicates that a method runs before every <code>[Test]</code> method.
		 */
		public static const BEFORE:String = "Before";
		
		/**
		 * Indicates that a method runs after every <code>[Test]</code> method.
		 */
		public static const AFTER:String = "After";
		
		/**
		 * Indicates that a method should be run once before all
		 * <code>[Test]</code> methods in the class.
		 */
		public static const BEFORE_CLASS:String = "BeforeClass";
		
		/**
		 * Indicates that a method should be run once after all
		 * <code>[Test]</code> methods in the class.
		 */
		public static const AFTER_CLASS:String = "AfterClass";

		/**
		 * Indicates which <code>ITestRunner</code> should be used to run the
		 * tests in the class.
		 * 
		 * <pre><code>[RunWith("org.apache.test.runners.SuiteRunner")]</code></pre>
		 */
		public static const RUN_WITH:String = "RunWith";
	}
}