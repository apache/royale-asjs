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
	 * The VScrollViewport extends the ScrollingViewport class and limts scrolling
	 * to only vertical scroll bars.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.2
	 */
	COMPILE::JS
	public class VScrollViewport extends ScrollingViewport
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.2
		 */
		public function VScrollViewport()
		{
			super();
		}
		
		// These shuould be disabled for VScroll
		override public function get horizontalScrollPosition():Number
		{
			return 0;
		}
		override public function set horizontalScrollPosition(value:Number):void
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
				(value as UIBase).element.style.overflowY = "auto";
			} else {
				(contentView as UIBase).element.style.overflow = "hidden";
				(contentView as UIBase).element.style.overflowY = "auto";
			}
		}		
	}
	
	COMPILE::SWF
	public class VScrollViewport extends ScrollingViewport
	{
		/**
		 * Constructor
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.9.2
		 */
		public function VScrollViewport()
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

        private var _verticalScrollPosition:Number = 0;

        override public function get verticalScrollPosition():Number
        {
			return _verticalScrollPosition;
        }
        override public function set verticalScrollPosition(value:Number):void
        {
			_verticalScrollPosition = value;
			handleVerticalScrollChange();
        }

        private var _horizontalScrollPosition:Number = 0;

        override public function get horizontalScrollPosition():Number
        {
			return _horizontalScrollPosition;
        }
        override public function set horizontalScrollPosition(value:Number):void
        {
			// Do nothing
			// _horizontalScrollPosition = value;
			// handleHorizontalScrollChange();
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
			
			var hadV:Boolean = _verticalScroller != null && _verticalScroller.visible;
			
			var hostWidth:Number = host.width;
			var hostHeight:Number = host.height;
			
			var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(_strand as IUIBase);
			
			hostWidth -= borderMetrics.left + borderMetrics.right;
			hostHeight -= borderMetrics.top + borderMetrics.bottom;
			
			var needV:Boolean = contentSize.height > viewportHeight;
			
			// if sized to content, the container should stretch to fit, making the original
			// viewport dimensions obsolete and scrollbars unnecessary.
			// This might not work for the flexible child.
			if (host.isHeightSizedToContent())
				needV = false;

			if (needV)
			{
				if (_verticalScroller == null) {
					_verticalScroller = createVerticalScrollBar();
					(_strand as IContainer).strandChildren.addElement(_verticalScroller);
				}
			}
			
			if (needV)
			{
				_verticalScroller.visible = true;
				_verticalScroller.x = UIBase(_strand).width - borderMetrics.right - _verticalScroller.width;
				_verticalScroller.y = borderMetrics.top;
				_verticalScroller.setHeight(hostHeight, false);
				
				ScrollBarModel(_verticalScroller.model).maximum = contentSize.height;
				ScrollBarModel(_verticalScroller.model).pageSize = contentArea.height;
				ScrollBarModel(_verticalScroller.model).pageStepSize = contentArea.height;
				
				if (contentSize.height > contentArea.height &&
					(contentSize.height - contentArea.height) < _verticalScrollPosition)
					_verticalScrollPosition = contentSize.height - contentArea.height;
			}
			else if (_verticalScroller) {
				_verticalScroller.visible = false;
			}
			
			var rect:flash.geom.Rectangle = new flash.geom.Rectangle(_horizontalScrollPosition, _verticalScrollPosition,
				(_verticalScroller != null && _verticalScroller.visible) ? _verticalScroller.x : hostWidth,
				hostHeight);
			
			contentArea.scrollRect = rect;
		}

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

		private function handleVerticalScroll(event:Event):void
		{
			var host:UIBase = UIBase(_strand);
			var vpos:Number = ScrollBarModel(_verticalScroller.model).value;
			var rect:flash.geom.Rectangle = contentArea.scrollRect;
			rect.y = vpos;
			contentArea.scrollRect = rect;

			_verticalScrollPosition = vpos;
		}

		private function handleVerticalScrollChange():void
		{
			if (_verticalScroller) {
				ScrollBarModel(_verticalScroller.model).value = verticalScrollPosition;
			}
		}

	}
}
