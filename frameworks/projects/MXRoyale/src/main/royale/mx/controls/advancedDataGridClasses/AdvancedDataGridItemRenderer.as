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
/* import flash.display.DisplayObject;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import flash.utils.getQualifiedSuperclassName; */

//import mx.controls.AdvancedDataGrid;
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.core.IDataRenderer;
import mx.core.IFlexDisplayObject;
import mx.core.IToolTip;
import mx.core.UITextField;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.managers.ISystemManager;
import mx.styles.CSSStyleDeclaration;
//import mx.styles.IStyleClient;
//import mx.styles.StyleProtoChain;
use namespace mx_internal;

import org.apache.royale.utils.CSSUtils;
import org.apache.royale.html.supportClasses.StringItemRenderer;
import mx.core.UIComponent;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the <code>data</code> property changes.
 *
 *  <p>When you use a component as an item renderer,
 *  the <code>data</code> property contains the data to display.
 *  You can listen for this event and update the component
 *  when the <code>data</code> property changes.</p>
 * 
 *  @eventType mx.events.FlexEvent.DATA_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Event(name="dataChange", type="mx.events.FlexEvent")]

/**
 *  The AdvancedDataGridItemRenderer class defines the default item renderer for a AdvancedDataGrid control. 
 *  By default, the item renderer 
 *  draws the text associated with each item in the grid.
 *
 *  <p>You can override the default item renderer by creating a custom item renderer.</p>
 *
 *  @see mx.controls.AdvancedDataGrid
 *  @see mx.core.IDataRenderer
 *  @see mx.controls.listClasses.IDropInListItemRenderer
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class AdvancedDataGridItemRenderer extends StringItemRenderer
                                  implements IDataRenderer,IDropInListItemRenderer
{
 /* extends UITextField
                                  implements IDataRenderer,
                                  IDropInListItemRenderer, ILayoutManagerClient,
                                  IListItemRenderer, IStyleClient
								   */
/*     include "../../core/Version.as";
 */    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function AdvancedDataGridItemRenderer()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     * Sets the data for the itemRenderer instance along with the listData
     * (TreeListData).
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    override public function set data(value:Object):void
    {
        super.data = value;
        
        var treeListData:AdvancedDataGridListData = listData as AdvancedDataGridListData;
        var indentSpace:String = "    ";
        var extraSpace:String = " ";
        
        COMPILE::JS {
            indentSpace = "\u00a0\u00a0\u00a0\u00a0";
            extraSpace = "\u00a0";
        }
            
        var indent:String = "";
        if (treeListData.columnIndex == 0)
        {
            for (var i:int=0; i < treeListData.depth - 1; i++) {
                indent += indentSpace;
            }
            
            indent += (treeListData.hasChildren ? (treeListData.open ? "▼" : "▶") : "") + extraSpace;
        }
        var bgColors:Array = (treeListData.owner as UIComponent).getStyle("alternatingItemColors");
        backgroundColor = ((treeListData.rowIndex % 2) == 1) ? bgColors[1] : bgColors[0];

        COMPILE::JS {
            element.style.backgroundColor = CSSUtils.attributeFromColor(backgroundColor);
        }
        this.text = indent + this.text;
    }

    /**
     * @private
     */
    override public function updateRenderer():void
    {
        COMPILE::SWF
        {
            super.updateRenderer();
        }
        COMPILE::JS
        {
            if (selected)
                element.style.backgroundColor = '#9C9C9C';
            else if (hovered)
                element.style.backgroundColor = '#ECECEC';
            else
                element.style.backgroundColor = CSSUtils.attributeFromColor(backgroundColor);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------


    override public function set text(value:String):void
    {
        COMPILE::JS
        {
            if (value == "undefined" && !(data is XML))
            {
                value = "";
            }
        }
        super.text = value;
    }
}

}
