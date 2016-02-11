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
package org.apache.flex.html.supportClasses
{
    COMPILE::AS3
    {
        import flash.geom.Rectangle;
    }
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IContentViewHost;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewport;
	import org.apache.flex.core.IViewportModel;
    COMPILE::AS3
    {
        import org.apache.flex.core.IViewportScroller;
    }
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.geom.Size;
	import org.apache.flex.html.beads.ScrollBarView;
	import org.apache.flex.html.beads.models.ScrollBarModel;

	/**
	 * The ScrollingViewport extends the Viewport class by adding horizontal and
	 * vertical scroll bars, if needed, to the content area of a Container. In
	 * addition, the content of the Container is clipped so that items extending
	 * outside the Container are hidden and reachable only by scrolling.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ScrollingViewport extends Viewport implements IBead, IViewport
	{
		/**
		 * Constructor
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion FlexJS 0.0
		 */
		public function ScrollingViewport()
		{
		}

        COMPILE::AS3
		private var _verticalScroller:ScrollBar;

        COMPILE::AS3
		public function get verticalScroller():IViewportScroller
		{
			return _verticalScroller;
		}

        COMPILE::AS3
		private var _horizontalScroller:ScrollBar

        COMPILE::AS3
		public function get horizontalScroller():IViewportScroller
		{
			return _horizontalScroller;
		}

        COMPILE::AS3
        private var _verticalScrollPosition:Number = 0;

        public function get verticalScrollPosition():Number
        {
            COMPILE::AS3
            {
                return _verticalScrollPosition;
            }
            COMPILE::JS
            {
                return this.contentView.positioner.scrollTop;
            }
        }
        public function set verticalScrollPosition(value:Number):void
        {
            COMPILE::AS3
            {
                _verticalScrollPosition = value;
                handleVerticalScrollChange();
            }
            COMPILE::JS
            {
                this.contentView.positioner.scrollTop = value;
            }
        }

        COMPILE::AS3
        private var _horizontalScrollPosition:Number = 0;

        public function get horizontalScrollPosition():Number
        {
            COMPILE::AS3
            {
                return _horizontalScrollPosition;
            }
            COMPILE::JS
            {
                return this.contentView.positioner.scrollLeft;
            }
        }
        public function set horizontalScrollPosition(value:Number):void
        {
            COMPILE::AS3
            {
                _horizontalScrollPosition = value;
                handleHorizontalScrollChange();
            }
            COMPILE::JS
            {
                this.contentView.positioner.scrollLeft = value;
            }
        }

        COMPILE::JS
        override public function set strand(value:IStrand):void
        {
            super.strand = value;
            contentView.element.style.overflow = 'auto';
        }

        private var viewportWidth:Number;
        private var viewportHeight:Number;

        /**
         * @copy org.apache.flex.core.IViewport
         */
        override public function layoutViewportBeforeContentLayout(width:Number, height:Number):void
        {
           super.layoutViewportBeforeContentLayout(width, height);
           viewportWidth = width;
           viewportHeight = height;
        }

        /**
         * @copy org.apache.flex.core.IViewport
         */
		override public function layoutViewportAfterContentLayout():Size
		{
            COMPILE::AS3
            {
                var hadV:Boolean = _verticalScroller != null && _verticalScroller.visible;
                var hadH:Boolean = _horizontalScroller != null && _horizontalScroller.visible;
                var contentSize:Size;
                do
                {
                    contentSize = super.layoutViewportAfterContentLayout();
                    if (isNaN(viewportHeight))
                        viewportHeight = contentSize.height;
                    if (isNaN(viewportWidth))
                        viewportWidth = contentSize.width;

                    var host:UIBase = UIBase(_strand);
                    var visibleWidth:Number;
                    var visibleHeight:Number;
                    var needV:Boolean = contentSize.height > viewportHeight;
                    var needH:Boolean = contentSize.width > viewportWidth;

                    if (needV)
                    {
                        if (_verticalScroller == null) {
                            _verticalScroller = createVerticalScrollBar();
                            (host as IContentViewHost).strandChildren.addElement(_verticalScroller);
                        }
                    }
                    if (needH)
                    {
                        if (_horizontalScroller == null) {
                            _horizontalScroller = createHorizontalScrollBar();
                            (host as IContentViewHost).strandChildren.addElement(_horizontalScroller);
                        }
                    }

                    if (needV)
                    {
                        _verticalScroller.visible = true;
                        _verticalScroller.x = contentArea.x + viewportWidth - _verticalScroller.width;
                        _verticalScroller.y = contentArea.y;
                        _verticalScroller.setHeight(viewportHeight - (needH ? _horizontalScroller.height : 0), true);
                        visibleWidth = _verticalScroller.x;
                    }
                    else if (_verticalScroller)
                        _verticalScroller.visible = false;

                    if (needH)
                    {
                        _horizontalScroller.visible = true;
                        _horizontalScroller.x = contentArea.x;
                        _horizontalScroller.y = contentArea.y + viewportHeight - _horizontalScroller.height;
                        _horizontalScroller.setWidth(viewportWidth - (needV ? _verticalScroller.width : 0), true);
                        visibleHeight = _horizontalScroller.y;
                    }

                    var needsLayout:Boolean = false;
                    // resize content area if needed to get out from under scrollbars
                    if (!isNaN(visibleWidth) || !isNaN(visibleHeight))
                    {
                        if (!isNaN(visibleWidth))
                            needsLayout = visibleWidth != contentView.width;
                        if (!isNaN(visibleHeight))
                            needsLayout = visibleHeight != contentView.height;
                        if (!isNaN(visibleWidth) && !isNaN(visibleHeight))
                            contentArea.setWidthAndHeight(visibleWidth, visibleHeight, false);
                        else if (!isNaN(visibleWidth))
                            contentArea.setWidth(visibleWidth, false);
                        else if (!isNaN(visibleHeight))
                            contentArea.setHeight(visibleHeight, false);
                    }
                    if (needsLayout)
                    {
                        var layout:IBeadLayout = host.getBeadByType(IBeadLayout) as IBeadLayout;
                        layout.layout();
                    }
                } while (needsLayout && (needV != hadV || needH == hadH));
                if (_verticalScroller)
                {
                    ScrollBarModel(_verticalScroller.model).maximum = contentSize.height;
                    ScrollBarModel(_verticalScroller.model).pageSize = contentArea.height;
                    ScrollBarModel(_verticalScroller.model).pageStepSize = contentArea.height;
                    if (contentSize.height > contentArea.height &&
                        (contentSize.height - contentArea.height) < _verticalScrollPosition)
                        _verticalScrollPosition = contentSize.height - contentArea.height;
                }
                if (_horizontalScroller)
                {
                    ScrollBarModel(_horizontalScroller.model).maximum = contentSize.width;
                    ScrollBarModel(_horizontalScroller.model).pageSize = contentArea.width;
                    ScrollBarModel(_horizontalScroller.model).pageStepSize = contentArea.width;
                    if (contentSize.width > contentArea.width &&
                        (contentSize.width - contentArea.width) < _horizontalScrollPosition)
                        _horizontalScrollPosition = contentSize.width - contentArea.width;
                }

                var rect:Rectangle = new Rectangle(_horizontalScrollPosition, _verticalScrollPosition,
                    (_verticalScroller != null && _verticalScroller.visible) ?
                    _verticalScroller.x : viewportWidth,
                    (_horizontalScroller != null && _horizontalScroller.visible) ?
                    _horizontalScroller.y : viewportHeight);
                contentArea.scrollRect = rect;
                return contentSize;

            }
            COMPILE::JS
            {
                return new Size(contentView.width, contentView.height);
            }

		}

		COMPILE::AS3
		private function createVerticalScrollBar():ScrollBar
		{
			var vsbm:ScrollBarModel = new ScrollBarModel();
			vsbm.minimum = 0;
			vsbm.snapInterval = 1;
			vsbm.stepSize = 1;
			vsbm.value = 0;

			var vsb:VScrollBar;
			vsb = new VScrollBar();
			vsb.model = vsbm;
			vsb.visible = false;

			vsb.addEventListener("scroll",handleVerticalScroll);
			return vsb;
		}

        COMPILE::AS3
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

        COMPILE::AS3
		private function handleVerticalScroll(event:Event):void
		{
			var host:UIBase = UIBase(_strand);
			var vpos:Number = ScrollBarModel(_verticalScroller.model).value;
			var rect:Rectangle = contentArea.scrollRect;
			rect.y = vpos;
			contentArea.scrollRect = rect;

			_verticalScrollPosition = vpos;
		}

        COMPILE::AS3
		private function handleHorizontalScroll(event:Event):void
		{
			var host:UIBase = UIBase(_strand);
			var hpos:Number = ScrollBarModel(_horizontalScroller.model).value;
			var rect:Rectangle = contentArea.scrollRect;
			rect.x = hpos;
			contentArea.scrollRect = rect;

			_horizontalScrollPosition = hpos;
		}

        COMPILE::AS3
		private function handleVerticalScrollChange():void
		{
			if (_verticalScroller) {
				ScrollBarModel(_verticalScroller.model).value = verticalScrollPosition;
			}
		}

        COMPILE::AS3
		private function handleHorizontalScrollChange():void
		{
			if (_horizontalScroller) {
				ScrollBarModel(_horizontalScroller.model).value = horizontalScrollPosition;
			}
		}
	}
}
