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
    import mx.controls.dataGridClasses.*;



    import mx.controls.DataGrid;
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
public class DataGridItemRenderer extends StringItemRenderer
                                  implements IDataRenderer,IDropInListItemRenderer,IListDataItemRenderer,IListItemRenderer
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
    public function DataGridItemRenderer()
    {
        super();
        typeNames += " DataGridItemRenderer";
        addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
    }

    private function doubleClickHandler(event:MouseEvent):void
    {
        var listData:DataGridListData = this.listData as DataGridListData;
        var owner:DataGrid = listData.owner as DataGrid;
        var newEvent:ListEvent = new ListEvent(ListEvent.ITEM_DOUBLE_CLICK);
        newEvent.rowIndex = index;
		newEvent.columnIndex = listData.columnIndex;
        owner.dispatchEvent(newEvent);        
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
        var listData:DataGridListData = this.listData as DataGridListData;
        var owner:DataGrid = listData.owner as DataGrid;
        var dgModel:DataGridICollectionViewModel = owner.getBeadByType(DataGridICollectionViewModel) as DataGridICollectionViewModel;
        var column:DataGridColumn = dgModel.columns[listData.columnIndex];

        super.data = value;
        
        if (column.labelFunction)
        {
            this.text = column.labelFunction(value, column);
        }

		dispatchEvent(new FlexEvent("dataChange"));
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
    
    public function setStyle(styleName:String, value:Object):void
    {
	//	var selectionBead:AdvancedDataGridSelectableItemRendererBead;
        COMPILE::JS
        {
            if (styleName == "textRollOverColor")
			{
				/*selectionBead = getSelectionRenderBead(this) as AdvancedDataGridSelectableItemRendererBead;
                selectionBead.textRollOverColor = String(value);*/
                trace('todo textRollOverColor')
			}
            else if (styleName == "textSelectedColor")
			{
				/*selectionBead = getSelectionRenderBead(this) as AdvancedDataGridSelectableItemRendererBead;
                selectionBead.textSelectedColor = String(value);*/
                trace('todo textSelectedColor')
			}
            else
                element.style[styleName] = value;        
        }
    }


    //----------------------------------
    //  styleName
    //----------------------------------

    COMPILE::JS
    override protected function computeFinalClassNames():String
    {
        var computed:String = super.computeFinalClassNames();
        if (typeof _styleName == 'string') computed += ' ' + _styleName;
        return  computed;
    }

    /**
     *  @private
     *  Storage for the styleName property.
     */
    private var _styleName:Object /* String, CSSStyleDeclaration, or UIComponent */;

    /**
     *  @copy mx.core.UIComponent#styleName
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get styleName():Object /* String, CSSStyleDeclaration, or UIComponent */
    {
        return _styleName;
    }

    /**
     *  @private
     */
    public function set styleName(value:Object /* String, CSSStyleDeclaration, or UIComponent */):void
    {
        if (_styleName === value)
            return;

        _styleName = value;
        if (typeof value == 'string' || !value) {
            COMPILE::JS{
                if (_styleName) element.classList.remove(_styleName);
                _styleName = value;
                if (value) element.classList.add(value)
            }
            COMPILE::SWF{
                trace("styleName not yet implemented for string assignments");
            }
        } else {
            // TODO
            trace("styleName not implemented for non-string assignments");
        }


		/*
        if (parent)
        {
            StyleProtoChain.initTextField(this);
            styleChanged("styleName");
        }
		*/
        // If we don't have a parent pointer yet, then we'll wait
        // and initialize the proto chain when the parentChanged()
        // method is called.
    }

    //----------------------------------
    //  systemManager
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#systemManager
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get systemManager():ISystemManager
    {
        var o:IUIComponent = parent as IUIComponent;
        while (o)
        {
            var ui:IUIComponent = o as IUIComponent;
            if (ui)
                return ui.systemManager;

            o = o.parent as IUIComponent;
        }

        return null;
    }

    /**
     *  @private
     */
    public function set systemManager(value:ISystemManager):void
    {
        // Not supported
    }

    //----------------------------------
    //  isPopUp
    //----------------------------------
    /**
     *  @copy mx.core.UIComponent#isPopUp
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get isPopUp():Boolean
    {
    return false;
    }
    
    /**
     *  @private
     */
    public function set isPopUp(value:Boolean):void
    {
    }

    /**
     *  @copy mx.core.UIComponent#getExplicitOrMeasuredWidth()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getExplicitOrMeasuredWidth():Number
    {
        return !isNaN(explicitWidth) ? explicitWidth : measuredWidth;
    }

    /**
     *  @copy mx.core.UIComponent#getExplicitOrMeasuredHeight()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getExplicitOrMeasuredHeight():Number
    {
        return !isNaN(explicitHeight) ? explicitHeight : measuredHeight;
    }

    //----------------------------------
    //  explicitMaxHeight
    //----------------------------------

    /**
     *  Number that specifies the maximum height of the component, 
     *  in pixels, in the component's coordinates, if the maxHeight property
     *  is set. Because maxHeight is read-only, this method returns NaN. 
     *  You must override this method and add a setter to use this
     *  property.
     *  
     *  @see mx.core.UIComponent#explicitMaxHeight
     *  
     *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get explicitMaxHeight():Number
    {
        return NaN;
    }

    //----------------------------------
    //  explicitMaxWidth
    //----------------------------------

    /**
     *  Number that specifies the maximum width of the component, 
     *  in pixels, in the component's coordinates, if the maxWidth property
     *  is set. Because maxWidth is read-only, this method returns NaN. 
     *  You must override this method and add a setter to use this
     *  property.
     *  
     *  @see mx.core.UIComponent#explicitMaxWidth
     *  
     *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get explicitMaxWidth():Number
    {
        return NaN;
    }

    //----------------------------------
    //  explicitMinHeight
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#explicitMinHeight
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get explicitMinHeight():Number
    {
        return NaN;
    }

    //----------------------------------
    //  explicitMinWidth
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#explicitMinWidth
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get explicitMinWidth():Number
    {
        return NaN;
    }

    //----------------------------------
    //  enabled
    //----------------------------------

    /**
     *  @private
     *  Storage for the enabled property.
     */
    private var _enabled:Boolean = true;

    /**
     *  A Boolean value that indicates whether the component is enabled. 
     *  This property only affects
     *  the color of the text and not whether the UITextField is editable.
     *  To control editability, use the 
     *  <code>flash.text.TextField.type</code> property.
     *  
     *  @default true
     *  @see flash.text.TextField
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get enabled():Boolean
    {
        return _enabled;
    }

    /**
     *  @private
     */
    public function set enabled(value:Boolean):void
    {
        //mouseEnabled = value;
        _enabled = value;

        //styleChanged("color");
    }

    //----------------------------------
    //  minHeight
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#minHeight
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minHeight():Number
    {
        return 0;
    }

    //----------------------------------
    //  minWidth
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#minWidth
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minWidth():Number
    {
        return 0;
    }

    //----------------------------------
    //  maxHeight
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#maxHeight
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxHeight():Number
    {
        return UIComponent.DEFAULT_MAX_HEIGHT;
    }

    //----------------------------------
    //  maxWidth
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#maxWidth
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxWidth():Number
    {
        return UIComponent.DEFAULT_MAX_WIDTH;
    }

    //--------------------------------------------------------------------------
    //
    //  IUIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns <code>true</code> if the child is parented or owned by this object.
     *
     *  @param child The child DisplayObject.
     *
     *  @return <code>true</code> if the child is parented or owned by this UITextField object.
     * 
     *  @see #owner
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function owns(child:IUIBase):Boolean
    {
        return child == this;
    }

    //----------------------------------
    //  measuredMinHeight
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#measuredMinHeight
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get measuredMinHeight():Number
    {
        return 0;
    }

    /**
     *  @private
     */
    public function set measuredMinHeight(value:Number):void
    {
    }

    //----------------------------------
    //  measuredMinWidth
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#measuredMinWidth
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get measuredMinWidth():Number
    {
        return 0;
    }

    /**
     *  @private
     */
    public function set measuredMinWidth(value:Number):void
    {
    }

    //----------------------------------
    //  owner
    //----------------------------------

    /**
     *  @private
     */
    private var _owner:IUIComponent;

    /**
     *  By default, set to the parent container of this object. 
     *  However, if this object is a child component that is 
     *  popped up by its parent, such as the dropdown list of a ComboBox control, 
     *  the owner is the component that popped up this object. 
     *
     *  <p>This property is not managed by Flex, but by each component. 
     *  Therefore, if you use the <code>PopUpManger.createPopUp()</code> or 
     *  <code>PopUpManger.addPopUp()</code> method to pop up a child component, 
     *  you should set the <code>owner</code> property of the child component 
     *  to the component that popped it up.</p>
     * 
     *  <p>The default value is the value of the <code>parent</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get owner():IUIComponent
    {
        return _owner ? _owner : parent as IUIComponent;
    }

    public function set owner(value:IUIComponent):void
    {
        _owner = value;
    }

    //----------------------------------
    //  includeInLayout
    //----------------------------------

    /**
     *  @private
     *  Storage for the includeInLayout property.
     */
    private var _includeInLayout:Boolean = true;

    /**
     *  @copy mx.core.UIComponent#includeInLayout
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get includeInLayout():Boolean
    {
        return _includeInLayout;
    }

    /**
     *  @private
     */
    public function set includeInLayout(value:Boolean):void
    {
        if (_includeInLayout != value)
        {
            _includeInLayout = value;

			/*
            var p:IInvalidating = parent as IInvalidating;
            if (p)
            {
                p.invalidateSize();
                p.invalidateDisplayList();
            }
			*/
        }
    }

    //----------------------------------
    //  document
    //----------------------------------

    /**
     *  @private
     *  Storage for the enabled property.
     */
    private var _mxmlDocument:Object;

    /**
     *  A reference to the document object associated with this UITextField object. 
     *  A document object is an Object at the top of the hierarchy of a Flex application, 
     *  MXML component, or AS component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get mxmlDocument():Object
    {
        return _mxmlDocument;
    }

    /**
     *  @private
     */
    public function set mxmlDocument(value:Object):void
    {
        _mxmlDocument = value;
    }

    //----------------------------------
    //  measuredWidth
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#measuredWidth
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get measuredWidth():Number
    {
		COMPILE::JS
		{
			return element.offsetWidth;
		}
		COMPILE::SWF
		{
			return super.width;
		}        
    }

    //----------------------------------
    //  measuredHeight
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#measuredHeight
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get measuredHeight():Number
    {
		COMPILE::JS
		{
			return element.offsetHeight;
		}
		COMPILE::SWF
		{
			return super.height;
		}        
    }

    /**
     *  Initializes this component.
     *
     *  <p>This method is required by the IUIComponent interface,
     *  but it actually does nothing for a UITextField.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function initialize():void
    {
    }

    /**
     *  @copy mx.core.UIComponent#move()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function move(x:Number, y:Number):void
    {
        // Performance optimization: if the position hasn't changed, don't let
        // the player think that we're dirty
        if (this.x != x)
            this.x = x;
        if (this.y != y)           
            this.y = y;
    }

    /**
     *  @copy mx.core.UIComponent#setActualSize()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setActualSize(w:Number, h:Number):void
    {
        // Performance optimization: if the size hasn't changed, don't let
        // the player think that we're dirty
        if (width != w)
            width = w;
        if (height != h)
            height = h;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  @royaleignorecoercion mx.core.IUIComponent
     */
    [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent", returns="flash.display.DisplayObject"))]
    COMPILE::SWF 
    { override }
    public function addChild(child:IUIComponent):IUIComponent
    {
        return null;
    }
    
    
    /**
     *  @private
     *  @royaleignorecoercion mx.core.IUIComponent
     */
    [SWFOverride(params="flash.display.DisplayObject,int", altparams="mx.core.UIComponent,int", returns="flash.display.DisplayObject"))]
    COMPILE::SWF 
    { override }
    public function addChildAt(child:IUIComponent,
                                        index:int):IUIComponent
    {
        return null;
    }
    
    /**
     *  @private
     *  @royaleignorecoercion mx.core.IUIComponent
     */
    [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent", returns="flash.display.DisplayObject"))]
    COMPILE::SWF 
    { override }
    public function removeChild(child:IUIComponent):IUIComponent
    {
        return null;
    }
    
    COMPILE::JS
	public function swapChildren(child1:IUIComponent, child2:IUIComponent):void
	{
	
	}
    /**
     *  @private
     *  @royaleignorecoercion mx.core.IUIComponent
     */
    [SWFOverride(returns="flash.display.DisplayObject"))]
    COMPILE::SWF 
    { override }
    public function removeChildAt(index:int):IUIComponent
    {
        // this should probably call the removingChild/childRemoved
        return null;
    }
    
    /**
     *  @private
     *  @royaleignorecoercion mx.core.IUIComponent
     */
    [SWFOverride(returns="flash.display.DisplayObject"))]
    COMPILE::SWF 
    { override }
    public function getChildAt(index:int):IUIComponent
    {
        return null;
    }
    
    /**
     *  @private
     */
    COMPILE::SWF 
    { override }
    public function get numChildren():int
    {
        return 0;
    }
    
    /**
     *  @private
     */
    [SWFOverride(params="flash.display.DisplayObject,int", altparams="mx.core.UIComponent,int"))]
    COMPILE::SWF 
    { override }
    public function setChildIndex(child:IUIComponent, index:int):void
    {
        trace("setChildIndex not implemented");
    }

    /**
     *  @private
     */
    [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent"))]
    COMPILE::SWF 
    { override }
    public function getChildIndex(child:IUIComponent):int
    {
        return -1;
    }

    /**
     *  @private
     */
    [SWFOverride(returns="flash.display.DisplayObject"))]
    COMPILE::SWF 
    { override }
    public function getChildByName(name:String):IUIComponent
    {
        trace("getChildByName not implemented");
        return null;
    }

    /**
     *  @private
     */
    [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent"))]
    COMPILE::SWF 
    { override }
    public function contains(child:IUIBase):Boolean
    {
		return child == this;
    }

    COMPILE::JS
	private var _rotation:Number = 0;
	 
    COMPILE::JS
	public function get rotation():Number
	{
	    return _rotation;
	}
    
    COMPILE::JS
    public function set rotation(value:Number):void
	{
	   	_rotation = value;
        element.style.transform = computeTransformString();
        element.style["transform-origin-x"] = "0px";
        element.style["transform-origin-y"] = "0px";
	}
	
    COMPILE::JS
	private function computeTransformString():String
    {
        var s:String = "";
        var value:Number = _rotation;
        if (_rotation != 0)
        {
            if (value < 0)
                value += 360;
            s += "rotate(" + value.toString() + "deg)";
        }
        if (_scaleX != 1.0)
        {
            if (s.length)
                s += " ";
            s += "scaleX(" + _scaleX.toString() + ")";
        }
        if (_scaleY != 1.0)
        {
            if (s.length)
                s += " ";
            s += "scaleY(" + _scaleY.toString() + ")";
        }
        return s;
    }

    COMPILE::JS
    private var _scaleX:Number = 1.0;
    
	COMPILE::JS
	public function get scaleX():Number
	{
		return _scaleX;
	}
	
	COMPILE::JS
	public function set scaleX(value:Number):void
	{
        _scaleX = value;
        element.style.transform = computeTransformString();
	}
	
    COMPILE::JS
    private var _scaleY:Number = 1.0;
    
	COMPILE::JS
	public function get scaleY():Number
	{
		return _scaleY;
	}
	
	COMPILE::JS
	public function set scaleY(value:Number):void
	{
        _scaleY = value;
        element.style.transform = computeTransformString();
	}

    /**
     *  localToGlobal
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [SWFOverride(params="flash.geom.Point", altparams="org.apache.royale.geom.Point", returns="flash.geom.Point"))]
    COMPILE::SWF 
    { override }
    public function localToGlobal(value:Point):Point
    {
        COMPILE::SWF
        {
            var o:Object = super.localToGlobal(value);
            return new org.apache.royale.geom.Point(o.x, o.y);
        }
        return PointUtils.localToGlobal(value, this);
    }
    
    /**
     *  globalToLocal
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [SWFOverride(params="flash.geom.Point", altparams="org.apache.royale.geom.Point", returns="flash.geom.Point"))]
    COMPILE::SWF 
    { override }
    public function globalToLocal(value:Point):Point
    {
        COMPILE::SWF
        {
            var o:Object = super.globalToLocal(value);
            return new org.apache.royale.geom.Point(o.x, o.y);
        }
        return PointUtils.globalToLocal(value, this);
    }

    //----------------------------------
    //  cacheAsBitmap
    //----------------------------------

    COMPILE::JS
    public function get cacheAsBitmap():Boolean
    {
        // TODO
        trace("cacheAsBitmap not implemented");
        return false;
    }
    
    /**
     *  @private
     */
    COMPILE::SWF
    {
        override
    }
    public function set cacheAsBitmap(value:Boolean):void
    {
        // TODO
        trace("cacheAsBitmap not implemented");
    }

    //----------------------------------
    //  filters
    //----------------------------------

    /**
     *  @private
     *  Storage for the filters property.
     */
    private var _filters:Array;

    /**
     *  @private
     */
    COMPILE::SWF
    {
        override
    }
    public function get filters():Array
    {
        return _filters;
    }

    /**
     *  @private
     */
    COMPILE::SWF
    {
        override
    }
    public function set filters(value:Array):void
    {
        // TODO
        trace("filters not implemented");
    }

    //----------------------------------
    //  name
    //----------------------------------
    
    /**
     *  @private
     */
    COMPILE::JS
    private var _name:String;
    
    /**
     *  @copy mx.core.IVisualElement#owner
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @royaleignorecoercion mx.core.IUIComponent
     */
    COMPILE::JS
    public function get name():String
    {
        return _name;
    }
    
    COMPILE::JS
    public function set name(value:String):void
    {
        _name = value;
    }

    /**
     *  mouseX
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::JS
    public function get mouseX():Number
    {
        trace("mouseX not implemented");
        return 0;
    }
    
    /**
     *  mouseY
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::JS
    public function get mouseY():Number
    {
        trace("mouseX not implemented");
        return 0;
    }

}

}
