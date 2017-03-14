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
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
    
	/**
	 *  The GroupView is a bead that manages the layout bead (if any) attached to a Group. This class
	 *  also provides support for background and border styles for a Group on the SWF platform.
     *  
	 *  @viewbead
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
	 */
	public class GroupView extends BeadViewBase implements IBeadView, ILayoutHost
	{
		/**
     	 *  The GroupView class is the default view for
         *  the org.apache.flex.html.Group class.
         *  It lets you use some CSS styles to manage the border, background
         *  and padding around the content area.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function GroupView()
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
			return host as IParentIUIBase;
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
			super.strand = value;
			
			COMPILE::SWF {
				displayBackgroundAndBorder(host as UIBase);
			}
			
			// listen for initComplete to signal that the strand is set with its size
			// and beads.
			host.addEventListener("beadsAdded", beadsAddedHandler);
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
		protected function beadsAddedHandler(event:Event):void
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
			// set up listeners for when children are added or there is a specific request
			// to perform the layout again.
			host.addEventListener("childrenAdded", performLayout);
			host.addEventListener("layoutNeeded", performLayout);
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
			
			layoutRunning = false;
		}
		
		COMPILE::SWF
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
