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
package org.apache.flex.events
{
    import flash.events.MouseEvent;
    import org.apache.flex.core.IDragInitiator;
    
	/**
	 *  Drag and Drop Events.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
	 */
	public class DragEvent extends MouseEvent
	{
        /**
         *  The <code>DragEvent.DRAG_START</code> constant defines the value of the 
         *  event object's <code>type</code> property for a <code>dragStart</code> event. 
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
         *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
         *       it is not always the Object listening for the event. 
         *       Use the <code>currentTarget</code> property to always access the 
         *       Object listening for the event.</td></tr>
         *  </table>
         *
         *  @eventType dragStart 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static const DRAG_START:String = "dragStart";
        
        /**
         *  The <code>DragEvent.DRAG_MOVE</code> constant defines the value of the 
         *  event object's <code>type</code> property for a <code>dragMove</code> event. 
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
         *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
         *       it is not always the Object listening for the event. 
         *       Use the <code>currentTarget</code> property to always access the 
         *       Object listening for the event.</td></tr>
         *  </table>
         *
         *  @eventType dragMove 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static const DRAG_MOVE:String = "dragMove";

        /**
         *  The <code>DragEvent.DRAG_END</code> constant defines the value of the 
         *  event object's <code>type</code> property for a <code>dragEnd</code> event. 
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
         *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
         *       it is not always the Object listening for the event. 
         *       Use the <code>currentTarget</code> property to always access the 
         *       Object listening for the event.</td></tr>
         *  </table>
         *
         *  @eventType dragEnd 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static const DRAG_END:String = "dragEnd";

        /**
         *  The <code>DragEvent.DRAG_ENTER</code> constant defines the value of the 
         *  event object's <code>type</code> property for a <code>dragEnter</code> event. 
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
         *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
         *       it is not always the Object listening for the event. 
         *       Use the <code>currentTarget</code> property to always access the 
         *       Object listening for the event.</td></tr>
         *  </table>
         *
         *  @eventType dragEnter 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static const DRAG_ENTER:String = "dragEnter";
        
        /**
         *  The <code>DragEvent.DRAG_OVER</code> constant defines the value of the 
         *  event object's <code>type</code> property for a <code>dragOver</code> event. 
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
         *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
         *       it is not always the Object listening for the event. 
         *       Use the <code>currentTarget</code> property to always access the 
         *       Object listening for the event.</td></tr>
         *  </table>
         *
         *  @eventType dragOver 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static const DRAG_OVER:String = "dragOver";
        
        /**
         *  The <code>DragEvent.DRAG_EXIT</code> constant defines the value of the 
         *  event object's <code>type</code> property for a <code>dragExit</code> event. 
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
         *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
         *       it is not always the Object listening for the event. 
         *       Use the <code>currentTarget</code> property to always access the 
         *       Object listening for the event.</td></tr>
         *  </table>
         *
         *  @eventType dragExit 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static const DRAG_EXIT:String = "dragExit";
        
        /**
         *  The <code>DragEvent.DRAG_DROP</code> constant defines the value of the 
         *  event object's <code>type</code> property for a <code>dragDrop</code> event. 
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
         *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
         *       it is not always the Object listening for the event. 
         *       Use the <code>currentTarget</code> property to always access the 
         *       Object listening for the event.</td></tr>
         *  </table>
         *
         *  @eventType dragDrop 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static const DRAG_DROP:String = "dragDrop";
        
        /**
         *  Constructor.
         *  
         *  @param type The name of the event.
         *  @param bubbles Whether the event bubbles.
         *  @param cancelable Whether the event can be canceled.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function DragEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

        /**
         *  The object that wants to know if a drop is accepted
         *  
         *  @param type The name of the event.
         *  @param bubbles Whether the event bubbles.
         *  @param cancelable Whether the event can be canceled.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var dragInitiator:IDragInitiator;
        
        /**
         *  The data being dragged. Or an instance
         *  of an object describing the data.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var dragSource:Object;
        
        public function copyMouseEventProperties(event:MouseEvent):void
        {
            localX = event.localX;
            localY = event.localY;
            altKey = event.altKey;
            ctrlKey = event.ctrlKey;
            shiftKey = event.shiftKey;
            buttonDown = event.buttonDown;
            delta = event.delta;
            relatedObject = event.relatedObject;
        }
	}
}