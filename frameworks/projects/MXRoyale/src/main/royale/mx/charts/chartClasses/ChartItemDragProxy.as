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

import org.apache.royale.reflection.getDefinitionByName;
import org.apache.royale.reflection.getQualifiedClassName;

import mx.charts.ChartItem;
import mx.core.IDataRenderer;
import mx.core.IFlexDisplayObject;
//import mx.core.LayoutDirection;
import mx.core.UIComponent;
import mx.core.mx_internal;

use namespace mx_internal;

/**
 *  The default drag proxy used when dragging items from a chart control.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ChartItemDragProxy extends UIComponent
{
//    include "../../core/Version.as";

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
    public function ChartItemDragProxy()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

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
        
        var items:Array /* of uint */ = ChartBase(owner).selectedChartItems;

        var n:int = items.length;
        for (var i:int = 0; i < n; i++)
        {
            var src:UIComponent;
            src = items[i].itemRenderer;
            
            if (!src)
                continue;

            var o:ChartItem;
            var className:String;
            var obj:Object;
            var classRef:Class;
            
            o = items[i].clone();
            className = getQualifiedClassName(o.itemRenderer);
            classRef = getDefinitionByName(className) as Class;
            obj = new classRef();
            obj.data = IDataRenderer(o.itemRenderer).data;
            
            if ((o.itemRenderer as Object).hasOwnProperty('styleName'))
                obj.styleName = Object(o.itemRenderer).styleName;
            o.itemRenderer = IFlexDisplayObject(obj);
            
            addChild(UIComponent(o.itemRenderer));
            
            o.itemRenderer.setActualSize(src.width,src.height);
            o.itemRenderer.x = src.x;
            o.itemRenderer.y = src.y;

            measuredHeight = Math.max(measuredHeight, o.itemRenderer.y + o.itemRenderer.height);
            measuredWidth = Math.max(measuredWidth, o.itemRenderer.x + o.itemRenderer.width);
            /*
			if(ChartBase(owner).layoutDirection == LayoutDirection.RTL)
				layoutDirection = LayoutDirection.RTL;
            */
        }

        invalidateDisplayList();
    }
}

}
