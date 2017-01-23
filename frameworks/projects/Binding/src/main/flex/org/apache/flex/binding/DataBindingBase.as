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
    import org.apache.flex.core.IBead;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.events.Event;
    import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.core.IBinding;

    /**
     *  The DataBindingBase class is the base class for custom data binding
     *  implementations that can be cross-compiled.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class DataBindingBase implements IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function DataBindingBase()
		{
		}

		protected var _strand:IStrand;

        protected var deferredBindings:Object = {};

        /**
         *  @copy org.apache.flex.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            IEventDispatcher(_strand).addEventListener("initBindings", initBindingsHandler);
        }

        protected function initBindingsHandler(event:Event):void
        {
        }

        protected function prepareCreatedBinding(binding:IBinding, bindingObject:Object, destinationObject:Object = null):void
        {
            if (!destinationObject)
            {
                destinationObject = _strand[bindingObject.destination[0]];
            }

            var destination:IStrand = destinationObject as IStrand;
            if (destination)
            {
                destination.addBead(binding as IBead);
            }
            else
            {
                if (destinationObject)
                {
                    binding.destination = destinationObject;
                    _strand.addBead(binding as IBead);
                }
                else
                {
                    deferredBindings[bindingObject.destination[0]] = binding;
                    IEventDispatcher(_strand).addEventListener("valueChange", deferredBindingsHandler);
                }
            }
        }

        /**
         * @flexjsignorecoercion Function
         */
        protected function setupWatchers(gb:GenericBinding, index:int, watchers:Array, parentWatcher:WatcherBase):void
        {
            var foundWatcher:Boolean = false;
            var n:int = watchers.length;

            for (var i:int = 0; i < n; i++)
            {
                var watcher:Object = watchers[i];
                var isValidWatcher:Boolean = false;
                if (typeof(watcher.bindings) == "number")
                {
                    isValidWatcher = (watcher.bindings == index);
                }
                else
                {
                    isValidWatcher = (watcher.bindings.indexOf(index) != -1);
                }

                if (isValidWatcher)
                {
                    var type:String = watcher.type;
                    var parentObj:Object = _strand;
                    switch (type)
                    {
                        case "static":
                        {
                            parentObj = watcher.parentObj;
                            gb.staticRoot = parentObj;
                            gb.isStatic = true;

                            break;
                        }
                        case "property":
                        {
                            var getterFunction:Function = watcher.getterFunction;
                            if (typeof(gb.source) === "function" && watcher.children == null)
                            {
                               getterFunction = gb.source as Function;
                            }

                            var pw:PropertyWatcher = new PropertyWatcher(_strand,
                                    watcher.propertyName,
                                    watcher.eventNames,
                                    getterFunction);
                            watcher.watcher = pw;
                            if (parentWatcher)
                            {
                                pw.parentChanged(parentWatcher.value);
                            }
                            else
                            {
                                pw.parentChanged(parentObj);
                            }

                            if (parentWatcher)
                            {
                                parentWatcher.addChild(pw);
                            }

                            if (watcher.children == null)
                            {
                                pw.addBinding(gb);
                            }

                            foundWatcher = true;
                            break;
                        }
                    }

                    if (watcher.children)
                    {
                        setupWatchers(gb, index, watcher.children.watchers, watcher.watcher);
                    }
                }
            }

            if (!foundWatcher)
            {
                // might be a binding to a function that doesn't have change events
                // so just force an update via parentWatcher (if it is set, null if not)
                if (parentWatcher)
                {
                    gb.valueChanged(parentWatcher.value);
                }
                else
                {
                    gb.valueChanged(null);
                }
            }
        }

        protected function decodeWatcher(bindingData:Array):Object
        {
            var watcherMap:Object = {};
            var watchers:Array = [];
            var n:int = bindingData.length;
            var index:int = 0;
            var watcherData:Object;
            while (index < n - 1)
            {
                var watcherIndex:int = bindingData[index++];
                var type:int = bindingData[index++];
                switch (type)
                {
                    case 0:
                    {
                        watcherData = { type: "function" };
                        watcherData.functionName = bindingData[index++];
                        watcherData.paramFunction = bindingData[index++];
                        watcherData.eventNames = bindingData[index++];
                        watcherData.bindings = bindingData[index++];
                        break;
                    }
                    case 1:
                    {
                        watcherData = { type: "static" };
                        watcherData.propertyName = bindingData[index++];
                        watcherData.eventNames = bindingData[index++];
                        watcherData.bindings = bindingData[index++];
                        watcherData.getterFunction = bindingData[index++];
                        watcherData.parentObj = bindingData[index++];
                        watcherMap[watcherData.propertyName] = watcherData;
                        break;
                    }
                    case 2:
                    {
                        watcherData = { type: "property" };
                        watcherData.propertyName = bindingData[index++];
                        watcherData.eventNames = bindingData[index++];
                        watcherData.bindings = bindingData[index++];
                        watcherData.getterFunction = bindingData[index++];
                        watcherMap[watcherData.propertyName] = watcherData;
                        break;
                    }
                    case 3:
                    {
                        watcherData = { type: "xml" };
                        watcherData.propertyName = bindingData[index++];
                        watcherData.bindings = bindingData[index++];
                        watcherMap[watcherData.propertyName] = watcherData;
                        break;
                    }
                }
                watcherData.children = bindingData[index++];
                if (watcherData.children != null)
                {
                    watcherData.children = decodeWatcher(watcherData.children);
                }
                watcherData.index = watcherIndex;
                watchers.push(watcherData);
            }
            return { watchers: watchers, watcherMap: watcherMap };
        }

        protected function makeConstantBinding(binding:Object):void
        {
            var cb:ConstantBinding = new ConstantBinding();
            cb.destinationPropertyName = binding.destination[1];
            if (binding.source is String) {
                cb.sourcePropertyName = binding.source;
            } else {
                cb.sourceID = binding.source[0];
                cb.sourcePropertyName = binding.source[1];
            }
            cb.setDocument(_strand);

            prepareCreatedBinding(cb as IBinding, binding);
        }

        private function deferredBindingsHandler(event:Event):void
        {
            for (var p:String in deferredBindings)
            {
                if (_strand[p] != null)
                {
                    var destination:IStrand = _strand[p] as IStrand;
                    if (destination)
                    {
                        destination.addBead(deferredBindings[p]);
                    }
                    else
                    {
                        var destObject:Object = _strand[p];
                        if (destObject)
                        {
                            deferredBindings[p].destination = destObject;
                            _strand.addBead(deferredBindings[p]);
                        }
                        else
                        {
                            trace("unexpected condition in deferredBindingsHandler");
                        }
                    }
                    delete deferredBindings[p];
                }
            }
        }
    }
}
