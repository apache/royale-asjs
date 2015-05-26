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
package org.apache.flex.html.beads
{
	import flash.display.Graphics;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;

    /**
     *  The SingleLineBorderBead class draws a single line solid border.
     *  The color and thickness can be specified in CSS.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class SingleLineBorderBead implements IBead, IBorderBead, IGraphicsDrawing
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function SingleLineBorderBead()
		{
		}
		
		private var _strand:IStrand;
		
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
            IEventDispatcher(value).addEventListener("layoutNeeded", changeHandler);
            IEventDispatcher(value).addEventListener("heightChanged", changeHandler);
            IEventDispatcher(value).addEventListener("widthChanged", changeHandler);
            IEventDispatcher(value).addEventListener("sizeChanged", changeHandler);
            changeHandler(null);
		}
		        
		private function changeHandler(event:Event):void
		{
			var styleObject:* = ValuesManager.valuesImpl.getValue(_strand,"border-color");
            if (styleObject is String)
            {
                if (styleObject.charAt(0) == "#")
                    styleObject = styleObject.replace("#", "0x");
            }
			var borderColor:Number = Number(styleObject);
			if( isNaN(borderColor) ) borderColor = 0x000000;
			styleObject = ValuesManager.valuesImpl.getValue(_strand,"border-width");
            if (styleObject is String)
                styleObject = styleObject.replace("px", "");
			var borderThickness:Number = Number(styleObject);
			if( isNaN(borderThickness) ) borderThickness = 1;
			
            var host:UIBase = UIBase(_strand);
            var g:Graphics = host.graphics;
            var w:Number = host.clientWidth;
            var h:Number = host.clientHeight;
			
			var gd:IGraphicsDrawing = _strand.getBeadByType(IGraphicsDrawing) as IGraphicsDrawing;
			if( this == gd ) g.clear();
			
			g.lineStyle();
            g.beginFill(borderColor);
            g.drawRect(0, 0, w, h);
            g.drawRect(borderThickness, borderThickness, w-2*borderThickness, h-2*borderThickness);
            g.endFill();
		}
	}
}
