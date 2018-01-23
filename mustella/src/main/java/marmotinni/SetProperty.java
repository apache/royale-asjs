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
 * SetProperty
 *
 * Set a property
 */
public class SetProperty extends TestStep { 

	public SetProperty () { 
	}

    /**
     *  Set the target's property to the specified value
     */
	@Override
    protected void doStep()
    {
		String valueString = null;
		if (valueExpression != null)
			valueString = ((JavascriptExecutor)webDriver).executeScript(valueExpression).toString();
		else if (value != null)
		{
			if (value.equalsIgnoreCase("false") || value.equalsIgnoreCase("true"))
				valueString = value;
			else {				
				try {
					Double.parseDouble(value);
					valueString = value;
				}
				catch (Exception e) {
					valueString = "'" + value + "'";
				}
			}
		}
		else
			valueString = "null";
		
		StringBuilder setScript = new StringBuilder();
		insertTargetScript(setScript, target);
		setScript.append("if (typeof(target['set_' + '" + propertyName + "']) == 'function') target['set_' + '" + propertyName + "'](" + valueString + ");");
		setScript.append(" else target['" + propertyName + "']=" + valueString + ";");
		if (TestStep.showScripts)
			System.out.println(setScript.toString());
		((JavascriptExecutor)webDriver).executeScript(setScript.toString());
    }
	
	/**
	 *  The object to set a property on
	 */
	public String target;
	
	/**
	 *  The name of the property to set
	 */
	public String propertyName;
	
	/**
	 *  The value to set
	 */
	public String value;
	
	/**
	 *  The value to set
	 */
	public String valueExpression;
	
    /**
     *  customize string representation
     */
	@Override
    public String toString()
    {
		String s = "SetProperty";
		if (target != null)
			s += ": target = " + target.toString();
		if (propertyName != null)
			s += ": propertyName = " + propertyName.toString();
		if (value != null)
			s += ": value = " + value;
		return s;
	}

	@Override
	public void populateFromAttributes(Attributes attributes)
	{
		target = attributes.getValue("target");
		propertyName = attributes.getValue("propertyName");
		value = attributes.getValue("value");
		valueExpression = attributes.getValue("valueExpression");
	}

}
