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
import flash.events.TextEvent;  
}
/* import mx.events.Event;*/
import org.apache.royale.events.Event;
import org.apache.royale.events.IRoyaleEvent;

/**
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 *  @royalesuppresspublicvarwarning
 */
COMPILE::SWF
public class TextEvent extends flash.events.TextEvent
{
	private static function platformConstant(s:String):String
        {
            return s;
        }
		
    public static const TEXT_INPUT : String = platformConstant("textInput"); 
		
	public function TextEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "")
    {
        super(type, bubbles, cancelable);
        this.text = text;
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
public class TextEvent extends org.apache.royale.events.Event
{
   private static function platformConstant(s:String):String
        {
            return s;
        }
		
    public static const TEXT_INPUT : String = platformConstant("textInput"); 
		
		
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	
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
	public function TextEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "")
							  
	{
		super(type, bubbles, cancelable);
		_text = text;
	}
	
	private var _text:String;
	public function get text():String
	{
		return _text;
	}
    public function set text(value:String):void
	{
		_text = value;
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods: Event
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override public function cloneEvent():IRoyaleEvent
	{
		return new TextEvent(type, bubbles, cancelable, _text);
	}
	
}

}
