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
package org.apache.royale.html.beads.models
{
	import org.apache.royale.collections.ICollectionView;
	import org.apache.royale.core.DispatcherBead;
	import org.apache.royale.core.IMultiSelectionModel;
	import org.apache.royale.core.IRollOverModel;
	import org.apache.royale.events.Event;

    /**
     *  The MultiSelectionCollectionViewModel class is a selection model for
     *  a dataProvider that is an ICollectionView. It assumes that items
     *  can be fetched from the dataProvider using dataProvider.getItemAt(index).
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
	public class MultiSelectionCollectionViewModel extends DispatcherBead implements IRollOverModel, IMultiSelectionModel
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function MultiSelectionCollectionViewModel()
		{
		}

		private var _dataProvider:ICollectionView;

		[Bindable("dataProviderChanged")]
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
		 *  @royaleignorecoercion org.apache.royale.collections.ICollectionView
         */
		public function set dataProvider(value:Object):void
		{
            if (value == _dataProvider) return;

            _dataProvider = value as ICollectionView;
			// if(!_dataProvider || _selectedIndex >= _dataProvider.length)
			// 	_selectedIndex = -1;
            
			// _selectedItem = _selectedIndex == -1 ? null : _dataProvider.getItemAt(_selectedIndex);
			if(_dataProvider && _selectedIndices)
			{
				var indices:Array = [];
				var length:int = value.length;
				for (var i:int = 0; i < _selectedIndices.length; i++)
				{
					if (_selectedIndices[i] < length)
					{
						indices.push(value.getItemAt(_selectedIndices[i]));
					}
					_selectedIndices = indices;
					syncItemsAndIndices();
				}
			}
			dispatchEvent(new Event("dataProviderChanged"));
		}

		private var _selectedIndices:Array = null;
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
         *  @copy org.apache.royale.core.ISelectionModel#selectedIndices
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function get selectedIndices():Array
		{
			return _selectedIndices;
		}

        /**
         *  @private
         */
		public function set selectedIndices(value:Array):void
		{
            if (value == _selectedIndices) return;

			_selectedIndices = value;
			// _selectedItem = (value == -1 || _dataProvider == null) ? null : (value < _dataProvider.length) ? _dataProvider.getItemAt(value) : null;
			if (value == null || dataProvider == null)
			{
				_selectedItems = null;
			} else
			{
				syncItemsAndIndices();
			}
			dispatchEvent(new Event("selectedItemsChanged"));
			dispatchEvent(new Event("selectedIndicesChanged"));
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

		private var _selectedItems:Array;

        /**
         *  @copy org.apache.royale.core.ISelectionModel#selectedItem
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function get selectedItems():Array
		{
			return _selectedItems;
		}

        /**
         *  @private
         */
		public function set selectedItems(value:Array):void
		{
            if (value == _selectedItems) return;

			_selectedItems = value;
			_selectedIndices = [];
			// var n:int = _dataProvider.length;
			for (var i:int = 0; i < value.length; i++)
			{
				_selectedIndices.push(_dataProvider.getItemIndex(value[i]));
				// if (_dataProvider.getItemAt(i) == value)
				// {
				// 	_selectedIndex = i;
				// 	break;
				// }
			}
			dispatchEvent(new Event("selectedItemsChanged"));
			dispatchEvent(new Event("selectedIndicesChanged"));
		}
		private function syncItemsAndIndices():void
		{
			var items:Array = [];
			for (var i:int = 0; i < _selectedIndices.length; i++)
			{
				items.push(dataProvider.getItemAt(_selectedIndices[i]));
			}
			_selectedItems = items;
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
			var arr:Array = [];
			for(var i:int =0;i<_selectedItems.length;i++){
				arr.push(_selectedItems[i]);
			}
			return String( arr.join(',')); 
		}

        /**
         *  @private
         */
		public function set selectedString(value:String):void
		{
			var arr:Array = value.split(/[,\s]+/);
			_selectedString = value;
			_selectedIndices = [];
			var n:int = _dataProvider.length;
			for (var i:int = 0; i < n; i++)
			{
				// _selectedIndices.push(_dataProvider.getItemIndex(arr[i]));
				if (String(_dataProvider.getItemAt(i)) == value)
				{
					selectedIndices.push(i);
					break;
				}
			}
			dispatchEvent(new Event("selectedItemsChanged"));
			dispatchEvent(new Event("selectedIndicesChanged"));
		}
	}
}
