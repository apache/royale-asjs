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
    import org.apache.flex.binding.ChainBinding;
    import org.apache.flex.binding.ConstantBinding;
    import org.apache.flex.binding.GenericBinding;
    import org.apache.flex.binding.PropertyWatcher;
    import org.apache.flex.binding.SimpleBinding;
    import org.apache.flex.binding.WatcherBase;
    import org.apache.flex.core.IBead;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.events.Event;
    import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.core.IBinding;

    /**
     *  The ContainerDataBinding class implements databinding for
     *  Container instances.  Place a ContainerDataBinding tag into
     *  the MXML file that has Container as its root tag.
     *  Different classes can have
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
	public class ContainerDataBinding extends DataBindingBase implements IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ContainerDataBinding()
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
            var cb:ConstantBinding;
            var bindingData:Array = _strand["_bindings"];
            var binding:Object = null;
            var n:int = bindingData[0];
            var bindings:Array = [];
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
                        var compWatcher:Object;
                        if (binding.source.length == 2 && binding.destination.length == 2)
                        {
                            // simple component.property binding
                            // can be simplebinding or constantbinding
                            compWatcher = watchers.watcherMap[binding.source[0]];
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
                                cb = new ConstantBinding();
                                cb.destinationPropertyName = binding.destination[1];
                                cb.sourceID = binding.source[0];
                                cb.sourcePropertyName = binding.source[1];
                                cb.setDocument(_strand);

                                prepareCreatedBinding(cb as IBinding, binding);
                            }
                        }
                        else
                        {
                            compWatcher = watchers.watcherMap[binding.source[0]];
                            var chb:ChainBinding = new ChainBinding();
                            chb.destination = binding.destination;
                            chb.source = binding.source;
                            chb.watcherChain = compWatcher;
                            chb.setDocument(_strand);
                            _strand.addBead(chb);
                        }
                    }
                }
                else if (binding.source is String && binding.destination is Array)
                {
                    fieldWatcher = watchers.watcherMap[binding.source];
                    if (fieldWatcher == null)
                    {
                        cb = new ConstantBinding();
                        cb.destinationPropertyName = binding.destination[1];
                        cb.sourcePropertyName = binding.source;
                        cb.setDocument(_strand);
                        var destinationObject:Object = null;
                        if (binding.destination[0] == "this")
                        {
                            destinationObject = _strand;
                        }
                        else
                        {
                            destinationObject = _strand[binding.destination[0]];
                        }

                        prepareCreatedBinding(cb as IBinding, binding, destinationObject);
                    }
                    else if (fieldWatcher.eventNames is String)
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
            if (watchers.watchers.length)
            {
                setupWatchers(gb, index, watchers.watchers, null);
            }
            else
            {
                // should be a constant expression.
                // the value doesn't matter as GenericBinding
                // should get the value from the source
                gb.valueChanged(null);  
            }
        }
    }
}
