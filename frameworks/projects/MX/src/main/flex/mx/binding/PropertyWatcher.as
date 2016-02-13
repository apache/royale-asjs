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

package mx.binding
{

import org.apache.flex.events.Event;
import org.apache.flex.events.IEventDispatcher;
import org.apache.flex.reflection.getQualifiedClassName;
import mx.core.mx_internal;
import mx.events.PropertyChangeEvent;
import mx.utils.DescribeTypeCache;

use namespace mx_internal;

[ExcludeClass]

/**
 *  @private
 */
public class PropertyWatcher extends Watcher
{
    include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

    /**
     *  Create a PropertyWatcher
     *
     *  @param prop The name of the property to watch.
     *  @param event The event type that indicates the property has changed.
     *  @param listeners The binding objects that are listening to this Watcher.
     *  @param propertyGetter A helper function used to access non-public variables.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function PropertyWatcher(propertyName:String,
                                    events:Object,
                                    listeners:Array,
                                    propertyGetter:Function = null)
    {
		super(listeners);

        _propertyName = propertyName;
        this.events = events;
        this.propertyGetter = propertyGetter;
        useRTTI = !events;
    }

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	/**
     *  The parent object of this property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var parentObj:Object;

    /**
     *  The events that indicate the property has changed
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var events:Object;

    /**
     *  Storage for the propertyGetter property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var propertyGetter:Function;

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  propertyName
	//----------------------------------

	/**
     *  Storage for the propertyName property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _propertyName:String;
    
    /**
     *  The name of the property this Watcher is watching.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get propertyName():String
    {
        return _propertyName;
    }

	//----------------------------------
	//  useRTTI
	//----------------------------------

    /**
     *	If compiler can't determine bindability from static type,
	 *  use RTTI on runtime values.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var useRTTI:Boolean;

	//--------------------------------------------------------------------------
	//
	//  Overridden methods: Watcher
	//
	//--------------------------------------------------------------------------

    /**
     *  If the parent has changed we need to update ourselves
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function updateParent(parent:Object):void
    {
        if (parentObj && parentObj is IEventDispatcher)
        {
            for (var eventType:String in events)
            {
                parentObj.removeEventListener(eventType, eventHandler);
            }
        }

        if (parent is Watcher)
            parentObj = parent.value;
        else
            parentObj = parent;

        if (parentObj)
        {
			if (useRTTI)
			{
				// Use RTTI to ensure that parentObj is an IEventDispatcher,
				// and that bindability metadata exists
				// for parentObj[_propertyName].

				events = {};

				if (parentObj is IEventDispatcher)
				{
					var info:BindabilityInfo =
						DescribeTypeCache.describeType(parentObj).
						bindabilityInfo;

					events = info.getChangeEvents(_propertyName);

					if (objectIsEmpty(events))
					{
						trace("warning: unable to bind to property '" +
							  _propertyName + "' on class '" +
							  getQualifiedClassName(parentObj) + "'");
					}
					else
					{
						addParentEventListeners();
					}
				}
				else
				{
					trace("warning: unable to bind to property '" +
						  _propertyName + "' on class '" +
						  getQualifiedClassName(parentObj) +
						  "' (class is not an IEventDispatcher)");
				}
			}
			else
			{
				// useRTTI == false implies that the compiler
				// has provided us with a list of change events.
				// NOTE: this normally also implies that parentObj
				// is guaranteed to implement IEventDispatcher.
				// The guard below is necessitated by Proxy cases,
				// which provide blanket bindability information
				// on properties which are not strongly typed,
				// and so could accept values that do not implement
				// IEventDispatcher.
				// In these cases, correct binding behavior depends on
				// the Proxy implementation providing after-the-fact
				// bindability by wrapping assigned values and attaching
				// event listeners at that point.
				// Here we can only fail silently.

				if (parentObj is IEventDispatcher)
					addParentEventListeners();
			}
        }
        
		// Now get our property.
        wrapUpdate(updateProperty);
    }

    /**
	 *  @private
	 */
    override protected function shallowClone():Watcher
    {
        var clone:PropertyWatcher = new PropertyWatcher(_propertyName,
                                                        events,
                                                        listeners,
                                                        propertyGetter);

        return clone;
    }

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private function addParentEventListeners():void
	{
		for (var eventType:String in events)
		{
			if (eventType != "__NoChangeEvent__")
			{
				parentObj.bindingEventDispatcher.addEventListener(
					eventType, eventHandler, false);
			}
		}
	}

	/**
	 *  @private
	 */
	private function traceInfo():String
	{
		return "Watcher(" + getQualifiedClassName(parentObj) + "." +
				_propertyName + "): events = [" +
				eventNamesToString() + (useRTTI ? "] (RTTI)" : "]");
	}

	/**
	 *  @private
	 */
	private function eventNamesToString():String
	{
		var s:String = " ";

		for (var ev:String in events)
		{
			s += ev + " ";
		}
		
		return s;
	}

	/**
	 *  @private
	 */
	private function objectIsEmpty(o:Object):Boolean
	{
		for (var p:String in o)
		{
			return false;
		}
		return true;
	}

    /**
     *  Gets the actual property then updates
	 *  the Watcher's children appropriately.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function updateProperty():void
    {
        if (parentObj)
        {
            if (_propertyName == "this")
            {
                value = parentObj;
            }
            else
            {
                if (propertyGetter != null)
                {
                    value = propertyGetter.apply(parentObj, [ _propertyName ]);
                }
                else
                {
                    value = parentObj[_propertyName];
                }
            }
        }
        else
        {
            value = null;
        }

        updateChildren();
    }

	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------

    /**
     *  The generic event handler.
	 *  The only event we'll hear indicates that the property has changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function eventHandler(event:Event):void
    {
        if (event is PropertyChangeEvent)
        {
            var propName:Object = PropertyChangeEvent(event).property;

            if (propName != _propertyName)
                return;
        }

		wrapUpdate(updateProperty);

        notifyListeners(events[event.type]);
    }
}

}
