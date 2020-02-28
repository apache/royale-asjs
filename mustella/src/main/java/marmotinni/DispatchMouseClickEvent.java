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

import org.openqa.selenium.interactions.internal.Coordinates;
import org.openqa.selenium.interactions.HasInputDevices;
import org.openqa.selenium.interactions.Mouse;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.remote.RemoteWebElement;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.StaleElementReferenceException;

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
		
		Double x;
		Double y;
		if (hasLocal)
		{
			StringBuilder script = new StringBuilder();
			insertTargetScript(script, target);
			script.append("return target.element.getBoundingClientRect().left");
			if (TestStep.showScripts)
				System.out.println(script);
            Object any = ((JavascriptExecutor)webDriver).executeScript(script.toString());
            if (any instanceof Long)
                x = ((Long)any).doubleValue();
            else if (any instanceof Double)
                x = (Double)any;
            else
            {
                System.out.println("x is not Long or Double");
                x = 0.0;
            }
			script = new StringBuilder();
			insertTargetScript(script, target);
			script.append("return target.element.getBoundingClientRect().top");
			if (TestStep.showScripts)
				System.out.println(script);
            any = ((JavascriptExecutor)webDriver).executeScript(script.toString());
            if (any instanceof Long)
                y = ((Long)any).doubleValue();
            else if (any instanceof Double)
                y = (Double)any;
            else
            {
                System.out.println("y is not Long or Double");
                y = 0.0;
            }
			x += localX;
			y += localY;
		}
		else
		{
			x = stageX;
			y = stageY;
		}
		TestOutput.logResult("DispatchMouseClickEvent: x = " + x + ", y = " + y);
		// find top-most element
		StringBuilder script = new StringBuilder();
		script.append("var all = document.all;");
		script.append("var n = all.length;");
		script.append("for(var i=n-1;i>=0;i--) { ");
		script.append("    var e = all[i];");
        script.append("    var bounds = e.getBoundingClientRect();");
		script.append("     if (" + x + " >= bounds.left && " + x + " <= bounds.right && " + y + " >= bounds.top && " + y + " <= bounds.bottom) {");
        script.append("         window.marmotinni_mouse_target = e;");
		script.append("         return e;");
        script.append("    }");
		script.append("};");
		script.append("return null;");
		if (TestStep.showScripts)
			System.out.println(script);
		RemoteWebElement mouseTarget = (RemoteWebElement)((JavascriptExecutor)webDriver).executeScript(script.toString());
        if (mouseTarget == null)
            TestOutput.logResult("DispatchMouseClickEvent: mouseTarget = null");
        else
            TestOutput.logResult("DispatchMouseClickEvent: mouseTarget = " + mouseTarget.getTagName() + " " + mouseTarget.getText());
        try
        {
            /*  a way to halt the test in the debugger.  Pick an element and have this code
                wait for the title of some element that doesn't have a title.  This should
                pause the test indefinitely so you can poke around in the debugger then
                from the browser console, set the title to "foo"
            if (target.contains("DataGrid"))
            {
                WebDriverWait wait = new WebDriverWait(webDriver, 1000);
                wait.until(ExpectedConditions.attributeToBe(mouseTarget, "title", "foo"));
            } */
            script = new StringBuilder();
            script.append("var init = { bubbles: true };");
            script.append("init.screenX = ");
            script.append(x.toString());
            script.append(";");
            script.append("init.screenY = ");
            script.append(y.toString());
            script.append(";");
            script.append("window.marmotinni_mouse_target.dispatchEvent(new MouseEvent('mousedown', init));");
            if (TestStep.showScripts)
                System.out.println(script);
            ((JavascriptExecutor)webDriver).executeScript(script.toString());
            script = new StringBuilder();
            script.append("var init = { bubbles: true };");
            script.append("init.screenX = ");
            script.append(x.toString());
            script.append(";");
            script.append("init.screenY = ");
            script.append(y.toString());
            script.append(";");
            script.append("window.marmotinni_mouse_target.dispatchEvent(new MouseEvent('mouseup', init));");
            if (TestStep.showScripts)
                System.out.println(script);
            ((JavascriptExecutor)webDriver).executeScript(script.toString());
            try {
				Thread.sleep(1000);
                mouseTarget.click();
            }
            catch (StaleElementReferenceException sere)
            {
                // eat this if mousedown/up caused the object to go away
            }
            /*
            if (target.contains("DataGrid"))
            {
                WebDriverWait wait = new WebDriverWait(webDriver, 1000);
                wait.until(ExpectedConditions.attributeToBe(mouseTarget, "title", "bar"));
            }
            */
        }
        catch (Exception e1)
        {
            TestOutput.logResult("Exception thrown in DispatchMouseClickEvent.");
            e1.printStackTrace();
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
	public double localX;
	
	/**
	 *  The localY property on the MouseEvent (optional)
	 *  Either set stageX/stageY or localX/localY, but not both.
	 */
	public double localY;
	
	/**
	 *  The stageX property on the MouseEvent (optional)
	 *  Either set stageX/stageY or localX/localY, but not both.
	 */
	public double stageX;
	
	/**
	 *  The stageY property on the MouseEvent (optional)
	 *  Either set stageX/stageY or localX/localY, but not both.
	 */
	public double stageY;
	
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
			s += ", localX = " + Double.toString(localX);
			s += ", localY = " + Double.toString(localY);
		}
		if (hasStage)
		{
			s += ", stageX = " + Double.toString(stageX);
			s += ", stageY = " + Double.toString(stageY);
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
			localX = Double.parseDouble(value);
			hasLocal = true;
		}
		value = attributes.getValue("localY");
		if (value != null)
		{
			localY = Double.parseDouble(value);
			hasLocal = true;
		}
		value = attributes.getValue("stageX");
		if (value != null)
		{
			stageX = Double.parseDouble(value);
			hasStage = true;
		}
		value = attributes.getValue("stageY");
		if (value != null)
		{
			stageY = Double.parseDouble(value);
			hasStage = true;
		}
	}

}
