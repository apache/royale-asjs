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
package org.apache.royale.jewel.beads.itemRenderers
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.jewel.beads.views.DataGridView;
	import org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList;

    /**
	 *  Handles the removal of all itemRenderer in a DataGrid component.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class RemoveAllDataGridItemRendererForArrayListData implements IBead
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function RemoveAllDataGridItemRendererForArrayListData()
		{
		}
		
		private var view:DataGridView;

		protected var _strand:IStrand;
		/**
		 * @copy org.apache.royale.core.IStrand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			view = UIBase(_strand).view as DataGridView;
            for (var i:int=0; i < view.columnLists.length; i++)
            {
                var list:IDataGridColumnList = view.columnLists[i] as IDataGridColumnList;
				var removeAllBead:RemoveAllItemRendererForArrayListData = new RemoveAllItemRendererForArrayListData();
				list.addBead(removeAllBead);
				removeAllBead.setUp();
            }
		}
	}
}
