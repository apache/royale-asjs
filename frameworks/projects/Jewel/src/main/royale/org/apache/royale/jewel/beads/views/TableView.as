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
	import org.apache.royale.html.beads.DataContainerView;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.jewel.supportClasses.table.TBody;
	import org.apache.royale.jewel.supportClasses.table.THead;
	import org.apache.royale.jewel.supportClasses.table.TFoot;
	
	/**
	 *  The TableView class creates the visual elements of the org.apache.royale.jewel.Table component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class TableView extends DataContainerView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function TableView()
		{
        }

		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		private function get host():UIBase
		{
			return _strand as UIBase;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			//createChildren();
		}

		private var thead:THead;
		private var tbody:TBody;
		private var tfoot:TFoot;

		/**
		 * @private
		 */
		private function createChildren():void
		{
			thead = new THead();
			host.addElement(thead);

			tbody = new TBody();
			host.addElement(tbody);
			
			tfoot = new TFoot();
			host.addElement(tfoot);
		}
	}
}
