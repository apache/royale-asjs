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
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.ItemRendererClassFactory;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.ButtonBar;
	import org.apache.royale.html.List;
	import org.apache.royale.html.Tree;
	import org.apache.royale.html.beads.layouts.TreeGridLayout;
	import org.apache.royale.html.beads.models.ArrayListSelectionModel;
	import org.apache.royale.html.beads.models.ButtonBarModel;
	import org.apache.royale.html.beads.models.TreeGridModel;
	import org.apache.royale.html.supportClasses.TreeGridColumn;
	import org.apache.royale.html.supportClasses.TreeGridControlItemRenderer;
	
	/**
	 * The TreeGridView class is responsible for creating the sub-components of the TreeGrid:
	 * the ButtonBar header, the Tree (first column), and Lists (rest of the columns), as well
	 * as the container that holds the columns. This bead will also add in a TreeGridLayout
	 * if one has not already been created or specified in CSS.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class TreeGridView implements IBeadView
	{
		/**
		 * Constructor.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function TreeGridView()
		{
		}
		
		private var _strand: IStrand;
		
		private var _controlColumn:Tree;
		private var controlColumnDataProvider:Object;
		
		private var _header: ButtonBar;
		
		/**
		 * The ButtonBar header for the TreeGrid.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get header(): ButtonBar
		{
			return _header;
		}
		
		private var _contentArea: UIBase;
		
		/**
		 * The component that contains the Tree/List columns.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get contentArea(): UIBase
		{
			return _contentArea;
		}
		
		private var _displayedColumns:Array;
		
		/**
		 * The array of the displayed columns with a Tree at index zero.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get displayedColumns():Array
		{
			return _displayedColumns;
		}
		
		public function get host():IUIBase
		{
			return _strand as IUIBase;
		}
		private function get uiHost():UIBase
		{
			return _strand as UIBase;
		}
		
		/**
		 * @see org.apache.royale.core.IStrand
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			(_strand as IEventDispatcher).addEventListener("beadsAdded", finishSetup);
		}
		
		private function finishSetup(event:Event):void
		{
			var layout:IBeadLayout = _strand.getBeadByType(TreeGridLayout) as IBeadLayout;
			if (layout == null) {
				var layoutClass:Class = ValuesManager.valuesImpl.getValue(_strand, "iBeadLayout") as Class;
				if (layoutClass != null) {
					layout = new layoutClass() as IBeadLayout;
				} else {
					layout = new TreeGridLayout(); // default
				}
				_strand.addBead(layout);
			}
			
			_contentArea = new UIBase();
			_contentArea.typeNames = "TreeGridContentArea";
			
			_header = new ButtonBar();
			_header.typeNames = "TreedGridHeader";
			
			var columnLabels:Array = [];
			
			var model:TreeGridModel = uiHost.model as TreeGridModel;
			_displayedColumns = [];
			
			for(var i:int=0; i < model.columns.length; i++) {
				var columnDef:TreeGridColumn = model.columns[i] as TreeGridColumn;
				
				columnLabels.push(columnDef.label);
				
				if (i == 0) {
					_controlColumn = new Tree();
					_controlColumn.typeNames = "TreeGridColumn";
					_controlColumn.dataProvider = model.dataProvider;
					_controlColumn.labelField = columnDef.dataField;
					
					_displayedColumns.push(_controlColumn);
					_contentArea.addElement(_controlColumn, false);
					
					_controlColumn.addEventListener("change", handleTreeChange);
					
					// remember this so all of the lists get the same model data
					controlColumnDataProvider = _controlColumn.model.dataProvider as ArrayList;
					(_controlColumn.model as IEventDispatcher).addEventListener("selectedIndexChanged", handleSelectedIndexChanged);
				}
				else {
					var columnList:List = new List();
					columnList.typeNames = "TreeGridColumn";
					
					columnList.model = new ArrayListSelectionModel();
					columnList.dataProvider = controlColumnDataProvider; 
					columnList.labelField = columnDef.dataField;
					columnList.addBead(new DynamicItemsRendererFactoryForArrayListData());
					
					_displayedColumns.push(columnList);
					_contentArea.addElement(columnList, false);
					
					(columnList.model as IEventDispatcher).addEventListener("selectedIndexChanged", handleSelectedIndexChanged);
				}
			}
			
			_header.dataProvider = columnLabels;
			uiHost.addElement(_header, false);
			
			uiHost.addElement(_contentArea, false);
			
			// request the layout to do its thing
			(_strand as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * Handles the changes to the tree nodes (open and close) and updates the other column
		 * lists to reflect that.
		 * 
		 * @private
		 */
		private function handleTreeChange(event:Event):void
		{
			var tree:Tree = event.currentTarget as Tree;
			for(var i:int=1; i < _displayedColumns.length; i++) {
				var columnList:List = _displayedColumns[i] as List;
				columnList.dataProvider = null;
				columnList.dataProvider = _controlColumn.model.dataProvider as ArrayList;
			}
		}
		
		/**
		 * Handles selection from one column and selects the same index in the other
		 * columns.
		 * 
		 * @private
		 */
		private function handleSelectedIndexChanged(event:Event):void
		{
			trace("selection changed on the model");
			if (event.currentTarget is ISelectionModel) {
				var newIndex:int = (event.currentTarget as ISelectionModel).selectedIndex;
				for(var i:int=0; i < _displayedColumns.length; i++) {
					_displayedColumns[i].selectedIndex = newIndex;
				}
			}
		}
	}
}