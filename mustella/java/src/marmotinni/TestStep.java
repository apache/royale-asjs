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

import org.xml.sax.Attributes;

/** 
 * TestStep
 *
 * Base class for test steps like DispatchMouseEvent and AssertPropertyValue, etc.
 */
public class TestStep { 

	public static boolean showScripts = false;

	public TestStep () { 
	}

	public boolean execute(WebDriver webDriver, TestCase testCase, TestResult testResult)
	{
		this.webDriver = webDriver;
		this.testCase = testCase;
		this.testResult = testResult;
				
		doStep();
		
		// if test failed, don't bother waiting, just bail
		if (testResult.hasStatus())
		{
			if (waitEvent != null)
			{
				/* TODO: figure out how to wait */
			}
		}
		
		return true;
	}
	
	/**
	 *  The name of the object to listen for an event we're waiting on
	 */
	public String waitTarget;
	
	/**
	 *  The name of the event to listen for on the waitTarget
	 */
	public String waitEvent;
	
	/**
	 *  The number of milliseconds to wait before giving up
	 */
	public int timeout = 3000;
	
	/**
	 *  The TestResult for this TestCase
	 */
	protected TestResult testResult;
	
	/**
	 *  The TestCase that this step belongs to
	 */
	protected TestCase testCase;

	/**
	 *  The WebDriver for this session
	 */
	protected WebDriver webDriver;
	
	/**
	 *  The method that gets called when it is time to perform the work in the step.
	 */
	protected void doStep()
	{
	}
	
	public void populateFromAttributes(Attributes attributes) throws Exception
	{
		waitTarget = attributes.getValue("waitTarget");
		waitEvent = attributes.getValue("waitEvent");
	}
	
	protected void insertTargetScript(StringBuilder sb, String target)
	{
		sb.append("var target = document.getElementsByTagName('body')[0];");
		sb.append("target = target.flexjs_wrapper;");
		sb.append("target = target.initialView;");
		if (target == null || target.length() == 0)
		{
			return;
		}
		String parts[] = target.split("\\.");
		int n = parts.length;
		for (int i = 0; i < n; i++)
		{
			sb.append("target = target['get_' + '" + parts[i] + "']();");
		}

	}
	
	public String toString()
	{
		return "";
	}
}
