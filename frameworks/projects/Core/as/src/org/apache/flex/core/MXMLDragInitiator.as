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
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
    import org.apache.flex.events.EventDispatcher;
    
    /**
     *  Indicates that acceptingDrop API has been called.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="acceptingDrop", type="org.apache.flex.events.Event")]
    
    /**
     *  Indicates that acceptedDrop API has been called.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="acceptedDrop", type="org.apache.flex.events.Event")]

    /**
     *  The MXMLDragInitiator is an IDragInitiator that
     *  dispatches events when the IDragInitiator methods
     *  are called to make it easier to handle in MXML.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::AS3
	public class MXMLDragInitiator extends EventDispatcher implements IBead, IDragInitiator
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function MXMLDragInitiator()
		{
			super();
		}
		
        private var _strand:IStrand;
        /**
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
        }
        
        /**
         *  The dropTarget
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var dropTarget:Object;

        /**
         *  The DropType
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var dropType:String;
        
        /**
         *  Handles the acceptingDrop API
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function acceptingDrop(dropTarget:Object, type:String):void
        {
            dispatchEvent(new Event("acceptingDrop"));
        }
        
        /**
         *  Handles the acceptedDrop API
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function acceptedDrop(dropTarget:Object, type:String):void
        {
            dispatchEvent(new Event("acceptedDrop"));
        }

   }
}
