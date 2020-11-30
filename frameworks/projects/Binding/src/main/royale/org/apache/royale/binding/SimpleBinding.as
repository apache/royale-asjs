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
package org.apache.royale.binding
{
import org.apache.royale.core.IBead;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.IDocument;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.events.Event;
import org.apache.royale.events.ValueChangeEvent;
import org.apache.royale.core.IBinding;
/**
 *  The SimpleBinding class is lightweight data-binding class that
 *  is optimized for simple assignments of one object's property to
 *  another object's property.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class SimpleBinding implements IBead, IDocument, IBinding
{
	/**
	 *  Constructor.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function SimpleBinding(isStatic:Boolean=false)
	{
		_isStatic = isStatic;
	}

	private var _isStatic:Boolean;
    private var _destination:Object;
    private var _sourceID:String;
    private var _destinationPropertyName:String;
    private var _sourcePropertyName:String;

	/**
	 *  The event dispatcher that dispatches an event
	 *  when the source property changes. This can
	 *  be different from the source (example: static bindables)
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	protected var dispatcher:IEventDispatcher;

	/**
	 *  The source object that dispatches an event
	 *  when the property changes
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	protected var source:Object;

	/**
	 *  The host mxml document for the source and
	 *  destination objects.  The source object
	 *  is either this document for simple bindings
	 *  like {foo} where foo is a property on
	 *  the mxml documnet, or found as document[sourceID]
	 *  for simple bindings like {someid.someproperty}
	 *  It may be the document class for local static
	 *  bindables (e.g. from a script block)
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	protected var document:Object;

    private var _eventName:String;
    
	/**
	 *  The event name that is dispatched when the source
	 *  property changes.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
    public function get eventName():String
    {
        return _eventName;
    }
    
    public function set eventName(value:String):void
    {
        _eventName = value;
    }

    /**
     *  @copy org.apache.royale.core.IBinding#destination;
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get destination():Object
    {
        return _destination;
    }

    public function set destination(value:Object):void
    {
        _destination = value;
    }

    /**
     *  @copy org.apache.royale.core.IBinding#sourceID
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get sourceID():String
    {
        return _sourceID;
    }

    public function set sourceID(value:String):void
    {
        _sourceID = value;
    }

	private var _sourceEventName:String = 'valueChange';
	public function setSourceEventName(eventName:String):void{
		_sourceEventName = eventName;
	}

    /**
     *  @copy org.apache.royale.core.IBinding#destinationPropertyName
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get destinationPropertyName():String
    {
        return _destinationPropertyName;
    }

    public function set destinationPropertyName(value:String):void
    {
        _destinationPropertyName = value;
    }

    /**
     *  @copy org.apache.royale.core.IBinding#sourcePropertyName
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get sourcePropertyName():String
    {
        return _sourcePropertyName;
    }

    public function set sourcePropertyName(value:String):void
    {
        _sourcePropertyName = value;
    }



	/**
	 *  @copy org.apache.royale.core.IBead#strand
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
	 */
	public function set strand(value:IStrand):void
	{
		if (dispatcher) dispatcher.removeEventListener(eventName, changeHandler);
		if (destination == null)
			destination = value;
		if (_isStatic) {
			source = document;
			dispatcher = source.staticEventDispatcher as IEventDispatcher;
		} else {
			if (sourceID != null)
			{
				source = dispatcher = document[sourceID] as IEventDispatcher;
				document.addEventListener(_sourceEventName, sourceChangeHandler);
				if (source == null)
				{
					return;
				}
			} else {
				source = dispatcher = document as IEventDispatcher;
			}

		}

		dispatcher.addEventListener(eventName, changeHandler);
		try
		{
			destination[destinationPropertyName] = source[sourcePropertyName];
		}
		catch (e:Error) {}

	}

	/**
	 *  @copy org.apache.royale.core.IDocument#setDocument()
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function setDocument(document:Object, id:String = null):void
	{
		this.document = document;
	}

	/**
	 * @royaleignorecoercion org.apache.royale.events.ValueChangeEvent
	 */
	private function changeHandler(event:Event):void
	{
		if (event.type == ValueChangeEvent.VALUE_CHANGE)
		{
			var vce:ValueChangeEvent = event as ValueChangeEvent;
			if (vce.propertyName != sourcePropertyName)
				return;
		}
		destination[destinationPropertyName] = source[sourcePropertyName];
	}

	/**
	 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
	 * @royaleignorecoercion org.apache.royale.events.ValueChangeEvent
	 */
	private function sourceChangeHandler(event:/*ValueChange*/Event):void
	{
		if (event.type == ValueChangeEvent.VALUE_CHANGE && (event as ValueChangeEvent).propertyName != sourceID)
			return;

		if (dispatcher)
			dispatcher.removeEventListener(eventName, changeHandler);

		source = dispatcher = document[sourceID] as IEventDispatcher;

		if (dispatcher)
			dispatcher.addEventListener(eventName, changeHandler);

		destination[destinationPropertyName] = source ? source[sourcePropertyName] : null;
	}
}
}
