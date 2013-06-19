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
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.UIMetrics;
	import org.apache.flex.core.ValuesManager;

public class BeadMetrics
{
	
	public static function getMetrics(strand:IStrand) : UIMetrics
	{
		var borderThickness:Object = ValuesManager.valuesImpl.getValue(strand,"border-thickness");
		var borderOffset:Number;
		if( borderThickness == null ) {
			borderOffset = 0;
		}
		else {
			borderOffset = Number(borderThickness);
			if( isNaN(borderOffset) ) borderOffset = 0;
		}
		
		var result:UIMetrics = new UIMetrics();
		result.x = borderOffset;
		result.y = borderOffset;
		result.width = UIBase(strand).width - 2*borderOffset;
		result.height = UIBase(strand).height - 2*borderOffset;
		
		return result;
	}
}
}