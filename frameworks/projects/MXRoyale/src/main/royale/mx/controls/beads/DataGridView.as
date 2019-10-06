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
package mx.controls.beads
{
    import org.apache.royale.core.IDataGrid;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.DataGridView;
    
    import mx.events.CollectionEvent;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnList;
    import mx.controls.AdvancedDataGrid;
	
    /**
     *  The AlertView class.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class DataGridView extends org.apache.royale.html.beads.DataGridView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DataGridView()
		{
        }

        override protected function handleInitComplete(event:Event):void
        {
            super.handleInitComplete(event);
            
            var host:IDataGrid = _strand as IDataGrid;
            
            IEventDispatcher(host).addEventListener(CollectionEvent.COLLECTION_CHANGE, handleCollectionChanged);
            if (host.model.dataProvider != null && host.model.dataProvider.length > 0)
            {
                // force update of list.adg and refresh renderers
                handleCollectionChanged(event);
            }
            else if (host.model.dataProvider == null)
            {
                IEventDispatcher(host.model).addEventListener("dataProviderChanged", handleCollectionChanged);
            }
        }		
        
        private function handleCollectionChanged(event:Event):void
        {
            for (var i:int=0; i < columnLists.length; i++)
            {
                var list:AdvancedDataGridColumnList = columnLists[i] as AdvancedDataGridColumnList;
                list.adg = _strand as AdvancedDataGrid;
                list.model.dispatchEvent(new Event("dataProviderChanged"));
            }
            host.dispatchEvent(new Event("layoutNeeded"));
            
        }
	}
}
