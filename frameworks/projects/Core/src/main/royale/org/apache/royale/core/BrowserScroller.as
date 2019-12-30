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
package org.apache.royale.core
{
    COMPILE::SWF
    {        
        import flash.external.ExternalInterface;
        import flash.utils.getQualifiedClassName;
    }    

    COMPILE::JS
    {
        import org.apache.royale.utils.html.getStyle;
    }

    import org.apache.royale.events.Event;
    
    /**
     *  The BrowserScroller class enables browser scrollbars
     *  when the application is larger than the screen.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class BrowserScroller implements IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function BrowserScroller()
		{
		}
		
        private var app:IInitialViewApplication;
        
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
            app = value as IInitialViewApplication;
            app.addEventListener("viewChanged", viewChangedHandler);
        }
        
        /**
         * @royaleignorecoercion org.apache.royale.core.ElementWrapper
         */
        private function viewChangedHandler(event:Event):void
        {
            COMPILE::SWF
            {
                if (ExternalInterface.available)
                {
                    // Get application name.  This assumes that the wrapper is using an
                    // object tag with the id that matches the application name
                    var appName:String = getQualifiedClassName(app);
                    var js:String = "var o = document.getElementById('" + appName + "');";
                    js += "o.width = " + app.initialView.width.toString() + ";";
                    js += "o.height = " + app.initialView.height.toString() + ";"
                    ExternalInterface.call("eval", js); 
                }                    
            }
            COMPILE::JS
            {
                getStyle(app as ElementWrapper).overflow = 'auto';
            }
        }

	}
}
