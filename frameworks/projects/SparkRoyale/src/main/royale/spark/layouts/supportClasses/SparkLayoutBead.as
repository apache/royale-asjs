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

package spark.layouts.supportClasses
{
import mx.core.Container;
import mx.core.ILayoutElement;
import mx.core.IVisualElement;
import mx.core.UIComponent;
import mx.core.mx_internal;

import spark.components.supportClasses.GroupBase;
import spark.core.NavigationUnit;

import org.apache.royale.core.IBeadLayout;
import org.apache.royale.core.ILayoutHost;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.LayoutBase;
import org.apache.royale.core.UIBase;
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.utils.MXMLDataInterpreter;
import org.apache.royale.utils.loadBeadFromValuesManager;

use namespace mx_internal;

/**
 *  The SparkLayoutBead class is a layout bead that pumps the Spark 
 *  LayoutBase subclasses.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class SparkLayoutBead extends org.apache.royale.core.LayoutBase
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
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */    
    public function SparkLayoutBead()
    {
        super();
    }

    override public function layout():Boolean
    {
        var n:int = target.numChildren;
        if (n == 0)
            return false;
        
        if (target != host)
        {
            var tlc:UIComponent = host as UIComponent;
            if (!tlc.isWidthSizedToContent() &&
                !tlc.isHeightSizedToContent())
                target.setActualSize(tlc.width, tlc.height);
        }
        
        var w:Number = target.width;
        var h:Number = target.height;
        if (target.isHeightSizedToContent())
            h = target.measuredHeight;
        if (target.isWidthSizedToContent())
            w = target.measuredWidth;
        target.layout.updateDisplayList(w, h);
        
        // update the target's actual size if needed.
        if (target.isWidthSizedToContent() && target.isHeightSizedToContent()) {
            target.setActualSize(target.getExplicitOrMeasuredWidth(), 
                target.getExplicitOrMeasuredHeight());
        }
        else if (target.isWidthSizedToContent())
            target.setWidth(target.getExplicitOrMeasuredWidth());
        else if (target.isHeightSizedToContent())
            target.setHeight(target.getExplicitOrMeasuredHeight());
        
        return true;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    private var _strand:IStrand;
    
    override public function set strand(value:IStrand):void
    {
        _strand = value;
        var host:UIBase = value as UIBase;
        _target = (host.view as ILayoutHost).contentView as GroupBase;
        super.strand = value;
        
    }
    
    private var _target:GroupBase;
    
    public function get target():GroupBase
    {
        return _target;
    }
    
    public function set target(value:GroupBase):void
    {
        _target = value;
    }

}
}
