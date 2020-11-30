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

package mx.controls.listClasses
{

//import flash.display.DisplayObject;
//import flash.display.Sprite;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
//import flash.text.TextFieldType;

import mx.core.IDataRenderer;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
//import mx.core.IFontContextComponent;
import mx.core.IToolTip;
import mx.core.IUITextField;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.core.mx_internal;
import mx.events.FlexEvent;
//import mx.events.InterManagerRequest;
import mx.events.ToolTipEvent;
import mx.managers.ISystemManager;
import mx.utils.PopUpUtil;

use namespace mx_internal;

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
 *  @productversion Flex 3
 */
[Event(name="dataChange", type="mx.events.FlexEvent")]

/**
 *  Text color of a component label.
 * 
 *  The default value for the Halo theme is <code>0x0B333C</code>.
 *  The default value for the Spark theme is <code>0x000000</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="color", type="uint", format="Color", inherit="yes")]

/**
 *  Text color of the component if it is disabled.
 *  @default 0xAAB3B3
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="disabledColor", type="uint", format="Color", inherit="yes")]

/**
 *  Number of pixels between children in the vertical direction. 
 *  @default 6
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="verticalGap", type="Number", format="Length", inherit="no")]

/**
 *  The TileListItemRenderer class defines the default item renderer for the 
 *  HorizontalList and TileList controls. 
 *  By default, the item renderer 
 *  draws the text associated with each item in the list, and an optional icon.
 *
 *  <p>You can override the default item renderer by creating a custom item renderer.</p>
 *
 *  @see mx.controls.HorizontalList
 *  @see mx.controls.TileList
 *  @see mx.core.IDataRenderer
 *  @see mx.controls.listClasses.IDropInListItemRenderer
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class TileListItemRenderer extends UIComponent
                                  implements IDataRenderer,
                                  IDropInListItemRenderer, IListItemRenderer
                                  //,IFontContextComponent
{
    //include "../../core/Version.as";

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
     *  @productversion Flex 3
     */
    public function TileListItemRenderer()
    {
        super();

        addEventListener(ToolTipEvent.TOOL_TIP_SHOW, toolTipShowHandler);
    }
	
	 protected function toolTipShowHandler(event:ToolTipEvent):void
    {
     /* var toolTip:IToolTip = event.toolTip;
        var pt:Point = PopUpUtil.positionOverComponent(DisplayObject(label),
                                                       systemManager,
                                                       toolTip.width, 
                                                       toolTip.height,
                                                       height / 2); 
        toolTip.move(pt.x, pt.y); */
    }
	
	//----------------------------------
    //  data
    //----------------------------------

    /**
     *  @private
     *  Storage for the data property.
     */
    private var _data:Object;

    [Bindable("dataChange")]

    /**
     *  The implementation of the <code>data</code> property as 
     *  defined by the IDataRenderer interface.  It simply stores
     *  the value and invalidates the component
     *  to trigger a relayout of the component.
     *
     *  @see mx.core.IDataRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	 public function get data():Object
    {
        return _data;
    }

    /**
     *  @private
     */
    public function set data(value:Object):void
    {
        _data = value;

        invalidateProperties();

        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    }
	
	//----------------------------------
    //  listData
    //----------------------------------

    /**
     *  @private
     *  Storage for the listData property.
     */
    private var _listData:ListData;

    [Bindable("dataChange")]
    
    /**
     *  The implementation of the <code>listData</code> property as 
     *  defined by the IDropInListItemRenderer interface.
     *
     *  @see mx.controls.listClasses.IDropInListItemRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get listData():BaseListData
    {
        return _listData;
    }

    /**
     *  @private
     */
    public function set listData(value:BaseListData):void
    {
        _listData = ListData(value);

        invalidateProperties();
    }

    

}

}
