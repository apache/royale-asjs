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
package mx.controls.beads
{
	import mx.controls.AdvancedDataGrid;
	import mx.controls.beads.DataGridView;
	import mx.events.AdvancedDataGridEvent;
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.DataGridButtonBar;
    
	public class AdvancedDataGridSortBead implements IBead
	{
		public function AdvancedDataGridSortBead()
		{
			super();
		}
		
        private var adg:AdvancedDataGrid;
        
		/**                         	
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function set strand(value:IStrand):void
		{
            adg = value as AdvancedDataGrid;
			(adg.view as DataGridView).header.addEventListener(MouseEvent.CLICK, mouseClickHandler, false);
		}
		
		/**
		 * @private
		 */
		private function mouseClickHandler(event:MouseEvent):void
		{
            var adgEvent:AdvancedDataGridEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.SORT);
            adgEvent.columnIndex = ((adg.view as DataGridView).header as DataGridButtonBar).selectedIndex;
            adgEvent.dataField = adg.columns[adgEvent.columnIndex].dataField;
            adg.dispatchEvent(adgEvent);
		}
	}
}