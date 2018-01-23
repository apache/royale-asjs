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

	public class DataGridButtonBarViewForMovableColumns extends DragDropListView
	{
		/**
		 * Constructor
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function DataGridButtonBarViewForMovableColumns()
		{
			super();
		}

		private var _strand:IStrand;

		/**
		 * @private
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;

			_strand.addBead(new ButtonBarReorderBead());
			_strand.addBead(new SingleSelectionDragImageBead());
			_strand.addBead(new SingleSelectionDropIndicatorBead());
		}
	}
}
