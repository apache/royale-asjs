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
		 *  The actual parent that parents the children.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */        
		protected var actualParent:UIBase;
		
		/**
		 * @private
		 */
		private var viewportModel:IViewportModel;
		
		private var _viewport:IViewport;
		
		/**
		 * The Viewport used to manage the display of the content area.
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
		public function set viewport(value:IViewport):void
		{
			_viewport = value;
		}
		
		private var _strand:IStrand;
        
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
			super.strand = value;
			
			_strand = value;
			
			var host:UIBase = value as UIBase;
			
			// determines if an offset child will act as the parent; this
			// happens when there is padding or chrome elements.
			checkActualParent(false);
			
			createViewport(getMetrics());
			
			if (!host.isWidthSizedToContent() && !host.isHeightSizedToContent()) {
				displayBackgroundAndBorder(host);
			}
			
			host.addEventListener("childrenAdded", changeHandler);
			host.addEventListener("layoutNeeded", changeHandler);
			host.addEventListener("widthChanged", resizeHandler);
			host.addEventListener("heightChanged", resizeHandler);
		}
		
		/**
		 * Creates and initializes the Viewport. Subclasses can override this to
		 * reposition the Viewport, via the Viewport's model, to suit their needs. 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
		 */
		protected function createViewport(metrics:UIMetrics):void
		{
			if (viewportModel == null) {
				viewportModel = new ViewportModel();
			}
			
			// the viewport takes the entire space as there is no default chrome.
			// if chrome children get added the viewport will need to be adjusted
			// accordingly.
			viewportModel.viewportHeight = host.height;
			viewportModel.viewportWidth = host.width;
			viewportModel.viewportX = 0;
			viewportModel.viewportY = 0;
			
			// default the content area to match the viewport's size. later, the
			// viewport will resize and position the contentArea if needed.
			viewportModel.contentHeight = viewportModel.viewportHeight - metrics.top - metrics.bottom;
			viewportModel.contentWidth = viewportModel.viewportWidth - metrics.left - metrics.right;
			viewportModel.contentX = viewportModel.viewportX + metrics.left;
			viewportModel.contentY = viewportModel.viewportY + metrics.top;
			
			viewportModel.contentArea = actualParent;
			viewportModel.contentIsHost = actualParent == UIBase(_strand);
			
			if (viewport == null) {
				viewport = _strand.getBeadByType(IViewport) as IViewport;
				if (viewport == null) {
					var c:Class = ValuesManager.valuesImpl.getValue(host, "iViewport");
					if (c)
					{
						viewport = new c() as IViewport;
						_strand.addBead(viewport);
					}
					else {
						viewport = new Viewport();
						_strand.addBead(viewport);
					}
				}
				viewport.model = viewportModel;
			}
		}
		
				
		/**
		 * Event handler invoked whenever the size or children are added/removed
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		protected function changeHandler(event:Event):void
		{
			var host:UIBase = UIBase(_strand);
			
			// add the layout to the viewport if not done so already
			if (viewportModel.layout == null)
			{
				viewportModel.layout = _strand.getBeadByType(IBeadLayout) as IBeadLayout;
				if (viewportModel.layout == null)
				{
					var c:Class = ValuesManager.valuesImpl.getValue(host, "iBeadLayout");
					if (c)
					{
						viewportModel.layout = new c() as IBeadLayout;
						_strand.addBead(viewportModel.layout);
					}
				}
			}
			
			// Run the layout which will not only size and position the children
			// of the contentArea (actualParent), but will also change the viewport
			// model's content size properties. 
			if (viewport.runLayout()) 
			{
				// remove size change handlers so that any size changes internally
				// are not picked up and processed which could result in an infinite
				// chain of events.
//				host.removeEventListener("widthChanged", resizeHandler);
//				host.removeEventListener("heightChanged", resizeHandler);
				
				handleContentResize();
				
//				host.addEventListener("widthChanged", resizeHandler);
//				host.addEventListener("heightChanged", resizeHandler);
			}			
			
			// update the contentArea so that it exposes all of the items as placed
			// by the layout.
			viewport.updateContentAreaSize();
			
			displayBackgroundAndBorder(host);
		}
		
		/**
		 * This function guides the resizing of the container and/or its viewport,
		 * depending on the constraints on the container's size (being sized by
		 * its content or sized externally).
		 */
		protected function handleContentResize():void
		{
			var host:UIBase = UIBase(_strand);
			var metrics:UIMetrics = getMetrics();
			
			// If the host is being sized by its content, the change in the contentArea
			// causes the host's size to change
			if (host.isWidthSizedToContent() && host.isHeightSizedToContent()) {					
				host.setWidthAndHeight(viewportModel.contentWidth, viewportModel.contentHeight, true);
				
				viewportModel.viewportHeight = viewportModel.contentHeight + metrics.top + metrics.bottom;
				viewportModel.viewportWidth  = viewportModel.contentWidth + metrics.left + metrics.right;
			}
				
			// if the width is fixed and the height is changing, then set up horizontal
			// scrolling (if the viewport supports it).
			else if (!host.isWidthSizedToContent() && host.isHeightSizedToContent())
			{
				viewport.needsHorizontalScroller();
				
				host.setHeight(viewportModel.contentHeight, false);
				viewportModel.viewportHeight = viewportModel.contentHeight + metrics.top + metrics.bottom;
				
			}
				
			// if the height is fixed and the width can change, then set up
			// vertical scrolling (if the viewport supports it).
			else if (host.isWidthSizedToContent() && !host.isHeightSizedToContent())
			{
				viewport.needsVerticalScroller();
				
				host.setWidth(viewportModel.contentWidth+viewport.scrollerWidth(), false);
				viewportModel.viewportWidth = viewportModel.contentWidth + metrics.left + metrics.right + viewport.scrollerWidth();
			}
				
			// Otherwise the viewport needs to display some scrollers (or other elements
			// allowing the rest of the contentArea to be visible)
			else {
				
				viewport.needsScrollers();
			}
		}
		
		/**
		 * @private
		 */
		protected function resizeHandler(event:Event):void
		{
			var host:UIBase = UIBase(_strand);
			
			// the viewport has to be adjusted to account for the change
			// in the host size.			
			viewportModel.viewportHeight = host.height;
			viewportModel.viewportWidth = host.width;
			
			// if the host has a fixed width, reset the contentWidth to match.
			if (!host.isWidthSizedToContent()) viewportModel.contentWidth = host.width;
			
			// if the host has a fixed height, reset the contentHeight to match.
			if (!host.isHeightSizedToContent()) viewportModel.contentHeight = host.height;
			
			// the viewport's size and position also has to be adjusted since the
			// host's size has changed.
			viewport.updateSize();
			
			// the layout needs to be run to adjust the content for 
			// the new host size.
			changeHandler(event);
		}
		
		/**
		 * @private
		 */
		protected function checkActualParent(force:Boolean=false):Boolean
		{
			var host:UIBase = UIBase(_strand);
			if (contentAreaNeeded() || force)
			{
				if (actualParent == null || actualParent == host)
				{
					actualParent = new ContainerContentArea();
					actualParent.className = "ActualParent";
					host.addElement(actualParent, false);
					ContainerBase(host).setActualParent(actualParent);
				}
				return true;
			}
			else
			{
				actualParent = host;
			}
			return false;
		}
		
		/**
		 *  Returns true if container to create a separate ContainerContentArea.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function contentAreaNeeded():Boolean
		{
			var metrics:UIMetrics = getMetrics();
			
			return (!isNaN(metrics.left) && metrics.left > 0 ||
				!isNaN(metrics.top) && metrics.top > 0);
		}
		
		/**
		 * Returns the metrics (border, padding) of the strand.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function getMetrics():UIMetrics
		{
			return BeadMetrics.getMetrics(_strand);
		}
		
		/**
		 *  The parent of the children.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get contentView():IParentIUIBase
		{
			return actualParent;
		}
		
		/**
		 *  The host component, which can resize to different slots.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get resizableView():IUIBase
		{
			return _strand as IUIBase;
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
		
        private var inGetViewHeight:Boolean;
        
		/**
		 *  @copy org.apache.flex.core.IBeadView#viewHeight
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function get viewHeight():Number
		{
            if (inGetViewHeight)
            {
                //trace("ContainerView: no height set for " + host);
                return host["$height"];
            }
            inGetViewHeight = true;
			var vh:Number = contentView.height;
            inGetViewHeight = false;
            return vh;
		}
		
        private var inGetViewWidth:Boolean;
        
		/**
		 *  @copy org.apache.flex.core.IBeadView#viewWidth
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function get viewWidth():Number
		{
            if (inGetViewWidth)
            {
                //trace("ContainerView: no width set for " + host);
				var metrics:UIMetrics = getMetrics();
                return host["$width"] + metrics.left + metrics.right;
            }
            inGetViewWidth = true;
			var vw:Number = contentView.width;
            inGetViewWidth = false;
			return vw;
		}
	}
}