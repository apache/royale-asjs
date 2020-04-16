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
package org.apache.royale.jewel.beads.controls.list
{
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.jewel.List;
	import org.apache.royale.jewel.beads.models.ListPresentationModel;
	
	/**
     *  Ensures that the data provider item at the given index is visible.
     *  
     *  If the item is visible, the <code>verticalScrollPosition</code>
     *  property is left unchanged even if the item is not the first visible
     *  item. If the item is not currently visible, the 
     *  <code>verticalScrollPosition</code>
     *  property is changed make the item the first visible item, unless there
     *  aren't enough rows to do so because the 
     *  <code>verticalScrollPosition</code> value is limited by the 
     *  <code>maxVerticalScrollPosition</code> property.
     *
     *  @param index The index of the item in the data provider.
     *
     *  @return <code>true</code> if <code>verticalScrollPosition</code> changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.7
     */
    public function scrollToIndex(list:List, index:int):Boolean
    {
        COMPILE::SWF
        {
            // to implement

            return false;
        }

		COMPILE::JS
		{
        var scrollArea:HTMLElement = list.element;
        var oldScroll:Number = scrollArea.scrollTop;

        var totalHeight:Number = 0;
        
        if(list.variableRowHeight)
        {
            var listView:IListView = list.getBeadByType(IListView) as IListView;
            var dataGroup:IItemRendererOwnerView = listView.dataGroup;

            //each item render can have its own height
            var n:int = list.dataProvider.length;
            var irHeights:Array = [];
            for (var i:int = 0; i < n; i++)
            {
                var ir:IItemRenderer = dataGroup.getItemRendererForIndex(i) as IItemRenderer;
                irHeights.push(totalHeight + ir.element.clientHeight);
                totalHeight += ir.element.clientHeight;
            }

            scrollArea.scrollTop = irHeights[index-1];

        } else 
        {
            var rowHeight:Number;
            // all items renderers with same height
            rowHeight = isNaN(list.rowHeight) ? ListPresentationModel.DEFAULT_ROW_HEIGHT : list.rowHeight;
            totalHeight = list.dataProvider.length * rowHeight - scrollArea.clientHeight;
            
            scrollArea.scrollTop = Math.min(index * rowHeight, totalHeight);
        }

        return oldScroll != scrollArea.scrollTop; 
		}
    } 
}
