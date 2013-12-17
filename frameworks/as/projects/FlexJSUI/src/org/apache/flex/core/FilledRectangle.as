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
package org.apache.flex.core
{
	import flash.display.Shape;
	
	import org.apache.flex.core.UIBase;
	
	public class FilledRectangle extends UIBase
	{
		public function FilledRectangle()
		{
			super();
			
			_shape = new flash.display.Shape();
			this.addElement(_shape);
		}
		
		private var _shape:flash.display.Shape;
		
		private var _fillColor:uint = 0x000000;
		public function get fillColor():uint
		{
			return _fillColor;
		}
		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}
		
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void
		{
			_shape.graphics.clear();
			_shape.graphics.beginFill(_fillColor);
			_shape.graphics.drawRect(x, y, width, height);
			_shape.graphics.endFill();
		}
	}
}