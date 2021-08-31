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

package mx.controls.dataGridClasses
{

import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridListData;
import mx.core.UIComponent;

import org.apache.royale.utils.CSSUtils;
import org.apache.royale.core.IListDataItemRenderer;
import org.apache.royale.core.ISelectableItemRenderer;
import org.apache.royale.core.IStrand;
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.html.beads.SelectableItemRendererBeadBase;

/**
 *  DataGridSelectableItemRendererBead may be a temporary solution for this support.
 *  @todo investigate: Alternating row colors could be done perhaps by nth-child-of-type in browser css...
 *
 *  <p>While the properties of this class are writable, you should consider them to 
 *  be read only. They are initialized by the AdvancedDataGrid class, and read by an item renderer 
 *  or item editor. Changing these values can lead to unexpected results.</p>
 *
 *  @see mx.controls.listClasses.IDropInListItemRenderer
 *  @see mx.controls.AdvancedDataGrid
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DataGridSelectableItemRendererBead extends SelectableItemRendererBeadBase
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------


    override public function set strand(value:IStrand):void 
	{
		super.strand = value;
		(value as IEventDispatcher).addEventListener("dataChange", dataChangeHandler);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    public var textSelectedColor:String = "#000000";
    public var textRollOverColor:String = "#000000";

    //@todo check defaults are correct here
    private static var defaultAlternatingItemColors:Array = [0xF7F7F7, 0xFFFFFF];
    
    /**
     * @private
     */
    override public function updateRenderer():void
    {
        var ir:IListDataItemRenderer = _strand as IListDataItemRenderer;
        var listData:DataGridListData = ir.listData as DataGridListData;
        var owner:DataGrid = listData.owner as DataGrid;
        var bgColors:Array = owner.getStyle("alternatingItemColors");
        if (bgColors.length<2) {
            bgColors = defaultAlternatingItemColors;
        }
        textSelectedColor = owner.getStyle("textSelectedColor");
        textRollOverColor = owner.getStyle("textRollOverColor");
        backgroundColor = ((listData.rowIndex % 2) == 1) ? bgColors[1] : bgColors[0];
        COMPILE::JS {
            if (selected)
                ir.element.style.backgroundColor = '#9C9C9C';
            else
                ir.element.style.backgroundColor = CSSUtils.attributeFromColor(backgroundColor);
        }
            
        COMPILE::SWF
        {
            super.updateRenderer();
        }
        COMPILE::JS
        {
            if (selected)
            {
                ir.element.style.backgroundColor = '#9C9C9C';
                ir.element.style.color = textSelectedColor;
            }
            else if (hovered)
            {
                ir.element.style.backgroundColor = '#ECECEC';
                ir.element.style.color = textRollOverColor;
            }
            else
            {
                ir.element.style.backgroundColor = CSSUtils.attributeFromColor(backgroundColor);
                ir.element.style.color = CSSUtils.attributeFromColor((listData.owner as UIComponent).getStyle("color"));
            }
        }
    }

	private function dataChangeHandler(event:Event):void
	{
        var ir:IListDataItemRenderer = _strand as IListDataItemRenderer;
        var listData:DataGridListData = ir.listData as DataGridListData;
        var owner:DataGrid = listData.owner as DataGrid;
        if (owner.selectedIndices.indexOf(listData.rowIndex) != -1)
        {
            selected = true;
        } 
        else selected = owner.selectedIndex == listData.rowIndex;
	}
}

}
