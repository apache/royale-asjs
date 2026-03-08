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
package org.apache.royale.style.beads
{
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.sendStrandEvent;
	import org.apache.royale.core.Bead;

	/**
	 *  This class is the base class for most, if not all, layouts.
	 *
	 *  @langversion 3.0
	 *  @productversion Royale 0.9.13
	 */
	public class LayoutBase extends Bead implements IBeadLayout
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.13
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
		 *  @productversion Royale 0.9.13
		 */
		protected var host:ILayoutChild;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.13
		 *
		 * @royaleignorecoercion org.apache.royale.core.ILayoutChild
		 */
		override public function set strand(value:IStrand):void
		{
			if (value != _strand)
			{
				if (_strand)
					setListeners(true);
			}
			_strand = value;
			host = value as ILayoutChild;
			if (value)
			{
				setListeners();
			}
		}

		protected function setListeners(off:Boolean = false):void
		{
			listenOnStrand("childrenAdded", handleChildrenAdded, false, off);
			listenOnStrand("initComplete", handleInitComplete, false, off);
			listenOnStrand("layoutNeeded", handleLayoutNeeded, false, off);
		}

		private var lastWidth:Number = -1;
		private var lastHeight:Number = -1;

		/**
		 * Handles the addition of children to the host's layoutView by listening for
		 * size changes in the children.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.13
		 */
		protected function handleChildrenAdded(event:Event):void
		{
			COMPILE::JS
			{
				if (sawInitComplete)
				{
					performLayout();
				}
			}
		}

		/**
		 * Called whenever "layoutNeeded" event is dispatched against the host strand.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.13
		 */
		protected function handleLayoutNeeded(event:Event):void
		{
			performLayout();
		}

		/**
		 * Handles the final start-up condition by running the layout an initial time.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.13
		 */
		protected function handleInitComplete(event:Event):void
		{
			sawInitComplete = true;
			COMPILE::JS
			{
				// always run layout since there are no size change events
				performLayout();
			}
		}

		/**
		 * Returns the ILayoutView for the host.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.13
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
		 *  @productversion Royale 0.9.13
		 * @royaleignorecoercion org.apache.royale.core.ILayoutParent
		 */
		public function performLayout():void
		{
			// avoid running this layout instance recursively.
			if (isLayoutRunning)
				return;

			isLayoutRunning = true;

			var viewBead:ILayoutHost = (host as ILayoutParent).getLayoutHost();
			if (viewBead.beforeLayout())
			{
				if (layout())
				{
					viewBead.afterLayout();
				}
			}

			isLayoutRunning = false;

			sendStrandEvent(_strand, "layoutComplete");

		}

		/**
		 * @copy org.apache.royale.core.IBeadLayout#layout
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.13
		 */
		public function layout():Boolean
		{
			// override in subclass
			return false;
		}
	}
}
