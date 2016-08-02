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
    import org.apache.flex.core.IDragInitiator;
    COMPILE::JS
    {
        import org.apache.flex.core.IUIBase;
        import window.Event;
        import window.MouseEvent;
    }
    
	/**
	 *  Drag and Drop Events.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
	 */
	public class DragEvent extends DragEventBase
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
        public static var dragInitiator:IDragInitiator;
        
        /**
         *  The data being dragged. Or an instance
         *  of an object describing the data.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static var dragSource:Object;
        

        /**
         *  Constructor.  Do not call 'new DragEvent', use the
         *  createDragEvent method instead.
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
            COMPILE::SWF
            {
                super(type, bubbles, cancelable);                    
            }
            COMPILE::JS
            {
                this.type = type;
            }
		}

        /**
         *  Factory for DragEvents.
         *  
         *  @param type The name of the event.
         *  @param event The MouseEvent properties to copy into the DragEvent.
         *  @return The new DragEvent.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion org.apache.flex.events.DragEvent
         *  @flexjsignorecoercion window.Event
         *  @flexjsignorecoercion Event
         */
        public static function createDragEvent(type:String, event:MouseEvent):DragEvent
        {
            COMPILE::SWF
            {
                var de:DragEvent = new DragEvent(type, true, true);
                de.localX = event.localX;
                de.localY = event.localY;
                de.altKey = event.altKey;
                de.ctrlKey = event.ctrlKey;
                de.shiftKey = event.shiftKey;
                de.buttonDown = event.buttonDown;
                de.delta = event.delta;
                de.relatedObject = event.relatedObject;
                return de;                    
            }
            COMPILE::JS
            {
                var out:window.MouseEvent = new window.MouseEvent(type);
                var e:window.Event = event as window.Event;
                (out as window.Event).initMouseEvent(type, true, true,
                    e.view, e.detail, e.screenX, e.screenY,
                    e.clientX, e.clientY, e.ctrlKey, e.altKey,
                    e.shiftKey, e.metaKey, e.button, e.relatedTarget);
                return out as DragEvent;
            }
        }
        
        
        /**
         *  Dispatch a DragEvent
         *  
         *  @param event The DragEvent to dispatch.
         *  @param target The target to dispatch the event from.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion org.apache.flex.core.IUIBase
         *  @flexjsignorecoercion org.apache.flex.events.IEventDispatcher
         *  @flexjsignorecoercion window.Event
         */
        public static function dispatchDragEvent(event:DragEvent, target:IEventDispatcher):void
        {
            COMPILE::SWF
            {
                target.dispatchEvent(event);                    
            }
            COMPILE::JS
            {
                ((target as IUIBase).element as IEventDispatcher).dispatchEvent(event as window.Event);
            }
        }

        /**
         */
        COMPILE::JS
        private static function installDragEventMixin():Boolean 
        {
            var o:Object = org.apache.flex.events.ElementEvents.elementEvents;
            o['dragEnd'] = 1;
            o['dragMove'] = 1;
            return true;
        }
        
        
        /**
         * Add some other events to listen from the element
         */
        COMPILE::JS
        private static var dragEventMixin:Boolean = installDragEventMixin();

    }
}
