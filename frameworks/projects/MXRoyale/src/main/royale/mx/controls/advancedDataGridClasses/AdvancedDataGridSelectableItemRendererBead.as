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
package mx.controls.advancedDataGridClasses
{

import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridListData;
import mx.core.UIComponent;

import org.apache.royale.utils.CSSUtils;
import org.apache.royale.core.IListDataItemRenderer;
import org.apache.royale.core.ISelectableItemRenderer;
import org.apache.royale.core.IStrand;
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.html.beads.SelectableItemRendererBeadBase;

/**
 *  The AdvancedDataGridListData class defines the data type of the <code>listData</code> property 
 *  implemented by drop-in item renderers or drop-in item editors for the AdvancedDataGrid control. 
 *  All drop-in item renderers and drop-in item editors must implement the 
 *  IDropInListItemRenderer interface, which defines the <code>listData</code> property.
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
public class AdvancedDataGridSelectableItemRendererBead extends SelectableItemRendererBeadBase
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

    private var isInit:Boolean;
    private var wasSelected:Boolean = false;
    private var wasHovered:Boolean = false;
    private var colorAttr:String;
    private var bgColorsAttr:Array;
    
    /**
     * @private
     */
    override public function updateRenderer():void
    {
        var ir:IListDataItemRenderer = _strand as IListDataItemRenderer;
        var treeListData:AdvancedDataGridListData = ir.listData as AdvancedDataGridListData;
        var owner:AdvancedDataGrid = treeListData.owner as AdvancedDataGrid;

        if (isInit && wasSelected == (selected == null ? false : selected) && wasHovered == (hovered == null ? false : hovered))
            return;
        isInit = true;
        wasSelected = selected;
        wasHovered = hovered;

        // not really nice...
        var styleCache:Object = owner["SelectableItemRendererBead"];
        if (!styleCache)
        {
            // until getStyle() is cheaper, try to avoid getStyle() calls,
            // at the expense of some flexiblity
            //
            styleCache = owner["SelectableItemRendererBead"] = new Object();
            styleCache["alternatingItemColors"] = owner.getStyle("alternatingItemColors");
            styleCache["textSelectedColor"] = owner.getStyle("textSelectedColor");
            styleCache["textRollOverColor"] = owner.getStyle("textRollOverColor");
            styleCache["color"] = (treeListData.owner as UIComponent).getStyle("color");
        }
        
        if (!bgColorsAttr)
        {
            // cache work of converting colors to attr
            colorAttr = CSSUtils.attributeFromColor(styleCache["color"]);
            bgColorsAttr = new Array(2);
            var bgArray:Array = styleCache["alternatingItemColors"];
            bgColorsAttr[0] = CSSUtils.attributeFromColor(bgArray[0]);
            bgColorsAttr[1] = CSSUtils.attributeFromColor(bgArray[1]);
        }

        var bgColors:Array = styleCache["alternatingItemColors"];
        textSelectedColor = styleCache["textSelectedColor"];
        textRollOverColor = styleCache["textRollOverColor"];
        backgroundColor = ((treeListData.rowIndex % 2) == 1) ? bgColors[1] : bgColors[0];
        //var backgroundColorAttr:String = ((treeListData.rowIndex % 2) == 1) ? bgColorsAttr[1] : bgColorsAttr[0];
        var backgroundColorAttr:String = bgColorsAttr[1];
        COMPILE::SWF
        {
            super.updateRenderer();
        }
        COMPILE::JS
        {
            if (selected)
            {
                ir.element.style.backgroundColor = '#A8C6EE';
                ir.element.style.color = textSelectedColor;
            }
            else if (hovered)
            {
                ir.element.style.backgroundColor = '#D4E5FC';
                ir.element.style.color = textRollOverColor;
            }
            else
            {
                ir.element.style.backgroundColor = backgroundColorAttr;
                ir.element.style.color = colorAttr;
            }
        }
    }

	private function dataChangeHandler(event:Event):void
	{
        var ir:IListDataItemRenderer = _strand as IListDataItemRenderer;
        var treeListData:AdvancedDataGridListData = ir.listData as AdvancedDataGridListData;
        var owner:AdvancedDataGrid = treeListData.owner as AdvancedDataGrid;
        if (owner.selectedIndices.indexOf(treeListData.rowIndex) != -1)
        {
            selected = true;
        } 
        else if (owner.selectedIndex == treeListData.rowIndex)
        {
            selected = true;            
        }
		else
			selected = false;        
	}
}

}