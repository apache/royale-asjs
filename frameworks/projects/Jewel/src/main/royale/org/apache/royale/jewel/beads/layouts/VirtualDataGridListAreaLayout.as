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
package org.apache.royale.jewel.beads.layouts
{
    import org.apache.royale.events.Event;
    import org.apache.royale.html.beads.IDataGridView;
    import org.apache.royale.core.IDataGrid;
    import org.apache.royale.jewel.Container;
    import org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList;
        
	/**
	 *  The VirtualDataGridListAreaLayout class is used for Jewel VirtualDataGrid
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class VirtualDataGridListAreaLayout extends VirtualListVerticalLayout
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
         *  @royaleignorecoercion HTMLDivElement
		 */
		public function VirtualDataGridListAreaLayout()
		{
			super();
		}

        private function getListArea():Container
        {
            var datagrid:IDataGrid = (host as IDataGridColumnList).datagrid;
            var view:IDataGridView = datagrid.getBeadByType(IDataGridView) as IDataGridView;
            return view.listArea as Container;
        }

        override protected function scrollHandler(e:Event):void
        {
            super.scrollHandler(e);

            var listArea:Container = getListArea();

            for (var i:int = 0; i < listArea.numElements; i++)
            {
				COMPILE::JS
				{
                if (listArea.getElementAt(i) != host)
                    listArea.getElementAt(i).element.scrollTop = host.element.scrollTop;
				}	
            }
        }
	}
}