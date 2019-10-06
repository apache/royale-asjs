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
package mx.controls.beads.models
{
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IDataGridModel;
	
    /**
     *  MenuBar Mouse Controller
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class DataGridICollectionViewModel extends SingleSelectionICollectionViewModel implements IDataGridModel
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DataGridICollectionViewModel()
		{
		}
		
        private var _columns:Array;
        
        /**
         *  The array of org.apache.royale.html.supportClasses.DataGridColumns used to
         *  define each column of the org.apache.royale.html.DataGrid.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get columns():Array
        {
            return _columns;
        }
        public function set columns(value:Array):void
        {
            if (_columns != value) {
                _columns = value;
                dispatchEvent( new Event("columnsChanged"));
            }
        }
        
        private var _headerModel:IBeadModel;
        
        /**
         * The model to use for the DataGrid's header.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function get headerModel():IBeadModel
        {
            return _headerModel;
        }
        public function set headerModel(value:IBeadModel):void
        {
            if (_headerModel != value) {
                _headerModel = value;
                dispatchEvent(new Event("headerModelChanged"));
                
                _headerModel.addEventListener("dataProviderChanged", handleHeaderModelChange);
            }
        }
        
        private function handleHeaderModelChange(event:Event):void
        {
            dispatchEvent(new Event("headerModelChanged"));
        }
    }
}
