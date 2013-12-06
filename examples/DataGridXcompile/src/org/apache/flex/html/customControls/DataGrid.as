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
package org.apache.flex.html.customControls
{
	import org.apache.flex.core.IDataGridModel;
	import org.apache.flex.core.UIBase;
	
	[Event(name="change", type="org.apache.flex.events.Event")]
	
	public class DataGrid extends UIBase
	{
		public function DataGrid()
		{
			super();
		}
		
		public function get dataProvider():Object
		{
			return IDataGridModel(model).dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
			//IDataGridModel(model).dataProvider = value;  
			var dgm:IDataGridModel = model as IDataGridModel
			dgm.dataProvider = value;
		}
		
		public function get labelFields():Object
		{
			return IDataGridModel(model).labelFields;
		}
		public function set labelFields(value:Object):void
		{
			//IDataGridModel(model).labelFields = value;
			var dgm:IDataGridModel = model as IDataGridModel
			dgm.labelFields = value;
		}
		
		public function get selectedIndex():int
		{
			return IDataGridModel(model).selectedIndex;
		}
	}
}