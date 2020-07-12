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
package org.apache.royale.html.beads.models
{
	import org.apache.royale.html.IListPresentationModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.core.DispatcherBead;
	
	/**
	 *  The ListPresentationModel holds values used by list controls for presenting
	 *  their user interfaces.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ListPresentationModel extends DispatcherBead implements IListPresentationModel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ListPresentationModel()
		{
			super();
		}
		
		private var _rowHeight:Number = 30;
		
		/**
		 *  The height of each row.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get rowHeight():Number
		{
			return _rowHeight;
		}
		
		public function set rowHeight(value:Number):void
		{
			_rowHeight = value;
			dispatchEvent(new Event("rowHeightChanged"));
		}
		
		private var _separatorThickness:Number = 0;
		
		/**
		 *  The distance between rows.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get separatorThickness():Number
		{
			return _separatorThickness;
		}
		
		public function set separatorThickness(value:Number):void
		{
			_separatorThickness = value;
			dispatchEvent(new Event("separatorThicknessChanged"));
		}
		
	}
}
