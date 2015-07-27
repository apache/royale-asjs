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
package org.apache.flex.html.beads.layouts
{
	import flash.display.DisplayObject;
	
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IScrollBarModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIMetrics;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.IScrollBarView;
	import org.apache.flex.utils.BeadMetrics;

    /**
     *  The HScrollBarLayout class is a layout
     *  bead that displays lays out the pieces of a
     *  horizontal ScrollBar like the thumb, track
     *  and arrow buttons.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class HScrollBarLayout implements IBeadLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function HScrollBarLayout()
		{
		}
		
		private var sbModel:IScrollBarModel;
		private var sbView:IScrollBarView;
		
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
			sbView = _strand.getBeadByType(IScrollBarView) as IScrollBarView;
		}
			
        /**
         * @copy org.apache.flex.core.IBeadLayout#layout
         */
		public function layout():Boolean
		{
            if (!sbModel)
                sbModel = _strand.getBeadByType(IScrollBarModel) as IScrollBarModel
					
			var metrics:UIMetrics = BeadMetrics.getMetrics(_strand);
                    
			var w:Number = DisplayObject(_strand).width + metrics.left + metrics.right;
			var increment:DisplayObject = sbView.increment;
			var decrement:DisplayObject = sbView.decrement;
			var track:DisplayObject = sbView.track;
			var thumb:DisplayObject = sbView.thumb;
			
			decrement.x = 0;
			decrement.y = 0;
			decrement.height = DisplayObject(_strand).height;
			decrement.width = DisplayObject(_strand).height;
			
			increment.height = DisplayObject(_strand).height;
			increment.width = DisplayObject(_strand).height;
			increment.x = w - increment.width - 1;
			increment.y = 0;

			track.x = decrement.width;
			track.y = 0;
			track.height = DisplayObject(_strand).height;
			track.width = increment.x - decrement.width;
            thumb.width = sbModel.pageSize / (sbModel.maximum - sbModel.minimum) * track.width;
			if (track.width > thumb.width)
			{
				thumb.visible = true;
				thumb.x = (sbModel.value / (sbModel.maximum - sbModel.minimum - sbModel.pageSize) * (track.width - thumb.width)) + track.x;
			}
			else
			{
				thumb.visible = false;
			}
			
            return true;
		}
						
	}
}
