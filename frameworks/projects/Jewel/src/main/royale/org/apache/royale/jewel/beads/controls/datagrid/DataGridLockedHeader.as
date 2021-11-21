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
package org.apache.royale.jewel.beads.controls.datagrid
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IDataGrid;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.IBead;
	import org.apache.royale.jewel.beads.views.DataGridView;
	import org.apache.royale.jewel.supportClasses.datagrid.DataGridButtonBar;

	/**
	 *  The DataGridLockedHeader bead class is a specialty bead that can be use with a Jewel DataGrid control
	 *  when need to fix the header
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.9
	 */
	public class DataGridLockedHeader implements IBead
	{
		public function DataGridLockedHeader()
		{
			super();
		}
        
		/**                         	
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.9
		 */
		public function set strand(value:IStrand):void
		{
            var dg:IDataGrid = value as IDataGrid;
            (dg as UIBase).style = "overflow: visible";

            var dgView:DataGridView = (dg as UIBase).view as DataGridView;
            (dgView.header as DataGridButtonBar).style = "position: sticky; top: 0; z-index: 200;";
		}
	}
}