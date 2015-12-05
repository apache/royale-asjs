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
package org.apache.flex.createjs
{	
    import org.apache.flex.core.ApplicationBase;
    import org.apache.flex.core.IBead;
    import org.apache.flex.core.IFlexInfo;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.core.IUIBase;
    import org.apache.flex.core.IValuesImpl;
    import org.apache.flex.core.ValuesManager;
    import org.apache.flex.createjs.core.ViewBase;
    import org.apache.flex.events.Event;
    import org.apache.flex.utils.MXMLDataInterpreter;
	
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
        import createjs.DisplayObject;
        import createjs.Stage;
    }
    
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched at startup.
	 */
	[Event(name="initialize", type="org.apache.flex.events.Event")]
	
    /**
     * FalconJX will inject html into the index.html file.  Surround with
     * "inject_html" tag as follows:
     *
     * <inject_html>
     * <script src="https://code.createjs.com/easeljs-0.8.1.min.js"></script>
     * </inject_html>
     */
	public class Application extends org.apache.flex.core.Application implements IStrand, IFlexInfo
	{
		public function Application()
		{
			super();
		}
        
        COMPILE::JS
        private var stage:Stage;
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLBodyElement
         * @flexjsignorecoercion HTMLCanvasElement
         */
        COMPILE::JS
		override public function start():void
        {
            var body:HTMLBodyElement;
            var canvas:HTMLCanvasElement;
            
            // For createjs, the application is the same as the canvas
            // and it provides convenient access to the stage.
            
            element = document.createElement('canvas') as WrappedHTMLElement;
            canvas = element as HTMLCanvasElement;
            canvas.id = 'flexjsCanvas';
            canvas.width = 700;
            canvas.height = 500;
            
            body = document.getElementsByTagName('body')[0] as HTMLBodyElement;
            body.appendChild(this.element);
            
            stage = new createjs.Stage('flexjsCanvas');

            /* AJH is this needed
            MXMLDataInterpreter.generateMXMLProperties(this,
                MXMLProperties);
            */
            
            dispatchEvent('initialize');
            
            initialView.applicationModel = this.model;
            addElement(initialView);
            
            dispatchEvent('viewChanged');
        }
        
        /**
         * @flexjsignorecoercion createjs.DisplayObject
         */
        COMPILE::JS
        override public function addElement(c:Object, dispatchEvent:Boolean = true):void
        {
            stage.addChild(c as DisplayObject);
            c.addedToParent();
        }
	}
}
