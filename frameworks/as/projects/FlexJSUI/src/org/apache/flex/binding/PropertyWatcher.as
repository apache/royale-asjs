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

	public class PropertyWatcher extends WatcherBase
	{
		public function PropertyWatcher(source:Object, propertyName:String, eventNames:Object, 
                                            getterFunction:Function)
		{
            this.source = source;
            this.propertyName = propertyName;
            this.getterFunction = getterFunction;
            this.eventNames = eventNames;
            
		}
		
		public var source:Object;
        public var propertyName:String;
        public var eventNames:Object;
        public var getterFunction:Function;
		
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
         *  If the parent has changed we need to update ourselves
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
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
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
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