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

package mx.charts.chartClasses
{
    
//import flash.display.BitmapData;
import mx.charts.CategoryAxis;
import mx.charts.PieChart;
import mx.core.IFlexDisplayObject;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.display.Graphics;

import org.apache.royale.events.Event;
import org.apache.royale.geom.Matrix;
import org.apache.royale.geom.Point;

use namespace mx_internal;

[DefaultProperty("dataChildren")]

/**
 * PolarDataCanvas class enables user to use graphics API
 * with respect to data coordinates instead of screen coordinates.
 * 
 * <p>The drawing region for canvas is determined by <code>radialAxis</code>
 * and <code>angularAxis</code> if they are specified. Otherwise,
 * default axes of chart will be considered to compute canvas drawing region.</p>
 * 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class PolarDataCanvas extends ChartElement implements IDataCanvas
{
//    include "../../core/Version.as";

    //----------------------------------------------
    //
    // Constructor
    //
    //----------------------------------------------
    
    /**
     * Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function PolarDataCanvas()
    {
        super();
        
        dataTransform = new PolarTransform();
    }
    
    //----------------------------------------------
    //
    // Variables
    //
    //----------------------------------------------
    private var _xMap:Object;
    private var _yMap:Object;
    private var _hDataDesc:DataDescription = new DataDescription();
    private var _vDataDesc:DataDescription = new DataDescription();
    
    private var _dataCache:PolarDataCache;
    private var _dataCacheDirty:Boolean = true;
    private var _filterDirty:Boolean = true;
    private var _mappingDirty:Boolean = true;
    private var _transformDirty:Boolean = true;
    private var _oldUW:Number;
    private var _oldUH:Number;
    private var borderWidth:Number = 0;
    private var _bAxesDirty:Boolean = false;
    private var _childMap:Object = {}; //new Dictionary(true);


    //----------------------------------------------
    //
    // Properties
    //
    //----------------------------------------------
    
    //----------------------------------
    //  angularAxis
    //----------------------------------

    /**
     *  @private
     *  Storage for the angularAxis property.
     */
    private var _angularAxis:IAxis;
    
    [Inspectable(category="Data")]

    /**
     *  Defines the labels, tick marks, and data position
     *  for items on the x-axis.
     *  Use either the LinearAxis class or the CategoryAxis class
     *  to set the properties of the angularAxis as a child tag in MXML
     *  or create a LinearAxis or CategoryAxis object in ActionScript.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get angularAxis():IAxis
    {
        return _angularAxis;
    }
    
    /**
     * @private
     */
    public function set angularAxis(value:IAxis):void
    {
        _angularAxis = value;
        _bAxesDirty = true;
        
        invalidateData();
        invalidateProperties();
    }
    
    //-----------------------------------------
    //  dataChildren
    //-----------------------------------------
    
    /**
     * @private
     * Storage for dataChildren property
     */
    private var _dataChildren:Array /* of DisplayObject */  = [];
    [Inspectable(category="General")]
    
    /**
     * @private
     * Array of child objects
     */
    public function get dataChildren():Array /* of DisplayObject */
    {
        return _dataChildren;
    }
    
    /**
     * @private
     */     
    public function set dataChildren(value:Array /* of DisplayObject */):void
    {
        for (var p:* in _childMap)
        {
            removeChild(_childMap[p].child);
        }
        _childMap = {};// new Dictionary(true);
        _dataChildren = value;
        var n:int  = value.length;
        for (var i:int =0; i < n; i++)
        {
            var dc:PolarDataChild;
            if (value[i] is PolarDataChild)              
                dc = value[i];
            else
                dc = new PolarDataChild(value[i]);
                
            _childMap[dc.child] = dc;
            dc.left = 0;
            dc.top = 0;
            dc.addEventListener("change",dataChildChangeHandler/*,false,0,true*/);
            super.addChild(dc.child);           
        }
        invalidateOpCodes();
    }
        
    //-----------------------------------------
    // includeInRanges
    //-----------------------------------------
    
    /**
     * @private
     * Storage for includeInRanges property
     */
    private var _includeInRanges:Boolean = false;
    [Inspectable(category="General")]
    
    /**
     * If <code>true</code>, the computed range of the chart is affected by this
     * canvas.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    
    public function get includeInRanges():Boolean
    {
        return _includeInRanges;
    }

    /**
     * @private
     */
    public function set includeInRanges(value:Boolean):void
    {
        if (_includeInRanges == value)
            return;
        _includeInRanges = value;
        dataChanged();
    }
    
    //----------------------------------
    //  radialAxis
    //----------------------------------

    /**
     *  @private
     *  Storage for the radialAxis property.
     */
    private var _radialAxis:IAxis;

    [Inspectable(category="Data")]

    /**
     *  Defines the labels, tick marks, and data position
     *  for items on the y-axis.
     *  Use either the LinearAxis class or the CategoryAxis class
     *  to set the properties of the angular axis as a child tag in MXML
     *  or to create a LinearAxis or CategoryAxis object in ActionScript.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get radialAxis():IAxis
    {
        return _radialAxis;
    }
    
    /**
     *  @private
     */
    public function set radialAxis(value:IAxis):void
    {
        _radialAxis = value;
        _bAxesDirty = true;
        invalidateData();
        invalidateProperties();
    }
    
    //--------------------------------------------
    // opCodes
    //--------------------------------------------
    /**
     * @private
     * Storage for opCodes property
     */
    private var _opCodes:Array /* of PolarOpCode */ = [];
        
    [ArrayElementType("PolarOpCode")]
    
    /**
     * @private
     */
     
    private function get opCodes():Array /* of PolarOpCode */ 
    {
        return _opCodes;
    }
    
    /**
     * @private
     */
    private function set opCodes(value:Array /* of PolarOpCode */):void
    {       
        _opCodes = value;
        invalidateOpCodes();
    }
    
    //----------------------------------------
    // totalValue
    //----------------------------------------
    
    /**
     * @private
     * Storage for totalValue porperty
     */
    private var _totalValue:Number = 100;
    
    /**
     * @private
     * Value used to calcualte angle of the data value.
     * This will be used only if angularAxis is not CategoryAxis
     */
    public function get totalValue():Number
    {
        return _totalValue;
    }
    
    /**
     * @private
     */
    public function set totalValue(value:Number):void
    {
        _totalValue = value;
        invalidateData();
        invalidateProperties();
    } 
    
    
    //----------------------------------------------
    //
    // Overridden Methods
    //
    //----------------------------------------------
    
    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent", returns="flash.display.DisplayObject"))]
    override public function addChild(child:IUIComponent):IUIComponent
    {
        var dc:PolarDataChild = new PolarDataChild(child);
        dc.left = 0;
        dc.top = 0;
        _childMap[child] = dc;
        _dataChildren.push(dc);                 
        dc.addEventListener("change",dataChildChangeHandler/*,false,0,true*/);
        invalidateOpCodes();
        return super.addChild(child);
    }
    
    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [SWFOverride(params="flash.display.DisplayObject,int", altparams="mx.core.UIComponent,int", returns="flash.display.DisplayObject"))]
    override public function addChildAt(child:IUIComponent,index:int):IUIComponent
    {
        var dc:PolarDataChild = new PolarDataChild(child);
        _childMap[child] = dc;
        _dataChildren.push(dc);         
        dc.addEventListener("change",dataChildChangeHandler/*,false,0,true*/);
        invalidateOpCodes();
        return super.addChildAt(child,index);
    }
        
    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent", returns="flash.display.DisplayObject"))]
    override public function removeChild(child:IUIComponent):IUIComponent
    {
         super.removeChild(child);
        if (child in _childMap)
            delete _childMap[child];
        _dataChildren.splice(_dataChildren.indexOf(child),1);
        return child;
    }
    
    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    [SWFOverride(returns="flash.display.DisplayObject"))]
    override public function removeChildAt(index:int):IUIComponent
    {
        var child:IUIComponent = super.removeChildAt(index);
        if (child in _childMap)
            delete _childMap[child];
        _dataChildren.splice(index,1);
        return child;
    }
    
    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();
        
        if (_bAxesDirty)
        {
            if (dataTransform)
            {
                if (_angularAxis)
                    dataTransform.setAxis(PolarTransform.ANGULAR_AXIS, _angularAxis);
                if (_radialAxis)
                    dataTransform.setAxis(PolarTransform.RADIAL_AXIS, _radialAxis);
            }
            _bAxesDirty = false; 
        }
        
        var c:PolarChart = PolarChart(chart);
        if (c)
        {
            if (!_angularAxis)
                PolarTransform(dataTransform).setAxis(PolarTransform.ANGULAR_AXIS, c.angularAxis);
            if (!_radialAxis)
                PolarTransform(dataTransform).setAxis(PolarTransform.RADIAL_AXIS, c.radialAxis);
        }
        
        dataTransform.elements = [this];
        invalidateOpCodes();
    }
    
    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
        
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        
        validateData();
        mapChildren();
        
        var updated:Boolean = validateTransform();
        
        if (updated)
        {
            var g:Graphics = graphics;
            
            g.clear();
            var n:int = _opCodes.length;
            for (var i:int = 0; i < n; i++)
            {
                _opCodes[i].render(this,_dataCache);
            }
            positionChildren();
        }
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function invalidateDisplayList():void
    {
        _dataCacheDirty = true;
        _mappingDirty = true;
        _filterDirty = true;
        _transformDirty = true;
        super.invalidateDisplayList();
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function set dataTransform(value:DataTransform):void
    {
        if (value)
        {
            super.dataTransform = value;
        }
        else
        {
            var p:String;
            for (p in dataTransform.axes)
                dataTransform.getAxis(p).unregisterDataTransform(dataTransform);
        }
    }
        
    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function describeData(dimension:String,
                                          requiredFields:uint):Array /* of DataDescription */
    {
        updateMapping();
        var result:Array /* of DataDescription */ = [];

        if (_includeInRanges)
        {
            if (dimension == PolarTransform.RADIAL_AXIS)
            {
                if (_dataCache.xCache.length)
                    result.push(_vDataDesc);
            }
            else if (dimension == PolarTransform.ANGULAR_AXIS)
            {
                if (_dataCache.yCache.length)
                    result.push(_hDataDesc);
            }
        }

        return result;  
    }
        
    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    // this function is called by the charting package when the axes that affect this element change their mapping some how.
    // that means we need to call the mapCache function again to get new mappings.  
    override public function mappingChanged():void
    {
        invalidateDisplayList();
    }    
    
    //----------------------------------------------
    //
    // Methods
    //
    //----------------------------------------------

    mx_internal function dataChildChangeHandler(event:Event):void
    {
        dataChildren = dataChildren;
    }

    /**
     * This adds any <code>DisplayObject</code> as child to current canvas
     * 
     * @param child         A DisplayObject instance that is to be added as child to the current canvas.
     * @param angleLeft     Left angular coordinate of the child, in data coordinates.
     * @param radialTop     Top radial coordinate of the child, in data coordinates.
     * @param angleRight    Right angular coordinate of the child, in data coordinates.
     * @param radialBottom  Bottom radial coordinate of the child, in data coordinates.
     * @param angleCenter   Middle angular coordinate of the child, in data coordinates.
     * @param radialCenter  Middle radial coordinate of the child, in data coordinates.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function addDataChild(child:IUIComponent,angleLeft:* = undefined, radialTop:* = undefined, angleRight:* = undefined, 
                                 radialBottom:* = undefined , angleCenter:* = undefined, radialCenter:* = undefined):void
    {
        var dc:PolarDataChild = new PolarDataChild(child,angleLeft,radialTop,angleRight,radialBottom);
        dc.addEventListener("change",dataChildChangeHandler/*,false,0,true*/);
        addChild(child);
        updateDataChild(child,angleLeft,radialTop,angleRight,radialBottom,angleCenter,radialCenter);
        invalidateOpCodes();
    }
    
    /**
     * Removes all data children (DisplayObject instances) of the canvas.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function removeAllChildren():void
    {
        var n:int = _dataChildren.length;
        for (var i:int = n - 1; i >= 0; i--)
        {
            removeChildAt(i);
        }
    }
    
    /**
     * Updates the position of any child to the current canvas.
     * 
     * @param child         A DisplayObject instance that is to be added as a child of the current canvas.
     * @param angleLeft     Left angular coordinate of the child, in data coordinates.
     * @param radialTop     Top radial coordinate of the child, in data coordinates.
     * @param angleRight    Right angular coordinate of the child, in data coordinates.
     * @param radialBottom  Bottom radial coordinate of the child, in data coordinates.
     * @param angleCenter   Middle angular coordinate of the child, in data coordinates.
     * @param radialCenter  Middle radial coordinate of the child, in data coordinates.
     * 
     * <p>For example:
     * <pre>
     *      var lbl:Label = new Label();
     *      lbl.text = "Last Month";
     *      canvas.addChild(lbl);
     *      canvas.updateDataChild(lbl,200,20);
     * </pre>
     * </p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */

    public function updateDataChild(child:IUIComponent,angleLeft:* = undefined, radialTop:* = undefined, angleRight:* = undefined,
                                    radialBottom:* = undefined, angleCenter:* = undefined, radialCenter:* = undefined):void
    {
        var dc:PolarDataChild = _childMap[child];
        dc.left = angleLeft;
        dc.top = radialTop;
        dc.right = angleRight;
        dc.bottom = radialBottom;
        dc.aCenter = angleCenter;
        dc.rCenter = radialCenter;
        invalidateOpCodes();
    }

    /**
     * Clears the canvas.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function clear():void
    {
        _opCodes = [];
        invalidateOpCodes();
    }

    /**
     * @copy flash.display.Graphics#beginFill()
     * @see flash.display.Graphics
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function beginFill(color:uint , alpha:Number = 1):void
    {
        pushOp(PolarOpCode.BEGIN_FILL, { color: color, alpha: alpha });
    }
    
    /**
     * Fills a drawing area with a bitmap image. Coordinate are in terms of the <code>angularAxis</code> or 
     * <code>radialAxis</code> properties of the canvas.
     * 
     * <p>The usage and parameters of this method are identical to the <code>beginBitmapFill()</code> method of the 
     * flash.display.Graphics class.</p>
     *
     * @param bitmap A transparent or opaque bitmap image that contains the bits to be displayed. 
     *
     * @param x Angle specifying the location of the fill.
     *
     * @param y The distance, in pixels, from the center of the chart to the fill.
     *
     * @param matrix A matrix object (of the flash.geom.Matrix class), 
     * which you can use to define transformations on the bitmap.
     *
     * @param repeat If <code>true</code>, the bitmap image repeats in a tiled pattern. 
     * If <code>false</code>, the bitmap image does not repeat, and the edges of 
     * the bitmap are used for any fill area that extends beyond the bitmap.
     *
     * @param smooth If <code>false</code>, upscaled bitmap images are rendered 
     * by using a nearest-neighbor algorithm and look pixelated. 
     * If <code>true</code>, upscaled bitmap images are rendered by using a bilinear algorithm. 
     * Rendering by using the nearest neighbor algorithm is faster. 
     * 
     * @see flash.display.Graphics#beginBitmapFill()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
    public function beginBitmapFill(bitmap:BitmapData, x:* = undefined,
                                    y:* = undefined, matrix:Matrix = null,
                                    repeat:Boolean = true, smooth:Boolean = true):void
    {
        pushOp(PolarOpCode.BEGIN_BITMAP_FILL, { bitmap:bitmap, x:x, y:y, repeat:repeat, smooth:smooth, matrix:matrix });
    }
     */
    
    /**
     * Draws a curve using the current line style from the current drawing position to (anchorX, anchorY) and using the 
     * control point that (controlX, controlY) specifies. The coordinates that you pass to this method are in terms of 
     * chart data rather than screen coordinates.
     * 
     * <p>The usage and parameters of this method are identical to the <code>curveTo()</code> method of the 
     * flash.display.Graphics class.</p>
     *
     * @param controlAngle The angle that specifies the position of the 
     * control point. 
     *
     * @param controlRadial The distance, in pixels, from the center of the chart to 
     * the control point. 
     *
     * @param anchorAngle The angle that specifies the position of the 
     * anchor point.  
     *
     * @param anchorRadial The distance, in pixels, from the center of the chart to 
     * the anchor point.  
     *
     * @see flash.display.Graphics#curveTo()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function curveTo(controlAngle:*, controlRadial:*, anchorAngle:*, anchorRadial:*):void
    {
        pushOp(PolarOpCode.CURVE_TO, { controlAngle: controlAngle, controlRadial:controlRadial, anchorAngle:anchorAngle, anchorRadial:anchorRadial, borderWidth: borderWidth });
    }
    
    /**
     * Draws a circle. 
     * Set the line style, fill, or both before you call the <code>drawCircle()</code> method, 
     * by calling the <code>linestyle()</code>, <code>lineGradientStyle()</code>, 
     * <code>beginFill()</code>, <code>beginGradientFill()</code>, or <code>beginBitmapFill()</code> method. 
     * Coordinates are in terms of data rather than screen coordinates.
     * 
     * @param angle The angle that specifies the position of the center of the circle. 
     * 
     * @param radial The distance, in pixels, from the center of the chart to 
     * the center of the circle. 
     * 
     * @param radius The radius of the circle (in pixels). 
     * 
     * @see flash.display.Graphics#drawCircle()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function drawCircle(angle:*, radial:*, radius:Number):void
    {
        pushOp(PolarOpCode.DRAW_CIRCLE, { angle: angle, radial: radial, radius: radius, borderWidth: borderWidth });
    }
    
    /**
     * Draws an ellipse. 
     * Set the line style, fill, or both before you call the <code>drawEllipse()</code> method, 
     * by calling the <code>linestyle()</code>, <code>lineGradientStyle()</code>, 
     * <code>beginFill()</code>, <code>beginGradientFill()</code>, or <code>beginBitmapFill()</code> method. 
     * Coordinates are in terms of data rather than screen coordinates.
     * 
     * @param angleLeft The angle specifying the location of the top-left corner of the bounding-box of the ellipse.
     * 
     * @param radialTop The distance, in pixels, from the center of the chart to the location of the 
     * top-left corner of the bounding-box of the ellipse.
     * 
     * @param angleRight The angle specifying the location of the bottom-right corner of the bounding-box of the ellipse.
     * 
     * @param radialBottom The distance, in pixels, from the center of the chart to the location of the 
     * bottom-right corner of the bounding-box of the ellipse.
     * 
     * @see flash.display.Graphics#drawEllipse()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function drawEllipse(angleLeft:*, radialTop:*, angleRight:*, radialBottom:*):void
    {
        pushOp(PolarOpCode.DRAW_ELLIPSE, { angleLeft: angleLeft, radialTop: radialTop, angleRight: angleRight,
                                     radialBottom: radialBottom, borderWidth: borderWidth });
    }
    
    /**
     * Draws a rectangle. 
     * Set the line style, fill, or both before you call the <code>drawRect()</code> method, 
     * by calling the <code>linestyle()</code>, <code>lineGradientStyle()</code>, 
     * <code>beginFill()</code>, <code>beginGradientFill()</code>, or <code>beginBitmapFill()</code> method. 
     * Coordinates are in terms of data rather than screen coordinates.
     * 
     * @param angleLeft The angle specifying the location of the top-left corner of the rectangle.
     * 
     * @param radialTop The distance, in pixels, from the center of the chart to the location of the 
     * top-left corner of the rectangle.
     * 
     * @param angleRight The angle specifying the location of the bottom-right corner of the rectangle.
     * 
     * @param radialBottom The distance, in pixels, from the center of the chart to the location of the 
     * bottom-right corner of the rectangle.
     * 
     * @see flash.display.Graphics#drawRect()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function drawRect(angleLeft:*, radialTop:*, angleRight:*, radialBottom:*):void
    {
        pushOp(PolarOpCode.DRAW_RECT, { angleLeft: angleLeft, radialTop: radialTop, angleRight: angleRight, 
                                  radialBottom: radialBottom, borderWidth: borderWidth });
    }
    
    /**
     * Draws a rounded rectangle. 
     * Set the line style, fill, or both before you call the <code>drawRoundRect()</code> method, 
     * by calling the <code>linestyle()</code>, <code>lineGradientStyle()</code>, 
     * <code>beginFill()</code>, <code>beginGradientFill()</code>, or <code>beginBitmapFill()</code> method. 
     * Coordinates are in terms of data rather than screen coordinates.
     * 
     * @param angleLeft The angle specifying the location of the top-left corner of the rectangle.
     * 
     * @param radialTop The distance, in pixels, from the center of the chart to the location of the 
     * top-left corner of the rectangle.
     * 
     * @param angleRight The angle specifying the location of the bottom-right corner of the rectangle.
     * 
     * @param radialBottom The distance, in pixels, from the center of the chart to the location of the 
     * bottom-right corner of the rectangle.
     * 
     * @param cornerRadius The radius of the corners, in pixels.
     *
     * @see flash.display.Graphics#drawRoundedRect()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function drawRoundedRect(angleLeft:*, radialTop:*, angleRight:*, radialBottom:*, cornerRadius:Number):void
    {
        pushOp(PolarOpCode.DRAW_ROUNDRECT, { angleLeft: angleLeft, radialTop: radialTop, angleRight: angleRight, 
                                       radialBottom: radialBottom, borderWidth: borderWidth,
                                       cornerRadius: cornerRadius });
    }
    
    /** 
     * @copy flash.display.Graphics#endFill()
     * @see flash.display.Graphics
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function endFill():void
    {
        pushOp(PolarOpCode.END_FILL);
    }
    
    /**
     * Specifies a line style that Flash uses for subsequent calls to other Graphics methods (such as <code>lineTo()</code> 
     * or <code>drawCircle()</code>) for the object.
     * 
     * <p>The usage and parameters of this method are identical to the <code>lineStyle()</code> method of the 
     * flash.display.Graphics class.</p>
     * 
     * @param thickness An integer that indicates the thickness of the line in points; valid values are 0-255. 
     * If a number is not specified, or if the parameter is undefined, a line is not drawn. 
     * If a value of less than 0 is passed, the default is 0. 
     * The value 0 indicates hairline thickness; the maximum thickness is 255. 
     * If a value greater than 255 is passed, the default is 255. 
     * 
     * @param color A hexadecimal color value of the line; for example, red is 0xFF0000, blue is 0x0000FF, and so on. 
     * If a value is not indicated, the default is 0x000000 (black).
     * 
     * @param alpha A number that indicates the alpha value of the color of the line; valid values are 0 to 1. 
     * If a value is not indicated, the default is 1 (solid). 
     * If the value is less than 0, the default is 0. 
     * If the value is greater than 1, the default is 1.
     * 
     * @param pixelHinting A Boolean value that specifies whether to hint strokes to full pixels. 
     * This affects both the position of anchors of a curve and the line stroke size itself. 
     * With <code>pixelHinting</code> set to true, line widths are adjusted to full pixel widths. 
     * With <code>pixelHinting</code> set to false, disjoints can appear for curves and straight lines.
     * 
     * @param scaleMode A value from the flash.display.LineScaleMode class that specifies which scale mode to use:
     * 
     * <ul>
     *   <li><code>LineScaleMode.NORMAL</code>: Always scale the line thickness when the object is scaled (the default).</li>
     *   <li><code>LineScaleMode.NONE</code>: Never scale the line thickness.</li>
     *   <li><code>LineScaleMode.VERTICAL</code>: Do not scale the line thickness if the object is scaled vertically only. </li>
     *   <li><code>LineScaleMode.HORIZONTAL</code>: Do not scale the line thickness if the object is scaled horizontally only. </li>
     * </ul>
     * 
     * @param caps A value from the flash.display.CapsStyle class that specifies the type of 
     * caps at the end of lines. 
     * Valid values are: <code>CapsStyle.NONE</code>, <code>CapsStyle.ROUND</code>, 
     * and <code>CapsStyle.SQUARE</code>. If a value is not indicated, use round caps. 
     * 
     * @param joints A value from the flash.display.JointStyle class that specifies the type of 
     * joint appearance used at angles. 
     * Valid values are: <code>JointStyle.BEVEL</code>, <code>JointStyle.MITER</code>, and <code>JointStyle.ROUND</code>. 
     * If a value is not indicated, use round joints. 
     * 
     * @param miterLimit A number that indicates the limit at which a miter is cut off. 
     * Valid values range from 1 to 255 (and values outside that range are rounded to 1 or 255). 
     * This value is only used if the jointStyle is set to "miter". 
     * The <code>miterLimit</code> value represents the length that a miter can extend beyond the point at which 
     * the lines meet to form a joint. 
     * The value expresses a factor of the line thickness. 
     * For example, with a <code>miterLimit</code> factor of 2.5 and a thickness of 10 pixels, the miter is cut off at 25 pixels. 
     *
     * @see flash.display.Graphics#lineStyle()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */    
    public function lineStyle(thickness:Number, color:uint = 0, alpha:Number = 1.0,
                              pixelHinting:Boolean = false, scaleMode:String = "normal",
                              caps:String = null, joints:String = null, miterLimit:Number = 3):void
    {
        borderWidth = thickness;
        pushOp(PolarOpCode.LINE_STYLE, { thickness: thickness, color: color, alpha: alpha, pixelHinting: pixelHinting, scaleMode: scaleMode,
                                    caps: caps, joints: joints, miterLimit: miterLimit });
    }
    
    /**
     * Draws a line using the current line style from the current drawing position to (angle, radial); 
     * the current drawing position is then set to (angle, radial). 
     * If the display object in which you are drawing contains content that was created 
     * with the Flash drawing tools, calls to the <code>lineTo()</code> method are drawn underneath the content. 
     * If you call <code>lineTo()</code> before any calls to the moveTo() method, the default position 
     * for the current drawing is (0, 0). 
     * If any of the parameters are missing, this method fails and the current drawing 
     * position is not changed. Coordinates are in terms of data rather than screen coordinates.
     * 
     * @param angle The angle of the drawing position.
     * 
     * @param radial The distance, in pixels, from the center of the chart to the drawing position. 
     * 
     * @see flash.display.Graphics#lineTo()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function lineTo(angle:*, radial:*):void
    {
        pushOp(PolarOpCode.LINE_TO, { angle: angle, radial:radial, borderWidth: borderWidth });
    }
    
    /**
     * Moves the current drawing position to (angle, radial). 
     * If any of the parameters are missing, this method fails and the current 
     * drawing position is not changed. 
     * Coordinates are in terms of data rather than screen coordinates.
     * 
     * @param angle The angle of the drawing position.
     * 
     * @param radial The distance, in pixels, from the center of the chart to the drawing position. 
     * 
     * @see flash.display.Graphics#moveTo()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function moveTo(angle:*, radial:*):void
    {
        pushOp(PolarOpCode.MOVE_TO, { angle: angle, radial:radial, borderWidth: borderWidth});
    }
    
    /**
     *  Calls the <code>updateTransform()</code> method of the canvas, if necessary.
     *  This method is called automatically by the canvas
     *  during the <code>commitProperties()</code> method, as necessary,
     *  but a derived canvas might call it explicitly
     *  if the generated values are needed at an explicit time.
     *  Filtering and transforming of data relies on specific values
     *  being calculated by the axes, which can in turn
     *  depend on the data that is displayed in the chart.
     *  Calling this function at the wrong time might result
     *  in extra work being done, if those values are updated.
     *  
     *  @return <code>true</code> if the underlying data of the data provider has changed; otherwise, <code>false</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function validateTransform():Boolean
    {
        var updated:Boolean = false;
        if (dataTransform && _transformDirty)
        {
            updated = updateTransform();
        }
        return updated;
    }
    
    /**
     *  Calls the <code>updateMapping()</code> 
     *  and <code>updateFilter()</code> methods of the canvas, if necessary.
     *  This method is called automatically by the canvas
     *  from the <code>commitProperties()</code> method, as necessary,
     *  but a derived canvas might call it explicitly
     *  if the generated values are needed at an explicit time.
     *  
     *  <p>Loading and mapping data against the axes is designed
     *  to be acceptable by the axes at any time.
     *  It is safe to call this method explicitly at any point.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function validateData():void
    {
        if (dataTransform)
        {
            if (_mappingDirty)
            {
                updateMapping();
            }
            if (_filterDirty)
            {
                updateFilter();
            }
        }
    }
    
    /**
     *  Called when the underlying data the canvas represents
     *  needs to be filtered against the ranges represented by the axes
     *  of the associated data transform.
     *  This can happen either because the underlying data has changed
     *  or because the range of the associated axes has changed.
     *  
     *  <p>If you implement a custom canvas type, you should override this method
     *  and filter out any outlying data using the <code>filterCache()</code>
     *  method of the axes managed by its associated data transform.  
     *  The <code>filterCache()</code> method converts any values
     *  that are out of range to <code>NaN</code>.
     *  You must be sure to call the <code>super.updateFilter()</code> method
     *  in your subclass.</p>
     *  
     *  <p>You should not generally call this method directly.
     *  Instead, if you need to guarantee that your data has been filtered
     *  at a given point, call the <code>validateTransform()</code> method
     *  of the PolarDataCanvas class.</p>
     *  
     *  <p>You can generally assume that your <code>updateData()</code>
     *  and <code>updateMapping()</code> methods have been called
     *  prior to this method, if necessary.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function updateFilter():void
    {
        var n:int  = _dataCache.xCache.length;
        for (var i:int = 0; i < n; i++)
        {
            if (isNaN(_dataCache.xCache[i].mappedValue))
                delete _dataCache.xMap[_dataCache.xCache[i].value];
        }
        if (!(chart is PieChart))
        {
            n = _dataCache.yCache.length;
            for (i = 0; i < n; i++)
            {
                if (isNaN(_dataCache.yCache[i].mappedValue))
                    delete _dataCache.yMap[_dataCache.yCache[i].value];
            }
        }
        stripNaNs(_dataCache.xCache,"mappedValue");
        if (!(chart is PieChart))
            stripNaNs(_dataCache.yCache,"mappedValue");
        _filterDirty = false;
    }
    
    /**
     * @private
     */
    private function mapChildren():void
    {
        var width:Number;
        var height:Number;
        for (var p:* in _childMap)
        {
            var dc:PolarDataChild = _childMap[p];
            var pt:Point;
            var dataTransform:PolarTransform = PolarTransform(dataTransform);
            var data:Object = {};
            var da:Array /* of Object */ = [data];
            if (dc.aCenter != undefined)
            {
                data["d0"] = dc.aCenter;
                dataTransform.getAxis(PolarTransform.ANGULAR_AXIS).
                    mapCache(da, "d0", "v0");
                if (chart is PieChart && !(angularAxis is CategoryAxis))
                    data["v0"] = data["v0"]* 100 / totalValue;
                
            }
            else if (dc.right != undefined)
            {
                data["d0"] = dc.right;
                dataTransform.getAxis(PolarTransform.ANGULAR_AXIS).
                    mapCache(da, "d0", "v0");
                if (chart is PieChart && !(angularAxis is CategoryAxis))
                    data["v0"] = data["v0"] * 100 / totalValue;
            }   
            else
            {
                data["d0"] = dc.left;
                dataTransform.getAxis(PolarTransform.ANGULAR_AXIS).
                    mapCache(da, "d0", "v0");
                if (chart is PieChart && !(angularAxis is CategoryAxis))
                    data["v0"] = data["v0"]* 100 / totalValue;
            }
        
            if (!(chart is PieChart))
            {
                if (dc.rCenter != undefined)
                {
                    data["d1"] = dc.rCenter;
                    dataTransform.getAxis(PolarTransform.RADIAL_AXIS).
                        mapCache(da, "d1", "v1");
                    dataTransform.transformCache(da,"v0","s0","v1","s1");
                    pt = new Point(dataTransform.origin.x +
                          Math.cos(data.s0)*data.s1 - widthFor(dc.child) / 2,
                          dataTransform.origin.y -
                          Math.sin(data.s0)*data.s1 - heightFor(dc.child) / 2);
                    
                }
                
                else if (dc.bottom != undefined)
                {
                    data["d1"] = dc.bottom;
                    dataTransform.getAxis(PolarTransform.RADIAL_AXIS).mapCache(da, "d1", "v1");
                    dataTransform.transformCache(da,"v0","s0","v1","s1");
                    pt = new Point(dataTransform.origin.x +
                                    Math.cos(data.s0) * data.s1 - widthFor(dc.child),
                                    dataTransform.origin.y - 
                                    Math.sin(data.s0) * data.s1 - heightFor(dc.child));
                }
                
                else if (dc.top != undefined)
                {
                    data["d1"] = dc.top;
                    dataTransform.getAxis(PolarTransform.RADIAL_AXIS).
                        mapCache(da, "d1", "v1");
                    dataTransform.transformCache(da,"v0","s0","v1","s1");
                    pt = new Point(dataTransform.origin.x +
                          Math.cos(data.s0)*data.s1,
                          dataTransform.origin.y -
                          Math.sin(data.s0)*data.s1);
                    
                }
                
                
                
            }
            else
            {
                dataTransform.transformCache(da,"v0","s0",null,null);
                if (dc.aCenter != undefined)
                {
                    if (dc.rCenter == undefined)
                        dc.rCenter = 1;
                    pt = new Point(dataTransform.origin.x +
                                Math.cos(data.s0) * dc.rCenter - widthFor(dc.child) / 2,
                                dataTransform.origin.y - 
                                Math.sin(data.s0) * dc.rCenter - heightFor(dc.child) / 2);
                }
                if (dc.right != undefined)
                {
                    if (dc.bottom == undefined)
                        dc.bottom = 1;
                    pt = new Point(dataTransform.origin.x +
                                    Math.cos(data.s0) * dc.bottom - widthFor(dc.child),
                                    dataTransform.origin.y - 
                                    Math.sin(data.s0) * dc.bottom - heightFor(dc.child));
                }               
                else
                {
                    if (dc.top == undefined)
                        dc.top = 1;
                    pt = new Point(dataTransform.origin.x +
                                Math.cos(data.s0) * dc.top,
                                dataTransform.origin.y -
                                Math.sin(data.s0) * dc.top);                 
                }
            }
            dc.renderLeft = pt.x;
            dc.renderTop = pt.y;
        }
    }
    
    /**
     *  Removes any item from the provided cache whose <code>field</code>
     *  property is <code>NaN</code>.
     *  Derived classes can call this method from their <code>updateFilter()</code>
     *  implementation to remove any ChartItem objects that were filtered out by the axes.
     *  
     *  @param cache The data cache for the PolarDataCanvas object.
     *  
     *  @param field The value of the item's <code>field</code> property. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function stripNaNs(cache:Array /* of Object */, field:String):void
    {
        var len:int = cache.length;
        var start:int = -1;
        var end:int = -1;
        var i:int;
        var n:int = cache.length;
        
        if (field == "")
        {
            for (i = n - 1; i >= 0; i--)
            {
                if (isNaN(cache[i]))
                {
                    if (start < 0)
                    {
                        start = end = i;
                    }
                    else if (end - 1 == i)
                    {
                        end = i;
                    }
                    else
                    {
                        cache.splice(end, start - end + 1);
                        start = end = i;
                    }
                }
            }
        }
        else
        {
            for (i = n - 1; i >= 0; i--)
            {
                if (isNaN(cache[i][field]))
                {
                    if (start < 0)
                    {
                        start = end = i;
                    }
                    else if (end - 1 == i)
                    {
                        end = i;
                    }
                    else
                    {
                        cache.splice(end, start - end + 1);
                        start = end = i;
                    }
                }
            }
        }

        if (start >= 0)
            cache.splice(end, start - end + 1);
    }
    
    /**
     *  Informs the canvas that the underlying data
     *  in the dataProvider has changed.
     *  This function triggers calls to the <code>updateMapping()</code>
     *  and <code>updateTransform()</code> methods on the next call
     *  to the <code>commitProperties()</code> method.
     * 
     *  @param invalid <code>true</code> if the data has changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function invalidateData(invalid:Boolean = true):void
    {
        if (invalid)
        {
            invalidateDisplayList();
        }
    }
        
    /**
     * @private
     * Takes our data values and converts them into pixel values.
     */
    protected function updateMapping():void
    {
        if (_dataCacheDirty)
        {
            _dataCache = new PolarDataCache();
            var i:int;
            var p:*;
            var record:*;
            var value:*;
            var boundedValue:BoundedValue;
            var n:int = _opCodes.length;
            for (i = 0; i < n; i++)
            {
                _opCodes[i].collectValues(_dataCache);
            }

                
            _dataCache.xCache = [];
            _dataCache.yCache = [];
            _hDataDesc.min = Number.MAX_VALUE;
            _hDataDesc.max = Number.MIN_VALUE;
            _vDataDesc.min = Number.MAX_VALUE;
            _vDataDesc.max = Number.MIN_VALUE;
            
            for (p in _dataCache.xMap)
            {
                value = _dataCache.xMap[p];
                _dataCache.xCache.push({ value: value });
            }
            for (p in _dataCache.yMap)
            {
                value = _dataCache.yMap[p];
                _dataCache.yCache.push({ value: value });
            }
            _mappingDirty = true;
            _dataCacheDirty = false;
        }
        if (_mappingDirty)
        {
            
            dataTransform.getAxis(PolarTransform.ANGULAR_AXIS).mapCache(_dataCache.xCache,"value","mappedValue");
            if (!(angularAxis is CategoryAxis))
            {
                n = _dataCache.xCache.length;
                for (i = 0; i < n; i++)
                {
                    _dataCache.xCache[i].mappedValue = _dataCache.xCache[i].mappedValue * 100 / totalValue;
                }
            }
            if (!(chart is PieChart))
                dataTransform.getAxis(PolarTransform.RADIAL_AXIS).mapCache(_dataCache.yCache,"value","mappedValue");
            
            _transformDirty = true;
            _mappingDirty = false;
            _filterDirty = true;

            var boundedValues:Array /* of BoundedValue */ = [];
            
            n = _dataCache.xCache.length;
            for (i = 0; i < n; i++)
            {
                value = _dataCache.xCache[i];
                boundedValue = _dataCache.xBoundedValues[value.value];
                if (boundedValue)
                {
                    boundedValue.value = value.mappedValue;
                    boundedValues.push(boundedValue);
                }
            }
            if (boundedValues.length > 0)
            {
                _hDataDesc.boundedValues = boundedValues;
                boundedValues = [];
            }
            
            n = _dataCache.yCache.length;
            for (i = 0; i < n; i++)
            {
                value = _dataCache.yCache[i];
                boundedValue = _dataCache.yBoundedValues[value.value];
                if (boundedValue)
                {
                    boundedValue.value = value.mappedValue;
                    boundedValues.push(boundedValue);
                }
            }
            if (boundedValues.length > 0)
            {
                _vDataDesc.boundedValues = boundedValues;
            }
            
            n = _dataCache.yCache.length;
            for (i = 0; i < n; i++)
            {
                record = _dataCache.yCache[i];
                _vDataDesc.min = Math.min(_vDataDesc.min, record.mappedValue);
                _vDataDesc.max = Math.max(_vDataDesc.max, record.mappedValue);
            }
            
            n = _dataCache.xCache.length;
            for (i = 0; i < n; i++)
            {
                record = _dataCache.xCache[i];
                _hDataDesc.min = Math.min(_hDataDesc.min, record.mappedValue);
                _hDataDesc.max = Math.max(_hDataDesc.max, record.mappedValue);
            }
            
        }
    }   
    
    /**
     * @private
     */
    protected function updateTransform():Boolean
    {
        var i:int;
        var record:Object;
        var dataTransform:PolarTransform = PolarTransform(dataTransform);
        var updated:Boolean = false;
        if (_transformDirty == false)
        {
            if (unscaledHeight != _oldUW || unscaledWidth != _oldUW)
            {
                _transformDirty = true;
                _oldUW = unscaledWidth;
                _oldUH = unscaledHeight;
            }
        }
        
        if (_transformDirty)
        {
            var pt:Point;
            updated = true;
            _transformDirty = false;
            dataTransform.transformCache(_dataCache.xCache,"mappedValue","pixelValue",null,null);
            var n:int = _dataCache.xCache.length;           
            for (i = 0; i < n; i++)
            {
                _dataCache.xMap[_dataCache.xCache[i].value] = _dataCache.xCache[i].pixelValue;
            }
            if (!(chart is PieChart))
            {
                dataTransform.transformCache(_dataCache.yCache,null,null,"mappedValue","pixelValue");
                n = _dataCache.yCache.length;
                for (i = 0; i < n; i++)
                {
                    _dataCache.yMap[_dataCache.yCache[i].value] = _dataCache.yCache[i].pixelValue;
                }
            }
            else
            {
                n = _dataCache.yCache.length;
                for (i = 0; i < n; i++)
                {
                    _dataCache.yMap[_dataCache.yCache[i].value] = _dataCache.yCache[i].value;
                }
            }           
        }
        return updated;
    }

    /**
     * @private
     */
    private function widthFor(child:IUIComponent):Number
    {
        return  (child is IUIComponent)? IUIComponent(child).getExplicitOrMeasuredWidth() + 2:
                (child is IFlexDisplayObject)? IFlexDisplayObject(child).measuredWidth + 2:
                child.width; 
    }

    /**
     * @private
     */
    private function heightFor(child:IUIComponent):Number
    {
        return  (child is IUIComponent)? IUIComponent(child).getExplicitOrMeasuredHeight() + 2:
                (child is IFlexDisplayObject)? IFlexDisplayObject(child).measuredHeight + 2:
                child.height; 
    }
    
    /**
     * private
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     private function positionChildren():void
     {
        var dataTransform:PolarTransform = PolarTransform(dataTransform);
        for (var p:* in _childMap)
        {
            var dc:PolarDataChild = _childMap[p];
            var left:Number;
            var right:Number;
            var top:Number;
            var bottom:Number;
            var width:Number;
            var height:Number;
            
            left = dc.renderLeft;
            right = left + widthFor(dc.child);
            top = dc.renderTop;
            bottom = top + heightFor(dc.child);
            if (isNaN(left) || isNaN(right) || isNaN(top) || isNaN(bottom))
            {
                removeChild(p);
                continue;
            }
            if (dc.child is IFlexDisplayObject)
            {
                IFlexDisplayObject(dc.child).setActualSize(right-left,bottom-top);
                IFlexDisplayObject(dc.child).move(left, top);
            }
            else
            {
                dc.child.width = right - left;
                dc.child.height = bottom - top;
                dc.child.x = left;
                dc.child.y = top;
            }           
        }       
     }

    /**
     * @private
     */
    private function invalidateOpCodes():void
    {
        dataChanged();
        invalidateDisplayList();
    }
    
    /**
     * @private
     */
    private function pushOp(code:int, params:Object = null):PolarOpCode
    {
        var op:PolarOpCode = new PolarOpCode(this,code,params);
        _opCodes.push(op);
        invalidateOpCodes();
        return op;
    }
}

}

import mx.charts.chartClasses.PolarDataCanvas;
import mx.charts.chartClasses.BoundedValue;
import org.apache.royale.geom.Matrix;
import mx.display.Graphics;
import mx.core.mx_internal;
import org.apache.royale.geom.Point;
import mx.charts.chartClasses.PolarTransform;

use namespace mx_internal;

class PolarOpCode
{
    public var canvas:PolarDataCanvas;
    public var code:int;
    public var params:Object;
    
    public function PolarOpCode(canvas:PolarDataCanvas,code:int, params:Object = null):void
    {
        this.canvas = canvas;
        this.code = code;
        this.params = params == null ? {} : params;
    }
    
    public static const BEGIN_BITMAP_FILL:int =     0;
    public static const BEGIN_FILL:int =            1;
    public static const CURVE_TO:int =              2;
    public static const DRAW_CIRCLE:int =           3;
    public static const DRAW_ELLIPSE:int =          4;
    public static const DRAW_RECT:int =             5;
    public static const DRAW_ROUNDRECT:int =        6;  
    public static const END_FILL:int =              7;
    public static const LINE_STYLE:int =            8;
    public static const LINE_TO:int =               9;
    public static const MOVE_TO:int =               10;
    
    mx_internal function collectValues(cache:PolarDataCache):void
    {
        switch (code)
        {
            case BEGIN_BITMAP_FILL:
                cache.storeX(params.x)
                cache.storeY(params.y);             
                break;
                
            case CURVE_TO:
                cache.storeX(params.anchorAngle);
                cache.storeY(params.anchorRadial);              
                cache.storeX(params.controlAngle);
                cache.storeY(params.controlRadial);
                break;
            case DRAW_CIRCLE:
            case MOVE_TO:
            case LINE_TO:
                cache.storeX(params.angle);
                cache.storeY(params.radial);
                break;
            case DRAW_ELLIPSE:
                cache.storeX(params.angleLeft);
                cache.storeY(params.radialTop);
                cache.storeX(params.angleRight);
                cache.storeY(params.radialBottom);
                break;
            case DRAW_RECT:
                cache.storeX(params.angleLeft);
                cache.storeY(params.radialTop);
                cache.storeX(params.angleRight);
                cache.storeY(params.radialBottom);
                break;
            case DRAW_ROUNDRECT:
                cache.storeX(params.angleLeft);
                cache.storeY(params.radialTop);
                cache.storeX(params.angleRight);
                cache.storeY(params.radialBottom);
                break;
        }
    }

    mx_internal function render(target:PolarDataCanvas,cache:PolarDataCache):void
    {
        var left:Number;
        var top:Number;
        var right:Number;
        var bottom:Number;
        var controlX:Number;
        var controlY:Number;
        var anchorX:Number;
        var anchorY:Number;
        var x:Number;
        var y:Number;
        var pt:Point;
        var dataTransform:PolarTransform = PolarTransform(dataTransform);
        var data:Object = {};
        var da:Array /* of Object */ = [data];
        
        var g:Graphics = target.graphics;
        switch (code)
        {

            /*case BEGIN_BITMAP_FILL:
                var m:Matrix;
                if (!(params.matrix))
                    m = new Matrix();
                else
                    m = params.matrix.clone();
                    
                var d:* = params.x;
                if (d != undefined)
                    m.tx = cache.x(d);
                d = params.y;
                if (d != undefined)
                    m.ty = cache.y(d);
                g.beginBitmapFill(params.bitmap,m,params.repeat,params.smooth);
                break;*/
            
            case BEGIN_FILL:
                g.beginFill(params.color,params.alpha);
                break;              
            
            case CURVE_TO:
                controlX = cache.x(params.controlAngle);
                controlY = cache.y(params.controlRadial);
                pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(controlX) * controlY, 
                               PolarTransform(canvas.dataTransform).origin.y - Math.sin(controlX) * controlY);
                controlX = pt.x;
                controlY = pt.y;
                anchorX = cache.x(params.anchorAngle);
                anchorY = cache.y(params.anchorRadial);
                pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(anchorX) * anchorY, 
                               PolarTransform(canvas.dataTransform).origin.y - Math.sin(anchorX) * anchorY);
                anchorX = pt.x;
                anchorY = pt.y;
                if (isNaN(controlX) || isNaN(controlY) || isNaN(anchorX) || isNaN(anchorY))
                    return;
                g.curveTo(controlX,controlY,anchorX,anchorY);
                break;
            
            case DRAW_CIRCLE:
                x = cache.x(params.angle);
                y = cache.y(params.radial);
                pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(x) * y, 
                               PolarTransform(canvas.dataTransform).origin.y - Math.sin(x) * y);
                x = pt.x;
                y = pt.y;
                if (isNaN(x) || isNaN(y))
                    return;
                g.drawCircle(x, y, params.radius);
                break;
            
            case DRAW_ELLIPSE:
                left = cache.x(params.angleLeft);
                top = cache.y(params.radialTop);
                pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(left) * top, 
                               PolarTransform(canvas.dataTransform).origin.y - Math.sin(left) * top);
                left = pt.x;
                top = pt.y;
                right = cache.x(params.angleRight);
                bottom = cache.y(params.radialBottom);
                pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(right) * bottom, 
                               PolarTransform(canvas.dataTransform).origin.y - Math.sin(right) * bottom);
                right = pt.x;
                bottom = pt.y;
                if (isNaN(left) || isNaN(top) || isNaN(right) || isNaN(bottom))
                    return;
                g.drawEllipse(left, top, 
                            right - left,bottom - top);
                break;
                
            case DRAW_RECT:
                left = cache.x(params.angleLeft);
                top = cache.y(params.radialTop);
                pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(left) * top, 
                               PolarTransform(canvas.dataTransform).origin.y - Math.sin(left) * top);
                left = pt.x;
                top = pt.y;
                right = cache.x(params.angleRight);
                bottom = cache.y(params.radialBottom);
                pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(right) * bottom, 
                               PolarTransform(canvas.dataTransform).origin.y - Math.sin(right) * bottom);
                right = pt.x;
                bottom = pt.y;
                if (isNaN(left) || isNaN(top) || isNaN(right) || isNaN(bottom))
                    return;
                g.drawRect(left, top, 
                            right - left,bottom - top);
                break;
                
            case DRAW_ROUNDRECT:
                left = cache.x(params.angleLeft);
                top = cache.y(params.radialTop);
                pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(left) * top, 
                               PolarTransform(canvas.dataTransform).origin.y - Math.sin(left) * top);
                left = pt.x;
                top = pt.y;
                right = cache.x(params.angleRight);
                bottom = cache.y(params.radialBottom);
                pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(right) * bottom, 
                               PolarTransform(canvas.dataTransform).origin.y - Math.sin(right) * bottom);
                right = pt.x;
                bottom = pt.y;
                
                if (isNaN(left) || isNaN(top) || isNaN(right) || isNaN(bottom))
                    return;
                g.drawRoundRect(left, top, 
                            right - left,bottom - top,params.cornerRadius,params.cornerRadius);
                break;
                
            case END_FILL:
                g.endFill();
                break;
                    
            case LINE_STYLE:
                g.lineStyle(params.thickness,params.color,params.alpha,params.pixleHinting,params.scaleMode,params.caps,params.joints,params.miterLimit);
                break;
                
            case MOVE_TO:
                x = cache.x(params.angle);
                y = cache.y(params.radial);
                pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(x) * y, 
                               PolarTransform(canvas.dataTransform).origin.y - Math.sin(x) * y);
                x = pt.x;
                y = pt.y;
                if (isNaN(x) || isNaN(y))
                    return;
                g.moveTo(x, y);
                break;
                
            case LINE_TO:
                x = cache.x(params.angle);
                y = cache.y(params.radial);
                pt = new Point(PolarTransform(canvas.dataTransform).origin.x + Math.cos(x) * y, 
                               PolarTransform(canvas.dataTransform).origin.y - Math.sin(x) * y);
                x = pt.x;
                y = pt.y;
                if (isNaN(x) || isNaN(y))
                    return;
                g.lineTo(x, y);
                break;          
        }
    }
}

import mx.core.mx_internal;

use namespace mx_internal;

class PolarDataCache
{
    public var xCache:Array /* of Object */;
    public var yCache:Array; /* of Object */
    
    public var xBoundedValues:Object;
    public var yBoundedValues:Object;
    public var xMap:Object;
    public var yMap:Object;
    
    public function PolarDataCache():void
    {
        xMap = {}; //new Dictionary(true);
        yMap = {}; //new Dictionary(true);
        xCache = [];
        yCache = [];
        xBoundedValues = {}; //new Dictionary(true);
        yBoundedValues = {}; //new Dictionary(true);
    }
    
    mx_internal function storeX(value:*, leftMargin:Number = 0,rightMargin:Number = 0):void
    {
        var bounds:BoundedValue;

        xMap[value] = value;
        
        if (leftMargin != 0 || rightMargin != 0)
        bounds = xBoundedValues[value];
        if (leftMargin > 0)
            leftMargin += 2;
        if (rightMargin > 0)
            rightMargin += 2;
            
        if (!bounds)
        {
            xBoundedValues[value] = bounds = new BoundedValue(0,leftMargin,rightMargin);
        }
        else
        {
            bounds.lowerMargin = Math.max(bounds.lowerMargin,leftMargin);
            bounds.upperMargin = Math.max(bounds.upperMargin,rightMargin);
        }
    }

    mx_internal function storeY(value:*,topMargin:Number = 0,bottomMargin:Number = 0):void
    {
        var bounds:BoundedValue;

        yMap[value] = value;
        if (topMargin != 0 || bottomMargin != 0)
        {
            bounds = yBoundedValues[value];
            if (!bounds)
            {
                yBoundedValues[value] = bounds = new BoundedValue(0,bottomMargin,topMargin);
            }
            else
            {
                bounds.lowerMargin = Math.max(bounds.lowerMargin,bottomMargin);
                bounds.upperMargin = Math.max(bounds.upperMargin,topMargin);
            }
        }
    }
    
    mx_internal function x(value:*):Number
    {
        return Number(xMap[value]);
    }
    
    mx_internal function y(value:*):Number
    {
        return Number(yMap[value]);
    }
}

import mx.core.IUIComponent;
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.events.Event;
use namespace mx_internal;
    
[DefaultProperty("content")]
[Event(name="change")]

class PolarDataChild extends EventDispatcher
{
    public function PolarDataChild(child:IUIComponent = null,left:* = undefined, top:* = undefined, right:* = undefined, bottom:* = undefined,
    aCenter:* = undefined, rCenter:* = undefined):void
    {
        this.child = child;
        this.left = left;
        this.top = top;
        this.bottom = bottom;
        this.right = right;
        this.aCenter = aCenter;
        this.rCenter = rCenter;
    }
    
    public var child:IUIComponent;
    public var left:*;
    public var right:*;
    public var top:*;
    public var bottom:*;
    public var renderLeft:*;
    public var renderTop:*;
    public var rCenter:*;
    public var aCenter:*;
    
    public function set content(value:*):void
    {
        if (value is IUIComponent)
            child = value;
        else if (value is Class)
            child = new value();
        dispatchEvent(new Event("change"));
    }       
}
