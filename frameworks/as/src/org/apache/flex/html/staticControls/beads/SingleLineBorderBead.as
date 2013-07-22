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
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;

	public class SingleLineBorderBead implements IBead, IBorderBead, IGraphicsDrawing
	{
		public function SingleLineBorderBead()
		{
		}
		
		private var _strand:IStrand;
		
		public function get strand():IStrand
		{
			return _strand;
		}
		public function set strand(value:IStrand):void
		{
			_strand = value;
            IEventDispatcher(value).addEventListener("heightChanged", changeHandler);
            IEventDispatcher(value).addEventListener("widthChanged", changeHandler);
		}
		        
		private function changeHandler(event:Event):void
		{
			var styleObject:* = ValuesManager.valuesImpl.getValue(_strand,"border-color");
			var borderColor:Number = Number(styleObject);
			if( isNaN(borderColor) ) borderColor = 0x000000;
			styleObject = ValuesManager.valuesImpl.getValue(_strand,"border-thickness");
			var borderThickness:Number = Number(styleObject);
			if( isNaN(borderThickness) ) borderThickness = 1;
			
            var host:UIBase = UIBase(_strand);
            var g:Graphics = host.graphics;
            var w:Number = host.width;
            var h:Number = host.height;
			
			var gd:IGraphicsDrawing = strand.getBeadByType(IGraphicsDrawing) as IGraphicsDrawing;
			if( this == gd ) g.clear();
			
			g.lineStyle();
            g.beginFill(borderColor);
            g.drawRect(0, 0, w, h);
            g.drawRect(borderThickness, borderThickness, w-2*borderThickness, h-2*borderThickness);
            g.endFill();
		}
	}
}