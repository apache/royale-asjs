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

import mx.core.UIComponent;
import org.apache.royale.display.Graphics;
import org.apache.royale.events.Event;
import mx.events.MouseEvent;
import org.apache.royale.geom.Matrix;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;

import mx.controls.DataGrid;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.EdgeMetrics;
import mx.core.IUIComponent;
import mx.core.LayoutDirection;
import mx.core.UIComponent;
import mx.core.UIComponentGlobals;
import mx.core.mx_internal;
import mx.events.DataGridEvent;
import mx.events.SandboxMouseEvent;
import mx.managers.CursorManager;
import mx.managers.CursorManagerPriority;
import mx.styles.ISimpleStyleClient;
import mx.styles.StyleManager;

use namespace mx_internal;

 
public class DataGridHeader extends DataGridHeaderBase
{


    public function DataGridHeader()
    {
        super();
        // addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
        // addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
        // addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
    }

     
    private var separatorAffordance:Number = 3;


     
    override mx_internal function clearSelectionLayer():void
    {
        while (selectionLayer.numChildren > 0)
        {
            selectionLayer.removeChildAt(0);
        }
    }

     
    protected var dataGrid:DataGrid;


     
    protected var headerItems:Array = [];


    protected var cachedHeaderHeight:Number = 0;


     
    protected var cachedPaddingBottom:Number = 0;

	 
	protected var cachedPaddingTop:Number = 0;

	public var needRightSeparator:Boolean = false;
	
	 
	public var needRightSeparatorEvents:Boolean = false;

     
    override protected function createChildren():void
    {
        dataGrid = parent as DataGrid;

        // this is the layer where we draw selection indicators
        selectionLayer = new UIComponent();
        addChild(selectionLayer);
    }

  /*  override protected function measure():void
    {
        super.measure();
        var calculatedHeight:Number = dataGrid.calculateHeaderHeight();
        cachedHeaderHeight = dataGrid._explicitHeaderHeight ? dataGrid.headerHeight : calculatedHeight;
        cachedPaddingBottom = getStyle("paddingBottom");
        cachedPaddingTop = getStyle("paddingTop");
        measuredHeight = cachedHeaderHeight;

        var ww:Number = 0;
        var n:int = visibleColumns ? visibleColumns.length : 0;
        for (var i:int = 0; i < n; i++)
            ww += visibleColumns[i].preferredWidth;
        measuredWidth = ww;
    }

    *
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    override protected function updateDisplayList(w:Number, h:Number):void
    {
        allowItemSizeChangeNotification = false;

        // make new ones
        var cols:Array = visibleColumns;

        if (headerItemsChanged && (cols && cols.length > 0 || dataGrid.headerVisible))
        {
            headerItemsChanged = false;

            var xx:Number = 0;
            var yy:Number = 0;
            var hh:Number = 0;
            var ww:Number = 0;
            var rh:Number;
            var colNum:int = 0; // visible columns compensate for firstCol offset

            var rowData:DataGridListData;
            var item:IListItemRenderer;
            var extraItem:IListItemRenderer;
            var data:Object;
            var uid:String;
            var c:DataGridColumn;

            var maxHeaderHeight:Number = 0;
            // copy current list of renderers
            var oldHeaderItems:Array = headerItems.slice();

            while (cols && colNum < cols.length)
            {
                c = cols[colNum];
                item = c.cachedHeaderRenderer;
                if (!item)
                {
                    item = dataGrid.createColumnItemRenderer(c, true, c);
                    item.styleName = c;
                    c.cachedHeaderRenderer = item;
                }
                rowData = new DataGridListData((c.headerText != null) ? c.headerText : c.dataField, 
                                                                c.dataField, colNum, uid, dataGrid, 0);
                if (item is IDropInListItemRenderer)
                    IDropInListItemRenderer(item).listData = rowData;
                item.data = c;
                item.visible = true;
                // if it isn't parented by us, add it (could be in lockedColumns header)
                if (item.parent != this)
                    addChild(UIComponent(item));
                headerItems[colNum] = item;
                // set prefW so we can compute prefH
                item.explicitWidth = ww = c.width;
                UIComponentGlobals.layoutManager.validateClient(item, true);
                // but size it regardless of what prefW is
                rh = item.getExplicitOrMeasuredHeight();
                item.setActualSize(ww, dataGrid._explicitHeaderHeight ?
                    cachedHeaderHeight - cachedPaddingTop - cachedPaddingBottom : rh);
                item.move(xx, yy + cachedPaddingTop);
                xx += ww;
                colNum++;
                hh = Math.ceil(Math.max(hh, dataGrid._explicitHeaderHeight ?
                    cachedHeaderHeight : rh + cachedPaddingBottom + cachedPaddingTop));
                maxHeaderHeight = Math.max(maxHeaderHeight, dataGrid._explicitHeaderHeight ?
                    cachedHeaderHeight - cachedPaddingTop - cachedPaddingBottom : rh);
            }

            // expand all headers to be of maximum height
            for (var i:int = 0; i < headerItems.length; i++)
                headerItems[i].setActualSize(headerItems[i].width, maxHeaderHeight);
            
            for (i = 0; i < oldHeaderItems.length; i++)
            {
                item = oldHeaderItems[i];
                if (item && headerItems.indexOf(item) == -1)
                {
                    // if it is parented by us, remove it (could be in lockedColumns header)
                    if (item.parent == this)
                        removeChild(UIComponent(item));
                }
            }
            while (headerItems.length > colNum)
            {
                // remove extra columns
                extraItem = headerItems.pop();
                // if it is parented by us, remove it (could be in lockedColumns header)
                if (extraItem.parent == this)
                {
                    // make sure it isn't already in there elsewhere
                    if (headerItems.indexOf(extraItem) == -1)
                        removeChild(UIComponent(extraItem));
                }
            }
        }
        var headerBG:UIComponent =
            UIComponent(getChildByName("headerBG"));
        
        if (headerBGSkinChanged)
        {
            headerBGSkinChanged = false;
            if (headerBG)
                removeChild(headerBG);
            headerBG = null;
        }

        if (!headerBG)
        {
            headerBG = new UIComponent();
            headerBG.name = "headerBG";
            addChildAt(UIComponent(headerBG), 0);
                        
            var headerBGSkinClass:Class = getStyle("headerBackgroundSkin");
            var headerBGSkin:IFlexUIComponent = new headerBGSkinClass();
       
            if (headerBGSkin is ISimpleStyleClient)
                ISimpleStyleClient(headerBGSkin).styleName = this;
            headerBG.addChild(UIComponent(headerBGSkin));
        }
        if (dataGrid.headerVisible)
        {
            headerBG.visible = true;
            drawHeaderBackgroundSkin(IFlexUIComponent(headerBG.getChildAt(0)));
            dataGrid._drawSeparators();
        }
        else
        {
            headerBG.visible = false;
            dataGrid._clearSeparators();
        }

        dataGrid._placeSortArrow();

        allowItemSizeChangeNotification = true;
    }

    mx_internal function _drawHeaderBackground(headerBG:UIComponent):void
    {
        drawHeaderBackground(headerBG);
    }

    *
     *  Draws the background of the headers into the given 
     *  UIComponent. The graphics drawn may be scaled horizontally
     *  if the component's width changes or this method will be
     *  called again to redraw at a different width and/or height
     *
     *  @param headerBG A UIComponent that will contain the header
     *  background graphics.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    protected function drawHeaderBackground(headerBG:UIComponent):void
    {       
        var tot:Number = width;

        var hh:Number = cachedHeaderHeight;

        var g:Graphics = headerBG.graphics;
        g.clear();
        var colors:Array = getStyle("headerColors");
        styleManager.getColorNames(colors);
        
        var matrix:Matrix = new Matrix();
        matrix.createGradientBox(tot, hh + 1, Math.PI/2, 0, 0);

        colors = [ colors[0], colors[0], colors[1] ];
        var ratios:Array = [ 0, 60, 255 ];
        var alphas:Array = [ 1.0, 1.0, 1.0 ];

        g.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
        g.lineStyle(0, 0x000000, 0);
        g.moveTo(0, 0);
        g.lineTo(tot, 0);
        g.lineTo(tot, hh - 0.5);
        g.lineStyle(0, getStyle("borderColor"), 100);
        g.lineTo(0, hh - 0.5);
        g.lineStyle(0, 0x000000, 0);
        g.endFill();
    }
    
    private function drawHeaderBackgroundSkin(headerBGSkin:IFlexUIComponent):void
    {
        headerBGSkin.setActualSize(unscaledWidth, Math.ceil(cachedHeaderHeight));  
    }

    mx_internal function _clearSeparators():void
    {
        clearSeparators();
    }

    *
     *  Removes column header separators that the user normally uses
     *  to resize columns.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    protected function clearSeparators():void
    {
        if (!separators)
            return;

        var lines:UIComponent = UIComponent(getChildByName("lines"));
        while (lines.numChildren)
        {
            lines.removeChildAt(lines.numChildren - 1);
            separators.pop();
        }
    }

    mx_internal function _drawSeparators():void
    {
        drawSeparators();
    }

    *
     *  Creates and displays the column header separators that the user 
     *  normally uses to resize columns.  This implementation uses
     *  the same UIComponent as the lines and column backgrounds and adds
     *  instances of the <code>headerSeparatorSkin</code> and attaches mouse
     *  listeners to them in order to know when the user wants
     *  to resize a column.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    protected function drawSeparators():void
    {
        if (!separators)
            separators = [];

        var lines:UIComponent = UIComponent(getChildByName("lines"));
        
        if (!lines)
        {
            lines = new UIComponent();
            lines.name = "lines";
            addChild(lines); 
        }
        else
            setChildIndex(lines, numChildren - 1);

        // required to deal with some 2.x clipping behavior
        lines.scrollRect = new Rectangle(0, 0, unscaledWidth, unscaledHeight + 1);

        if (headerSepSkinChanged)
        {
            headerSepSkinChanged = false;
            clearSeparators();
        }

        var n:int = visibleColumns ? visibleColumns.length : 0;
        
        if (!needRightSeparator && n > 0)
        	n--;
        
        for (var i:int = 0; i < n; i++)
        {
            var sep:UIComponent;
            var sepSkin:IFlexUIComponent;
            
            if (i < lines.numChildren)
            {
                sep = UIComponent(lines.getChildAt(i));
                sepSkin = IFlexUIComponent(sep.getChildAt(0));
            }
            else
            {
                var headerSeparatorClass:Class =
                    getStyle("headerSeparatorSkin");
                sepSkin = new headerSeparatorClass();
                if (sepSkin is ISimpleStyleClient)
                    ISimpleStyleClient(sepSkin).styleName = this;
                sep = new UIComponent();
                sep.addChild(UIComponent(sepSkin));
                lines.addChild(sep);
                UIComponentGlobals.layoutManager.validateClient(sep, true);
                
                separators.push(sep);
            }
            // if not separator
            if ( !(i == visibleColumns.length-1 && !needRightSeparatorEvents) )
            {
	            UIComponent(sep).addEventListener(
	                MouseEvent.MOUSE_OVER, columnResizeMouseOverHandler);
	            UIComponent(sep).addEventListener(
	                MouseEvent.MOUSE_OUT, columnResizeMouseOutHandler);
	            UIComponent(sep).addEventListener(
	                MouseEvent.MOUSE_DOWN, columnResizeMouseDownHandler);
	        }
			else
			{
                // if not separator
                if ( (i == visibleColumns.length-1 && !needRightSeparatorEvents) )
                {
	                UIComponent(sep).removeEventListener(
	                    MouseEvent.MOUSE_OVER, columnResizeMouseOverHandler);
	                UIComponent(sep).removeEventListener(
	                    MouseEvent.MOUSE_OUT, columnResizeMouseOutHandler);
	                UIComponent(sep).removeEventListener(
	                    MouseEvent.MOUSE_DOWN, columnResizeMouseDownHandler);
	            }
			}

            var cols:Array = visibleColumns;
            if (!(cols && cols.length > 0 || dataGrid.headerVisible))
            {
                sep.visible = false;
                continue;
            }

            // Spark skins don't measure if the width is specified.
            var skinWidth:Number;
            if (sepSkin is IUIComponent)
                skinWidth = IUIComponent(sepSkin).getExplicitOrMeasuredWidth();
            else
                skinWidth = sepSkin.measuredWidth;
            
            sep.visible = true;
            sep.x = headerItems[i].x +
                    visibleColumns[i].width - Math.round(skinWidth / 2);
            if (i > 0)
            {
                sep.x = Math.max(sep.x,
                                 separators[i - 1].x + Math.round(skinWidth / 2));
            }
            sep.y = 0;
            sepSkin.setActualSize(skinWidth, Math.ceil(cachedHeaderHeight));

                        // Draw invisible background for separator affordance
            sep.graphics.clear();
            sep.graphics.beginFill(0xFFFFFF, 0);
            sep.graphics.drawRect(-separatorAffordance, 0,
								  sepSkin.measuredWidth + separatorAffordance,
								  cachedHeaderHeight);
            sep.graphics.endFill();
			sep.mouseEnabled = true;
        }

        while (lines.numChildren > n)
        {
            lines.removeChildAt(lines.numChildren - 1);
            separators.pop();
        }
        UIComponentGlobals.layoutManager.validateClient(lines, true);
    }
    
     *
     *  Draws the highlight indicator into the given UIComponent
     *  at the position, width and height specified using the
     *  color specified.
     * 
     *  @param indicator A UIComponent that should contain the graphics
     *  that make a renderer look highlighted.
     *
     *  @param x The suggested x position for the indicator.
     *
     *  @param y The suggested y position for the indicator.
     *
     *  @param width The suggested width for the indicator.
     *
     *  @param height The suggested height for the indicator.
     *
     *  @param color The suggested color for the indicator.
     *
     *  @param itemRenderer The item renderer that is being highlighted.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    protected function drawHeaderIndicator(indicator:UIComponent, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
    {
        var g:Graphics = indicator.graphics;
        g.clear();
        g.beginFill(color);
        g.drawRect(0, 0, width, height);
        g.endFill(); 
        indicator.x = x;
        indicator.y = y;
    }
    
     *
     *  Draws the selection indicator into the given UIComponent
     *  at the position, width and height specified using the
     *  color specified.
     * 
     *  @param indicator A UIComponent that should contain the graphics
     *  that make a renderer look selected.
     *
     *  @param x The suggested x position for the indicator.
     *
     *  @param y The suggested y position for the indicator.
     *
     *  @param width The suggested width for the indicator.
     *
     *  @param height The suggested height for the indicator.
     *
     *  @param color The suggested color for the indicator.
     *
     *  @param itemRenderer The item renderer that is being selected.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    protected function drawSelectionIndicator(indicator:UIComponent, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
    {
        var g:Graphics = indicator.graphics;
        g.clear();
        g.beginFill(color);
        g.drawRect(0, 0, width, height);
        g.endFill(); 
        indicator.x = x;
        indicator.y = y;
    }
    
     *
     *  Draws the overlay on the dragged column into the given UIComponent
     *  at the position, width and height specified using the
     *  color specified.
     * 
     *  @param indicator A UIComponent that should contain the graphics
     *  that indicate that a column is being dragged.
     *
     *  @param x The suggested x position for the indicator.
     *
     *  @param y The suggested y position for the indicator.
     *
     *  @param width The suggested width for the indicator.
     *
     *  @param height The suggested height for the indicator.
     *
     *  @param color The suggested color for the indicator.
     *
     *  @param itemRenderer The item renderer that is being dragged.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    protected function drawColumnDragOverlay(indicator:UIComponent, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
    {
        var g:Graphics = indicator.graphics;
        g.clear();
        g.beginFill(color);
        g.drawRect(0, 0, width, height);
        g.endFill(); 
        indicator.x = x;
        indicator.y = y;
    }   

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    *
     *  @private
     
    private function columnResizeMouseOverHandler(event:MouseEvent):void
    {
        if (!enabled || !dataGrid.resizableColumns)
            return;

        var target:UIComponent = UIComponent(event.target);
        var index:int = target.parent.getChildIndex(target);
        if (!visibleColumns[index].resizable)
            return;

        // hide the mouse, attach and show the cursor
        var stretchCursorClass:Class = getStyle("stretchCursor");
        resizeCursorID = cursorManager.setCursor(stretchCursorClass,
                                                 CursorManagerPriority.HIGH, 0, 0);
    }

    *
     *  @private
     
    private function columnResizeMouseOutHandler(event:MouseEvent):void
    {
        if (!enabled || !dataGrid.resizableColumns)
            return;

        var target:UIComponent = UIComponent(event.target);
        var index:int = target.parent.getChildIndex(target);
        if (!visibleColumns[index].resizable)
            return;

        cursorManager.removeCursor(resizeCursorID);
    }

    *
     *  @private
     *  Indicates where the right side of a resized column appears.
     
    private function columnResizeMouseDownHandler(event:MouseEvent):void
    {
        if (!enabled || !dataGrid.resizableColumns)
            return;

        var target:UIComponent = UIComponent(event.target);
        var index:int = target.parent.getChildIndex(target);
        if (!visibleColumns[index].resizable)
            return;

        startX = UIComponent(event.target).x + x;
        lastPt = new Point(event.stageX, event.stageY);
        lastPt = dataGrid.globalToLocal(lastPt);
        var n:int = separators.length;
		var colIndex:int = 0;
        for (var i:int = 0; i < n; i++)
        {
            if (separators[i] == event.target)
            {
                resizingColumn = visibleColumns[i];
				colIndex = i;
            }
			else
				separators[i].mouseEnabled = false;
        }
        if (!resizingColumn)
            return;

        minX = headerItems[colIndex].x + x + resizingColumn.minWidth;

        var sbRoot:UIComponent = systemManager.getSandboxRoot();
        sbRoot.addEventListener(MouseEvent.MOUSE_MOVE, columnResizingHandler, true);
        sbRoot.addEventListener(MouseEvent.MOUSE_UP, columnResizeMouseUpHandler, true);
        sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, columnResizeMouseUpHandler);
        systemManager.deployMouseShields(true);

        var resizeSkinClass:Class = getStyle("columnResizeSkin");
        resizeGraphic = new resizeSkinClass();
		if (resizeGraphic is UIComponent)
			UIComponent(resizeGraphic).mouseEnabled = false;

        dataGrid.addChild(UIComponent(resizeGraphic));
        resizeGraphic.move(UIComponent(event.target).x + x, 0);
        resizeGraphic.setActualSize(resizeGraphic.measuredWidth,
                                    dataGrid.height / dataGrid.scaleY);
    }

    *
     *  @private
     
    private function columnResizingHandler(event:MouseEvent):void
    {
        if (!MouseEvent(event).buttonDown)
        {
            columnResizeMouseUpHandler(event);
            return;
        }
        
        var vsw:int = dataGrid.vScrollBar ? dataGrid.vScrollBar.width : 0;

        var pt:Point = new Point(event.stageX, event.stageY);
        pt = dataGrid.globalToLocal(pt);
        lastPt = pt;
        resizeGraphic.move(Math.min(Math.max(minX, pt.x),
                           (dataGrid.width / dataGrid.scaleX) - separators[0].width - vsw), 0);
    }

    *
     *  @private
     *  Determines how much to resize the column.
     
    private function columnResizeMouseUpHandler(event:Event):void
    {
        if (!enabled || !dataGrid.resizableColumns)
            return;

        // Set this to null so sort doesn't happen.
        lastItemDown = null;

        var sbRoot:UIComponent = systemManager.getSandboxRoot();
        sbRoot.removeEventListener(MouseEvent.MOUSE_MOVE, columnResizingHandler, true);
        sbRoot.removeEventListener(MouseEvent.MOUSE_UP, columnResizeMouseUpHandler, true);
        sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, columnResizeMouseUpHandler);
        systemManager.deployMouseShields(false);

        dataGrid.removeChild(UIComponent(resizeGraphic));
        resizeGraphic = null;

        cursorManager.removeCursor(resizeCursorID);

        var c:DataGridColumn = resizingColumn;
        resizingColumn = null;

        var vsw:int = dataGrid.vScrollBar ? dataGrid.vScrollBar.width : 0;

        var mouseEvent:MouseEvent = event as MouseEvent;
        var pt:Point;
        
        if (mouseEvent)
        {
            pt = new Point(mouseEvent.stageX, mouseEvent.stageY);
            pt = dataGrid.globalToLocal(pt);
        }
        else
            pt = lastPt;
            
        // resize the column
        var widthChange:Number = Math.min(Math.max(minX, pt.x),
            (dataGrid.width / dataGrid.scaleX) - separators[0].width - vsw) - startX;
        dataGrid.resizeColumn(c.colNum, Math.floor(c.width + widthChange));

        invalidateDisplayList();    // force redraw of columns

        // event
        var dataGridEvent:DataGridEvent =
            new DataGridEvent(DataGridEvent.COLUMN_STRETCH);
        dataGridEvent.columnIndex = c.colNum;
        dataGridEvent.dataField = c.dataField;
        dataGridEvent.localX = pt.x;
        dataGrid.dispatchEvent(dataGridEvent);
    }

    *
     *  @private
     
    private function columnDraggingMouseMoveHandler(event:MouseEvent):void
    {
        if (!event.buttonDown)
        {
            columnDraggingMouseUpHandler(event);
            return;
        }

        var item:IListItemRenderer;
        var c:DataGridColumn = dataGrid.movingColumn;
        var s:UIComponent;
        var i:int = 0;
        var n:int = headerItems.length;
        var dgSelectionLayer:UIComponent;

        if (isNaN(startX))
        {
            // If startX is not a number, dragging has just started.
            // Initialise and return without actually moving anything.

            startX = event.stageX;
            
            // Set this to null so sort doesn't happen.
            lastItemDown = null;

            var vm:EdgeMetrics = dataGrid.viewMetrics;

            // Create, position and draw selection layer over both headers.
            dgSelectionLayer = new UIComponent();
            dgSelectionLayer.name = "columnDragSelectionLayer";
            dgSelectionLayer.alpha = 0.6;
            dataGrid.addChild(dgSelectionLayer);
            dgSelectionLayer.x = vm.left;
            dgSelectionLayer.y = vm.top;

            // Create and position proxy.
            var proxy:IListItemRenderer = dataGrid.createColumnItemRenderer(c, true, c);
            proxy.name = "headerDragProxy";

            var rowData:DataGridListData = new DataGridListData((c.headerText != null) ? c.headerText : c.dataField, 
                                                                c.dataField, c.colNum, uid, dataGrid, 0);
            if (proxy is IDropInListItemRenderer)
                IDropInListItemRenderer(proxy).listData = rowData;

            dgSelectionLayer.addChild(UIComponent(proxy));

            proxy.data = c;
            proxy.styleName = getStyle("headerDragProxyStyleName"); 
            UIComponentGlobals.layoutManager.validateClient(proxy, true);
            proxy.setActualSize(c.width, dataGrid._explicitHeaderHeight ?
                dataGrid.headerHeight : proxy.getExplicitOrMeasuredHeight());

            for (i = 0; i < n; i++)
            {
                item = headerItems[i];
                if (item.data == dataGrid.movingColumn)
                    break;
            }
            proxy.move(item.x + x, item.y);

            // Create, position and draw column overlay.
            s = new FlexUIComponent();
            s.name = "columnDragOverlay";
            s.alpha = 0.6;
            dataGrid.addChild(s);

            if (c.width > 0)
            {
                drawColumnDragOverlay(s, item.x + x, 0, c.width, 
                                        dataGrid.height / dataGrid.scaleY - vm.bottom - s.y, 
                                        getStyle("disabledColor"), item);
            }

            s = UIComponent(selectionLayer.getChildByName("headerSelection"));
            if (s)
            {
                s.width = dataGrid.movingColumn.width;
                dgSelectionLayer.addChild(s);
                s.x += x;
            }


            // Clip the contents so the header drag proxy doesn't show
            // outside the list.
            dgSelectionLayer.scrollRect = new Rectangle(0, 0,
                    dataGrid.width / dataGrid.scaleX,
                    unscaledHeight);

            return;
        }

        // Global coordinates.
        var deltaX:Number = event.stageX - startX;
        dgSelectionLayer = UIComponent(dataGrid.getChildByName("columnDragSelectionLayer"));

        // If the mouse pointer over the right (layoutDirection=”ltr”) or 
        // left (layoutDirection=”rtl”) half of the column, the drop indicator 
        // should be shown before the next column.
        var deltaXInLocalCoordinates:Number = 
            (layoutDirection == LayoutDirection.LTR ? +deltaX : -deltaX);
        
        // Move header selection.
        s = UIComponent(dgSelectionLayer.getChildByName("headerSelection"));
        if (s)
            s.x += deltaXInLocalCoordinates;
        
         // Move header proxy.
        item = IListItemRenderer(dgSelectionLayer.getChildByName("headerDragProxy"));
        if (item)
            item.move(item.x + deltaXInLocalCoordinates, item.y);
        
        // Global coordinates.
        startX += deltaX;
        
        var allVisibleColumns:Array = dataGrid.getAllVisibleColumns();
        var pt:Point = new Point(event.stageX, event.stageY);
        pt = dataGrid.globalToLocal(pt);
        lastPt = pt;
        n = allVisibleColumns.length;
        var xx:Number = dataGrid.viewMetrics.left;
        var ww:Number;
        for (i = 0; i < n; i++)
        {
            ww = allVisibleColumns[i].width;

            if (pt.x < xx + ww)
            {
                // If the mouse pointer over the right (ltr) or left (rtl) half 
                // of the column, the drop indicator should be shown before 
                // the next column.
                if (pt.x > xx + ww / 2)
                {
                    i++;
                    xx += ww;
                }

                if (dropColumnIndex != i)
                {
                    dropColumnIndex = i;

                    if (!columnDropIndicator)
                    {
                        var dropIndicatorClass:Class
                            = getStyle("columnDropIndicatorSkin");
                        if (!dropIndicatorClass)
                            dropIndicatorClass = DataGridColumnDropIndicator;
                        columnDropIndicator = IFlexUIComponent(
                            new dropIndicatorClass());

                        if (columnDropIndicator is ISimpleStyleClient)
                            ISimpleStyleClient(columnDropIndicator).styleName = this;

                        dataGrid.addChild(
                            UIComponent(columnDropIndicator));
                        var m:Shape = new Shape();
                        m.graphics.beginFill(0xffffff);
                        m.graphics.drawRect(0, 0, 10, 10);
                        m.graphics.endFill();
                        dataGrid.addChild(m);
                        columnDropIndicator.mask = m;
                    }

                    dataGrid.setChildIndex(
                        UIComponent(columnDropIndicator),
                        dataGrid.numChildren - 1);
                    columnDropIndicator.visible = true;
                    m = columnDropIndicator.mask as Shape;
                    m.x = dataGrid.viewMetrics.left;
                    m.y = dataGrid.viewMetrics.top;
                    m.width = dataGrid.width / dataGrid.scaleX - m.x - dataGrid.viewMetrics.right;
                    m.height = dataGrid.height / dataGrid.scaleY - m.x - dataGrid.viewMetrics.bottom;

                    columnDropIndicator.setActualSize(3, dataGrid.height / dataGrid.scaleY);
                    columnDropIndicator.x = xx - columnDropIndicator.width + (layoutDirection == LayoutDirection.LTR ? 0 : 1);
                    columnDropIndicator.y = 0;  
                }
                break;
            }
            xx += ww;
        }
    }

    *
     *  @private
     * 
     *  @param event MouseEvent or SandboxMouseEvent.
     
    private function columnDraggingMouseUpHandler(event:Event):void
    {
        if (!dataGrid.movingColumn)
            return;

        var origIndex:int = dataGrid.movingColumn.colNum;
        var allVisibleColumns:Array = dataGrid.getAllVisibleColumns();

        if (dropColumnIndex >= 0)
        {
            if (dropColumnIndex >= allVisibleColumns.length)
            {
                dropColumnIndex = allVisibleColumns.length - 1;
            }
            else
            {
                if (origIndex < allVisibleColumns[dropColumnIndex].colNum)
                    dropColumnIndex--;
            }
     
            // dropColumnIndex is actually the index into the headerItems
            // array.  Get the corresponding index into the _columns array.
            dropColumnIndex = allVisibleColumns[dropColumnIndex].colNum;
        }

        // Shift columns.
        dataGrid.shiftColumns(origIndex, dropColumnIndex, event as MouseEvent);

        var sbRoot:UIComponent = systemManager.getSandboxRoot();
        sbRoot.removeEventListener(MouseEvent.MOUSE_MOVE, columnDraggingMouseMoveHandler, true);
        sbRoot.removeEventListener(MouseEvent.MOUSE_UP, columnDraggingMouseUpHandler, true);
        sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, columnDraggingMouseUpHandler);
        systemManager.deployMouseShields(false);

        var dgSelectionLayer:UIComponent = UIComponent(dataGrid.getChildByName("columnDragSelectionLayer"));
        if (!dgSelectionLayer)
        {
            startX = NaN;
            dataGrid.movingColumn = null;
            dropColumnIndex = -1;
            return;
        }

        var proxy:IListItemRenderer =
            IListItemRenderer(getChildByName("headerDragProxy"));
        if (proxy)
            dgSelectionLayer.removeChild(UIComponent(proxy));

        var s:UIComponent = UIComponent(dgSelectionLayer.getChildByName("headerSelection"));
        if (s)
            dgSelectionLayer.removeChild(s);

        if (columnDropIndicator)
            columnDropIndicator.visible = false;

        s = UIComponent(dataGrid.getChildByName("columnDragOverlay"));
        if (s)
            dataGrid.removeChild(s);

        dataGrid.removeChild(dgSelectionLayer);

        startX = NaN;
        dataGrid.movingColumn = null;
        dropColumnIndex = -1;

        invalidateDisplayList(); // force redraw
    }

    *
     *  @private
     
    protected function mouseOverHandler(event:MouseEvent):void
    {
        var r:IListItemRenderer;
        var i:int;

        if (resizingColumn || dataGrid.movingColumn)
            return;

        if (dataGrid.enabled && dataGrid.sortableColumns && dataGrid.headerVisible)
        {
            // find out if we hit the sort arrow
            s = UIComponent(getChildByName("sortArrowHitArea"));

            if (event.target == s)
            {
                var n:int = visibleColumns.length;
                for (i = 0; i < n; i++)
                {
                    if (visibleColumns[i].colNum == dataGrid.sortIndex)
                    {
                        r = headerItems[i];
                        break;
                    }
                }
            }
            else
            {
                for (i = 0; i < separators.length; i++)
                {
                    if (event.target == separators[i] && visibleColumns[i].resizable)
                        return;
                }
                var pt:Point = new Point(event.stageX, event.stageY);
                pt = globalToLocal(pt);
                for (i = 0; i < headerItems.length; i++)
                {
                    if (headerItems[i].x + headerItems[i].width >= pt.x)
                    {
                        r = headerItems[i];
                        break;
                    }
                }
                if (i >= headerItems.length)
                    return;
            }

            s = UIComponent(getChildByName("sortArrowHitArea"));
            if (visibleColumns[i].sortable)
            {
                var s:UIComponent = UIComponent(
                    selectionLayer.getChildByName("headerSelection"));
                if (!s)
                {
                    s = new FlexUIComponent();
                    s.name = "headerSelection";
                    s.mouseEnabled = false;
                    selectionLayer.addChild(s);
                }      

                drawHeaderIndicator(s, r.x, 0, visibleColumns[i].width, cachedHeaderHeight - 0.5, getStyle("rollOverColor"), r);
                
            }
        }

        if (event.buttonDown)
            lastItemDown = r;
        else
            lastItemDown = null;
    }
    
    *
     *  @private
     
    protected function mouseOutHandler(event:MouseEvent):void
    {
        var r:IListItemRenderer;
        var i:int;

        if (resizeGraphic || dataGrid.movingColumn)
            return;

        if (dataGrid.enabled && dataGrid.sortableColumns && dataGrid.headerVisible)
        {
            // find out if we hit the sort arrow
            s = UIComponent(getChildByName("sortArrowHitArea"));

            if (event.target == s)
            {
                var n:int = visibleColumns.length;
                for (i = 0; i < n; i++)
                {
                    if (visibleColumns[i].colNum == dataGrid.sortIndex)
                    {
                        r = headerItems[i];
                        break;
                    }
                }
                if (i >= visibleColumns.length)
                    return;
            }
            else
            {
                for (i = 0; i < separators.length; i++)
                {
                    if (event.target == separators[i] && visibleColumns[i].resizable)
                        return;
                }
                var pt:Point = new Point(event.stageX, event.stageY);
                pt = globalToLocal(pt);
                for (i = 0; i < headerItems.length; i++)
                {
                    if (headerItems[i].x + headerItems[i].width >= pt.x)
                    {
                        r = headerItems[i];
                        break;
                    }
                }
                if (i >= headerItems.length)
                    i = headerItems.length - 1;
            }

            if (visibleColumns.length > 0 && visibleColumns[i].sortable)
            {
                var s:UIComponent = UIComponent(
                    selectionLayer.getChildByName("headerSelection"));
                if (s)
                    selectionLayer.removeChild(s);
            }
        }

        if (event.buttonDown)
            lastItemDown = r;
        else
            lastItemDown = null;

    }

    *
     *  @private
     
    protected function mouseDownHandler(event:MouseEvent):void
    {
        // trace(">>mouseDownHandler");
        var r:IListItemRenderer;
        var s:UIComponent;
        var i:int;

        systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true, 0, true);
        systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseLeaveHandler, false, 0, true);

        // find out if we hit the sort arrow
        s = UIComponent(getChildByName("sortArrowHitArea"));

        if (event.target == s)
        {
            var n:int = visibleColumns.length;
            for (i = 0; i < n; i++)
            {
                if (visibleColumns[i].colNum == dataGrid.sortIndex)
                {
                    r = headerItems[i];
                    break;
                }
            }
        }
        else
        {
            for (i = 0; i < separators.length; i++)
            {
                if (event.target == separators[i] && visibleColumns[i].resizable)
                    return;
            }
            var pt:Point = new Point(event.stageX, event.stageY);
            pt = globalToLocal(pt);
            for (i = 0; i < headerItems.length; i++)
            {
                if (headerItems[i].x + headerItems[i].width >= pt.x)
                {
                    r = headerItems[i];
                    break;
                }
            }
            if (i >= headerItems.length)
                return;
        }

        // if headers are visible and clickable for sorting
        if (dataGrid.enabled && (dataGrid.sortableColumns || dataGrid.draggableColumns)
                && dataGrid.headerVisible)
        {

            if (dataGrid.sortableColumns && visibleColumns[i].sortable)
            {
                lastItemDown = r;
                s = UIComponent(selectionLayer.getChildByName("headerSelection"));
                if (!s)
                {
                    s = new FlexUIComponent();
                    s.name = "headerSelection";
                    selectionLayer.addChild(s);
                }

                drawSelectionIndicator(s, r.x, 0, visibleColumns[i].width, cachedHeaderHeight - 0.5, getStyle("selectionColor"), r);
            }

            // begin column dragging
            if (dataGrid.draggableColumns && visibleColumns[i].draggable)
            {
                startX = NaN;
                
                var sbRoot:UIComponent = systemManager.getSandboxRoot();
                sbRoot.addEventListener(MouseEvent.MOUSE_MOVE, columnDraggingMouseMoveHandler, true);
                sbRoot.addEventListener(MouseEvent.MOUSE_UP, columnDraggingMouseUpHandler, true);
                sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, columnDraggingMouseUpHandler);
                systemManager.deployMouseShields(true);
                dataGrid.movingColumn = visibleColumns[i];
            }
        }
    }

     *
     *  @private
     
    protected function mouseUpHandler(event:MouseEvent):void
    {
        var dataGridEvent:DataGridEvent;
        var r:IListItemRenderer;
        var s:UIComponent;
        var n:int;
        var i:int;

        systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
        systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseLeaveHandler);

        // find out if we hit the sort arrow
        s = UIComponent(getChildByName("sortArrowHitArea"));

        if (event.target == s)
        {
            n = visibleColumns.length;
            for (i = 0; i < n; i++)
            {
                if (visibleColumns[i].colNum == dataGrid.sortIndex)
                {
                    r = headerItems[i];
                    break;
                }
            }
        }
        else
        {
            for (i = 0; i < separators.length; i++)
            {
                if (event.target == separators[i] && visibleColumns[i].resizable)
                    return;
            }
            var pt:Point = new Point(event.stageX, event.stageY);
            pt = globalToLocal(pt);
            for (i = 0; i < headerItems.length; i++)
            {
                if (headerItems[i].x + headerItems[i].width >= pt.x)
                {
                    r = headerItems[i];
                    break;
                }
            }
            if (i >= headerItems.length)
                return;
        }

        if (dataGrid.enabled && (dataGrid.sortableColumns || dataGrid.draggableColumns)
                && dataGrid.dataProvider && dataGrid.headerVisible)
        {
            if (r == lastItemDown)
            {
                if (dataGrid.sortableColumns && visibleColumns[i].sortable)
                {
                    lastItemDown = null;
                    dataGridEvent = new DataGridEvent(DataGridEvent.HEADER_RELEASE, false, true);
                    // HEADER_RELEASE event is cancelable
                    dataGridEvent.columnIndex = visibleColumns[i].colNum;
                    dataGridEvent.dataField = visibleColumns[i].dataField;
                    dataGridEvent.itemRenderer = r;
                    dataGrid.dispatchEvent(dataGridEvent);
                }
            }
        }
    }

    private function mouseLeaveHandler(event:Event):void
    {
        systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
        systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseLeaveHandler);
    }

    mx_internal function _placeSortArrow():void
    {
        placeSortArrow();
    }

    *
     *  Draws the sort arrow graphic on the column that is the current sort key.
     *  This implementation creates or reuses an instance of the skin specified
     *  by <code>sortArrowSkin</code> style property and places 
     *  it in the appropriate column header.  It
     *  also shrinks the size of the column header if the text in the header
     *  would be obscured by the sort arrow.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    protected function placeSortArrow():void
    {

        var sortArrowHitArea:UIComponent =
            UIComponent(getChildByName("sortArrowHitArea"));

        if (dataGrid.sortIndex == -1 && dataGrid.lastSortIndex == -1)
        {
            if (sortArrow)
                sortArrow.visible = false;
            if (sortArrowHitArea)
                sortArrowHitArea.visible = false;
            return;
        }

        if (!dataGrid.headerVisible)
        {
            if (sortArrow)
                sortArrow.visible = false;
            if (sortArrowHitArea)
                sortArrowHitArea.visible = false;
            return;
        }

        if (!sortArrow)
        {
            var sortArrowClass:Class = getStyle("sortArrowSkin");
            sortArrow = new sortArrowClass();
            UIComponent(sortArrow).name = enabled ? "sortArrow" : "sortArrowDisabled";
            if (sortArrow is ISimpleStyleClient)
                ISimpleStyleClient(sortArrow).styleName = this;
            
            addChild(UIComponent(sortArrow));
        }
        var xx:Number;
        var n:int;
        var i:int;
        var found:Boolean = false;
        if (headerItems && headerItems.length)
        {
            n = headerItems.length;
            for (i = 0; i < n; i++)
            {
                if (visibleColumns[i].colNum == dataGrid.sortIndex)
                {
                    xx = headerItems[i].x + visibleColumns[i].width;
                    headerItems[i].setActualSize(visibleColumns[i].width - sortArrow.measuredWidth - 8, headerItems[i].height);

                    if (!isNaN(headerItems[i].explicitWidth))
                        headerItems[i].explicitWidth = headerItems[i].width;

                    UIComponentGlobals.layoutManager.validateClient(headerItems[i], true);

                    // Create hit area to capture mouse clicks behind arrow.
                    if (!sortArrowHitArea)
                    {
                        sortArrowHitArea = new FlexUIComponent();
                        sortArrowHitArea.name = "sortArrowHitArea";
                        addChild(sortArrowHitArea);
                    }
                    else
                        sortArrowHitArea.visible = true;

                    sortArrowHitArea.x = headerItems[i].x + headerItems[i].width;
                    sortArrowHitArea.y = headerItems[i].y;

                    var g:Graphics = sortArrowHitArea.graphics;
                    g.clear();
                    g.beginFill(0, 0);
                    g.drawRect(0, 0, sortArrow.measuredWidth + 8,
                            headerItems[i].height);
                    g.endFill();
                    found = true;
                    break;
                }
            }
        }
        if (isNaN(xx))
            sortArrow.visible = false;
        else
            sortArrow.visible = true;

        if (visibleColumns.length && dataGrid.lastSortIndex >= 0 && dataGrid.lastSortIndex != dataGrid.sortIndex)
            if (visibleColumns[0].colNum <= dataGrid.lastSortIndex && 
                dataGrid.lastSortIndex <= visibleColumns[visibleColumns.length - 1].colNum)
            {
                n = headerItems.length;
                for (var j:int = 0; j < n; j++)
                {
                    if (visibleColumns[j].colNum == dataGrid.lastSortIndex)
                    {
                        headerItems[j].setActualSize(visibleColumns[j].width, headerItems[j].height);
                        UIComponentGlobals.layoutManager.validateClient(headerItems[j], true);
                        break;
                    }
                }
            }

        var d:Boolean = (dataGrid.sortDirection == "ASC");
        sortArrow.width = sortArrow.measuredWidth;
        sortArrow.height = sortArrow.measuredHeight;
        UIComponent(sortArrow).scaleY = (d) ? -1.0 : 1.0;
        sortArrow.x = xx - sortArrow.measuredWidth - 8;
        var hh:Number = cachedHeaderHeight;
        sortArrow.y = (hh - sortArrow.measuredHeight) / 2 + ((d) ? sortArrow.measuredHeight: 0);

        if (found && sortArrow.x < headerItems[i].x)
            sortArrow.visible = false;

        if (!sortArrow.visible && sortArrowHitArea)
            sortArrowHitArea.visible = false;

    }


    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

   *
     *  @private
     
    override public function invalidateSize():void
    {
        if (allowItemSizeChangeNotification)
            super.invalidateSize();
    }


    *
     *  @copy mx.core.IUIComponent#enabled
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    override public function set enabled(value:Boolean):void
    {
        super.enabled = value;
        if (sortArrow)
        {
			removeChild(UIComponent(sortArrow));
            sortArrow = null;
            placeSortArrow();
        }
            
    }
    
    
    *
     *  @private
     
    override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);
        if (styleProp == "headerBackgroundSkin")
        {
            headerBGSkinChanged = true;
        }
        else if (styleProp == "headerSeparatorSkin")
        {
            headerSepSkinChanged = true;
        }
    }

    *
     *  @private
     
    private var resizeCursorID:int = CursorManager.NO_CURSOR;

    *
     *  @private
     *  A tmp var to store the stretching col's X coord.
     
    private var startX:Number;

    *
     *  @private
     *  A tmp var to store the stretching col's min X coord for column's minWidth.
     
    private var minX:Number;

    *
     *  @private
     *  A tmp var to store the last point (in dataGrid coords) received while dragging.
     
    private var lastPt:Point;


    *
     *  @private
     *  List of header separators for column resizing.
     
    private var separators:Array;

    *
     *  @private
     
    mx_internal function getSeparators():Array
    {
        return separators;
    }

    *
     *  @private
     *  The column that is being resized.
     
    private function get resizingColumn():DataGridColumn
	{
		return dataGrid.resizingColumn;
	}
    *
     *  @private
     *  The column that is being resized.
     
    private function set resizingColumn(value:DataGridColumn):void
	{
		dataGrid.resizingColumn = value;
	}

    *
     *  Specifies a graphic that shows the proposed column width as the user stretches it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    private var resizeGraphic:IFlexUIComponent;

    *
     *  @private
     
    private var lastItemDown:IListItemRenderer;

    *
     *  @private
     *  Index of column before which to drop
     
    private var dropColumnIndex:int = -1;

    *
     *  @private
     
    mx_internal var columnDropIndicator:IFlexUIComponent;

    *
     *  The small arrow graphic used to show sortable columns and direction.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    mx_internal var sortArrow:IFlexUIComponent;

    * 
     *  diagnostics
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    mx_internal function get rendererArray():Array 
    {
        return headerItems;
    }

    *
     *  The offset, in pixels, from the left side of the content of the renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    public var leftOffset:Number = 0;

    *
     *  The offset, in pixels, from the top of the content of the renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    public var topOffset:Number = 0;

    *
     *  The offset, in pixels, from the right side of the content of the renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    public var rightOffset:Number = 0;

    *
     *  The offset, in pixels, from the bottom of the content of the renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     
    public var bottomOffset:Number = 0;

    *
     *  @private
     
    private var allowItemSizeChangeNotification:Boolean = true;

    private var headerBGSkinChanged:Boolean = false;

    private var headerSepSkinChanged:Boolean = false;  */
}

}
