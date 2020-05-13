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
import mx.controls.Label;
import mx.controls.Tree;
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.core.IDataRenderer;
import mx.core.IFlexDisplayObject;
import mx.core.UIComponent;
import mx.core.mx_internal;

use namespace mx_internal;

import org.apache.royale.core.IBead;
import org.apache.royale.core.IItemRenderer;
import org.apache.royale.core.ILabelFieldItemRenderer;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.events.Event;
import org.apache.royale.html.util.getLabelFromData;
import org.apache.royale.html.supportClasses.TreeListData;
import org.apache.royale.core.IItemRendererOwnerView;
import org.apache.royale.core.ISelectableItemRenderer;

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
public class TreeItemRenderer extends UIComponent 
    implements IDataRenderer, IDropInListItemRenderer, IItemRenderer, ILabelFieldItemRenderer
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
        typeNames = "TreeItemRenderer";        
    }

    override protected function createChildren():void
    {
        super.createChildren();
        if (numChildren == 0)
        {
            label = new Label();
            addChild(label);
            disclosureIcon = new Label();
            addChild(disclosureIcon);
        }
    }
   
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    
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
    protected var label:Label;
    
 
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
    public var disclosureIcon:Label;

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
    
    //--------------------------------------------------------------------------
    //
    //  Copied from UIItemRendererBase.  Good case for finding a better way to 
    //  share code like this
    //
    //--------------------------------------------------------------------------
    

    /**
     * @private
     */
    override public function addedToParent():void
    {
        super.addedToParent();
        
        // very common for item renderers to be resized by their containers,
        addEventListener("widthChanged", sizeChangeHandler);
        addEventListener("heightChanged", sizeChangeHandler);
        addEventListener("sizeChanged", sizeChangeHandler);
        
        // each MXML file can also have styles in fx:Style block
        ValuesManager.valuesImpl.init(this);
        
        dispatchEvent(new Event("initBindings"));
        dispatchEvent(new Event("initComplete"));
        
    }
    
    private var _data:Object;
    
    [Bindable("__NoChangeEvent__")]
    /**
     *  The data being represented by this itemRenderer. This can be something simple like a String or
     *  a Number or something very complex.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get data():Object
    {
        return _data;
    }
    public function set data(value:Object):void
    {
        _data = value;
        var treeListData:mx.controls.treeClasses.TreeListData = listData as mx.controls.treeClasses.TreeListData;

        if ((treeListData.owner as Tree).labelFunction)
            text = (treeListData.owner as Tree).labelFunction(data);
        else
            text = dataToString(value);
        
        var indentSpace:String = "    ";
        var extraSpace:String = " ";
        
        COMPILE::JS {
            indentSpace = "\u00a0\u00a0\u00a0\u00a0";
            extraSpace = "\u00a0";
        }
            
            var indent:String = "";
        for (var i:int=0; i < treeListData.depth - 1; i++) {
            indent += indentSpace;
        }
        
        indent += (treeListData.hasChildren ? (treeListData.isOpen ? "▼" : "▶") : "") + extraSpace;
        
        disclosureIcon.text = indent;

    }
    
    protected function dataToString(value:Object):String
    {
        return getLabelFromData(this,value);
    }

    private var _listData:Object;
    
    [Bindable("__NoChangeEvent__")]
    /**
     *  Additional data about the list structure the itemRenderer may
     *  find useful.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get listData():Object
    {
        return _listData;
    }
    public function set listData(value:Object):void
    {
        _listData = value;
    }
    
    private var _labelField:String = "label";
    
    /**
     * The name of the field within the data to use as a label. Some itemRenderers use this field to
     * identify the value they should show while other itemRenderers ignore this if they are showing
     * complex information.
     */
    public function get labelField():String
    {
        return _labelField;
    }
    public function set labelField(value:String):void
    {
        _labelField = value;
    }
    
    /**
     * @private
     */
    private function sizeChangeHandler(event:Event):void
    {
        adjustSize();
    }
    
    /**
     *  This function is called whenever the itemRenderer changes size. Sub-classes should override
     *  this method an handle the size change.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function adjustSize():void
    {
        updateDisplayList(width, height);
    }
   
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        label.x = disclosureIcon.width;
        label.y = 2;
        disclosureIcon.y = 2;
    }

    public function set text(value:String):void
    {
        COMPILE::JS
        {
            if (value == "undefined")
            {
                if (labelField.charAt(0) == '@')
                    value = data["attribute"](labelField);
                else
                    value = data["child"](labelField).toString();
            }
        }
        label.text = value;
    }

    /**
     *  The text currently displayed by the itemRenderer instance.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get text():String
    {
        return label.text;
    }
    
}

}
