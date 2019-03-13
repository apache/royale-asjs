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

import mx.events.PropertyChangeEventKind;

import org.apache.royale.events.Event;
import org.apache.royale.events.IRoyaleEvent;

/**
 * The PropertyChangeEvent class represents the event object 
 * passed to the event listener when one of the properties of 
 * an object has changed, and provides information about the change. 
 * This event is used by collection classes, and is the only way for 
 * collections to know that the data they represent has changed.
 * This event is also used by the Flex data binding mechanism.
 * 
 * @see PropertyChangeEventKind
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class PropertyChangeEvent extends Event
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    // Note: If the value for CHANGE changes,
    // update mx.utils.ObjectProxy's Bindable metadata.
    
    /**
     *  The <code>PropertyChangeEvent.PROPERTY_CHANGE</code> constant defines the value of the 
     *  <code>type</code> property of the event object for a <code>PropertyChange</code> event.
     * 
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>Determined by the constructor; defaults to false.</td></tr>
     *     <tr><td><code>cancelable</code></td><td>Determined by the constructor; defaults to false.</td></tr>
     *     <tr><td><code>kind</code></td><td>The kind of change; PropertyChangeEventKind.UPDATE
     *             or PropertyChangeEventKind.DELETE.</td></tr>
     *     <tr><td><code>oldValue</code></td><td>The original property value.</td></tr>
     *     <tr><td><code>newValue</code></td><td>The new property value, if any.</td></tr>
     *     <tr><td><code>property</code></td><td>The property that changed.</td></tr>
     *     <tr><td><code>source</code></td><td>The object that contains the property that changed.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType propertyChange
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const PROPERTY_CHANGE:String = "propertyChange";

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns a new PropertyChangeEvent of kind
     *  <code>PropertyChangeEventKind.UPDATE</code>
     *  with the specified properties.
     *  This is a convenience method.
     * 
     *  @param source The object where the change occured.
     *
     *  @param property A String, QName, or int
     *  specifying the property that changed,
     *
     *  @param oldValue The value of the property before the change.
     *
     *  @param newValue The value of the property after the change.
     *
     *  @return A newly constructed PropertyChangeEvent
     *  with the specified properties. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function createUpdateEvent(
                                    source:Object,
                                    property:Object,
                                    oldValue:Object,
                                    newValue:Object):PropertyChangeEvent
    {
        var event:PropertyChangeEvent =
            new PropertyChangeEvent(PROPERTY_CHANGE);
        
        event.kind = PropertyChangeEventKind.UPDATE;
        event.oldValue = oldValue;
        event.newValue = newValue;
        event.source = source;
        event.property = property;
        
        return event;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param type The event type; indicates the action that triggered the event.
     *
     *  @param bubbles Specifies whether the event can bubble
     *  up the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior
     *  associated with the event can be prevented.
     *
     *  @param kind Specifies the kind of change.
     *  The possible values are <code>PropertyChangeEventKind.UPDATE</code>,
     *  <code>PropertyChangeEventKind.DELETE</code>, and <code>null</code>.
     *
     *  @param property A String, QName, or int
     *  specifying the property that changed.
     *
     *  @param oldValue The value of the property before the change.
     *
     *  @param newValue The value of the property after the change.
     *
     *  @param source The object that the change occured on.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function PropertyChangeEvent(type:String, bubbles:Boolean = false,
                                        cancelable:Boolean = false,
                                        kind:String = null,
                                        property:Object = null, 
                                        oldValue:Object = null,
                                        newValue:Object = null,
                                        source:Object = null)
    {
        super(type, bubbles, cancelable);

        this.kind = kind;
        this.property = property;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.source = source;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  kind
    //----------------------------------

    /**
     *  Specifies the kind of change.
     *  The possible values are <code>PropertyChangeEventKind.UPDATE</code>,
     *  <code>PropertyChangeEventKind.DELETE</code>, and <code>null</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _kind:String;
	
	public function get kind():String
	{
		return _kind;
	}
	public function set kind(value:String):void
	{
		_kind = value;
	}

    //----------------------------------
    //  newValue
    //----------------------------------

    /**
     *  The value of the property after the change.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _newValue:Object;
	
	public function get newValue():Object
	{
		return _newValue;
	}
	public function set newValue(value:Object):void
	{
		_newValue = value;
	}

    //----------------------------------
    //  oldValue
    //----------------------------------
 
    /**
     *  The value of the property before the change.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _oldValue:Object;
	
	public function get oldValue():Object
	{
		return _oldValue;
	}
	public function set oldValue(value:Object):void
	{
		_oldValue = value;
	}

    //----------------------------------
    //  property
    //----------------------------------

    /**
     *  A String, QName, or int specifying the property that changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _property:Object;
	
	public function get property():Object
	{
		return _property;
	}
	public function set property(value:Object):void
	{
		_property = value;
	}

    //----------------------------------
    //  source
    //----------------------------------

    /**
     *  The object that the change occured on.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _source:Object;
	
	public function get source():Object
	{
		return _source;
	}
	public function set source(value:Object):void
	{
		_source = value;
	}

    //--------------------------------------------------------------------------
    //
    //  Class methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
	override public function cloneEvent():IRoyaleEvent
    {
        return new PropertyChangeEvent(type, bubbles, cancelable, kind,
                                       property, oldValue, newValue, source);
    }
}

}
