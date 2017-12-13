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
package org.apache.royale.core
{

	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.Event;
    import org.apache.royale.utils.CSSUtils;

    /**
     *  This class is the base class for most, if not all, layouts. 
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
	public class LayoutBase implements IBeadLayout
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
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
		public function set strand(value:IStrand):void
		{
            host = value as ILayoutChild;
            var sizeChange:Function = handleSizeChange;
            (value as IEventDispatcher).addEventListener("widthChanged", sizeChange);
            (value as IEventDispatcher).addEventListener("heightChanged", sizeChange);
            (value as IEventDispatcher).addEventListener("sizeChanged", sizeChange);

            (value as IEventDispatcher).addEventListener("childrenAdded", handleChildrenAdded);
            (value as IEventDispatcher).addEventListener("initComplete", handleInitComplete);
            (value as IEventDispatcher).addEventListener("layoutNeeded", handleLayoutNeeded);

		}
		
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
			performLayout();
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
		 */
		protected function childMargins(child:Object, hostWidth:Number, hostHeight:Number):Object
		{
			var margin:Object = ValuesManager.valuesImpl.getValue(child, "margin");
			var marginLeft:Object = ValuesManager.valuesImpl.getValue(child, "margin-left");
			var marginTop:Object = ValuesManager.valuesImpl.getValue(child, "margin-top");
			var marginRight:Object = ValuesManager.valuesImpl.getValue(child, "margin-right");
			var marginBottom:Object = ValuesManager.valuesImpl.getValue(child, "margin-bottom");
			var ml:Number = CSSUtils.getLeftValue(marginLeft, margin, hostWidth);
			var mr:Number = CSSUtils.getRightValue(marginRight, margin, hostWidth);
			var mt:Number = CSSUtils.getTopValue(marginTop, margin, hostHeight);
			var mb:Number = CSSUtils.getBottomValue(marginBottom, margin, hostHeight);
			if (marginLeft == "auto")
				ml = 0;
			if (marginRight == "auto")
				mr = 0;
			if (margin == "auto")
			    ml = mr = mt = mb = 0;
			
			return {left:ml, top:mt, right:mr, bottom:mb, auto: (marginLeft == "auto" && marginRight == "auto") || margin == "auto"};
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
		 */
		protected function childPositions(child:Object):Object
		{
			var left:Number = ValuesManager.valuesImpl.getValue(child, "left");
			var right:Number = ValuesManager.valuesImpl.getValue(child, "right");
			var top:Number = ValuesManager.valuesImpl.getValue(child, "top");
			var bottom:Number = ValuesManager.valuesImpl.getValue(child, "bottom");
			
			return {top:top, left:left, bottom:bottom, right:right};
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
		
		private var isLayoutRunning:Boolean = false;
		
		/**
		 * Performs the layout in three parts: before, layout, after.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
		 */
		public function performLayout():void
		{
			// avoid running this layout instance recursively.
			if (isLayoutRunning) return;
			
			isLayoutRunning = true;

			var oldWidth:Number = host.width;
			var oldHeight:Number = host.height;
			
			var viewBead:ILayoutHost = (host as ILayoutParent).getLayoutHost();
			
			viewBead.beforeLayout();
			
			if (layout()) {
				viewBead.afterLayout();
			}
			
			isLayoutRunning = false;
			
			IEventDispatcher(host).dispatchEvent(new Event("layoutComplete"));
			
			// check sizes to see if layout changed the size or not
			// and send an event to re-layout parent of host
			if (host.width != oldWidth ||
			    host.height != oldHeight)
			{
				isLayoutRunning = true;
				host.dispatchEvent(new Event("sizeChanged"));
				isLayoutRunning = false;
			}

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
