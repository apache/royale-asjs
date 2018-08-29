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

package mx.controls.treeClasses
{

/* import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.controls.Tree;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.IDataRenderer;
import mx.core.IFlexModuleFactory;
import mx.core.IFontContextComponent;
import mx.core.ILayoutDirectionElement;
import mx.core.IToolTip;
import mx.core.SpriteAsset;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.core.IUITextField;
import mx.events.FlexEvent;
import mx.events.ToolTipEvent;
import mx.events.TreeEvent;
import mx.managers.ISystemManager;
import mx.utils.PopUpUtil;

 */
COMPILE::JS
{
    import goog.DEBUG;
}
import mx.core.IFlexDisplayObject;
import mx.controls.listClasses.BaseListData;
import org.apache.royale.html.supportClasses.TreeItemRenderer;
import mx.core.mx_internal;
import mx.core.UIComponent;
import mx.core.IDataRenderer;
import mx.controls.listClasses.IDropInListItemRenderer;

use namespace mx_internal;

/**
 *  The TreeItemRenderer class defines the default item renderer for a Tree control. 
 *  By default, the item renderer draws the text associated with each item in the tree, 
 *  an optional icon, and an optional disclosure icon.
 *
 *  <p>You can override the default item renderer by creating a custom item renderer.</p>
 *
 *  @see mx.controls.Tree
 *  @see mx.core.IDataRenderer
 *  @see mx.controls.listClasses.IDropInListItemRenderer
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class TreeItemRenderer extends UIComponent implements IDataRenderer,IDropInListItemRenderer
{
   

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
    public function TreeItemRenderer()
    {
        super();
    }

   
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

  	private var _data:Object
 
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
	//dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));  
	}


	private var _listData:BaseListData 
	//_listData:AdvancedDataGridListData;

	[Bindable("dataChange")]


	/**
	*  
	The implementation of the <code>listData</code> property as 
	*  
	defined by the IDropInListItemRenderer interface.
	*  The text of the renderer is set to the <code>label</code>

	*  property of this property.
	*
	*  @see mx.controls.listClasses.IDropInListItemRenderer
	*  
	*  @langversion 3.0

	*  @playerversion Flash 9
	*  @playerversion AIR 1.1
	*  @productversion Royale 0.9.3
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
	_listData = value;
	/*_listData = AdvancedDataGridListData(value);

	if (nestLevel && !invalidatePropertiesFlag)

	{

	UIComponentGlobals.layoutManager.invalidateProperties(this);

	invalidatePropertiesFlag = true;

	UIComponentGlobals.layoutManager.invalidateSize(this);

	invalidateSizeFlag = true;

	} 
	*/
	}
    
    //----------------------------------
    //  icon
    //----------------------------------

    /**
     *  The internal IFlexDisplayObject that displays the icon in this renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var icon:IFlexDisplayObject;
    
    //----------------------------------
    //  label
    //----------------------------------

    /**
     *  The internal UITextField that displays the text in this renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var label:Object;
    
 
	//----------------------------------
    //  disclosureIcon
    //----------------------------------

    /**
     *  The internal IFlexDisplayObject that displays the disclosure icon
     *  in this renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var disclosureIcon:IFlexDisplayObject;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    
    /**
     *  @private
     */
    mx_internal function getLabel():Object
    {
        return label;
    }
    
	
   

}

}
