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
	import flash.display.DisplayObjectContainer;
	
	import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.ContainerBase;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IContainer;
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewport;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.UIMetrics;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.models.ViewportModel;
	import org.apache.flex.html.supportClasses.Border;
	import org.apache.flex.html.supportClasses.ContainerContentArea;
	import org.apache.flex.html.supportClasses.Viewport;
	import org.apache.flex.utils.BeadMetrics;
	
	public class ContainerView extends BeadViewBase implements IBeadView, ILayoutParent
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
			return _contentArea;
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
		public function get viewport():IViewport
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
		
		private var _contentArea:IParentIUIBase;
		private var _viewportModel:IViewportModel;
		private var _viewport:IViewport;
		private var _strand:IStrand;
		
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
			
			_contentArea = createContentView();
			(host as UIBase).addElement(_contentArea,false);
			ContainerBase(host).setActualParent(_contentArea as DisplayObjectContainer);
			
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
		protected function deferredSizeHandler(event:Event):void
		{
			host.removeEventListener(event.type, deferredSizeHandler);
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
			createViewport();
			
			(contentView as UIBase).setWidthAndHeight(viewportModel.contentWidth, viewportModel.contentHeight, true);
			
			host.addEventListener("childrenAdded", childrenChangedHandler);
            childrenChangedHandler(null);
			host.addEventListener("childrenAdded", performLayout);
			host.addEventListener("layoutNeeded", performLayout);
			host.addEventListener("widthChanged", resizeHandler);
			host.addEventListener("heightChanged", resizeHandler);
			host.addEventListener("viewCreated", viewCreatedHandler);
		}
		
		/**
		 * Creates the contentView or actual parent, of the items being contained. This
		 * is done for ActionScript to provide offsets for padding within the host.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function createContentView():IParentIUIBase
		{
			var area:ContainerContentArea = new ContainerContentArea();
			area.className = "ActualParent";
			return area;
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
			resizeViewport();
			
			if ((host as UIBase).numElements > 0) {
				performLayout(null);
			}
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
			if (viewportModel == null) {
				_viewportModel = new ViewportModel();
			}
			
			if (viewport == null) {
				_viewport = _strand.getBeadByType(IViewport) as IViewport;
				if (viewport == null) {
					var c:Class = ValuesManager.valuesImpl.getValue(host, "iViewport");
					if (c)
					{
						_viewport = new c() as IViewport;
						_strand.addBead(viewport);
					}
					else {
						_viewport = new Viewport();
						_strand.addBead(viewport);
					}
				}
				viewport.model = viewportModel;
			}
			
			var metrics:UIMetrics = BeadMetrics.getMetrics(host);
			
			viewportModel.contentArea = contentView;
			viewportModel.contentIsHost = false;
			viewportModel.contentWidth = Math.max(host.width - metrics.left - metrics.right, 0);
			viewportModel.contentHeight = Math.max(host.height - metrics.top - metrics.bottom, 0);
			viewportModel.contentX = metrics.left;
			viewportModel.contentY = metrics.top;
			
			resizeViewport();
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
				determineContentSizeFromChildren();
			}
			
			adjustSizeAfterLayout();
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
		protected function adjustSizeAfterLayout():void
		{
			var host:UIBase = _strand as UIBase;
			var metrics:UIMetrics = BeadMetrics.getMetrics(host);
			
			adjusting = true;
						
			if (host.isWidthSizedToContent() && host.isHeightSizedToContent()) {					
				host.setWidthAndHeight(viewportModel.contentWidth+metrics.left+metrics.right, 
					viewportModel.contentHeight+metrics.top+metrics.bottom, false);
				resizeViewport();
			}
			else if (!host.isWidthSizedToContent() && host.isHeightSizedToContent())
			{
				viewport.needsHorizontalScroller();
				host.setHeight(viewportModel.contentHeight+metrics.top+metrics.bottom, false);
				resizeViewport();
			}
			else if (host.isWidthSizedToContent() && !host.isHeightSizedToContent())
			{
				viewport.needsVerticalScroller();
				host.setWidth(viewportModel.contentWidth+metrics.left+metrics.right, false);
				resizeViewport();
			}
			else {
				viewport.needsScrollers();
				viewport.updateSize();
				viewport.updateContentAreaSize();
			}
			
			adjusting = false;
		}
		
		/**
		 * Determines the size of the contentArea after the layout has been run. The
		 * size of the content area might be used to adjust the size of the host.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function determineContentSizeFromChildren():void
		{
			// pass through all of the children and determine the maxWidth and maxHeight
			// note: this is not done on the JavaScript side because the browser handles
			// this automatically.
			var maxWidth:Number = 0;
			var maxHeight:Number = 0;
			var num:Number = contentView.numElements;
			
			for (var i:int=0; i < num; i++) {
				var child:IUIBase = contentView.getElementAt(i) as IUIBase;
				if (child == null || !child.visible) continue;
				var childXMax:Number = child.x + child.width;
				var childYMax:Number = child.y + child.height;
				maxWidth = Math.max(maxWidth, childXMax);
				maxHeight = Math.max(maxHeight, childYMax);
			}
			
			viewportModel.contentWidth = Math.max(maxWidth,contentView.width);
			viewportModel.contentHeight = Math.max(maxHeight,contentView.height);
		}
		
		/**
		 * Resizes the viewport opening in case the host has been resized.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function resizeViewport():void
		{
			// the viewport takes the entire space as there is no default chrome.
			// if chrome children get added the viewport will need to be adjusted
			// accordingly.
			viewportModel.viewportHeight = host.height;
			viewportModel.viewportWidth = host.width;
			viewportModel.viewportX = 0;
			viewportModel.viewportY = 0;
			
			viewport.updateSize();
			viewport.updateContentAreaSize();
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
			resizeViewport();
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
			var n:Number = contentView.numElements;
			for (var i:int=0; i < n; i++) {
				var child:IUIBase = contentView.getElementAt(i) as IUIBase;
				child.addEventListener("widthChanged", childResizeHandler);
				child.addEventListener("heightChanged", childResizeHandler);
			}
		}
		
		private var resizingChildren:Boolean = false;
		
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
			if (resizingChildren) return;
			resizingChildren = true;
			
			var child:UIBase = event.target as UIBase;
			performLayout(event);
			resizingChildren = false;
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