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
	import org.apache.flex.events.Event;

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
     *  @productversion FlexJS 0.0
     */
	[Event(name="initComplete", type="org.apache.flex.events.Event")]
    
	[DefaultProperty("mxmlContent")]
    
    /**
     *  The ViewBase class is the base class for most views in a FlexJS
     *  application.  It is generally used as the root tag of MXML
     *  documents and UI controls and containers are added to it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class ViewBase extends ContainerBase implements IPopUpHost
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ViewBase()
		{
			super();
			
			className = "flexjs";
		}
		
		private var _applicationModel:Object;
		
		[Bindable("modelChanged")]
        
        /**
         *  A reference to the Application's model.  Usually,
         *  a view is displaying the main model for an
         *  application.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get applicationModel():Object
		{
			return _applicationModel;
		}
        
        /**
         *  @private
         */
        public function set applicationModel(value:Object):void
        {
            _applicationModel = value;
            dispatchEvent(new Event("modelChanged"));
        }

    }
}