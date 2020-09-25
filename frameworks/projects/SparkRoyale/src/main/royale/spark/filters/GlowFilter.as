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
//import flash.filters.GlowFilter;
import mx.filters.BaseDimensionFilter;
import mx.filters.IBitmapFilter;

/**
 * The GlowFilter class lets you apply a glow effect to display objects.
 * You have several options for the style of the 
 * glow, including inner or outer glow and knockout mode. 
 * The glow filter is similar to the drop shadow filter with the <code>distance</code>
 * and <code>angle</code> properties of the drop shadow filter set to 0. 
 * You can apply the filter to any display object (that is, objects that inherit from the DisplayObject class), 
 * such as MovieClip, SimpleButton, TextField, and Video objects, as well as to BitmapData objects.
 *
 * <p>The use of filters depends on the object to which you apply the filter:</p>
 * <ul><li>To apply filters to display objects, use the
 * <code>filters</code> property (inherited from DisplayObject). Setting the <code>filters</code> 
 * property of an object does not modify the object, and you can remove the filter by clearing the
 * <code>filters</code> property. </li>
 * 
 * <li>To apply filters to BitmapData objects, use the <code>BitmapData.applyFilter()</code> method.
 * Calling <code>applyFilter()</code> on a BitmapData object takes the source BitmapData object 
 * and the filter object and generates a filtered image as a result.</li>
 * </ul>
 * 
 * <p>If you apply a filter to a display object, the <code>cacheAsBitmap</code> property of the 
 * display object is set to <code>true</code>. If you clear all filters, the original value of 
 * <code>cacheAsBitmap</code> is restored.</p>
 *
 * <p>This filter supports Stage scaling. However, it does not support general scaling, rotation, and 
 * skewing. If the object itself is scaled (if <code>scaleX</code> and <code>scaleY</code> are 
 * set to a value other than 1.0), the filter is not scaled. It is scaled only when the user zooms
 * in on the Stage.</p>
 * 
 * <p>A filter is not applied if the resulting image exceeds the maximum dimensions.
 * In  AIR 1.5 and Flash Player 10, the maximum is 8,191 pixels in width or height, 
 * and the total number of pixels cannot exceed 16,777,215 pixels. (So, if an image is 8,191 pixels 
 * wide, it can only be 2,048 pixels high.) 
 * For example, if you zoom in on a large movie clip with a filter applied, the filter is 
 * turned off if the resulting image exceeds the maximum dimensions.</p>
 * 
 *  @mxml 
 *  <p>The <code>&lt;s:GlowFilter&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:GlowFilter
 *    <strong>Properties</strong>
 *    alpha="1"
 *    color="0xFF0000"
 *    inner="false"
 *  /&gt;
 *  </pre>
 *
 * @see flash.filters.GlowFilter
 * @see flash.display.BitmapData#applyFilter()
 * @see flash.display.DisplayObject#filters
 * @see flash.display.DisplayObject#cacheAsBitmap
 * @see flash.display.DisplayObject#scaleX
 * @see flash.display.DisplayObject#scaleY
 * @see flash.filters.DropShadowFilter#distance
 * @see flash.filters.DropShadowFilter#angle
 *
 * @includeExample examples/GlowFilterExample.mxml
 *  
 * @langversion 3.0
 * @playerversion Flash 10
 * @playerversion AIR 1.5
 * @productversion Flex 4
 */

public class GlowFilter extends BaseDimensionFilter implements IBitmapFilter
{
    
    /**
     * Constructor.
     * 
     * @param color The color of the glow, in the hexadecimal format 
     * 0x<i>RRGGBB</i>. The default value is 0xFF0000.
     * @param alpha The alpha transparency value for the color. Valid values are 0 to 1. For example,
     * .25 sets a transparency value of 25%.
     * @param blurX The amount of horizontal blur. Valid values are 0 to 255 (floating point). Values
     * that are a power of 2 (such as 2, 4, 8, 16 and 32) are optimized 
     * to render more quickly than other values.
     * @param blurY The amount of vertical blur. Valid values are 0 to 255 (floating point). 
     * Values that are a power of 2 (such as 2, 4, 8, 16 and 32) are optimized 
     * to render more quickly than other values.
     * @param strength The strength of the imprint or spread. The higher the value, 
     * the more color is imprinted and the stronger the contrast between the glow and the background. 
     * Valid values are 0 to 255. 
     * @param quality The number of times to apply the filter. Use the BitmapFilterQuality constants:
     * <ul>
     * <li><code>BitmapFilterQuality.LOW</code></li>
     * <li><code>BitmapFilterQuality.MEDIUM</code></li>
     * <li><code>BitmapFilterQuality.HIGH</code></li>
     * </ul>
     * <p>For more information, see the description of the <code>quality</code> property.</p>
     * @param inner Specifies whether the glow is an inner glow. The value <code> true</code> specifies
     * an inner glow. The value <code>false</code> specifies an outer glow (a glow
     * around the outer edges of the object). 
     * @param knockout Specifies whether the object has a knockout effect. The value <code>true</code>
     * makes the object's fill transparent and reveals the background color of the document. 
     *
     * @see BitmapFilterQuality
     *
     * @langversion 3.0
     * @playerversion Flash 10
     * @playerversion AIR 1.5
     * @productversion Flex 4
     *
     */
    public function GlowFilter(color:uint = 0xFF0000, alpha:Number = 1.0, 
                               blurX:Number = 4.0, blurY:Number = 4.0, 
                               strength:Number = 1, quality:int = 1, 
                               inner:Boolean = false, knockout:Boolean = false)
    {
        super();
        
        this.color = color;
        this.alpha = alpha;
        this.blurX = blurX;
        this.blurY = blurY;
        this.strength = strength;
        this.quality = quality;
        this.inner = inner;
        this.knockout = knockout;
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
    //  color
    //----------------------------------
    
    private var _color:uint = 0xFF0000;
    
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
    //  inner
    //----------------------------------
    
    private var _inner:Boolean = false;
    
    /**
     *  Specifies whether the glow is an inner glow. 
     *  The value true indicates an inner glow. 
     *  The default is false, meaning an outer glow 
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
     * @return A new GlowFilter instance with all the
     * properties of the original GlowFilter instance.
     *
     * @langversion 3.0
     * @playerversion Flash 10
     * @playerversion AIR 1.5
     * @productversion Flex 4
     */
    public function clone():Object
    {
        //return new flash.filters.GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
        return null;
    }



    
}

}
