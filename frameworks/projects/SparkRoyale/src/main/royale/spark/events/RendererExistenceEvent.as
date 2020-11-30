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

package spark.events
{

import org.apache.royale.events.Event;

import mx.core.IVisualElement;

/**
 *  The RendererExistenceEvent class represents events that are 
 *  dispatched when a renderer of a Spark DataGroup is added or removed.
 *
 *  @see spark.components.DataGroup
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class RendererExistenceEvent extends Event
{
    //include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  The <code>RendererExistenceEvent.RENDERER_ADD</code> constant 
     *  defines the value of the <code>type</code> property of the event 
     *  object for an <code>rendererAdd</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>data</code></td><td>The data item that the renderer
     *       is visualizing.</td></tr>
     *     <tr><td><code>index</code></td><td>The data provider index for the 
     *       renderer that was added.</td></tr>
     *     <tr><td><code>renderer</code></td><td>Contains a reference
     *         to the renderer that was added</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType rendererAdd
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const RENDERER_ADD:String = "rendererAdd";

    /**
     *  The <code>RendererExistenceEvent.RENDERER_REMOVE</code> constant 
     *  defines the value of the <code>type</code> property of the event 
     *  object for an <code>rendererRemove</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>data</code></td><td>The data item that the renderer
     *       was visualizing.</td></tr>
     *     <tr><td><code>index</code></td><td>The data provider index for the 
     *       renderer that is being removed.</td></tr>
     *     <tr><td><code>renderer</code></td><td>Contains a reference
     *        to the renderer that is about to be removed.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType rendererRemove
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const RENDERER_REMOVE:String = "rendererRemove";

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
     *  @param bubbles Specifies whether the event can bubble up the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior associated with the event can be prevented.
     *
     *  @param renderer Reference to the item renderer that was added or removed.
     * 
     *  @param index The index in the data provider where the renderer was added or removed.
     * 
     *  @param data The data item that the renderer is visualizing.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function RendererExistenceEvent(
                                type:String, bubbles:Boolean = false,
                                cancelable:Boolean = false,
                                renderer:IVisualElement = null, 
                                index:int = -1, data:Object = null)
    {
        super(type, bubbles, cancelable);

        this.renderer = renderer;
        this.index = index;
        this.data = data;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  data
    //----------------------------------

    /**
     *  The data item of the renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var data:Object;
    
    //----------------------------------
    //  index
    //----------------------------------

    /**
     *  The index where the item renderer was added or removed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var index:int;

    //----------------------------------
    //  renderer
    //----------------------------------

    /**
     *  Reference to the item render that was added or removed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var renderer:IVisualElement;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function cloneEvent():Event
    {
        return new RendererExistenceEvent(type, bubbles, cancelable,
                                         renderer, index, data);
    }
}

}
