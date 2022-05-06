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
package mx.controls.beads.models
{
    import mx.collections.ArrayCollection;
    import mx.collections.ICollectionView;
    import mx.collections.XMLListCollection;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;

    import org.apache.royale.core.IMenuBarModel;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
	
    /**
     *  MenuBar Mouse Controller
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class MenuBarModel extends SingleSelectionICollectionViewModel implements IMenuBarModel
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function MenuBarModel()
		{
		}
		
        private var _submenuField:String = "children";
        
        /**
         * The field in the data object that identifies sub-menus. The default is "menu". This
         * value is transferred to the CascadingMenu opened for each menu item.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function get submenuField():String
        {
            return _submenuField;
        }
        public function set submenuField(value:String):void
        {
            _submenuField = value;
            dispatchEvent(new Event("submenuFieldChanged"));
        }

        private var _showRoot:Boolean = true;
		
        /**
         *  showRoot
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get showRoot():Boolean
		{
            return _showRoot;
		}
        public function set showRoot(value:Boolean):void
        {
            _showRoot = value;
        }


        protected var _hasRoot:Boolean;
        public function get hasRoot():Boolean{
            return _hasRoot;
        }


        protected var _rootModel:ICollectionView;


        override public function set dataProvider(value:Object):void{
            if (_rootModel)
            {
                _rootModel.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
                        collectionChangeHandler);
            }
            _hasRoot = false;
            // handle strings and xml
            if (typeof(value)=="string")
                value = new XML(value);
            /*else if (value is XMLNode)
                value = new XML(XMLNode(value).toString());*/
            else if (value is XMLList)
                value = new XMLListCollection(value as XMLList);

            if (value is XML)
            {
                _hasRoot = true;
                var xl:XMLList = new XMLList();
                xl += value;
                _rootModel = new XMLListCollection(xl);
            }
            //if already a collection dont make new one
            else if (value is ICollectionView)
            {
                _rootModel = ICollectionView(value);
                if (_rootModel.length == 1)
                    _hasRoot = true;
            }
            else if (value is Array)
            {
                _rootModel = new ArrayCollection(value as Array);
            }
            //all other types get wrapped in an ArrayCollection
            else if (value is Object)
            {
                _hasRoot = true;
                // convert to an array containing this one item
                var tmp:Array = [];
                tmp.push(value);
                _rootModel = new ArrayCollection(tmp);
            }
            else
            {
                _rootModel = new ArrayCollection();
            }

            _rootModel.addEventListener(CollectionEvent.COLLECTION_CHANGE,
                    collectionChangeHandler, false/*, 0, true*/);
            super.dataProvider = _rootModel;
            var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.kind = CollectionEventKind.RESET;
            collectionChangeHandler(event);
            /*IEventDispatcher(_strand).*/dispatchEvent(event);
        }
	}
}
