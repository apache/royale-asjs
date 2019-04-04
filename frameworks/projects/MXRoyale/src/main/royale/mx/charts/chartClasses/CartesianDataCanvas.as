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
import mx.core.UIComponent;
import mx.display.Graphics;
import org.apache.royale.events.Event;
import org.apache.royale.geom.Matrix;
import org.apache.royale.geom.Point;
import mx.core.mx_internal;
import mx.core.IFlexDisplayObject;
import mx.core.IUIComponent;

use namespace mx_internal;

[DefaultProperty("dataChildren")]

/**
 * This class lets you use add graphical elements such as lines, ellipses, and other shapes
 * by using a graphics API. The values that you pass to the graphics API are in data
 * coordinates rather than screen coordinates. You can also add any DisplaObject to the canvas,
 * in the same way that you add children to containers.
 * 
 * <p>The drawing region for the canvas is determined by the <code>verticalAxis</code>
 * and <code>horizontalAxis</code>, if they are specified. Otherwise,
 * the canvas uses the default axes of the chart to compute the drawing region.</p>
 * 
 * <p>The data coordinates passed as parameters to the drawing APIs can be 
 * actual values of the data coordinate or an object of type <code>CartesianCanvasValue</code>,
 * which can hold a data coordinate value and an offset, in pixels.</p>
 * 
 * @mxml
 *  
 *  <p>The <code>&lt;mx:CartesianDataCanvas&gt;</code> tag inherits all the
 *  properties of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:CartesianDataCanvas
 *    <strong>Properties</strong>
 *    dataChildren="<i>No default</i>"
 *    horizontalAxis="<i>No default</i>"
 *    includeInRanges="<i>false</i>"
 *    verticalAxis="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class CartesianDataCanvas extends ChartElement implements IDataCanvas
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
    public function CartesianDataCanvas()
    {
        super();
        
        dataTransform = new CartesianTransform();
    }
    
    //-----------------------------------------------
    //
    // Variables
    //
    //-----------------------------------------------
          
    private var _data:*;
    private var _offset:Number;
    private var _xMap:Object;
    private var _yMap:Object;
    private var _hDataDesc:DataDescription = new DataDescription();
    private var _vDataDesc:DataDescription = new DataDescription();
    
    private var _dataCache:CartesianDataCache;
    private var _dataCacheDirty:Boolean = true;
    private var _mappingDirty:Boolean = true;
    private var _filterDirty:Boolean = true;
    private var _transformDirty:Boolean = true;
    private var _oldUW:Number;
    private var _oldUH:Number;
    private var borderWidth:Number = 0;
    private var _bAxesDirty:Boolean = false;
    private var _childMap:Object = {}; //new Dictionary(true);
    
    //----------------------------------------------
    //
    // Overridden Properties
    //
    //----------------------------------------------
    
    //----------------------------------
    //  dataTransform
    //----------------------------------

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
            for (var p:String in dataTransform.axes)
            {
                dataTransform.getAxis(p).unregisterDataTransform(dataTransform);
            }
        }
    }  
    
    
    //----------------------------------------------
    //
    // Properties
    //
    //----------------------------------------------
    
    //-----------------------------------------
    //  dataChildren
    //-----------------------------------------
    
    /**
     * @private
     * Storage for dataChildren property
     */
    private var _dataChildren:Array /* of DisplayObject */ = [];
    [Inspectable(category="General")]
    
    /**
     * An array of child objects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
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
        _childMap = {}; //new Dictionary(true);
        _dataChildren = value;
        var n:int = value.length;
        for (var i:int = 0; i < n; i++)
        {
            var dc:CartesianDataChild;
            if (value[i] is CartesianDataChild)               
                dc = value[i];
            else
                dc = new CartesianDataChild(value[i]);
                
            _childMap[dc.child] = dc;
            dc.addEventListener("change",dataChildChangeHandler/*,false,0,true*/);
            super.addChild(dc.child);           
        }
        invalidateOpCodes();
    }    
    
    //----------------------------------
    //  horizontalAxis
    //----------------------------------

    /**
     *  @private
     *  Storage for the horizontalAxis property.
     */
    private var _horizontalAxis:IAxis;
    
    [Inspectable(category="Data")]

    /**
     *  Defines the labels, tick marks, and data position
     *  for items on the x-axis.
     *  Use either the LinearAxis class or the CategoryAxis class
     *  to set the properties of the horizontal axis as a child tag in MXML
     *  or create a LinearAxis or CategoryAxis object in ActionScript.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get horizontalAxis():IAxis
    {
        return _horizontalAxis;
    }
    
    /**
     * @private
     */
    public function set horizontalAxis(value:IAxis):void
    {
        _horizontalAxis = value;
        _bAxesDirty = true;
        
        invalidateData();
        invalidateProperties();
    }
    
    //----------------------------------
    //  includeInRanges
    //----------------------------------
    
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
    
    //--------------------------------------------
    // opCodes
    //--------------------------------------------
    /**
     * @private
     * Storage for opCodes property
     */
    private var _opCodes:Array /* of CartesianOpCode */ = [];
        
    [ArrayElementType("CartesianOpCode")]
    
    /**
     * @private
     */
     
    private function get opCodes():Array /* of CartesianOpCode */
    {
        return _opCodes;
    }
    
    /**
     * @private
     */
    private function set opCodes(value:Array /* of CartesianOpCode */):void
    {       
        _opCodes = value;
        invalidateOpCodes();
    }
    
    
    //----------------------------------
    //  verticalAxis
    //----------------------------------

    /**
     *  @private
     *  Storage for the verticalAxis property.
     */
    private var _verticalAxis:IAxis;

    [Inspectable(category="Data")]

    /**
     *  Defines the labels, tick marks, and data position
     *  for items on the y-axis.
     *  Use either the LinearAxis class or the CategoryAxis class
     *  to set the properties of the vertical axis as a child tag in MXML
     *  or create a LinearAxis or CategoryAxis object in ActionScript.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get verticalAxis():IAxis
    {
        return _verticalAxis;
    }
    
    /**
     *  @private
     */
    public function set verticalAxis(value:IAxis):void
    {
        _verticalAxis = value;
        _bAxesDirty = true;
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
    override public function addChild(child:IUIComponent):IUIComponent
    {
        var dc:CartesianDataChild = new CartesianDataChild(child);
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
    override public function addChildAt(child:IUIComponent,index:int):IUIComponent
    {
        var dc:CartesianDataChild = new CartesianDataChild(child);
        _childMap[child] = dc;
        _dataChildren.push(dc);         
        dc.addEventListener("change",dataChildChangeHandler/*,false,0,true*/);
        invalidateOpCodes();
        return super.addChildAt(child,index);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function commitProperties():void
    {
        super.commitProperties();
        
        if (_bAxesDirty)
        {
            if (dataTransform)
            {
                if (_horizontalAxis)
                {
                    _horizontalAxis.chartDataProvider = dataProvider;
                    CartesianTransform(dataTransform).setAxis(
                        CartesianTransform.HORIZONTAL_AXIS,_horizontalAxis);
                }
                
                if (_verticalAxis)
                {
                    _verticalAxis.chartDataProvider = dataProvider;
                    CartesianTransform(dataTransform).setAxis(
                        CartesianTransform.VERTICAL_AXIS, _verticalAxis);
                }
            }
            _bAxesDirty = false; 
        }
        
        var c:CartesianChart = CartesianChart(chart);
        if (c)
        {
            if (!_horizontalAxis)
            {
                if (dataTransform.axes[CartesianTransform.HORIZONTAL_AXIS] != c.horizontalAxis)
                        CartesianTransform(dataTransform).setAxis(
                            CartesianTransform.HORIZONTAL_AXIS,c.horizontalAxis);
            }
                            
            if (!_verticalAxis)
            {
                if (dataTransform.axes[CartesianTransform.VERTICAL_AXIS] != c.verticalAxis)
                        CartesianTransform(dataTransform).setAxis(
                            CartesianTransform.VERTICAL_AXIS, c.verticalAxis);
            }
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
    override public function removeChildAt(index:int):IUIComponent
    {
        var child:IUIComponent = super.removeChildAt(index);
        if (child in _childMap)
            delete _childMap[child];
        _dataChildren.splice(index,1);
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
        
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        
        validateData();
        
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
    override public function dataToLocal(... dataValues):Point
    {
        var data:Object = {};
        var da:Array /* of Object */ = [ data ];
        var n:int = dataValues.length;
        
        if (n > 0)
        {
            data["d0"] = dataValues[0];
            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).
                mapCache(da, "d0", "v0");
        }
        
        if (n > 1)
        {
            data["d1"] = dataValues[1];
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).
                mapCache(da, "d1", "v1");           
        }

        dataTransform.transformCache(da,"v0","s0","v1","s1");
        
        return new Point(data.s0 + this.x,
                         data.s1 + this.y);
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function localToData(v:Point):Array /* of Object */
    {
        var values:Array /* of Object */ = dataTransform.invertTransform(
                                            v.x - this.x,
                                            v.y - this.y);
        return values;
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
            if (dimension == CartesianTransform.VERTICAL_AXIS)
            {
                if (_dataCache.xCache.length > 0)
                    result.push(_vDataDesc);
            }
            else if (dimension == CartesianTransform.HORIZONTAL_AXIS)
            {
                if (_dataCache.yCache.length > 0)
                    result.push(_hDataDesc);
            }
        }

        return result;  
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
     * Adds the specified display object as a child to the current canvas.
     * 
     * @param child     The display object that is to be added as a child to current canvas.
     * @param left      Left x-coordinate of the <code>child</code> in data coordinates.
     * @param top       Top y-coordinate of the <code>child</code> in data coordinates.
     * @param right     Right x-coordinate of the <code>child</code> in data coordinates.
     * @param bottom    Bottom y-coordinate of the <code>child</code> in data coordinates.
     * @param hCenter   Middle x-coordinate of the <code>child</code> in data coordinates.
     * @param vCenter   Middle y-coordinate of the <code>child</code> in data coordinates.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function addDataChild(child:UIComponent,left:* = undefined, top:* = undefined, right:* = undefined, 
                                 bottom:* = undefined , hCenter:* = undefined, vCenter:* = undefined):void
    {
        var dc:CartesianDataChild = new CartesianDataChild(child,left,top,right,bottom);
        dc.addEventListener("change",dataChildChangeHandler/*,false,0,true*/);
        addChild(child);
        updateDataChild(child,left,top,right,bottom,hCenter,vCenter);
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
     * Updates the position of any child to current canvas.
     * 
     * @param child     The display object that is to be updated.
     * @param left      Left x coordinate of the child, in data coordinates.
     * @param top       Top y coordinate of the child, in data coordinates.
     * @param right     Right x coordinate of the child, in data coordinates.
     * @param bottom    Bottom y coordinate of the child, in data coordinates.
     * @param hCenter   Middle x coordinate of the child, in data coordinates.
     * @param vCenter   Middle y coordinate of the child, in data coordinates.
     * 
     * <p>For example:
     * <pre>
     *      var lbl:Label = new Label();
     *      lbl.text = "Last Month";
     *      canvas.addChild(lbl);
     *      canvas.updateDataChild(lbl,"Feb",200);
     * </pre>
     * </p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function updateDataChild(child:UIComponent,left:* = undefined, top:* = undefined, right:* = undefined,
                                    bottom:* = undefined, hCenter:* = undefined, vCenter:* = undefined):void
    {
        var dc:CartesianDataChild = _childMap[child];
        dc.left = left;
        dc.top = top;
        dc.right = right;
        dc.bottom = bottom;
        dc.horizontalCenter = hCenter;
        dc.verticalCenter = vCenter;
        invalidateOpCodes();
    }

    /**
     * @copy flash.display.Graphics#clear()
     * @see flash.display.Graphics
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
     * <i>Note: With the exception of the <code>beginGradientFill()</code> and <code>beginShaderFill()</code> methods, the following information
     * from the <code>flash.display.Graphics</code> class's <code>beginFill()</code> method applies to this method:</i>
     *  
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
        pushOp(CartesianOpCode.BEGIN_FILL, { color: color, alpha: alpha} );
    }
    
    /**
     * Fills a drawing area with a bitmap image. The coordinates that you pass to this method are relative to 
     * the canvas's horizontal axis and vertical axis.
     * 
     * <p>The usage and parameters of this method are identical to the <code>beginBitmapFill()</code> method of the 
     * flash.display.Graphics class.</p>
     * 
     * @param bitmap A transparent or opaque bitmap image that contains the bits to be displayed. 
     *
     * @param x The x coordinate of the fill.
     *
     * @param y The y coordinate of the fill.
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
        pushOp(CartesianOpCode.BEGIN_BITMAP_FILL, { bitmap:bitmap, x:x, y:y, repeat:repeat, smooth:smooth, matrix:matrix });
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
     * @param controlX The x coordinate of the control point. 
     *
     * @param controlY The y coordinate of the control point.
     *
     * @param anchorX The x coordinate of the anchor point. 
     *
     * @param anchorY The y coordinate of the anchor point.  
     *
     * @see flash.display.Graphics#curveTo()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function curveTo(controlX:*, controlY:*, anchorX:*, anchorY:*):void
    {
        pushOp(CartesianOpCode.CURVE_TO, { controlX: controlX, controlY:controlY, anchorX:anchorX, anchorY:anchorY, borderWidth: borderWidth } );
    }
    
    /**
     * Draws a circle. 
     * Set the line style, fill, or both before you call the <code>drawCircle()</code> method, 
     * by calling the <code>linestyle()</code>, <code>lineGradientStyle()</code>, 
     * <code>beginFill()</code>, <code>beginGradientFill()</code>, or <code>beginBitmapFill()</code> method. 
     * The coordinates that you pass to this method are in terms of chart data rather than screen coordinates.
     * 
     * @param x The x location of the center of the circle (in pixels). 
     * 
     * @param y The y location of the center of the circle (in pixels). 
     * 
     * @param radius The radius of the circle (in pixels). 
     *
     * @see flash.display.Graphics
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function drawCircle(x:*, y:*, radius:Number):void
    {
        pushOp(CartesianOpCode.DRAW_CIRCLE, { x: x, y: y, radius: radius, borderWidth: borderWidth });
    }
    
    /**
     * Draws an ellipse. 
     * Set the line style, fill, or both before you call the <code>drawEllipse()</code> method, 
     * by calling the <code>linestyle()</code>, <code>lineGradientStyle()</code>, 
     * <code>beginFill()</code>, <code>beginGradientFill()</code>, or <code>beginBitmapFill()</code> method. 
     * The coordinates that you pass to this method are in terms of chart data rather than screen coordinates.
     * 
     * @param left The x location of the top-left corner of the bounding-box of the ellipse.
     * 
     * @param top The y location of the top-left corner of the bounding-box of the ellipse.
     * 
     * @param right The x location of the bottom-right corner of the bounding-box of the ellipse.
     * 
     * @param bottom The y location of the bottom-right corner of the bounding-box of the ellipse.
     * 
     * @see flash.display.Graphics#drawEllipse()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function drawEllipse(left:*, top:*, right:*, bottom:*):void
    {
        pushOp(CartesianOpCode.DRAW_ELLIPSE, { left: left, top: top, right: right, bottom: bottom, borderWidth: borderWidth });
    }
    
    /**
     * Draws a rectangle. 
     * Set the line style, fill, or both before you call the <code>drawRect()</code> method, 
     * by calling the <code>linestyle()</code>, <code>lineGradientStyle()</code>, 
     * <code>beginFill()</code>, <code>beginGradientFill()</code>, or <code>beginBitmapFill()</code> method. 
     * The coordinates that you pass to this method are in terms of chart data rather than screen coordinates.
     * 
     * @param left The x location of the top-left corner of the rectangle.
     * 
     * @param top The y location of the top-left corner of the rectangle.
     * 
     * @param right The x location of the bottom-right corner of the rectangle.
     * 
     * @param bottom The y location of the bottom-right corner of the rectangle.
     *
     * @see flash.display.Graphics#drawRect()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function drawRect(left:*, top:*, right:*, bottom:*):void
    {
        pushOp(CartesianOpCode.DRAW_RECT, { left: left, top: top, right: right, bottom: bottom, borderWidth: borderWidth });
    }
    
    /**
     * Draws a rounded rectangle. 
     * Set the line style, fill, or both before you call the <code>drawRoundRect()</code> method, 
     * by calling the <code>linestyle()</code>, <code>lineGradientStyle()</code>, 
     * <code>beginFill()</code>, <code>beginGradientFill()</code>, or <code>beginBitmapFill()</code> method. 
     * The coordinates that you pass to this method are in terms of chart data rather than screen coordinates.
     * 
     * @param left The x location of the top-left corner of the rectangle.
     * 
     * @param top The y location of the top-left corner of the rectangle.
     * 
     * @param right The x location of the bottom-right corner of the rectangle.
     * 
     * @param bottom The y location of the bottom-right corner of the rectangle.
     * 
     * @param cornerRadius The radius of the corners, in pixels.
     * 
     * @see flash.display.Graphics#drawRoundRect()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function drawRoundedRect(left:*, top:*, right:*, bottom:*, cornerRadius:Number):void
    {
        pushOp(CartesianOpCode.DRAW_ROUNDRECT, { left: left, top: top, right: right, bottom: bottom, 
                                    borderWidth: borderWidth,
                                    cornerRadius: cornerRadius });
    }
    
    /** 
     * <i>Note: With the exception of the <code>beginGradientFill()</code> method, the following information
     * from the <code>flash.display.Graphics</code> class's <code>endFill()</code> applies to this method:</i>
     * 
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
        pushOp(CartesianOpCode.END_FILL);
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
        pushOp(CartesianOpCode.LINE_STYLE, { thickness: thickness, color: color, alpha: alpha, pixelHinting: pixelHinting, scaleMode: scaleMode,
                                    caps: caps, joints: joints, miterLimit: miterLimit });
    }
    
    /**
     * Draws a line using the current line style from the current drawing position to (x, y); 
     * the current drawing position is then set to (x, y). 
     * If the display object in which you are drawing contains content that was created 
     * with the Flash drawing tools, calls to the <code>lineTo()</code> method are drawn underneath the content. 
     * If you call <code>lineTo()</code> before any calls to the moveTo() method, the default position 
     * for the current drawing is (0, 0). 
     * If any of the parameters are missing, this method fails and the current drawing 
     * position is not changed. Coordinates are in terms of data rather than screen coordinates.
     * The coordinates that you pass to this method are in terms of chart data rather than screen coordinates.
     * 
     * @param x The x coordinate of the drawing position.
     * 
     * @param y The y coordinate of the drawing position. 
     * 
     * @see flash.display.Graphics#lineTo()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function lineTo(x:*, y:*):void
    {
        pushOp(CartesianOpCode.LINE_TO, { x: x, y:y, borderWidth: borderWidth });
    }
    
    /**
     * Moves the current drawing position to (x, y). 
     * If any of the parameters are missing, this method fails and the current 
     * drawing position is not changed. 
     * The coordinates that you pass to this method are in terms of chart data rather than screen coordinates.
     * 
     * @param x The x coordinate of the drawing position.
     * 
     * @param y The y coordinate of the drawing position. 
     *
     * @see flash.display.Graphics#moveTo()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function moveTo(x:*, y:*):void
    {
        pushOp(CartesianOpCode.MOVE_TO, { x: x, y:y, borderWidth: borderWidth });
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
     *  @return Returns <code>true</code> if <code>updateTransform()</code> was called. Otherwise, <code>false</code>.
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
     *  Loading and mapping data against the axes is designed
     *  to be acceptable by the axes at any time.
     *  It is safe this method explicitly at any point.
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
     *  If you implement a custom canvas type, you should override this method
     *  and filter out any outlying data using the <code>filterCache()</code>
     *  method of the axes managed by its associated data transform.  
     *  The <code>filterCache()</code> method converts any values
     *  that are out of range to <code>NaN</code>.
     *  You must be sure to call the <code>super.updateFilter()</code> method
     *  in your subclass.
     *  You should not generally call this method directly.
     *  Instead, if you need to guarantee that your data has been filtered
     *  at a given point, call the <code>validateTransform()</code> method
     *  of the CartesianDataCanvas class.
     *  You can generally assume that your <code>updateData()</code>
     *  and <code>updateMapping()</code> methods have been called
     *  prior to this method, if necessary.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    
    protected function updateFilter():void
    {
        dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).filterCache(_dataCache.yCache,"mappedValue","filteredValue");
        dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).filterCache(_dataCache.xCache,"mappedValue","filteredValue");
        
        var n:int = _dataCache.xCache.length;
        for (var i:int = 0; i < n; i++)
        {
            if (isNaN(_dataCache.xCache[i].filteredValue))
                delete _dataCache.xMap[_dataCache.xCache[i].value];
        }
        
        n = _dataCache.yCache.length;
        for (i = 0; i < n; i++)
        {
            if (isNaN(_dataCache.yCache[i].filteredValue))
                delete _dataCache.yMap[_dataCache.yCache[i].value];
        }
        stripNaNs(_dataCache.xCache,"filteredValue");
        stripNaNs(_dataCache.yCache,"filteredValue");
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
            var dc:CartesianDataChild = _childMap[p];
            if (dc.horizontalCenter != undefined)
            {
                width = widthFor(dc.child);
                split(dc.horizontalCenter)
                _dataCache.storeX(_data,width/2 - _offset,width/2 + _offset);
            }
            else if (dc.right == undefined)
            {
                split(dc.left);
                _dataCache.storeX(_data,- _offset,widthFor(dc.child) + _offset);
            }
            else if (dc.left == undefined)              
            {
                split(dc.right);
                _dataCache.storeX(_data,widthFor(dc.child) - _offset,_offset);
            }   
            else
            {
                split(dc.left);
                _dataCache.storeX(_data,-_offset,_offset);
                split(dc.right);
                _dataCache.storeX(_data,-_offset,_offset);
            }
            if (dc.verticalCenter != undefined)
            {
                height = heightFor(dc.child);
                split(dc.verticalCenter);
                _dataCache.storeY(_data,height/2 - _offset,height/2 + _offset);
            }
            else if (dc.bottom== undefined)
            {
                split(dc.top);
                _dataCache.storeY(_data,- _offset,heightFor(dc.child) + _offset);
            }
            else if (dc.top == undefined)               
            {
                split(dc.bottom);
                _dataCache.storeY(_data,heightFor(dc.child) - _offset,_offset);
            }
            else
            {
                split(dc.top);
                _dataCache.storeY(_data,-_offset,_offset);
                split(dc.bottom);
                _dataCache.storeY(_data,-_offset,_offset);
            }
        }
    }
    
    /**
     *  Removes any item from the provided cache whose <code>field</code>
     *  property is <code>NaN</code>.
     *  Derived classes can call this method from their updateFilter()
     * implementation to remove any ChartItems filtered out by the axes.
     *  
     *  @param cache An array of objects.
     * 
     *  @param field The <code>field</code> property test against.
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
        var n:int;
        
        if (field == "")
        {
            n = cache.length;
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
            n = cache.length;
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
     *  in the data provider has changed.
     *  This method triggers calls to the <code>updateMapping()</code>
     *  and <code>updateTransform()</code> methods on the next call
     *  to the <code>commitProperties()</code> method.
     *  
     *  @param invalid <code>true</code> if the data provider's data has changed.
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
            _dataCache = new CartesianDataCache();
            
            var p:*;
            var record:*;
            var value:*;
            var boundedValue:BoundedValue;
            
            var n:int = _opCodes.length;
            for (var i:int = 0; i < n; i++)
            {
                _opCodes[i].collectValues(_dataCache);
            }

            mapChildren();
                
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
            _dataCacheDirty = false;
            _mappingDirty = true;
        }
        if (_mappingDirty)
        {
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(_dataCache.yCache,"value","mappedValue",true);
            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(_dataCache.xCache,"value","mappedValue",true);
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
        var record:Object;
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
            updated = true;
            _transformDirty = false;
            dataTransform.transformCache(_dataCache.xCache,"mappedValue","pixelValue",null,null);           
            dataTransform.transformCache(_dataCache.yCache,null,null,"mappedValue","pixelValue");           
    
            var n:int = _dataCache.xCache.length;
            for (var i:int = 0; i < n; i++)
            {
                record = _dataCache.xCache[i];
                _dataCache.xMap[record.value] = record.pixelValue;
            }
            
            n = _dataCache.yCache.length;
            for (i = 0; i < n; i++)
            {
                record = _dataCache.yCache[i];
                _dataCache.yMap[record.value] = record.pixelValue;
            }
        }
        return updated;
    }
  
    /**
     * @private
     * Retrieves value and offset from given data
     */
    private function split(v:*):void
    {
        if (v is CartesianCanvasValue)
        {
            _data = v.value;
            _offset = v.offset;
            if (isNaN(_offset))
                _offset = 0;
        }
        else
        {
            _data = v;
            _offset = 0;
        }
    }
    
    /**
     * @private
     * Retrieves value from given data
     */
    private function data(v:*):*
    {
        if (v is CartesianCanvasValue)
            return v.value;
        else
            return v;
    }
    
    /**
     * @private
     * Retrieves offset from given data
     */
    private function offset(v:*):*
    {
        if (v is CartesianCanvasValue)
            return v.offset;
        else
            return 0;
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
        for (var p:* in _childMap)
        {
            var dc:CartesianDataChild = _childMap[p];
            var left:Number;
            var right:Number;
            var top:Number;
            var bottom:Number;
            var hCenter:Number;
            var vCenter:Number;
            var width:Number;
            var height:Number;
            
            if (dc.horizontalCenter != undefined)
            {
                hCenter = _dataCache.x(data(dc.horizontalCenter)) + offset(dc.horizontalCenter);
                width = widthFor(dc.child);
                left = hCenter - width/2;
                right = hCenter + width/2;      
            }
            else if (dc.right == undefined)
            {
                left = _dataCache.x(data(dc.left)) + offset(dc.left);
                right = left + widthFor(dc.child);
            }
            else if (dc.left == undefined)              
            {
                right = _dataCache.x(data(dc.right)) + offset(dc.right);
                left = right - widthFor(dc.child);
            }
            else
            {
                left = _dataCache.x(data(dc.left)) + offset(dc.left);
                right = _dataCache.x(data(dc.right)) + offset(dc.right);
            }
            
            if (dc.verticalCenter != undefined)
            {
                vCenter = _dataCache.y(data(dc.verticalCenter)) + offset(dc.verticalCenter);
                height = heightFor(dc.child);
                top = vCenter - height/2;
                bottom= vCenter + height/2;     
            }
            else if (dc.bottom == undefined)
            {
                top = _dataCache.y(data(dc.top)) + offset(dc.top);
                bottom = top + heightFor(dc.child);
            }
            else if (dc.top == undefined)               
            {
                bottom = _dataCache.y(data(dc.bottom)) + offset(dc.bottom);
                top = bottom - heightFor(dc.child);
            }
            else
            {
                top = _dataCache.y(data(dc.top)) + offset(dc.top);
                bottom = _dataCache.y(data(dc.bottom)) + offset(dc.bottom);
            }
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
    private function pushOp(code:int, params:Object = null):CartesianOpCode
    {
        var op:CartesianOpCode = new CartesianOpCode(this,code,params);
        _opCodes.push(op);
        invalidateOpCodes();
        return op;
    }
}

}

import mx.charts.chartClasses.CartesianDataCanvas;
import mx.charts.chartClasses.BoundedValue;
import org.apache.royale.geom.Matrix;
import mx.display.Graphics;
import mx.charts.chartClasses.CartesianCanvasValue;
import mx.core.mx_internal;

use namespace mx_internal;

class CartesianOpCode
{
    public var canvas:CartesianDataCanvas;
    public var code:int;
    public var params:Object;
    
    public function CartesianOpCode(canvas:CartesianDataCanvas,code:int, params:Object = null):void
    {
        this.canvas = canvas;
        this.code = code;
        this.params = (params == null) ? {} : params;
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
    
    private var _data:*;
    private var _offset:Number;

    private function split(v:*):void
    {
        if (v is CartesianCanvasValue)
        {
            _data = v.value;
            _offset = v.offset;
            if (isNaN(_offset))
                _offset = 0;
        }
        else
        {
            _data = v;
            _offset = 0;
        }
    }
    
    private function data(v:*):*
    {
        if (v is CartesianCanvasValue)
            return v.value;
        else
            return v;
    }
    
    private function offset(v:*):*
    {
        if (v is CartesianCanvasValue)
            return v.offset;
        else
            return 0;
    }
    
    mx_internal function collectValues(cache:CartesianDataCache):void
    {
        switch (code)
        {
            case BEGIN_BITMAP_FILL:
                split(params.x);
                if (_data != undefined)
                    cache.storeX(_data,-_offset,_offset);
                split(params.y);
                if (_data != undefined)
                    cache.storeY(_data,-_offset,_offset);
                break;
            case CURVE_TO:
                split(params.anchorX);
                cache.storeX(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                split(params.anchorY);
                cache.storeY(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                split(params.controlX);
                cache.storeX(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                split(params.controlY);
                cache.storeY(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                break;
            case DRAW_CIRCLE:
                split(params.x);
                cache.storeX(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                split(params.y);
                cache.storeY(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                break;
            case MOVE_TO:
            case LINE_TO:
                split(params.x);
                cache.storeX(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                split(params.y);
                cache.storeY(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                break;
            case DRAW_ELLIPSE:
                split(params.left);
                cache.storeX(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                split(params.top);
                cache.storeY(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                split(params.right);
                cache.storeX(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                split(params.bottom);
                cache.storeY(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                break;
            case DRAW_RECT:
                split(params.left);
                cache.storeX(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                split(params.top);
                cache.storeY(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                split(params.right);
                cache.storeX(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                split(params.bottom);
                cache.storeY(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                break;
            case DRAW_ROUNDRECT:
                split(params.left);
                cache.storeX(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                split(params.top);
                cache.storeY(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                split(params.right);
                cache.storeX(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                split(params.bottom);
                cache.storeY(_data,-_offset+params.borderWidth/2,_offset+params.borderWidth/2);
                break;
        }
    }

    mx_internal function render(target:CartesianDataCanvas,cache:CartesianDataCache):void
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
        
        var g:Graphics = target.graphics;
            switch (code)
        {
            /*
            case BEGIN_BITMAP_FILL:
                var m:Matrix;
                if (!(params.matrix))
                    m = new Matrix();
                else
                    m = params.matrix.clone();
                    
                var d:* = data(params.x);
                if (d != undefined)
                    m.tx = cache.x(d);
                m.tx  += offset(params.x);
                d = data(params.y);
                if (d != undefined)
                    m.ty = cache.y(d);
                m.ty += offset(params.y);
                g.beginBitmapFill(params.bitmap, m, params.repeat, params.smooth);
                break;
            */
            case BEGIN_FILL:
                g.beginFill(params.color, params.alpha);
                break;              
            
            case CURVE_TO:
                controlX = cache.x(data(params.controlX)) + offset(params.controlX);
                controlY = cache.y(data(params.controlY)) + offset(params.controlY);
                anchorX = cache.x(data(params.anchorX)) + offset(params.anchorX);
                anchorY = cache.y(data(params.anchorY)) + offset(params.anchorY);
                if (isNaN(controlX) || isNaN(controlY) || isNaN(anchorX) || isNaN(anchorY))
                    return;
                g.curveTo(controlX, controlY, anchorX, anchorY);
                break;
            
            case DRAW_CIRCLE:
                x = cache.x(data(params.x)) + offset(params.x);
                y = cache.y(data(params.y)) + offset(params.y);
                if (isNaN(x) || isNaN(y))
                    return;
                 g.drawCircle(x, y, params.radius);
                break;
            
            case DRAW_ELLIPSE:
                left = cache.x(data(params.left)) + offset(params.left);
                top = cache.y(data(params.top)) + offset(params.top);
                right = cache.x(data(params.right)) + offset(params.right);
                bottom = cache.y(data(params.bottom)) + offset(params.bottom);
                if (isNaN(left) || isNaN(top) || isNaN(right) || isNaN(bottom))
                    return;
                g.drawEllipse(left, top, 
                            right - left,bottom - top);
                break;
                
            case DRAW_RECT:
                left = cache.x(data(params.left)) + offset(params.left);
                top = cache.y(data(params.top)) + offset(params.top);
                right = cache.x(data(params.right)) + offset(params.right);
                bottom = cache.y(data(params.bottom)) + offset(params.bottom);
                if (isNaN(left) || isNaN(top) || isNaN(right) || isNaN(bottom))
                    return;
                g.drawRect(left, top, 
                            right - left,bottom - top);
                break;
                
            case DRAW_ROUNDRECT:
                left = cache.x(data(params.left)) + offset(params.left);
                top = cache.y(data(params.top)) + offset(params.top);
                right = cache.x(data(params.right)) + offset(params.right);
                bottom = cache.y(data(params.bottom)) + offset(params.bottom);
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
                x = cache.x(data(params.x)) + offset(params.x);
                y = cache.y(data(params.y)) + offset(params.y);
                if (isNaN(x) || isNaN(y))
                    return;
                g.moveTo(x , y);
                break;
                
            case LINE_TO:
                x = cache.x(data(params.x)) + offset(params.x);
                y = cache.y(data(params.y)) + offset(params.y);
                if (isNaN(x) || isNaN(y))
                    return;
                g.lineTo(x,y);
                break;          
        }
    }
}

import mx.core.mx_internal;

use namespace mx_internal;

class CartesianDataCache
{
    public var xCache:Array /* of Object */;
    public var yCache:Array /* of Object */;
    
    public var xBoundedValues:Object;
    public var yBoundedValues:Object;
    public var xMap:Object;
    public var yMap:Object;
    
    public function CartesianDataCache():void
    {
        xMap = {}; //new Dictionary(true);
        yMap = {}; //new Dictionary(true);
        xCache = [];
        yCache = [];
        xBoundedValues = {}; //new Dictionary(true);
        yBoundedValues = {}; //new Dictionary(true);
    }
    
    mx_internal function storeX(value:*,leftMargin:Number = 0, rightMargin:Number = 0):void
    {
        var bounds:BoundedValue;

        if (leftMargin < 0)
            leftMargin = 0;
        if (rightMargin < 0)
            rightMargin = 0;
            
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

class CartesianDataChild extends EventDispatcher
{
    public function CartesianDataChild(child:IUIComponent = null,left:* = undefined, top:* = undefined, right:* = undefined, bottom:* = undefined,
    horizontalCenter:* = undefined, verticalCenter:* = undefined):void
    {
        this.child = child;
        this.left = left;
        this.top = top;
        this.bottom = bottom;
        this.right = right;
    }
    
    public var child:IUIComponent;
    public var left:*;
    public var right:*;
    public var top:*;
    public var bottom:*;        
    public var horizontalCenter:*;
    public var verticalCenter:*;
    
    public function set content(value:*):void
    {
        if (value is IUIComponent)
            child = value;
        else if (value is Class)
            child = new value();
        dispatchEvent(new Event("change"));
    }       
}
