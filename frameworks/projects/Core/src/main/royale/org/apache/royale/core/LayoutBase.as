////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//	  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.core
{
	COMPILE::SWF
	{
	import org.apache.royale.events.IEventDispatcher;
	}
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.layout.MarginData;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.sendStrandEvent;

	/**
	 *  This class is the base class for most, if not all, layouts. 
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class LayoutBase extends Bead implements IBeadLayout
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function LayoutBase()
		{
		}

		private var sawInitComplete:Boolean;
		
		/**
		 * The strand/host container is also an ILayoutChild because
		 * it can have its size dictated by the host's parent which is
		 * important to know for layout optimization.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		protected var host:ILayoutChild;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 * 
		 * @royaleignorecoercion org.apache.royale.core.ILayoutChild
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			host = value as ILayoutChild;
			listenOnStrand("widthChanged", handleSizeChange);
			listenOnStrand("heightChanged", handleSizeChange);
			listenOnStrand("sizeChanged", handleSizeChange);

			listenOnStrand("childrenAdded", handleChildrenAdded);
			listenOnStrand("initComplete", handleInitComplete);
			listenOnStrand("layoutNeeded", handleLayoutNeeded);

		}
		
		private var lastWidth:Number = -1;
		private var lastHeight:Number = -1;
		
		/**
		 * Changes in size to the host strand are handled (by default) by running the
		 * layout sequence. Subclasses can override this function and use event.type
		 * to handle specific changes in dimension.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		protected function handleSizeChange(event:Event):void
		{
			if (host.width == lastWidth &&
				host.height == lastHeight) return;
			performLayout();
			lastWidth = host.width;
			lastHeight = host.height;
		}
		
		/**
		 * Handles the addition of children to the host's layoutView by listening for
		 * size changes in the children.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		protected function handleChildrenAdded(event:Event):void
		{
			COMPILE::SWF {
				if (sawInitComplete)
				{
					performLayout();
				}
				else
				{
					var n:Number = layoutView.numElements;
					for(var i:int=0; i < n; i++) {
						var child:IEventDispatcher = layoutView.getElementAt(i) as IEventDispatcher;
						child.addEventListener("widthChanged", childResizeHandler);
						child.addEventListener("heightChanged", childResizeHandler);
						child.addEventListener("sizeChanged", childResizeHandler);
					}
				}
			}
			COMPILE::JS {
				if (sawInitComplete) {
					performLayout();
				}
			}
		}
		
		/**
		 * If changes happen to a layoutView's child, this function will perform the
		 * layout again.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.core.ILayoutParent
		 */
		protected function childResizeHandler(event:Event):void
		{
			var viewBead:ILayoutHost;
			
			// don't layout in response to child size changes if sized by parent
			// or explicitly sized
			if (event.type == "widthChanged" && 
				!(host.isWidthSizedToContent() || !isNaN(host.explicitWidth)))
			{
				// but do call this to update scrolling viewports
				viewBead = (host as ILayoutParent).getLayoutHost();
				viewBead.beforeLayout();
				viewBead.afterLayout();
				return;
			}
			// don't layout in response to child size changes if sized by parent
			// or explicitly sized
			if (event.type == "heightChanged" && 
				!(host.isHeightSizedToContent() || !isNaN(host.explicitHeight)))
			{
				// but do call this to update scrolling viewports
				viewBead = (host as ILayoutParent).getLayoutHost();
				viewBead.beforeLayout();
				viewBead.afterLayout();
				return;
			}
			// don't layout in response to child size changes if sized by parent
			// or explicitly sized
			if (event.type == "sizeChanged" && 
				!(host.isHeightSizedToContent() || !isNaN(host.explicitHeight)) &&
				!(host.isWidthSizedToContent() || !isNaN(host.explicitWidth)))
			{
				// but do call this to update scrolling viewports
				viewBead = (host as ILayoutParent).getLayoutHost();
				viewBead.beforeLayout();
				viewBead.afterLayout();
				return;
			}
			performLayout();
		}
		
		/**
		 * Called whenever "layoutNeeded" event is dispatched against the host strand.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		protected function handleLayoutNeeded(event:Event):void
		{
			performLayout();
		}
		
		/**
		 * Handles the final start-up condition by running the layout an initial time.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		protected function handleInitComplete(event:Event):void
		{
			sawInitComplete = true;
			
			COMPILE::SWF
			{
			// Complete the setup if the height is sized to content or has been explicitly set
			// and the width is sized to content or has been explicitly set
			if ((host.isHeightSizedToContent() || !isNaN(host.explicitHeight)) &&
				(host.isWidthSizedToContent() || !isNaN(host.explicitWidth)))
				performLayout();
			}
			COMPILE::JS
			{
				// always run layout since there are no size change events
				performLayout();
			}
		}
		
		/**
		 * Returns an object of margins for the given child.
		 * 
		 * @param child Object The element whose margins are required.
		 * @param hostWidth Number The usable width dimension of the host.
		 * @param hostHeight Number The usable height dimension of the host.
		 * 
		 * @return Object A structure of {top:Number, left:Number, bottom:Number, right:Number}
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		protected function childMargins(child:Object, hostWidth:Number, hostHeight:Number):MarginData
		{
			var md:MarginData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getMargins(child as IUIBase, hostWidth, hostHeight);
			return md;
		}
		
		/**
		 * Returns an object containing the child's positioning values.
		 * 
		 * @param child Object The element whose positions are required.
		 * 
		 * @return Object A structure of {top:Number, left:Number, bottom:Number, right:Number}
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		protected function childPositions(child:Object):EdgeData
		{
			var ed:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPositions(child as IUIBase);
			return ed;
		}
		
		/**
		 * Returns the ILayoutView for the host.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 * 
		 * @royaleignorecoercion org.apache.royale.core.ILayoutParent
		 */
		protected function get layoutView():ILayoutView
		{
			var viewBead:ILayoutHost = (host as ILayoutParent).getLayoutHost();
			return viewBead.contentView;
		}
		
		protected var isLayoutRunning:Boolean = false;
		
		/**
		 * Performs the layout in three parts: before, layout, after.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 * @royaleignorecoercion org.apache.royale.core.ILayoutParent
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function performLayout():void
		{
			// avoid running this layout instance recursively.
			if (isLayoutRunning) return;
			
			isLayoutRunning = true;
			/* Not all components need measurement
			COMPILE::SWF
			{
				host.measuredHeight = host.height;
				host.measuredWidth = host.width;
			}
			*/
			
			var viewBead:ILayoutHost = (host as ILayoutParent).getLayoutHost();
			
			if (viewBead.beforeLayout())
			{
				if (layout()) {
					viewBead.afterLayout();
				}
			}
			
			isLayoutRunning = false;
			
			sendStrandEvent(_strand,"layoutComplete");
			
			/* measurement may not matter for all components
			COMPILE::SWF
			{
				// check sizes to see if layout changed the size or not
				// and send an event to re-layout parent of host
				if (host.width != host.measuredWidth ||
					host.height != host.measuredHeight)
				{
					isLayoutRunning = true;
					host.dispatchEvent(new Event("sizeChanged"));
					isLayoutRunning = false;
				}
			}
			*/

		}

		/**
		 * @copy org.apache.royale.core.IBeadLayout#layout
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function layout():Boolean
		{
			// override in subclass
			return false;
		}
	}
}
