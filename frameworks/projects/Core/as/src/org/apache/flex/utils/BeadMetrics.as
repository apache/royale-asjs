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
		var borderThickness:Object = ValuesManager.valuesImpl.getValue(object,"border-thickness");
		var borderOffset:Number;
		if( borderThickness == null ) {
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
		if (padding is Array)
		{
			if (padding.length == 1)
				paddingLeft = paddingTop = padding[0];
			else if (padding.length <= 3)
			{
				paddingTop = padding[0];
				paddingLeft = padding[1];
				paddingBottom = padding[0];
				paddingRight = padding[1];
			}
			else if (padding.length == 4)
			{
				paddingTop = padding[0];
				paddingLeft = padding[1];
				paddingBottom = padding[2];
				paddingRight = padding[3];					
			}
		}
		else if (padding == null)
		{
			paddingLeft = ValuesManager.valuesImpl.getValue(object, "padding-left");
			paddingTop = ValuesManager.valuesImpl.getValue(object, "padding-top");
			paddingRight = ValuesManager.valuesImpl.getValue(object, "padding-right");
			paddingBottom = ValuesManager.valuesImpl.getValue(object, "padding-bottom");
		}
		else
		{
			paddingLeft = paddingTop = padding;
			paddingRight = paddingBottom = padding;
		}
		var pl:Number = Number(paddingLeft);
		var pt:Number = Number(paddingTop);
		var pr:Number = Number(paddingRight);
		var pb:Number = Number(paddingBottom);
		
		var marginLeft:Object;
		var marginRight:Object;
		var marginTop:Object;
		var marginBottom:Object;
		var margin:Object;
		margin = ValuesManager.valuesImpl.getValue(object, "margin");
		
		if (margin is Array)
		{
			if (margin.length == 1)
				marginLeft = marginTop = marginRight = marginBottom = margin[0];
			else if (margin.length <= 3)
			{
				marginLeft = marginRight = margin[1];
				marginTop = marginBottom = margin[0];
			}
			else if (margin.length == 4)
			{
				marginLeft = margin[3];
				marginBottom = margin[2];
				marginRight = margin[1];
				marginTop = margin[0];					
			}
		}
		else if (margin == null)
		{
			marginLeft = ValuesManager.valuesImpl.getValue(object, "margin-left");
			marginTop = ValuesManager.valuesImpl.getValue(object, "margin-top");
			marginRight = ValuesManager.valuesImpl.getValue(object, "margin-right");
			marginBottom = ValuesManager.valuesImpl.getValue(object, "margin-bottom");
		}
		else
		{
			marginLeft = marginTop = marginBottom = marginRight = margin;
		}
		var ml:Number;
		var mr:Number;
		var mt:Number;
		var mb:Number;
		var lastmr:Number;
		if (marginLeft == "auto")
			ml = 0;
		else
		{
			ml = Number(marginLeft);
			if (isNaN(ml))
				ml = 0;
		}
		if (marginRight == "auto")
			mr = 0;
		else
		{
			mr = Number(marginRight);
			if (isNaN(mr))
				mr = 0;
		}
		mt = Number(marginTop);
		if (isNaN(mt))
			mt = 0;
		mb = Number(marginBottom);
		if (isNaN(mb))
			mb = 0;
		
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