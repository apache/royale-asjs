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
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextLineMetrics;
*/
import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridButtonBar;
import mx.controls.beads.DataGridView;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.ClassFactory;
import mx.core.IDataRenderer;
import mx.core.IFactory;
import mx.core.IInvalidating;
import mx.core.IToolTip;
import mx.core.IUIComponent;
import mx.core.IUITextField;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.events.ToolTipEvent;
import mx.managers.ISystemManager;

import org.apache.royale.core.IChild;
import org.apache.royale.core.TextLineMetrics;
import org.apache.royale.events.Event;
import org.apache.royale.events.ItemClickedEvent;
import org.apache.royale.events.MouseEvent;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
import org.apache.royale.html.DataGridButtonBar;

use namespace mx_internal;

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
 *  @productversion Flex 3
 */
[Event(name="dataChange", type="mx.events.FlexEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Text color of a component label.
 *  @default 0x0B333C
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="color", type="uint", format="Color", inherit="yes")]

/**
 *  Color of the separator between the text part and icon part.
 *  @default 0xCCCCCC
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="separatorColor", type="uint", format="Color", inherit="yes")]


/**
 *  Horizontal alignment of the header text.
 *  Possible values are <code>"left"</code>, <code>"center"</code>,
 *  and <code>"right"</code>.
 *
 *  @default "center"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="horizontalAlign", type="String", enumeration="left,center,right", inherit="no")]

/**
 *  Vertical alignment of the header text.
 *  Possible values are <code>"top"</code>, <code>"middle"</code>,
 *  and <code>"bottom"</code>.
 *
 *  @default "middle"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="verticalAlign", type="String", enumeration="top,middle,bottom", inherit="no")]

/** 
 *  The AdvancedDataGridHeaderRenderer class defines the default header
 *  renderer for a AdvancedDataGrid control.  
 *  By default, the header renderer
 *  draws the text associated with each header in the list, and an optional
 *  sort arrow (if sorted by that column).
 *
 *  <p> By default, the custom header renderer uses the default 
 *  sort item renderer defined by the AdvancedDataGridSortItemRenderer class. 
 *  The sort item renderer controls the display of the 
 *  sort icon and sort sequence number.  
 *  You can specify a custom sort item renderer by using 
 *  the <code>sortItemRenderer</code> property.</p>
 *
 *  <p>You can override the default header renderer by creating a custom
 *  header renderer.
 *  The only requirement for a custom header renderer is that it
 *  must include the size of the <code>sortItemRenderer</code> 
 *  in any size calculations performed by an override of the 
 *  <code>measure()</code> and <code>updateDisplayList()</code> methods.</p>
 *
 *  <p>You can customize when the sorting gets triggered by
 *  handling or dispatching the <code>AdvancedDataGridEvent.SORT</code> event.</p>
 *
 *  @see mx.controls.AdvancedDataGrid
 *  @see mx.controls.advancedDataGridClasses.AdvancedDataGridSortItemRenderer
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class AdvancedDataGridHeaderRenderer extends UIComponent implements IDataRenderer,
 IDropInListItemRenderer, IListItemRenderer
      
{
   // include "../../core/Version.as";
    
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
    public function AdvancedDataGridHeaderRenderer()
    {
        super();
        
        typeNames = "AdvancedDataGridHeaderRenderer";

        // InteractiveObject variables.
        tabEnabled   = false;
        addEventListener(ToolTipEvent.TOOL_TIP_SHOW, toolTipShowHandler); 
        addEventListener('click',handleClickEvent);
    }
    
    /**
     * @private
     */
    protected function handleClickEvent(event:MouseEvent):void
    {
        var newEvent:ItemClickedEvent = new ItemClickedEvent("itemClicked");
        newEvent.index = index;
        newEvent.data = data;
        dispatchEvent(newEvent);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var grid:AdvancedDataGrid;

    /**
     *  @private
     *  The value of the unscaledWidth parameter during the most recent
     *  call to updateDisplayList
     */
    private var oldUnscaledWidth:Number = -1;

    /**
     *  @private
     *  header separator skin
     */
    private var partsSeparatorSkinClass:Class;
    private var partsSeparatorSkin:IUIComponent;
    
    /**
     *  @private
     *  Storage for the sortItemRenderer property
     */
    private var sortItemRendererInstance:UIComponent;
    private var sortItemRendererChanged:Boolean = false;
    
    /**
     *  The internal UITextField that displays the text in this renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var label:IUITextField;

    /**
     *  This background is used as a mouseShield so that the mouse clicks do not pass
     *  through to the parent component, but all mouse events within the header area
     *  are handled by the header itself.
     *
     *  Inspired by mouseShield in mx/core/Container.as and mx/skins/halo/HaloBorder.as.
     *
     *  @private
     */
    protected var background:UIComponent;

    //--------------------------------------------------------------------------
    //
    //  Overridden properties: UIComponent
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  baselinePosition
    //----------------------------------

    /**
     *  @private
     */
    override public function get baselinePosition():Number
    {
        // return label.baselinePosition;
        return 0;
    } 

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

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
     *  The implementation of the <code>data</code> property
     *  as defined by the IDataRenderer interface.
     *  When set, it stores the value and invalidates the component 
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

        var col:AdvancedDataGridColumn = (value as AdvancedDataGridColumn);
        var ld:AdvancedDataGridListData = new AdvancedDataGridListData(getColumnLabel(col),
                col.dataField, 
                col.colNum, "", col.owner);
        listData = ld;
        
        invalidateProperties();
        commitProperties();

        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    } 
    
    private function getColumnLabel(col:DataGridColumn):String
    {
        var label:String = col.headerText != null ? col.headerText : col.dataField;
        COMPILE::JS
        {
            if (label)
                label = label.replace(" ", "&nbsp;");
        }
        var dg:UIComponent = col.owner;
        if (index == ((dg.view as DataGridView).header as AdvancedDataGridButtonBar).selectedIndex)
        {
            label += " " + (col.sortDescending ? "▼" : "▲");
        }
        
        return label;
    }

    //----------------------------------
    //  sortItemRenderer
    //----------------------------------

    private var _sortItemRenderer:IFactory;

    [Inspectable(category="Data")] 
    /**
     *  Specifies a custom sort item renderer.
     *  By default, the AdvancedDataGridHeaderRenderer class uses 
     *  AdvancedDataGridSortItemRenderer as the sort item renderer.
     *
     *  <p>Note that the sort item renderer controls the display of the
     *  sort icon and sort sequence number. 
     *  A custom header renderer must include code to display the
     *  sort item renderer, regardless of whether it is the default or custom
     *  sort item renderer.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get sortItemRenderer():IFactory
    {
            return _sortItemRenderer;
    } 

    /**
     *  @private
     */
    public function set sortItemRenderer(value:IFactory):void
    {
            _sortItemRenderer = value;

            sortItemRendererChanged = true;
            invalidateSize();
            invalidateDisplayList();
	    updateDisplayList(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
            dispatchEvent(new Event("sortItemRendererChanged"));
    } 

    //----------------------------------
    //  listData
    //----------------------------------

    /**
     *  @private
     *  Storage for the listData property.
     */
    private var _listData:AdvancedDataGridListData;

    [Bindable("dataChange")] 

    /**
     *  The implementation of the <code>listData</code> property
     *  as defined by the IDropInListItemRenderer interface.
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
        _listData = AdvancedDataGridListData(value);
        grid      = AdvancedDataGrid(_listData.owner);

        invalidateProperties();
    } 

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function createChildren():void
    {
        super.createChildren();

        if (!label)
        {
            label = IUITextField(createInFontContext(UITextField));
            addChild(IUIComponent(label));
        }

        if (!background)
        {
            background = new UIComponent();
            addChild(background);
        }
    } 
    
    private var childHeaders:DataGridButtonBar;

    private var usingHTML:Boolean;
    
    /**
     *  @private
     *  Apply the data and listData.
     *  Create an instance of the sort item renderer if specified,
     *  and set the text into the text field.
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (!initialized)
            label.styleName = this;

        if (!sortItemRendererInstance || sortItemRendererChanged)
        {
            // if (!sortItemRenderer)
            //     sortItemRenderer = ClassFactory(grid.sortItemRenderer);

            if (sortItemRenderer)
            {
                sortItemRendererInstance = sortItemRenderer.newInstance();

                // TODO Ideally, we should be doing this, but commenting out
                // now because of Bug 204187:
                //
                // sortItemRendererInstance.owner = grid;

                addChild( IUIComponent(sortItemRendererInstance) );
            }

             sortItemRendererChanged = false;
        }

        // Handle skin for the separator between the text and icon parts
        var oldPartsSeparatorSkinClass:Class = partsSeparatorSkinClass;
        if (!partsSeparatorSkinClass
                || partsSeparatorSkinClass != grid.getStyle("headerSortSeparatorSkin"))
        {
            partsSeparatorSkinClass = grid.getStyle("headerSortSeparatorSkin");
        }
        if (grid.sortExpertMode || partsSeparatorSkinClass != oldPartsSeparatorSkinClass)
        {
            if (partsSeparatorSkin)
                removeChild(partsSeparatorSkin);
            if (!grid.sortExpertMode)
            {
                partsSeparatorSkin = new partsSeparatorSkinClass();
                addChild(partsSeparatorSkin);
            }
        }
        if (partsSeparatorSkin)
            partsSeparatorSkin.visible = !(_data is AdvancedDataGridColumnGroup);

        if (_data != null)
        {
            var lbl:String = listData.label ? listData.label : " ";
            if (lbl.indexOf("&nbsp;") >= 0)
            {
                label.htmlText = lbl;
                usingHTML = true;
            }
            else
                label.text = lbl;
            // label.multiline = grid.variableRowHeight;
            // if( _data is AdvancedDataGridColumn)
            //     label.wordWrap = grid.columnHeaderWordWrap(_data as AdvancedDataGridColumn);
                
                
//             if (listData.columnIndex > -1)
//                 label.wordWrap = grid.columnHeaderWordWrap(grid.columns[listData.columnIndex]);
            // else
            //     label.wordWrap = grid.wordWrap;

            if (_data is AdvancedDataGridColumn)
            {
                var column:AdvancedDataGridColumn =
                    _data as AdvancedDataGridColumn;
                    
                var dataTips:Boolean = grid.showDataTips;
                if (column.showDataTips == true)
                    dataTips = true;
                if (column.showDataTips == false)
                    dataTips = false;
                if (dataTips)
                {
                    // if (label.textWidth > label.width 
                    //     || column.dataTipFunction || column.dataTipField 
                    //     || grid.dataTipFunction || grid.dataTipField)
                    // {
                    //     toolTip = column.itemToDataTip(_data);
                    // }
                    // else
                    // {
                    //     toolTip = null;
                    // }
                }
                else
                {
                    toolTip = null;
                }
                if (data is AdvancedDataGridColumnGroup)
                {
                    var adgcg:AdvancedDataGridColumnGroup = data as AdvancedDataGridColumnGroup;
                    childHeaders = new AdvancedDataGridButtonBar();
                    childHeaders.dataProvider = adgcg.children;
                    addElement(childHeaders);                    
                }
             }
        }
        else
        {
            label.text = " ";
            toolTip = null;
        }

        if (sortItemRendererInstance is IInvalidating)
            IInvalidating(sortItemRendererInstance).invalidateProperties();
    } 

    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();

        // Cache padding values
        var paddingLeft:int   = getStyle("paddingLeft");
        var paddingRight:int  = getStyle("paddingRight");
        var paddingTop:int    = getStyle("paddingTop");
        var paddingBottom:int = getStyle("paddingBottom");

        // Measure sortItemRenderer
        var sortItemRendererWidth:Number  = sortItemRendererInstance ?
                                sortItemRendererInstance.getExplicitOrMeasuredWidth()  : 0;
        var sortItemRendererHeight:Number = sortItemRendererInstance ?
                                sortItemRendererInstance.getExplicitOrMeasuredHeight() : 0;
        if (grid.sortExpertMode && getFieldSortInfo() == null)
        {
            sortItemRendererWidth  = 0;
            sortItemRendererHeight = 0;
        }

        var horizontalGap:Number = getStyle("horizontalGap");
        if (sortItemRendererWidth == 0)
            horizontalGap = 0;

        // Measure text
        var labelWidth:Number  = 0;
        var labelHeight:Number = 0;
        var w:Number = 0;
        var h:Number = 0;

        // By default, we already get the column's width
        if (!isNaN(explicitWidth))
        {
            w = explicitWidth;
            labelWidth = w - sortItemRendererWidth
                            - horizontalGap
                            - (partsSeparatorSkin ? partsSeparatorSkin.width + 10 : 0)
                            - paddingLeft - paddingRight;
            label.width = labelWidth;
            // Inspired by mx.controls.Label#measureTextFieldBounds():
            // In order to display the text completely,
            // a TextField must be 4-5 pixels larger.
            labelHeight = label.textHeight + UITextField.TEXT_HEIGHT_PADDING;
        }
        else
        {
            var lineMetrics:TextLineMetrics = measureText(usingHTML ? label.htmlText : label.text);
            labelWidth  = lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
            labelHeight = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
            w = labelWidth + horizontalGap
                           + (partsSeparatorSkin ? partsSeparatorSkin.width : 0)
                           + sortItemRendererWidth
        }

        h = Math.max(labelHeight, sortItemRendererHeight);
        h = Math.max(h, (partsSeparatorSkin ? partsSeparatorSkin.height : 0));

        // Add padding
        w += paddingLeft + paddingRight;
        h += paddingTop  + paddingBottom;

        // Set required width and height
        measuredMinWidth  = measuredWidth  = w;
        measuredMinHeight = measuredHeight = h;
    } 
    
    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        if (unscaledWidth == 0)
            return;

        // Cache padding values
        var paddingLeft:int   = getStyle("paddingLeft");
        var paddingRight:int  = getStyle("paddingRight");
        var paddingTop:int    = getStyle("paddingTop");
        var paddingBottom:int = getStyle("paddingBottom");

        // Size of sortItemRenderer
        var sortItemRendererWidth:Number  = sortItemRendererInstance ?
                                sortItemRendererInstance.getExplicitOrMeasuredWidth()  : 0;
        var sortItemRendererHeight:Number = sortItemRendererInstance ?
                                sortItemRendererInstance.getExplicitOrMeasuredHeight() : 0;
        if (sortItemRendererInstance)
            sortItemRendererInstance.setActualSize(sortItemRendererWidth,
                                                    sortItemRendererHeight);
        if (grid.sortExpertMode && getFieldSortInfo() == null)
        {
            sortItemRendererWidth  = 0;
            sortItemRendererHeight = 0;
        }

        var horizontalGap:Number = getStyle("horizontalGap");
        if (sortItemRendererWidth == 0)
            horizontalGap = 0;

        // Adjust to given width
        var lineMetrics:TextLineMetrics = measureText(usingHTML ? label.htmlText: label.text);
        var labelWidth:Number  = lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
        var maxLabelWidth:int = unscaledWidth - sortItemRendererWidth
                                - horizontalGap - paddingLeft - paddingRight;
        if (maxLabelWidth < 0)
            maxLabelWidth = 0; // set the max width to 0, if its < 0

        var truncate:Boolean = false;
        
        if (maxLabelWidth < labelWidth)
        {
            truncate = true;
            labelWidth = maxLabelWidth;
        }

        // Adjust to given height
        var labelHeight:Number = label.textHeight + UITextField.TEXT_HEIGHT_PADDING;
        var maxLabelHeight:int = unscaledHeight - paddingTop - paddingBottom;

        if (maxLabelHeight < labelHeight)
        {
            truncate = true;
            labelHeight = maxLabelHeight;
        }

        // Size of label
        label.setActualSize(labelWidth, labelHeight);
        
        // truncate only if the truncate flag is set
        // if (truncate && !label.multiline)
        //     label.truncateToFit();

        // Calculate position of label, by default center it
        var labelX:Number;
        var horizontalAlign:String = getStyle("horizontalAlign");
        if (horizontalAlign == "left")
        {
            labelX = paddingLeft;
        }
        else if (horizontalAlign == "right")
        {
            labelX = unscaledWidth - paddingRight - sortItemRendererWidth
                        - horizontalGap - labelWidth;
        }
        else // if (horizontalAlign == "center")
        {
            labelX = (unscaledWidth - labelWidth - paddingLeft
                        - paddingRight - horizontalGap
                        - sortItemRendererWidth)/2 + paddingLeft;
        }
        labelX = Math.max(labelX, 0);

        var labelAreaHeight:Number = unscaledHeight;
        if (childHeaders)
            labelAreaHeight /= 2;
        
        var labelY:Number;
        var verticalAlign:String = getStyle("verticalAlign");
        if (verticalAlign == "top")
        {
            labelY = paddingTop;
        }
        else if (verticalAlign == "bottom")
        {
            labelY = labelAreaHeight - labelHeight - paddingBottom + 2; // 2 for gutter
        }
        else // if (verticalAlign == "middle")
        {
            labelY = (labelAreaHeight - labelHeight - paddingBottom - paddingTop)/2
                     + paddingTop;
        }
        labelY = Math.max(labelY, 0);

        // Set positions
        label.x = Math.round(labelX);
        label.y = Math.round(labelY);

        if (sortItemRendererInstance)
        {
            // Calculate position of sortItemRenderer (to the right of the headerRenderer)
            var sortItemRendererX:Number = unscaledWidth
                                            - sortItemRendererWidth
                                            - paddingRight
                                            ;
            var sortItemRendererY:Number = (unscaledHeight - sortItemRendererHeight
                                            - paddingTop - paddingBottom
                                            ) / 2
                                            + paddingTop;

            sortItemRendererInstance.x = Math.round(sortItemRendererX);
            sortItemRendererInstance.y = Math.round(sortItemRendererY);
        }

        // Draw the separator
        graphics.clear();
        if (sortItemRendererInstance && !grid.sortExpertMode
                &&  !(_data is AdvancedDataGridColumnGroup))
        {
            if (!partsSeparatorSkinClass)
            {
                graphics.lineStyle(1, getStyle("separatorColor") !== undefined
                                        ? getStyle("separatorColor") : 0xCCCCCC);
                graphics.moveTo(sortItemRendererInstance.x - 1, 1);
                graphics.lineTo(sortItemRendererInstance.x - 1, unscaledHeight - 1);
            }
            else
            {
                partsSeparatorSkin.x = sortItemRendererInstance.x
                                       - horizontalGap - partsSeparatorSkin.width;
                partsSeparatorSkin.y = (unscaledHeight - partsSeparatorSkin.height) / 2;
            }
        }

        // Set text color
        var labelColor:Number;

        if (data && parent)
        {
            if (!enabled)
                labelColor = getStyle("disabledColor");
            // else if (grid.isItemHighlighted(listData.uid))
            //     labelColor = getStyle("textRollOverColor");
            //else if (grid.isItemSelected(listData.uid))
            //    labelColor = getStyle("textSelectedColor");
            else
                labelColor = getStyle("color");

           label.setColor(labelColor);
        }

        // Set background size, position, color
        if (background)
        {
            background.graphics.clear();
            background.graphics.beginFill(0xFFFFFF, 0.0); // transparent
            background.graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
            background.graphics.endFill();
            setChildIndex( IUIComponent(background), 0 );
        }
        if (childHeaders)
        {
            var adgcg:AdvancedDataGridColumnGroup = data as AdvancedDataGridColumnGroup;
            var buttonWidths:Array = [];
            for (var i:int = 0; i < adgcg.children.length; i++)
                buttonWidths.push((adgcg.children[i] as DataGridColumn).columnWidth);
            childHeaders.buttonWidths = buttonWidths;
            childHeaders.height = unscaledHeight / 2;
            childHeaders.width = unscaledWidth;
            childHeaders.x = 0;
            childHeaders.y = unscaledHeight / 2;
        }
    } 

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /** 
     *  Indicates if the mouse pointer was over the text part or icon part 
     *  of the header when the mouse event occurred.
     *
     *  <p>This method has to be implemented in custom header renderers for sorting
     *  to work. Note that this implicitly means you will need to display both
     *  text (which can be displayed any way the custom header renderer
     *  wants; by default, Flex display text) and an icon (which is the
     *  default or custom sort item renderer).</p>
     *
     *  @param event The mouse event.
     *
     *  @return <code>AdvancedDataGrid.HEADERTEXTPART</code> if the mouse was over the header text, 
     *  and <code>AdvancedDataGrid.HEADERICONPART</code> if the mouse was over the header icon.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function mouseEventToHeaderPart(event:MouseEvent):String
    {
        return null;
        // if(sortItemRendererInstance == null)
        //     return AdvancedDataGrid.HEADER_TEXT_PART;

        // var point:Point = new Point(event.stageX, event.stageY);
        // point = globalToLocal(point);

        // // Needs to be in sync with the logic in measure() and updateDisplayList()
        // return point.x < sortItemRendererInstance.x
        //                  ? AdvancedDataGrid.HEADER_TEXT_PART
        //                  : AdvancedDataGrid.HEADER_ICON_PART;
    } 

    /**
     *  Returns the sort information for this column from the AdvancedDataGrid control
     *  so that the control can display the column's number in the sort sequence,
     *  and whether the sort is ascending or descending. 
     *  The sorting information is represented by an instance of the SortInfo class,
     *  where each column in the AdvancedDataGrid control has an associated 
     *  SortInfo instance.
     *
     *  @return A SortInfo instance.
     *
     *  @see mx.controls.advancedDataGridClasses.SortInfo
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    // protected function getFieldSortInfo():SortInfo
    protected function getFieldSortInfo():Object
    {
       	// return grid.getFieldSortInfo(grid.mx_internal::rawColumns[listData.columnIndex]);
       	return null;
    } 

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  Positions the tooltip in the header.
     *
     *  @param The Event object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function toolTipShowHandler(event:ToolTipEvent):void
    {
        var toolTip:IToolTip = event.toolTip;
		var xPos:int = IUIComponent(systemManager).mouseX + 11;
        var yPos:int = IUIComponent(systemManager).mouseY + 22;
        // Calculate global position of label.
        var pt:Point = new Point(xPos, yPos);
        pt = UIComponent(systemManager).localToGlobal(pt);
        pt = UIComponent(systemManager.getSandboxRoot()).globalToLocal(pt);           
        
        toolTip.move(pt.x, pt.y + (height - toolTip.height) / 2);
            
        var screen:Rectangle = toolTip.screen;
        var screenRight:Number = screen.x + screen.width;
        if (toolTip.x + toolTip.width > screenRight)
            toolTip.move(screenRight - toolTip.width, toolTip.y);

    } 

    /**
     *  @private
     */
    mx_internal function getLabel():IUITextField
    {
        return label;
    } 

    override public function setWidth(value:Number, noEvent:Boolean = false):void
    {
        super.setWidth(value, noEvent);
        updateDisplayList(width, height);
    }

    override public function get systemManager():ISystemManager
    {
        var sm:ISystemManager = super.systemManager;
        if (!sm)
        {
            // skip a layer because parent ButtonBar is not IUIComponent
            systemManager = ((parent as IChild).parent as IUIComponent).systemManager;
        }
        return sm;
    }
    
    public function get nestLevel():int
    {
    	throw new Error("Method not implemented.");
    }

    public function set nestLevel(value:int):void
    {
    	throw new Error("Method not implemented.");
    }

    public function get processedDescriptors():Boolean
    {
    	throw new Error("Method not implemented.");
    }

    public function set processedDescriptors(value:Boolean):void
    {
    	throw new Error("Method not implemented.");
    }

    public function get updateCompletePendingFlag():Boolean
    {
    	throw new Error("Method not implemented.");
    }

    public function set updateCompletePendingFlag(value:Boolean):void
    {
    	throw new Error("Method not implemented.");
    }
} // end class

} // end package
