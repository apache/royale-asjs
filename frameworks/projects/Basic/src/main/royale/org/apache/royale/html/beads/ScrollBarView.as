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
package org.apache.royale.html.beads
{
	import flash.display.DisplayObject;
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IScrollBarModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.Strand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.Button;
	import org.apache.royale.html.beads.controllers.ButtonAutoRepeatController;
	import org.apache.royale.utils.loadBeadFromValuesManager;

    /**
     *  The ScrollBarView class is the default view for
     *  the org.apache.royale.html.supportClasses.ScrollBar class.
     *  It implements the classic desktop-like ScrollBar.
     *  A different view would implement more modern scrollbars that hide themselves
     *  until hovered over with the mouse.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ScrollBarView extends Strand implements IBeadView, IStrand, IScrollBarView
	{
		public static const FullSize:int = 12;
		public static const ThreeQuarterSize:int = 9;
		public static const HalfSize:int = 6;
		public static const ThirdSize:int = 4;
		public static const QuarterSize:int = 3;
		
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ScrollBarView()
		{
		}
				
		protected var sbModel:IScrollBarModel;
		
		protected var _strand:IStrand;
		
        /**
         *  The layout. 
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected var layout:IBeadLayout;
        
        /**
         *  The host component. 
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get host():IUIBase
        {
            return _strand as IUIBase;
        }

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
            
            for each (var bead:IBead in beads)
                addBead(bead);
                        
			sbModel = value.getBeadByType(IScrollBarModel) as IScrollBarModel;
            sbModel.addEventListener("maximumChange", changeHandler);
            sbModel.addEventListener("minimumChange", changeHandler);
            sbModel.addEventListener("snapIntervalChange", changeHandler);
            sbModel.addEventListener("stepSizeChange", changeHandler);
            sbModel.addEventListener("pageSizeChange", changeHandler);
            sbModel.addEventListener("valueChange", changeHandler);
            
			layout = loadBeadFromValuesManager(IBeadLayout, "iBeadLayout", _strand) as IBeadLayout;
		}
						
        protected function changeHandler(event:Event):void
        {
            layout.layout();    
        }
        
		protected var _decrement:Button;
		protected var _increment:Button;
		protected var _track:Button;
		protected var _thumb:Button;
		
        /**
         *  @copy org.apache.royale.html.beads.IScrollBarView#decrement
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get decrement():Button
		{
			return _decrement;
		}

        /**
         *  @copy org.apache.royale.html.beads.IScrollBarView#increment
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get increment():Button
		{
			return _increment;
		}
        
        /**
         *  @copy org.apache.royale.html.beads.IScrollBarView#track
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get track():Button
		{
			return _track;
		}
        
        /**
         *  @copy org.apache.royale.html.beads.IScrollBarView#thumb
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get thumb():Button
		{
			return _thumb;
		}
		
        /**
         *  @copy org.apache.royale.core.IBeadView#viewHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get viewHeight():Number
        {
            // don't want to put $height in an interface
            return _strand["$height"];
        }
        
        /**
         *  @copy org.apache.royale.core.IBeadView#viewWidth
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get viewWidth():Number
        {
            // don't want to put $width in an interface
            return _strand["$width"];
        }
	}
}
