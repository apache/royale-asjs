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
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.geom.Point;
	import org.apache.royale.events.Event;
	
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
        import org.apache.royale.core.WrappedHTMLElement;            
    }
    
    /**
     *  The SubAppLoader class can load Flash or HTML content into a space within an application. 
	 *  Use SubAppLoader to identify where the application should appear, then use its loadApplication() 
	 *  function to load the application dynamically.
	 * 
     *  @toplevel
     *  @see org.apache.royale.html.beads.layout
     *  @see org.apache.royale.html.supportClasses.ScrollingViewport
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */    
	public class SubAppLoader extends UIBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function SubAppLoader()
		{
			super();
		}
		
		COMPILE::SWF
		private var swfLoader:Loader;
		
		COMPILE::JS
		private var htmlLoader:WrappedHTMLElement;
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		private function createLoader():void
		{
			COMPILE::SWF {				
				if (swfLoader != null) {
					removeChild(swfLoader);
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
         *  @productversion Royale 0.0
		 */
		public function loadApplication(swfURL:String, htmlURL:String):void
		{
			createLoader();
			
			COMPILE::SWF {
				var url:URLRequest = new URLRequest(swfURL);
				var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
				swfLoader.load(url, loaderContext);
				if (swfLoader.parent == null) {
					addChild(swfLoader);
				}
			}
				
			COMPILE::JS {
				htmlLoader.setAttribute("src", htmlURL);
			}
		}
	}
}
