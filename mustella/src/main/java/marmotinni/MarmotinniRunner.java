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
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxProfile;
import org.openqa.selenium.firefox.internal.ProfilesIni;

import java.io.IOException;
import java.nio.CharBuffer;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;


/** 
 * TestEngine
 *
 * Runs a mustella script by parsing it and executing its contents
 *
 */
public class MarmotinniRunner extends DefaultHandler { 

	public MarmotinniRunner () { 
	}

	public boolean runTest(WebDriver webDriver, String scriptName)
	{
		if (tagMap == null)
			setupMap();
		tests = new ArrayList<TestCase>();
		
		System.out.println("running script " + scriptName);
		
		SAXParserFactory spf = SAXParserFactory.newInstance();
		try {
			
			//get a new instance of parser
			SAXParser sp = spf.newSAXParser();
			
			//parse the file and also register this class for call backs
			sp.parse(scriptName, this);
			
		}catch(SAXException se) {
			se.printStackTrace();
		}catch(ParserConfigurationException pce) {
			pce.printStackTrace();
		}catch (IOException ie) {
			ie.printStackTrace();
		}
		boolean success = true;
		System.out.println("test case count: " + tests.size());
		for (TestCase testCase : tests)
		{
			this.testCase = testCase;
			testCase.runTest(webDriver);
			TestResult testResult = testCase.getTestResult();
			testResult.scriptName = scriptName;
			if (!testResult.hasStatus())
				testResult.result = TestResult.PASS;
			else
			{
				System.out.println("test failure");
				success = false;
			}
			System.out.println(testResult.toString());
		}
		return success;
	}

	private HashMap<String, Class<?>> tagMap = null;
	
	private void setupMap()
	{
		tagMap = new HashMap<String, Class<?>>();
		tagMap.put("SetProperty", SetProperty.class);
		tagMap.put("DispatchKeyEvent", DispatchKeyEvent.class);
		tagMap.put("DispatchMouseEvent", DispatchMouseEvent.class);
		tagMap.put("DispatchMouseClickEvent", DispatchMouseClickEvent.class);
		tagMap.put("AssertPropertyValue", AssertPropertyValue.class);
	}
	
	private boolean verboseXMLParsing;
	private ArrayList<TestCase> tests;
	private TestCase testCase;
	private String currentPhase;
	
	//Event Handlers
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		if (verboseXMLParsing)
			System.out.println("StartElement: uri: " + uri + "localName: " + localName + "qName: " + qName);
		if(qName.equalsIgnoreCase("UnitTester")) {
			// this should be the top-level tag, just ignore for now.  Will need to process script subtags later
		}
		else if (qName.length() == 0)
		{
			// there seems to be some empty tags
		}
		else if (qName.equalsIgnoreCase("testCases"))
		{
			// there seems to be some empty tags
		}
		else if (qName.equalsIgnoreCase("mx:Script"))
		{
			// there seems to be some empty tags
		}
		else if (qName.equalsIgnoreCase("mx:Metadata"))
		{
			// there seems to be some empty tags
		}
		else if (qName.equalsIgnoreCase("TestCase")) {
			testCase = new TestCase();
			testCase.populateFromAttributes(attributes);
			tests.add(testCase);
		}
		else if (tagMap.containsKey(qName)) {
			Class<?> c = tagMap.get(qName);
			try {
				TestStep testStep = (TestStep)c.newInstance(); 
				testStep.populateFromAttributes(attributes);
				if (currentPhase.equals("setup"))
					testCase.setup.add(testStep);
				else if (currentPhase.equals("body"))
					testCase.body.add(testStep);
				else
					testCase.cleanup.add(testStep);
			}
			catch (Exception e) {
				System.out.println(e.getMessage());
				return;
			}
		}
		else if (qName.equals("setup")) {
			currentPhase = "setup";
			testCase.setup = new ArrayList<TestStep>();
		}
		else if (qName.equals("body")) {
			currentPhase = "body";
			testCase.body = new ArrayList<TestStep>();
		}
		else if (qName.equals("cleanup")) {
			currentPhase = "cleanup";
			testCase.cleanup = new ArrayList<TestStep>();
		}
		else {
			System.out.println("unexpected element: " + uri + qName);
		}

	}
	
	
	public void characters(char[] ch, int start, int length) throws SAXException {
		CharBuffer cb = CharBuffer.allocate(ch.length);
		cb.put(ch);
		String s = cb.toString();
		if (verboseXMLParsing)
			if (s.trim().length() > 0)
				System.out.println("unexpected characters: " + s);
	}
	
	public void endElement(String uri, String localName, String qName) throws SAXException {
		if (verboseXMLParsing)
			System.out.println("EndElement: uri: " + uri + "localName: " + localName + "qName: " + qName);
	}
	
	public static void main(String[] args)
    {
		ArrayList<String> scripts = new ArrayList<String>();
        Map<String, String> argsMap = new HashMap<String, String>();
        for (String arg : args)
        {
            String[] keyValuePair = arg.split("=");
			if (keyValuePair[0].equals("script"))
				scripts.add(keyValuePair[1]);
			else	
				argsMap.put(keyValuePair[0], keyValuePair[1]);
        }
        final String showScriptsArg = argsMap.get("showScripts");
        TestStep.showScripts = showScriptsArg != null && showScriptsArg.equalsIgnoreCase("true");
        final String showStepsArg = argsMap.get("showSteps");
        TestCase.showSteps = showStepsArg != null && showStepsArg.equalsIgnoreCase("true");
		
        final String url = argsMap.get("url");
		System.out.println(url);
        
		final String browser = argsMap.get("browser");
        WebDriver driver;
		if (browser != null && browser.equalsIgnoreCase("chrome"))
			driver = new ChromeDriver();
		else if (argsMap.containsKey("profile"))
		{
			ProfilesIni profile = new ProfilesIni();
 			FirefoxProfile ffprofile = profile.getProfile(argsMap.get("profile"));
			System.out.println("FireFox Profile: " + argsMap.get("profile"));			
			driver = new FirefoxDriver(ffprofile);
		}
		else
			driver = new FirefoxDriver();
		
        driver.get(url);
		
		int exitCode = 0;
		try 
		{
			MarmotinniRunner mr = new MarmotinniRunner();
			final String verboseXMLParsingArg = argsMap.get("verboseXMLParsing");
			mr.verboseXMLParsing = verboseXMLParsingArg != null && verboseXMLParsingArg.equalsIgnoreCase("true");
			int n = scripts.size();
			for (int i = 0; i < n; i++)
			{
				if (!mr.runTest(driver, scripts.get(i)))
				{
					System.out.println("script failed");
					exitCode = 1;
				}
			}			
		}
		catch (Exception e)
        {
            System.out.println(e.getMessage());
			exitCode = 1;
        }
        finally
        {
            driver.quit();
        }
		System.exit(exitCode);
	}

}
