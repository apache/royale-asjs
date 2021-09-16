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

package mx.events
{
COMPILE::SWF
{
import flash.events.KeyboardEvent;  
}
/* import mx.events.Event;*/
import org.apache.royale.events.Event;
import org.apache.royale.events.IRoyaleEvent;

/**
 // *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 *  @royalesuppresspublicvarwarning
 */
COMPILE::SWF
public class KeyboardEvent extends flash.events.KeyboardEvent
{

	public function KeyboardEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false, 
	charCodeValue:uint = 0, keyCodeValue:uint = 0, keyLocationValue:uint = 0, 
	ctrlKeyValue:Boolean = false, altKeyValue:Boolean = false, 
	shiftKeyValue:Boolean = false, 
	controlKeyValue:Boolean = false, commandKeyValue:Boolean = false)
    {
        super(type, bubbles, cancelable);
		charCode = charCodeValue;
		keyCode = keyCodeValue;
		//,keyLocationValue,
		ctrlKey = ctrlKeyValue;
		altKey = altKeyValue;
		shiftKey = shiftKeyValue;
		//,controlKeyValue,commandKeyValue);
    }
	
	
	public static const KEY_DOWN:String = platformConstant1("keyDown");
	public static const HOME:uint = platformConstant(36); 
	public static const BACKSPACE:uint = platformConstant(8);
	public static const LEFT:uint = platformConstant(37);
	public static const RIGHT:uint = platformConstant(39);
	public static const DELETE:uint = platformConstant(46);
	public static const END:uint = platformConstant(35);
	public static const KEY_UP:String = platformConstant1("keyUp");
		
    public function get key():String
    {
        return String.fromCharCode(charCode);
    }
    
	private static function platformConstant(s:uint):uint
        {
            return s;
        }
    private static function platformConstant1(s:String):String
        {
            return s;
        }
    public static function get capsLock():Boolean
	{
	    return true;
	}
}

/**
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 *  @royalesuppresspublicvarwarning
 */
COMPILE::JS
public class KeyboardEvent extends org.apache.royale.events.KeyboardEvent
{
	
		
		public function get keyCode():uint
		{
		    return nativeEvent["keyCode"];
		}
		
		public function set keyCode(val:uint):void
		{
		}
		 public function get KEY_DOWN():String
		{
		return "keyDown";
		}
		
		public function set KEY_DOWN(val:String):void
		{
		} 
		
		
		 private static function platformConstant(s:uint):uint
        	{
            	return s;
       	 	}
		 private static function platformConstant1(s:String):String
        	{
            	return s.toLowerCase();
        	}
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	public static const HOME:uint = platformConstant(36); 
	public static const BACKSPACE:uint = platformConstant(8);
	public static const LEFT:uint = platformConstant(37);
	public static const RIGHT:uint = platformConstant(39);
	public static const DELETE:uint = platformConstant(46);
	public static const END:uint = platformConstant(35);
    // in emulation leave these as mixed case as in Flash because lots of
    // people (and MXML output) may have used the string and not the constant
    // so we'll see if we can send the mixed case name.
	public static const KEY_DOWN:String = "keyDown";
	public static const KEY_UP:String = "keyUp";
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param type The event type; indicates the action that caused the event.
	 *
	 *  @param bubbles Specifies whether the event can bubble
	 *  up the display list hierarchy.
	 *
	 *  @param cancelable Specifies whether the behavior
	 *  associated with the event can be prevented.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public function KeyboardEvent(
            type:String,
            key:String,
            code:String,
            shiftKey:Boolean=false,
            altKey:Boolean=false,
            ctrlKey:Boolean=false,
            metaKey:Boolean=false,
            bubbles:Boolean = false, cancelable:Boolean = false)
							  
	{
		super(type, key,code,shiftKey,altKey,ctrlKey,metaKey,bubbles,cancelable);
	}
	
	
	public function get charCode():uint
	{
		if (code == "Enter")
			return 13;
		return code.charCodeAt();
	}
	
	public var _keyLocationVal:uint = 0;
	public function get keyLocation():uint {
		return _keyLocationVal;
	}
    public function set keyLocation(value:uint):void {
		_keyLocationVal = value;
	}
}

}
