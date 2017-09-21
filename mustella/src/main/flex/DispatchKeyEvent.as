////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package {
COMPILE::SWF
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.TextEvent;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.ui.Keyboard;
}

/**
 *  The test step that fakes a keyboard event
 *  MXML attributes:
 *  type (optional)
 *  charCode
 *  ctrlKey (optional)
 *  keyCode (optional)
 *  keyLocation (optional)
 *  shiftKey (optional)
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout (optional);
 *  cancelable (optional)
 */


public class DispatchKeyEvent extends TestStep
{
	// These are constants from flash.ui.Keyboard.  They are not
	// available in non-AIR compilations, so they are reproduced here
	// to avoid compile errors.
	// If they change in AIR, these will need to be updated.
	public static const FLASH_UI_KEYBOARD_BACK:uint = 0x01000016;
	public static const FLASH_UI_KEYBOARD_MENU:uint = 0x01000012;
	public static const FLASH_UI_KEYBOARD_SEARCH:uint = 0x0100001F;
	
    private var inDispatchKey:Boolean;
    private var gotFocusIn:Boolean;
    private var charSequence:Array;
    private var keySequence:Array;
    private var currentRepeat:int;
    private var currentKey:int;
    private var sendBoth:Boolean;
    
    /**
     *  Set the target's property to the specified value
     */
    COMPILE::SWF
    override protected function doStep():void
    {
        UnitTester.blockFocusEvents = false;

        sendBoth = false;

        if (!type)
        {
            sendBoth = true;
            type = "keyDown";
        }
        
        var i:int;
        var n:int;
        charSequence = new Array();
        keySequence = new Array();
		
		
        if (charCode)
        {
            charSequence.push(charCode);
            keySequence.push(keyCode ? keyCode : CharCodeToKeyCode[charCode] ? CharCodeToKeyCode[charCode] : charCode);
        }
        else if (keyCode)
        {
            charSequence.push(KeyCodeToCharCode[keyCode] ? KeyCodeToCharCode[keyCode] : 0);
            keySequence.push(keyCode);
        }
        else if (char)
        {
            n = char.length;
            for (i = 0; i < n; i++)
            {
                var c:uint = char.charCodeAt(i) 
                charSequence.push(c);
                keySequence.push(CharCodeToKeyCode[c]);
            }
        }
        else if (key || keys)
        {
            var sequence:Array;
            if (key)
                sequence = [ key ];
            else
                sequence = keys;
            n = sequence.length;
            for (i = 0; i < n; i++)
            {
                var kc:uint = Keyboard[sequence[i]];
                if (kc == 0)
                {
                    testResult.doFail(key + " is not a valid flash.ui.Keyboard constant");
                    UnitTester.blockFocusEvents = true;
                    return;
                }
                keySequence.push(kc);
                charSequence.push(KeyCodeToCharCode[kc] ? KeyCodeToCharCode[kc] : 0);
            }
        }
        else
        {
            testResult.doFail("no keys specified");
            UnitTester.blockFocusEvents = true;
            return;
        }
		
        try
        {
            for (i = 0; i < repeatCount; i++)
            {
                var m:int = charSequence.length;
                for (var j:int = 0; j < m; j++)
                {
                    var event:KeyboardEvent = new KeyboardEvent(type, true, cancelable); // all keyboard events bubble
                    event.ctrlKey = ctrlKey;
                    event.shiftKey = shiftKey;
                    event.charCode = charSequence[j];
                    event.keyCode = keySequence[j];
                    event.keyLocation = keyLocation;

                    if (keySequence[j] == Keyboard.TAB)
                    {
                        // if we don't see a focusIn, focus is being set
                        // asynchronously so we need to wait.
                        currentRepeat = i;
                        currentKey = j;
                        gotFocusIn = false;
                        root.addEventListener("focusIn", focusInHandler);
                        inDispatchKey = true;
                        dispatchKey(j, event);
                        inDispatchKey = false;
                        if (!gotFocusIn)
                            break;
                    }
                    else
                        dispatchKey(j, event);
                }
            }
        }
        catch (e1:Error)
        {
            TestOutput.logResult("Exception thrown in DispatchKeyEvent.");
            testResult.doFail (e1.getStackTrace()); 
        }

        UnitTester.blockFocusEvents = true;
    }

    /**

     *  (Optional) name of a UI object whose Window/Stage

     *  will be used to dispatch the event

     */

    public var window:String;



    /**
     *  The type of the event to send (keyUp, keyDown, etc).
     *  If not set, we'll send both a keyDown and a keyUp
     */
    public var type:String;

    /**
     *  The char or sequence of chars to send as a string/char if you don't know the charCode (optional)
     */
    public var char:String;

    /**
     *  The charCode property on the KeyboardEvent (optional)
     */
    public var charCode:uint;

    /**
     *  The ctrlKey property on the KeyboardEvent (optional)
     */
    public var ctrlKey:Boolean;

    /**
     *  The Keyboard key if you don't know the keyCode (optional)
     */
    public var key:String;

    /**
     *  The sequence of keys (optional) e.g ["LEFT", "UP"]
     */
    public var keys:Array;

    /**
     *  The keyCode property on the KeyboardEvent (optional)
     */
    public var keyCode:uint;

    /**
     *  The keyLocation property on the KeyboardEvent (optional)
     */
    public var keyLocation:uint;

    /**
     *  The number of times to repeat the sequence (optional)
     */
    public var repeatCount:uint = 1;

    /**
     *  The shiftKey property on the KeyboardEvent (optional)
     */
    public var shiftKey:Boolean;

    /**
     *  Designate the created event to be cancelable. by default, they are not
     */
    public var cancelable:Boolean = false;

    /**
     *  The FlashPlayer TextField doesn't actually handle keyboard events so we have to
     *  emulate them
     */
    COMPILE::SWF
    private function emulateKey(actualTarget:Object, event:KeyboardEvent):void
    {
        var begin:int = actualTarget.selectionBeginIndex;
        var end:int = actualTarget.selectionEndIndex;
        var caret:int = actualTarget.caretIndex;
        // trace("begin =", begin, "end =", end, "caret =", caret);

        if (event.keyCode == Keyboard.LEFT)
        {
            if (event.shiftKey)
            {
                if (caret > 0)
                {
                    if (caret == begin)
                    {
                        begin--;
                        // last param defines caret position
                        actualTarget.setSelection(end, begin);
                    }
                    else if (caret == end)
                    {
                        end--;
                        if (end < begin)
                            begin = end;
			            actualTarget.setSelection(end, begin);

                    }
                }
            }
            else
            {
                if (begin != end)
                    actualTarget.setSelection(begin, begin);

               else if (caret > 0)
                    actualTarget.setSelection(caret - 1, caret - 1);
            }
        }
        else if (event.keyCode == Keyboard.RIGHT)
        {
            if (event.shiftKey)
            {
                if (caret < actualTarget.length)
                {
                    if (caret == end)
                    {
                        end++;
                        actualTarget.setSelection(begin, end);

                    }
                    else if (caret == begin)
                    {
                        begin++;
                        if (end < begin)
                            end = begin;
                        // last param defines caret position
                        actualTarget.setSelection(end, begin);

                    }
                }
            }
            else
            {
                if (begin != end)
                    actualTarget.setSelection(end, end); 

               else if (caret > 0)
                    actualTarget.setSelection(caret + 1, caret + 1);
            }
        }
    }

    COMPILE::SWF
    private function focusInHandler(focusEvent:Event):void
    {
        gotFocusIn = true;        
        root.removeEventListener("focusIn", focusInHandler);
        if (inDispatchKey)
            return;
        
        for (var i:int = currentRepeat; i < repeatCount; i++)
        {
            var m:int = charSequence.length;
            for (var j:int = currentKey + 1; j < m; j++)
            {
                var event:KeyboardEvent = new KeyboardEvent(type, true, cancelable); // all keyboard events bubble
                event.ctrlKey = ctrlKey;
                event.shiftKey = shiftKey;
                event.charCode = charSequence[j];
                event.keyCode = keySequence[j];
                event.keyLocation = keyLocation;
                
                if (keySequence[j] == Keyboard.TAB)
                {
                    currentRepeat = i;
                    currentKey = j;
                    gotFocusIn = false;
                    root.addEventListener("focusIn", focusInHandler);
                    inDispatchKey = true;
                    dispatchKey(j, event);
                    inDispatchKey = false;
                    if (!gotFocusIn)
                        break;
                }                
                else
                    dispatchKey(j, event);
            }
        }
    }
    
    COMPILE::SWF
    private function dispatchKey(index:int, event:KeyboardEvent):void
    {
        // note that we don't check Window activation since we want to run in the background
        // and window activation is a player function
        
        var actualTarget:Object;
        
        if (window)
        {
            actualTarget = context.stringToObject(window);
            actualTarget = actualTarget.stage.focus;
        }
        else
        {
            actualTarget = root.stage.focus;
            if (!actualTarget)
            {
                actualTarget = UnitTester.getFocus();
            }
        }
        
        // BACK, MENU, and SEARCH are buttons on mobile (Android) devices.  
        // On Android devices right now, actualTarget is still null at this point.  Dispatching the event to the stage works.
        // Using the constants in flash.ui.Keyboard will cause an error in a non-AIR runs, so the constants are also defined
        // in this file, above.  There is risk here.
        if (keySequence[index] == FLASH_UI_KEYBOARD_BACK ||
            keySequence[index] == FLASH_UI_KEYBOARD_MENU ||
            keySequence[index] == FLASH_UI_KEYBOARD_SEARCH){
            
            actualTarget = root.stage;
        }
        
        if (actualTarget)
        {
            var targetType:TypeInfo = context.getTypeInfo(actualTarget);
            var isTextView:Boolean = targetType.isAssignableTo("spark.components::RichEditableText");
            
            
            if (actualTarget is TextField)
            {
                if (event.charCode)
                {
                    if (actualTarget.type == "input")
                    {
                        actualTarget.replaceSelectedText(String.fromCharCode(event.charCode));
                        // actualTarget.dispatchEvent(new Event("change", true));
                        actualTarget.dispatchEvent(new Event("change"));
                    }
                }
                else
                {
                    if (actualTarget.selectable)
                        emulateKey(actualTarget, event);
                }
            }
            
            actualTarget.dispatchEvent(event);
            
            
            
            if (isTextView)
            {
                if (event.keyCode == Keyboard.DELETE ||
                    
                    event.keyCode == Keyboard.BACKSPACE ||
                    
                    event.keyCode == Keyboard.INSERT ||
                    
                    ctrlKey)
                    
                {
                    
                    // don't send TEXT_INPUT event
                    
                }
                    
                else
                    
                {
                    
                    var textEvent:TextEvent = new TextEvent(TextEvent.TEXT_INPUT, true, true);
                    
                    textEvent.text = String.fromCharCode(charSequence[index]);
                    
                    actualTarget.dispatchEvent(textEvent);
                    
                }
                
            }
            
            if (keySequence[index] == Keyboard.TAB && type == "keyDown")
            {
                var fm:Object;
                var newTarget:Object = actualTarget;
                while (!fm && newTarget)
                {   
                    if ("focusManager" in newTarget)
                        fm = newTarget["focusManager"];
                    newTarget = newTarget.parent;
                }
                newTarget = null;
                if (fm)
                {
                    try
                    {
                        newTarget = fm.getNextFocusManagerComponent(shiftKey);
                    }
                    catch (e:Error)
                    {
                        // ignore error thrown here.  Should only throw if the
                        // current FM became inactive as a result of dispatching
                        // the key event.  We don't really care too much about
                        // getting an accurate newTarget in this case because
                        // newTarget is often wrong since the Player is offering
                        // it up and the Player has that wonky algorithm for
                        // determining newTarget.   In theory, none of our code
                        // truly cares as long as it doesn't point to old focus
                        // object.
                    }
                }
                
                actualTarget.dispatchEvent(new FocusEvent(FocusEvent.KEY_FOCUS_CHANGE, true, true, InteractiveObject(newTarget), shiftKey, Keyboard.TAB));
            }
            
            if (sendBoth)
            {
                event = new KeyboardEvent("keyUp", true, cancelable);
                event.ctrlKey = ctrlKey;
                event.shiftKey = shiftKey;
                event.charCode = charSequence[index];
                event.keyCode = keySequence[index];
                event.keyLocation = keyLocation;
                actualTarget.dispatchEvent(event);
            }
        }
        else
        {
            if (keySequence[index] == Keyboard.TAB && type == "keyDown")
            {
                
                var thisRoot:DisplayObject
                
                // note that we don't check Window activation since we want to run in the background
                // and window activation is a player function
                if (window)
                {
                    thisRoot = context.stringToObject(window).root;
                }
                else
                    thisRoot = root;
                try
                {
                    thisRoot.stage.dispatchEvent(new FocusEvent(FocusEvent.KEY_FOCUS_CHANGE, true, true, InteractiveObject(actualTarget), shiftKey, Keyboard.TAB));
                }
                catch(se2:SecurityError)
                {
                    thisRoot.dispatchEvent(new FocusEvent(FocusEvent.KEY_FOCUS_CHANGE, true, true, InteractiveObject(actualTarget), shiftKey, Keyboard.TAB));
                }
            }						
            
        }
    }
    
    private var KeyCodeToCharCode:Object = {
                    8: 8,
                    13: 13,
                    96: 48,
                    97: 49,
                    98: 50,
                    99: 51,
                    100: 52, 
                    101: 53,
                    102: 54,
                    103: 55,
                    104: 56,
                    105: 57,
                    106: 42,
                    107: 43,
                    109: 45,
                    110: 46,
                    111: 47
    }

    private var CharCodeToKeyCode:Object = {
                    13: 13,
                    33: 49,
                    34: 222,
                    35: 51,
                    36: 52,
                    37: 53,
                    38: 55,
                    39: 222,
                    40: 57,
                    41: 48,
                    42: 56,
                    43: 187,
                    44: 188,
                    45: 189,
                    46: 190,
                    47: 191,
                    48: 48,
                    49: 49,
                    50: 50,
                    51: 51,
                    52: 52,
                    53: 53,
                    54: 54,
                    55: 55,
                    56: 56,
                    57: 57,
                    58: 186,
                    59: 186,
                    60: 188,
                    61: 187,
                    62: 190,
                    63: 191,
                    64: 50,
                    65: 65,
                    66: 66,
                    67: 67,
                    68: 68,
                    69: 69,
                    70: 70,
                    71: 71,
                    72: 72,
                    73: 73,
                    74: 74,
                    75: 75,
                    76: 76,
                    77: 77,
                    78: 78,
                    79: 79,
                    80: 80,
                    81: 81,
                    82: 82,
                    83: 83,
                    84: 84,
                    85: 85,
                    86: 86,
                    87: 87,
                    88: 88,
                    89: 89,
                    90: 90,
                    91: 219,
                    92: 220,
                    93: 221,
                    94: 54,
                    95: 189,
                    96: 192,
                    97: 65,
                    98: 66,
                    99: 67,
                    100: 68,
                    101: 69,
                    102: 70,
                    103: 71,
                    104: 72,
                    105: 73,
                    106: 74,
                    107: 75,
                    108: 76,
                    109: 77,
                    110: 78,
                    111: 79,
                    112: 80,
                    113: 81,
                    114: 82,
                    115: 83,
                    116: 84,
                    117: 85,
                    118: 86,
                    119: 87,
                    120: 88,
                    121: 89,
                    122: 90,
                    123: 219,
                    124: 220,
                    125: 221,
                    126: 192
    }

    /**
     *  customize string representation
     */
    override public function toString():String
    {
        var s:String = "DispatchKeyEvent";
        if (charCode)
            s += ": charCode = " + charCode.toString();
        if (keyCode)
            s += ": keyCode = " + keyCode.toString();
        if (char)
            s += ": char = " + char;
        if (key)
            s += ": key = " + key;
        if (keys)
            s += ": keys = " + keys.toString();
        if (type)
            s += ", type = " + type;
        if (shiftKey)
            s += ", shiftKey = " + shiftKey.toString();
        if (ctrlKey)
            s += ", ctrlKey = " + ctrlKey.toString();
        if (repeatCount)
            s += ", repeatCount = " + repeatCount.toString();
        return s;
    }
}

}
