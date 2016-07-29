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
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.system.ApplicationDomain;
    import flash.utils.getQualifiedClassName;
	}
	
    import org.apache.flex.events.Event;
    import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.events.MouseEvent;
    import org.apache.flex.events.utils.MouseEventConverter;
    import org.apache.flex.utils.MXMLDataInterpreter;
    
	/**
	 *  A SWF application must be bootstrapped by a Flash Sprite.
	 *  The factory class is the default bootstrap.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Frame(factoryClass="org.apache.flex.core.ApplicationFactory")]
	
    /**
     *  The SimpleApplication class can be used as the main class and entry point
     *  for low-level ActionScript-only FlexJS
     *  applications.  It is not indended for use in MXML applications or most
     *  of the FlexJS components as they expect a certain application lifecycle
     *  in the org.apache.flex.core.Application class.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public class SimpleApplication extends ApplicationBase
    {
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function SimpleApplication()
        {
            super();
		}
        
		COMPILE::SWF
        public function setRoot(r:Sprite):void
        {
			$sprite = r;
			start();
        }
        
        /**
         *  The entry point.  Override this and put all of your code in here.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function start():void
		{
		  COMPILE::JS
		  {
			  this.element = document.getElementsByTagName('body')[0];
			  this.element.flexjs_wrapper = this;
			  this.element.className = 'SimpleApplication';
		  }
		}
	}
}
