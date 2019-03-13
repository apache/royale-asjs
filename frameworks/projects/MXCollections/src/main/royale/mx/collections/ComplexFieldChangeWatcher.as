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

package mx.collections {
    
	// import flash.events.EventDispatcher;
	import org.apache.royale.events.EventDispatcher;
	
	// import flash.utils.Dictionary;

    import mx.binding.utils.ChangeWatcher;
    import mx.core.mx_internal;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    import mx.events.PropertyChangeEvent;

    public class ComplexFieldChangeWatcher extends EventDispatcher
    {
        // private var _complexFieldWatchers:Dictionary = new Dictionary(true);
        private var _list:IList;
        private var _listCollection:ICollectionView;

        public function stopWatchingForComplexFieldChanges():void
        {
            unwatchListForChanges();
            unwatchAllItems();
        }

        private function unwatchAllItems():void
        {
            /*for(var item:Object in _complexFieldWatchers)
            {
                unwatchItem(item);
                delete _complexFieldWatchers[item];
            }*/
        }

        private function unwatchArrayOfItems(items:Array):void
        {
            for(var i:int = 0; i < items.length; i++)
            {
                unwatchItem(items[i]);
            }
        }

        private function unwatchItem(item:Object):void
        {
            /*var watchersForItem:Array = _complexFieldWatchers[item] as Array;
            while(watchersForItem && watchersForItem.length)
            {
                var watcher:ChangeWatcher = watchersForItem.pop() as ChangeWatcher;
                if(watcher)
                    watcher.unwatch();
            }*/
        }

        public function startWatchingForComplexFieldChanges():void
        {
            watchListForChanges();
            watchAllItems();
        }

        private function watchAllItems():void
        {
            watchItems(list);
        }

        private function watchItems(items:IList):void
        {
            if(sortFields)
            {
                for(var i:int = 0; i < items.length; i++)
                {
                    watchItem(items.getItemAt(i), sortFields);
                }
            }
        }

        private function watchArrayOfItems(items:Array):void
        {
            if(sortFields)
            {
                for(var i:int = 0; i < items.length; i++)
                {
                    watchItem(items[i], sortFields);
                }
            }
        }

        private function watchItem(item:Object, fieldsToWatch:Array):void
        {
            if(item)
            {
                for(var i:int = 0; i < fieldsToWatch.length; i++)
                {
                    var sortField:IComplexSortField = fieldsToWatch[i] as IComplexSortField;
                    if(sortField && sortField.nameParts)
                    {
                        watchItemForField(item, sortField.nameParts);
                    }
                }
            }
        }

        private function watchItemForField(item:Object, chain:Array):void
        {
            /*var watcher:ChangeWatcher = ChangeWatcher.watch(item, chain, new Closure(item, onComplexValueChanged).callFunctionOnObject, false, true);
            if(watcher)
            {
                addWatcher(watcher, item);
            }*/
        }

        private function addWatcher(watcher:ChangeWatcher, forItem:Object):void
        {
            /*if(!_complexFieldWatchers[forItem])
                _complexFieldWatchers[forItem] = [];
            (_complexFieldWatchers[forItem] as Array).push(watcher);*/
        }

        private function onComplexValueChanged(item:Object):void
        {
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(item, null, null, null));
        }

        private function get sortFields():Array
        {
            return _listCollection && _listCollection.sort ? _listCollection.sort.fields : null;
        }

        mx_internal function set list(value:IList):void
        {
            if(_list != value)
            {
                stopWatchingForComplexFieldChanges();

                _list = value;
                _listCollection = value as ICollectionView;
            }
        }

        protected function get list():IList
        {
            return _list;
        }

        private function watchListForChanges():void
        {
            /*if(list)
                list.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChanged, false, 0, true);*/
        }

        private function unwatchListForChanges():void
        {
            if(list)
                list.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChanged);
        }

        private function onCollectionChanged(event:CollectionEvent):void
        {
            switch(event.kind)
            {
                case CollectionEventKind.ADD: {
                    watchArrayOfItems(event.items);
                    break;
                }
                case CollectionEventKind.REMOVE: {
                    unwatchArrayOfItems(event.items);
                    break;
                }
                case CollectionEventKind.REFRESH:
                case CollectionEventKind.RESET:
                {
                    reset();
                    break;
                }
            }
        }

        private function reset():void
        {
            unwatchAllItems();
            watchAllItems();
        }
    }
}

// import flash.events.Event;
import org.apache.royale.events.Event;

class Closure
{
    private var _object:Object;
    private var _function:Function;

    public function Closure(cachedObject:Object, cachedFunction:Function)
    {
        _object = cachedObject;
        _function = cachedFunction;
    }

    public function callFunctionOnObject(event:Event):void
    {
        _function.apply(null, [_object]);
    }
}