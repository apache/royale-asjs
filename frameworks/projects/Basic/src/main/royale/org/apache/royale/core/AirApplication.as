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
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;

    //--------------------------------------
    //  Events
    //--------------------------------------

    /**
     *  Dispatched at startup. Attributes and sub-instances of
     *  the MXML document have been created and assigned.
     *  The component lifecycle is different
     *  than the Flex SDK.  There is no creationComplete event.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="initialize", type="org.apache.royale.events.Event")]

    /**
     *  Dispatched at startup before the instances get created.
     *  Beads can call preventDefault and defer initialization.
     *  This event will be dispatched on every frame until no
     *  listeners call preventDefault(), then the initialize()
     *  method will be called.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="preinitialize", type="org.apache.royale.events.Event")]

    /**
     *  Dispatched at startup after the initial view has been
     *  put on the display list. This event is sent before
     *  applicationComplete is dispatched.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="viewChanged", type="org.apache.royale.events.Event")]

    /**
     *  Dispatched at startup after the initial view has been
     *  put on the display list.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="applicationComplete", type="org.apache.royale.events.Event")]
    
    /**
     *  The AirApplication class should be used by Air applications as their
	 *  main entry point.
     *
     *  @see Application
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class AirApplication extends Application
    {
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function AirApplication()
        {
			COMPILE::SWF {
				addEventListener("preinitialize", handlePreInitialize);
			}
				
            super();
        }
		
		COMPILE::SWF
		private function handlePreInitialize(event:org.apache.royale.events.Event):void
		{
			event.preventDefault();
			removeEventListener("preinitialize", handlePreInitialize);
		}

    }
}
