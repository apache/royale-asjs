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
    import org.apache.flex.binding.WatcherBase;
    import org.apache.flex.core.IBead;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.events.Event;
    import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.core.IBinding;

    /**
     *  The ItemRendererDataBinding class implements databinding for
     *  ItemRenderer instances.  Different classes can have
     *  different databinding implementation that optimize for
     *  the different lifecycles.  For example, an item renderer
     *  databinding implementation can wait to execute databindings
     *  until the data property is set.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ItemRendererDataBinding extends DataBindingBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ItemRendererDataBinding()
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

                if (binding.source is String)
                {
                    fieldWatcher = watchers.watcherMap[binding.source];
                    if (!fieldWatcher)
                    {
                        makeConstantBinding(binding);
                    }
                    else if (fieldWatcher.eventNames is String)
                    {
                        var isStatic:Boolean = fieldWatcher.type == "static";
                        sb = new SimpleBinding(isStatic);
                        sb.destinationPropertyName = binding.destination[1];
                        sb.eventName = fieldWatcher.eventNames as String;
                        sb.sourcePropertyName = binding.source;
                        if (isStatic)
                        {
                            sb.setDocument(fieldWatcher.parentObj);
                        }
                        else
                        {
                            sb.setDocument(_strand);
                        }

                        prepareCreatedBinding(sb as IBinding, binding);
                    }
                }
                else if (binding.source is Array
                        && binding.source.length == 2 && binding.destination.length == 2)
                {
                    var compWatcher:Object = watchers.watcherMap[binding.source[0]];
                    if (compWatcher)
                    {
                        fieldWatcher = compWatcher.children.watcherMap[binding.source[1]];
                    }

                    if (compWatcher && fieldWatcher &&
                            (binding.source[0] == "data" ||
                            (compWatcher.eventNames is String &&
                            compWatcher.eventNames == "dataChange")))
                    {
                        var irsb:ItemRendererSimpleBinding = new ItemRendererSimpleBinding();
                        irsb.destinationID = binding.destination[0];
                        irsb.destinationPropertyName = binding.destination[1];
                        irsb.sourcePropertyName = binding.source[1];
                        irsb.setDocument(_strand);
                        _strand.addBead(irsb);
                    }
                    else if (fieldWatcher != null && fieldWatcher.eventNames is String)
                    {
                        sb = new SimpleBinding();
                        sb.destinationPropertyName = binding.destination[1];
                        sb.eventName = fieldWatcher.eventNames as String;
                        sb.sourceID = binding.source[0];
                        sb.sourcePropertyName = binding.source[1];
                        sb.setDocument(_strand);

                        prepareCreatedBinding(sb as IBinding, binding);
                    }
                    else if (fieldWatcher == null || fieldWatcher.eventNames == null)
                    {
                        makeConstantBinding(binding);
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
