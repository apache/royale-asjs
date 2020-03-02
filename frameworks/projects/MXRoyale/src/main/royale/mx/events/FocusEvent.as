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
import flash.events.FocusEvent;  
import flash.display.InteractiveObject;      
}
/* import mx.events.Event;*/
COMPILE::JS
{
import goog.events.BrowserEvent;
import org.apache.royale.core.WrappedHTMLElement;
}

import org.apache.royale.events.Event;
import org.apache.royale.events.IRoyaleEvent;

/**
 *  Represents event objects that are dispatched when focus changes.
 *
 *  @see mx.core.UIComponent
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 *  @royalesuppresspublicvarwarning
 */
COMPILE::SWF
public class FocusEvent extends flash.events.FocusEvent
{
    public static const FOCUS_IN:String = "focusIn";
    public static const FOCUS_OUT:String = "focusOut";
	public function FocusEvent(type:String/*, bubbles:Boolean = false,
                              cancelable:Boolean = false ,relatedObject:InteractiveObject = null, shiftKey:Boolean = false, keyCode:uint = 0, direction:String = "none"*/)
    {
        super(type/*, bubbles, cancelable,relatedObject,shiftKey,keyCode,direction*/);
    }
}

/**
 *  Represents event objects that are dispatched when focus changes.
 *
 *  @see mx.core.UIComponent
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 *  @royalesuppresspublicvarwarning
 */
COMPILE::JS
public class FocusEvent extends org.apache.royale.events.Event
{
   /*  include "../core/Version.as"; */
	public static const FOCUS_IN:String = "focusIn";
    public static const FOCUS_OUT:String = "focusOut";
	
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
	public function FocusEvent(type:String, bubbles:Boolean = false,
							  cancelable:Boolean = false ,relatedObject:Object = null, shiftKey:Boolean = false, keyCode:uint = 0, direction:String = "none")
							  
	{
		super(type, bubbles, cancelable);
		_relatedObject = relatedObject;
	}
	
	private var _relatedObject:Object;
	
    /**
     * @type {?goog.events.FocusEvent}
     */
    private var wrappedEvent:Object;
    
    /**
     * @type {FocusEvent}
     */
    private var nativeEvent:Object;
    
    public function wrapEvent(event:Object):void
    {
        //wrappedEvent = event;
        nativeEvent = event; //.getBrowserEvent();
    }
    
    /**
     * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
     */
	public function get relatedObject():Object
	{
		if (nativeEvent && nativeEvent["relatedTarget"])
		{
			return (nativeEvent["relatedTarget"] as WrappedHTMLElement).royale_wrapper;
		}
			
		return _relatedObject;
	}

	
}

}
