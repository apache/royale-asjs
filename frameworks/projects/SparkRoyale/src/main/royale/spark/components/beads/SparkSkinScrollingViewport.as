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

package spark.components.beads
{

import mx.core.mx_internal;
use namespace mx_internal;

import spark.components.supportClasses.GroupBase;
import spark.components.supportClasses.SkinnableComponent;

import org.apache.royale.core.IBead;
import org.apache.royale.core.IContentView;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.IUIBase;
import org.apache.royale.core.IViewport;
import org.apache.royale.core.UIBase;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.geom.Size;

COMPILE::SWF
{
    import flash.geom.Rectangle;
}

/**
 *  @private
 *  The viewport that loads a Spark Skin.
 */
public class SparkSkinScrollingViewport implements IViewport
{
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
	public function SparkSkinScrollingViewport()
	{
		super();
	}

    protected var contentArea:UIBase;
    
    /**
     * Get the actual parent of the container's content.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get contentView():IUIBase
    {
        return contentArea;
    }
    
    protected var host:SkinnableComponent;
    
    /**
     */
    public function set strand(value:IStrand):void
    {
        host = value as SkinnableComponent;
        
        var c:Class = ValuesManager.valuesImpl.getValue(value, "skinClass") as Class;
        host.setSkin(new c());
        
        contentArea = host.skin["contentGroup"];
        
        COMPILE::JS
        {
            setScrollStyle();
        }
        
    }
    
    /**
     * Subclasses override this method to change scrolling behavior
     */
    COMPILE::JS
    protected function setScrollStyle():void
    {
        contentArea.element.style.overflow = "auto";
    }
    
    /**
     * @copy org.apache.royale.core.IViewport#setPosition()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function setPosition(x:Number, y:Number):void
    {
        COMPILE::SWF {
            contentArea.x = x;
            contentArea.y = y;
        }
    }
    
    /**
     * @copy org.apache.royale.core.IViewport#layoutViewportBeforeContentLayout()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function layoutViewportBeforeContentLayout(width:Number, height:Number):void
    {
        COMPILE::SWF {
            if (!isNaN(width))
                contentArea.width = width;
            if (!isNaN(height))
                contentArea.height = height;
        }
    }
    
    /**
     * @copy org.apache.royale.core.IViewport#layoutViewportAfterContentLayout()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function layoutViewportAfterContentLayout(contentSize:Size):void
    {
        COMPILE::SWF {
            var hostWidth:Number = UIBase(host).width;
            var hostHeight:Number = UIBase(host).height;
            
            var rect:flash.geom.Rectangle = new flash.geom.Rectangle(0, 0, hostWidth, hostHeight);
            contentArea.scrollRect = rect;
            
            return;
        }
    }
}

}
