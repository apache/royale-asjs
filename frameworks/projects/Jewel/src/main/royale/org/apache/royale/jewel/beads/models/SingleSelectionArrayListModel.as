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
package org.apache.royale.jewel.beads.models
{
	import org.apache.royale.collections.ICollectionView;
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.events.Event;

    /**
     *  The SingleSelectionCollectionViewModel class is a selection model for
     *  a dataProvider that is an ICollectionView. It assumes that items
     *  can be fetched from the dataProvider using dataProvider.getItemAt(index).
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
	public class SingleSelectionArrayListModel extends SingleSelectionCollectionViewModel
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function SingleSelectionArrayListModel()
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
		override public function get dataProvider():Object
		{
			return _dataProvider;
		}

        /**
         *  @private
		 *  @royaleignorecoercion org.apache.royale.collections.ICollectionView
         */
		override public function set dataProvider(value:Object):void
		{
            if (value == _dataProvider) return;

			if (value is Array)
				_dataProvider = new ArrayList(value as Array);
			else
            	_dataProvider = value as ICollectionView;

			if(!_dataProvider || _selectedIndex >= _dataProvider.length)
				_selectedIndex = -1;
            
			_selectedItem = _selectedIndex == -1 ? null : _dataProvider.getItemAt(_selectedIndex);
			
			dispatchEvent(new Event("dataProviderChanged"));
		}

		private var _selectedIndex:int = -1;
		private var _selectedItem:Object;
        
	}
}
