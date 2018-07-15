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
package org.apache.royale.express
{
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.core.IBead;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.List;
	import org.apache.royale.html.beads.models.ArraySelectionModel;
	import org.apache.royale.html.beads.DataItemRendererFactoryForArrayData;
	import org.apache.royale.html.beads.DataItemRendererFactoryForArrayList;
	import org.apache.royale.html.beads.models.ArrayListSelectionModel;
	import org.apache.royale.html.beads.SingleSelectionDragSourceBead;
	import org.apache.royale.html.beads.SingleSelectionDragImageBead;
	import org.apache.royale.html.beads.SingleSelectionDropTargetBead;
	import org.apache.royale.html.beads.SingleSelectionDropIndicatorBead;

	/**
	 * The List class is a component that displays multiple data items take from a data source.
	 *
	 * @flexcomponent spark.components.List
	 * @flexdocurl https://flex.apache.org/asdoc/spark/components/List.html
	 * @commentary In Royale, the List component requires a data provider source and a class to be used as an itemRenderer to display the data.
	 * @commentary In the Royale Express package, data binding is prepackaged into the List component. The Royale Express List also includes support for scrolling as well as drag-and-drop.
	 * @example &lt;js:List dataProvider=\"{employees}\" itemRenderer=\"local.EmployeeCard\" /&gt;
	 */
	public class List extends org.apache.royale.html.List
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
