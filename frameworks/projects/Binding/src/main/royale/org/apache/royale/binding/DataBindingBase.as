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
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.core.IBinding;

    /**
     *  The DataBindingBase class is the base class for custom data binding
     *  implementations that can be cross-compiled.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class DataBindingBase implements IBead
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DataBindingBase()
		{
		}

		protected var _strand:IStrand;

        protected var deferredBindings:Object;

        protected var initEventType:String = "initBindings";

        private var _initialized:Boolean;

        /**
         * This method is a way to manually initialize the binding support at an earlier time than would
         * happen by default ( this is usually the timing of 'initBindings' but could vary according to the
         * timing of whatever initTypeEvent is for a particular sub-class)
         * This can be useful in some cases when porting legacy code that expects bindings to be active
         * at a certain alternate time, e.g. before mxml content is created and assigned, for example.
         *
         * This method will be dead-code-eliminated in js-release builds if not used in an application's code
         *
         * @royalesuppressexport
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
        public function initializeNow():void{
            if (!_initialized) {
                IEventDispatcher(_strand).removeEventListener(initEventType, processBindings);
                processBindings(null);
            }
        }

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            if (!_initialized)
                IEventDispatcher(_strand).addEventListener(initEventType, processBindings);
        }

        private var _ancestry:Array;
        /**
		 *  @royaleignorecoercion Array
         */
        protected function processBindings(event:Event):void{
            if (!("_bindings" in _strand) ||  _initialized)
                return;
            _initialized = true;
            var bindingData:Array = _strand["_bindings"];
            var first:int = 0;
            if (bindingData[0] is Array) {
                _ancestry = [];
                //process ancestor bindings
                processAncestors(bindingData[0] as Array, _ancestry);
                first = 1;
            }
            processBindingData(bindingData, first);
        }

        /**
         *
         * @param array the binding data to process
         * @param strongRefs, an array to push the ancestry items into, stored in the 'parent' DataBindingBase as a private var
         *
         * @royaleignorecoercion org.apache.royale.binding.DataBindingBase
         * @royaleignorecoercion Class
         * @royaleignorecoercion Array
         */
        private function processAncestors(array:Array, strongRefs:Array):void{
            var first:int = 0;
            var inst:DataBindingBase;
            var bindingClass:Class = Object(this).constructor as Class;
            if (array[0] is Array) {
                //recurse into any more distant ancestors
                inst = new bindingClass() as DataBindingBase;
                inst._strand = _strand;
                strongRefs.push(inst);
                inst.processAncestors(array[0] as Array, strongRefs);
                first = 1;
            }
            inst = new bindingClass() as DataBindingBase;
            inst._strand = _strand;
            strongRefs.push(inst);
            inst.processBindingData(array, first)
        }

        protected function processBindingData(array:Array, first:int):void{

        }

        /**
         * @royaleemitcoercion org.apache.royale.core.IStrand
         * @royaleignorecoercion org.apache.royale.core.IBead
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
        protected function prepareCreatedBinding(binding:IBinding, bindingObject:Object, destinationObject:Object = null):void
        {
            if (!destinationObject)
            {
                if (bindingObject.destination[0] == 'this') destinationObject = _strand
                else destinationObject = _strand[bindingObject.destination[0]];
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
                    if (!deferredBindings) {
						deferredBindings = {};
						IEventDispatcher(_strand).addEventListener("valueChange", deferredBindingsHandler);
                    }
                    deferredBindings[bindingObject.destination[0]] = binding;
                }
            }
        }
        
        private function watcherChildrenRelevantToIndex(children:Object, index:int):Boolean{
            var watchers:Array = children ? children.watchers : null;
			var hasValidWatcherChild:Boolean = false;
            if (watchers) {
                var l:uint = watchers.length;
                while (l--) {
					var watcher:Object = watchers[l];
					if (typeof(watcher.bindings) == "number")
					{
						hasValidWatcherChild = (watcher.bindings == index);
					}
					else
					{
						hasValidWatcherChild = (watcher.bindings.indexOf(index) != -1);
					}
                    if (!hasValidWatcherChild && watcher.children){
						hasValidWatcherChild = watcherChildrenRelevantToIndex(watcher.children, index);
                    }
                    if (hasValidWatcherChild) break;
                }
            }
            return hasValidWatcherChild;
        }

        /**
         * @royaleignorecoercion Function
         * @royaleignorecoercion String
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
                    var hasWatcherChildren:Boolean = watcherChildrenRelevantToIndex(watcher.children, index);
                    var type:String = watcher.type as String;
                    var parentObj:Object = _strand;
                    var processWatcher:Boolean = false;
                    var pw:PropertyWatcher;
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
                            if (typeof(gb.source) === "function" && !hasWatcherChildren)
                            {
                               getterFunction = gb.source as Function;
                            }
                            pw = new PropertyWatcher(_strand,
                                    watcher.propertyName,
                                    watcher.eventNames,
                                    getterFunction);
                            processWatcher = true;
                            break;
                        }
                        case 'function': {
                            pw = new PropertyWatcher(_strand,
                                        watcher.propertyName,
                                        watcher.eventNames, null);
                            pw.funcProps = {};
                            pw.funcProps.functionName = watcher.functionName;
                            pw.funcProps.paramFunction = watcher.paramFunction;
                            processWatcher = true;
                            break;
                        }
                    }
                    if (processWatcher)
                    {
                        foundWatcher = true;
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
                        if (!hasWatcherChildren || watcherChildIsXML(watcher))
                        {
                            pw.addBinding(gb);
                        }
                    }
                    
                    if (hasWatcherChildren)
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
                    gb.valueChanged(parentWatcher.value, true);
                }
                else
                {
                    gb.valueChanged(null, true);
                }
            }
        }

		private function watcherChildIsXML(watcher:Object):Boolean
		{	
			return (watcher.children.watchers.length == 1 && watcher.children.watchers[0].type == "xml");
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

        /**
         * @royaleignorecoercion org.apache.royale.core.IBinding
         */
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

        protected function makeGenericBinding(binding:Object, index:int, watchers:Object):void
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
                gb.valueChanged(null, true);
            }
        }


        /**
         * @royaleemitcoercion org.apache.royale.core.IStrand
         */
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
