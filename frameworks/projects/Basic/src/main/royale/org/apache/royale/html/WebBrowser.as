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
package org.apache.royale.html
{
	COMPILE::SWF
	{
		import flash.events.Event;
		import flash.html.HTMLLoader;
		import flash.net.URLRequest;
		import org.apache.royale.events.utils.IHandlesOriginalEvent;
	}
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
	}

	import org.apache.royale.core.UIBase
	import org.apache.royale.html.beads.models.WebBrowserModel;

	/**
	 * Dispatched whenever the WebBrowser's location has been changed.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="locationChanged", type="org.apache.royale.events.Event")]

	/**
	 * The WebBrowser provides a space in which to display a web page within
	 * a Royale application. Use the url property to change the location of
	 * the web page being displayed.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	COMPILE::SWF
	public class WebBrowser extends UIBase implements IHandlesOriginalEvent
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function WebBrowser()
		{
			super();
		}

		/**
		 * The location of the web page to display. Security restrictions may
		 * apply.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get url():String
		{
			return (model as WebBrowserModel).url;
		}

		public function set url(value:String):void
		{
			(model as WebBrowserModel).url = value;
		}
	}

	COMPILE::JS
	public class WebBrowser extends UIBase
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function WebBrowser()
		{
			super();
		}

		/**
		 * @royaleignorecoercion HTMLIFrameElement
		 */
		override protected function createElement():WrappedHTMLElement
		{
			var iframe:HTMLIFrameElement = addElementToWrapper(this,'iframe') as HTMLIFrameElement;
			iframe.frameBorder = "0";
			iframe.src = "JavaScript:''";
			iframe.sandbox = "allow-top-navigation allow-forms allow-scripts";
			return element;
		}
		
		/**
		 * The location of the web page to display. Security restrictions may
		 * apply.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
     *  @royaleignorecoercion org.apache.royale.html.beads.models.WebBrowserModel
		 */
		public function get url():String
		{
			return (model as WebBrowserModel).url;
		}
		/**
     *  @royaleignorecoercion org.apache.royale.html.beads.models.WebBrowserModel
		 */
		public function set url(value:String):void
		{
			(model as WebBrowserModel).url = value;
		}
	}
}
