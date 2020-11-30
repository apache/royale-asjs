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
package org.apache.royale.html.beads
{
  import org.apache.royale.core.IStrand;
  import org.apache.royale.collections.CollectionUtils;
  import org.apache.royale.events.Event;
  import org.apache.royale.collections.ICollectionView;
  import org.apache.royale.core.ISelectionModel;
  import org.apache.royale.events.IEventDispatcher;
  import org.apache.royale.core.Bead;
  
  /**
	 *  The CollectionSelectedItemByField class is a specialty bead that can be used with
	 *  any control with ISelectionModel. This bead allows to select an item by field
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */

  public class CollectionSelectedItemByField extends Bead{

      protected var _model:ISelectionModel;

	  
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
      public function CollectionSelectedItemByField()
		{
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			_model = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			listenOnStrand("selectionChanged", selectionChangedHandler);
			updateHost();
		}

        private var _valueField:String;
        /**
		 *  The string that will be used for comparison field name
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get valueField():String
		{
			return _valueField;
		}
		public function set valueField(value:String):void
		{
				_valueField = value;
			updateHost();
		}

		private var _selectedValue:*;
		
		/**
		 *  Any kind of object to perform the comparison or select
		 *  the item with this value in the field.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get selectedValue():*{
			return _selectedValue;
		}

		public function set selectedValue(value:*):void{
			_selectedValue = value;
			updateHost();
		}
		
		/**
		 *  This bead allows update the selected item of the component through the entered field 
		 */
		protected function updateHost():void
		{
			if(_model && valueField != "" && selectedValue != null){
				var aux:* = CollectionUtils.getItemByField(_model.dataProvider as ICollectionView,valueField,selectedValue);
					if(aux == null){
						_model.selectedItem = null;
						_model.selectedIndex = -1;
					} else if (aux!==_model.selectedItem){
						_model.selectedItem = aux;
					}
			}
		}
		
		/**
		 *  Select the right item for the component.
		 * 
		 *  @param event 
		 */
		protected function selectionChangedHandler(event:Event):void{
			if(valueField != "" && _model){
				var selectedItem:Object = _model.selectedItem;
				if(selectedItem != null && selectedValue !== selectedItem[valueField])
					selectedValue = selectedItem[valueField];
			}
		}

  }   
}