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
package org.apache.flex.core
{
    import org.apache.flex.binding.ConstantBinding;
    import org.apache.flex.binding.GenericBinding;
    import org.apache.flex.binding.PropertyWatcher;
    import org.apache.flex.binding.SimpleBinding;
    import org.apache.flex.binding.WatcherBase;
    import org.apache.flex.core.IBead;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.events.Event;
    import org.apache.flex.events.IEventDispatcher;
    
    /**
     *  The ApplicationDataBinding class implements databinding for
     *  Application instances.  Different classes can have
     *  different databinding implementation that optimize for
     *  the different lifecycles.  For example, an item renderer
     *  databinding implementation can wait to execute databindings
     *  until the data property is set.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class ApplicationDataBinding extends DataBindingBase implements IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ApplicationDataBinding()
		{
			super();
		}
        
        private var _strand:IStrand;
        
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
            IEventDispatcher(_strand).addEventListener("viewChanged", initCompleteHandler);
        }    

        private function initCompleteHandler(event:Event):void
        {
            var fieldWatcher:Object;
            var sb:SimpleBinding;
            if (!("_bindings" in _strand))
                return;
            var bindingData:Array = _strand["_bindings"];
            var n:int = bindingData[0];
            var bindings:Array = [];
            var i:int;
            var index:int = 1;
            for (i = 0; i < n; i++)
            {
                var binding:Object = {};
                binding.source = bindingData[index++];
				binding.destFunc = bindingData[index++];
                binding.destination = bindingData[index++];
                bindings.push(binding);
            }
            var watchers:Object = decodeWatcher(bindingData.slice(index));
            for (i = 0; i < n; i++)
            {
                    binding = bindings[i];
                if (binding.source is Array)
                {
                    if (binding.source[0] in _strand)
                    {
                        if (binding.source.length == 2 && binding.destination.length == 2)
                        {
                            // simple component.property binding
                            var destObject:Object;
                            var destination:IStrand;
                            // can be simplebinding or constantbinding
                            var compWatcher:Object = watchers.watcherMap[binding.source[0]];
                            fieldWatcher = compWatcher.children.watcherMap[binding.source[1]];
                            if (fieldWatcher.eventNames is String)
                            {
                                sb = new SimpleBinding();
                                sb.destinationPropertyName = binding.destination[1];
                                sb.eventName = fieldWatcher.eventNames as String;
                                sb.sourceID = binding.source[0];
                                sb.sourcePropertyName = binding.source[1];
                                sb.setDocument(_strand);
                                destObject = _strand[binding.destination[0]];                                
                                destination = destObject as IStrand;
                                if (destination)
                                    destination.addBead(sb);
                                else
                                {
                                    if (destObject)
                                    {
                                        sb.destination = destObject;
                                        _strand.addBead(sb);
                                    }
                                    else
                                    {
                                        deferredBindings[binding.destination[0]] = sb;
                                        IEventDispatcher(_strand).addEventListener("valueChange", deferredBindingsHandler);
                                    }
                                }
                            }
                            else if (fieldWatcher.eventNames == null)
                            {
                                var cb:ConstantBinding = new ConstantBinding();
                                cb.destinationPropertyName = binding.destination[1];
                                cb.sourceID = binding.source[0];
                                cb.sourcePropertyName = binding.source[1];
                                cb.setDocument(_strand);
                                destObject = _strand[binding.destination[0]];                                
                                destination = destObject as IStrand;
                                if (destination)
                                    destination.addBead(cb);
                                else
                                {
                                    if (destObject)
                                    {
                                        cb.destination = destObject;
                                        _strand.addBead(sb);
                                    }
                                    else
                                    {
                                        deferredBindings[binding.destination[0]] = sb;
                                        IEventDispatcher(_strand).addEventListener("valueChange", deferredBindingsHandler);
                                    }
                                }
                            }
                        }
                    }
                }
                else if (binding.source is String)
                {
                    fieldWatcher = watchers.watcherMap[binding.source];
                    if (fieldWatcher.eventNames is String)
                    {
                        sb = new SimpleBinding();
                        sb.destinationPropertyName = binding.destination[1];
                        sb.eventName = fieldWatcher.eventNames as String;
                        sb.sourcePropertyName = binding.source;
                        sb.setDocument(_strand);
                        destObject = _strand[binding.destination[0]];                                
                        destination = destObject as IStrand;
                        if (destination)
                            destination.addBead(sb);
                        else
                        {
                            if (destObject)
                            {
                                sb.destination = destObject;
                                _strand.addBead(sb);
                            }
                            else
                            {
                                deferredBindings[binding.destination[0]] = sb;
                                IEventDispatcher(_strand).addEventListener("valueChange", deferredBindingsHandler);
                            }
                        }
                    }
                }
                else
                {
                    makeGenericBinding(binding, i, watchers);
                }
            }
        }

        private function makeGenericBinding(binding:Object, index:int, watchers:Object):void
        {
            var gb:GenericBinding = new GenericBinding();
            gb.setDocument(_strand);
            gb.destinationData = binding.destination;
			gb.destinationFunction = binding.destFunc;
            gb.source = binding.source;
            setupWatchers(gb, index, watchers.watchers, null);
        }
        
        private function setupWatchers(gb:GenericBinding, index:int, watchers:Array, parentWatcher:WatcherBase):void
        {
            var n:int = watchers.length;
            for (var i:int = 0; i < n; i++)
            {
                var watcher:Object = watchers[i];
                if (watcher.bindings.indexOf(index) != -1)
                {
                    var type:String = watcher.type;
                    switch (type)
                    {
                        case "property":
                        {
                            var pw:PropertyWatcher = new PropertyWatcher(this, 
                                        watcher.propertyName, 
                                        watcher.eventNames,
                                        watcher.getterFunction);
                            watcher.watcher = pw;
                            if (parentWatcher)
                                pw.parentChanged(parentWatcher.value);
                            else
                                pw.parentChanged(_strand);
                            if (parentWatcher)
                                parentWatcher.addChild(pw);
                            if (watcher.children == null)
                                pw.addBinding(gb);
                            break;
                        }
                    }
                    if (watcher.children)
                    {
                        setupWatchers(gb, index, watcher.children, watcher.watcher);
                    }
                }
            }
        }
        
        private function decodeWatcher(bindingData:Array):Object
        {
            var watcherMap:Object = {};
            var watchers:Array = [];
            var n:int = bindingData.length;
            var index:int = 0;
            var watcherData:Object;
            // FalconJX adds an extra null to the data so make sure
            // we have enough data for a complete watcher otherwise
            // say we are done
            while (index < n - 2)
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
        
        private var deferredBindings:Object = {};
        private function deferredBindingsHandler(event:Event):void
        {
            for (var p:String in deferredBindings)
            {
                if (_strand[p] != null)
                {
                    var destination:IStrand = _strand[p] as IStrand;
                    destination.addBead(deferredBindings[p]);
                    delete deferredBindings[p];
                }
            }
        }
        
    }
}