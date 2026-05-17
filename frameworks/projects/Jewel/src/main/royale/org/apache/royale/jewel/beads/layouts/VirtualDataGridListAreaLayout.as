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
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IDataGrid;
    import org.apache.royale.core.IBeadLayout;
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
        // Tracks which DataGrid is currently syncing columns, to suppress redundant
        // layout() calls from scroll events triggered by programmatic scrollTop changes.
        private static var _syncingDataGrid:IDataGrid = null;

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

        override public function set strand(value:IStrand):void
        {
            super.strand = value;

            COMPILE::JS
            {
                // Non-passive wheel listener so preventDefault() can block the browser's
                // compositor thread from scrolling this column ahead of its siblings.
                // Without this, the compositor moves this column visually before our
                // handler fires, producing one frame of cross-column misalignment.
                var wheelOptions:Object = new Object();
                wheelOptions["passive"] = false;
                host.element.addEventListener("wheel", wheelHandler, wheelOptions);
            }
        }

        COMPILE::JS
        private function wheelHandler(e:*):void
        {
            if (e.deltaY == 0) return;

            e.preventDefault();

            // deltaMode: 0 = pixels (trackpad/modern), 1 = lines (mouse wheel on Firefox)
            var delta:Number = (e.deltaMode == 0) ? e.deltaY : e.deltaY * 40;
            var limitY:Number = host.element.scrollHeight - host.element.clientHeight;
            var newScrollTop:Number = Math.max(0, Math.min(host.element.scrollTop + delta, limitY));
            if (newScrollTop == host.element.scrollTop) return;

            // Apply scroll + layout on host and siblings synchronously inside this
            // handler so the browser paints a single frame with all columns aligned.
            // Going through the async scroll event leaves a gap visible on slower
            // machines, especially with heavy renderers such as editable checkboxes.
            host.element.scrollTop = newScrollTop;
            layout();
            syncSiblings(newScrollTop);
        }

        COMPILE::JS
        private function syncSiblings(scrollTop:Number):void
        {
            var myDataGrid:IDataGrid = (host as IDataGridColumnList).datagrid;
            _syncingDataGrid = myDataGrid;

            var listArea:Container = getListArea();
            for (var i:int = 0; i < listArea.numElements; i++)
            {
                var column:* = listArea.getElementAt(i);
                if (column == host) continue;

                column.element.scrollTop = scrollTop;
                var columnLayout:IBeadLayout = column.getBeadByType(IBeadLayout) as IBeadLayout;
                if (columnLayout)
                    columnLayout.layout();
            }

            // Clear the flag after any queued scroll events from the programmatic
            // scrollTop changes above have been processed and suppressed.
            setTimeout(function():void
            {
                if (_syncingDataGrid == myDataGrid)
                    _syncingDataGrid = null;
            }, 0);
        }

        private function getListArea():Container
        {
            var datagrid:IDataGrid = (host as IDataGridColumnList).datagrid;
            var view:IDataGridView = datagrid.getBeadByType(IDataGridView) as IDataGridView;
            return view.listArea as Container;
        }

        override protected function scrollHandler(e:Event):void
        {
            COMPILE::JS
            {
                if (_syncingDataGrid != null && _syncingDataGrid == (host as IDataGridColumnList).datagrid)
                {
                    // Being synced from another column or from wheelHandler - just
                    // update own layout without re-syncing siblings.
                    super.scrollHandler(e);
                    return;
                }
            }

            // Non-wheel scroll path (keyboard, scrollbar drag, programmatic).
            // wheelHandler covers the wheel path; this branch keeps the rest in sync.
            super.scrollHandler(e);

            COMPILE::JS
            {
                syncSiblings(host.element.scrollTop);
            }
        }
	}
}