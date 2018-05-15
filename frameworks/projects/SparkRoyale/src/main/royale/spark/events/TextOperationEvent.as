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

//import flash.events.Event;
import org.apache.royale.events.Event;
//import flashx.textLayout.operations.FlowOperation;
//import org.apache.royale.textLayout.operations.FlowOperation;
/**
 *  The TextOperationEvent class represents events that are dispatched
 *  when text content changes due to user operations
 *  such as inserting characters, backspacing, pasting,
 *  or changing text attributes.
 *  
 *  <p>This event is dispatched by subclasses of the SkinnableTextBase class. This
 *  includes RichEditableText and classes that use RichEditableText such as ComboBox and
 *  TextInput, as well as TextArea. Text controls that have no user interaction, 
 *  such as RichText and Label, do not dispatch events of this type.</p>
 *
 *  @see spark.components.RichEditableText
 *  @see spark.components.TextArea
 *  @see spark.components.ComboBox
 *  @see spark.components.TextInput
 *  @see spark.components.supportClasses.SkinnableTextBase
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 *  @royalesuppresspublicvarwarning
*/
public class TextOperationEvent extends Event
{
   // include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  The <code>TextOperationEvent.CHANGING</code> constant 
     *  defines the value of the <code>type</code> property of the event 
     *  object for a <code>changing</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>true</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>operation</code></td><td>The FlowOperation object
     *       describing the editing operation being performed
     *       on the text by the user.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType changing
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public static const CHANGING:String = "changing";

    /**
     *  The <code>TextOperationEvent.CHANGE</code> constant 
     *  defines the value of the <code>type</code> property of the event 
     *  object for a <code>change</code> event.
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
     *     <tr><td><code>operation</code></td><td>The FlowOperation object
     *       describing the editing operation being performed
     *       on the text by the user.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
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
     *  @param bubbles Specifies whether the event
     *  can bubble up the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior
     *  associated with the event can be prevented.
     *
     *  @param operation The FlowOperation object representing
     *  the editing operation being performed on the text by the user.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function TextOperationEvent(type:String, bubbles:Boolean = false,
                                       cancelable:Boolean = true,
                                       operation:Object = null) //operation:FlowOperation
    {
        super(type, bubbles, cancelable);

        this.operation = operation;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  operation
    //----------------------------------

    /**
     *  The FlowOperation object representing the editing operation
     *  being performed on the text by the user.
     *
     *  <p>This might be an InsertTextOperation, a DeleteTextOperation,
     *  a SplitParagraphOperation, a CutOperation, a PasteOperation,
     *  an UndoOperation, or other subclass of FlowOperation.</p>
     *
     *  @see flashx.textLayout.operations.InsertTextOperation
     *  @see flashx.textLayout.operations.DeleteTextOperation
     *  @see flashx.textLayout.operations.SplitParagraphOperation
     *  @see flashx.textLayout.operations.PasteOperation
     *  @see flashx.textLayout.operations.CutOperation
     *  @see flashx.textLayout.operations.UndoOperation
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public var operation:Object;//FlowOperation;

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
        return new TextOperationEvent(type, bubbles, cancelable, operation);
    }
}

}
