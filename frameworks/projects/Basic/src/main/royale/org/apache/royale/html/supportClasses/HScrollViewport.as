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
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.IContainer;
	import org.apache.royale.core.IContentViewHost;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IViewport;
	import org.apache.royale.core.IViewportModel;
    import org.apache.royale.core.layout.EdgeData;
    import org.apache.royale.core.ValuesManager;
    COMPILE::SWF
    {
        import org.apache.royale.core.IViewportScroller;
		import org.apache.royale.html.beads.ScrollBarView;
		import org.apache.royale.html.beads.models.ScrollBarModel;
		import flash.geom.Rectangle;
		import org.apache.royale.geom.Rectangle;
    }
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.geom.Size;
	import org.apache.royale.geom.Rectangle;

	/**
	 * The HScrollViewport extends the ScrollingViewport class and limts scrolling
	 * to only vertical scroll bars.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.2
	 */
	COMPILE::JS
	public class HScrollViewport extends ScrollingViewport
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.2
		 */
		public function HScrollViewport()
		{
			super();
		}
		
		// These shuould be disabled for HScroll
		override public function get verticalScrollPosition():Number
		{
			return 0;
		}
		override public function set verticalScrollPosition(value:Number):void
		{
			// Do nothing
		}
		
		override protected function setScrollStyle():void
		{
			contentArea.element.style.overflow = "hidden";
			contentArea.element.style.overflowX = "auto";
			adaptContentArea();
		}

	}
	
	COMPILE::SWF
	public class HScrollViewport extends ScrollingViewport
	{
		/**
		 * Constructor
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 */
		public function HScrollViewport()
		{
			super();
		}

        override public function set verticalScrollPosition(value:Number):void
        {
			//do nothing
        }

        /**
         * @copy org.apache.royale.core.IViewport
         *  @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
         */
		override public function layoutViewportAfterContentLayout(contentSize:Size):void
		{
			var host:UIBase = UIBase(_strand);
						
			var hostWidth:Number = host.width;
			var hostHeight:Number = host.height;
			
			var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(_strand as IUIBase);
			
			hostWidth -= borderMetrics.left + borderMetrics.right;
			hostHeight -= borderMetrics.top + borderMetrics.bottom;
			
			var needH:Boolean = contentSize.width > viewportWidth;
			
			// if sized to content, the container should stretch to fit, making the original
			// viewport dimensions obsolete and scrollbars unnecessary.
			// This might not work for the flexible child.
			if (host.isWidthSizedToContent())
				needH = false;

			if (needH)
			{
				if (_horizontalScroller == null) {
					_horizontalScroller = createHorizontalScrollBar();
					(_strand as IContainer).strandChildren.addElement(_horizontalScroller);
				}
			}
			
			if (needH)
			{
				_horizontalScroller.visible = true;
				_horizontalScroller.x = 0;
				_horizontalScroller.y = UIBase(_strand).height - borderMetrics.bottom - _horizontalScroller.height;
				_horizontalScroller.setWidth(hostWidth, false);
				
				ScrollBarModel(_horizontalScroller.model).maximum = contentSize.width;
				ScrollBarModel(_horizontalScroller.model).pageSize = contentArea.width;
				ScrollBarModel(_horizontalScroller.model).pageStepSize = contentArea.width;
				
				if (contentSize.width > contentArea.width &&
					(contentSize.width - contentArea.width) < _horizontalScrollPosition)
					_horizontalScrollPosition = contentSize.width - contentArea.width;
			} 
			else if (_horizontalScroller) {
				_horizontalScroller.visible = false;
			}
			
			var rect:flash.geom.Rectangle = new flash.geom.Rectangle(_horizontalScrollPosition, 0,
				hostWidth,
				(_horizontalScroller != null && _horizontalScroller.visible) ? _horizontalScroller.y : hostHeight);
			
			contentArea.scrollRect = rect;
		}

	}
}
