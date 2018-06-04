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

/* import flash.events.Event;
 */
 import org.apache.royale.events.Event;
/**
 *  The IndexChangeEvent class represents events that are dispatched when 
 *  an index changes in a Spark component.
 *
 *  @see spark.components.supportClasses.ListBase
 *  @see spark.components.List
 *  @see spark.components.ButtonBar
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 *  @royalesuppresspublicvarwarning
 */
public class IndexChangeEvent extends Event
{
  //  include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  The <code>IndexChangeEvent.CHANGE</code> constant defines the value of the 
     *  <code>type</code> property of the event object for a <code>change</code> event,
     *  which indicates that an index has changed, such as when a List-based control 
     *  changes its selection. 
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
     *     <tr><td><code>newIndex</code></td><td>The zero-based index 
     *       after the change.</td></tr>
     *     <tr><td><code>oldIndex</code></td><td>The zero-based index 
     *       before the change.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>Type</code></td><td>IndexChangeEvent.CHANGE</td></tr>
     *  </table>
     *   
     *  @eventType change
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public static const CHANGE:String = "change";
    
    /**
     *  The <code>IndexChangeEvent.CHANGING</code> constant defines the value of the 
     *  <code>type</code> property of the event object for a <code>changing</code> event,
     *  which indicates that the current selection is about to change. 
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
     *     <tr><td><code>newIndex</code></td><td>The zero-based index of the 
     *       selected item after the change.</td></tr>
     *     <tr><td><code>oldIndex</code></td><td>The zero-based index of the 
     *       selected item before the change.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>Type</code></td><td>IndexChangeEvent.CHANGING</td></tr>
     *  </table>
     *   
     *  @eventType changing
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   //public static const CHANGING:String = "changing";
    
    /**
     *  The <code>IndexChangeEvent.CARET_CHANGE</code> constant defines the value of the 
     *  <code>type</code> property of the event object for a <code>caretChange</code> event,
     *  which indicates that the current item in focus is about to change. 
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
     *     <tr><td><code>newIndex</code></td><td>The zero-based index of the 
     *       selected item after the change.</td></tr>
     *     <tr><td><code>oldIndex</code></td><td>The zero-based index of the 
     *       selected item before the change.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>Type</code></td><td>IndexChangeEvent.CARET_CHANGE</td></tr>
     *  </table>
     *   
     *  @eventType caretChange
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    //public static const CARET_CHANGE:String = "caretChange";

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
     *  @param oldIndex The zero-based index before the change.
     *
     *  @param newIndex The zero-based index after the change.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function IndexChangeEvent(type:String, bubbles:Boolean = false,
                                      cancelable:Boolean = false,
                                      oldIndex:int = -1,
                                      newIndex:int = -1)
    {
        super(type, bubbles, cancelable);

        this.oldIndex = oldIndex;
        this.newIndex = newIndex;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  newIndex
    //----------------------------------

    /**
     *  The zero-based index after the change. For <code>change</code> events
     *  it is the index of the current child. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public var newIndex:int;

    //----------------------------------
    //  oldIndex
    //----------------------------------

    /**
     *  The zero-based index before the change.  
     *  For <code>change</code> events it is the index of the previous child.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public var oldIndex:int;

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
        return new IndexChangeEvent(type, bubbles, cancelable,
                                     oldIndex, newIndex);
    }
}

}
