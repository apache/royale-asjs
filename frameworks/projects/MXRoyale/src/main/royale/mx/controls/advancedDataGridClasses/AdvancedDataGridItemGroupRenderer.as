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


    //import mx.controls.AdvancedDataGrid;
    import mx.controls.AdvancedDataGrid;
    import mx.controls.Label;
    import mx.controls.beads.models.DataGridICollectionViewModel;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.controls.listClasses.BaseListData;
    import mx.controls.listClasses.IDropInListItemRenderer;
    import mx.controls.listClasses.IListItemRenderer;
    import mx.core.IDataRenderer;
    import mx.core.IFlexDisplayObject;
    import mx.core.IToolTip;
    import mx.core.UITextField;
    import mx.core.mx_internal;
    import mx.events.FlexEvent;
    import mx.managers.ISystemManager;
    import mx.styles.CSSStyleDeclaration;

    import org.apache.royale.core.ILabelFieldItemRenderer;
    
    import org.apache.royale.html.util.getLabelFromData;
    
    //import mx.styles.IStyleClient;
    //import mx.styles.StyleProtoChain;
    use namespace mx_internal;
    
    import org.apache.royale.html.supportClasses.StringItemRenderer;
    import org.apache.royale.events.MouseEvent;
    import mx.core.IUIComponent;
    import mx.core.UIComponent;
    import mx.collections.IHierarchicalData;
    import mx.events.ListEvent;
    import org.apache.royale.core.ISelectableItemRenderer;
    import org.apache.royale.core.IListDataItemRenderer;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.geom.Point;
    import org.apache.royale.utils.getSelectionRenderBead;
    import org.apache.royale.utils.PointUtils;
    import org.apache.royale.events.Event;
    import mx.supportClasses.IFoldable;

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
[Event(name="dataChange", type="mx.events.FlexEvent")]

/**
 * The AdvancedDataGridGroupItemRenderer class defines the default item renderer for
 *  the nodes of the navigation tree.
 *  By default, the item renderer draws the text associated with each node in the tree,
 *  an optional icon, and an optional disclosure icon.
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
public class AdvancedDataGridItemGroupRenderer extends UIComponent
                                  implements IDataRenderer,IDropInListItemRenderer,IListDataItemRenderer,IListItemRenderer,IFoldable, ILabelFieldItemRenderer
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
    public function AdvancedDataGridItemGroupRenderer()
    {
        super();
        typeNames += " AdvancedDataGridItemRenderer";
        addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
    }

    /**
     * override to specify a fixed icon width, otherwise the icon width defaults to the renderer height
     * @return
     */
    public function getIconWidth():uint{
        return 0;
    }
    /**
     * override to specify a fixed icon height, otherwise the icon height defaults to the renderer height
     * @return
     */
    public function getIconHeight():uint{
        return 0;
    }

    private function doubleClickHandler(event:MouseEvent):void
    {
        var treeListData:AdvancedDataGridListData = listData as AdvancedDataGridListData;
        var owner:AdvancedDataGrid = treeListData.owner as AdvancedDataGrid;
        var newEvent:ListEvent = new ListEvent(ListEvent.ITEM_DOUBLE_CLICK);
        newEvent.rowIndex = index;
		newEvent.columnIndex = treeListData.columnIndex;
        owner.dispatchEvent(newEvent);        
    }


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
        addEventListener("dataChange", sizeChangeHandler);
   /*     // each MXML file can also have styles in fx:Style block
        ValuesManager.valuesImpl.init(this);*/

        dispatchEvent(new Event("initBindings"));
        dispatchEvent(new Event("initComplete"));

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


    override protected function createChildren():void
    {
        super.createChildren();
        if (numChildren == 0)
        {
            label = new Label();
            addChild(label);
            disclosureIcon = new Label();
            disclosureIcon.x = 0;
            disclosureIcon.truncateToFit = false;
            disclosureIcon.textAlign = 'right';
            addChild(disclosureIcon);
        }
    }

    protected function createIcon():IFlexDisplayObject{
        var img:mx.controls.Image = new mx.controls.Image();
        var fixedDimension:uint  = getIconWidth();
        if (fixedDimension) img.width = fixedDimension;
        else img.width = height;
        fixedDimension = getIconHeight();
        if (fixedDimension) img.height = fixedDimension;
        else img.height = height;
     //   img.setStyle("verticalAlign", "middle" );
        return img;
    }

    //porting notes, only create icon if needed
    protected function configureIcon(source:Object):void{
        if (!source) {
            if (icon) removeChild(icon as IUIComponent);
            icon = null;
        } else {
            if (!icon) {
                icon = createIcon();
                addChild(icon as IUIComponent);
            }
            if (icon is mx.controls.Image) {
                mx.controls.Image(icon).source = source;
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties: UIComponent
    //
    //--------------------------------------------------------------------------

    public function getIndentWidth():uint{
        return 14;
    }

    public function getDisclosureOpen():String{
        return "▼";
    }

    public function getDisclosureClosed():String{
        return "▶";
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

    /**
     * Sets the data for the itemRenderer instance along with the listData
     * (TreeListData).
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function set data(value:Object):void
    {
        _data = value;
        var treeListData:AdvancedDataGridListData = listData as AdvancedDataGridListData;
        var owner:AdvancedDataGrid = treeListData.owner as AdvancedDataGrid;

        text = treeListData.label;

        var extraSpace:String ;
        var indentWidth:uint= getIndentWidth();
        var indentW:uint = indentWidth;
        COMPILE::SWF {
            extraSpace = " ";
        }
        COMPILE::JS {
            extraSpace = "\u00a0";
        }

        if (owner.iconFunction){
            configureIcon(owner.iconFunction(value))
        }
        if (treeListData.columnIndex == 0 && owner._rootModel is IHierarchicalData)
        {
            for (var i:int=0; i < treeListData.depth - 1; i++) {
                indentW += indentWidth;
            }

            _canFold = treeListData.hasChildren && treeListData.open;
            _canUnfold = treeListData.hasChildren && !treeListData.open;

            var disclosureIconText:String =(treeListData.hasChildren ? (treeListData.open ? getDisclosureOpen() : getDisclosureClosed()) + extraSpace: "");
            disclosureIcon.text = disclosureIconText;
            disclosureIcon.width = fineTuneDisclosureIconWidth(indentW);
        } else {
            disclosureIcon.text = null;
            disclosureIcon.width = 0;
        }

		dispatchEvent(new FlexEvent("dataChange"));
        if (parent) adjustSize();
    }


    protected function fineTuneDisclosureIconWidth(standard:uint):uint{
        return standard;
    }


    
    private var _listData:Object;
    
    [Bindable("__NoChangeEvent__")]
    /**
     *  The extra data being represented by this itemRenderer. This can be something simple like a String or
     *  a Number or something very complex.
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
        if (initialized)
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
        if (icon) {
            icon.x = disclosureIcon.width;
            icon.y = (unscaledHeight-icon.height)*.5;
            label.x = disclosureIcon.width + icon.width + 2;
        } else {
            label.x = disclosureIcon.width;
        }
        label.y = 2;
        label.width = unscaledWidth - label.x;
        disclosureIcon.y = 2;
    }

    private var _canFold:Boolean;
    public function get canFold():Boolean
    {
        return _canFold;
    }
    
    private var _canUnfold:Boolean;
    public function get canUnfold():Boolean
    {
        return _canUnfold;
    }

    public function isFoldInitiator(check:Object):Boolean
    {
        return check == disclosureIcon ;
    }


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------


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


    protected function dataToString(value:Object):String
    {
        if (value is XML && labelField && labelField.indexOf("@") > -1)
        {
            var attName:String = labelField.split("@")[1] as String;
            return (value as XML).attribute(attName).toString();
        }
        return getLabelFromData(this,value);
    }






}

}
