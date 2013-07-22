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
	import flash.display.Shape;
	import flash.display.SimpleButton;
	
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	public class SliderTrackView implements IBeadView
	{
		public function SliderTrackView()
		{
			hitArea = new Shape();
			upView = new Shape();
			downView = new Shape();
			overView = new Shape();
		}
		
		private function drawView(g:Graphics, bgColor:uint):void
		{
			g.clear();
			g.lineStyle(1,0x000000);
			g.beginFill(bgColor);
			g.drawRect(0, 0, SimpleButton(_strand).width, SimpleButton(_strand).height);
			g.endFill();
		}
		
		private var _strand:IStrand;
		
		private var hitArea:Shape;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			drawView(hitArea.graphics, 0xDD0000);
			drawView(upView.graphics, 0xCCCCCC);
			drawView(downView.graphics, 0x808080);
			drawView(overView.graphics, 0xEEEEEE);
			
			SimpleButton(value).upState = upView;
			SimpleButton(value).downState = downView;
			SimpleButton(value).overState = overView;
			SimpleButton(value).hitTestState = hitArea;
			
			IEventDispatcher(value).addEventListener("widthChanged",sizeChangeHandler);
			IEventDispatcher(value).addEventListener("heightChanged",sizeChangeHandler);
		}
		
		private var upView:Shape;
		private var downView:Shape;
		private var overView:Shape;
		
		private function sizeChangeHandler( event:Event ) : void
		{
			drawView(hitArea.graphics, 0xDD0000);
			drawView(upView.graphics, 0xCCCCCC);
			drawView(downView.graphics, 0x808080);
			drawView(overView.graphics, 0xEEEEEE);
		}
	}
}