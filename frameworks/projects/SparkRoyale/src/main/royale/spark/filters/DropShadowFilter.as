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

package spark.filters
{
//import flash.filters.BitmapFilter;
//import flash.filters.DropShadowFilter;
import mx.filters.BaseDimensionFilter;
import mx.filters.IBitmapFilter;


/**
 * The DropShadowFilter class lets you add a drop shadow to display objects.
 * The shadow algorithm is based on the same box filter that the blur filter uses. You have 
 * several options for the style of the drop shadow, including inner or outer shadow and knockout mode.
 * You can apply the filter to any display object (that is, objects that inherit from the DisplayObject class), 
 * such as MovieClip, SimpleButton, TextField, and Video objects, as well as to BitmapData objects.
 * 
 * <p>The use of filters depends on the object to which you apply the filter:</p>
 * <ul><li>To apply filters to display objects use the
 * <code>filters</code> property (inherited from DisplayObject). Setting the <code>filters</code> 
 * property of an object does not modify the object, and you can remove the filter by clearing the
 * <code>filters</code> property. </li>
 * 
 * <li>To apply filters to BitmapData objects, use the <code>BitmapData.applyFilter()</code> method.
 * Calling <code>applyFilter()</code> on a BitmapData object takes the source BitmapData object 
 * and the filter object and generates a filtered image as a result.</li>
 * </ul>
 * 
 * <p>If you apply a filter to a display object, the value of the <code>cacheAsBitmap</code> property of the 
 * display object is set to <code>true</code>. If you clear all filters, the original value of 
 * <code>cacheAsBitmap</code> is restored.</p>
 * <p>This filter supports Stage scaling. However, it does not support general scaling, rotation, and 
 * skewing. If the object itself is scaled (if <code>scaleX</code> and <code>scaleY</code> are 
 * set to a value other than 1.0), the filter is not scaled. It is scaled only when 
 * the user zooms in on the Stage.</p>
 * 
 * <p>A filter is not applied if the resulting image exceeds the maximum dimensions.
 * In  AIR 1.5 and Flash Player 10, the maximum is 8,191 pixels in width or height, 
 * and the total number of pixels cannot exceed 16,777,215 pixels. (So, if an image is 8,191 pixels 
 * wide, it can only be 2,048 pixels high.) 
 * If, for example, you zoom in on a large movie clip with a filter applied, the filter is 
 * turned off if the resulting image exceeds the maximum dimensions.</p>
 *
 *  @mxml 
 *  <p>The <code>&lt;s:DropShadowFilter&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:DropShadowFilter 
 *    <strong>Properties</strong>
 *    alpha="1"
 *    angle="45"
 *    color="0xFF0000"
 *    distance="4"
 *    hideObject="false"
 *    inner="false"
 *  /&gt;
 *  </pre>
 *
 * @includeExample examples/DropShadowFilterExample.mxml
 *  
 * @see flash.filters.DropShadowFilter
 *  
 * @langversion 3.0
 * @playerversion Flash 10
 * @playerversion AIR 1.5
 * @productversion Flex 4
 */
 
public class DropShadowFilter extends BaseDimensionFilter implements IBitmapFilter
{
    /**
     * Constructor.
     * 
     * @param distance Offset distance for the shadow, in pixels. 
     * @param angle Angle of the shadow, 0 to 360 degrees (floating point). 
     * @param color Color of the shadow, in hexadecimal format 
     * <i>0xRRGGBB</i>. The default value is 0x000000.
     * @param alpha Alpha transparency value for the shadow color. Valid values are 0.0 to 1.0. 
     * For example, .25 sets a transparency value of 25%. 
     * @param blurX Amount of horizontal blur. Valid values are 0 to 255.0 (floating point). 
     * @param blurY Amount of vertical blur. Valid values are 0 to 255.0 (floating point). 
     * @param strength The strength of the imprint or spread. The higher the value, 
     * the more color is imprinted and the stronger the contrast between the shadow and the background. 
     * Valid values are 0 to 255.0. 
     * @param quality The number of times to apply the filter. Use the BitmapFilterQuality constants:
     * <ul>
     * <li><code>BitmapFilterQuality.LOW</code></li>
     * <li><code>BitmapFilterQuality.MEDIUM</code></li>
     * <li><code>BitmapFilterQuality.HIGH</code></li>
     * </ul>
     * <p>For more information about these values, see the <code>quality</code> property description.</p>
     *
     * @param inner Indicates whether or not the shadow is an inner shadow. A value of <code>true</code> specifies
     * an inner shadow. A value of <code>false</code> specifies an outer shadow (a
     * shadow around the outer edges of the object).
     * @param knockout Applies a knockout effect (<code>true</code>), which effectively 
     * makes the object's fill transparent and reveals the background color of the document. 
     * @param hideObject Indicates whether or not the object is hidden. A value of <code>true</code> 
     * indicates that the object itself is not drawn; only the shadow is visible. 
     * 
     * @see flash.filters.BitmapFilterQuality
     * 
     * @langversion 3.0
     * @playerversion Flash 10
     * @playerversion AIR 1.5
     * @productversion Flex 4
     */
    public function DropShadowFilter(distance:Number = 4.0, angle:Number = 45, 
                                     color:uint = 0, alpha:Number = 1.0, 
                                     blurX:Number = 4.0, blurY:Number = 4.0, 
                                     strength:Number = 1.0, quality:int = 1, 
                                     inner:Boolean = false, 
                                     knockout:Boolean = false, 
                                     hideObject:Boolean = false)
     {
        super();
        
        this.distance = distance;
        this.angle = angle;
        this.color = color;
        this.alpha = alpha;
        this.blurX = blurX;
        this.blurY = blurY;
        this.strength = strength;
        this.quality = quality;
        this.inner = inner;
        this.knockout = knockout;
        this.hideObject = hideObject;
     }
    
    //----------------------------------
    //  alpha
    //----------------------------------
    
    private var _alpha:Number = 1.0;
    
    [Inspectable(minValue="0.0", maxValue="1.0")]        
    
    /**
     *  The alpha transparency value for the color. Valid values are 0 to 1. 
     *  For example, .25 sets a transparency value of 25%.
     * 
     *  @default 1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get alpha():Number
    {
        return _alpha;
    }
    
    public function set alpha(value:Number):void
    {
        if (value != _alpha)
        {
            _alpha = value;
            notifyFilterChanged();
        }
    }
    
    //----------------------------------
    //  angle
    //----------------------------------
    
    private var _angle:Number = 45;
    
    /**
     *   The angle of the bevel. Valid values are from 0 to 360°. 
     *   The angle value represents the angle of the theoretical light source falling on the 
     *   object and determines the placement of the effect relative to the object. 
     *   If the distance property is set to 0, the effect is not offset from the object and, 
     *   therefore, the angle property has no effect.
     * 
     *   @default 45
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get angle():Number
    {
        return _angle;
    }
    
    public function set angle(value:Number):void
    {
        if (value != _angle)
        {
            _angle = value;
            notifyFilterChanged();
        }
    }
    
    //----------------------------------
    //  color
    //----------------------------------
    
    private var _color:uint = 0x000000;
    
    /**
     *  The color of the glow. Valid values are in the hexadecimal format 
     *  0xRRGGBB. 
     *  @default 0xFF0000
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get color():uint
    {
        return _color;
    }
    
    public function set color(value:uint):void
    {
        if (value != _color)
        {
            _color = value;
            notifyFilterChanged();
        }
    }
    
    //----------------------------------
    //  distance
    //----------------------------------
    
    private var _distance:Number = 4.0;
    
    /**
     *  The offset distance of the bevel. Valid values are in pixels (floating point). 
     *  @default 4
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get distance():Number
    {
        return _distance;
    }
    
    public function set distance(value:Number):void
    {
        if (value != _distance)
        {
            _distance = value;
            notifyFilterChanged();
        }
    }
    
    //----------------------------------
    //  hideObject
    //----------------------------------
    
    private var _hideObject:Boolean = false;
    
    /**
     *  Indicates whether or not the object is hidden. 
     *  The value <code>true</code> indicates that the 
     *  object itself is not drawn; only the shadow is visible. 
     *  The default is <code>false</code>, meaning that the object is shown.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get hideObject():Boolean
    {
        return _hideObject;
    }
    
    public function set hideObject(value:Boolean):void
    {
        if (value != _hideObject)
        {
            _hideObject = value;
            notifyFilterChanged();
        }
    }
    
    //----------------------------------
    //  inner
    //----------------------------------
    
    private var _inner:Boolean = false;
    
    /**
     *  Specifies whether the glow is an inner glow. 
     *  The value <code>true</code> indicates an inner glow. 
     *  The default is <code>false</code> that creates an outer glow 
     *  (a glow around the outer edges of the object).
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get inner():Boolean
    {
        return _inner;
    }
    
    public function set inner(value:Boolean):void
    {
        if (value != _inner)
        {
            _inner = value;
            notifyFilterChanged();
        }
    }
    
    /**
     * Returns a copy of this filter object.
     * @return A new DropShadowFilter instance with all the
     * properties of the original DropShadowFilter instance.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4 
     */
     
    public function clone():Object
    {
	return null;
        //return new flash.filters.DropShadowFilter(distance, angle, color, alpha, blurX, 
                                                  //blurY, strength, quality, inner, 
                                                  //knockout, hideObject);
    }
        
}
    
}
