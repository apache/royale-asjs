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
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.events.ValueChangeEvent;

    /**
     *  The PropertyWatcher class is the data-binding class that watches
     *  for changes to various properties in objects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     * 
     *  @royalesuppresspublicvarwarning
     */
	public class PropertyWatcher extends WatcherBase
	{
        /**
         *  Constructor.
         *  
         *  @param source The object who's property we are watching.
         *  @param propertyName The name of the property we are watching.
         *  @param eventNames The name or array of names of events that get
         *  dispatched when the property changes.
         *  @param getterFunction  A function to call to get the value
         *  of the property changes if the property is not public.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function PropertyWatcher(document:Object, propertyName:String, eventNames:Object, 
                                            getterFunction:Function)
		{
            this.document = document;
            this.propertyName = propertyName;
            this.getterFunction = getterFunction;
            this.eventNames = eventNames;
            
		}

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
         *  The document we belong to.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var document:Object;
        
        /**
         *  The object who's property we are watching.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public var source:Object;
        
        /**
         *  The name of the property we are watching.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var propertyName:String;
        
        /**
         *  The name or array of names of events that get
         *  dispatched when the property changes.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
         *  @productversion Royale 0.0
         */                
        public var getterFunction:Function;
        
        
        /**
         *  Support for function return binding on a chain
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public var funcProps:Object;
		
        /**
         *  The event handler that gets called when
         *  the change events are dispatched.
         *  
         *  @param event The event that was dispatched to notify of a value change.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.events.ValueChangeEvent
         */                
        protected function changeHandler(event:Event):void
        {
            if (event is ValueChangeEvent)
            {   //normally it is 'generic' ValueChangeEvent.VALUE_CHANGE, but it can be other types, eg. "currentStateChange", so check here:
                if (event.type == ValueChangeEvent.VALUE_CHANGE) {
                    var propName:String = ValueChangeEvent(event).propertyName;

                    if (propName != propertyName) {
                        return;
                    }

                }
                //@todo investigate possible optimization here. We can assume we already know the new Value and old Value via the event.
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
         *  @royaleignorecoercion org.apache.royale.binding.PropertyWatcher
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
        override public function parentChanged(parent:Object):void
        {
            if (dispatcher)
				adjustListeners(false);

            if (parent is PropertyWatcher)
                source = PropertyWatcher(parent).value;
            else
                source = parent;
            
            if (source) {
                if (source is IEventDispatcher) dispatcher = IEventDispatcher(source);
                else if (source is Class && source['staticEventDispatcher']!=null) dispatcher = source.staticEventDispatcher;
            }

            if (dispatcher) 
                adjustListeners(true);
            
            // Now get our property.
            wrapUpdate(updateProperty);
            
            notifyListeners();
        }

        /**
         * @royaleignorecoercion Array
         * @royaleignorecoercion String
         */
        private function adjustListeners(add:Boolean):void
        {
            var adjustListener:Function = add ? dispatcher.addEventListener : dispatcher.removeEventListener;
            if (eventNames is String)
            {
				adjustListener(eventNames as String, changeHandler);
            }
            else if (eventNames is Array)
            {
                var arr:Array = eventNames as Array;
                var n:int = arr.length;
                for (var i:int = 0; i < n; i++)
                {
                    var eventName:String = eventNames[i];
					adjustListener(eventName, changeHandler);
                }
            }
            if (!add)  dispatcher = null;
        }
        
        /**
         *  Gets the actual property then updates
         *  the Watcher's children appropriately.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
                    if (funcProps != null) {
                        try{
                            if (funcProps.functionGetter != null)
                            {
                                value = funcProps.functionGetter(funcProps.functionName).apply(source,
                                        funcProps.paramFunction.apply(document));
                            }
                            else
                            {
                                value = source[funcProps.functionName].apply(source,
                                        funcProps.paramFunction.apply(document));
                            }
                        } catch (e:Error)
                        {
                            value = null;
                        }
                    }
                    else if (getterFunction != null)
                    {
                        try
                        {
                            value = getterFunction.apply(document, [ propertyName ]);
                        }
                        catch (e:Error)
                        {
                            value = null;
                        }
                    }
                    else
                    {
                        COMPILE::JS
                        {
                            // someday have Proxy swap out PropertyWatcher?
                            if (typeof source["getProperty"] === "function")
                                value = source["getProperty"](propertyName);
                            else
                                value = source[propertyName];
                            
                        }
                        COMPILE::SWF
                        {
                            value = source[propertyName];
                        }
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
