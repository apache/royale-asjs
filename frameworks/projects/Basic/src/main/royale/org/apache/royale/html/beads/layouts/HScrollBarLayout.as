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
package org.apache.royale.html.beads.layouts
{
	
	import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.IScrollBarModel;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.geom.Rectangle;
	import org.apache.royale.html.beads.IScrollBarView;
	import org.apache.royale.html.Button;

    /**
     *  The HScrollBarLayout class is a layout
     *  bead that displays lays out the pieces of a
     *  horizontal ScrollBar like the thumb, track
     *  and arrow buttons.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class HScrollBarLayout implements IBeadLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function HScrollBarLayout()
		{
		}
		
		private var sbModel:IScrollBarModel;
		private var sbView:IScrollBarView;
		
		private var _strand:IStrand;
		
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
			sbView = _strand.getBeadByType(IScrollBarView) as IScrollBarView;
		}
			
        /**
         * @copy org.apache.royale.core.IBeadLayout#layout
         * @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
         */
		public function layout():Boolean
		{
            if (!sbModel)
                sbModel = _strand.getBeadByType(IScrollBarModel) as IScrollBarModel
					
			var metrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderAndPaddingMetrics(_strand as IUIBase);
            
            var host:UIBase = UIBase(_strand);
			var w:Number = host.width + metrics.left + metrics.right;
			var increment:Button = sbView.increment;
			var decrement:Button = sbView.decrement;
			var track:Button = sbView.track;
			var thumb:Button = sbView.thumb;
			
			decrement.x = 1;
			decrement.y = 0;
			decrement.height = host.height - 2;
			decrement.width = host.height;
			
			increment.height = host.height - 2;
			increment.width = host.height;
			increment.x = w - increment.width - 2;
			increment.y = 0;

			track.x = decrement.width + 4;
			track.y = 0;
			track.height = host.height;
			track.width = increment.x - decrement.width - 5;
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
