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
package org.apache.flex.core
{
COMPILE::SWF
{
    import flash.events.Event;
    import flash.external.ExternalInterface;
    import flash.utils.getQualifiedClassName;        
}

    /**
     *  The BrowserResizeListener class listens for browser
     *  resizing and resizes the application accordingly.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class BrowserResizeListener implements IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function BrowserResizeListener()
		{
		}
		
        private var app:IInitialViewApplication;
        
        /**
         *  Minimum height
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var minHeight:Number;
        
        /**
         *  Minimum width
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var minWidth:Number;
        
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function set strand(value:IStrand):void
        {
            app = value as IInitialViewApplication;
            COMPILE::SWF
            {
                app.$displayObject.stage.addEventListener("resize", resizeHandler);
                if (ExternalInterface.available && (!isNaN(minWidth) || !isNaN(minHeight)))
                {
                    // Get application name.  This assumes that the wrapper is using an
                    // object tag with the id that matches the application name
                    var appName:String = getQualifiedClassName(app);
                    var js:String = "var o = document.getElementById('" + appName + "');";
                    if (!isNaN(minWidth))
                        js += "o.style.minWidth = '" + minWidth + "px';";
                    if (!isNaN(minHeight))
                        js += "o.style.minHeight = '" + minHeight + "px';"
                    ExternalInterface.call("eval", js); 
                }                    
            }
            COMPILE::JS
            {
                window.addEventListener('resize',
                    this.resizeHandler, false);
                if (!isNaN(this.minWidth))
                    document.body.style.minWidth = this.minWidth + 'px';
                if (!isNaN(this.minHeight))
                    document.body.style.minHeight = this.minHeight + 'px';
                document.body.style.overflow = 'auto';
            }
        }
        
        private function resizeHandler(event:Event):void
        {
            COMPILE::SWF
            {
                var initialView:UIBase = app.initialView as UIBase;
				var constrainedWidth:Number = Math.max(isNaN(minWidth) ? 0 : minWidth, app.$displayObject.stage.stageWidth);
				var constrainedHeight:Number = Math.max(isNaN(minHeight) ? 0 : minHeight, app.$displayObject.stage.stageHeight);
                if (!isNaN(initialView.percentWidth) && !isNaN(initialView.percentHeight))
                    initialView.setWidthAndHeight(constrainedWidth, constrainedHeight, true);
                else if (!isNaN(initialView.percentWidth))
                    initialView.setWidth(constrainedWidth);
                else if (!isNaN(initialView.percentHeight))
                    initialView.setHeight(constrainedHeight);
            }
            COMPILE::JS
            {
                var initialView:UIBase = app.initialView as UIBase;
                var element:HTMLElement = app.element;
                if (!isNaN(initialView.percentWidth) || !isNaN(initialView.percentHeight)) {
                    element.style.height = window.innerHeight + 'px';
                    element.style.width = window.innerWidth + 'px';
                    initialView.dispatchEvent('sizeChanged'); // kick off layout if % sizes
                }
            }
        }

	}
}
