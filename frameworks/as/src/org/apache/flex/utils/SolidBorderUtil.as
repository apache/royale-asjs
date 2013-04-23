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
	import flash.display.Graphics;

public class SolidBorderUtil
{
	public static function drawBorder(g:Graphics, x:Number, y:Number, 
									  width:Number, height:Number,
									  color:uint, backgroundColor:Object = null, 
									  thickness:int = 1, alpha:Number = 1.0):void
	{
		g.lineStyle(thickness, color, alpha);
		if (backgroundColor != null)
			g.beginFill(uint(backgroundColor));	
		
		g.drawRect(x, y, width, height);
		if (backgroundColor != null)
			g.endFill();
	}
}
}
