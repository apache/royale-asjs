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
	
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.UIMetrics;
    import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.Panel;
	import org.apache.flex.html.TitleBar;
	import org.apache.flex.utils.BeadMetrics;
    import org.apache.flex.utils.CSSUtils;
	
	/**
	 *  The Panel class creates the visual elements of the org.apache.flex.html.Panel 
	 *  component. A Panel has a org.apache.flex.html.TitleBar, and content.  A
     *  different View, PanelWithControlBarView, can display a ControlBar.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class PanelView extends ContainerView implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function PanelView()
		{
			super();
		}
		
		private var _titleBar:TitleBar;
		
		/**
		 *  The org.apache.flex.html.TitleBar component of the 
		 *  org.apache.flex.html.Panel.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get titleBar():TitleBar
		{
			return _titleBar;
		}
		
        /**
         *  @private
         */
        public function set titleBar(value:TitleBar):void
        {
            _titleBar = value;
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
            var host:UIBase = UIBase(value);
            
            if (!_titleBar) {
                _titleBar = new TitleBar();
				_titleBar.id = "panelTitleBar";
				_titleBar.height = 30;
			}
			// replace the TitleBar's model with the Panel's model (it implements ITitleBarModel) so that
			// any changes to values in the Panel's model that correspond values in the TitleBar will 
			// be picked up automatically by the TitleBar.
			titleBar.model = host.model;
			            
            super.strand = value;
		}
		
		override protected function completeSetup():void
		{
			UIBase(_strand).addElement(titleBar);
			super.completeSetup();
		}
		
        override protected function adjustSizeBeforeLayout():void
        {
            var metrics:UIMetrics = BeadMetrics.getMetrics(host);
            
            viewportModel.contentWidth = Math.max(host.width - metrics.left - metrics.right, 0);
            viewportModel.contentHeight = Math.max(host.height - titleBar.height - metrics.top - metrics.bottom, 0);
            viewportModel.contentX = metrics.left;
            viewportModel.contentY = metrics.top;
            
            contentView.x = viewportModel.contentX;
            contentView.y = viewportModel.contentY;
            contentView.width = viewportModel.contentWidth;
            contentView.height = viewportModel.contentHeight;
        }
        
		override protected function layoutContainer(widthSizedToContent:Boolean, heightSizedToContent:Boolean):void
		{
            var borderThickness:Object = ValuesManager.valuesImpl.getValue(host,"border-width");
            var borderStyle:Object = ValuesManager.valuesImpl.getValue(host,"border-style");
            var border:Object = ValuesManager.valuesImpl.getValue(host,"border");
            var borderOffset:Number;
            if (borderStyle == "none")
                borderOffset = 0;
            else if (borderThickness != null)
            {
                if (borderThickness is String)
                    borderOffset = CSSUtils.toNumber(borderThickness as String, host.width);
                else
                    borderOffset = Number(borderThickness);
                if( isNaN(borderOffset) ) borderOffset = 0;            
            }
            else // no style and/or no width
            {
                border = ValuesManager.valuesImpl.getValue(host,"border");
                if (border != null)
                {
                    if (border is Array)
                    {
                        borderOffset = CSSUtils.toNumber(border[0], host.width);
                        borderStyle = border[1];
                    }
                    else if (border == "none")
                        borderOffset = 0;
                    else if (border is String)
                        borderOffset = CSSUtils.toNumber(border as String, host.width);
                    else
                        borderOffset = Number(border);
                }
                else // no border style set at all so default to none
                    borderOffset = 0;
            }

            titleBar.x = borderOffset;
			titleBar.y = borderOffset;
			titleBar.width = host.width - 2 * borderOffset;
			titleBar.dispatchEvent( new Event("layoutNeeded") ); // this shouldn't be needed
			
			if (heightSizedToContent) {
				host.height = viewportModel.contentHeight + titleBar.height + 2 * borderOffset;
			}
            if (widthSizedToContent) {
                host.width = viewportModel +  2 * borderOffset;
            }
			
			viewportModel.viewportHeight = host.height - titleBar.height - 2 * borderOffset;
			viewportModel.viewportWidth = host.width - 2 * borderOffset;
			viewportModel.viewportX = borderOffset;
			viewportModel.viewportY = titleBar.height + borderOffset;
		}       
	}
}
