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
    import org.apache.royale.binding.ConstantBinding;
    import org.apache.royale.binding.GenericBinding;
    import org.apache.royale.binding.PropertyWatcher;
    import org.apache.royale.binding.SimpleBinding;
    import org.apache.royale.binding.WatcherBase;
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.core.IBinding;

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

        /**
         * @royaleignorecoercion org.apache.royale.core.IBinding
         * @royaleignorecoercion String
         * @private
         */
        override protected function processBindingData(bindingData:Array, first:int):void{
            var fieldWatcher:Object;
            var sb:SimpleBinding;

            var binding:Object = null;
            var n:int = bindingData[first];
            var bindings:Array = [];
            var i:int;
            var index:int = first + 1;
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
                    //for ItemRendererSimpleBinding we only want single level bindings via 'dataChange'
                    //because it only listens to top level 'dataChange', so fieldWatcher should be null here:
                    if (compWatcher && !fieldWatcher &&
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
                    else if (fieldWatcher != null
                            && fieldWatcher.eventNames is String
                            && compWatcher.eventNames is String)
                    {
                        sb = new SimpleBinding();
                        sb.destinationPropertyName = binding.destination[1];
                        sb.eventName = fieldWatcher.eventNames as String;
                        sb.sourceID = binding.source[0];
                        sb.setSourceEventName(compWatcher.eventNames as String);
                        sb.sourcePropertyName = binding.source[1];
                        sb.setDocument(_strand);

                        prepareCreatedBinding(sb as IBinding, binding);
                    }
                    else if (fieldWatcher == null || fieldWatcher.eventNames == null)
                    {
                        makeConstantBinding(binding);
                    } else {
                        makeGenericBinding(binding, i, watchers);
                    }
                }
                else
                {
                    makeGenericBinding(binding, i, watchers);
                }

                fieldWatcher = null;
            }
        }

    }
}
