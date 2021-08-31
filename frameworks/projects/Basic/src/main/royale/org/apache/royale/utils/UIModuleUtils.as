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
package org.apache.royale.utils
{
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IUIBase;
	
	COMPILE::SWF
	{
		import flash.display.DisplayObjectContainer;
		import flash.display.Loader;
		import flash.events.Event;
		import flash.net.URLRequest;
		import flash.system.ApplicationDomain;
		import flash.system.LoaderContext;
	}
	
    COMPILE::JS
    {
        import goog.DEBUG;
        import goog.global;

        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.events.Event;
        import org.apache.royale.geom.Point;
        import org.apache.royale.utils.PointUtils;
    }
    
    /**
     *  The UIModuleUtils class can load a UIModule. 
	 * 
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */    
	public class UIModuleUtils
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function UIModuleUtils()
		{
			super();
		}
		
        private var _modulePath:String;
        
        /**
         *  Path or URL of module.  This is combined
         *  with the module name and a platform suffix
         *  to determine the actual path or URL of the
         *  module.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get modulePath():String
        {
            return _modulePath;
        }
        
        /**
         *  @private.
         */
        public function set modulePath(value:String):void
        {
            _modulePath = value;
        }
        
        private var _moduleName:String;
        
        public function get moduleName():String
        {
            return _moduleName;
        }
        
        public function set moduleName(value:String):void
        {
            _moduleName = value;
        }
        
		COMPILE::SWF
		public var swfLoader:Loader;
		
		COMPILE::JS
        /**
         * @royalesuppresspublicvarwarning
         */
		public var jsLoader:WrappedHTMLElement;

        COMPILE::JS
        private var jsDepsLoader:WrappedHTMLElement;
                
        COMPILE::JS
        private var jsCSSLoader:HTMLLinkElement;
        
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		private function createLoader():void
		{
			COMPILE::SWF {				
				if (swfLoader != null) {
                    swfLoader.contentLoaderInfo.removeEventListener("complete", completeHandler);
				}
				
				swfLoader = new Loader();
                swfLoader.contentLoaderInfo.addEventListener("complete", completeHandler);
			}
				
			COMPILE::JS {
				var origin:Point = new Point(0,0);
				var xlated:Point = PointUtils.localToGlobal(origin, host.parent);
				
                if (goog.DEBUG)
                {
                    jsDepsLoader = document.createElement('script') as WrappedHTMLElement;
                    jsDepsLoader.onload = loadDepsHandler;
                    document.body.appendChild(jsDepsLoader);
                }
                else
                {
					jsLoader = document.createElement('script') as WrappedHTMLElement;
                    jsLoader.onload = loadHandler;
					document.body.appendChild(jsLoader);
                }
                
                jsCSSLoader = document.createElement('link') as HTMLLinkElement;
                jsCSSLoader.onload = actuallyLoadModule;
                document.head.appendChild(jsCSSLoader);
			}
		}
        
        private var host:IParentIUIBase;
		
		/**
         *  Load the module.  Will be called automatically if modulePath
         *  is set as the UIModuleLoader is added to the display list.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 */
		public function loadModule(host:IParentIUIBase):void
		{
            this.host = host;
            
            if (moduleInstance && moduleInstance.parent == host)
                host.removeElement(moduleInstance);
            
			createLoader();
			
			COMPILE::SWF {
				var url:URLRequest = new URLRequest(modulePath ? modulePath + "/" + moduleName + ".swf" :
                                                    moduleName + ".swf");
				var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
				swfLoader.load(url, loaderContext);
				if (swfLoader.parent == null) {
					(host as DisplayObjectContainer).addChild(swfLoader);
				}
			}
			COMPILE::JS {
                var suffix:String = ".min.css";
                if (goog.DEBUG)
                    suffix = ".css";
                loadCSS(modulePath ? modulePath + "/" + moduleName + suffix :
                    moduleName + suffix);
            }
        }
        
        COMPILE::JS
        protected function loadCSS(href:String):void
        {
            jsCSSLoader.id = href;
            jsCSSLoader.rel = "stylesheet";
            jsCSSLoader.type = "text/css";
            jsCSSLoader.media = "all";
            jsCSSLoader.href = href;
        }
        
        COMPILE::JS
        protected function actuallyLoadModule():void
        {
            if (!goog.DEBUG)
	   			jsLoader.setAttribute("src", modulePath ? modulePath + "/" + moduleName + ".js" :
                    moduleName + ".js");
            else
            {
                // js-debug module loading requires that the __deps.js file has been tweaked
                // so that the path to the module class is correct and that any
                // framework js files have been copied into the same tree structure as
                // the main apps framework js files
                window["goog"]["ENABLE_CHROME_APP_SAFE_SCRIPT_LOADING"] = true;
                jsDepsLoader.setAttribute("src", modulePath ? modulePath + "/" + moduleName + "__deps.js" :
                    moduleName + "__deps.js");
            }
		}
        
        public var moduleInstance:IUIBase;
        
        COMPILE::SWF
        protected function completeHandler(event:flash.events.Event):void
        {
            var c:Class = ApplicationDomain.currentDomain.getDefinition(moduleName) as Class;
            moduleInstance = new c() as IUIBase;
            host.addElement(moduleInstance);
        }
        
        COMPILE::JS
        protected function loadDepsHandler():void
        {
            // wait for other scripts to load
            if (window[moduleName] == null)
            {
                setTimeout(loadDepsHandler, 250);
            }
            else
                loadHandler();
                
        }
        /**
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
         */
        COMPILE::JS
        protected function loadHandler():void
        {
            var c:Class = window[moduleName];
            moduleInstance = new c() as IUIBase;
            host.addElement(moduleInstance);
        }
	}
}
