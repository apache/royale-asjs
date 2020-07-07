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
	import org.apache.royale.html.beads.models.WebBrowserModel;
	import org.apache.royale.html.beads.models.WebBrowserModel;
	import org.apache.royale.html.beads.models.WebBrowserModel;
	
	COMPILE::SWF {
		import flash.events.Event;
		import flash.html.HTMLLoader;
		import flash.net.URLRequest;
	}

	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.models.WebBrowserModel;

	/**
	 *  The WebBrowserView creates an instance of HTMLLoader to load
	 *  web pages into AIR application.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	COMPILE::SWF
	public class WebBrowserView implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function WebBrowserView()
		{
			loader = new HTMLLoader();
			loader.placeLoadStringContentInApplicationSandbox = false;

			loader.addEventListener(flash.events.LocationChangeEvent.LOCATION_CHANGE, handleLocationChange);
		}

		private var _strand:IStrand;

		private var loader:HTMLLoader;

		/**
		 * @private
		 */
		public function get host():IUIBase
		{
			return _strand as IUIBase;
		}

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			(host as UIBase).addEventListener("widthChanged", handleSizeChange);
			(host as UIBase).addEventListener("heightChanged", handleSizeChange);

			var model:IEventDispatcher = (host as UIBase).model as IEventDispatcher;
			model.addEventListener("urlChanged", loadPage);

			loader.x = 0;
			loader.y = 0;
			loader.width = host.width;
			loader.height = host.height;
			(host as UIBase).$sprite_addChild(loader);
			if (model is WebBrowserModel && WebBrowserModel(model).url != null) {
				loadPage(null);
			}
		}

		/**
		 * @private
		 */
		private function loadPage(event:org.apache.royale.events.Event):void
		{
			var model:WebBrowserModel = (host as UIBase).model as WebBrowserModel;
			loader.load(new URLRequest(model.url));
		}

		/**
		 * @private
		 */
		private function handleSizeChange(event:org.apache.royale.events.Event):void
		{
			loader.width = host.width;
			loader.height = host.height;
		}

		/**
		 * @private
		 */
		private function handleLocationChange(event:flash.events.LocationChangeEvent):void
		{
			var model:WebBrowserModel = (host as UIBase).model as WebBrowserModel;
			model.setURL(loader.location);
			host.dispatchEvent(new org.apache.royale.events.Event("locationChanged"));
		}
	}

	COMPILE::JS
	public class WebBrowserView implements IBeadView
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function WebBrowserView()
		{

		}

		private var _strand:IStrand;

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		public function get host():IUIBase
		{
			return _strand as IUIBase;
		}

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 *  @royaleignorecoercion HTMLIFrameElement
		 *  @royaleignorecoercion org.apache.royale.html.beads.models.WebBrowserModel
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			var model:IEventDispatcher = (host as UIBase).model as IEventDispatcher;
			model.addEventListener("urlChanged", loadPage);

			var iframe:HTMLIFrameElement = (host as UIBase).element as HTMLIFrameElement;
			iframe.addEventListener("load", handlePageShow, false);
			if (model is WebBrowserModel && WebBrowserModel(model).url != null) {
				loadPage(null);
			}
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 * @royaleignorecoercion org.apache.royale.html.beads.models.WebBrowserModel
		 * @royaleignorecoercion HTMLIFrameElement
		 */
		private function loadPage(event:Event):void
		{
			var model:WebBrowserModel = (host as UIBase).model as WebBrowserModel;

			var iframe:HTMLIFrameElement = (host as UIBase).element as HTMLIFrameElement;
			iframe.src = model.url;
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 * @royaleignorecoercion org.apache.royale.html.beads.models.WebBrowserModel
		 * @royaleignorecoercion HTMLIFrameElement
		 */
		private function handlePageShow(event:Event):void
		{
			var model:WebBrowserModel = (host as UIBase).model as WebBrowserModel;
			var iframe:HTMLIFrameElement = (host as UIBase).element as HTMLIFrameElement;

			model.setURL(iframe.src);
			host.dispatchEvent(new org.apache.royale.events.Event("locationChanged"));
		}
	}
}

