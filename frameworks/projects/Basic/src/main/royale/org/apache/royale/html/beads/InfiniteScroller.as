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
	import org.apache.royale.core.DispatcherBead;
	import org.apache.royale.events.Event;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IStrand;


	/**
	 * The scrollEnd event is dispatched when the last item render scrolls into view.
	 *
	 *  @langversion 3.0
	 *  @productversion Royale 0.9.10
	 */
	[Event(name="scrollEnd", type="org.apache.royale.events.Event")]
	/**
	 * The InfiniteScroller class is a Javascript-only bead that can be used with a List to
	 * dispatch a scrollEnd event when the last item renderer scrolls into view.
	 * This can be used to implement infinite scrolling.
	 * 
	 * This bead requires that the strand has a view which is an IItemRendererOwnerView.
	 * 
	 * By default, the strand is used as the container to be scrolled. This can be
	 * changed by setting the scrollContainer property.
	 * 
	 * The margin property can be used to trigger the scrollEnd event before the last
	 * item renderer is completely scrolled into view. The default is 0.
	 * 
	 * The threshold property can be used to trigger the scrollEnd event when a percentage
	 * of the last item renderer is visible. The default is 0.
	 * 
	 * The bead uses the IntersectionObserver API to detect when the last item renderer
	 * is scrolled into view. This API is not supported in all browsers. If the browser
	 * does not support it, the scrollEnd event will never be dispatched.
	 * Please check https://caniuse.com/intersectionobserver for browser support.
	 * 
	 * 
	 *  @langversion 3.0
	 *  @productversion Royale 0.9.10
	 */
	public class InfiniteScroller extends DispatcherBead
	{
		public function InfiniteScroller(scrollContainer:IParentIUIBase = null)
		{
			super();
			this.scrollContainer = scrollContainer;
			COMPILE::SWF
			{
				throw new Error("InfiniteScroller is not supported on SWF platforms.");
			}
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		private function get host():IUIBase
		{
			return _strand as IUIBase;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
		 * @royaleignorecoercion org.apache.royale.core.IItemRendererOwnerView
		 */
		private function get view():IItemRendererOwnerView
		{
			assert(_strand is IStrandWithModelView, "InfiniteScroller requires a strand with a model view.");
			assert((_strand as IStrandWithModelView).view is IItemRendererOwnerView, "InfiniteScroller requires a strand with a view that is an IItemRendererOwnerView.");
			return (_strand as IStrandWithModelView).view as IItemRendererOwnerView;
		}
		COMPILE::JS
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			listenOnStrand("itemAdded", handleItemAdded);
		}

		COMPILE::JS
		private function handleItemAdded(event:ValueEvent):void{
			if(pendingObserve){
				return;
			}
			pendingObserve = true;
			requestAnimationFrame(observeLastItem);
		}

		private var pendingObserve:Boolean;

		private var _scrollContainer:IParentIUIBase;
		/**
		 * The container that will be scrolled. By default this will be the strand.
		 */
		public function get scrollContainer():IParentIUIBase
		{
			return _scrollContainer;
		}

		public function set scrollContainer(value:IParentIUIBase):void
		{
			_scrollContainer = value;
		}

		/**
		 * The number of pixels from the bottom of the scroller that will
		 * trigger the scrollEnd event. The default is 0.
		 */
		public var margin:Number = 0;

		/**
		 * A number between 0 and 1. 0 means if any pixels are visible.
		 * 1 means completely visible. The default is 0.
		 */
		public var threshold:Number = 0;

		private var observer:Object;
		private var observedItem:IItemRenderer;

		COMPILE::JS
		private function observeLastItem():void{
			pendingObserve = false;
			if(!observer){
				var element:HTMLElement = scrollContainer? scrollContainer.element : host.element;
				observer = new IntersectionObserver(handleItemIntersection, {
					root: element,
					rootMargin: isNaN(margin) ? "0px" : margin + "px",
					threshold: threshold
				});
			}
			unobserveItem();
			
			observedItem = view.getItemRendererAt(view.numItemRenderers - 1);
			if(observedItem && observedItem.element){
				observer.observe(observedItem.element);
			}
		}
		COMPILE::JS
		private function unobserveItem():void{
			if(!observedItem){
				return;
			}
			if(!observer){
				return;
			}
			observer.unobserve(observedItem.element);
			observedItem = null;
		}
		COMPILE::JS
		private function handleItemIntersection(entries:Array):void{
			if(!entries.length){
				return;
			}
			var entry:Object = entries[0];
			if(entry.isIntersecting){
				unobserveItem();
				dispatchEvent(new Event("scrollEnd"));
			}
		}
	}
}