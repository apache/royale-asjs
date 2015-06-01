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
		
		var result:UIMetrics = new UIMetrics();
		result.top = borderOffset + pt;
		result.left = borderOffset + pl;
		result.bottom = borderOffset + pb;
		result.right = borderOffset + pr;
		
		return result;
	}
}
}