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
		
		public function get contentView():IParentIUIBase
		{
			return _contentArea;
		}
		
		public function get resizableView():IUIBase
		{
			return host;
		}
		
		public function get viewport():IViewport
		{
			return _viewport;
		}
		
		public function get viewportModel():IViewportModel
		{
			return _viewportModel;
		}
		
		private var _contentArea:IParentIUIBase;
		private var _viewportModel:IViewportModel;
		private var _viewport:IViewport;
		private var _strand:IStrand;
		
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;
			
			_contentArea = createContentView();
			(host as UIBase).addElement(_contentArea,false);
			ContainerBase(host).setActualParent(_contentArea as DisplayObjectContainer);
			
			createViewport();
			
			displayBackgroundAndBorder(host as UIBase);
			
			if (isNaN((host as UIBase).percentHeight) && isNaN((host as UIBase).percentWidth)) {
				completeSetup();
				IEventDispatcher(_strand).dispatchEvent( new Event("viewCreated") );
			}
			else {
				host.addEventListener("sizeChanged", deferredSizeHandler);
			}
		}
		
		protected function createContentView():IParentIUIBase
		{
			var area:ContainerContentArea = new ContainerContentArea();
			area.className = "ActualParent";
			return area;
		}
		
		protected function deferredSizeHandler(event:Event):void
		{
			host.removeEventListener(event.type, deferredSizeHandler);
			
			completeSetup();
			IEventDispatcher(_strand).dispatchEvent( new Event("viewCreated") );
		}
		
		protected function completeSetup():void
		{
			(contentView as UIBase).setWidthAndHeight(host.width, host.height, true);
			
			host.addEventListener("childrenAdded", childrenChangedHandler);
			host.addEventListener("childrenAdded", performLayout);
			host.addEventListener("layoutNeeded", performLayout);
			host.addEventListener("widthChanged", resizeHandler);
			host.addEventListener("heightChanged", resizeHandler);
			host.addEventListener("viewCreated", viewCreatedHandler);
		}
		
		protected function viewCreatedHandler(event:Event):void
		{
			resizeViewport();
			
			if ((host as UIBase).numElements > 0) {
				performLayout(null);
			}
		}
		
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
			
			viewportModel.contentArea = contentView;
			viewportModel.contentIsHost = false;
			
			resizeViewport();
		}
		
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
			}
			
			adjustSizeAfterLayout();
		}
		
		protected function adjustSizeAfterLayout():void
		{
			var host:UIBase = _strand as UIBase;
			
			if (host.isWidthSizedToContent() && host.isHeightSizedToContent()) {					
				host.setWidthAndHeight(viewportModel.contentWidth, viewportModel.contentHeight, true);
				resizeViewport();
			}
			else if (!host.isWidthSizedToContent() && host.isHeightSizedToContent())
			{
				viewport.needsHorizontalScroller();
				host.setHeight(viewportModel.contentHeight, false);
				resizeViewport();
			}
			else if (host.isWidthSizedToContent() && !host.isHeightSizedToContent())
			{
				viewport.needsVerticalScroller();
				host.setWidth(viewportModel.contentWidth, false);
				resizeViewport();
			}
			else {
				viewport.needsScrollers();
				viewport.updateSize();
				viewport.updateContentAreaSize();
			}
		}
		
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
		
		protected function resizeHandler(event:Event):void
		{
			resizeViewport();
			if (event.target != this.resizableView) {
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
				if (host.isWidthSizedToContent()) {
					child.addEventListener("widthChanged",childResizeHandler);
				}
				if (host.isHeightSizedToContent()) {
					child.addEventListener("heightChanged",childResizeHandler);
				}
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
		
		override public function get viewWidth():Number
		{
			return 0;
		}
		
		override public function get viewHeight():Number
		{
			return 0;
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