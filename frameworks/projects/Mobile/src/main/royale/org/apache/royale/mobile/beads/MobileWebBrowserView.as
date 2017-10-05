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
package org.apache.royale.mobile.beads
{
	COMPILE::SWF {
		import flash.events.Event;
		import flash.media.StageWebView;
		import flash.geom.Rectangle;
		import flash.geom.Point;
	}

	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStrandWithModel;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.models.WebBrowserModel;
	
	COMPILE::JS {
		import org.apache.royale.html.beads.WebBrowserView;
	}

	/**
	 *  The MobileWebBrowserView creates an instance of StageWebView to load
	 *  web pages into a mobile application. This class is available only
	 *  for AS3 compiled mode. Note that StageWebView is attached directly to
	 *  the stage and may obscure other components.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	COMPILE::SWF
	public class MobileWebBrowserView implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function MobileWebBrowserView()
		{
			stageWebView = new StageWebView();

			stageWebView.addEventListener(flash.events.Event.COMPLETE, handleLocationChange);
		}

		private var _strand:IStrand;

		private var stageWebView:StageWebView;

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

			host.addEventListener("widthChanged", handleSizeChange);
			host.addEventListener("heightChanged", handleSizeChange);

			var model:IEventDispatcher = (host as IStrandWithModel).model as IEventDispatcher;
			model.addEventListener("urlChanged", loadPage);

			stageWebView.stage = host.$displayObject.stage;
			
			var hostOrigin:Point = new Point(0,0);
			var hostPosition:Point = host.$displayObject.localToGlobal(hostOrigin);
			stageWebView.viewPort = new Rectangle( hostPosition.x, hostPosition.y, host.width, host.height );
		}

		/**
		 * @private
		 */
		private function loadPage(event:org.apache.royale.events.Event):void
		{
			var model:WebBrowserModel = (host as IStrandWithModel).model as WebBrowserModel;
			stageWebView.loadURL(model.url);
		}

		/**
		 * @private
		 */
		private function handleSizeChange(event:org.apache.royale.events.Event):void
		{
			var hostOrigin:Point = new Point(0,0);
			var hostPosition:Point = host.$displayObject.localToGlobal(hostOrigin);
			stageWebView.viewPort = new Rectangle( hostPosition.x, hostPosition.y, host.width, host.height );
		}

		/**
		 * @private
		 */
		private function handleLocationChange(event:flash.events.Event):void
		{
			var model:WebBrowserModel = (host as IStrandWithModel).model as WebBrowserModel;
			model.setURL(stageWebView.location);
			host.dispatchEvent(new org.apache.royale.events.Event("locationChanged"));
		}
	}
	
	COMPILE::JS
	public class MobileWebBrowserView extends WebBrowserView
	{
		// does nothing but provide a placeholder so JavaScript version
		// builds and runs
	}
}

