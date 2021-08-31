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
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.jewel.supportClasses.combobox.IComboBoxPresentationModel;
	
	/**
	 *  The ComboBoxPresentationModel class contains the data to present the popup list
	 *  of the org.apache.royale.jewel.ComboBox along with the rowCount, the height of the rows or
	 *  the align of column labels. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class ComboBoxPresentationModel extends ListPresentationModel implements IComboBoxPresentationModel
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function ComboBoxPresentationModel()
		{
			super();	
		}

		private var _rowCount:int = 5;
		/**
		 *  Maximum number of rows visible in the ComboBox popup list.
		 *  If there are fewer items in the dataProvider, the ComboBox shows only as many items as there are in the dataProvider.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		[Bindable("rowCountChanged")]
		public function get rowCount():int
		{
			return _rowCount;
		}
    	public function set rowCount(value:int):void
		{
			if (value != _rowCount) {
				_rowCount = value;
				if(_strand)
					(_strand as IEventDispatcher).dispatchEvent(new Event("rowCountChanged"));
			}
		}
	}
}
