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

package spark.skins
{

	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import spark.components.supportClasses.Skin;
/*
import flash.display.DisplayObject;
import flash.geom.ColorTransform;

import spark.components.supportClasses.Skin;
import spark.primitives.supportClasses.GraphicElement;
*/
/**
 *  Base class for Spark skins.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */    
public class SparkSkin extends Skin
{
    /*static private const DEFAULT_COLOR_VALUE:uint = 0xCC;
    static private const DEFAULT_COLOR:uint = 0xCCCCCC;
    static private const DEFAULT_SYMBOL_COLOR:uint = 0x000000;
    
    static private var colorTransform:ColorTransform = new ColorTransform();
    */
    /**
     *  Specifies whether or not this skin should be affected by the <code>chromeColor</code> style.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected var useChromeColor:Boolean = false;
    
    //private var colorized:Boolean = false;
    
    /**
     * Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function SparkSkin()
    {
        super();
    }
    
	// not implemented
	public function get colorizeExclusions() : Array { return []}
    /**
     *  @private
     */
	
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // Do all colorizing here, before calling super.updateDisplayList(). This ensures that
        // graphic elements are drawn correctly the first time, and don't trigger a redraw for
        // any new colors.
        
        var i:int;
        
        // symbol color
        /*var symbols:Array = symbolItems;
        
        if (symbols && symbols.length > 0)
        {
            var symbolColor:uint = getStyle("symbolColor");
            
            for (i = 0; i < symbols.length; i++)
            {
                if (this[symbols[i]])
                    this[symbols[i]].color = symbolColor;
            }
        }
        
        // content color
        var content:Array = contentItems;
        
        if (content && content.length > 0)
        {
            var contentBackgroundColor:uint = getStyle("contentBackgroundColor");
            var contentBackgroundAlpha:Number = getStyle("contentBackgroundAlpha");
            
            for (i = 0; i < content.length; i++)
            {
                if (this[content[i]])
                {
                    this[content[i]].color = contentBackgroundColor;
                    this[content[i]].alpha = contentBackgroundAlpha;
                }
            }
        }*/
        
        // chrome color
        var chromeColor:uint = getStyle("chromeColor");
        /*
        if ((chromeColor != DEFAULT_COLOR  || colorized) && useChromeColor)
        {          
            colorTransform.redOffset = ((chromeColor & (0xFF << 16)) >> 16) - DEFAULT_COLOR_VALUE;
            colorTransform.greenOffset = ((chromeColor & (0xFF << 8)) >> 8) - DEFAULT_COLOR_VALUE;
            colorTransform.blueOffset = (chromeColor & 0xFF) - DEFAULT_COLOR_VALUE;
            colorTransform.alphaMultiplier = alpha;
            
            //transform.colorTransform = colorTransform;
            
            // Apply inverse colorizing to exclusions
            var exclusions:Array = colorizeExclusions;
            
            if (exclusions && exclusions.length > 0)
            {
                colorTransform.redOffset = -colorTransform.redOffset;
                colorTransform.greenOffset = -colorTransform.greenOffset;
                colorTransform.blueOffset = -colorTransform.blueOffset;
                
                for (i = 0; i < exclusions.length; i++)
                {
                    var exclusionObject:Object = this[exclusions[i]];
                    
                    if (exclusionObject &&
                        (exclusionObject is DisplayObject ||
                         exclusionObject is GraphicElement))
                    {
                        colorTransform.alphaMultiplier = exclusionObject.alpha;
                        exclusionObject.transform.colorTransform = colorTransform;
                    }
                }
            }
    
            //colorized = true;
        }*/
        
        // Finally, call super.updateDisplayList() after setting up the colors.
        super.updateDisplayList(unscaledWidth, unscaledHeight);
    }
    
    /**
     *  @private
     */
	
    /*override*/ public function beginHighlightBitmapCapture():Boolean
    {
        var needRedraw:Boolean// = super.beginHighlightBitmapCapture();

        // If we have a mostly-transparent content background, temporarily bump
        // up the contentBackgroundAlpha so the captured bitmap includes an opaque
        // snapshot of the background.
        if (getStyle("contentBackgroundAlpha") < 0.5)
        {
            /*if (styleDeclaration && styleDeclaration.getStyle("contentBackgroundAlpha") !== null)
                contentBackgroundAlphaSetLocally = true;
            else
                contentBackgroundAlphaSetLocally = false;
            oldContentBackgroundAlpha = getStyle("contentBackgroundAlpha");
            setStyle("contentBackgroundAlpha", 0.5);
            needRedraw = true;*/
        }

        return needRedraw;
    }
	
    /**
     *  @private
     */
	
    /*override*/ public function endHighlightBitmapCapture():Boolean
    {
        var needRedraw:Boolean// = super.endHighlightBitmapCapture();

        /*if (!isNaN(oldContentBackgroundAlpha))
        {
            if (contentBackgroundAlphaSetLocally)
                setStyle("contentBackgroundAlpha", oldContentBackgroundAlpha);
            else
                clearStyle("contentBackgroundAlpha");
            needRedraw = true;
            oldContentBackgroundAlpha = NaN;
        }*/
        
        return needRedraw;
    }
    
}
}
