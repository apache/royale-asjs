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
    import flash.display.Sprite;
	import flash.display.Graphics;
	
	import org.apache.flex.core.IBead;
    import org.apache.flex.core.IBeadView;
    import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;

    /**
     *  The SolidBackgroundBead class draws a solid filled background.
     *  The color and opacity can be specified in CSS.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class SolidBackgroundBead implements IBead, IBackgroundBead, IGraphicsDrawing
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function SolidBackgroundBead()
		{
		}
				
		private var _strand:IStrand;
		
        private var host:IUIBase;
        
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
            if (value is IUIBase)
                host = IUIBase(value);
            else if (value is IBeadView)
                host = IUIBase(IBeadView(value).host);
            
            IEventDispatcher(host).addEventListener("heightChanged", changeHandler);
            IEventDispatcher(host).addEventListener("widthChanged", changeHandler);
			IEventDispatcher(host).addEventListener("sizeChanged", changeHandler);
			IEventDispatcher(host).addEventListener("initComplete", changeHandler);
			
			var bgColor:Object = ValuesManager.valuesImpl.getValue(host, "background-color");
			if( bgColor != null ) {
				backgroundColor = ValuesManager.valuesImpl.convertColor(bgColor);
			}
			
			var bgAlpha:Object = ValuesManager.valuesImpl.getValue(host, "opacity");
			if( bgAlpha != null ) {
				opacity = Number(bgAlpha);
			}
            
            var corner:Object = ValuesManager.valuesImpl.getValue(host, "border-radius");
            if( corner != null ) {
                borderRadius = Number(corner);
            }
            
            changeHandler(null);
		}
		
		private var _backgroundColor:uint;
		
        /**
         *  The background color
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
        
        /**
         *  @private
         */
		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			if (_strand)
				changeHandler(null);
		}
		
		private var _opacity:Number = 1.0;
		
        /**
         *  The opacity (alpha).
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get opacity():Number
		{
			return _opacity;
		}
		
        /**
         *  @private
         */
		public function set opacity(value:Number):void
		{
			_opacity = value;
			if( _strand )
				changeHandler(null);
		}
		
        private var _borderRadius:Number;
        
        /**
         *  The opacity (alpha).
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get borderRadius():Number
        {
            return _borderRadius;
        }
        
        /**
         *  @private
         */
        public function set borderRadius(value:Number):void
        {
            _borderRadius = value;
            if( _strand )
                changeHandler(null);
        }
        
		private function changeHandler(event:Event):void
		{
            var g:Graphics = Sprite(host).graphics;
            var w:Number = host.width;
            var h:Number = host.height;
			
			var gd:IGraphicsDrawing = _strand.getBeadByType(IGraphicsDrawing) as IGraphicsDrawing;
			if( this == gd ) g.clear();

            g.beginFill(backgroundColor,opacity);
            if (isNaN(borderRadius))
                g.drawRect(0, 0, w, h);
            else
                g.drawRoundRect(0, 0, w, h, borderRadius);
            g.endFill();
		}
	}
}
