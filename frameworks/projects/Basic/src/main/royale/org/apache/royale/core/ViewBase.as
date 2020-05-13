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
	import org.apache.royale.utils.sendEvent;

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
	[Event(name="initComplete", type="org.apache.royale.events.Event")]

	[DefaultProperty("mxmlContent")]

    /**
     *  The ViewBase class is the base class for most views in a Royale
     *  application.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ViewBase extends GroupBase implements IPopUpHost, IPopUpHostParent, IApplicationView
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ViewBase()
		{
			super();

			typeNames = "royale";
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
         *  @productversion Royale 0.0
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
            sendEvent(this,"modelChanged");
        }

        /**
         *  ViewBase can host popups but they will be in the layout, if any
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get popUpParent():IPopUpHostParent
        {
            return this;
        }
        
        /**
         */
        public function get popUpHost():IPopUpHost
        {
            return this;
        }

    }
}
