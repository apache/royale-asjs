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
package org.apache.royale.jewel.beads.views
{
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IStrandWithModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.ITableView;
	import org.apache.royale.jewel.beads.views.ListView;
	import org.apache.royale.jewel.supportClasses.table.TFoot;
	import org.apache.royale.jewel.supportClasses.table.THead;
	
	/**
	 *  The TableView class creates the visual elements of the org.apache.royale.jewel.Table component.
	 * 
	 *  It creates a TBody, and defines THead and TFoot optional parts to be created by a mapper
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class TableView extends ListView implements ITableView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function TableView()
		{
			super();
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		override protected function handleInitComplete(event:Event):void
		{
			super.handleInitComplete(event);
			listModel.addEventListener("columnsChanged", columnsChangedHandler);
		}

		/**
		 * When columns change, trigger a data provider change to redo all table
		 */
		protected function columnsChangedHandler(event:Event):void
		{
			IStrandWithModel(_strand).model.dispatchEvent(new Event("dataProviderChanged"));
		}

		/**
		 * @royalesuppresspublicvarwarning
		 */
		protected var thead:THead;
		/**
		 *  The component which parents the header elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function get header():IParent
		{
			return thead;
		}
		public function set header(value:IParent):void
		{
			thead = value as THead;
		}
		
		/**
		 * @royalesuppresspublicvarwarning
		 */
		protected var tfoot:TFoot;
		/**
		 *  The component which parents the footer elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function get footer():IParent
		{
			return tfoot;
		}
		public function set footer(value:IParent):void
		{
			tfoot = value as TFoot;
		}
	}
}
