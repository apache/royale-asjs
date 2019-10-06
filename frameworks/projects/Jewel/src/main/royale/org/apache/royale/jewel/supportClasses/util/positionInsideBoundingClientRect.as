////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "Licens"); you may not use this file except in compliance with
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
package org.apache.royale.jewel.supportClasses.util
{
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.geom.Point;
    import org.apache.royale.utils.PointUtils;

    /**
     *  Determines the position of the popUp related to a point to avoid
     *  the component get partialy out of sight.
     * 
     *  Ensure the popup has width before performing this operation to work properly
     *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
     * 
     *  @royaleignorecoercion org.apache.royale.core.IUIBase 
     */
    public function positionInsideBoundingClientRect(_strand:IStrand, popUp:IUIBase, point:Point):Point
    {
        var outerWidth:Number;
        var outerHeight:Number;

        COMPILE::JS
        {
            outerWidth = document.body.getBoundingClientRect().width;
            outerHeight = document.body.getBoundingClientRect().height;
        }

        var popUpWidth:Number = popUp.width;
        var popUpHeight:Number = popUp.height;
        
        point = PointUtils.localToGlobal(point, _strand);
        //make sure it's not too high or to the left.
        point.x = Math.max(point.x,0);
        point.y = Math.max(point.y,0);

        // add an extra pixel for rounding errors
        var extraHeight:Number = 1 + point.y + popUpHeight - outerHeight;
        if(extraHeight > 0)
        {
            point.y -= extraHeight;
        }
        var extraWidth:Number = 1 + point.x + popUpWidth - outerWidth;
        if(extraWidth > 0)
        {
            point.x -= extraWidth;
        }
        return point;
    }
}
