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
import flex.events.IEventDispatcher;
COMPILE::LATER
{
import mx.core.EventPriority;
}
import mx.core.mx_internal;

use namespace mx_internal;

[ExcludeClass]

/**
 *  @private
 */
public class FunctionReturnWatcher extends Watcher
{
    include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

    /**
	 *  @private
	 *  Constructor.
	 */
	public function FunctionReturnWatcher(functionName:String,
										  document:Object,
										  parameterFunction:Function,
										  events:Object,
                                          listeners:Array,
                                          functionGetter:Function = null,
                                          isStyle:Boolean = false)
    {
		super(listeners);

        this.functionName = functionName;
        this.document = document;
        this.parameterFunction = parameterFunction;
        this.events = events;
        this.functionGetter = functionGetter;
        this.isStyle = isStyle;
    }

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
     *  The name of the property, used to actually get the property
	 *  and for comparison in propertyChanged events.
     */
    private var functionName:String;
    
	/**
 	 *  @private
     *  The document is what we need to use to execute the parameter function.
     */
    private var document:Object;
    
	/**
 	 *  @private
     *  The function that will give us the parameters for calling the function.
     */
    private var parameterFunction:Function;
    
    /**
 	 *  @private
     *  The events that indicate the property has changed.
     */
    private var events:Object;
    
	/**
	 *  @private
     *  The parent object of this function.
     */
    private var parentObj:Object;
    
	/**
	 *  @private
     *  The watcher holding onto the parent object.
     */
    public var parentWatcher:Watcher;

    /**
     *  Storage for the functionGetter property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var functionGetter:Function;

    /**
     *  Storage for the isStyle property.  This will be true, when
     *  watching a function marked with [Bindable(style="true")].  For
     *  example, UIComponent.getStyle().
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4
     */
    private var isStyle:Boolean;

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

    /**
 	 *  @private
     */
    override public function updateParent(parent:Object):void
    {
        if (!(parent is Watcher))
            setupParentObj(parent);
        
		else if (parent == parentWatcher)
            setupParentObj(parentWatcher.value);
        
		updateFunctionReturn();
    }

    /**
 	 *  @private
     */
    override protected function shallowClone():Watcher
    {
        var clone:FunctionReturnWatcher = new FunctionReturnWatcher(functionName,
                                                                    document,
                                                                    parameterFunction,
                                                                    events,
                                                                    listeners,
                                                                    functionGetter);

        return clone;
    }

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

    /**
 	 *  @private
     *  Get the new return value of the function.
     */
    public function updateFunctionReturn():void
    {
        wrapUpdate(function():void
		{
            if (functionGetter != null)
            {
                value = functionGetter(functionName).apply(parentObj,
                                                           parameterFunction.apply(document));
            }
            else
            {
                value = parentObj[functionName].apply(parentObj,
                                                      parameterFunction.apply(document));
            }
			
			updateChildren();
		});
    }

    /**
 	 *  @private
     */
    private function setupParentObj(newParent:Object):void
    {
		var eventDispatcher:IEventDispatcher;
        var eventName:String;

        // Remove listeners from the old "watched" object.
        if (parentObj != null &&
            parentObj is IEventDispatcher)
        {
            eventDispatcher = parentObj as IEventDispatcher;

            // events can be null when watching a function marked with
            // [Bindable(style="true")].
            if (events != null)
            {
                for (eventName in events)
                {
                    if (eventName != "__NoChangeEvent__")
                    {
                        eventDispatcher.removeEventListener(eventName, eventHandler);
                    }
                }
            }

            if (isStyle)
            {
                // For example, if the data binding expression is
                // {getStyle("color")}, the eventName will be
                // "colorChanged".
                eventName = parameterFunction.apply(document) + "Changed";
                eventDispatcher.removeEventListener(eventName, eventHandler);
                eventDispatcher.removeEventListener("allStylesChanged", eventHandler);
            }
        }
        
		parentObj = newParent;
        
        // Add listeners the new "watched" object.
        if (parentObj != null &&
            parentObj is IEventDispatcher)
        {
            eventDispatcher = parentObj as IEventDispatcher;

            // events can be null when watching a function marked with
            // [Bindable(style="true")].
            if (events != null)
            {
                for (eventName in events)
                {
                    if (eventName != "__NoChangeEvent__")
                    {
                        eventDispatcher.bindingEventDispatcher.addEventListener(eventName, eventHandler,
                                                         false);
                    }
                }
            }

            if (isStyle)
            {
                // For example, if the data binding expression is
                // {getStyle("color")}, the eventName will be
                // "colorChanged".
                eventName = parameterFunction.apply(document) + "Changed";
                eventDispatcher.bindingEventDispatcher.addEventListener(eventName, eventHandler, false);                
                eventDispatcher.bindingEventDispatcher.addEventListener("allStylesChanged", eventHandler, false);                
            }
        }
    }

	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------

    /**
 	 *  @private
     */
    public function eventHandler(event:Event):void
    {
        updateFunctionReturn();

        // events can be null when watching a function marked with
        // [Bindable(style="true")].
        if (events != null)
        {
            notifyListeners(events[event.type]);
        }

        if (isStyle)
        {
            notifyListeners(true);
        }
    }
}

}
