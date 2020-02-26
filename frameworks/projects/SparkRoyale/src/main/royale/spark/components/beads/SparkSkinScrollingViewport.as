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
import org.apache.royale.core.IScrollingViewport;
import org.apache.royale.core.UIBase;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.geom.Size;
import spark.components.SkinnableContainer;

COMPILE::SWF
{
    import flash.geom.Rectangle;
}

/**
 *  @private
 *  The viewport that loads a Spark Skin.
 */
public class SparkSkinScrollingViewport extends SparkSkinViewport implements IScrollingViewport
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

    override protected function initCompleteHandler(event:Event):void
    {
		super.initCompleteHandler(event);
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
    
    COMPILE::SWF
    protected var _verticalScrollPosition:Number = 0;
    
    public function get verticalScrollPosition():Number
    {
        COMPILE::JS
        {
            return contentArea.element.scrollTop;
        }
        COMPILE::SWF
        {
            return _verticalScrollPosition;
        }
    }
    public function set verticalScrollPosition(value:Number):void
    {
        COMPILE::JS
        {
            contentArea.element.scrollTop = value;
        }
        COMPILE::SWF
        {
            _verticalScrollPosition = value;
            dispatchEvent(new Event("verticalScrollPositionChanged"));
            // handleVerticalScrollChange();  figure out how to re-use from ScrollingViewport
            // given we need different timing (waiting on initComplete)
        }
    }

    COMPILE::SWF
    protected var _horizontalScrollPosition:Number = 0;
    
    public function get horizontalScrollPosition():Number
    {
        COMPILE::JS
        {
            return contentArea.element.scrollLeft;
        }
        COMPILE::SWF
        {
            return _horizontalScrollPosition;
        }
    }
    
    public function set horizontalScrollPosition(value:Number):void
    {
        COMPILE::JS
        {
           contentArea.element.scrollLeft = value;
        }
        COMPILE::SWF
        {
            _horizontalScrollPosition = value;
            dispatchEvent(new Event("horizontalScrollPositionChanged"));
            // handleHorizontalScrollChange();     figure out how to re-use from ScrollingViewport
            // given we need different timing (waiting on initComplete)         
        }
    }

}

}
