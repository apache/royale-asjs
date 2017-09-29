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

import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import org.xml.sax.Attributes;

/** 
 * DispatchMouseClickEvent
 *
 * Dispatch click to the element under the mouse
 */
public class DispatchMouseClickEvent extends TestStep { 

    /**
     *  Dispatch click event
     */
	@Override
    protected void doStep()
    {
		
		Long x;
		Long y;
		if (hasLocal)
		{
			StringBuilder script = new StringBuilder();
			insertTargetScript(script, target);
			script.append("return target.element.offsetLeft");
			if (TestStep.showScripts)
				System.out.println(script);
			x = (Long)((JavascriptExecutor)webDriver).executeScript(script.toString());
			script = new StringBuilder();
			insertTargetScript(script, target);
			script.append("return target.element.offsetTop");
			if (TestStep.showScripts)
				System.out.println(script);
			y = (Long)((JavascriptExecutor)webDriver).executeScript(script.toString());
			x += localX;
			y += localY;
		}
		else
		{
			x = stageX;
			y = stageY;
		}
		
		// find top-most element
		StringBuilder script = new StringBuilder();
		script.append("var all = document.all;");
		script.append("var n = all.length;");
		script.append("for(var i=n-1;i>=0;i--) { ");
		script.append("    var e = all[i];");
		script.append("     if (" + x + " >= e.offsetLeft && " + x + " <= e.offsetLeft + e.offsetWidth && " + y + " >= e.offsetTop && " + y + " <= e.offsetTop + e.offsetHeight)");
		script.append("         return e;");
		script.append("};");
		script.append("return null;");
		if (TestStep.showScripts)
			System.out.println(script);
		WebElement mouseTarget = (WebElement)((JavascriptExecutor)webDriver).executeScript(script.toString());
        try
        {
			mouseTarget.click();
            Thread.sleep(2000);
        }
        catch (Exception e1)
        {
            TestOutput.logResult("Exception thrown in DispatchMouseClickEvent.");
            testResult.doFail (e1.getMessage()); 
        }
		
    }
	
	/**
	 *  The object that should receive the mouse event
	 */
	public String target;
	
	/**
	 *  The ctrlKey property on the MouseEvent (optional)
	 */
	public boolean ctrlKey;
	
	/**
	 *  The delta property on the MouseEvent (optional)
	 */
	public int delta;
	
	private boolean hasLocal;
	private boolean hasStage;
	
	/**
	 *  The localX property on the MouseEvent (optional)
	 *  Either set stageX/stageY or localX/localY, but not both.
	 */
	public long localX;
	
	/**
	 *  The localY property on the MouseEvent (optional)
	 *  Either set stageX/stageY or localX/localY, but not both.
	 */
	public long localY;
	
	/**
	 *  The stageX property on the MouseEvent (optional)
	 *  Either set stageX/stageY or localX/localY, but not both.
	 */
	public long stageX;
	
	/**
	 *  The stageY property on the MouseEvent (optional)
	 *  Either set stageX/stageY or localX/localY, but not both.
	 */
	public long stageY;
	
	/**
	 *  The shiftKey property on the MouseEvent (optional)
	 */
	public boolean shiftKey;
	
	/**
	 *  The relatedObject property on the MouseEvent (optional)
	 */
	public String relatedObject;
	
	/**
	 *  customize string representation
	 */
	@Override 
	public String toString()
	{
		String s = "DispatchMouseClickEvent: target = ";
		s += target;
		if (hasLocal)
		{
			s += ", localX = " + Long.toString(localX);
			s += ", localY = " + Long.toString(localY);
		}
		if (hasStage)
		{
			s += ", stageX = " + Long.toString(stageX);
			s += ", stageY = " + Long.toString(stageY);
		}
		if (shiftKey)
			s += ", shiftKey = true";
		if (ctrlKey)
			s += ", ctrlKey = true";
		
		if (relatedObject != null)
			s += ", relatedObject = " + relatedObject;
		if (delta != 0)
			s += ", delta = " + Integer.toString(delta);
		return s;
	}
	
	@Override
	public void populateFromAttributes(Attributes attributes)
	{
		target = attributes.getValue("target");
		String value = attributes.getValue("localX");
		if (value != null)
		{
			localX = Long.parseLong(value);
			hasLocal = true;
		}
		value = attributes.getValue("localY");
		if (value != null)
		{
			localY = Long.parseLong(value);
			hasLocal = true;
		}
		value = attributes.getValue("stageX");
		if (value != null)
		{
			stageX = Long.parseLong(value);
			hasStage = true;
		}
		value = attributes.getValue("stageY");
		if (value != null)
		{
			stageY = Long.parseLong(value);
			hasStage = true;
		}
	}

}
