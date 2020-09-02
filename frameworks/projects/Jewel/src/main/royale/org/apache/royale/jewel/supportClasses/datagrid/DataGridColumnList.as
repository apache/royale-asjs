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
package org.apache.royale.jewel.supportClasses.datagrid
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.jewel.DataGrid;
    import org.apache.royale.jewel.List;
    import org.apache.royale.jewel.beads.models.DataGridColumnListPresentationModel;
    import org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList;
    import org.apache.royale.jewel.supportClasses.list.IListPresentationModel;
    
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  @copy org.apache.royale.core.ISelectionModel#change
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    [Event(name="change", type="org.apache.royale.events.Event")]
    
    /**
     *  The DataGridColumnList class is the List class used internally
     *  by DataGrid for each column.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
	public class DataGridColumnList extends List implements IDataGridColumnList
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function DataGridColumnList()
		{
			super();
			typeNames = "jewel list column";
		}
		
        private var _columnInfo:IDataGridColumn;
        /**
         *  The DataGridColumn for this list
         *  
         *
         *  @toplevel
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.10.0
         * 
         *  @royalesuppresspublicvarwarning
         */
		public function get columnInfo():IDataGridColumn
        {
            return _columnInfo;
        }
		public function set columnInfo(value:IDataGridColumn):void
        {
            if(_columnInfo != value)
                _columnInfo = value;
        }

        private var _datagrid:DataGrid;
        /**
		 *  Pointer back to the DataGrid that owns this column List
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function get datagrid():DataGrid {
            return _datagrid;
        }
		public function set datagrid(value:DataGrid):void {
            _datagrid = value;
        }

        /**
		 *  The presentation model for the list.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.list.IListPresentationModel
		 */
		override public function get presentationModel():IBead
		{
			var presModel:IListPresentationModel = getBeadByType(IListPresentationModel) as IListPresentationModel;
			if (presModel == null) {
				presModel = new DataGridColumnListPresentationModel();
				addBead(presModel);
			}
			return presModel;
		}
	}
}
