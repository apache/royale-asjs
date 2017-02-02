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
package org.apache.flex.html
{
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.utils.PointUtils;
	import org.apache.flex.geom.Point;
	import org.apache.flex.events.Event;
	
	COMPILE::SWF
	{
		import flash.display.Loader;
		import flash.display.DisplayObjectContainer;
		import flash.system.LoaderContext;
		import flash.system.ApplicationDomain;
		import flash.net.URLRequest;
		import flash.events.Event;
	}
	
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;            
    }
    
    /**
     *  The Module class can load Flash or HTML content into a space within an application. Use Module to
	 *  identify where the application should appear, then use its loadContent() function to load the
	 *  application dynamically.
	 * 
     *  @toplevel
     *  @see org.apache.flex.html.beads.layout
     *  @see org.apache.flex.html.supportClasses.ScrollingViewport
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */    
	public class Module extends UIBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function Module()
		{
			super();
		}
		
		COMPILE::SWF
		private var swfLoader:Loader;
		
		COMPILE::JS
		private var htmlLoader:WrappedHTMLElement;
		
		/**
		 * @private
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		private function createLoader():void
		{
			COMPILE::SWF {				
				if (swfLoader != null) {
					$displayObjectContainer.removeChild(swfLoader);
				}
				
				swfLoader = new Loader();
				swfLoader.x = 0;
				swfLoader.y = 0;
			}
				
			COMPILE::JS {
				var origin:Point = new Point(0,0);
				var xlated:Point = PointUtils.localToGlobal(origin, parent);
				
				if (htmlLoader == null) {
					htmlLoader = document.createElement('iframe') as WrappedHTMLElement;
					htmlLoader["width"] = String(this.width);
					htmlLoader["height"] = String(this.height);
					htmlLoader.style.position = "absolute";
					htmlLoader.style.left = String(xlated.x) + "px";
					htmlLoader.style.top = String(xlated.y) + "px";
					htmlLoader.style.backgroundColor = String("white");
					htmlLoader.style.border = "none";
					document.body.appendChild(htmlLoader);
				}
			}
		}
		
		/**
		 * Specifies the URL to load, depending on the runtime platform. Pass null for
		 * whichever URL is not being used.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
		 */
		public function loadContent(swfURL:String, htmlURL:String):void
		{
			createLoader();
			
			COMPILE::SWF {
				var url:URLRequest = new URLRequest(swfURL);
				var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
				swfLoader.load(url, loaderContext);
				if (swfLoader.parent == null) {
					$displayObjectContainer.addChild(swfLoader);
				}
			}
				
			COMPILE::JS {
				htmlLoader.setAttribute("src", htmlURL);
			}
		}
	}
}
