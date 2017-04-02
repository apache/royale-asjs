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
	import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.ContainerBase;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IChild;
	import org.apache.flex.core.IContainer;
	import org.apache.flex.core.IContainerView;
	import org.apache.flex.core.IContentViewHost;
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.ILayoutView;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewport;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.geom.Size;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.beads.models.ViewportModel;
	import org.apache.flex.html.supportClasses.Border;
	import org.apache.flex.html.supportClasses.ContainerContentArea;
	import org.apache.flex.html.supportClasses.Viewport;
	import org.apache.flex.utils.CSSContainerUtils;

	/**
	 * This class creates and manages the contents of a Container. On the ActionScript
	 * side, a Container has a contentView into which the offical children can be
	 * placed. When adding an element that implements IChrome, that element is not
	 * placed into the contentView, but is made a child of the Container directly.
	 *
	 * Containers also have a layout associated with them which controls the size and
	 * placement of the elements in the contentView. When a Container does not have an
	 * explicit size (including a percent size), the content dictates the size of the
	 * Container.
     *
	 *  @viewbead
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
	 */
	COMPILE::SWF
	public class ContainerView extends GroupView
	{
		/**
     	 *  The ContainerView class is the default view for
         *  the org.apache.flex.core.ContainerBase classes.
         *  It lets you use some CSS styles to manage the border, background
         *  and padding around the content area.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ContainerView()
		{
			super();
		}

		/**
		 * The sub-element used as the parent of the container's elements. This does not
		 * include the chrome elements.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function get contentView():ILayoutView
		{
			return viewport.contentView as ILayoutView;
		}

		/**
		 * The viewport used to present the content and may display
		 * scroll bars (depending on the actual type of viewport).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function get viewport():IViewport
		{
			return _viewport;
		}

		/**
		 * The data model used by the viewport to determine how it should
		 * present the content area.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get viewportModel():IViewportModel
		{
			return _viewportModel;
		}

		private var _viewportModel:IViewportModel;
		private var _viewport:IViewport;
		private var layoutRunning:Boolean;

		/**
		 * Strand setter.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;

            createViewport();

			var chost:IContainer = host as IContainer;
			chost.strandChildren.addElement(viewport.contentView);

			super.strand = value;
		}

		/**
		 * Called when the host is ready to complete its setup (usually after its size has been
		 * determined).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override protected function completeSetup():void
		{
			super.completeSetup();

			// when the first layout is complete, set up listeners for changes
			// to the childrens' sizes.
			host.addEventListener("layoutComplete", childrenChangedHandler);

			host.addEventListener("widthChanged", resizeHandler);
			host.addEventListener("heightChanged", resizeHandler);
			host.addEventListener("sizeChanged", resizeHandler);
		}

		/**
		 * Creates the Viewport (or ScrollableViewport) through which the content
		 * area is presented.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function createViewport():void
		{
            var c:Class;
			if (viewportModel == null) {
                _viewportModel = _strand.getBeadByType(IViewportModel) as IViewportModel;
                if (viewportModel == null) {
                    c = ValuesManager.valuesImpl.getValue(host, "iViewportModel");
                    if (c)
                    {
                        _viewportModel = new c() as IViewportModel;
                        _strand.addBead(_viewportModel);
                    }
                }
			}

			if (viewport == null) {
				_viewport = _strand.getBeadByType(IViewport) as IViewport;
				if (viewport == null) {
					c = ValuesManager.valuesImpl.getValue(host, "iViewport");
					if (c)
					{
						_viewport = new c() as IViewport;
						_strand.addBead(viewport);
					}
				}
			}
		}

		/**
		 * Calculate the space taken up by non-content children like a TitleBar in a Panel.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function getChromeMetrics():Rectangle
		{
			var paddingMetrics:Rectangle = CSSContainerUtils.getPaddingMetrics(host);
			return paddingMetrics;
		}
		
		/**
		 *  Positions the viewport, then sets any known sizes of the Viewport prior
         *  to laying out its content.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override protected function layoutViewBeforeContentLayout():void
		{
            var host:ILayoutChild = this.host as ILayoutChild;
            var vm:IViewportModel = viewportModel;
			var hostWidth:Number = host.width;
			var hostHeight:Number = host.height;

            vm.borderMetrics = CSSContainerUtils.getBorderMetrics(host);

            viewport.setPosition(vm.borderMetrics.left, vm.borderMetrics.top);

			viewport.layoutViewportBeforeContentLayout(
				host.isWidthSizedToContent() ? NaN : hostWidth - vm.borderMetrics.left - vm.borderMetrics.right,
				host.isHeightSizedToContent() ? NaN : hostHeight - vm.borderMetrics.top - vm.borderMetrics.bottom);
		}

		/**
		 * @private
		 */
		private var adjusting:Boolean = false;

		/**
		 * Adjusts the size of the host, or adds scrollbars to the viewport, after
		 * the layout has been run.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override protected function layoutViewAfterContentLayout():void
		{
			if (adjusting) return;

			adjusting = true;

			super.layoutViewAfterContentLayout();

			var contentSize:Size = calculateContentSize();
			viewport.layoutViewportAfterContentLayout(contentSize);

			adjusting = false;
		}

		/**
		 * Handles dynamic changes to the host's size by running the layout once
		 * the viewport has been adjusted.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function resizeHandler(event:Event):void
		{
			if (!adjusting) {
				performLayout(event);
			}
		}

		/**
		 * Whenever children are added, listeners are added to detect changes
		 * in their size.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function childrenChangedHandler(event:Event):void
		{
			var host:UIBase = _strand as UIBase;
			host.removeEventListener(event.type, childrenChangedHandler);

			var n:Number = contentView.numElements;
			for (var i:int=0; i < n; i++) {
				var child:IUIBase = contentView.getElementAt(i) as IUIBase;
				child.addEventListener("widthChanged", childResizeHandler);
				child.addEventListener("heightChanged", childResizeHandler);
				child.addEventListener("sizeChanged", childResizeHandler);
			}
		}

		/**
		 * This event handles changes to the size of children of the container by running
		 * the layout again and adjusting the size of the container or viewport as necessary.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function childResizeHandler(event:Event):void
		{
			// during this process we don't want the layout to trigger
			// an endless event chain should any children get resized
			// by the layout.
			if (layoutRunning) return;
			performLayout(event);
		}
	}

	COMPILE::JS
	public class ContainerView extends GroupView //??implements IParent
	{
		private var _viewport:IViewport;

		/**
		 * The viewport used to present the content and may display
		 * scroll bars (depending on the actual type of viewport).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function get viewport():IViewport
		{
			return _viewport;
		}
		
		/**
		 * The sub-element used as the parent of the container's elements. This does not
		 * include the chrome elements.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function get contentView():ILayoutView
		{
			if (viewport != null) {
				return viewport.contentView as ILayoutView;
			} else {
				return host as ILayoutView;
			}
		}

		/**
		 * Strand setter.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;

			var c:Class;

			if (viewport == null) {
				_viewport = _strand.getBeadByType(IViewport) as IViewport;
				if (viewport == null) {
					c = ValuesManager.valuesImpl.getValue(host, "iViewport");
					if (c)
					{
						_viewport = new c() as IViewport;
						_strand.addBead(viewport);
					}
				}
			}
			
			if (viewport != null) {
				var chost:IContainer = host as IContainer;
				// add the viewport's contentView to this host ONLY if
				// the contentView is not the host itself, which is likely
				// most situations.
				if (chost != viewport.contentView) {
					chost.addElement(viewport.contentView);
				}
			}
		}
	}
}
