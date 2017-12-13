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

import java.util.ArrayList;

import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import org.xml.sax.Attributes;

/** 
 * DispatchKeyEvent
 *
 * Dispatch keys to the currently focused element
 */
public class DispatchKeyEvent extends TestStep { 

	public DispatchKeyEvent () { 
	}

	// These are constants from flash.ui.Keyboard.  They are not
	// available in non-AIR compilations, so they are reproduced here
	// to avoid compile errors.
	// If they change in AIR, these will need to be updated.
	public static final int FLASH_UI_KEYBOARD_BACK = 0x01000016;
	public static final int FLASH_UI_KEYBOARD_MENU = 0x01000012;
	public static final int FLASH_UI_KEYBOARD_SEARCH = 0x0100001F;
	
    private StringBuilder charSequence;
    private int currentRepeat;
    private int currentKey;
    private boolean sendBoth;
    
    /**
     *  Set the target's property to the specified value
     */
	@Override
    protected void doStep()
    {
        sendBoth = false;
		
        if (type == null)
        {
            sendBoth = true;
            type = "keyDown";
        }
        
        int i;
        int j;
        int n;
        charSequence = new StringBuilder();
				
        try
        {
			for (i = 0; i < repeatCount; i++)
			{
				WebElement focusedElement = (WebElement)((JavascriptExecutor)webDriver).executeScript("return document.activeElement");
				if (chars != null)
				{
					charSequence.append(chars);
					focusedElement.sendKeys(charSequence);
				}
				else if (keys != null)
				{
					n = keys.size();
					for (j = 0; j < n; i++)
					{
						Keys key = Keys.valueOf(keys.get(j));
						focusedElement.sendKeys(key);
						// could be new focused element if tab or similar
						focusedElement = (WebElement)((JavascriptExecutor)webDriver).executeScript("return document.activeElement");
					}
				}
				else
				{
					testResult.doFail("no keys specified");
					return;
				}
			}
		}
		catch (Exception e1)
		{
			TestOutput.logResult("Exception thrown in DispatchKeyEvent.");
			testResult.doFail (e1.getMessage()); 
		}
		
    }
	
    /**
     *  (Optional) name of a UI object whose Window/Stage
     *  will be used to dispatch the event
     */
    public String window;
	
    /**
     *  The type of the event to send (keyUp, keyDown, etc).
     *  If not set, we'll send both a keyDown and a keyUp
     */
    public String type;
	
    /**
     *  The char or sequence of chars to send as a string/char if you don't know the charCode (optional)
     */
    public String chars;
	
    /**
     *  The ctrlKey property on the KeyboardEvent (optional)
     */
    public boolean ctrlKey;
	
    /**
     *  The sequence of keys (optional) e.g ["LEFT", "UP"]
     */
    public ArrayList<String> keys;
	
    /**
     *  The keyLocation property on the KeyboardEvent (optional)
     */
    public int keyLocation;
	
    /**
     *  The number of times to repeat the sequence (optional)
     */
    public int repeatCount = 1;
	
    /**
     *  The shiftKey property on the KeyboardEvent (optional)
     */
    public boolean shiftKey;
	
    /**
     *  Designate the created event to be cancelable. by default, they are not
     */
    public boolean cancelable = false;
	    
    /**
     *  customize string representation
     */
	@Override
    public String toString()
    {
		String s = "DispatchKeyEvent";
		if (chars != null)
			s += ": char = " + chars;
		if (keys != null)
			s += ": keys = " + keys.toString();
		if (type != null)
			s += ", type = " + type;
		if (shiftKey)
			s += ", shiftKey = true";
		if (ctrlKey)
			s += ", ctrlKey = true";
		if (repeatCount != 0)
			s += ", repeatCount = " + Integer.toString(repeatCount);
		return s;
	}

	@Override
	public void populateFromAttributes(Attributes attributes) throws Exception
	{
		chars = attributes.getValue("char");
		String key = attributes.getValue("key");
		if (key != null)
		{
			keys = new ArrayList<String>();
			keys.add(key);
		}
		String keyAttr = attributes.getValue("keys");
		if (keyAttr != null)
		{
			keys = new ArrayList<String>();
			String keyList[] = keyAttr.split(",");
			for (String keyPart : keyList)
				keys.add(keyPart);
		}
		String keyCode = attributes.getValue("keyCode");
		if (keyCode != null)
			throw new Exception("keyCode not supported");

	}

}
