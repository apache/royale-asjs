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
	import org.apache.royale.core.IContainer;
	import org.apache.royale.core.IContentViewHost;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IViewport;
	import org.apache.royale.core.IViewportModel;
    COMPILE::SWF
    {
        import org.apache.royale.core.IViewportScroller;
		import org.apache.royale.html.beads.ScrollBarView;
		import org.apache.royale.html.beads.models.ScrollBarModel;
		import org.apache.royale.utils.CSSContainerUtils;
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
		
		/**
		 * @royaleignorecoercion HTMLElement 
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			if (contentView == null) {
				(value as UIBase).element.style.overflow = "hidden";
				(value as UIBase).element.style.overflowX = "auto";
			} else {
				(contentView as UIBase).element.style.overflow = "hidden";
				(contentView as UIBase).element.style.overflowX = "auto";
			}
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

		private var _verticalScroller:ScrollBar;

		override public function get verticalScroller():IViewportScroller
		{
			return _verticalScroller;
		}

		private var _horizontalScroller:ScrollBar

		override public function get horizontalScroller():IViewportScroller
		{
			return _horizontalScroller;
		}

        override public function get verticalScrollPosition():Number
        {
			return 0;
        }
        override public function set verticalScrollPosition(value:Number):void
        {
			//do nothing
        }

        private var _horizontalScrollPosition:Number = 0;

        override public function get horizontalScrollPosition():Number
        {
			return _horizontalScrollPosition;
        }
        override public function set horizontalScrollPosition(value:Number):void
        {
			_horizontalScrollPosition = value;
            dispatchEvent(new Event("horizontalScrollPositionChanged"));
			handleHorizontalScrollChange();
        }

        private var viewportWidth:Number;
        private var viewportHeight:Number;

        /**
         * @copy org.apache.royale.core.IViewport
         */
        override public function layoutViewportBeforeContentLayout(width:Number, height:Number):void
        {
           	super.layoutViewportBeforeContentLayout(width, height);
           	viewportWidth = width;
           	viewportHeight = height;
        }

        /**
         * @copy org.apache.royale.core.IViewport
         */
		override public function layoutViewportAfterContentLayout(contentSize:Size):void
		{
			var host:UIBase = UIBase(_strand);
						
			var hostWidth:Number = host.width;
			var hostHeight:Number = host.height;
			
			var borderMetrics:org.apache.royale.geom.Rectangle = CSSContainerUtils.getBorderMetrics(_strand);
			
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

		private function createHorizontalScrollBar():ScrollBar
		{
			var hsbm:ScrollBarModel = new ScrollBarModel();
			hsbm.minimum = 0;
			hsbm.snapInterval = 1;
			hsbm.stepSize = 1;
			hsbm.value = 0;

			var hsb:HScrollBar;
			hsb = new HScrollBar();
			hsb.model = hsbm;
			hsb.visible = false;

			hsb.addEventListener("scroll",handleHorizontalScroll);
			return hsb;
		}

		private function handleHorizontalScroll(event:Event):void
		{
			var host:UIBase = UIBase(_strand);
			var hpos:Number = ScrollBarModel(_horizontalScroller.model).value;
			var rect:flash.geom.Rectangle = contentArea.scrollRect;
			rect.x = hpos;
			contentArea.scrollRect = rect;

			_horizontalScrollPosition = hpos;
            dispatchEvent(new Event("horizontalScrollPositionChanged"));
		}

		private function handleHorizontalScrollChange():void
		{
			if (_horizontalScroller) {
				ScrollBarModel(_horizontalScroller.model).value = horizontalScrollPosition;
			}
		}

	}
}
