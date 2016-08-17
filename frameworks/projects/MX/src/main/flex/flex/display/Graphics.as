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

package flex.display
{
	import org.apache.flex.svg.CompoundGraphic;
	import org.apache.flex.graphics.SolidColor;
    import org.apache.flex.graphics.PathBuilder;
	
	public class Graphics
	{
		private var host:CompoundGraphic;
		
		public function Graphics(host:CompoundGraphic)
		{
			this.host = host;
		}
		
		public function beginFill(color:uint, alpha:Number = 1.0):void
		{
			var sc:SolidColor = new SolidColor();
			sc.color = color;
			host.fill = sc;
		}
		
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void
		{
			host.drawRect(x, y, width, height);	
		}
		
		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, rx:Number, ry:Number):void
		{
			host.drawRoundRect(x, y, width, height, rx, ry);	
		}
		
		public function clear():void
		{
			host.removeAllElements();
		}
		
		private var lastX:Number = 0;
		private var lastY:Number = 0;
		
		public function moveTo(x:Number, y:Number):void
		{
			lastX = x;
			lastY = y;
		}
		
		public function lineTo(x:Number, y:Number):void
		{
            var path:PathBuilder = new PathBuilder();
            path.moveTo(lastX, lastY);
            path.lineTo(x, y);
			host.drawPathCommands(path);
			lastX = x;
			lastY = y;
		}
		
		public function curveTo(mx:Number, my:Number, x:Number, y:Number):void
		{
            var path:PathBuilder = new PathBuilder();
            path.moveTo(lastX, lastY);
            path.quadraticCurveTo(mx, my, x, y);
			host.drawPathCommands(path);
			lastX = x;
			lastY = y;
		}
		
		public function endFill():void
		{
			// really, we should queue up the drawing commands and execute them here.
		}
	}
}
