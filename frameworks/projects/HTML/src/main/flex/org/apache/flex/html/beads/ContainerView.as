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
	import org.apache.flex.core.IContainer;
	import org.apache.flex.core.IContainerView;
	import org.apache.flex.core.IContentViewHost;
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutHost;
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
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
	 */
	public class ContainerView extends BeadViewBase implements IBeadView, IContainerView, ILayoutHost
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
			
			layoutRunning = false;
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
		public function get contentView():IParentIUIBase
		{
			return viewport.contentView as IParentIUIBase;
		}
		
		/**
		 * The view that can be resized.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get resizableView():IUIBase
		{
			return host;
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
		 * @private
		 */
		public function addElement(c:Object, dispatchEvent:Boolean = true):void
		{
			contentView.addElement(c, dispatchEvent);
		}
		
		/**
		 * @private
		 */
		public function addElementAt(c:Object, index:int, dispatchEvent:Boolean = true):void
		{
			contentView.addElementAt(c, index, dispatchEvent);
		}
		
		/**
		 * @private
		 */
		public function getElementIndex(c:Object):int
		{
			return contentView.getElementIndex(c);
		}
		
		/**
		 * @private
		 */
		public function removeElement(c:Object, dispatchEvent:Boolean = true):void
		{
			contentView.removeElement(c, dispatchEvent);
		}
		
		/**
		 * @private
		 */
		public function get numElements():int
		{
			return contentView.numElements;
		}
		
		/**
		 * @private
		 */
		public function getElementAt(index:int):Object
		{
			return contentView.getElementAt(index);
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
			
            createViewport();
			
			(host as IContentViewHost).strandChildren.addElement(viewport.contentView, false);
			
			displayBackgroundAndBorder(host as UIBase);
			
			// listen for initComplete to signal that the strand is set with its size
			// and beads.
			host.addEventListener("initComplete", initCompleteHandler);
		}
		
		/**
		 * Handles the initComplete event by completing the setup and kicking off the
		 * presentation of the Container.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function initCompleteHandler(event:Event):void
		{
            var ilc:ILayoutChild = host as ILayoutChild;
			// Complete the setup if the height is sized to content or has been explicitly set
            // and the width is sized to content or has been explicitly set
			if ((ilc.isHeightSizedToContent() || !isNaN(ilc.explicitHeight)) &&
                (ilc.isWidthSizedToContent() || !isNaN(ilc.explicitWidth))) {
				completeSetup();
				
				var num:Number = contentView.numElements;
				if (num > 0) performLayout(event);
			}
			else {
				// otherwise, wait until the unknown sizes have been set and then finish
				host.addEventListener("sizeChanged", deferredSizeHandler);
                host.addEventListener("widthChanged", deferredSizeHandler);
                host.addEventListener("heightChanged", deferredSizeHandler);
			}
		}
		
		/**
		 * Handles the case where the size of the host is not immediately known, usually do
		 * to one of its dimensions being indicated as a percent size.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		private function deferredSizeHandler(event:Event):void
		{
            host.removeEventListener("sizeChanged", deferredSizeHandler);
            host.removeEventListener("widthChanged", deferredSizeHandler);
            host.removeEventListener("heightChanged", deferredSizeHandler);
			completeSetup();
			
			var num:Number = contentView.numElements;
			if (num > 0) 
            {
                performLayout(event);
            }
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
		protected function completeSetup():void
		{
			// when the first layout is complete, set up listeners for changes
			// to the childrens' sizes.
			host.addEventListener("layoutComplete", childrenChangedHandler);
			
			host.addEventListener("childrenAdded", performLayout);
			host.addEventListener("layoutNeeded", performLayout);
			host.addEventListener("widthChanged", resizeHandler);
			host.addEventListener("heightChanged", resizeHandler);
			host.addEventListener("sizeChanged", resizeHandler);
			host.addEventListener("viewCreated", viewCreatedHandler);
		}
		
		/**
		 * Handles the viewCreated event by performing the first layout if
		 * there are children already present (ie, from MXML).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function viewCreatedHandler(event:Event):void
		{			
			if ((host as UIBase).numElements > 0) {
				performLayout(null);
			}
		}
		
        /**
         * Calculate the space taken up by non-content children like a TItleBar in a Panel.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        protected function getChromeMetrics():Rectangle
        {
            return new Rectangle(0, 0, 0, 0);
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
		 *  Positions the viewport, then sets any known sizes of the Viewport prior
         *  to laying out its content.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function layoutViewBeforeContentLayout():void
		{
            var host:ILayoutChild = this.host as ILayoutChild;
            var vm:IViewportModel = viewportModel;
            vm.borderMetrics = CSSContainerUtils.getBorderMetrics(host);
            vm.chromeMetrics = getChromeMetrics();
            viewport.setPosition(vm.borderMetrics.left + vm.chromeMetrics.left,
                                 vm.borderMetrics.top + vm.chromeMetrics.top)
            viewport.layoutViewportBeforeContentLayout(
                !host.isWidthSizedToContent() ? 
			        host.width - vm.borderMetrics.left - vm.borderMetrics.right -
                        vm.chromeMetrics.left - vm.chromeMetrics.right : NaN,
                !host.isHeightSizedToContent() ? 
                    host.height - vm.borderMetrics.top - vm.borderMetrics.bottom -
                        vm.chromeMetrics.top - vm.chromeMetrics.bottom : NaN);
			
		}
		
		/**
		 * Executes the layout associated with this container. Once the layout has been
		 * run, it may affect the size of the host or may cause the host to present scroll
		 * bars view its viewport.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function performLayout(event:Event):void
		{
			layoutRunning = true;
			
			layoutViewBeforeContentLayout();
			
			var host:UIBase = _strand as UIBase;
			
			var layout:IBeadLayout = _strand.getBeadByType(IBeadLayout) as IBeadLayout;
			if (layout == null) {
				var c:Class = ValuesManager.valuesImpl.getValue(host, "iBeadLayout");
				if (c) {
					layout = new c() as IBeadLayout;
					_strand.addBead(layout);
				}
			}
			
			if (layout) {
				layout.layout();
			}
			
			layoutViewAfterContentLayout();
			
			layoutRunning = false;
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
		protected function layoutViewAfterContentLayout():void
		{
			var host:UIBase = _strand as UIBase;
            var vm:IViewportModel = viewportModel;
            
			adjusting = true;
			
            var viewportSize:Size = viewport.layoutViewportAfterContentLayout();
            
			if (host.isWidthSizedToContent() && host.isHeightSizedToContent()) {					
				host.setWidthAndHeight(viewportSize.width + vm.borderMetrics.left + vm.borderMetrics.right +
                                           vm.chromeMetrics.left + vm.chromeMetrics.right, 
					                   viewportSize.height + vm.borderMetrics.top + vm.borderMetrics.bottom +
                                           vm.chromeMetrics.top + vm.chromeMetrics.bottom,
                                       false);
			}
			else if (!host.isWidthSizedToContent() && host.isHeightSizedToContent())
			{
				host.setHeight(viewportSize.height + vm.borderMetrics.top + vm.borderMetrics.bottom +
                    vm.chromeMetrics.top + vm.chromeMetrics.bottom, false);
			}
			else if (host.isWidthSizedToContent() && !host.isHeightSizedToContent())
			{
				host.setWidth(viewportSize.width + vm.borderMetrics.left + vm.borderMetrics.right +
                    vm.chromeMetrics.left + vm.chromeMetrics.right, false);
			}			
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
		
		protected function displayBackgroundAndBorder(host:UIBase) : void
		{
			var backgroundColor:Object = ValuesManager.valuesImpl.getValue(host, "background-color");
			var backgroundImage:Object = ValuesManager.valuesImpl.getValue(host, "background-image");
			if (backgroundColor != null || backgroundImage != null)
			{
				if (host.getBeadByType(IBackgroundBead) == null)
					var c:Class = ValuesManager.valuesImpl.getValue(host, "iBackgroundBead");
				if (c) {
					host.addBead( new c() as IBead );
				}
			}
			
			var borderStyle:String;
			var borderStyles:Object = ValuesManager.valuesImpl.getValue(host, "border");
			if (borderStyles is Array)
			{
				borderStyle = borderStyles[1];
			}
			if (borderStyle == null)
			{
				borderStyle = ValuesManager.valuesImpl.getValue(host, "border-style") as String;
			}
			if (borderStyle != null && borderStyle != "none")
			{
				if (host.getBeadByType(IBorderBead) == null) {
					c = ValuesManager.valuesImpl.getValue(host, "iBorderBead");
					if (c) {
						host.addBead( new c() as IBead );
					}
				}
			}
		}
	}
}