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

import org.xml.sax.Attributes;

/** 
 * AssertPropertyValue
 *
 * Assert if a property is set to the right value
 */
public class AssertPropertyValue extends AssertStep { 


	public AssertPropertyValue () { 
	}
	
	/**
	 *  The name of the property to test
	 */
	public String propertyName;
	
	/**
	 *  The value the property should have
	 */
	public String value;

	/**
	 *  The value the property should have
	 */
	public String valueExpression;
	
	@Override
	public void populateFromAttributes(Attributes attributes)
	{
		target = attributes.getValue("target");
		propertyName = attributes.getValue("propertyName");
		value = attributes.getValue("value");
		valueExpression = attributes.getValue("valueExpression");
	}
	
	@Override
    protected void doStep()
    {
		
		StringBuilder getScript = new StringBuilder();
		insertTargetScript(getScript, target);
		getScript.append("if (typeof(target['get_' + '" + propertyName + "']) == 'function') return target['get_' + '" + propertyName + "']();");
		getScript.append(" else return target['" + propertyName + "'];");
		if (TestStep.showScripts)
			System.out.println(getScript.toString());
		String actualValue = ((JavascriptExecutor)webDriver).executeScript(getScript.toString()).toString();
		String valueString = null;
		if (valueExpression != null)
			valueString = ((JavascriptExecutor)webDriver).executeScript(valueExpression).toString();
		else if (value != null)
			valueString = value;
		else
			valueString = "null";
			
		if (!valueString.equals(actualValue))
		{
			testResult.doFail(target + "." + propertyName + " " + actualValue + " != " + valueString);	
		}
				
    }
	
    /**
     *  customize string representation
     */
	@Override
    public String toString()
    {
		String s = "AssertPropertyValue";
		if (target != null)
			s += ": target = " + target.toString();
		if (propertyName != null)
			s += ": propertyName = " + propertyName.toString();
		if (value != null)
			s += ": value = " + value;
		return s;
	}
	
}
