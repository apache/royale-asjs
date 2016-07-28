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
	import flash.display.DisplayObject;
	
    import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IScrollBarModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.Strand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
    import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.events.Event;
	import org.apache.flex.html.Button;
	import org.apache.flex.html.beads.controllers.ButtonAutoRepeatController;

    /**
     *  The HScrollBarView class is the default view for
     *  the org.apache.flex.html.supportClasses.HScrollBar class.
     *  It implements the classic desktop-like HScrollBar.
     *  A different view would implement more modern scrollbars that hide themselves
     *  until hovered over with the mouse.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class HScrollBarView extends ScrollBarView implements IBeadView, IStrand, IScrollBarView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function HScrollBarView()
		{
		}

        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
            var v:UIBase = UIBase(value);
			v.setHeight(ScrollBarView.FullSize, true);
            
            // TODO: (aharui) put in values impl
			_increment = new Button();
            var i:Button = _increment;
			i.addBead(new RightArrowButtonView());
            i.addBead(new ButtonAutoRepeatController());
			_decrement = new Button();
            var d:Button = _decrement;
			d.addBead(new LeftArrowButtonView());
            d.addBead(new ButtonAutoRepeatController());
			_track = new Button();
            var tr:Button = _track;
			tr.addBead(new HScrollBarTrackView());
			_thumb = new Button();
            var th:Button = _thumb;
			th.addBead(new HScrollBarThumbView());
            
            v.$sprite.addChild(d.$button);
            v.$sprite.addChild(i.$button);
            v.$sprite.addChild(tr.$button);
            v.$sprite.addChild(th.$button);
            
            IEventDispatcher(_strand).addEventListener("widthChanged", changeHandler);

            layout.layout();
		}
	}
}
