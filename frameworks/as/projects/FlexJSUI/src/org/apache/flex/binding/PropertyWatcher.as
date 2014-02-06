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
package org.apache.flex.binding
{	
    import org.apache.flex.events.Event;
    import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.events.ValueChangeEvent;

    /**
     *  The PropertyWatcher class is the data-binding class that watches
     *  for changes to various properties in objects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class PropertyWatcher extends WatcherBase
	{
        /**
         *  Constructor.
         *  
         *  @param source The object who's property we are watching.
         *  @param proeprtyName The name of the property we are watching.
         *  @param eventNames The name or array of names of events that get
         *  dispatched when the property changes.
         *  @param getterFunction  A function to call to get the value
         *  of the property changes if the property is not public.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function PropertyWatcher(source:Object, propertyName:String, eventNames:Object, 
                                            getterFunction:Function)
		{
            this.source = source;
            this.propertyName = propertyName;
            this.getterFunction = getterFunction;
            this.eventNames = eventNames;
            
		}
		
        /**
         *  The object who's property we are watching.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public var source:Object;
        
        /**
         *  The name of the property we are watching.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var propertyName:String;
        
        /**
         *  The name or array of names of events that get
         *  dispatched when the property changes.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */        
        public var eventNames:Object;
        
        /**
         *  A function to call to get the value
         *  of the property changes if the property is
         *  not public.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */                
        public var getterFunction:Function;
		
        /**
         *  The event handler that gets called when
         *  the change events are dispatched.
         *  
         *  @param event The event that was dispatched to notify of a value change.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */                
        protected function changeHandler(event:Event):void
        {
            if (event is ValueChangeEvent)
            {
                var propName:String = ValueChangeEvent(event).propertyName;
                
                if (propName != propertyName)
                    return;
            }
            
            wrapUpdate(updateProperty);
            
            notifyListeners();
            
        }
        
        //--------------------------------------------------------------------------
        //
        //  Overridden methods: Watcher
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         */                
        override public function parentChanged(parent:Object):void
        {
            if (source && source is IEventDispatcher)
                removeEventListeners();

            source = parent;
            
            if (source)
                addEventListeners();
            
            // Now get our property.
            wrapUpdate(updateProperty);
        }

        private function addEventListeners():void
        {
            if (eventNames is String)
                source.addEventListener(eventNames as String, changeHandler);
            else if (eventNames is Array)
            {
                var arr:Array = eventNames as Array;
                var n:int = arr.length;
                for (var i:int = 0; i < n; i++)
                {
                    var eventName:String = eventNames[i];
                    source.addEventListener(eventName, changeHandler);           
                }
            }
        }
        
        private function removeEventListeners():void
        {
            if (eventNames is String)
                source.removeEventListener(eventNames as String, changeHandler);
            else if (eventNames is Array)
            {
                var arr:Array = eventNames as Array;
                var n:int = arr.length;
                for (var i:int = 0; i < n; i++)
                {
                    var eventName:String = eventNames[i];
                    source.removeEventListener(eventName, changeHandler);           
                }
            }
        }
        
        /**
         *  Gets the actual property then updates
         *  the Watcher's children appropriately.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        private function updateProperty():void
        {
            if (source)
            {
                if (propertyName == "this")
                {
                    value = source;
                }
                else
                {
                    if (getterFunction != null)
                    {
                        value = getterFunction.apply(source, [ propertyName ]);
                    }
                    else
                    {
                        value = source[propertyName];
                    }
                }
            }
            else
            {
                value = null;
            }
            
            updateChildren();
        }

	}
}