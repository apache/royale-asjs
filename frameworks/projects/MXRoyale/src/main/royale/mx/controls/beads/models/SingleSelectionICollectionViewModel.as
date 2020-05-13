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
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
    import mx.collections.CursorBookmark;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
	
	import org.apache.royale.core.IRollOverModel;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;

    /**
     *  The SingleSelectionICollectionViewModel class is a selection model for
     *  a dataProvider that is an ICollectionView.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
	public class SingleSelectionICollectionViewModel extends EventDispatcher implements ISelectionModel, IRollOverModel
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function SingleSelectionICollectionViewModel()
		{
		}

		private var _strand:IStrand;

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}

		private var _dataProvider:ICollectionView;
        private var _cursor:IViewCursor;

        /**
         *  @copy org.apache.royale.core.ISelectionModel#dataProvider
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function get dataProvider():Object
		{
			return _dataProvider;
		}

        /**
         *  @private
		 *  @royaleignorecoercion org.apache.royale.collections.IList
         */
		public function set dataProvider(value:Object):void
		{
            if (value == _dataProvider) return;

            _dataProvider = value as ICollectionView;
            if (_dataProvider)
			{
                _cursor = _dataProvider.createCursor();
				dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
			if(!_dataProvider || _selectedIndex >= _dataProvider.length)
				_selectedIndex = -1;
            
			_selectedItem = _selectedIndex == -1 ? null : getItemAt(_selectedIndex);
			
			dispatchEvent(new Event("dataProviderChanged"));
		}

        private var lastIndex:int = -1;
        private function getItemAt(index:int):Object
        {
            if (index == 0)
            {
                if (lastIndex == 1)
				{
					_cursor.movePrevious();
				}
                else
				{
					_cursor.seek(CursorBookmark.FIRST);
				}
                lastIndex = 0;
            }
            else if (index + 1 == lastIndex)
			{
				_cursor.movePrevious();
			}
            else if (lastIndex + 1 == index)
			{
				_cursor.moveNext();
			}
            else
			{
				_cursor.seek(CursorBookmark.FIRST, index);
			}

            return _cursor.current;                
        }
        
		private var _selectedIndex:int = -1;
		private var _rollOverIndex:int = -1;
		private var _labelField:String = null;

        /**
         *  @copy org.apache.royale.core.ISelectionModel#labelField
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function get labelField():String
		{
			return _labelField;
		}

        /**
         *  @private
         */
		public function set labelField(value:String):void
		{
			if (value != _labelField) {
				_labelField = value;
				dispatchEvent(new Event("labelFieldChanged"));
			}
		}

        /**
         *  @copy org.apache.royale.core.ISelectionModel#selectedIndex
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

        /**
         *  @private
         */
		public function set selectedIndex(value:int):void
		{
            if (value == _selectedIndex) return;

			lastIndex = _selectedIndex;
			_selectedIndex = value;
			if (value == -1 || dataProvider == null)
			{
				_selectedItem = null;
			}
			else
			{
                if (value >= dataProvider.length)
                {
                    value = dataProvider.length - 1;
                    _selectedIndex = value;
                }
				_selectedItem = getItemAt(value);
			}

			dispatchEvent(new Event("selectedIndexChanged"));
		}

        /**
         *  @copy org.apache.royale.core.IRollOverModel#rollOverIndex
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function get rollOverIndex():int
		{
			return _rollOverIndex;
		}

        /**
         *  @private
         */
		public function set rollOverIndex(value:int):void
		{
			if (value != _rollOverIndex) {
				_rollOverIndex = value;
				dispatchEvent(new Event("rollOverIndexChanged"));
			}
		}

		private var _selectedItem:Object;

        /**
         *  @copy org.apache.royale.core.ISelectionModel#selectedItem
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function get selectedItem():Object
		{
			return _selectedItem;
		}

        /**
         *  @private
         */
		public function set selectedItem(value:Object):void
		{
            if (value == _selectedItem) return;

			_selectedItem = value;
			var n:int = _dataProvider.length;
			for (var i:int = 0; i < n; i++)
			{
				if (getItemAt(i) == value)
				{
					_selectedIndex = i;
					break;
				}
			}
			dispatchEvent(new Event("selectedItemChanged"));
			dispatchEvent(new Event("selectedIndexChanged"));
		}

		private var _selectedString:String;

        /**
         *  An alternative to selectedItem for strongly typing the
         *  the selectedItem if the Array is an Array of Strings.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function get selectedString():String
		{
			return String(_selectedItem);
		}

        /**
         *  @private
         */
		public function set selectedString(value:String):void
		{
			_selectedString = value;
			var n:int = _dataProvider.length;
			for (var i:int = 0; i < n; i++)
			{
				if (String(getItemAt(i)) == value)
				{
					_selectedIndex = i;
					break;
				}
			}
			dispatchEvent(new Event("selectedItemChanged"));
			dispatchEvent(new Event("selectedIndexChanged"));
		}
		
		protected function collectionChangeHandler(event:CollectionEvent):void
		{
			if (event.kind == CollectionEventKind.ADD)
			{
				if (event.location <= _selectedIndex)
				{
					_selectedIndex++;
					dispatchEvent(new Event("selectedIndexChanged"));
				}
			}
			else if (event.kind == CollectionEventKind.REMOVE)
			{
				if (event.location < _selectedIndex)
				{
					_selectedIndex--;
					dispatchEvent(new Event("selectedIndexChanged"));
				}
				else if (event.location == _selectedIndex)
				{
					_selectedItem = null;
					_selectedIndex = -1;
					dispatchEvent(new Event("selectedItemChanged"));
					dispatchEvent(new Event("selectedIndexChanged"));
				}
			}
		}
	}
}
