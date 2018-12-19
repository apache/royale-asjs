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
package org.apache.royale.events
{
    import org.apache.royale.core.IDragInitiator;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.geom.Point;
    import org.apache.royale.utils.PointUtils;

    COMPILE::JS
    {
        import org.apache.royale.core.IUIBase;
		import org.apache.royale.core.IStrand;
		import org.apache.royale.core.UIBase;
        import window.Event;
        import window.MouseEvent;
        import org.apache.royale.events.utils.EventUtils;
    }
	COMPILE::SWF
	{
		import flash.display.InteractiveObject;
	}
    
	/**
	 *  Drag and Drop Events.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
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
         *  @productversion Royale 1.0.0
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
         *  @productversion Royale 1.0.0
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
         *  @productversion Royale 1.0.0
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
         *  @productversion Royale 1.0.0
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
         *  @productversion Royale 1.0.0
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
         *  @productversion Royale 1.0.0
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
         *  @productversion Royale 1.0.0
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
         *  @productversion Royale 0.0
         * 
         *  @royalesuppresspublicvarwarning
         */
        public static var dragInitiator:IDragInitiator;
        
        /**
         *  The data being dragged. Or an instance
         *  of an object describing the data.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         * 
         *  @royalesuppresspublicvarwarning
         */
        public static var dragSource:Object;
		
		COMPILE::SWF {
			private var _clientX:Number;
			
			/**
			 * @private
			 */
			override public function set clientX(value:Number):void
			{
				super.clientX = value;
				_clientX = value;
			}
			override public function get clientX():Number
			{
				return _clientX;
			}
	        
			private var _clientY:Number;
			
			/**
			 * @private
			 */
			override public function set clientY(value:Number):void
			{
				super.clientY = value;
				_clientY = value;
			}
			override public function get clientY():Number
			{
				return _clientY;
			}
		}
		COMPILE::JS {
			private var _relatedObject:Object;
			
			/**
			 * @private
			 */
			public function get relatedObject():Object
			{
				return _relatedObject;
			}
			public function set relatedObject(value:Object):void
			{
				_relatedObject = value;
			}
		}

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
         *  @productversion Royale 0.0
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
				this.bubbles = bubbles;
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
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.events.DragEvent
         *  @royaleignorecoercion window.Event
         *  @royaleignorecoercion Event
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
                de.relatedObject = event.target as InteractiveObject;
				
				de.clientX = event.clientX;
				de.clientY = event.clientY;
				
                return de;                    
            }
            COMPILE::JS
            {
				var de:DragEvent = new DragEvent(type, true, true);

				de.altKey = event.altKey;
				de.ctrlKey = event.ctrlKey;
				de.shiftKey = event.shiftKey;
				de.relatedObject = event.target;
				
				de.clientX = event.clientX;
				de.clientY = event.clientY;
				
				return de;
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
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.IUIBase
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         *  @royaleignorecoercion window.Event
         */
        public static function dispatchDragEvent(event:DragEvent, target:Object):void
        {
            COMPILE::SWF
            {
                target.dispatchEvent(event);                    
            }
            COMPILE::JS
            {	
				(target as IEventDispatcher).dispatchEvent(event);
            }
        }

        /**
         */
        private static function installDragEventMixin():Boolean 
        {
            return true;
        }
        
        
        /**
         * Add some other events to listen from the element
         */
        private static var dragEventMixin:Boolean = installDragEventMixin();
        
        /**
         * Calling this calls the static initializers
         */
        COMPILE::SWF
        public static function init():void
        {
            
        }
        
        /**
         * Create a copy/clone of the Event object.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
         */
        COMPILE::SWF
        override public function cloneEvent():IRoyaleEvent
        {
            return createDragEvent(type, this);
        }
        


    }
}
