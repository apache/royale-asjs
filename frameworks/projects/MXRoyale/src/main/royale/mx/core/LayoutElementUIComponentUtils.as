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
package mx.core
{
//import flash.geom.Matrix;
//import flash.geom.Matrix3D;
import org.apache.royale.geom.Point;

//import mx.utils.MatrixUtil;

[ExcludeClass]

/**
 *  @private
 *  Helper class to implement the ILayoutElement interface for IUIComponent
 *  classes.
 */
public class LayoutElementUIComponentUtils
{

//    include "../core/Version.as";

	public function LayoutElementUIComponentUtils()
	{
		
	}
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    // When changing these constants, make sure you change
    // the constants with the same name in UIComponent    
    private static const DEFAULT_MAX_WIDTH:Number = 10000;
    private static const DEFAULT_MAX_HEIGHT:Number = 10000;

    /**
     *  @return Returns the preferred width (untransformed) of the IUIComponent.
     *  Takes into account measured width, explicit width, explicit min width
     *  and explicit max width.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private static function getPreferredUBoundsWidth(obj:IUIComponent):Number
    {
        // explicit trumps measured. measuredWidth should already be
        // constraint between min & max during measure phase.
        var result:Number = obj.getExplicitOrMeasuredWidth();
        /*
        if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
        {
            // We are already taking scale into account from the transform,
            // so adjust here since IUIComponent mixes it with width/height
            result = (obj.scaleX == 0) ? 0 : result / obj.scaleX;
        }
        */
        return result;
    }

    /**
     *  @return Returns the preferred height (untransformed) of the IUIComponent.
     *  Takes into account measured height, explicit height, explicit min height
     *  and explicit max height.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private static function getPreferredUBoundsHeight(obj:IUIComponent):Number
    {
        // explicit trumps measured. measuredWidth should already be
        // constraint between min & max during measure phase. 
        var result:Number = obj.getExplicitOrMeasuredHeight();
        /*
        if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
        {
            // We are already taking scale into account from the transform,
            // so adjust here since IUIComponent mixes it with width/height
            result = (obj.scaleY == 0) ? 0 : result / obj.scaleY;
        }
        */
        return result;
    }
    
    private static function getMinUBoundsWidth(obj:IUIComponent):Number
    {
        // explicit trumps explicitMin trumps measuredMin.
        // measuredMin is restricted by explicitMax.
        var minWidth:Number;
        if (!isNaN(obj.explicitMinWidth))
        {
            minWidth = obj.explicitMinWidth;
        }
        else
        {
            minWidth = isNaN(obj.measuredMinWidth) ? 0 : obj.measuredMinWidth;
            if (!isNaN(obj.explicitMaxWidth))
                minWidth = Math.min(minWidth, obj.explicitMaxWidth);
        }

        /*
        if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
        {
            // We are already taking scale into account from the transform,
            // so adjust here since IUIComponent mixes it with width/height
            minWidth = (obj.scaleX == 0) ? 0 : minWidth / obj.scaleX;
        }
        */
        return minWidth;
    }
    
    private static function getMinUBoundsHeight(obj:IUIComponent):Number
    {
        // explicit trumps explicitMin trumps measuredMin.
        // measuredMin is restricted by explicitMax.
        var minHeight:Number;
        if (!isNaN(obj.explicitMinHeight))
        {
            minHeight = obj.explicitMinHeight;
        }
        else
        {
            minHeight = isNaN(obj.measuredMinHeight) ? 0 : obj.measuredMinHeight;
            if (!isNaN(obj.explicitMaxHeight))
                minHeight = Math.min(minHeight, obj.explicitMaxHeight);
        }

        /*
        if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
        {
            // We are already taking scale into account from the transform,
            // so adjust here since IUIComponent mixes it with width/height
            minHeight = (obj.scaleY == 0) ? 0 : minHeight / obj.scaleY;
        }
        */
        return minHeight;
    }
    
    private static function getMaxUBoundsWidth(obj:IUIComponent):Number
    {
        // explicit trumps explicitMax trumps Number.MAX_VALUE.
        var maxWidth:Number;
        if (!isNaN(obj.explicitMaxWidth))
            maxWidth = obj.explicitMaxWidth;
        else
            maxWidth = DEFAULT_MAX_WIDTH;

        /*
        if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
        {
            // We are already taking scale into account from the transform,
            // so adjust here since IUIComponent mixes it with width/height
            maxWidth = (obj.scaleX == 0) ? 0 : maxWidth / obj.scaleX;
        }
        */
        return maxWidth;
    }
    
    private static function getMaxUBoundsHeight(obj:IUIComponent):Number
    {
        // explicit trumps explicitMax trumps Number.MAX_VALUE.
        var maxHeight:Number;
        if (!isNaN(obj.explicitMaxHeight))
            maxHeight = obj.explicitMaxHeight;
        else
            maxHeight = DEFAULT_MAX_HEIGHT;

        /*
        if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
        {
            // We are already taking scale into account from the transform,
            // so adjust here since IUIComponent mixes it with width/height
            maxHeight = (obj.scaleY == 0) ? 0 : maxHeight / obj.scaleY;
        }
        */
        return maxHeight;
    }
    


    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getPreferredBoundsWidth(obj:IUIComponent/*,transformMatrix:Matrix*/):Number
    {
        var width:Number = getPreferredUBoundsWidth(obj);

        /*
        if (transformMatrix)
        {
			width = MatrixUtil.transformSize(width, getPreferredUBoundsHeight(obj), transformMatrix).x;
        }
        */
        return width;
    }

    public static function getPreferredBoundsHeight(obj:IUIComponent/*,transformMatrix:Matrix*/):Number
    {
        var height:Number = getPreferredUBoundsHeight(obj);

        /*
        if (transformMatrix)
        {
                height = MatrixUtil.transformSize(getPreferredUBoundsWidth(obj), height, transformMatrix).y;
        }
        */
        return height;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getMinBoundsWidth(obj:IUIComponent/*, transformMatrix:Matrix*/):Number
    {
        var width:Number = getMinUBoundsWidth(obj);

        /*
        if (transformMatrix)
        {
			width = MatrixUtil.transformSize(width, getMinUBoundsHeight(obj), transformMatrix).x;
        }
        */

        return width;
    }

    public static function getMinBoundsHeight(obj:IUIComponent/*,transformMatrix:Matrix*/):Number
    {
        var height:Number = getMinUBoundsHeight(obj);

        /*
        if (transformMatrix)
        {
			height = MatrixUtil.transformSize(getMinUBoundsWidth(obj), height, transformMatrix).y;
        }
        */

        return height;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getMaxBoundsWidth(obj:IUIComponent/*, transformMatrix:Matrix*/):Number
    {
        var width:Number = getMaxUBoundsWidth(obj);
        /*
        if (transformMatrix)
        {
			width = MatrixUtil.transformSize(width, getMaxUBoundsHeight(obj), transformMatrix).x;
        }
        */

        return width;
    }

    public static function getMaxBoundsHeight(obj:IUIComponent/*, transformMatrix:Matrix*/):Number
    {
        var height:Number = getMaxUBoundsHeight(obj);
        /*
        if (transformMatrix)
        {
			height = MatrixUtil.transformSize(getMaxUBoundsWidth(obj), height, transformMatrix).y;
        }
        */
        
        return height;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getBoundsXAtSize(obj:IUIComponent, width:Number, height:Number/*, transformMatrix:Matrix*/):Number
    {
        /*if (!transformMatrix)*/
            return obj.x;
        
        /*
        var fitSize:Point = MatrixUtil.fitBounds(width, height, transformMatrix,
                                                 obj.explicitWidth,
                                                 obj.explicitHeight,
                                                 getPreferredUBoundsWidth(obj),
                                                 getPreferredUBoundsHeight(obj),
                                                 getMinUBoundsWidth(obj),
                                                 getMinUBoundsHeight(obj),
                                                 getMaxUBoundsWidth(obj),
                                                 getMaxUBoundsHeight(obj));

        // If we couldn't fit at all, default to the minimum size
        if (!fitSize)
            fitSize = new Point(getMinUBoundsWidth(obj), getMinUBoundsHeight(obj));
            
        var pos:Point = new Point();
        MatrixUtil.transformBounds(fitSize.x, fitSize.y,
                                   transformMatrix,
                                   pos);
        return pos.x;
        */
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getBoundsYAtSize(obj:IUIComponent, width:Number, height:Number/*, transformMatrix:Matrix*/):Number
    {
        /*if (!transformMatrix)*/
            return obj.y;
        
        /*
        var fitSize:Point = MatrixUtil.fitBounds(width, height, transformMatrix,
                                                 obj.explicitWidth,
                                                 obj.explicitHeight,
                                                 getPreferredUBoundsWidth(obj),
                                                 getPreferredUBoundsHeight(obj),
                                                 getMinUBoundsWidth(obj),
                                                 getMinUBoundsHeight(obj),
                                                 getMaxUBoundsWidth(obj),
                                                 getMaxUBoundsHeight(obj));

        // If we couldn't fit at all, default to the minimum size
        if (!fitSize)
            fitSize = new Point(getMinUBoundsWidth(obj), getMinUBoundsHeight(obj));
            
        var pos:Point = new Point();
        MatrixUtil.transformBounds(fitSize.x, fitSize.y,
                                   transformMatrix,
                                   pos);
        return pos.y;
        */
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getLayoutBoundsWidth(obj:IUIComponent/*,transformMatrix:Matrix*/):Number
    {
        var width:Number = obj.width;
        /*
        if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
        {
            // We are already taking scale into account from the transform,
            // so adjust here since IUIComponent mixes it with width/height
            width = (obj.scaleX == 0) ? 0 : width / obj.scaleX;
        }

        if (transformMatrix)
        {
            var height:Number = obj.height;
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
            {
                // We are already taking scale into account from the transform,
                // so adjust here since IUIComponent mixes it with width/height
                height = (obj.scaleY == 0) ? 0 : height / obj.scaleY;
            }
            
            // By default the IUIComponent's registration point is the same
            // as its untransformed border top-left corner, which is (0,0).
            width = MatrixUtil.transformBounds(width, height,
                                               transformMatrix,
                                               new Point()).x;
        }
        */
        return width;
    }

    public static function getLayoutBoundsHeight(obj:IUIComponent/*,transformMatrix:Matrix*/):Number
    {
        var height:Number = obj.height;
        /*
        if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
        {
            // We are already taking scale into account from the transform,
            // so adjust here since IUIComponent mixes it with width/height
            height = (obj.scaleY == 0) ? 0 : height / obj.scaleY;
        }

        if (transformMatrix)
        {
            var width:Number = obj.width;
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
            {
                // We are already taking scale into account from the transform,
                // so adjust here since IUIComponent mixes it with width/height
                width = (obj.scaleX == 0) ? 0 : width / obj.scaleX;
            }
            
            // By default the IUIComponent's registration point is the same
            // as its untransformed border top-left corner, which is (0,0).
            height = MatrixUtil.transformBounds(width, height,
                                                transformMatrix,
                                                new Point()).y;
        }
        */
        return height;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getLayoutBoundsX(obj:IUIComponent/*,transformMatrix:Matrix*/):Number
    {
        /*if (transformMatrix == null)*/
            return obj.x;


        /*
        var width:Number = obj.width;
        var height:Number = obj.height;

        if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
        {
            width = (obj.scaleX == 0) ? 0 : width / obj.scaleX;
            height = (obj.scaleY == 0) ? 0 : height / obj.scaleY;
        }
        
		// We are already taking scale into account from the transform,
		// so adjust here since IUIComponent mixes it with width/height
		var pos:Point = new Point();
		MatrixUtil.transformBounds(width, height,
                            	   transformMatrix,
                            	   pos);
        return pos.x;
        */
    }

    public static function getLayoutBoundsY(obj:IUIComponent/*,transformMatrix:Matrix*/):Number
    {
        /*if (transformMatrix == null)*/
            return obj.y;

        /*
        var width:Number = obj.width;
        var height:Number = obj.height;

        if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
        {
            width = (obj.scaleX == 0) ? 0 : width / obj.scaleX;
            height = (obj.scaleY == 0) ? 0 : height / obj.scaleY;
        }
        
        // We are already taking scale into account from the transform,
        // so adjust here since IUIComponent mixes it with width/height
        var pos:Point = new Point();
        MatrixUtil.transformBounds(width, height,
                                   transformMatrix,
                                   pos);
        return pos.y;
        */
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function setLayoutBoundsPosition(obj:IUIComponent,x:Number, y:Number/*, transformMatrix:Matrix*/):void
    {
        /*
        if (transformMatrix)
        {
            //race("Setting actual position to " + x + "," + y);
            //race("\tcurrent x/y is " + obj.x + "," + obj.y); 
            //race("\tcurrent actual position is " + actualPosition.x + "," + actualPosition.y);
            x = x - getLayoutBoundsX(obj,transformMatrix) + obj.x;
            y = y - getLayoutBoundsY(obj,transformMatrix) + obj.y;
        }
        */
        COMPILE::JS
        {
            obj.element.style.position = "absolute";
        }
        obj.move(x, y);
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function setLayoutBoundsSize(obj:IUIComponent,width:Number,
                                               height:Number/*,
                                               transformMatrix:Matrix*/):void
    {
        /*
        if (!transformMatrix)
        {*/
            if (isNaN(width))
                width = getPreferredUBoundsWidth(obj);
            if (isNaN(height))
                height = getPreferredUBoundsHeight(obj);
    
            /*
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
            {
                // We are already taking scale into account from the transform,
                // so adjust here since IUIComponent mixes it with width/height
                width *= obj.scaleX;
                height *= obj.scaleY;
            }
            */
            obj.setActualSize(width, height);
            return;
        /*}

        var fitSize:Point = MatrixUtil.fitBounds(width, height, transformMatrix,
                                                 obj.explicitWidth,
                                                 obj.explicitHeight,
                                                 getPreferredUBoundsWidth(obj),
                                                 getPreferredUBoundsHeight(obj),
                                                 getMinUBoundsWidth(obj),
                                                 getMinUBoundsHeight(obj),
                                                 getMaxUBoundsWidth(obj),
                                                 getMaxUBoundsHeight(obj));

        // If we couldn't fit at all, default to the minimum size
        if (!fitSize)
            fitSize = new Point(getMinUBoundsWidth(obj), getMinUBoundsHeight(obj));

        if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
        {
            // We are already taking scale into account from the transform,
            // so adjust here since IUIComponent mixes it with width/height
            obj.setActualSize(fitSize.x * obj.scaleX, fitSize.y * obj.scaleY);
        }
        else
            obj.setActualSize(fitSize.x, fitSize.y);
        */
    }
}
}
