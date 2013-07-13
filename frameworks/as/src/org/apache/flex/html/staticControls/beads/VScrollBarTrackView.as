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
package org.apache.flex.html.staticControls.beads
{
	import flash.display.Graphics;
	import flash.display.SimpleButton;
	import flash.display.Shape;
	
    import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	
	public class VScrollBarTrackView implements IBeadView
	{
		public function VScrollBarTrackView()
		{
			upView = new Shape();
			downView = new Shape();
			overView = new Shape();

		}
		
		private function drawView(g:Graphics, bgColor:uint, h:Number):void
		{
			g.clear();
			g.lineStyle(1);
			g.beginFill(bgColor);
			g.drawRect(0, 0, 16, h);
			g.endFill();
			g.lineStyle(0);
		}

		private function heightChangeHandler(event:Event):void
		{
			var h:Number = SimpleButton(_strand).height;
			
			drawView(upView.graphics, 0xCCCCCC, h);
			drawView(downView.graphics, 0x808080, h);
			drawView(overView.graphics, 0xEEEEEE, h);	
			shape.graphics.clear();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, 16, h);
			shape.graphics.endFill();
			
		}
		
		private var _strand:IStrand;
		
		private var shape:Shape;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			SimpleButton(value).addEventListener("heightChanged", heightChangeHandler);
			shape = new Shape();
			SimpleButton(value).upState = upView;
			SimpleButton(value).downState = downView;
			SimpleButton(value).overState = overView;
			SimpleButton(value).hitTestState = shape;
		}
				
		private var upView:Shape;
		private var downView:Shape;
		private var overView:Shape;
		
	}
}