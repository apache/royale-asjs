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
	import org.apache.royale.events.getTargetWrapper;
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

	public var shiftKey:Boolean;
	public var keyCode:uint;
	public var direction:String;

	private var _target:Object;
	private var _relatedObject:Object;

    /**
     * @type {?goog.events.FocusEvent}
     */
    private var wrappedEvent:Object;
    
    /**
     * @type {FocusEvent}
     */
    private var nativeEvent:Object;
    
    public function wrapEvent(event:goog.events.BrowserEvent):void
    {
        wrappedEvent = event;
        nativeEvent = event.getBrowserEvent(); //.getBrowserEvent();
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

	/**
	 *  @copy org.apache.royale.events.BrowserEvent#target
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.9.4
	 */
	override public function get target():Object
	{
		return wrappedEvent ? getTargetWrapper(wrappedEvent.target) : _target;
	}
	override public function set target(value:Object):void
	{
		_target = value;
	}

	/**
	 *  @copy org.apache.royale.events.BrowserEvent#currentTarget
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.9.4
	 */
	override public function get currentTarget():Object
	{
		return wrappedEvent ? getTargetWrapper(wrappedEvent.currentTarget) : _target;
	}
	override public function set currentTarget(value:Object):void
	{
		_target = value;
	}

	// TODO remove this when figure out how to preserve the real target
	// The problem only manifests in SWF, so this alias is good enough for now
	public function get targetBeforeBubbling():Object
	{
		return target;
	}

	/**
	 * Whether the default action has been prevented.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.9.4
	 */
	override public function preventDefault():void
	{
		if(wrappedEvent)
			wrappedEvent.preventDefault();
		else
		{
			super.preventDefault();
			_defaultPrevented = true;
		}
	}

	private var _defaultPrevented:Boolean;
	/**
	 * Whether the default action has been prevented.
	 * @type {boolean}
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.9.4
	 */
	override public function get defaultPrevented():Boolean
	{
		return wrappedEvent ? wrappedEvent.defaultPrevented : _defaultPrevented;
	}
	override public function set defaultPrevented(value:Boolean):void
	{
		_defaultPrevented = value;
	}

	/**
	 * Create a copy/clone of the Event object.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.9.4
	 */
	override public function cloneEvent():IRoyaleEvent
	{
		return new mx.events.FocusEvent(type, bubbles, cancelable,
				relatedObject, shiftKey, keyCode, direction);
	}
	/**
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.9.4
	 */
	override public function stopImmediatePropagation():void
	{
		if(wrappedEvent)
		{
			wrappedEvent.stopPropagation();
			nativeEvent.stopImmediatePropagation();
		}
	}

	/**
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.9.4
	 */
	override public function stopPropagation():void
	{
		if(wrappedEvent)
			wrappedEvent.stopPropagation();
	}

	
}

}
