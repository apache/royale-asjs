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
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.events.Event;
	import org.apache.royale.html.Button;
	import org.apache.royale.html.beads.controllers.ButtonAutoRepeatController;

    /**
     *  The ScrollBarView class is the default view for
     *  the org.apache.royale.html.supportClasses.VScrollBar class.
     *  It implements the classic desktop-like VScrollBar.
     *  A different view would implement more modern scrollbars that hide themselves
     *  until hovered over with the mouse.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class VScrollBarView extends ScrollBarView implements IBeadView, IStrand, IScrollBarView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function VScrollBarView()
		{
		}

        /**
         *  The default step size for up and down arrows as a divisor
         *  to the height of the scroll bar.  In other words, if
         *  STEP_RATE is set to 20, then it will take 20 clicks on
         *  the thumb to move the bottom of the screen to the top.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public static var STEP_RATE:int = 20;
        
        override protected function changeHandler(event:Event):void
        {
        	layout.layout();
        	sbModel = host.getBeadByType(IScrollBarModel) as IScrollBarModel;
        	sbModel.stepSize = Math.max(Math.round(host.height / STEP_RATE), 1);
        }            

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			UIBase(value).setWidth(ScrollBarView.FullSize, true);
            
            // TODO: (aharui) put in values impl
			_increment = new Button();
			Button(_increment).addBead(new DownArrowButtonView());
            Button(_increment).addBead(new ButtonAutoRepeatController());
			_decrement = new Button();
			Button(_decrement).addBead(new UpArrowButtonView());
            Button(_decrement).addBead(new ButtonAutoRepeatController());
			_track = new Button();				
			Button(_track).addBead(new VScrollBarTrackView());
			_thumb = new Button();				
			Button(_thumb).addBead(new VScrollBarThumbView());
            
            UIBase(value).$sprite_addChild(_decrement);
            UIBase(value).$sprite_addChild(_increment);
            UIBase(value).$sprite_addChild(_track);
            UIBase(value).$sprite_addChild(_thumb);
            
            IEventDispatcher(_strand).addEventListener("heightChanged", changeHandler);
            
			layout.layout();
		}
	}
}
