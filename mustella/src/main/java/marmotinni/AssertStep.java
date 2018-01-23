/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */


package marmotinni;

import org.openqa.selenium.WebDriver;

/** 
 * AssertStep
 *
 * Base class for test steps like AssertPropertyValue, etc.
 */
public class AssertStep extends TestStep { 


	public AssertStep () { 
	}

	/**
	 *  Called by the test case in case you need to set up before execute()
	 */
	public void preview(WebDriver webDriver, TestCase testCase, TestResult testResult)
	{
		this.webDriver = webDriver;
		this.testCase = testCase;
		this.testResult = testResult;
	}
	
	public String target;
	
	/**
	 *  Called by the test case in case you need to clean up after execute()
	 */
	public void cleanup()
	{
	}
}
