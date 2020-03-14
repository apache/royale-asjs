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
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.loadBeadFromValuesManager;

	COMPILE::SWF {
		import org.apache.royale.geom.Size;
	}

	/**
	 *  The GroupView is a bead that manages the layout bead (if any) attached to a Group. This class
	 *  also provides support for background and border styles for a Group on the SWF platform.
     *
	 *  @viewbead
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
	 */
	public class GroupView extends BeadViewBase implements IBeadView, ILayoutHost
	{
		/**
     	 *  The GroupView class is the default view for
         *  the org.apache.royale.html.Group class.
         *  It lets you use some CSS styles to manage the border, background
         *  and padding around the content area.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.core.ILayoutView
		 */
		public function get contentView():ILayoutView
		{
			return host as ILayoutView;
		}

		/**
		 * The view that can be resized.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			COMPILE::SWF {
				displayBackgroundAndBorder(host as UIBase);
			}

			// listen for initComplete to signal that the strand has been initialized
			// with its beads and children.
			host.addEventListener("initComplete", handleInitComplete);
		}

		/**
		 * Handles the initComplete event by completing the setup and kicking off the
		 * presentation of the contents.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.core.ILayoutChild
		 */
		protected function handleInitComplete(event:Event):void
		{
            var ilc:ILayoutChild = host as ILayoutChild;
			// Complete the setup if the height is sized to content or has been explicitly set
            // and the width is sized to content or has been explicitly set
			if ((ilc.isHeightSizedToContent() || !isNaN(ilc.explicitHeight) || !isNaN(ilc.percentHeight)) &&
                (ilc.isWidthSizedToContent() || !isNaN(ilc.explicitWidth) || !isNaN(ilc.percentWidth))) {
				completeSetup();
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
		 *  @productversion Royale 0.8
		 */
		protected function deferredSizeHandler(event:Event):void
		{
            host.removeEventListener("sizeChanged", deferredSizeHandler);
            host.removeEventListener("widthChanged", deferredSizeHandler);
            host.removeEventListener("heightChanged", deferredSizeHandler);
			
			completeSetup();
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
		protected function completeSetup():void
		{
			// listen for changes to strand's size and rerun the layout
			host.addEventListener("sizeChanged", resizeHandler);
			host.addEventListener("widthChanged", resizeHandler);
			host.addEventListener("heightChanged", resizeHandler);
		}
		
		/**
		 * Invoked in response to the strand being resized.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		protected function resizeHandler(event:Event):void
		{
			// override in subclasses in case there is something besides running
			// the layout (which is handled automatically by the layout itself).
		}
		
		/**
		 * Provides a place for pre-layout actions.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function beforeLayout():Boolean
		{
			// This has no use for Group but is here so a subclass can override it.
			return true;
		}

		/**
		 * Executes the layout associated with this container. Once the layout has been
		 * run, it may affect the size of the host or may cause the host to present scroll
		 * bars view its viewport.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		protected function performLayout(event:Event):void
		{
			// trace("CALLING performLayout !!!!");
		}

		/**
		 * Returns the size of the content area including the padding.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 */
		COMPILE::SWF
		protected function calculateContentSize():Size
		{
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

			var padding:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPaddingMetrics(this._strand as IUIBase);
			var border:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(this._strand as IUIBase);

			// return the content size as the max plus right/bottom padding. the x,y position of
			// each child is already offset by the left/top padding by the layout algorithm.
			return new Size(maxWidth + padding.right - (border.left+border.right), maxHeight + padding.bottom - (border.top+border.bottom));
		}

		/**
		 * Adjusts the size of the host after the layout has been run.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 */
		COMPILE::SWF
		public function afterLayout():void
		{
			var host:UIBase = _strand as UIBase;
			var contentSize:Size = calculateContentSize();
			var border:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(this._strand as IUIBase);
			contentSize.width += border.left + border.right;
			contentSize.height += border.top + border.bottom;
			var padding:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPaddingMetrics(this._strand as IUIBase);
			// add padding.left since it wasn't considered in contentSize,
			// and add border.right so the border can be drawn in that column of pixels
			contentSize.width += padding.left + border.right; 
			contentSize.height += padding.top + border.top;
			

			if (host.isWidthSizedToContent() && host.isHeightSizedToContent()) {
				host.setWidthAndHeight(contentSize.width, contentSize.height, true);
			}
			else if (!host.isWidthSizedToContent() && host.isHeightSizedToContent())
			{
				host.setHeight(contentSize.height, true);
			}
			else if (host.isWidthSizedToContent() && !host.isHeightSizedToContent())
			{
				host.setWidth(contentSize.width, true);
			}
		}
		
		COMPILE::JS
		public function afterLayout():void
		{
			// maybe useful in a subclass on the JS side.
		}

		/**
		 * @private
         * @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 */
		COMPILE::SWF
		protected function displayBackgroundAndBorder(host:UIBase) : void
		{
			var backgroundColor:Object = ValuesManager.valuesImpl.getValue(host, "background-color");
			var backgroundImage:Object = ValuesManager.valuesImpl.getValue(host, "background-image");
			if (backgroundColor != null || backgroundImage != null)
			{
				loadBeadFromValuesManager(IBackgroundBead, "iBackgroundBead", _strand);
			}
			
            var border:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(this._strand as IUIBase);
			if (border.left + border.right + border.top + border.bottom > 0)
			{
				loadBeadFromValuesManager(IBorderBead, "iBorderBead", _strand);
			}
		}
	}
}
