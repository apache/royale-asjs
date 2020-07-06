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
	import org.apache.royale.html.beads.GroupView;
	import org.apache.royale.core.ContainerBase;
	import org.apache.royale.core.IBead;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.IContainer;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IViewport;
	import org.apache.royale.core.IViewportModel;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.events.Event;
	import org.apache.royale.geom.Size;
	import org.apache.royale.html.beads.models.ViewportModel;
	import org.apache.royale.html.supportClasses.Border;
	import org.apache.royale.html.supportClasses.Viewport;
	import org.apache.royale.utils.loadBeadFromValuesManager;

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
     *  @productversion Royale 0.8
	 */
	COMPILE::SWF
	public class ContainerView extends GroupView
	{
		/**
     	 *  The ContainerView class is the default view for
         *  the org.apache.royale.core.ContainerBase classes.
         *  It lets you use some CSS styles to manage the border, background
         *  and padding around the content area.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;

            createViewport();

            addViewport();

			super.strand = value;
		}

        protected function addViewport():void
        {
            var chost:IContainer = host as IContainer;
            chost.strandChildren.addElement(viewport.contentView);            
        }
        
		/**
		 * Called when the host is ready to complete its setup (usually after its size has been
		 * determined).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		override protected function completeSetup():void
		{
			super.completeSetup();

			// when the first layout is complete, set up listeners for changes
			// to the childrens' sizes.
//			host.addEventListener("layoutComplete", childrenChangedHandler);
		}

		/**
		 * Creates the Viewport (or ScrollableViewport) through which the content
		 * area is presented.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		protected function createViewport():void
		{
			if(!_viewportModel)
				_viewportModel = loadBeadFromValuesManager(IViewportModel, "iViewportModel", _strand) as IViewportModel;
				
			if(!_viewport)
				_viewport = loadBeadFromValuesManager(IViewport, "iViewport", _strand) as IViewport;

		}

		/**
		 * Calculate the space taken up by non-content children like a TitleBar in a Panel.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 */
		protected function getChromeMetrics():EdgeData
		{
			var paddingMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPaddingMetrics(host);
			return paddingMetrics;
		}
		
		/**
		 *  Positions the viewport, then sets any known sizes of the Viewport prior
         *  to laying out its content.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 */
		override public function beforeLayout():Boolean
		{
            var host:ILayoutChild = this.host as ILayoutChild;
            var vm:IViewportModel = viewportModel;
            COMPILE::SWF
            {
                // if earlier layouts set the size of the host
                // then it won't reflect changes in content size
                if (host is UIBase)
                {
                    var uiBase:UIBase = host as UIBase;
                    if (host.isWidthSizedToContent())
                    {
                        if (uiBase.width != uiBase.$width)
                        {
                            host.setWidth(uiBase.$width, true);
                        }
                    }
                    if (host.isHeightSizedToContent())
                    {
                        if (uiBase.height != uiBase.$height)
                        {
                            host.setHeight(uiBase.$height, true);
                        }
                    }                    
                }
            }
			var hostWidth:Number = host.width;
			var hostHeight:Number = host.height;

            vm.borderMetrics = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(host);

            viewport.setPosition(vm.borderMetrics.left, vm.borderMetrics.top);

			viewport.layoutViewportBeforeContentLayout(
				hostWidth - vm.borderMetrics.left - vm.borderMetrics.right,
				hostHeight - vm.borderMetrics.top - vm.borderMetrics.bottom);
				
			return true;
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
		 *  @productversion Royale 0.8
		 */
		override public function afterLayout():void
		{
			if (adjusting) return;

			adjusting = true;

			super.afterLayout();

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
		 *  @productversion Royale 0.8
		 */
//		override protected function resizeHandler(event:Event):void
//		{
//			if (!adjusting) {
//				performLayout(event);
//			}
//		}

		/**
		 * Whenever children are added, listeners are added to detect changes
		 * in their size.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
//		protected function childrenChangedHandler(event:Event):void
//		{
//			var host:UIBase = _strand as UIBase;
//			host.removeEventListener(event.type, childrenChangedHandler);
//
//			var n:Number = contentView.numElements;
//			for (var i:int=0; i < n; i++) {
//				var child:IUIBase = contentView.getElementAt(i) as IUIBase;
//				child.addEventListener("widthChanged", childResizeHandler);
//				child.addEventListener("heightChanged", childResizeHandler);
//				child.addEventListener("sizeChanged", childResizeHandler);
//			}
//		}
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
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.core.ILayoutView
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
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.core.IViewport
		 *  @royaleignorecoercion org.apache.royale.core.IContainer
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;

			if(!_viewport)
				_viewport = loadBeadFromValuesManager(IViewport, "iViewport", _strand) as IViewport;
			
			if (_viewport) {
				addViewport();
			}
		}
    
		/**
		 * @royaleignorecoercion org.apache.royale.core.IContainer
		 */
		protected function addViewport():void
		{
			var chost:IContainer = host as IContainer;
			// add the viewport's contentView to this host ONLY if
			// the contentView is not the host itself, which is likely
			// most situations.
			if (chost != null && chost != _viewport.contentView) {
				chost.addElement(_viewport.contentView);
			}
		}
	}
}
