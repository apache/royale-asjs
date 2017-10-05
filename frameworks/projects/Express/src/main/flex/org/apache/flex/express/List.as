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
package org.apache.flex.express
{
	import org.apache.flex.collections.ArrayList;
	import org.apache.flex.core.IBead;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.List;
	import org.apache.flex.html.beads.DataItemRendererFactoryForArrayData;
	import org.apache.flex.html.beads.DataItemRendererFactoryForArrayList;
	import org.apache.flex.html.beads.models.ArrayListSelectionModel;
	import org.apache.flex.html.beads.models.ArraySelectionModel;
	import org.apache.flex.html.beads.SingleSelectionDragSourceBead;
	import org.apache.flex.html.beads.SingleSelectionDragImageBead;
	import org.apache.flex.html.beads.SingleSelectionDropTargetBead;
	import org.apache.flex.html.beads.SingleSelectionDropIndicatorBead;
	
	public class List extends org.apache.flex.html.List
	{
		public function List()
		{
			super();
		}
		
		private var _dragEnabled:Boolean = false;
		public function get dragEnabled():Boolean
		{
			return _dragEnabled;
		}
		public function set dragEnabled(value:Boolean):void
		{
			_dragEnabled = value;
		}
		
		private var _dropEnabled:Boolean = false;
		public function get dropEnabled():Boolean
		{
			return _dropEnabled;
		}
		public function set dropEnabled(value:Boolean):void
		{
			_dropEnabled = value;
		}
		
		override public function addedToParent():void
		{
			super.addedToParent();
			
			if (dragEnabled) {
				addBead(new SingleSelectionDragSourceBead());
				addBead(new SingleSelectionDragImageBead());
			}
			if (dropEnabled) {
				addBead(new SingleSelectionDropTargetBead());
				addBead(new SingleSelectionDropIndicatorBead());
			}
		}
		
		override public function set dataProvider(value:Object):void
		{			
			if (value is Array) {
				// see if ArrayList beads are present and if so, remove them.
				// see if Array beads are present and if not, add them.
				
				if (model != null) {
					removeBead(model as IBead);
				}
				var newModel:ArraySelectionModel = new ArraySelectionModel();
				addBead(newModel);
				
				var oldFactory1:Object = getBeadByType(DataItemRendererFactoryForArrayList);
				if (oldFactory1 != null) {
					removeBead(oldFactory1 as IBead);
				}
				var newFactory1:DataItemRendererFactoryForArrayData = new DataItemRendererFactoryForArrayData();
				addBead(newFactory1);
			}
			else if (value is ArrayList) {
				// see if Array beads are present and if so, remove them.
				// see if ArrayList beads are present and if not, add them.
				
				if (model != null) {
					removeBead(model as IBead);
				}
				var newListModel:ArrayListSelectionModel = new ArrayListSelectionModel();
				addBead(newListModel);
				
				var oldFactory2:Object = getBeadByType(DataItemRendererFactoryForArrayData);
				if (oldFactory2 != null) {
					removeBead(oldFactory2 as IBead);
				}
				var newFactory2:DataItemRendererFactoryForArrayList = new DataItemRendererFactoryForArrayList();
				addBead(newFactory2);
			}
			
			super.dataProvider = value;
			
			// since the model and factory were pushed programmatically onto the strand after the original
			// cycle of beads, generated an artifical "beadsAdded" to let these new beads it is OK to continue
			// the start-up process.
			dispatchEvent(new Event("beadsAdded"));
		}
	}
}
