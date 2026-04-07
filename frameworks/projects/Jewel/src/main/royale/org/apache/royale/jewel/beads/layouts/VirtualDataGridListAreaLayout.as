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
        private var isAreaFocus:Boolean;

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
                host.element.addEventListener("mouseover", function():void { isAreaFocus = true });
                host.element.addEventListener("mouseleave", function():void { isAreaFocus = false });

                // Non-passive wheel listener so preventDefault() can block the browser's
                // compositor thread from scrolling this column ahead of its siblings.
                // Without this, the compositor moves this column visually before our
                // scrollHandler fires, producing one frame of cross-column misalignment.
                var wheelOptions:Object = new Object();
                wheelOptions["passive"] = false;
                host.element.addEventListener("wheel", wheelHandler, wheelOptions);
            }
        }

        COMPILE::JS
        private function wheelHandler(e:*):void
        {
            if (!isAreaFocus || e.deltaY == 0) return;

            e.preventDefault();

            // deltaMode: 0 = pixels (trackpad/modern), 1 = lines (mouse wheel on Firefox)
            var delta:Number = (e.deltaMode == 0) ? e.deltaY : e.deltaY * 40;
            var limitY:Number = host.element.scrollHeight - host.element.clientHeight;
            host.element.scrollTop = Math.max(0, Math.min(host.element.scrollTop + delta, limitY));
            // The resulting scroll event triggers scrollHandler which syncs all other columns.
        }

        private function getListArea():Container
        {
            var datagrid:IDataGrid = (host as IDataGridColumnList).datagrid;
            var view:IDataGridView = datagrid.getBeadByType(IDataGridView) as IDataGridView;
            return view.listArea as Container;
        }

        override protected function scrollHandler(e:Event):void
        {
            // Check if we're being synced by another column's scroll handler
            COMPILE::JS
            {
                if (_syncingDataGrid != null && _syncingDataGrid == (host as IDataGridColumnList).datagrid)
                {
                    // Being synced - just update layout without syncing others
                    super.scrollHandler(e);
                    return;
                }
            }

            // Update own layout
            super.scrollHandler(e);

            COMPILE::JS
            {
                // Any scroll event on this column triggers sync to all others,
                // regardless of mouse position. This handles cases where the browser
                // window regains focus without a mouseover event.
                var myDataGrid:IDataGrid = (host as IDataGridColumnList).datagrid;
                _syncingDataGrid = myDataGrid;

                var listArea:Container = getListArea();
                var scrollTop:Number = host.element.scrollTop;

                for (var i:int = 0; i < listArea.numElements; i++)
                {
                    var otherColumn:* = listArea.getElementAt(i);
                    if (otherColumn != host)
                    {
                        otherColumn.element.scrollTop = scrollTop;
                        // Immediately call layout() so all columns are visually aligned
                        // before the browser paints — without waiting for the async scroll event.
                        var otherLayout:IBeadLayout = otherColumn.getBeadByType(IBeadLayout) as IBeadLayout;
                        if (otherLayout)
                            otherLayout.layout();
                    }
                }

                // Clear the flag after any queued scroll events from the programmatic
                // scrollTop changes above have been processed and suppressed.
                setTimeout(function():void
                {
                    if (_syncingDataGrid == myDataGrid)
                        _syncingDataGrid = null;
                }, 0);
            }
        }
	}
}