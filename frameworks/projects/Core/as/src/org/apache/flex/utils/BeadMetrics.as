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
package org.apache.flex.utils
{
import org.apache.flex.core.UIMetrics;
import org.apache.flex.core.ValuesManager;

/**
 *  The BeadMetrics class is a utility class that computes the offset of the content
 *  in a container based on border-thickness and padding styles.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion FlexJS 0.0
 */
public class BeadMetrics
{
	
    /**
     *  Compute the offset of the content
     *  in a container based on border-thickness and padding styles.  
     *  
     *  @param object The object with style values.
     *  @return The offsets of the content.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public static function getMetrics(object:Object) : UIMetrics
	{
		var borderThickness:Object = ValuesManager.valuesImpl.getValue(object,"border-width");
		var borderOffset:Number;
		if( borderThickness == null ) 
        {
            borderThickness = ValuesManager.valuesImpl.getValue(object,"border");
            if (borderThickness != null)
            {
                if (borderThickness is Array)
                    borderOffset = CSSUtils.toNumber(borderThickness[0], object.width);
                else
                    borderOffset = CSSUtils.toNumber(borderThickness as String, object.width);
            }
            else
                borderOffset = 0;
		}
		else {
			borderOffset = Number(borderThickness);
			if( isNaN(borderOffset) ) borderOffset = 0;
		}
		
		var paddingLeft:Object;
		var paddingTop:Object;
		var paddingRight:Object;
		var paddingBottom:Object;
		
		var padding:Object = ValuesManager.valuesImpl.getValue(object, "padding");
		paddingLeft = ValuesManager.valuesImpl.getValue(object, "padding-left");
		paddingTop = ValuesManager.valuesImpl.getValue(object, "padding-top");
		paddingRight = ValuesManager.valuesImpl.getValue(object, "padding-right");
		paddingBottom = ValuesManager.valuesImpl.getValue(object, "padding-bottom");
		var pl:Number = CSSUtils.getLeftValue(paddingLeft, padding, object.width);
		var pt:Number = CSSUtils.getTopValue(paddingTop, padding, object.height);
		var pr:Number = CSSUtils.getRightValue(paddingRight, padding, object.width);
		var pb:Number = CSSUtils.getBottomValue(paddingBottom, padding, object.height);
		
		var marginLeft:Object;
		var marginRight:Object;
		var marginTop:Object;
		var marginBottom:Object;
		var margin:Object;
		margin = ValuesManager.valuesImpl.getValue(object, "margin");
		marginLeft = ValuesManager.valuesImpl.getValue(object, "margin-left");
		marginTop = ValuesManager.valuesImpl.getValue(object, "margin-top");
		marginRight = ValuesManager.valuesImpl.getValue(object, "margin-right");
		marginBottom = ValuesManager.valuesImpl.getValue(object, "margin-bottom");
		var ml:Number;
		var mr:Number;
		var mt:Number;
		var mb:Number;
		var lastmr:Number;
		if (marginLeft == "auto")
			ml = 0;
		else
        {
            ml = CSSUtils.getLeftValue(marginLeft, margin, object.width);
            if (isNaN(ml))
                ml = 0;
        }
		if (marginRight == "auto")
			mr = 0;
		else
        {
            mr = CSSUtils.getRightValue(marginRight, margin, object.width);
            if (isNaN(mr))
                mr = 0;
        }
		mt = CSSUtils.getTopValue(marginTop, margin, object.height);
		if (isNaN(mt))
			mt = 0;
        mb = CSSUtils.getBottomValue(marginBottom, margin, object.height);
		if (isNaN(mb))
			mb = 0;
		
        borderOffset *= 2; // border on each side
		var result:UIMetrics = new UIMetrics();
		result.top = borderOffset + pt;
		result.left = borderOffset + pl;
		result.bottom = borderOffset + pb;
		result.right = borderOffset + pr;
		result.marginTop = mt;
		result.marginLeft = ml;
		result.marginBottom = mb;
		result.marginRight = mr;
		
		return result;
	}
}
}