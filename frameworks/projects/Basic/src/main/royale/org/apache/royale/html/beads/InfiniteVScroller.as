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
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.EventDispatcher;

	/**
	 * The scrollEnd event is dispatched scrolled to the bottom.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
    [Event(name="scrollEnd", type="org.apache.royale.events.Event")]
	
	/**
	 * InfiniteVScroller dispatches an event when the component scrolls
	 * to the bottom to allow loading more content dynamically.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class InfiniteVScroller extends EventDispatcher implements IBead
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function InfiniteVScroller()
		{
			super();
		}
		
		protected var _strand:IStrand;
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		private function get host():IUIBase
		{
			return _strand as IUIBase;
		}
		
		private var _offset:Number = 0;

		/**
		 *  offset specifies how many pixels before the end to dispatch scrollEnd.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get offset():Number
		{
			return _offset;
		}

		public function set offset(value:Number):void
		{
			_offset = value;
		}

		private var _interval:int = 1000;

		/**
		 *  Minimum number of milliseconds between scrollEnd events.
		 *  default 1000
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get interval():int
		{
			return _interval;
		}

		public function set interval(value:int):void
		{
			_interval = value;
		}

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			COMPILE::JS
			{
				host.positioner.addEventListener("scroll", handleScroll);
			}
		}
		COMPILE::JS
		private var lastTime:Number = 0;
		
		COMPILE::JS
		private var lastTop:Number = 0;

		COMPILE::JS
		private function handleScroll(ev:Object):void
		{
			var elem:HTMLElement = host.positioner;
			// only handle down scrolling
			var top:Number = elem.scrollTop;
			if(top < lastTop) //scrolling up
			{
				lastTop = top;
				return;
			}
			lastTop = top;

			if(elem.offsetHeight + top >= elem.scrollHeight - _offset)
			{
				var time:Number = new Date().getTime();
				if(time - lastTime < _interval)
					return;
				lastTime = time;
				dispatchEvent(new Event("scrollEnd"));
			}
		}

	}
}
