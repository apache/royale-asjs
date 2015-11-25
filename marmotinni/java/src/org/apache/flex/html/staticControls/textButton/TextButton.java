/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

package org.apache.flex.html.textButton;

import java.util.HashMap;
import java.util.Map;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;

public class TextButton
{
    protected static String FAILED = "failed";
    protected static String SUCCESS = "success";

    public static void main(String[] args)
    {
        WebDriver driver = new FirefoxDriver();

        Map<String, String> argsMap = new HashMap<String, String>();
        for (String arg : args)
        {
            String[] keyValuePair = arg.split("=");
            argsMap.put(keyValuePair[0], keyValuePair[1]);
        }
        
        final String url = argsMap.get("url");
        
        driver.get(url);

        WebElement element = driver.findElement(By.tagName("button"));

        try
        {
            // there is a button in the DOM
            if (element != null)
            {
                // the button x position is 100
                if (element.getCssValue("left").equals("100px"))
                    System.out.println(SUCCESS);
                else
                    System.out.println(FAILED);
            }
            else
            {
                System.out.println(FAILED);
            }
        }
        catch (Exception e)
        {
            System.out.println(e.getMessage());
        }
        finally
        {
            driver.quit();
        }
    }

}
