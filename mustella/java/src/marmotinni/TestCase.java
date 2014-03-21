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

import java.util.List;
import java.util.ArrayList;
import java.util.Date;

import org.openqa.selenium.WebDriver;

import org.xml.sax.Attributes;

/** 
 * TestCase
 *
 * A set of TestSteps.
 */
public class TestCase { 

	public static boolean showSteps = false;
	
	/**
	 *  The history of bugs that this test case has encountered
	 */
	public List<String> bugs;
	
	/**
	 *  The sequence of TestSteps that comprise the test setup
	 */
	public List<TestStep> setup;
	
	/**
	 *  The sequence of TestSteps that comprise the test
	 */
	public List<TestStep> body;
	
	/**
	 *  The sequence of TestSteps that restore the test environment
	 */
	public List<TestStep> cleanup;
	
	/**
	 *  An identifier for the test
	 */
	public String testID;
	
	/**
	 *  A description of the test 
	 */
	public String description;
	
	/**
	 *  keywords, summarizing the tests
	 */
	public String keywords;
	
	/**
	 *  frequency, an estimate of the tests's intersection with real-world
	 *  usage. 1 = most frequent usage; 2 somewhat common; 3 = unusual
	 */
	public String frequency;
	
	/**
	 *  The current set of steps (setup, body, cleanup) we are executing
	 */
	private List<TestStep> currentSteps;
	
	/**
	 *  Which step we're currently executing (or waiting on an event for)
	 */
	private int currentIndex = 0;
	
	/**
	 *  Number of steps in currentSteps
	 */
	private int numSteps = 0;
	
	/**
	 *  Storage for the cleanupAsserts
	 */
	private List<AssertStep> cleanupAsserts;
	
	/**
	 *  Steps we have to review at the end of the body to see if
	 *  they failed or not.  These steps monitor activity like
	 *  checking for duplicate events or making sure unwanted events
	 *  don't fire.
	 */
	public List<AssertStep> getCleanupAsserts()
	{
		return cleanupAsserts;
	}
	
	/**
	 *  Storage for this tests's result
	 */
	private TestResult testResult;
	
	/**
	 *  This tests's result
	 */
	public TestResult getTestResult() 
	{ 
		testResult.testID = testID;
		return testResult;
	}
	
	/**
	 * Constructor. Create the TestResult associated with this TestCase
	 */
	public TestCase() {
		
		testResult = new TestResult();
		testResult.testID = testID;
		
		cleanupAsserts = new ArrayList<AssertStep>();
	}
	
	/**
	 *  Called when it is time to execute
	 *  this test case.
	 *
	 */
	public boolean runTest(WebDriver webDriver)
	{
		testResult.beginTime = new Date().getTime();
						
		return runSetup(webDriver);
	}
	
	/**
	 *  Execute the setup portion of the test
	 */
	private boolean runSetup(WebDriver webDriver)
	{
		if (!testResult.hasStatus()) 
		{ 
			if (setup != null)
			{
				testResult.phase = TestResult.SETUP;
				currentIndex = 0;
				currentSteps = setup;
				numSteps = setup.size();
				// return if we need to wait for something
				if (!runSteps(webDriver))
					return false;
				
			}
		}
		return runBody(webDriver);
	}
	
	/**
	 *  Execute the body portion of the test
	 */
	private boolean runBody(WebDriver webDriver)
	{
		if (!testResult.hasStatus()) 
		{ 
			if (body != null)
			{
				testResult.phase = TestResult.BODY;
				currentIndex = 0;
				currentSteps = body;
				numSteps = body.size();
				// return if we need to wait for something
				if (!runSteps(webDriver))
					return false;
				
			}
		}
		return runCleanup(webDriver);
	}
	
	/**
	 *  Execute the cleanup portion of the test
	 */
	private boolean runCleanup(WebDriver webDriver)
	{
		if (!testResult.hasStatus()) 
		{ 
			if (cleanup != null)
			{
				testResult.phase = TestResult.CLEANUP;
				currentIndex = 0;
				currentSteps = cleanup;
				numSteps = cleanup.size();
				// return if we need to wait for something
				if (!runSteps(webDriver))
					return false;
				
			}
		}
		return runComplete();
	}
	
	/**
	 *  Clean up when all three phases are done.  Sends an event
	 *  to the UnitTester harness to tell it that it can run
	 *  the next test case.
	 */
	private boolean runComplete()
	{
		int n = cleanupAsserts.size();
		for (int i = 0; i < n; i++)
		{
			AssertStep asrt = cleanupAsserts.get(i);
			asrt.cleanup();
		}
		testResult.endTime = new Date().getTime();
		return true;
	}
	
	/**
	 *  Go through the currentSteps, executing each one.
	 *  Returns true if no test steps required waiting.
	 *  Returns false if we have to wait for an event before
	 *  continuing.
	 */
	private boolean runSteps(WebDriver webDriver)
	{
		while (currentIndex < numSteps)
		{
			// return if a step failed
			if (testResult.hasStatus()) 
				return true;
			
			TestStep step = currentSteps.get(currentIndex);
			if (!(step instanceof AssertStep))
			{
				// look at subsequent steps for Asserts and set them up early
				for (int j = currentIndex + 1; j < numSteps; j++)
				{
					// scan following asserts for AssertEvents and set them up early
					TestStep nextStep = currentSteps.get(j);
					if (nextStep instanceof AssertStep)
					{
						((AssertStep)nextStep).preview(webDriver, this, testResult);
						/* TODO: (aharui) re-enable when we need these asserts
						// do a check to be sure folks are using AssertEventPropertyValue correctly
						if (nextStep instanceof AssertEventPropertyValue)
						{
							// AEPV must follow an AssertEvent or another AEPV
							if (j == 0 || !(currentSteps[j-1] instanceof AssertEvent || currentSteps[j-1] instanceof AssertEventPropertyValue))
								TestOutput.logResult("WARNING: AssertEventPropertyValue may be missing preceding AssertEvent");
						}
						else if (nextStep instanceof AssertError)
						{
							if (step instanceof SetProperty)
								SetProperty(step).expectError = true;
						}
						*/
					}
					else
						break;
				}
			}
			if (TestCase.showSteps)
				System.out.println(step.toString());
			step.execute(webDriver, this, testResult);
			currentIndex++;
		}
		return true;
	}
				
	public void populateFromAttributes(Attributes attributes)
	{
		description = attributes.getValue("description");
		testID = attributes.getValue("testID");
		keywords = attributes.getValue("keywords");
		frequency = attributes.getValue("frequency");
		
	}
	
}
