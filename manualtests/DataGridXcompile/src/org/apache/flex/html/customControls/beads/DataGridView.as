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
package org.apache.flex.html.customControls.beads
{
//	import flash.display.DisplayObject;
//	import flash.display.DisplayObjectContainer;
//	import flash.display.Shape;
	
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IDataGridModel;
	import org.apache.flex.core.IDataGridPresentationModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.ButtonBar;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.List;
	import org.apache.flex.html.SimpleList;
	import org.apache.flex.html.beads.layouts.HorizontalLayout;
	import org.apache.flex.html.beads.models.ArraySelectionModel;
	
	public class DataGridView implements IDataGridView
	{
		public function DataGridView()
		{
		}
		
//		private var background:Shape;
		private var buttonBar:ButtonBar;
		private var buttonBarModel:ArraySelectionModel;
		private var columnContainer:Container;
		private var columns:Array;
		
		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
//			background = new Shape();
//			DisplayObjectContainer(_strand).addChild(background);
			
			var pm:IDataGridPresentationModel = _strand.getBeadByType(IDataGridPresentationModel) as IDataGridPresentationModel;
			buttonBarModel = new ArraySelectionModel();
			buttonBarModel.dataProvider = pm.columnLabels;
			buttonBar = new ButtonBar();
			buttonBar.addBead(buttonBarModel);
			buttonBar.height = 20;
			buttonBar.width = UIBase(_strand).width;
			UIBase(_strand).addElement(buttonBar);
			
			columnContainer = new Container();
			var layout:HorizontalLayout = new HorizontalLayout();
			columnContainer.addBead(layout);
			UIBase(_strand).addElement(columnContainer);
			
			var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
			var columnWidth:Number = UIBase(_strand).width / pm.columnLabels.length;
			var columnHeight:Number = UIBase(_strand).height - buttonBar.height;
			
			columns = new Array();
			for(var i:int=0; i < pm.columnLabels.length; i++) {
				var column:List = new List();
				var columnView:DataGridColumnView = new DataGridColumnView();
				columnView.labelField = sharedModel.labelFields[i];
				var factory:DataItemRendererFactoryForColumnData = new DataItemRendererFactoryForColumnData();
				columnView.columnIndex = i;
				column.width = columnWidth;
				column.height = columnHeight;
				column.addBead(sharedModel);
				column.addBead(columnView);
				column.addBead(factory);
				columnContainer.addElement(column);
				columns.push(column);
				
				column.addEventListener('change',columnListChangeHandler);
			}
			
			IEventDispatcher(_strand).addEventListener("widthChanged",handleSizeChange);
			IEventDispatcher(_strand).addEventListener("heightChanged",handleSizeChange);
			
			handleSizeChange(null); // initial sizing
		}
		
		private function handleSizeChange(event:Event):void
		{
			var sw:Number = UIBase(_strand).width;
			var sh:Number = UIBase(_strand).height;
			
/*			var backgroundColor:Number = 0xDDDDDD;
			var value:Object = ValuesManager.valuesImpl.getValue(_strand, "background-color");
			if (value != null) backgroundColor = Number(value);*/
			
/*			background.graphics.clear();
			background.graphics.beginFill(backgroundColor);
			background.graphics.drawRect(0,0,sw,sh);
			background.graphics.endFill();*/
			
			buttonBar.x = 0;
			buttonBar.y = 0;
			buttonBar.width = sw;
			buttonBar.height = 25;
			
			columnContainer.x = 0;
			columnContainer.y = 30;
			columnContainer.width = sw;
			columnContainer.height = sh - 25;
			
			for(var i:int=0; i < columns.length; i++) {
				var column:List = columns[i];
			
				var cw:Number = sw/(columns.length);
				column.x = i*cw; // should be positioned by the Container's layout
				column.y = 0;
				column.width = cw;
				column.height = columnContainer.height; // this will actually be Nitem*rowHeight
			}
		}
		
		private function columnListChangeHandler(event:Event):void
		{
			var list:List = event.target as List;
			for(var i:int=0; i < columns.length; i++) {
				if (list != columns[i]) {
					columns[i].selectedIndex = list.selectedIndex;
				}
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event('change'));
		}
	}
}
