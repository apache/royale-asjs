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
    import org.apache.flex.binding.ConstantBinding;
    import org.apache.flex.binding.GenericBinding;
    import org.apache.flex.binding.PropertyWatcher;
    import org.apache.flex.binding.SimpleBinding;
    import org.apache.flex.core.IBinding;
    import org.apache.flex.binding.WatcherBase;
    import org.apache.flex.core.IBead;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.events.Event;
    import org.apache.flex.events.IEventDispatcher;
    
    /**
     *  The MXMLBeadViewDataBinding class implements databinding for
     *  MXMLBeadView instances.  Different classes can have
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
	public class MXMLBeadViewDataBinding extends DataBindingBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function MXMLBeadViewDataBinding()
		{
			super();
		}

        override protected function initBindingsHandler(event:Event):void
        {
            super.initBindingsHandler(event);

            if (!("_bindings" in _strand))
                return;

            var fieldWatcher:Object;
            var sb:SimpleBinding;
            var bindingData:Array = _strand["_bindings"];
            var n:int = bindingData[0];
            var bindings:Array = [];
            var binding:Object = null;
            var i:int;
            var index:int = 1;
            for (i = 0; i < n; i++)
            {
                binding = {};
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
                            // can be simplebinding or constantbinding
                            var compWatcher:Object = watchers.watcherMap[binding.source[0]];

                            if (compWatcher)
                            {
                                fieldWatcher = compWatcher.children.watcherMap[binding.source[1]];
                            }

                            if (fieldWatcher && fieldWatcher.eventNames is String)
                            {
                                sb = new SimpleBinding();
                                sb.destinationPropertyName = binding.destination[1];
                                sb.eventName = fieldWatcher.eventNames as String;
                                sb.sourceID = binding.source[0];
                                sb.sourcePropertyName = binding.source[1];
                                sb.setDocument(_strand);

                                prepareCreatedBinding(sb as IBinding, binding);
                            }
                            else if (fieldWatcher && fieldWatcher.eventNames == null)
                            {
                                var cb:ConstantBinding = new ConstantBinding();
                                cb.destinationPropertyName = binding.destination[1];
                                cb.sourceID = binding.source[0];
                                cb.sourcePropertyName = binding.source[1];
                                cb.setDocument(_strand);

                                prepareCreatedBinding(cb as IBinding, binding);
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

                        prepareCreatedBinding(sb as IBinding, binding);
                    }
                }
                else
                {
                    makeGenericBinding(binding, i, watchers);
                }

                fieldWatcher = null;
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
    }
}
