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
        import flash.events.Event;
		import flash.system.LoaderContext;
		import flash.system.ApplicationDomain;
		import flash.net.URLRequest;
	}
	
    COMPILE::JS
    {
        import goog.global;
        import org.apache.flex.core.WrappedHTMLElement;   
    }
    
    /**
     *  The UIModuleLoader class can load a UIModule. 
	 * 
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */    
	public class UIModuleLoader extends UIBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function UIModuleLoader()
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
         *  @productversion FlexJS 0.0
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
		private var swfLoader:Loader;
		
		COMPILE::JS
		private var jsLoader:WrappedHTMLElement;

        COMPILE::JS
        private var jsDepsLoader:WrappedHTMLElement;
        
        override public function addedToParent():void
        {
            super.addedToParent();
            if (_modulePath)
                loadModule();
        }
        
		/**
		 * @private
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
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
				var xlated:Point = PointUtils.localToGlobal(origin, parent);
				
                if (goog.DEBUG)
                {
                    if (jsDepsLoader == null) {
                        jsDepsLoader = document.createElement('script') as WrappedHTMLElement;
                        jsDepsLoader.onload = loadDepsHandler;
                        document.body.appendChild(jsDepsLoader);
                    }                    
                }
                else
                {
    				if (jsLoader == null) {
    					jsLoader = document.createElement('script') as WrappedHTMLElement;
                        jsLoader.onload = loadHandler;
    					document.body.appendChild(jsLoader);
    				}
                }
			}
		}
		
		/**
         *  Load the module.  Will be called automatically if modulePath
         *  is set as the UIModuleLoader is added to the display list.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
		 */
		public function loadModule():void
		{
            if (moduleInstance)
                removeElement(moduleInstance);
            
			createLoader();
			
			COMPILE::SWF {
				var url:URLRequest = new URLRequest(modulePath ? modulePath + "/" + moduleName + ".swf" :
                                                    moduleName + ".swf");
				var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
				swfLoader.load(url, loaderContext);
				if (swfLoader.parent == null) {
					addChild(swfLoader);
				}
			}
				
			COMPILE::JS {
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
		}
        
        private var moduleInstance:IUIBase;
        
        COMPILE::SWF
        protected function completeHandler(event:flash.events.Event):void
        {
            var c:Class = ApplicationDomain.currentDomain.getDefinition(moduleName) as Class;
            moduleInstance = new c() as IUIBase;
            addElement(moduleInstance);
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
        
        COMPILE::JS
        protected function loadHandler():void
        {
            var c:Class = window[moduleName];
            moduleInstance = new c() as IUIBase;
            addElement(moduleInstance);
        }
	}
}
