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
package org.apache.royale.jewel.beads.controls.datagrid
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.jewel.Container;
    import org.apache.royale.jewel.DataGrid;
    import org.apache.royale.jewel.beads.views.DataGridView;
    import org.apache.royale.jewel.VirtualDataGrid;
    import org.apache.royale.jewel.beads.views.VirtualDataGridView;
    import org.apache.royale.events.MouseEvent;

	/**
	 *  The DataGridScrollSpeed bead class is a specialty bead that can be use with a Jewel DataGrid and VirtualDataGrid control
	 *  when need to change the DataGrid scroll speed columns (special on VirtualDataGrid that needs to sync all columns)
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.9
	 */
    public class DataGridScrollSpeed implements IBead
    {
        private var scrollY:Number = 0;

        public var speed:Number = 1;

		public function DataGridScrollSpeed()
		{
			super();
		}

		/**                         	
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.9
		 */
        public function set strand(value:IStrand):void
        {
            var listArea:Container;
            if (value is VirtualDataGrid)
                listArea = ((value as VirtualDataGrid).view as VirtualDataGridView).listArea as Container;
            else
                listArea = ((value as DataGrid).view as DataGridView).listArea as Container;

            for (var i:int = 0; i < listArea.numElements; i++)
            {
				COMPILE::JS
				{
                    listArea.getElementAt(i).element.addEventListener("mousewheel", handleMouseWheel);
				}
            }
        }

        COMPILE::JS
		{
            private function handleMouseWheel(e:MouseEvent):void
            {
                e.preventDefault();

                var container:Element = e.currentTarget as Element;

                scrollY += speed * e.deltaY;
                if (scrollY < 0)
                {
                    scrollY = 0;
                }
                else
                {
                    var limitY:Number = container.scrollHeight - container.clientHeight;
                    if (scrollY > limitY)
                        scrollY = limitY;
                }
                container.scrollTop = scrollY;
            }
        }
    }
}