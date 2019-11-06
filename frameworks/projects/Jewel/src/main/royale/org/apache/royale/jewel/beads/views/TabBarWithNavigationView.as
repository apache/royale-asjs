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
package org.apache.royale.jewel.beads.views
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.jewel.Button;
	import org.apache.royale.jewel.TabBar;
	import org.apache.royale.core.IChild;
	import org.apache.royale.jewel.supportClasses.Viewport;

	COMPILE::JS
	{
		import org.apache.royale.events.Event;
		import org.apache.royale.jewel.itemRenderers.TabBarButtonItemRenderer;
		import org.apache.royale.core.WrappedHTMLElement;
	}

	/**
	 *  The TabBarWithNavigationView class creates additional buttons to navigate trough
	 *  tabs if they went outside available visible area.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class TabBarWithNavigationView extends TabBarView
	{
		/**
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function TabBarWithNavigationView()
		{
			super();
		}

		private static const TAB_BAR_SCROLL:int = 200;

		private var host:TabBar;

		protected var arrowLeft:Button;
		protected var arrowRight:Button;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			this.host = value as TabBar;
		}

		/**
		 *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		override protected function handleInitComplete(event:Event):void
		{
			super.handleInitComplete(event);
			COMPILE::JS
			{
				arrowLeft = new Button();
				arrowLeft.text = "<";
				arrowLeft.visible = false;
				arrowLeft.height = 45;
				arrowLeft.className = "tabbarnavleftbutton";
				arrowLeft.addEventListener("click", arrowLeftClickHandler);

				host.royale_wrapper.addElementAt(arrowLeft, 0);
				var children:Object = host.positioner.children;

				if (children && children.length > 0)
				{
					host.positioner.insertBefore(arrowLeft.element as WrappedHTMLElement, children[0]);
				}
				else
				{
					host.positioner.appendChild(arrowLeft.element as WrappedHTMLElement);
				}

				arrowRight = new Button();
				arrowRight.text = ">";
				arrowRight.visible = false;
				arrowRight.height = 45;
				arrowRight.className = "tabbarnavrighttbutton";
				arrowRight.addEventListener("click", arrowRightClickHandler);

				host.royale_wrapper.addElement(arrowRight);
				host.positioner.appendChild(arrowRight.element as WrappedHTMLElement);

				window.addEventListener('resize', this.windowResizeHandler, false);

				var viewPort:Viewport = host.getBeadByType(Viewport) as Viewport;
				viewPort.contentView.element.style.overflow = "hidden";

				this.host.percentWidth = 100;

				setTimeout(refreshNavigationButtonVisibility, 100);
			}
		}

		protected function arrowLeftClickHandler(event:Event):void
		{
			this.host.positioner.scrollLeft -= TAB_BAR_SCROLL;
			refreshNavigationButtonVisibility();
		}

		protected function arrowRightClickHandler(event:Event):void
		{
			this.host.positioner.scrollLeft += TAB_BAR_SCROLL;
			refreshNavigationButtonVisibility();
		}

		private function windowResizeHandler(event:Event):void
		{
			refreshNavigationButtonVisibility();
		}

		private function refreshNavigationButtonVisibility():void
		{
			if (this.host.positioner.scrollLeft > 0)
			{
				arrowLeft.visible = true;
			}
			else
			{
				arrowLeft.visible = false;
			}

			if (this.host.positioner.scrollLeft < this.host.positioner.scrollWidth - this.host.positioner.offsetWidth)
			{
				arrowRight.visible = true;
			}
			else
			{
				arrowRight.visible = false;
			}
		}
	}
}
