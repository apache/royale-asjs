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
package org.apache.flex.html.beads
{
	import org.apache.flex.core.IStrand;
 	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IDataGridModel;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.DataGrid;

		/**
		 *  The DataGridColumnReorderView bead extends DataGridView and
		 *  lists for changes to the model that is used to produce the column
		 *  header. When this model changes, this view bead also changes the
		 *  sub-components to match.
		 *
		 *  @viewbead
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public class DataGridColumnReorderView extends DataGridView
		{
			/**
			 *  constructor.
			 *
			 *  @langversion 3.0
			 *  @playerversion Flash 10.2
			 *  @playerversion AIR 2.6
			 *  @productversion Royale 0.0
			 */
			public function DataGridColumnReorderView()
			{
				super();
			}

			private var _strand:IStrand;


			/**
			 *  @copy org.apache.flex.core.IBead#strand
			 *
			 *  @langversion 3.0
			 *  @playerversion Flash 10.2
			 *  @playerversion AIR 2.6
			 *  @productversion Royale 0.0
			 */
			override public function set strand(value:IStrand):void
			{
				super.strand = value;
				_strand = value;
			}

			/**
			 * @private
			 */
			override protected function finishSetup(event:Event):void
			{
				super.finishSetup(event);

				 var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
				IEventDispatcher(sharedModel).addEventListener("headerModelChanged", handleHeaderModelChanged);
			}

			/**
			 * @private
			 */
			private function handleHeaderModelChanged(event:Event):void
			{
				 trace("** Detected that the DataGrid's header has changed in some way");
				 var host:DataGrid = _strand as DataGrid;
				 var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;

				 host.removeElement(header);
				 host.removeElement(listArea);

				 IEventDispatcher(sharedModel).removeEventListener("headerModelChanged", handleHeaderModelChanged);
				 refreshContent();
			}
		}
}

